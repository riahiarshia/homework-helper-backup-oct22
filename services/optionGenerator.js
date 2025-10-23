/**
 * Option Generator Service
 * 
 * Generates smart multiple choice distractors based on common student errors
 * Research-based strategies from educational psychology
 */

/**
 * Distractor generation strategies by problem type
 */
const DISTRACTOR_STRATEGIES = {
  arithmetic: [
    (result, formatted, expr) => {
      // Off by one (low)
      return formatSameStyle(result - 1, formatted);
    },
    (result, formatted, expr) => {
      // Off by one (high)
      return formatSameStyle(result + 1, formatted);
    },
    (result, formatted, expr) => {
      // Used one operand instead of calculating
      const operands = extractNumbers(expr);
      return operands[0] || formatSameStyle(result * 2, formatted);
    },
    (result, formatted, expr) => {
      // Wrong operation (multiply instead of add, etc)
      return formatSameStyle(Math.abs(result * 1.5), formatted);
    }
  ],
  
  probability: [
    (result, formatted, expr) => {
      // Inverted fraction
      if (formatted.includes('/')) {
        const parts = formatted.split('/');
        return `${parts[1]}/${parts[0]}`;
      }
      return formatSameStyle(1 / result, formatted);
    },
    (result, formatted, expr) => {
      // Added instead of multiplied
      const operands = extractProbabilities(expr);
      if (operands.length >= 2) {
        const sum = operands.reduce((a, b) => a + b, 0);
        return toFraction(sum);
      }
      return formatSameStyle(result * 2, formatted);
    },
    (result, formatted, expr) => {
      // Forgot "without replacement" adjustment
      return formatSameStyle(result * 1.2, formatted);
    },
    (result, formatted, expr) => {
      // Used wrong total
      return formatSameStyle(result * 0.8, formatted);
    }
  ],
  
  algebra: [
    (result, formatted, expr) => {
      // Sign error
      return formatSameStyle(-result, formatted);
    },
    (result, formatted, expr) => {
      // Reciprocal
      if (result !== 0) {
        return formatSameStyle(1 / result, formatted);
      }
      return formatSameStyle(result + 1, formatted);
    },
    (result, formatted, expr) => {
      // Squared instead
      return formatSameStyle(result * result, formatted);
    },
    (result, formatted, expr) => {
      // Forgot to divide/multiply
      return formatSameStyle(result / 2, formatted);
    }
  ],
  
  physics_formula: [
    (result, formatted, expr) => {
      // Inverted formula (a = F/m instead of F = ma)
      if (result !== 0) {
        return formatSameStyle(1 / result, formatted);
      }
      return formatSameStyle(result * 2, formatted);
    },
    (result, formatted, expr) => {
      // Wrong operation
      return formatSameStyle(result * 2, formatted);
    },
    (result, formatted, expr) => {
      // Forgot units conversion
      return formatSameStyle(result * 10, formatted);
    },
    (result, formatted, expr) => {
      // Used wrong value from problem
      return formatSameStyle(result * 0.5, formatted);
    }
  ],
  
  percentage: [
    (result, formatted, expr) => {
      // Forgot to multiply/divide by 100
      return formatSameStyle(result * 100, formatted);
    },
    (result, formatted, expr) => {
      // Used decimal instead of percentage
      return formatSameStyle(result / 100, formatted);
    },
    (result, formatted, expr) => {
      // Off by small amount
      return formatSameStyle(result + 5, formatted);
    },
    (result, formatted, expr) => {
      // Calculation error
      return formatSameStyle(result * 1.1, formatted);
    }
  ]
};

/**
 * Extract numbers from an expression
 */
function extractNumbers(expr) {
  const matches = expr.match(/\d+\.?\d*/g);
  return matches ? matches.map(parseFloat) : [];
}

/**
 * Extract probabilities (fractions) from expression
 */
function extractProbabilities(expr) {
  const fractionRegex = /\((\d+)\/(\d+)\)/g;
  const matches = [];
  let match;
  
  while ((match = fractionRegex.exec(expr)) !== null) {
    matches.push(parseFloat(match[1]) / parseFloat(match[2]));
  }
  
  return matches;
}

/**
 * Format a number in the same style as the formatted answer
 */
function formatSameStyle(value, referenceFormat) {
  // If reference is a fraction, return as fraction
  if (referenceFormat.includes('/')) {
    return toFraction(value);
  }
  
  // If reference is an integer, return as integer
  if (!referenceFormat.includes('.')) {
    return Math.round(value).toString();
  }
  
  // Match decimal places
  const decimalPlaces = (referenceFormat.split('.')[1] || '').length;
  return value.toFixed(decimalPlaces);
}

/**
 * Convert decimal to fraction string
 */
function toFraction(decimal) {
  const tolerance = 1.0E-6;
  let h1 = 1, h2 = 0, k1 = 0, k2 = 1;
  let b = Math.abs(decimal);
  const sign = decimal < 0 ? '-' : '';
  
  do {
    const a = Math.floor(b);
    let aux = h1;
    h1 = a * h1 + h2;
    h2 = aux;
    aux = k1;
    k1 = a * k1 + k2;
    k2 = aux;
    b = 1 / (b - a);
  } while (Math.abs(Math.abs(decimal) - h1 / k1) > Math.abs(decimal) * tolerance && k1 <= 100);
  
  if (k1 <= 100) {
    // If denominator is 1, just return the numerator
    if (k1 === 1) return sign + h1.toString();
    if (h1 === k1) return sign + h1.toString();
    return sign + `${h1}/${k1}`;
  }
  
  return decimal.toFixed(4).replace(/\.?0+$/, '');
}

/**
 * Shuffle array using Fisher-Yates algorithm
 */
function shuffle(array) {
  const arr = [...array];
  for (let i = arr.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [arr[i], arr[j]] = [arr[j], arr[i]];
  }
  return arr;
}

/**
 * Main function: Generate multiple choice options
 */
function generateOptions(result, formatted, type, expression, subject) {
  console.log(`📊 Generating options for ${type}:`, formatted);
  
  // Get appropriate strategies for this type
  const strategies = DISTRACTOR_STRATEGIES[type] || DISTRACTOR_STRATEGIES.arithmetic;
  
  // Generate wrong answers using strategies
  const wrongAnswers = [];
  const seen = new Set([formatted]);
  
  for (const strategy of strategies) {
    try {
      const distractor = strategy(result, formatted, expression);
      
      // Ensure uniqueness and not the correct answer
      if (distractor && !seen.has(distractor)) {
        wrongAnswers.push(distractor);
        seen.add(distractor);
      }
      
      // We need exactly 3 wrong answers
      if (wrongAnswers.length >= 3) {
        break;
      }
    } catch (error) {
      console.error('Error generating distractor:', error.message);
    }
  }
  
  // If we don't have enough wrong answers, generate some generic ones
  while (wrongAnswers.length < 3) {
    const multiplier = 1 + (Math.random() - 0.5) * 0.3; // ±15%
    const generic = formatSameStyle(result * multiplier, formatted);
    if (!seen.has(generic)) {
      wrongAnswers.push(generic);
      seen.add(generic);
    }
  }
  
  // Take only first 3 wrong answers
  const finalWrongAnswers = wrongAnswers.slice(0, 3);
  
  // Combine correct and wrong answers
  const allOptions = [formatted, ...finalWrongAnswers];
  
  console.log('✅ Generated options:', allOptions);
  
  return {
    correct: formatted,
    distractors: finalWrongAnswers,
    all: allOptions,
    shuffled: shuffle(allOptions)
  };
}

module.exports = {
  generateOptions,
  DISTRACTOR_STRATEGIES,
  toFraction,
  formatSameStyle
};

