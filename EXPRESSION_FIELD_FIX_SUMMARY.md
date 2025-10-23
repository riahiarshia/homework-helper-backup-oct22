# Expression Field Fix Summary

## Problem
The `expression` field was missing from API responses, even though:
- The calculation engine was built and working
- OpenAI prompt was updated to require it
- Fallback extraction was implemented

## Root Cause
**JavaScript JSON serialization omits `undefined` fields!**

When `step.expression` was `undefined`, it was completely omitted from the JSON response, even though we were trying to include it.

## Solution
Changed this:
```javascript
return {
  question: step.question,
  expression: step.expression  // If undefined, omitted from JSON!
};
```

To this:
```javascript
return {
  question: step.question,
  expression: step.expression || null  // Always included, even if null
};
```

## Why This Matters
With this fix:
- ✅ `expression` field will ALWAYS appear in responses
- ✅ If OpenAI provides it: `"expression": "3 + 4"`
- ✅ If fallback extracts it: `"expression": "3 + 4"`
- ✅ If neither works: `"expression": null` (visible, not missing)

This allows us to:
1. **See** when expressions are being provided/extracted
2. **Debug** why they might not be triggering
3. **Track** calculation engine usage vs AI guessing

## Files Modified
- `services/calculationEngine.js` - Line 252: Added `|| null` to ensure expression is never undefined
- Added logging to show when expression is missing

## Testing After Deployment
After the next deployment, the response should look like:
```json
{
  "question": "Problem 1: What is 3 + 4?",
  "expression": "3 + 4",  ← THIS SHOULD NOW APPEAR!
  "options": ["6", "7", "8", "9"],
  "correctAnswer": "7"
}
```

Or at minimum:
```json
{
  "expression": null  ← At least we can SEE it exists (but extraction failed)
}
```

