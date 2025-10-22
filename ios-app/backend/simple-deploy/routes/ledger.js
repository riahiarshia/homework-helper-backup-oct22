const express = require('express');
const router = express.Router();
const { Pool } = require('pg');

// Database connection
const pool = new Pool({
    connectionString: process.env.DATABASE_URL,
    ssl: process.env.NODE_ENV === 'production' ? { rejectUnauthorized: false } : false
});

/**
 * GET /api/ledger/debug
 * Debug endpoint to check database connection
 */
router.get('/debug', async (req, res) => {
    try {
        res.json({
            success: true,
            pool_defined: !!pool,
            database_url_defined: !!process.env.DATABASE_URL,
            node_env: process.env.NODE_ENV,
            timestamp: new Date().toISOString()
        });
    } catch (error) {
        console.error('❌ Debug endpoint error:', error);
        res.status(500).json({
            success: false,
            error: error.message
        });
    }
});

/**
 * GET /api/ledger/public-stats
 * Public endpoint for basic ledger statistics (no auth required)
 * Used for monitoring and health checks
 */
router.get('/public-stats', async (req, res) => {
    try {
        const stats = await pool.query(`
            SELECT 
                COUNT(*) as total_records,
                COUNT(*) FILTER (WHERE ever_trial = true) as trial_count,
                COUNT(*) FILTER (WHERE status = 'active') as active_count,
                COUNT(*) FILTER (WHERE status = 'expired') as expired_count,
                COUNT(*) FILTER (WHERE status = 'canceled') as canceled_count,
                MIN(first_seen_at) as oldest_record,
                MAX(last_seen_at) as newest_record
            FROM entitlements_ledger
        `);

        res.json({
            success: true,
            ledger: stats.rows[0],
            timestamp: new Date().toISOString(),
            note: "Public stats - no PII exposed"
        });
    } catch (error) {
        console.error('❌ Error getting public ledger stats:', error);
        res.status(500).json({
            success: false,
            error: 'Failed to get ledger stats: ' + error.message
        });
    }
});

/**
 * GET /api/ledger/health
 * Simple health check for ledger system
 */
router.get('/health', async (req, res) => {
    try {

        const result = await pool.query('SELECT COUNT(*) as count FROM entitlements_ledger');
        res.json({
            success: true,
            status: 'healthy',
            record_count: result.rows[0].count,
            timestamp: new Date().toISOString()
        });
    } catch (error) {
        console.error('❌ Ledger health check failed:', error);
        res.status(500).json({
            success: false,
            status: 'unhealthy',
            error: error.message,
            timestamp: new Date().toISOString()
        });
    }
});

/**
 * GET /api/ledger/system-info
 * Public endpoint for system information (no auth required)
 * Used for debugging and monitoring
 */
router.get('/system-info', async (req, res) => {
    try {

        const [userCount, subscriptionCount, ledgerCount] = await Promise.all([
            pool.query('SELECT COUNT(*) as count FROM users'),
            pool.query('SELECT COUNT(*) as count FROM subscription_history'),
            pool.query('SELECT COUNT(*) as count FROM entitlements_ledger')
        ]);

        res.json({
            success: true,
            system: {
                users: userCount.rows[0].count,
                subscriptions: subscriptionCount.rows[0].count,
                ledger_records: ledgerCount.rows[0].count
            },
            timestamp: new Date().toISOString(),
            note: "Public system info - no PII exposed"
        });
    } catch (error) {
        console.error('❌ Error getting system info:', error);
        res.status(500).json({
            success: false,
            error: 'Failed to get system info'
        });
    }
});

/**
 * GET /api/ledger/create-test-data
 * Create fake entitlements for testing (no auth required)
 * This creates test ledger entries to verify the admin portal functionality
 */
router.get('/create-test-data', async (req, res) => {
    try {
        const { upsertLedgerRecord } = require('../services/entitlementsLedgerService');
        
        // Create test ledger entries
        const testEntries = [
            {
                originalTransactionId: 'test_tx_001_monthly',
                productId: 'com.homeworkhelper.monthly',
                subscriptionGroupId: 'homework_helper_subscriptions',
                status: 'active',
                everTrial: false
            },
            {
                originalTransactionId: 'test_tx_002_yearly',
                productId: 'com.homeworkhelper.yearly',
                subscriptionGroupId: 'homework_helper_subscriptions',
                status: 'active',
                everTrial: true
            },
            {
                originalTransactionId: 'test_tx_003_trial',
                productId: 'com.homeworkhelper.monthly',
                subscriptionGroupId: 'homework_helper_subscriptions',
                status: 'expired',
                everTrial: true
            },
            {
                originalTransactionId: 'test_tx_004_canceled',
                productId: 'com.homeworkhelper.yearly',
                subscriptionGroupId: 'homework_helper_subscriptions',
                status: 'canceled',
                everTrial: false
            }
        ];

        const results = [];
        for (const entry of testEntries) {
            try {
                const result = await upsertLedgerRecord(entry);
                results.push({
                    success: true,
                    entry: entry,
                    hash: result.original_transaction_id_hash
                });
            } catch (error) {
                results.push({
                    success: false,
                    entry: entry,
                    error: error.message
                });
            }
        }

        res.json({
            success: true,
            message: 'Test ledger data created',
            results: results,
            timestamp: new Date().toISOString(),
            note: 'This creates fake transaction data for testing the admin portal'
        });
    } catch (error) {
        console.error('❌ Error creating test data:', error);
        res.status(500).json({
            success: false,
            error: 'Failed to create test data: ' + error.message
        });
    }
});

module.exports = router;
