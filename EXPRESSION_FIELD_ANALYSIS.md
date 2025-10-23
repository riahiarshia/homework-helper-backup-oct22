# Expression Field Investigation

## Current Situation
- The calculation engine has been built and deployed
- OpenAI prompt has been updated to require the expression field
- Fallback extraction has been implemented to extract expressions from questions
- The expression field is being preserved in the calculation engine's fallback return
- **BUT:** The expression field is MISSING from the API response

## Test Results
When testing "3 + 4 = ?" the response contains:
```json
{
  "question": "Problem 1: What is 3 + 4?",
  "explanation": "We need to find the sum of 3 and 4.",
  "options": ["6", "7", "8", "9"],
  "correctAnswer": "7"
}
```
**Missing:** `expression` field

## Possible Causes

### 1. OpenAI Not Providing Expression Field ❓
- Despite "MANDATORY" in prompt, OpenAI might be ignoring it
- Need to verify: Is OpenAI actually returning the expression field in its response?

### 2. Fallback Extraction Not Triggering ❓
- Pattern: "Problem 1: What is 3 + 4?"
- Should match Pattern 5: `what\s+is\s+([\d+\-×*/().\s]+)\?`
- Need to verify: Is `isCalculable` returning true? Is extraction working?

### 3. Expression Field Lost During Processing ❓
- The step might be modified with expression, but not propagated to response
- Need to verify: Does `validated.steps[i]` actually contain the expression after `processStep`?

### 4. JSON Serialization Issue ❓
- If `step.expression` is `undefined`, it might be omitted from JSON
- Need to verify: Is `expression: undefined` being filtered out?

## What We Know Works
1. ✅ Calculation engine IS working (correct answers)
2. ✅ Option generation IS working (different options each time)
3. ✅ The route is receiving and sending responses correctly
4. ✅ Other fields (question, explanation, options, correctAnswer) are preserved

## What's NOT Working
1. ❌ Expression field is missing from final response
2. ❌ Can't verify if OpenAI is providing it (no access to raw OpenAI response)
3. ❌ Can't verify if fallback is triggering (no access to backend logs easily)

## Next Steps
Since we can't easily access Azure logs and the debug endpoint isn't working, we need a different approach:

### Option A: Add Expression Field Explicitly
Force the expression field to always exist, even if empty:
```javascript
return {
  question: step.question,
  explanation: step.explanation,
  expression: step.expression || null,  // Always include, even if null
  options: step.options,
  correctAnswer: step.correctAnswer
};
```

### Option B: Modify OpenAI Service to Log to Response
Include debugging info in the actual API response temporarily:
```javascript
res.json({
  ...session,
  _debug: {
    openaiProvidedExpression: !!analysisResult.steps[0].expression,
    afterCalcEngineExpression: !!processed.expression
  }
});
```

### Option C: Check if Subject is Being Passed Correctly
Maybe the issue is that `isCalculable` is returning false because subject doesn't match?
- Need to verify: What subject is being passed to the calculation engine?

## Most Likely Root Cause
Based on the code review, the most likely issue is that OpenAI is NOT providing the expression field, the fallback IS extracting it and modifying `step.expression`, but when the processed step is returned, the expression field is `undefined` and gets filtered out during JSON serialization.

The fix: Ensure the expression field is ALWAYS included in the return object, even if it's null or undefined.

