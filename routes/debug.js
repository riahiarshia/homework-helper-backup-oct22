const express = require('express');
const router = express.Router();
const calculationEngine = require('../services/calculationEngine');

// DEBUG endpoint to test calculation engine directly
router.post('/test-calc-engine', async (req, res) => {
  try {
    const { question, subject } = req.body;
    
    console.log('🔬 DEBUG: Testing calculation engine');
    console.log('Question:', question);
    console.log('Subject:', subject);
    
    // Create a mock step
    const mockStep = {
      question: question || "Problem 1: What is 3 + 4?",
      explanation: "Test explanation",
      options: ["6", "7", "8", "9"],
      correctAnswer: "7"
    };
    
    console.log('🔬 Mock step (before processing):', JSON.stringify(mockStep, null, 2));
    
    // Process with calculation engine
    const processed = calculationEngine.processStep(mockStep, subject || 'Math');
    
    console.log('🔬 Processed step (after calc engine):', JSON.stringify(processed, null, 2));
    
    res.json({
      success: true,
      original: mockStep,
      processed: processed,
      hasExpression: !!processed.expression,
      expressionValue: processed.expression || 'MISSING'
    });
    
  } catch (error) {
    console.error('❌ DEBUG endpoint error:', error);
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
});

module.exports = router;
