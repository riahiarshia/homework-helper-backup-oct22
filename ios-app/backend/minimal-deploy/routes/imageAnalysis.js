/**
 * Image Analysis Routes
 * Handles image validation and homework analysis
 */

const express = require('express');
const multer = require('multer');
const openaiService = require('../Services/openaiService');
const azureService = require('../services/azureService');
const router = express.Router();

// Configure multer for image uploads
const storage = multer.memoryStorage();
const upload = multer({ 
    storage: storage,
    limits: {
        fileSize: 10 * 1024 * 1024 // 10MB limit
    }
});

/**
 * POST /api/validate-image
 * Validates image quality for homework analysis
 */
router.post('/validate-image', upload.single('image'), async (req, res) => {
    try {
        console.log('🔍 Image validation request received');
        
        if (!req.file) {
            return res.status(400).json({ 
                error: 'No image file provided',
                isGoodQuality: false,
                confidence: 0.0,
                issues: ['No image file uploaded'],
                recommendations: []
            });
        }
        
        const imageBuffer = req.file.buffer;
        const imageSize = imageBuffer.length;
        
        console.log(`📊 Image size: ${(imageSize / 1024).toFixed(2)} KB`);
        
        // Basic file size validation first
        if (imageSize < 10 * 1024) {
            return res.json({
                isGoodQuality: false,
                confidence: 0.0,
                issues: ['Image is too small (minimum 10KB required)'],
                recommendations: ['Take a higher resolution photo or get closer to the homework']
            });
        }
        
        if (imageSize > 10 * 1024 * 1024) {
            return res.json({
                isGoodQuality: false,
                confidence: 0.0,
                issues: ['Image is too large (maximum 10MB allowed)'],
                recommendations: ['Compress the image or take a new photo']
            });
        }
        
        // Check if it's a valid image format
        const isValidFormat = checkImageFormat(imageBuffer);
        if (!isValidFormat) {
            return res.json({
                isGoodQuality: false,
                confidence: 0.0,
                issues: ['Invalid image format (only JPEG, PNG, HEIC supported)'],
                recommendations: ['Save the image in JPEG or PNG format']
            });
        }
        
        // Use OpenAI to analyze image quality
        console.log('🤖 Using OpenAI to analyze image quality...');
        console.log('🔑 Fetching OpenAI API key from Azure Key Vault...');
        
        let apiKey;
        try {
            apiKey = await azureService.getOpenAIKey();
            console.log('✅ Successfully retrieved OpenAI API key from Azure Key Vault');
        } catch (error) {
            console.error('❌ Failed to get OpenAI API key from Azure Key Vault:', error.message);
            // Fallback to basic validation if Azure Key Vault fails
            return res.json({
                isGoodQuality: isValidFormat && imageSize >= 10 * 1024 && imageSize <= 10 * 1024 * 1024,
                confidence: 0.5,
                issues: isValidFormat ? [] : ['Could not verify image format'],
                recommendations: [
                    'Ensure the image is clear and well-lit',
                    'Make sure the homework text is readable',
                    'Avoid blurry or dark images'
                ]
            });
        }
        
        // Get userId and deviceId from request body if available (optional)
        const userId = req.body.userId || null;
        const deviceId = req.body.deviceId || null;
        console.log(`📊 [validate-image] Tracking usage for user: ${userId || 'anonymous'}, device: ${deviceId || 'unknown'}`);
        
        const qualityAnalysis = await openaiService.validateImageQuality({
            imageData: imageBuffer,
            apiKey: apiKey,
            userId: userId,
            deviceId: deviceId,
            metadata: {
                fileSize: imageSize,
                mimeType: req.file.mimetype
            }
        });
        
        console.log(`✅ OpenAI image validation completed - Quality: ${qualityAnalysis.isGoodQuality}, Confidence: ${qualityAnalysis.confidence}`);
        
        // Return the validation result in the expected format
        res.json({
            isGoodQuality: qualityAnalysis.isGoodQuality,
            confidence: qualityAnalysis.confidence,
            issues: qualityAnalysis.issues || [],
            recommendations: qualityAnalysis.recommendations || []
        });
        
    } catch (error) {
        console.error('Image validation error:', error);
        
        // Fallback to basic validation if OpenAI fails
        if (req.file) {
            const imageSize = req.file.buffer.length;
            const isValidFormat = checkImageFormat(req.file.buffer);
            
            res.json({
                isGoodQuality: isValidFormat && imageSize >= 10 * 1024 && imageSize <= 10 * 1024 * 1024,
                confidence: 0.5,
                issues: isValidFormat ? [] : ['Could not verify image format'],
                recommendations: [
                    'Ensure the image is clear and well-lit',
                    'Make sure the homework text is readable',
                    'Avoid blurry or dark images'
                ]
            });
        } else {
            res.status(500).json({ 
                error: 'Image validation failed',
                isGoodQuality: false,
                confidence: 0.0,
                issues: ['Server error during validation'],
                recommendations: []
            });
        }
    }
});

/**
 * POST /api/analyze-homework
 * Analyzes homework image and provides solutions
 */
router.post('/analyze-homework', upload.fields([
    { name: 'image', maxCount: 1 },
    { name: 'teacherMethodImage', maxCount: 1 }
]), async (req, res) => {
    try {
        console.log('🔍 Homework analysis request received');
        
        const { problemText, userGradeLevel } = req.body;
        const imageFile = req.files?.image ? req.files.image[0] : null;
        const teacherMethodImageFile = req.files?.teacherMethodImage ? req.files.teacherMethodImage[0] : null;
        
        if (!imageFile && !problemText) {
            return res.status(400).json({ 
                error: 'Either image file or problem text is required' 
            });
        }
        
        console.log(`📊 Analysis request - Image: ${!!imageFile}, Text: ${!!problemText}, Teacher Method: ${!!teacherMethodImageFile}, Grade: ${userGradeLevel}`);
        
        // Use OpenAI to analyze the homework
        console.log('🤖 Using OpenAI to analyze homework...');
        console.log('🔑 Fetching OpenAI API key from Azure Key Vault...');
        
        let apiKey;
        try {
            apiKey = await azureService.getOpenAIKey();
            console.log('✅ Successfully retrieved OpenAI API key from Azure Key Vault');
        } catch (error) {
            console.error('❌ Failed to get OpenAI API key from Azure Key Vault:', error.message);
            return res.status(500).json({ 
                error: 'AI service configuration error',
                message: 'Failed to retrieve OpenAI API key from secure storage'
            });
        }
        
        // Get userId and deviceId from request body if available (optional)
        const userId = req.body.userId || null;
        const deviceId = req.body.deviceId || null;
        console.log(`📊 [analyze-homework] Tracking usage for user: ${userId || 'anonymous'}, device: ${deviceId || 'unknown'}`);
        
        const analysisResult = await openaiService.analyzeHomework({
            imageData: imageFile ? imageFile.buffer : null,
            problemText: problemText,
            teacherMethodImageData: teacherMethodImageFile ? teacherMethodImageFile.buffer : null,
            userGradeLevel: userGradeLevel || 'elementary',
            apiKey: apiKey,
            userId: userId,
            deviceId: deviceId,
            metadata: {
                gradeLevel: userGradeLevel,
                problemText: problemText ? problemText.substring(0, 100) : null,
                hasTeacherMethod: !!teacherMethodImageFile
            }
        });
        
        console.log(`✅ OpenAI homework analysis completed - Subject: ${analysisResult.subject}, Difficulty: ${analysisResult.difficulty}, Total Steps: ${analysisResult.totalSteps}`);
        
        // Validate the response structure for step-by-step format
        if (!analysisResult.currentStep || typeof analysisResult.currentStep !== 'object') {
          console.error('❌ Invalid response structure: currentStep missing or invalid');
          return res.status(500).json({ 
            error: 'Invalid AI response structure',
            message: 'The AI response is missing required currentStep data'
          });
        }
        
        // Validate currentStep has required fields
        const step = analysisResult.currentStep;
        if (!step.question || !step.explanation || !step.options || !step.correctAnswer) {
          console.error(`❌ Invalid currentStep: missing required fields`, step);
          return res.status(500).json({ 
            error: 'Invalid step structure',
            message: 'Current step is missing required fields (question, explanation, options, correctAnswer)'
          });
        }
        
        // Validate totalSteps is present
        if (!analysisResult.totalSteps || typeof analysisResult.totalSteps !== 'number') {
          console.error('❌ Invalid response structure: totalSteps missing or invalid');
          return res.status(500).json({ 
            error: 'Invalid AI response structure',
            message: 'The AI response is missing required totalSteps data'
          });
        }
        
        // Return the analysis in the expected format
        res.json(analysisResult);
        
    } catch (error) {
        console.error('Homework analysis error:', error);
        
        // If OpenAI fails, return a helpful error message
        if (error.message.includes('Invalid OpenAI API key')) {
            res.status(500).json({ 
                error: 'AI service configuration error',
                message: 'OpenAI API key is not properly configured'
            });
        } else if (error.message.includes('rate limit')) {
            res.status(429).json({ 
                error: 'Service temporarily unavailable',
                message: 'AI analysis is temporarily unavailable due to high usage. Please try again in a few minutes.'
            });
        } else {
            res.status(500).json({ 
                error: 'Homework analysis failed',
                message: error.message 
            });
        }
    }
});

/**
 * POST /api/hint
 * Generate a hint for a specific step
 */
router.post('/hint', async (req, res) => {
    try {
        console.log('🔍 Hint generation request received');
        
        const { step, problemContext, userGradeLevel } = req.body;
        
        if (!step) {
            return res.status(400).json({ error: 'Step information is required' });
        }
        
        console.log('🤖 Generating hint...');
        
        let apiKey;
        try {
            apiKey = await azureService.getOpenAIKey();
            console.log('✅ Successfully retrieved OpenAI API key from Azure Key Vault');
        } catch (error) {
            console.error('❌ Failed to get OpenAI API key:', error.message);
            return res.status(500).json({ 
                error: 'AI service configuration error',
                message: 'Failed to retrieve API key'
            });
        }
        
        // Get userId and deviceId from request body if available (optional)
        const userId = req.body.userId || null;
        const deviceId = req.body.deviceId || null;
        console.log(`📊 [hint] Tracking usage for user: ${userId || 'anonymous'}, device: ${deviceId || 'unknown'}`);
        
        // Log the hint request
        const loggingService = require('../Services/loggingService');
        console.log('🔍 Logging hint request...');
        loggingService.logMathProblem({
            userId,
            deviceId,
            problemText: `Hint request for step: ${step.question}`,
            userGradeLevel: userGradeLevel || 'elementary',
            metadata: {
                type: 'hint_request',
                step: step,
                problemContext: problemContext || ''
            }
        });
        
        const hint = await openaiService.generateHint({
            step: step,
            problemContext: problemContext || '',
            userGradeLevel: userGradeLevel || 'elementary',
            apiKey: apiKey,
            userId: userId,
            deviceId: deviceId,
            metadata: {
                gradeLevel: userGradeLevel,
                stepQuestion: step.question
            }
        });
        
        // Log the hint response
        console.log('🔍 Logging hint response...');
        loggingService.logOpenAIResponse(JSON.stringify({
            type: 'hint_response',
            hint: hint,
            step: step,
            problemContext: problemContext || ''
        }, null, 2), 'hint_response');
        
        console.log('✅ Hint generated successfully');
        res.json({ hint: hint });
        
    } catch (error) {
        console.error('Hint generation error:', error);
        
        // Log the error
        const loggingService = require('../Services/loggingService');
        loggingService.logError(error, {
            userId: req.body.userId || null,
            deviceId: req.body.deviceId || null,
            endpoint: 'hint',
            requestData: req.body,
            duration: 0
        });
        
        res.status(500).json({ 
            error: 'Hint generation failed',
            message: error.message 
        });
    }
});

/**
 * POST /api/verify
 * Verify a student's answer
 */
router.post('/verify', async (req, res) => {
    try {
        console.log('🔍 Answer verification request received');
        
        const { answer, step, problemContext, userGradeLevel } = req.body;
        
        if (!answer || !step) {
            return res.status(400).json({ error: 'Answer and step information are required' });
        }
        
        console.log('🤖 Verifying answer...');
        
        let apiKey;
        try {
            apiKey = await azureService.getOpenAIKey();
            console.log('✅ Successfully retrieved OpenAI API key from Azure Key Vault');
        } catch (error) {
            console.error('❌ Failed to get OpenAI API key:', error.message);
            return res.status(500).json({ 
                error: 'AI service configuration error',
                message: 'Failed to retrieve API key'
            });
        }
        
        // Get userId and deviceId from request body if available (optional)
        const userId = req.body.userId || null;
        const deviceId = req.body.deviceId || null;
        console.log(`📊 [verify] Tracking usage for user: ${userId || 'anonymous'}, device: ${deviceId || 'unknown'}`);
        
        // Log the answer verification request
        const loggingService = require('../Services/loggingService');
        console.log('🔍 Logging answer verification request...');
        loggingService.logMathProblem({
            userId,
            deviceId,
            problemText: `Answer verification for step: ${step.question}`,
            userGradeLevel: userGradeLevel || 'elementary',
            metadata: {
                type: 'answer_verification_request',
                step: step,
                answer: answer,
                problemContext: problemContext || ''
            }
        });
        
        const verification = await openaiService.verifyAnswer({
            answer: answer,
            step: step,
            problemContext: problemContext || '',
            userGradeLevel: userGradeLevel || 'elementary',
            apiKey: apiKey,
            userId: userId,
            deviceId: deviceId,
            metadata: {
                gradeLevel: userGradeLevel,
                answer: answer.substring(0, 100)
            }
        });
        
        // Log the verification response
        console.log('🔍 Logging answer verification response...');
        loggingService.logOpenAIResponse(JSON.stringify({
            type: 'answer_verification_response',
            verification: verification,
            step: step,
            answer: answer,
            problemContext: problemContext || ''
        }, null, 2), 'answer_verification_response');
        
        console.log('✅ Answer verified successfully');
        res.json(verification);
        
    } catch (error) {
        console.error('Answer verification error:', error);
        
        // Log the error
        const loggingService = require('../Services/loggingService');
        loggingService.logError(error, {
            userId: req.body.userId || null,
            deviceId: req.body.deviceId || null,
            endpoint: 'verify',
            requestData: req.body,
            duration: 0
        });
        
        res.status(500).json({ 
            error: 'Verification failed',
            message: error.message 
        });
    }
});

/**
 * POST /api/chat
 * Generate chat response
 */
router.post('/chat', async (req, res) => {
    try {
        console.log('🔍 Chat request received');
        
        const { messages, problemContext, userGradeLevel } = req.body;
        
        if (!messages || !Array.isArray(messages)) {
            return res.status(400).json({ error: 'Messages array is required' });
        }
        
        console.log('🤖 Generating chat response...');
        
        let apiKey;
        try {
            apiKey = await azureService.getOpenAIKey();
            console.log('✅ Successfully retrieved OpenAI API key from Azure Key Vault');
        } catch (error) {
            console.error('❌ Failed to get OpenAI API key:', error.message);
            return res.status(500).json({ 
                error: 'AI service configuration error',
                message: 'Failed to retrieve API key'
            });
        }
        
        // Get userId and deviceId from request body if available (optional)
        const userId = req.body.userId || null;
        const deviceId = req.body.deviceId || null;
        console.log(`📊 [chat] Tracking usage for user: ${userId || 'anonymous'}, device: ${deviceId || 'unknown'}`);
        
        // Log the chat request
        const loggingService = require('../Services/loggingService');
        console.log('🔍 Logging chat request...');
        loggingService.logMathProblem({
            userId,
            deviceId,
            problemText: `Chat conversation with ${messages.length} messages`,
            userGradeLevel: userGradeLevel || 'elementary',
            metadata: {
                type: 'chat_request',
                messages: messages,
                problemContext: problemContext || ''
            }
        });
        
        const response = await openaiService.generateChatResponse({
            messages: messages,
            problemContext: problemContext || '',
            userGradeLevel: userGradeLevel || 'elementary',
            apiKey: apiKey,
            userId: userId,
            deviceId: deviceId,
            metadata: {
                gradeLevel: userGradeLevel,
                messageCount: messages.length
            }
        });
        
        // Log the chat response
        console.log('🔍 Logging chat response...');
        loggingService.logOpenAIResponse(JSON.stringify({
            type: 'chat_response',
            response: response,
            messages: messages,
            problemContext: problemContext || ''
        }, null, 2), 'chat_response');
        
        console.log('✅ Chat response generated successfully');
        res.json({ response: response });
        
    } catch (error) {
        console.error('Chat response error:', error);
        
        // Log the error
        const loggingService = require('../Services/loggingService');
        loggingService.logError(error, {
            userId: req.body.userId || null,
            deviceId: req.body.deviceId || null,
            endpoint: 'chat',
            requestData: req.body,
            duration: 0
        });
        
        res.status(500).json({ 
            error: 'Chat response failed',
            message: error.message 
        });
    }
});

/**
 * Helper function to check image format
 */
function checkImageFormat(buffer) {
    // Check for common image file signatures
    const signatures = [
        { offset: 0, bytes: [0xFF, 0xD8, 0xFF] }, // JPEG
        { offset: 0, bytes: [0x89, 0x50, 0x4E, 0x47] }, // PNG
        { offset: 0, bytes: [0x47, 0x49, 0x46] }, // GIF
        { offset: 4, bytes: [0x66, 0x74, 0x79, 0x70] } // HEIC/HEIF (simplified check)
    ];
    
    for (const sig of signatures) {
        if (buffer.length > sig.offset + sig.bytes.length) {
            const matches = sig.bytes.every((byte, index) => 
                buffer[sig.offset + index] === byte
            );
            if (matches) return true;
        }
    }
    
    return false;
}

// Step-by-step tutoring endpoint
router.post('/next-step', async (req, res) => {
    try {
        console.log('🔍 Next step request received');
        
        const { currentStep, studentAnswer, problemContext, userGradeLevel, userId, deviceId } = req.body;
        
        if (!currentStep || !studentAnswer || !problemContext) {
            return res.status(400).json({ error: 'Current step, student answer, and problem context are required' });
        }
        
        console.log('🤖 Getting next step...');
        
        let apiKey;
        try {
            apiKey = await azureService.getOpenAIKey();
            console.log('✅ Successfully retrieved OpenAI API key from Azure Key Vault');
        } catch (error) {
            console.error('❌ Failed to get OpenAI API key:', error.message);
            return res.status(500).json({ 
                error: 'AI service configuration error',
                message: 'Failed to retrieve API key'
            });
        }
        
        // Get userId and deviceId from request body if available (optional)
        const requestUserId = userId || null;
        const requestDeviceId = deviceId || null;
        console.log(`📊 [next-step] Tracking usage for user: ${requestUserId || 'anonymous'}, device: ${requestDeviceId || 'unknown'}`);
        
        const nextStepResult = await openaiService.getNextStep({
            currentStep: currentStep,
            studentAnswer: studentAnswer,
            problemContext: problemContext,
            userGradeLevel: userGradeLevel || 'elementary',
            apiKey: apiKey,
            userId: requestUserId,
            deviceId: requestDeviceId,
            metadata: {
                gradeLevel: userGradeLevel,
                currentStep: currentStep,
                studentAnswer: studentAnswer.substring(0, 100)
            }
        });
        
        console.log('✅ Next step generated successfully');
        res.json(nextStepResult);
        
    } catch (error) {
        console.error('Next step request failed:', error);
        res.status(500).json({ 
            error: 'Failed to generate next step',
            message: error.message 
        });
    }
});

module.exports = router;
