/**
 * AUTOMATED K-12 QA TEST SUITE
 * 
 * Runs comprehensive tests against the backend API
 * Tests all subjects, grades K-12, with automated scoring
 * 
 * Usage: node tests/automated-qa-tests.js
 */

const axios = require('axios');
const fs = require('fs');
const path = require('path');

// Configuration
const CONFIG = {
  apiUrl: process.env.API_URL || 'https://homework-helper-api.azurewebsites.net',
  testUserId: 'test-user-qa-automated',
  testDeviceId: 'test-device-qa-automated',
  gradeLevel: '6th grade', // Will be updated per test
  outputDir: path.join(__dirname, '../test-results'),
  logFile: path.join(__dirname, '../test-results/qa-test-results.json'),
  reportFile: path.join(__dirname, '../test-results/QA_FINAL_REPORT.md')
};

// Ensure output directory exists
if (!fs.existsSync(CONFIG.outputDir)) {
  fs.mkdirSync(CONFIG.outputDir, { recursive: true });
}

// Test data structure
const TEST_SUITE = {
  mathematics: {
    'K-2': [
      {
        id: '1A',
        problem: 'If you have 3 apples and get 5 more apples, how many apples do you have?',
        expectedAnswer: '8',
        expectedSteps: 2,
        topic: 'Basic Addition',
        correctAnswerVariants: ['8', '8 apples', 'eight']
      },
      {
        id: '1B',
        problem: 'Count by tens: 10, 20, 30, __, 50. What number goes in the blank?',
        expectedAnswer: '40',
        expectedSteps: 2,
        topic: 'Counting by 10s',
        correctAnswerVariants: ['40', 'forty']
      },
      {
        id: '1C',
        problem: 'Sara has 9 crayons. She gives 4 to her friend. How many crayons does Sara have left?',
        expectedAnswer: '5',
        expectedSteps: 2,
        topic: 'Simple Subtraction',
        correctAnswerVariants: ['5', '5 crayons', 'five']
      },
      {
        id: '1D',
        problem: 'How many sides does a triangle have?',
        expectedAnswer: '3',
        expectedSteps: 1,
        topic: 'Shape Recognition',
        correctAnswerVariants: ['3', 'three', '3 sides']
      }
    ],
    '3-5': [
      {
        id: '2A',
        problem: 'A box has 6 rows of eggs with 5 eggs in each row. How many eggs are in the box?',
        expectedAnswer: '30',
        expectedSteps: 3,
        topic: 'Multiplication Word Problem',
        correctAnswerVariants: ['30', '30 eggs', 'thirty']
      },
      {
        id: '2B',
        problem: 'Which fraction is equivalent to 1/2? Options: 1/4, 2/4, 3/4, 4/8',
        expectedAnswer: '2/4',
        expectedSteps: 3,
        topic: 'Fraction Equivalence',
        correctAnswerVariants: ['2/4', '4/8', '½']
      },
      {
        id: '2C',
        problem: 'A rectangle is 8 meters long and 3 meters wide. What is its perimeter?',
        expectedAnswer: '22',
        expectedSteps: 4,
        topic: 'Perimeter Calculation',
        correctAnswerVariants: ['22', '22 m', '22 meters', 'twenty-two']
      },
      {
        id: '2D',
        problem: 'If 23 cookies are shared equally among 4 friends, how many cookies does each friend get, and how many are left over?',
        expectedAnswer: '5 remainder 3',
        expectedSteps: 4,
        topic: 'Division with Remainder',
        correctAnswerVariants: ['5 remainder 3', '5 R3', '5 r 3']
      }
    ],
    '6-8': [
      {
        id: '3A',
        problem: 'Simplify: 3x + 5x - 2x',
        expectedAnswer: '6x',
        expectedSteps: 3,
        topic: 'Algebraic Expression',
        correctAnswerVariants: ['6x', '6 x']
      },
      {
        id: '3B',
        problem: 'What is 25% of 80?',
        expectedAnswer: '20',
        expectedSteps: 3,
        topic: 'Percentage Calculation',
        correctAnswerVariants: ['20', 'twenty']
      },
      {
        id: '3C',
        problem: 'A right triangle has legs of 3 cm and 4 cm. What is the length of the hypotenuse?',
        expectedAnswer: '5',
        expectedSteps: 4,
        topic: 'Pythagorean Theorem',
        correctAnswerVariants: ['5', '5 cm', 'five']
      },
      {
        id: '3D',
        problem: 'The ratio of boys to girls in a class is 3:5. If there are 15 girls, how many boys are there?',
        expectedAnswer: '9',
        expectedSteps: 4,
        topic: 'Ratio Problem',
        correctAnswerVariants: ['9', '9 boys', 'nine']
      }
    ],
    '9-10': [
      {
        id: '4A',
        problem: 'Solve for x: 2x + 7 = 19',
        expectedAnswer: 'x = 6',
        expectedSteps: 4,
        topic: 'Solving Linear Equations',
        correctAnswerVariants: ['x = 6', '6', 'x=6']
      },
      {
        id: '4B',
        problem: 'Factor: x² + 5x + 6',
        expectedAnswer: '(x + 2)(x + 3)',
        expectedSteps: 4,
        topic: 'Quadratic Factoring',
        correctAnswerVariants: ['(x + 2)(x + 3)', '(x+2)(x+3)', '(x + 3)(x + 2)']
      },
      {
        id: '4C',
        problem: 'Solve the system: x + y = 10 and x - y = 4',
        expectedAnswer: 'x = 7, y = 3',
        expectedSteps: 5,
        topic: 'System of Equations',
        correctAnswerVariants: ['x = 7, y = 3', 'x=7, y=3', '(7, 3)']
      },
      {
        id: '4D',
        problem: 'If f(x) = 2x² - 3x + 1, find f(3)',
        expectedAnswer: '10',
        expectedSteps: 3,
        topic: 'Function Evaluation',
        correctAnswerVariants: ['10', 'ten']
      }
    ],
    '11-12': [
      {
        id: '5A',
        problem: 'If sin(θ) = 0.5 and 0° < θ < 90°, what is θ?',
        expectedAnswer: '30°',
        expectedSteps: 3,
        topic: 'Trigonometry',
        correctAnswerVariants: ['30°', '30', '30 degrees']
      },
      {
        id: '5B',
        problem: 'Solve for x: log₂(x) = 5',
        expectedAnswer: '32',
        expectedSteps: 3,
        topic: 'Logarithms',
        correctAnswerVariants: ['32', 'thirty-two']
      },
      {
        id: '5C',
        problem: 'Find the derivative of f(x) = 3x² + 4x - 5',
        expectedAnswer: '6x + 4',
        expectedSteps: 4,
        topic: 'Derivatives (Calculus)',
        correctAnswerVariants: ['6x + 4', '6x+4', "f'(x) = 6x + 4"]
      },
      {
        id: '5D',
        problem: 'What is the probability of rolling a sum of 7 with two fair dice?',
        expectedAnswer: '1/6',
        expectedSteps: 5,
        topic: 'Probability',
        correctAnswerVariants: ['1/6', '0.167', '16.67%']
      }
    ]
  },
  science: {
    '9-10': [
      {
        id: '9A',
        problem: 'A car accelerates from rest at 3 m/s² for 5 seconds. What is its final velocity?',
        expectedAnswer: '15',
        expectedSteps: 3,
        topic: 'Physics - Kinematics',
        correctAnswerVariants: ['15', '15 m/s', 'fifteen']
      }
    ],
    '11-12': [
      {
        id: '10A',
        problem: 'A projectile is launched from a 50 m building with velocity 20 m/s. Find the time it hits the ground.',
        expectedAnswer: '5.8',
        expectedSteps: 5,
        topic: 'Physics - Projectile Motion',
        correctAnswerVariants: ['5.8', '5.8 s', '5.83', '5.83 s', '5.8 seconds'],
        critical: true, // This is our critical test!
        validatorExpected: true
      },
      {
        id: '10D',
        problem: 'A circuit has 10 V and 2 A of current. What is the resistance?',
        expectedAnswer: '5',
        expectedSteps: 3,
        topic: 'Physics - Ohms Law',
        correctAnswerVariants: ['5', '5 Ω', '5 ohms', 'five'],
        validatorExpected: true
      }
    ]
  }
};

// Evaluation functions
function normalizeAnswer(answer) {
  if (!answer) return '';
  // Remove special characters, normalize spaces, handle degree symbols
  return answer.toString()
    .toLowerCase()
    .trim()
    .replace(/°/g, '') // Remove degree symbols
    .replace(/θ/g, 'theta') // Normalize theta
    .replace(/[^\w\s.\/\-\+\(\)]/g, '') // Keep only alphanumeric, spaces, and basic math symbols
    .replace(/\s+/g, ' '); // Normalize spaces
}

function isAnswerCorrect(actualAnswer, expectedVariants) {
  const normalized = normalizeAnswer(actualAnswer);
  return expectedVariants.some(variant => {
    const normalizedVariant = normalizeAnswer(variant);
    return normalized.includes(normalizedVariant) || normalizedVariant.includes(normalized);
  });
}

function scoreTest(testCase, apiResponse, logs) {
  const scores = {
    understanding: 0,
    correctness: 0,
    reasoning: 0,
    hintQuality: 0,
    gradeFit: 0,
    clarity: 0
  };

  // 1. Understanding (0-20)
  if (apiResponse.subject) {
    scores.understanding += 10; // Identified subject
  }
  if (apiResponse.steps && apiResponse.steps.length > 0) {
    scores.understanding += 10; // Generated steps
  }

  // 2. Correctness (0-30) - MOST IMPORTANT
  const finalAnswer = apiResponse.steps?.[apiResponse.steps.length - 1]?.correctAnswer || '';
  const isCorrect = isAnswerCorrect(finalAnswer, testCase.correctAnswerVariants);
  
  if (isCorrect) {
    scores.correctness = 30; // Perfect score
  } else {
    // Check if answer is close (for numerical answers)
    const expected = parseFloat(testCase.expectedAnswer);
    const actual = parseFloat(finalAnswer);
    if (!isNaN(expected) && !isNaN(actual)) {
      const percentError = Math.abs((actual - expected) / expected) * 100;
      if (percentError < 5) scores.correctness = 25; // Within 5%
      else if (percentError < 10) scores.correctness = 20; // Within 10%
      else if (percentError < 20) scores.correctness = 10; // Within 20%
    }
  }

  // 3. Reasoning (0-20)
  if (apiResponse.steps && apiResponse.steps.length >= testCase.expectedSteps - 1) {
    scores.reasoning += 10; // Right number of steps
  }
  if (apiResponse.steps && apiResponse.steps.every(s => s.explanation)) {
    scores.reasoning += 10; // All steps have explanations
  }

  // 4. Hint Quality (0-15)
  if (apiResponse.steps && apiResponse.steps.every(s => s.options && s.options.length > 0)) {
    scores.hintQuality += 8; // Has multiple choice options
  }
  if (apiResponse.steps && apiResponse.steps[0]?.explanation) {
    scores.hintQuality += 7; // First step has guidance
  }

  // 5. Grade Fit (0-10)
  scores.gradeFit = 10; // Default assume appropriate (hard to assess automatically)

  // 6. Clarity (0-5)
  if (apiResponse.steps && apiResponse.steps.every(s => s.question && s.explanation)) {
    scores.clarity = 5; // All steps have clear questions and explanations
  }

  const total = Object.values(scores).reduce((sum, score) => sum + score, 0);

  // Determine pass/fail
  let status = 'FAIL';
  if (total >= 90) status = 'EXCELLENT';
  else if (total >= 75) status = 'PASS';
  else if (total >= 60) status = 'MARGINAL';

  return {
    scores,
    total,
    status,
    isCorrect,
    actualAnswer: finalAnswer,
    validatorActive: logs?.includes('Universal Physics Validator') || 
                     logs?.includes('Universal Math Validator') || 
                     logs?.includes('Chemistry/Physics Validator')
  };
}

// API call function
async function callTutoringAPI(problem, gradeLevel) {
  try {
    const response = await axios.post(
      `${CONFIG.apiUrl}/api/tutoring/session/start-text`,
      {
        userId: CONFIG.testUserId,
        deviceId: CONFIG.testDeviceId,
        problemText: problem,
        userGradeLevel: gradeLevel
      },
      {
        headers: {
          'Content-Type': 'application/json'
        },
        timeout: 60000 // 60 second timeout
      }
    );

    return {
      success: true,
      data: response.data,
      logs: response.data.debug || ''
    };
  } catch (error) {
    console.error(`❌ API Error: ${error.message}`);
    return {
      success: false,
      error: error.message,
      data: null,
      logs: ''
    };
  }
}

// Run single test
async function runTest(testCase, gradeLevel, subject) {
  console.log(`\n🧪 Testing ${testCase.id}: ${testCase.topic}`);
  console.log(`   Problem: ${testCase.problem.substring(0, 60)}...`);
  
  const startTime = Date.now();
  const result = await callTutoringAPI(testCase.problem, gradeLevel);
  const duration = Date.now() - startTime;

  if (!result.success) {
    return {
      testId: testCase.id,
      subject,
      gradeLevel,
      topic: testCase.topic,
      status: 'ERROR',
      error: result.error,
      duration
    };
  }

  const score = scoreTest(testCase, result.data, result.logs);

  console.log(`   ✅ Completed in ${duration}ms`);
  console.log(`   Score: ${score.total}/100 (${score.status})`);
  console.log(`   Answer: ${score.actualAnswer} (Expected: ${testCase.expectedAnswer})`);
  console.log(`   Correct: ${score.isCorrect ? '✅' : '❌'}`);
  if (testCase.validatorExpected) {
    console.log(`   Validator: ${score.validatorActive ? '✅ Active' : '❌ Not detected'}`);
  }

  return {
    testId: testCase.id,
    subject,
    gradeLevel,
    topic: testCase.topic,
    problem: testCase.problem,
    expectedAnswer: testCase.expectedAnswer,
    actualAnswer: score.actualAnswer,
    isCorrect: score.isCorrect,
    scores: score.scores,
    totalScore: score.total,
    status: score.status,
    validatorActive: score.validatorActive,
    validatorExpected: testCase.validatorExpected || false,
    critical: testCase.critical || false,
    duration,
    timestamp: new Date().toISOString()
  };
}

// Run all tests
async function runAllTests() {
  console.log('🚀 STARTING AUTOMATED K-12 QA TESTING');
  console.log('=' .repeat(60));
  
  const results = [];
  let totalTests = 0;
  let passedTests = 0;
  let failedTests = 0;

  // Count total tests
  for (const subject in TEST_SUITE) {
    for (const grade in TEST_SUITE[subject]) {
      totalTests += TEST_SUITE[subject][grade].length;
    }
  }

  console.log(`📊 Total tests to run: ${totalTests}\n`);

  // Run tests by subject and grade
  for (const subject in TEST_SUITE) {
    console.log(`\n${'='.repeat(60)}`);
    console.log(`📚 SUBJECT: ${subject.toUpperCase()}`);
    console.log('='.repeat(60));

    for (const gradeLevel in TEST_SUITE[subject]) {
      console.log(`\n📊 Grade Band: ${gradeLevel}`);
      
      const tests = TEST_SUITE[subject][gradeLevel];
      
      for (const testCase of tests) {
        const result = await runTest(testCase, gradeLevel, subject);
        results.push(result);

        if (result.status === 'EXCELLENT' || result.status === 'PASS') {
          passedTests++;
        } else {
          failedTests++;
        }

        // Add delay between tests to avoid rate limiting
        await new Promise(resolve => setTimeout(resolve, 2000));
      }
    }
  }

  // Save results
  fs.writeFileSync(CONFIG.logFile, JSON.stringify(results, null, 2));
  console.log(`\n💾 Results saved to: ${CONFIG.logFile}`);

  // Generate report
  generateReport(results, { total: totalTests, passed: passedTests, failed: failedTests });

  return results;
}

// Generate markdown report
function generateReport(results, summary) {
  const report = [];
  
  report.push('# 📊 AUTOMATED K-12 QA TEST RESULTS\n');
  report.push(`**Date:** ${new Date().toLocaleString()}`);
  report.push(`**API:** ${CONFIG.apiUrl}`);
  report.push(`**Total Tests:** ${summary.total}`);
  report.push(`**Passed:** ${summary.passed} (${((summary.passed/summary.total)*100).toFixed(1)}%)`);
  report.push(`**Failed:** ${summary.failed} (${((summary.failed/summary.total)*100).toFixed(1)}%)\n`);
  report.push('---\n');

  // Summary table
  report.push('## 📈 SUMMARY BY SUBJECT\n');
  report.push('| Subject | Total | Passed | Failed | Pass Rate | Avg Score |');
  report.push('|---------|-------|--------|--------|-----------|-----------|');

  const bySubject = {};
  results.forEach(r => {
    if (!bySubject[r.subject]) {
      bySubject[r.subject] = { total: 0, passed: 0, failed: 0, scores: [] };
    }
    bySubject[r.subject].total++;
    if (r.status === 'EXCELLENT' || r.status === 'PASS') bySubject[r.subject].passed++;
    else bySubject[r.subject].failed++;
    bySubject[r.subject].scores.push(r.totalScore);
  });

  for (const subject in bySubject) {
    const data = bySubject[subject];
    const passRate = ((data.passed / data.total) * 100).toFixed(1);
    const avgScore = (data.scores.reduce((a,b) => a+b, 0) / data.scores.length).toFixed(1);
    report.push(`| ${subject} | ${data.total} | ${data.passed} | ${data.failed} | ${passRate}% | ${avgScore} |`);
  }

  report.push('\n---\n');

  // Detailed results
  report.push('## 📋 DETAILED TEST RESULTS\n');

  results.forEach(result => {
    const icon = result.isCorrect ? '✅' : '❌';
    report.push(`### ${icon} Test ${result.testId}: ${result.topic}`);
    report.push(`**Grade:** ${result.gradeLevel} | **Subject:** ${result.subject} | **Score:** ${result.totalScore}/100 | **Status:** ${result.status}\n`);
    report.push(`**Problem:** ${result.problem}\n`);
    report.push(`**Expected Answer:** ${result.expectedAnswer}`);
    report.push(`**Actual Answer:** ${result.actualAnswer}`);
    report.push(`**Correct:** ${result.isCorrect ? 'YES ✅' : 'NO ❌'}\n`);
    
    if (result.validatorExpected) {
      report.push(`**Validator Expected:** YES`);
      report.push(`**Validator Active:** ${result.validatorActive ? 'YES ✅' : 'NO ❌'}\n`);
    }

    report.push(`**Scoring Breakdown:**`);
    report.push(`- Understanding: ${result.scores.understanding}/20`);
    report.push(`- Correctness: ${result.scores.correctness}/30`);
    report.push(`- Reasoning: ${result.scores.reasoning}/20`);
    report.push(`- Hint Quality: ${result.scores.hintQuality}/15`);
    report.push(`- Grade Fit: ${result.scores.gradeFit}/10`);
    report.push(`- Clarity: ${result.scores.clarity}/5\n`);
    report.push(`**Duration:** ${result.duration}ms\n`);
    report.push('---\n');
  });

  // Critical findings
  report.push('## 🚨 CRITICAL FINDINGS\n');
  
  const criticalTests = results.filter(r => r.critical);
  if (criticalTests.length > 0) {
    report.push('### Critical Tests (Must Pass):\n');
    criticalTests.forEach(r => {
      const status = r.isCorrect && r.validatorActive ? '✅ PASS' : '❌ FAIL';
      report.push(`- **Test ${r.testId}** (${r.topic}): ${status}`);
      if (!r.isCorrect) report.push(`  - ❌ Wrong answer: ${r.actualAnswer} (expected: ${r.expectedAnswer})`);
      if (r.validatorExpected && !r.validatorActive) report.push(`  - ⚠️ Validator not active`);
    });
    report.push('\n');
  }

  const validatorIssues = results.filter(r => r.validatorExpected && !r.validatorActive);
  if (validatorIssues.length > 0) {
    report.push('### ⚠️ Validator Issues:\n');
    validatorIssues.forEach(r => {
      report.push(`- **Test ${r.testId}**: Validator expected but not detected`);
    });
    report.push('\n');
  }

  // Write report
  fs.writeFileSync(CONFIG.reportFile, report.join('\n'));
  console.log(`\n📄 Report generated: ${CONFIG.reportFile}`);
}

// Main execution
async function main() {
  try {
    const results = await runAllTests();
    
    console.log('\n' + '='.repeat(60));
    console.log('✅ TESTING COMPLETE!');
    console.log('='.repeat(60));
    console.log(`📊 Results: ${CONFIG.logFile}`);
    console.log(`📄 Report: ${CONFIG.reportFile}`);
    
    process.exit(0);
  } catch (error) {
    console.error('\n❌ Testing failed:', error);
    process.exit(1);
  }
}

// Run if called directly
if (require.main === module) {
  main();
}

module.exports = { runAllTests, runTest, TEST_SUITE };

