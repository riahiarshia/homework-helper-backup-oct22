/**
 * Homework Helper Backend Server
 * With OpenAI Logging Integration
 */

const express = require('express');
const cors = require('cors');
const path = require('path');
require('dotenv').config();

console.log('🚀 Starting Homework Helper Backend with Logging...');

const app = express();
const PORT = process.env.PORT || 8080;

// Middleware
app.use(cors());
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

// Basic health check endpoint
app.get('/api/health', (req, res) => {
    res.json({
        status: 'OK',
        message: 'Homework Helper API with OpenAI Logging is running',
        timestamp: new Date().toISOString(),
        version: '1.0.0',
        features: ['OpenAI Logging', 'Homework Analysis', 'Image Processing']
    });
});

// Root route
app.get('/', (req, res) => {
    res.json({
        message: 'Homework Helper API with OpenAI Logging',
        version: '1.0.0',
        status: 'Running',
        endpoints: {
            health: '/api/health',
            validate_image: '/api/validate-image',
            analyze_homework: '/api/analyze-homework',
            hint: '/api/hint',
            verify: '/api/verify',
            chat: '/api/chat'
        },
        logging: {
            location: '/home/LogFiles/custom/homework-math.log',
            features: [
                'OpenAI API requests and responses',
                'Homework submission tracking',
                'Hint generation logging',
                'Answer verification logging',
                'Chat response logging',
                'Image validation logging'
            ]
        }
    });
});

// Import and use logging service
try {
    const loggingService = require('./Services/loggingService');
    console.log('✅ Logging service loaded successfully');
    
    // Log server startup
    loggingService.writeLog(loggingService.formatLogEntry('SERVER_STARTUP', {
        timestamp: new Date().toISOString(),
        port: PORT,
        environment: process.env.NODE_ENV || 'development',
        features: ['OpenAI Logging', 'Homework Analysis']
    }));
} catch (error) {
    console.warn('⚠️ Logging service not available:', error.message);
}

// Import and use OpenAI service with logging
try {
    const openaiService = require('./Services/openaiService');
    console.log('✅ OpenAI service loaded successfully');
} catch (error) {
    console.warn('⚠️ OpenAI service not available:', error.message);
}

// Import and use routes with logging
try {
    const imageAnalysisRoutes = require('./routes/imageAnalysis');
    app.use('/api', imageAnalysisRoutes);
    console.log('✅ Image analysis routes loaded successfully');
} catch (error) {
    console.warn('⚠️ Image analysis routes not available:', error.message);
}

try {
    const homeworkRoutes = require('./routes/homework');
    app.use('/api/homework', homeworkRoutes);
    console.log('✅ Homework routes loaded successfully');
} catch (error) {
    console.warn('⚠️ Homework routes not available:', error.message);
}

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
║   📚 Homework Helper Backend with OpenAI Logging     ║
║                                                        ║
║   🚀 Server running on port ${PORT}                      ║
║   🌐 Environment: ${process.env.NODE_ENV || 'development'}            ║
║   📊 API Health: http://localhost:${PORT}/api/health     ║
║   📝 Logs: /home/LogFiles/custom/homework-math.log    ║
║                                                        ║
╚════════════════════════════════════════════════════════╝
    `);
    
    console.log('✅ Homework Helper Backend with OpenAI Logging started successfully');
});

module.exports = app;
