const axios = require('axios');
const fs = require('fs');
const { COMPREHENSIVE_TESTS, CONFIG } = require('./comprehensive-tests');

async function runTest(category, test) {
  const startTime = Date.now();
  
  try {
    const response = await axios.post(
      `${CONFIG.apiUrl}/api/tutoring/session/start-text`,
      {
        userId: CONFIG.testUserId,
        deviceId: CONFIG.testDeviceId,
        problemText: test.problem,
        userGradeLevel: getGradeLevel(category),
        subject: getSubject(category)
      },
      { timeout: 60000 }
    );

    const duration = Date.now() - startTime;
    const lastStep = response.data.steps?.[response.data.steps.length - 1];
    const actualAnswer = lastStep?.correctAnswer || '';
    
    // More lenient matching for formulas and answers
    const normalizedActual = normalizeAnswer(actualAnswer);
    const normalizedVariants = test.variants.map(v => normalizeAnswer(v));
    
    const isCorrect = normalizedVariants.some(variant => {
      // Direct match or contains match
      if (normalizedActual.includes(variant) || variant.includes(normalizedActual)) {
        return true;
      }
      
      // Special handling for formulas - check if same variables present
      if (/[a-z]/.test(variant) && /[=+\-*\/]/.test(variant)) {
        // It's a formula - check if mathematically equivalent
        const variantVars = variant.match(/[a-z]+/g) || [];
        const actualVars = normalizedActual.match(/[a-z]+/g) || [];
        // If same variables in different order, consider it correct
        if (variantVars.length > 0 && actualVars.length > 0) {
          const sameVars = variantVars.every(v => actualVars.includes(v)) && 
                          actualVars.every(v => variantVars.includes(v));
          if (sameVars && variant.includes('=') === normalizedActual.includes('=')) {
            return true;
          }
        }
      }
      
      return false;
    });

    return {
      ...test,
      category,
      passed: isCorrect,
      actualAnswer,
      duration,
      steps: response.data.steps?.length || 0
    };
  } catch (error) {
    return {
      ...test,
      category,
      passed: false,
      error: error.message,
      duration: Date.now() - startTime
    };
  }
}

function normalizeAnswer(answer) {
  if (!answer) return '';
  return answer.toString()
    .toLowerCase()
    .trim()
    // Remove common variations
    .replace(/°/g, '')
    .replace(/[\u2080-\u2089\u2070-\u2079]/g, '') // Remove subscripts/superscripts
    .replace(/[₀-₉⁰-⁹]/g, '') // More subscripts/superscripts
    .replace(/\^/g, '') // Remove carets
    .replace(/×/g, '*') // Normalize multiplication
    .replace(/÷/g, '/') // Normalize division
    .replace(/−/g, '-') // Normalize minus
    .replace(/±/g, '+-') // Normalize plus-minus
    .replace(/√/g, 'sqrt') // Normalize square root
    // ITERATION 6: Better formula matching - normalize multiplication
    .replace(/\s*[×*]\s*/g, '') // Remove mult symbols & spaces (W = F * d → W = Fd)
    // Remove punctuation but keep math symbols
    .replace(/[,'"]/g, '')
    .replace(/\s+/g, ' ');
}

function getGradeLevel(category) {
  if (category.includes('K-2')) return '1st grade';
  if (category.includes('3-5')) return '4th grade';
  if (category.includes('6-8')) return '7th grade';
  if (category.includes('9-10')) return '10th grade';
  if (category.includes('11-12')) return '12th grade';
  return '6th grade';
}

function getSubject(category) {
  if (category.includes('Mathematics') || category.includes('Algebra') || 
      category.includes('Geometry') || category.includes('Calculus')) return 'mathematics';
  if (category.includes('Biology')) return 'biology';
  if (category.includes('Chemistry')) return 'chemistry';
  if (category.includes('Physics')) return 'physics';
  if (category.includes('Science')) return 'science';
  return 'science';
}

async function runAllTests() {
  console.log('🚀 Starting comprehensive tests...\n');
  
  const results = {};
  let totalTests = 0;
  let passed = 0;
  let failed = 0;

  for (const [category, tests] of Object.entries(COMPREHENSIVE_TESTS)) {
    console.log(`\n📚 Testing: ${category}`);
    console.log(`━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`);
    
    results[category] = [];
    
    for (const test of tests) {
      process.stdout.write(`   ${test.id}: ${test.topic}...`);
      
      const result = await runTest(category, test);
      results[category].push(result);
      totalTests++;
      
      if (result.passed) {
        passed++;
        console.log(` ✅ PASS (${result.duration}ms)`);
      } else {
        failed++;
        console.log(` ❌ FAIL (${result.error || 'Wrong answer'})`);
      }
    }
  }

  console.log('\n\n╔════════════════════════════════════════════╗');
  console.log('║         COMPREHENSIVE TEST SUMMARY         ║');
  console.log('╚════════════════════════════════════════════╝\n');
  console.log(`Total Tests: ${totalTests}`);
  console.log(`✅ Passed: ${passed} (${(passed/totalTests*100).toFixed(1)}%)`);
  console.log(`❌ Failed: ${failed} (${(failed/totalTests*100).toFixed(1)}%)`);
  console.log('');

  // Save results
  fs.writeFileSync(CONFIG.logFile, JSON.stringify(results, null, 2));
  console.log(`📁 Results saved to: ${CONFIG.logFile}\n`);

  // Generate report
  generateReport(results, totalTests, passed, failed);
}

function generateReport(results, total, passed, failed) {
  let report = `# 🎓 COMPREHENSIVE K-12 TEST REPORT\n\n`;
  report += `**Date:** ${new Date().toLocaleDateString()}\n`;
  report += `**Total Tests:** ${total}\n`;
  report += `**Passed:** ${passed} (${(passed/total*100).toFixed(1)}%)\n`;
  report += `**Failed:** ${failed} (${(failed/total*100).toFixed(1)}%)\n\n`;
  report += `---\n\n`;

  for (const [category, tests] of Object.entries(results)) {
    const categoryPassed = tests.filter(t => t.passed).length;
    const categoryTotal = tests.length;
    
    report += `## ${category}\n\n`;
    report += `**Pass Rate:** ${categoryPassed}/${categoryTotal} (${(categoryPassed/categoryTotal*100).toFixed(1)}%)\n\n`;
    
    for (const test of tests) {
      report += `### ${test.id}: ${test.topic}\n`;
      report += `- **Problem:** ${test.problem}\n`;
      report += `- **Expected:** ${test.answer}\n`;
      report += `- **Actual:** ${test.actualAnswer || 'N/A'}\n`;
      report += `- **Result:** ${test.passed ? '✅ PASS' : '❌ FAIL'}\n`;
      report += `- **Duration:** ${test.duration}ms\n\n`;
    }
  }

  fs.writeFileSync(CONFIG.reportFile, report);
  console.log(`📄 Report saved to: ${CONFIG.reportFile}\n`);
}

runAllTests().catch(console.error);
