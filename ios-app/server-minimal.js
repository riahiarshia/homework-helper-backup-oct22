/**
 * Minimal Homework Helper Backend Server
 * For Azure deployment with logging
 */

const express = require('express');
const cors = require('cors');
require('dotenv').config();

console.log('🚀 Starting minimal server...');

const app = express();
const PORT = process.env.PORT || 8080;

// Middleware
app.use(cors());
app.use(express.json());

// Basic health check endpoint
app.get('/api/health', (req, res) => {
    res.json({
        status: 'OK',
        message: 'Homework Helper API is running',
        timestamp: new Date().toISOString(),
        version: '1.0.0'
    });
});

// Root route
app.get('/', (req, res) => {
    res.json({
        message: 'Homework Helper API',
        version: '1.0.0',
        status: 'Running',
        endpoints: {
            health: '/api/health'
        }
    });
});

// Error handling middleware
app.use((err, req, res, next) => {
    console.error('Server error:', err);
    res.status(500).json({
        error: 'Internal server error',
        message: process.env.NODE_ENV === 'development' ? err.message : 'Something went wrong'
    });
});

// Start server
app.listen(PORT, () => {
    console.log(`
╔════════════════════════════════════════════════════════╗
║                                                        ║
║   📚 Homework Helper Backend Server (Minimal)        ║
║                                                        ║
║   🚀 Server running on port ${PORT}                      ║
║   🌐 Environment: ${process.env.NODE_ENV || 'development'}            ║
║   📊 API Health: http://localhost:${PORT}/api/health     ║
║                                                        ║
╚════════════════════════════════════════════════════════╝
    `);
    
    console.log('✅ Minimal server started successfully');
});

module.exports = app;
