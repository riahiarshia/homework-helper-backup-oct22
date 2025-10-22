const loggingService = require('./backend/Services/loggingService');

console.log('🧪 Testing logging service with debugging...');

// Test basic logging
console.log('Testing system event logging...');
loggingService.logSystemEvent('Debug Test Event', { test: true, timestamp: new Date().toISOString() });

// Test OpenAI text logging
console.log('Testing OpenAI text logging...');
loggingService.logOpenAIText('This is a test system prompt for debugging', 'system_prompt');
loggingService.logOpenAIText('This is a test user message for debugging', 'user_message');

// Test OpenAI response logging
console.log('Testing OpenAI response logging...');
loggingService.logOpenAIResponse('This is a test response from OpenAI for debugging', 'test_response');

// Test math problem logging
console.log('Testing math problem logging...');
loggingService.logMathProblem({
  userId: 'debug-test-user',
  deviceId: 'debug-test-device',
  problemText: 'Solve 2x + 3 = 7 for debugging',
  analysisResult: { subject: 'Math', difficulty: 'easy', debug: true }
});

console.log('🧪 Debug logging test completed. Check console output and LogFiles/custom/homework-math.log');
