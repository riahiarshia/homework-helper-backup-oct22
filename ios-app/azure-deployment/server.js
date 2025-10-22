/**
 * Homework Helper Backend Server
 * Wolfram|Alpha Integration Version
 */

const express = require('express');
const cors = require('cors');
const path = require('path');

// Load environment variables
require('dotenv').config();

// Validate required environment variables
const requiredEnvVars = ['OPENAI_API_KEY'];
requiredEnvVars.forEach(varName => {
    if (!process.env[varName]) {
        console.error(`❌ ERROR: Missing required environment variable: ${varName}`);
        console.error(`Please set ${varName} in your environment variables`);
        process.exit(1);
    }
});

// Log environment validation success
console.log('✅ Environment variables validated');

const app = express();
const PORT = process.env.PORT || 8080;
const HOST = '0.0.0.0';

// Middleware
app.use(cors());
app.use(express.json());

// Serve static files
app.use(express.static(path.join(__dirname, 'public')));

// Import our Wolfram|Alpha routes
const debugMathRoutes = require('./debug-math');

// Register routes
app.use('/api', debugMathRoutes);

// Root route
app.get('/', (req, res) => {
    res.json({
        message: 'Homework Helper API with Wolfram|Alpha Integration',
        version: '1.0.0',
        endpoints: {
            debug_math: '/api/debug-math',
            test: '/api/debug-math/test'
        }
    });
});

// Start server
app.listen(PORT, HOST, () => {
    console.log(`🚀 Server running on http://${HOST}:${PORT}`);
    console.log(`📊 Debug Math endpoint: http://${HOST}:${PORT}/api/debug-math`);
    console.log(`🧪 Test endpoint: http://${HOST}:${PORT}/api/debug-math/test`);
});

module.exports = app;