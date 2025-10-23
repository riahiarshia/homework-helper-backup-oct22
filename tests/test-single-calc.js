/**
 * Single Test - Calculation Engine Verification
 * Tests: "3 + 4 = ?" to verify calculation engine works
 */

const axios = require('axios');

const API_URL = process.env.API_URL || 'https://homework-helper-backup-oct22.azurewebsites.net';
const API_KEY = process.env.OPENAI_API_KEY || process.env.AZURE_OPENAI_KEY;

async function testCalculationEngine() {
  console.log('🧮 SINGLE TEST: Calculation Engine Verification');
  console.log('='.repeat(50));
  console.log('');
  console.log('Test Problem: "3 + 4 = ?"');
  console.log('Expected Answer: "7"');
  console.log('API URL:', API_URL);
  console.log('');
  
  try {
    console.log('⏳ Sending request to backend...');
    
    const response = await axios.post(`${API_URL}/api/validate-answer`, {
      problemText: '3 + 4 = ?',
      userAnswer: '7',
      subject: 'Math',
      gradeLevel: 'K-2'
    }, {
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': API_KEY
      },
      timeout: 30000
    });
    
    console.log('');
    console.log('📥 Response received!');
    console.log('');
    
    if (response.data) {
      const result = response.data;
      
      console.log('━'.repeat(50));
      console.log('RESULT:');
      console.log('━'.repeat(50));
      console.log('Subject:', result.subject || 'N/A');
      console.log('Steps Generated:', result.steps ? result.steps.length : 0);
      console.log('');
      
      if (result.steps && result.steps.length > 0) {
        const step = result.steps[0];
        console.log('First Step:');
        console.log('  Question:', step.question);
        console.log('  Expression:', step.expression || '❌ NOT PROVIDED');
        console.log('  Correct Answer:', step.correctAnswer);
        console.log('  Options:', step.options);
        console.log('');
        
        // Check if calculation engine worked
        if (step.expression) {
          console.log('✅ CALCULATION ENGINE: Expression detected!');
          console.log('   Expression: "' + step.expression + '"');
        } else {
          console.log('❌ CALCULATION ENGINE: No expression field');
        }
        
        console.log('');
        
        // Check if answer is correct
        const answer = step.correctAnswer;
        const isCorrect = answer === '7' || answer === 'seven' || answer.includes('7');
        
        if (isCorrect) {
          console.log('✅ ANSWER CORRECT: "' + answer + '"');
          console.log('');
          console.log('🎉 TEST PASSED! Calculation engine is working!');
        } else {
          console.log('❌ ANSWER WRONG: "' + answer + '"');
          console.log('   Expected: "7"');
          console.log('');
          console.log('❌ TEST FAILED! Calculation engine not working properly');
        }
      } else {
        console.log('❌ No steps generated in response');
      }
      
      console.log('━'.repeat(50));
    }
    
  } catch (error) {
    console.error('❌ ERROR:', error.message);
    if (error.response) {
      console.error('Status:', error.response.status);
      console.error('Data:', error.response.data);
    }
    process.exit(1);
  }
}

testCalculationEngine();

