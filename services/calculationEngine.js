/**
 * Calculation Engine Service
 * 
 * Provides 100% accurate mathematical calculations and option generation
 * for math-heavy subjects (Math, Physics, Chemistry)
 */

const math = require('mathjs');
const optionGenerator = require('./optionGenerator');

/**
 * Detects if a step contains a calculable expression
 */
function isCalculable(step, subject) {
  if (!step.expression || typeof step.expression !== 'string') {
    return false;
  }

  const mathOperators = ['+', '-', '*', '/', '^', '(', 'sqrt', 'log', 'sin', 'cos', 'tan'];
  const hasMathOperator = mathOperators.some(op => step.expression.includes(op));
  
  // Subjects that support calculation engine
  const calculableSubjects = ['Math', 'Mathematics', 'Physics', 'Chemistry'];
  const isCalculableSubject = calculableSubjects.some(s => 
    subject && subject.toLowerCase().includes(s.toLowerCase())
  );

  return hasMathOperator && isCalculableSubject;
}

/**
 * Safely evaluates a mathematical expression
 */
function calculateExpression(expression) {
  try {
    // Configure math.js for safe evaluation
    const result = math.evaluate(expression);
    
    return {
      success: true,
      result: result,
      formatted: formatResult(result)
    };
  } catch (error) {
    console.error('❌ Calculation error:', error.message);
    return {
      success: false,
      error: error.message,
      result: null
    };
  }
}

/**
 * Formats the result for display
 */
function formatResult(result) {
  // Handle fractions
  if (typeof result === 'number') {
    // Check if it's a clean fraction
    const fraction = toFraction(result);
    if (fraction) {
      return fraction;
    }
    
    // Check if it's a clean decimal
    if (result % 1 === 0) {
      return result.toString();
    }
    
    // Round to reasonable precision
    return result.toFixed(4).replace(/\.?0+$/, '');
  }
  
  return result.toString();
}

/**
 * Converts decimal to fraction if it's a clean fraction
 */
function toFraction(decimal) {
  const tolerance = 1.0E-6;
  let h1 = 1, h2 = 0, k1 = 0, k2 = 1;
  let b = decimal;
  
  do {
    const a = Math.floor(b);
    let aux = h1;
    h1 = a * h1 + h2;
    h2 = aux;
    aux = k1;
    k1 = a * k1 + k2;
    k2 = aux;
    b = 1 / (b - a);
  } while (Math.abs(decimal - h1 / k1) > decimal * tolerance);
  
  // Only return fraction if denominator is reasonable
  if (k1 <= 100) {
    // If denominator is 1, just return the numerator
    if (k1 === 1) return h1.toString();
    if (h1 === k1) return h1.toString();
    return `${h1}/${k1}`;
  }
  
  return null;
}

/**
 * Processes a step with calculation engine
 */
function processCalculableStep(step, subject) {
  console.log('🧮 Processing calculable step:', step.expression);
  
  // Calculate the correct answer
  const calculation = calculateExpression(step.expression);
  
  if (!calculation.success) {
    console.error('❌ Calculation failed, falling back to AI');
    return null; // Fall back to AI
  }
  
  console.log('✅ Calculated answer:', calculation.formatted);
  
  // Generate multiple choice options
  const options = optionGenerator.generateOptions(
    calculation.result,
    calculation.formatted,
    step.type || 'arithmetic',
    step.expression,
    subject
  );
  
  return {
    question: step.question,
    explanation: step.explanation,
    expression: step.expression,
    options: options.shuffled,
    correctAnswer: calculation.formatted,
    calculationMetadata: {
      rawResult: calculation.result,
      verified: true,
      source: 'calculation_engine',
      timestamp: new Date().toISOString()
    }
  };
}

/**
 * Main entry point: Process a step (either calculate or pass through)
 */
function processStep(step, subject) {
  // Check if this step is calculable
  if (isCalculable(step, subject)) {
    const result = processCalculableStep(step, subject);
    if (result) {
      return result;
    }
  }
  
  // Fall back to AI-provided options
  console.log('📝 Using AI-provided options for:', step.question);
  return {
    question: step.question,
    explanation: step.explanation,
    options: step.options,
    correctAnswer: step.correctAnswer,
    calculationMetadata: {
      source: 'ai_generated',
      timestamp: new Date().toISOString()
    }
  };
}

module.exports = {
  isCalculable,
  calculateExpression,
  processCalculableStep,
  processStep,
  formatResult
};

