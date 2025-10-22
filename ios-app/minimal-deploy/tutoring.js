const express = require('express');
const multer = require('multer');
const router = express.Router();
const sessionService = require('../Services/sessionService');
const openaiService = require('../Services/openaiService');
const azureService = require('../Services/azureService');

// Configure multer for image uploads
const storage = multer.memoryStorage();
const upload = multer({ 
    storage: storage,
    limits: {
        fileSize: 10 * 1024 * 1024 // 10MB limit
    }
});

// Create a new tutoring session with image
router.post('/session/start-image', upload.fields([
    { name: 'image', maxCount: 1 },
    { name: 'teacherMethodImage', maxCount: 1 }
]), async (req, res) => {
    try {
        console.log('🔍 Starting new image-based tutoring session');
        
        const { userId, deviceId, userGradeLevel } = req.body;
        const imageFile = req.files?.image ? req.files.image[0] : null;
        const teacherMethodImageFile = req.files?.teacherMethodImage ? req.files.teacherMethodImage[0] : null;
        
        if (!imageFile) {
            return res.status(400).json({ error: 'Image file is required' });
        }
        
        // Log the tutoring session start
        console.log('📝 Tutoring session start request:', {
            userId: userId,
            deviceId: deviceId,
            userGradeLevel: userGradeLevel,
            hasImage: !!imageFile,
            hasTeacherMethod: !!teacherMethodImageFile,
            imageSize: imageFile ? imageFile.size : 0
        });
        
        console.log('🤖 Creating initial step from image...');
        
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
        
        // Log OpenAI analysis start
        console.log('📝 Starting OpenAI analysis for tutoring session:', {
            userId: userId,
            deviceId: deviceId,
            userGradeLevel: userGradeLevel,
            sessionType: 'step-by-step-tutoring'
        });
        
        // Get the initial step from OpenAI using image analysis
        const initialStep = await openaiService.analyzeHomework({
            imageData: imageFile.buffer,
            problemText: null,
            teacherMethodImageData: teacherMethodImageFile ? teacherMethodImageFile.buffer : null,
            userGradeLevel: userGradeLevel || 'elementary',
            apiKey: apiKey,
            userId: userId,
            deviceId: deviceId,
            metadata: {
                gradeLevel: userGradeLevel,
                sessionType: 'step-by-step-tutoring',
                hasImage: true,
                hasTeacherMethod: !!teacherMethodImageFile
            }
        });
        
        // Log the OpenAI response
        console.log('📝 OpenAI tutoring analysis completed:', {
            subject: initialStep.subject,
            difficulty: initialStep.difficulty,
            totalSteps: initialStep.totalSteps,
            currentStep: initialStep.currentStep,
            problemDescription: initialStep.problemDescription
        });
        
        // Create a new session
        const session = sessionService.createSession({
            userId: userId || 'anonymous',
            deviceId: deviceId || 'unknown',
            problemContext: initialStep.problemDescription,
            currentStep: initialStep.currentStep,
            totalSteps: initialStep.totalSteps,
            subject: initialStep.subject,
            difficulty: initialStep.difficulty
        });
        
        // Log session creation
        console.log('📝 Tutoring session created successfully:', {
            sessionId: session.sessionId,
            userId: session.userId,
            deviceId: session.deviceId,
            subject: session.subject,
            difficulty: session.difficulty,
            totalSteps: session.totalSteps,
            currentStep: session.currentStep
        });
        
        console.log('✅ Tutoring session created successfully');
        res.json(session);
        
    } catch (error) {
        console.error('❌ Error starting tutoring session:', error);
        
        // Log the error
        console.error('📝 Tutoring session start failed:', {
            error: error.message,
            stack: error.stack,
            userId: req.body.userId,
            deviceId: req.body.deviceId
        });
        
        res.status(500).json({ 
            error: 'Failed to start tutoring session',
            message: error.message 
        });
    }
});

// Create a new tutoring session
router.post('/session/start', async (req, res) => {
    try {
        console.log('🔍 Starting new tutoring session');
        
        const { userId, deviceId, problemContext, userGradeLevel } = req.body;
        
        if (!problemContext) {
            return res.status(400).json({ error: 'Problem context is required' });
        }
        
        console.log('🤖 Creating initial step...');
        
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
        
        // Get the initial step from OpenAI
        const initialStep = await openaiService.analyzeHomework({
            imageData: null, // No image for text-based problems
            problemText: problemContext,
            teacherMethodImageData: null,
            userGradeLevel: userGradeLevel || 'elementary',
            apiKey: apiKey,
            userId: userId,
            deviceId: deviceId,
            metadata: {
                gradeLevel: userGradeLevel,
                sessionType: 'step-by-step-tutoring'
            }
        });
        
        // Create a new session
        const session = sessionService.createSession({
            userId: userId || 'anonymous',
            deviceId: deviceId || 'unknown',
            problemContext: problemContext,
            initialStep: initialStep
        });
        
        console.log('✅ Tutoring session created successfully');
        res.json({
            sessionId: session.sessionId,
            currentStep: session.currentStep,
            totalSteps: session.totalSteps,
            step: initialStep,
            progress: `Step ${session.currentStep} of ${session.totalSteps}`
        });
        
    } catch (error) {
        console.error('Failed to start tutoring session:', error);
        res.status(500).json({ 
            error: 'Failed to start tutoring session',
            message: error.message 
        });
    }
});

// Get current step in a session
router.get('/session/:sessionId/current-step', async (req, res) => {
    try {
        const { sessionId } = req.params;
        
        const session = sessionService.getSession(sessionId);
        if (!session) {
            return res.status(404).json({ error: 'Session not found' });
        }
        
        const currentStepData = session.steps[session.currentStep - 1];
        const progress = sessionService.getSessionProgress(sessionId);
        
        res.json({
            sessionId: session.sessionId,
            currentStep: session.currentStep,
            totalSteps: session.totalSteps,
            step: currentStepData,
            progress: progress,
            isCompleted: session.isCompleted
        });
        
    } catch (error) {
        console.error('Failed to get current step:', error);
        res.status(500).json({ 
            error: 'Failed to get current step',
            message: error.message 
        });
    }
});

// Submit answer and get next step
router.post('/session/:sessionId/answer', async (req, res) => {
    try {
        const { sessionId } = req.params;
        const { studentAnswer, userGradeLevel } = req.body;
        
        // Log answer submission
        console.log('📝 Student answer submitted:', {
            sessionId: sessionId,
            studentAnswer: studentAnswer,
            userGradeLevel: userGradeLevel
        });
        
        if (!studentAnswer) {
            return res.status(400).json({ error: 'Student answer is required' });
        }
        
        const session = sessionService.getSession(sessionId);
        if (!session) {
            return res.status(404).json({ error: 'Session not found' });
        }
        
        if (session.isCompleted) {
            return res.status(400).json({ error: 'Session is already completed' });
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
        
        // Log OpenAI next step request
        console.log('📝 Requesting next step from OpenAI:', {
            sessionId: sessionId,
            currentStep: session.currentStep,
            studentAnswer: studentAnswer,
            userGradeLevel: userGradeLevel
        });
        
        // Get the next step from OpenAI
        const nextStep = await openaiService.getNextStep({
            currentStep: session.currentStep,
            studentAnswer: studentAnswer,
            problemContext: session.problemContext,
            userGradeLevel: userGradeLevel || 'elementary',
            apiKey: apiKey,
            userId: session.userId,
            deviceId: session.deviceId,
            metadata: {
                gradeLevel: userGradeLevel,
                sessionId: sessionId,
                currentStep: session.currentStep
            }
        });
        
        // Log OpenAI response
        console.log('📝 OpenAI next step response received:', {
            sessionId: sessionId,
            nextStep: nextStep,
            isCompleted: nextStep.isCompleted
        });
        
        // Add the student's answer and next step to the session
        const updatedSession = sessionService.addStudentAnswer(sessionId, studentAnswer, nextStep);
        
        // Log session update
        console.log('📝 Session updated with student answer:', {
            sessionId: sessionId,
            currentStep: updatedSession.currentStep,
            totalSteps: updatedSession.totalSteps,
            isCompleted: updatedSession.isCompleted,
            studentAnswer: studentAnswer
        });
        
        console.log('✅ Answer submitted and next step generated');
        res.json({
            sessionId: session.sessionId,
            currentStep: updatedSession.currentStep,
            totalSteps: updatedSession.totalSteps,
            step: nextStep,
            progress: sessionService.getSessionProgress(sessionId),
            isCompleted: updatedSession.isCompleted
        });
        
    } catch (error) {
        console.error('Failed to submit answer:', error);
        
        // Log the error
        console.error('📝 Answer submission failed:', {
            error: error.message,
            stack: error.stack,
            sessionId: req.params.sessionId,
            studentAnswer: req.body.studentAnswer
        });
        
        res.status(500).json({ 
            error: 'Failed to submit answer',
            message: error.message 
        });
    }
});

// Get session progress
router.get('/session/:sessionId/progress', async (req, res) => {
    try {
        const { sessionId } = req.params;
        
        const progress = sessionService.getSessionProgress(sessionId);
        if (!progress) {
            return res.status(404).json({ error: 'Session not found' });
        }
        
        res.json(progress);
        
    } catch (error) {
        console.error('Failed to get session progress:', error);
        res.status(500).json({ 
            error: 'Failed to get session progress',
            message: error.message 
        });
    }
});

// Get all sessions for a user
router.get('/user/:userId/sessions', async (req, res) => {
    try {
        const { userId } = req.params;
        
        const sessions = sessionService.getUserSessions(userId);
        
        res.json({
            userId: userId,
            sessions: sessions,
            totalSessions: sessions.length
        });
        
    } catch (error) {
        console.error('Failed to get user sessions:', error);
        res.status(500).json({ 
            error: 'Failed to get user sessions',
            message: error.message 
        });
    }
});

// Complete a session (mark as completed)
router.post('/session/:sessionId/complete', async (req, res) => {
    try {
        const { sessionId } = req.params;
        
        const session = sessionService.getSession(sessionId);
        if (!session) {
            return res.status(404).json({ error: 'Session not found' });
        }
        
        session.isCompleted = true;
        session.completedAt = new Date().toISOString();
        
        console.log('🎉 Session completed:', sessionId);
        res.json({
            sessionId: session.sessionId,
            isCompleted: true,
            completedAt: session.completedAt,
            totalSteps: session.totalSteps,
            stepsCompleted: session.studentAnswers.length
        });
        
    } catch (error) {
        console.error('Failed to complete session:', error);
        res.status(500).json({ 
            error: 'Failed to complete session',
            message: error.message 
        });
    }
});

module.exports = router;
