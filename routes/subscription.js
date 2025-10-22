const express = require('express');
const router = express.Router();
const { Pool } = require('pg');
const authenticateUser = require('../middleware/auth');
const { requireAdmin } = require('../middleware/adminAuth');
const { calculateSubscriptionStatus, updateSubscriptionPeriod } = require('../services/subscriptionService');
const { upsertLedgerRecord } = require('../services/entitlementsLedgerService');
const { txidHash } = require('../lib/txidHash');

// Database connection
const pool = new Pool({
    connectionString: process.env.DATABASE_URL,
    ssl: process.env.NODE_ENV === 'production' ? { rejectUnauthorized: false } : false
});

/**
 * POST /api/subscription/sync
 * Sync subscription status from iOS app to database
 */
router.post('/sync', authenticateUser, async (req, res) => {
    try {
        const { userId, subscriptionStatus, subscriptionEndDate } = req.body;
        
        if (!userId || !subscriptionStatus) {
            return res.status(400).json({ error: 'userId and subscriptionStatus required' });
        }
        
        // Update user subscription in database
        const query = `
            UPDATE users 
            SET subscription_status = $1,
                subscription_end_date = $2,
                last_active_at = NOW()
            WHERE user_id = $3
            RETURNING *
        `;
        
        const result = await pool.query(query, [
            subscriptionStatus,
            subscriptionEndDate || null,
            userId
        ]);
        
        if (result.rows.length === 0) {
            return res.status(404).json({ error: 'User not found' });
        }
        
        console.log(`✅ Subscription synced for user ${userId}: ${subscriptionStatus}`);
        
        res.json({
            success: true,
            subscription: {
                status: result.rows[0].subscription_status,
                endDate: result.rows[0].subscription_end_date
            }
        });
        
    } catch (error) {
        console.error('Subscription sync error:', error);
        res.status(500).json({ error: 'Failed to sync subscription' });
    }
});

/**
 * GET /api/subscription/status
 * Get current subscription status for authenticated user
 */
router.get('/status', authenticateUser, async (req, res) => {
    try {
        const userId = req.user.userId;
        
        // Use centralized service for subscription status
        const subscriptionData = await calculateSubscriptionStatus(userId);
        
        res.json({
            subscriptionStatus: subscriptionData.status,
            subscriptionEndDate: subscriptionData.endDate,
            daysRemaining: subscriptionData.daysRemaining
        });
        
    } catch (error) {
        console.error('Get subscription status error:', error);
        res.status(500).json({ error: 'Failed to get subscription status' });
    }
});

/**
 * POST /api/subscription/admin/extend-trial
 * Admin endpoint to extend or reduce trial period for a user
 * Requires admin authentication
 */
router.post('/admin/extend-trial', requireAdmin, async (req, res) => {
    try {
        const { userId, days } = req.body;
        
        console.log(`🔧 Extend trial request: userId=${userId}, days=${days}`);
        console.log(`🔧 Admin user: ${req.admin.username} (${req.admin.email})`);
        
        if (!userId || !days) {
            return res.status(400).json({ error: 'userId and days required' });
        }
        
        console.log(`✅ Admin authentication verified`);
        
        // Use centralized service to update subscription period
        const updatedSubscription = await updateSubscriptionPeriod(userId, days);
        
        res.json({
            success: true,
            message: `Trial period ${days > 0 ? 'extended' : 'reduced'} by ${Math.abs(days)} days`,
            subscription: {
                status: updatedSubscription.status,
                endDate: updatedSubscription.endDate,
                daysRemaining: updatedSubscription.daysRemaining
            }
        });
        
    } catch (error) {
        console.error('Extend trial error:', error);
        res.status(500).json({ error: 'Failed to extend trial' });
    }
});

/**
 * POST /api/subscription/admin/set-trial-days
 * Admin endpoint to set default trial days for new users
 */
router.post('/admin/set-trial-days', async (req, res) => {
    try {
        const { days, adminToken } = req.body;
        
        if (!days || !adminToken) {
            return res.status(400).json({ error: 'days and adminToken required' });
        }
        
        // Verify admin token
        const adminSecret = process.env.ADMIN_SECRET || 'change-this-in-production';
        if (adminToken !== adminSecret) {
            return res.status(403).json({ error: 'Invalid admin token' });
        }
        
        // Store in environment or database (for now, just return success)
        // In production, you'd store this in a settings table
        
        console.log(`✅ Default trial period set to ${days} days`);
        
        res.json({
            success: true,
            message: `Default trial period set to ${days} days`,
            trialDays: days
        });
        
    } catch (error) {
        console.error('Set trial days error:', error);
        res.status(500).json({ error: 'Failed to set trial days' });
    }
});

/**
 * POST /api/subscription/apple/validate-receipt
 * Validate Apple receipt and update subscription status
 * Industry best practice: Always validate receipts server-side
 */
router.post('/apple/validate-receipt', authenticateUser, async (req, res) => {
    try {
        const { receipt, transactionId } = req.body;
        const userId = req.user.userId;
        
        if (!receipt) {
            return res.status(400).json({ error: 'Receipt data required' });
        }
        
        console.log(`🍎 Validating Apple receipt for user ${userId}`);
        
        // Validate with Apple's servers
        const appleResponse = await validateAppleReceipt(receipt);
        
        if (appleResponse.status === 0) {
            // Receipt is valid!
            const latestReceiptInfo = appleResponse.latest_receipt_info[0];
            
            // Extract subscription data
            const expiresDate = new Date(parseInt(latestReceiptInfo.expires_date_ms));
            const productId = latestReceiptInfo.product_id;
            const originalTransactionId = latestReceiptInfo.original_transaction_id;
            const purchaseDate = new Date(parseInt(latestReceiptInfo.purchase_date_ms));
            
            // Detect trial usage (critical for anti-abuse)
            const isTrialPeriod = latestReceiptInfo.is_trial_period === 'true';
            const isIntroOfferPeriod = latestReceiptInfo.is_in_intro_offer_period === 'true';
            const hadTrial = isTrialPeriod || isIntroOfferPeriod;
            
            // Use the environment flag from validateAppleReceipt, or detect from receipt
            const environment = appleResponse.environment || 
                               (isTrialPeriod ? 'Sandbox' : 'Production');
            
            // Determine subscription status
            const subscriptionStatus = hadTrial ? 'trial' : 'active';
            
            // Update database with validated data
            await pool.query(`
                UPDATE users 
                SET subscription_status = $1,
                    subscription_end_date = $2,
                    subscription_start_date = $3,
                    apple_original_transaction_id = $4,
                    apple_product_id = $5,
                    apple_environment = $6,
                    last_active_at = NOW(),
                    updated_at = NOW()
                WHERE user_id = $7
            `, [subscriptionStatus, expiresDate, purchaseDate, originalTransactionId, productId, environment, userId]);
            
            // CRITICAL: Track trial usage in trial_usage_history table
            // This persists even if user deletes their account (fraud prevention)
            if (hadTrial) {
                await pool.query(`
                    INSERT INTO trial_usage_history (
                        original_transaction_id,
                        user_id,
                        apple_product_id,
                        had_intro_offer,
                        had_free_trial,
                        trial_start_date,
                        trial_end_date,
                        apple_environment
                    ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
                    ON CONFLICT (original_transaction_id) DO UPDATE SET
                        user_id = EXCLUDED.user_id,
                        updated_at = NOW()
                `, [
                    originalTransactionId,
                    userId,
                    productId,
                    isIntroOfferPeriod,
                    isTrialPeriod,
                    purchaseDate,
                    expiresDate,
                    environment
                ]);
                
                console.log(`🎁 Trial usage recorded for original_transaction_id: ${originalTransactionId}`);
                console.log(`   Trial Type: ${isTrialPeriod ? 'Free Trial' : 'Intro Offer'}`);
            }
            
            // ADDITIVE: Upsert to user_entitlements (user-linked, deleted with account)
            // TODO: Add subscription_group_id to product configuration
            const subscriptionGroupId = 'com.homeworkhelper.premium'; // Same group for all products
            const hash = txidHash(originalTransactionId, process.env.LEDGER_SALT);
            
            try {
                await pool.query(`
                    INSERT INTO user_entitlements (
                        user_id,
                        product_id,
                        subscription_group_id,
                        original_transaction_id,
                        original_transaction_id_hash,
                        is_trial,
                        status,
                        purchase_at,
                        expires_at
                    ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
                    ON CONFLICT (original_transaction_id_hash)
                    DO UPDATE SET
                        status = EXCLUDED.status,
                        expires_at = EXCLUDED.expires_at,
                        updated_at = NOW()
                    WHERE user_entitlements.original_transaction_id_hash = EXCLUDED.original_transaction_id_hash
                `, [
                    userId,
                    productId,
                    subscriptionGroupId,
                    originalTransactionId,
                    hash,
                    hadTrial,
                    subscriptionStatus,
                    purchaseDate,
                    expiresDate
                ]);
                
                console.log(`📝 User entitlement upserted: hash=${hash.substring(0, 16)}...`);
            } catch (entError) {
                // Don't fail the whole validation if entitlements upsert fails
                console.error(`⚠️ Failed to upsert user entitlement:`, entError.message);
            }
            
            // ADDITIVE: Upsert to entitlements_ledger (PII-free, persists after deletion)
            try {
                await upsertLedgerRecord({
                    originalTransactionId,
                    productId,
                    subscriptionGroupId,
                    status: subscriptionStatus === 'trial' ? 'active' : subscriptionStatus,
                    everTrial: hadTrial
                });
                
                console.log(`📊 Ledger record upserted (de-identified, fraud prevention)`);
            } catch (ledgerError) {
                // Don't fail the whole validation if ledger upsert fails
                console.error(`⚠️ Failed to upsert ledger record:`, ledgerError.message);
            }
            
            // Log successful validation
            await pool.query(`
                INSERT INTO subscription_history 
                (user_id, event_type, new_status, new_end_date, metadata)
                VALUES ($1, 'apple_receipt_validated', $2, $3, $4)
            `, [userId, subscriptionStatus, expiresDate, JSON.stringify({ 
                product_id: productId, 
                transaction_id: transactionId,
                environment: environment,
                original_transaction_id: originalTransactionId,
                is_trial_period: isTrialPeriod,
                is_intro_offer_period: isIntroOfferPeriod
            })]);
            
            console.log(`✅ Apple receipt validated for user ${userId}`);
            console.log(`   Environment: ${environment}`);
            console.log(`   Product ID: ${productId}`);
            console.log(`   Status: ${subscriptionStatus}`);
            console.log(`   Expires: ${expiresDate}`);
            console.log(`   Original Transaction ID: ${originalTransactionId}`);
            console.log(`   Is Trial: ${hadTrial}`);
            
            res.json({ 
                success: true, 
                subscriptionStatus: subscriptionStatus,
                expiresDate: expiresDate,
                productId: productId,
                environment: environment,
                isTrial: hadTrial,
                isTrialPeriod: isTrialPeriod,
                isIntroOfferPeriod: isIntroOfferPeriod
            });
            
        } else {
            console.log(`❌ Invalid Apple receipt for user ${userId}, status: ${appleResponse.status}`);
            res.status(400).json({ 
                error: 'Invalid receipt', 
                appleStatus: appleResponse.status,
                message: getAppleStatusMessage(appleResponse.status)
            });
        }
        
    } catch (error) {
        console.error('Apple receipt validation error:', error);
        res.status(500).json({ error: 'Failed to validate receipt' });
    }
});

/**
 * POST /api/subscription/apple/webhook
 * Handle Apple Server Notifications (App Store Server Notifications)
 * Industry best practice: Always respond quickly to Apple
 */
router.post('/apple/webhook', express.json({ limit: '1mb' }), async (req, res) => {
    try {
        const notification = req.body;
        
        // Validate webhook secret if provided
        const providedSecret = req.headers['x-apple-webhook-secret'] || req.headers['authorization']?.replace('Bearer ', '');
        const expectedSecret = process.env.APPLE_WEBHOOK_SECRET || 'homework-helper-webhook-secret-2024';
        
        if (providedSecret && providedSecret !== expectedSecret) {
            console.log('⚠️ Apple webhook secret mismatch');
            // Still return 200 to Apple (don't reveal validation failure)
            return res.status(200).json({ received: true });
        }
        
        console.log('🍎 Apple webhook received:', notification.notification_type || 'unknown');
        
        // IMMEDIATELY respond to Apple (they expect quick response)
        res.status(200).json({ received: true });
        
        // Process notification asynchronously
        processAppleNotification(notification).catch(err => {
            console.error('Error processing Apple notification:', err);
        });
        
    } catch (error) {
        console.error('Apple webhook error:', error);
        // Still return 200 to acknowledge receipt
        res.status(200).json({ received: true });
    }
});

/**
 * Process Apple Server Notification asynchronously
 */
async function processAppleNotification(notification) {
    try {
        console.log('🍎 Processing Apple notification:', notification.notification_type);
        
        const notificationType = notification.notification_type;
        const unifiedReceipt = notification.unified_receipt;
        const latestReceiptInfo = unifiedReceipt?.latest_receipt_info?.[0];
        
        if (!latestReceiptInfo) {
            console.log('⚠️ No receipt info in notification');
            return;
        }
        
        const originalTransactionId = latestReceiptInfo.original_transaction_id;
        const expiresDate = new Date(parseInt(latestReceiptInfo.expires_date_ms));
        const productId = latestReceiptInfo.product_id;
        const environment = latestReceiptInfo.is_trial_period === 'true' ? 'Sandbox' : 'Production';
        
        // Find user by original transaction ID
        const userResult = await pool.query(
            'SELECT user_id FROM users WHERE apple_original_transaction_id = $1',
            [originalTransactionId]
        );
        
        if (userResult.rows.length === 0) {
            console.log(`⚠️ User not found for Apple transaction ${originalTransactionId}`);
            return;
        }
        
        const userId = userResult.rows[0].user_id;
        
        // Handle different notification types
        switch(notificationType) {
            case 'INITIAL_BUY':
                await handleAppleInitialPurchase(userId, expiresDate, latestReceiptInfo);
                break;
                
            case 'DID_RENEW':
                await handleAppleRenewal(userId, expiresDate, latestReceiptInfo);
                break;
                
            case 'DID_FAIL_TO_RENEW':
                await handleApplePaymentFailed(userId, latestReceiptInfo);
                break;
                
            case 'DID_CHANGE_RENEWAL_STATUS':
                await handleAppleCancellation(userId, expiresDate, latestReceiptInfo);
                break;
                
            case 'REFUND':
                await handleAppleRefund(userId, latestReceiptInfo);
                break;
                
            case 'REVOKE':
                await handleAppleRevoke(userId, latestReceiptInfo);
                break;
                
            case 'PRICE_INCREASE_CONSENT':
                await handleApplePriceIncrease(userId, latestReceiptInfo);
                break;
                
            case 'DID_RECOVER':
                await handleAppleRecovery(userId, expiresDate, latestReceiptInfo);
                break;
                
            default:
                console.log(`ℹ️ Unhandled Apple notification: ${notificationType}`);
        }
        
    } catch (error) {
        console.error('Error processing Apple notification:', error);
    }
}

/**
 * Apple notification handlers
 */
async function handleAppleInitialPurchase(userId, expiresDate, receiptInfo) {
    await updateAppleSubscription(userId, 'active', expiresDate, receiptInfo);
    await logSubscriptionEvent(userId, 'apple_initial_purchase', 'active', expiresDate, receiptInfo);
    console.log(`✅ Apple initial purchase for user ${userId}`);
}

async function handleAppleRenewal(userId, expiresDate, receiptInfo) {
    await updateAppleSubscription(userId, 'active', expiresDate, receiptInfo);
    
    // Reset monthly usage on subscription renewal
    const usageTrackingService = require('../services/usageTrackingService');
    await usageTrackingService.resetMonthlyUsage(userId);
    
    await logSubscriptionEvent(userId, 'apple_subscription_renewed', 'active', expiresDate, receiptInfo);
    console.log(`✅ Apple subscription renewed for user ${userId} - monthly usage reset`);
}

async function handleApplePaymentFailed(userId, receiptInfo) {
    await updateAppleSubscription(userId, 'grace_period', null, receiptInfo);
    await logSubscriptionEvent(userId, 'apple_payment_failed', 'grace_period', null, receiptInfo);
    console.log(`⚠️ Apple payment failed for user ${userId} - grace period`);
}

async function handleAppleCancellation(userId, expiresDate, receiptInfo) {
    await updateAppleSubscription(userId, 'cancelled', expiresDate, receiptInfo);
    await logSubscriptionEvent(userId, 'apple_subscription_cancelled', 'cancelled', expiresDate, receiptInfo);
    console.log(`❌ Apple subscription cancelled for user ${userId}`);
}

async function handleAppleRefund(userId, receiptInfo) {
    await updateAppleSubscription(userId, 'expired', new Date(), receiptInfo);
    await logSubscriptionEvent(userId, 'apple_subscription_refunded', 'expired', new Date(), receiptInfo);
    console.log(`💰 Apple refund processed for user ${userId}`);
}

async function handleAppleRevoke(userId, receiptInfo) {
    await updateAppleSubscription(userId, 'expired', new Date(), receiptInfo);
    await logSubscriptionEvent(userId, 'apple_subscription_revoked', 'expired', new Date(), receiptInfo);
    console.log(`🚫 Apple subscription revoked for user ${userId}`);
}

async function handleApplePriceIncrease(userId, receiptInfo) {
    await logSubscriptionEvent(userId, 'apple_price_increase_consent', null, null, receiptInfo);
    console.log(`📈 Apple price increase consented for user ${userId}`);
}

async function handleAppleRecovery(userId, expiresDate, receiptInfo) {
    await updateAppleSubscription(userId, 'active', expiresDate, receiptInfo);
    await logSubscriptionEvent(userId, 'apple_subscription_recovered', 'active', expiresDate, receiptInfo);
    console.log(`🔄 Apple subscription recovered for user ${userId}`);
}

/**
 * Helper function to update Apple subscription in database
 */
async function updateAppleSubscription(userId, status, expiresDate, receiptInfo) {
    const updateFields = ['subscription_status = $1', 'last_active_at = NOW()', 'updated_at = NOW()'];
    const values = [status, userId];
    let paramIndex = 2;
    
    if (expiresDate) {
        updateFields.push(`subscription_end_date = $${++paramIndex}`);
        values.splice(-1, 0, expiresDate);
    }
    
    if (receiptInfo.product_id) {
        updateFields.push(`apple_product_id = $${++paramIndex}`);
        values.splice(-1, 0, receiptInfo.product_id);
    }
    
    await pool.query(`
        UPDATE users 
        SET ${updateFields.join(', ')}
        WHERE user_id = $${paramIndex}
    `, values);
}

/**
 * Helper function to log subscription events
 */
async function logSubscriptionEvent(userId, eventType, status, endDate, receiptInfo) {
    await pool.query(`
        INSERT INTO subscription_history 
        (user_id, event_type, new_status, new_end_date, metadata)
        VALUES ($1, $2, $3, $4, $5)
    `, [userId, eventType, status, endDate, JSON.stringify({
        product_id: receiptInfo.product_id,
        transaction_id: receiptInfo.transaction_id,
        original_transaction_id: receiptInfo.original_transaction_id,
        environment: receiptInfo.is_trial_period === 'true' ? 'Sandbox' : 'Production'
    })]);
}

/**
 * Validate Apple receipt with Apple's servers
 * Industry best practice: Always validate server-side
 * 
 * Apple's Recommended Approach:
 * 1. ALWAYS validate against production first
 * 2. If you get error 21007 (sandbox receipt), retry against sandbox
 * 3. This handles both production users AND Apple reviewers (who use sandbox)
 */
async function validateAppleReceipt(receiptData) {
    const requestBody = {
        'receipt-data': receiptData,
        'password': process.env.APPLE_SHARED_SECRET,
        'exclude-old-transactions': true
    };
    
    // Step 1: ALWAYS try production first (Apple's recommendation)
    console.log('🍎 Validating receipt with Apple Production server...');
    
    const productionResponse = await fetch('https://buy.itunes.apple.com/verifyReceipt', {
        method: 'POST',
        headers: { 
            'Content-Type': 'application/json',
            'User-Agent': 'HomeworkHelper/1.0'
        },
        body: JSON.stringify(requestBody)
    });
    
    const productionResult = await productionResponse.json();
    
    // Step 2: If error 21007, this is a sandbox receipt - retry with sandbox
    if (productionResult.status === 21007) {
        console.log('🔄 Sandbox receipt detected (error 21007) - retrying with Sandbox server...');
        console.log('ℹ️  This is expected during Apple Review or Xcode testing');
        
        const sandboxResponse = await fetch('https://sandbox.itunes.apple.com/verifyReceipt', {
            method: 'POST',
            headers: { 
                'Content-Type': 'application/json',
                'User-Agent': 'HomeworkHelper/1.0'
            },
            body: JSON.stringify(requestBody)
        });
        
        const sandboxResult = await sandboxResponse.json();
        
        // Mark this as sandbox environment for logging
        if (sandboxResult.status === 0) {
            console.log('✅ Sandbox receipt validated successfully');
            sandboxResult.environment = 'sandbox';
        }
        
        return sandboxResult;
    }
    
    // Step 3: Production receipt validated (or other error)
    if (productionResult.status === 0) {
        console.log('✅ Production receipt validated successfully');
        productionResult.environment = 'production';
    } else {
        console.log(`⚠️  Receipt validation failed with status: ${productionResult.status}`);
    }
    
    return productionResult;
}

/**
 * Get human-readable message for Apple status codes
 */
function getAppleStatusMessage(status) {
    const statusMessages = {
        0: 'Valid receipt',
        21000: 'The App Store could not read the receipt',
        21002: 'The receipt data property was malformed',
        21003: 'The receipt could not be authenticated',
        21004: 'The shared secret does not match',
        21005: 'The receipt server is temporarily unavailable',
        21006: 'This receipt is valid but the subscription has expired',
        21007: 'This receipt is from the sandbox environment',
        21008: 'This receipt is from the production environment',
        21010: 'This receipt could not be authorized'
    };
    
    return statusMessages[status] || `Unknown status: ${status}`;
}

module.exports = router;
