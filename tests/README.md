# 🤖 AUTOMATED K-12 QA TESTING SYSTEM

Comprehensive automated testing system that tests all grades (K-12) and subjects through the backend API with Azure log stream monitoring.

---

## 🎯 **WHAT THIS DOES**

### **3-in-1 Testing System:**
1. ✅ **API Response Testing** - Validates answers, steps, hints
2. ✅ **Azure Log Monitoring** - Captures validator activity in real-time
3. ✅ **Automated Analysis** - Scores tests and generates reports

### **Coverage:**
- **26 test cases** across all subjects (Math, Science, Physics)
- **All grade levels** (K-2, 3-5, 6-8, 9-10, 11-12)
- **Validator verification** (checks if validators are actually running)
- **Consistency checking** (can run multiple times)

---

## 🚀 **QUICK START (One Command!)**

```bash
cd /Users/ar616n/Documents/ios-app/backup-restore/tests
./run-automated-tests.sh
```

That's it! The script will:
1. ✅ Start Azure log stream monitoring
2. ✅ Run all 26 automated tests
3. ✅ Capture both API responses and Azure logs
4. ✅ Analyze validator activity
5. ✅ Generate comprehensive reports

**Time:** ~2-3 minutes  
**Cost:** ~$0.20 (OpenAI API calls)

---

## 📊 **WHAT YOU GET**

### **After running, you'll have 5 files in `test-results/`:**

1. **`QA_FINAL_REPORT.md`** - Main test report
   - Summary statistics
   - Pass/fail rates by subject
   - Detailed test results
   - Critical findings

2. **`qa-test-results.json`** - Raw test data (JSON)
   - All test inputs and outputs
   - Scores and timing
   - Can be parsed for further analysis

3. **`azure-logs-YYYYMMDD_HHMMSS.log`** - Full Azure logs
   - Every line from Azure during testing
   - Shows validator activity
   - Useful for debugging

4. **`test-output-YYYYMMDD_HHMMSS.log`** - Test execution log
   - What the test script printed
   - Progress and errors

5. **`validator-analysis-YYYYMMDD_HHMMSS.txt`** - Validator report
   - Which validators ran
   - How many times
   - Which corrections were made
   - **THIS IS KEY!**

---

## 🔍 **VERIFYING VALIDATORS ARE WORKING**

### **Check `validator-analysis-YYYYMMDD_HHMMSS.txt`:**

```
🔬 Universal Physics Validator:
  ✅ DETECTED
  Activations: 2
  ✅ Value extraction working
  📐 Kinematics values: h₀=50m, v₀=20m/s, g=9.8m/s²
  ✅ Corrections made
  Corrections count: 2
  🔧 Step 1: Time 5.0s → 5.8s
```

This tells you:
- ✅ Validator is running
- ✅ It's extracting values correctly
- ✅ It's making corrections

### **If you see:**
```
🔬 Universal Physics Validator:
  ❌ NOT DETECTED
```

Then the validator isn't running and we need to debug!

---

## 📋 **DETAILED USAGE**

### **Option 1: Full Automated Run (Recommended)**
```bash
./run-automated-tests.sh
```
- Runs all 26 tests
- Monitors Azure logs
- Generates all reports
- Takes ~2-3 minutes

### **Option 2: Manual Testing (Advanced)**
```bash
# 1. Start log monitoring manually
az webapp log tail --resource-group homework-helper-rg-f --name homework-helper-api > logs.txt &

# 2. Run tests
node automated-qa-tests.js

# 3. Stop log monitoring
kill %1
```

### **Option 3: Single Test (Debugging)**
```javascript
// In Node REPL or script
const { runTest, TEST_SUITE } = require('./automated-qa-tests');

// Test the critical projectile problem
const test = TEST_SUITE.science['11-12'][0]; // Test 10A
const result = await runTest(test, '11-12', 'science');
console.log(result);
```

---

## 🧪 **TEST CASES INCLUDED**

### **Mathematics (16 tests):**
- K-2: Basic addition, counting, subtraction, shapes
- 3-5: Multiplication, fractions, perimeter, division
- 6-8: Algebra, percentages, Pythagorean theorem, ratios
- 9-10: Linear equations, factoring, systems, functions
- 11-12: Trigonometry, logarithms, calculus, probability

### **Science (2 tests):**
- 9-10: Physics kinematics (acceleration)
- 11-12: Physics projectile motion ⭐, Ohm's Law

### **Critical Tests:**
- ⭐ **Test 10A** (Projectile Motion): The one we've been working on!
  - Expected answer: 5.8 seconds
  - Validator must be active
  - Must extract h₀=50m, v₀=20m/s
  - Must correct 5.0s → 5.8s

---

## 📈 **UNDERSTANDING THE RESULTS**

### **Test Scoring (0-100 points):**
- **Understanding** (20): Did AI understand the question?
- **Correctness** (30): Is the answer right? ⭐ MOST IMPORTANT
- **Reasoning** (20): Are steps logical?
- **Hint Quality** (15): Are hints helpful?
- **Grade Fit** (10): Is difficulty appropriate?
- **Clarity** (5): Is language clear?

### **Status:**
- **EXCELLENT** (90-100): ✅ Perfect
- **PASS** (75-89): ✅ Good
- **MARGINAL** (60-74): ⚠️ Needs review
- **FAIL** (<60): ❌ Not acceptable

### **Example Result:**
```
✅ Test 10A: Physics - Projectile Motion
   Score: 95/100 (EXCELLENT)
   Answer: 5.8 s (Expected: 5.8 s)
   Correct: YES ✅
   Validator: ACTIVE ✅
   Scoring:
     - Understanding: 20/20
     - Correctness: 30/30  ← Perfect!
     - Reasoning: 20/20
     - Hint Quality: 15/15
     - Grade Fit: 10/10
     - Clarity: 5/5
```

---

## 🚨 **TROUBLESHOOTING**

### **Problem: "Azure CLI not found"**
**Solution:**
```bash
# macOS
brew install azure-cli

# Linux
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Windows
winget install Microsoft.AzureCLI
```

### **Problem: "Not logged in to Azure"**
**Solution:**
```bash
az login
```

### **Problem: "Validator not detected"**
**Solutions:**
1. Check if Azure app is running latest code
2. Restart Azure app:
   ```bash
   az webapp restart --name homework-helper-api --resource-group homework-helper-rg-f
   ```
3. Wait 30 seconds, then run tests again

### **Problem: "Module not found: axios"**
**Solution:**
```bash
cd /Users/ar616n/Documents/ios-app/backup-restore
npm install
```

### **Problem: "Tests timing out"**
**Solution:**
- Azure might be cold-starting
- Run once to warm up, then run again
- Or increase timeout in automated-qa-tests.js (line 243)

---

## 🎯 **WHAT TO LOOK FOR IN RESULTS**

### **✅ SUCCESS INDICATORS:**
1. **Overall pass rate ≥75%**
2. **Math tests ≥90%** (validators should help)
3. **Physics Test 10A = PASS** with validator active
4. **Validator analysis shows activations**
5. **No critical failures**

### **❌ FAILURE INDICATORS:**
1. **Physics Test 10A fails** or shows 5.0s instead of 5.8s
2. **Validator analysis shows "NOT DETECTED"**
3. **No corrections made** when they should be
4. **Overall pass rate <60%**
5. **Math tests failing** (validators should catch these)

---

## 📞 **NEXT STEPS AFTER TESTING**

### **If Tests Pass (≥75%):**
1. ✅ Review QA_FINAL_REPORT.md
2. ✅ Check which tests failed
3. ✅ Identify patterns in failures
4. ✅ Plan improvements for weak areas

### **If Tests Fail (<75%):**
1. ❌ Check validator-analysis first
2. ❌ If validators not running → Debug deployment
3. ❌ If validators running but failing → Debug logic
4. ❌ Review Azure logs for errors

### **If Critical Test 10A Fails:**
1. 🚨 Check validator logs immediately
2. 🚨 Verify value extraction working
3. 🚨 Check if corrections being made
4. 🚨 Review regex patterns in openaiService.js

---

## 🔧 **CUSTOMIZATION**

### **Add More Tests:**
Edit `automated-qa-tests.js`, add to `TEST_SUITE`:

```javascript
TEST_SUITE.mathematics['6-8'].push({
  id: '3E',
  problem: 'Your new problem here',
  expectedAnswer: '42',
  expectedSteps: 4,
  topic: 'Your Topic',
  correctAnswerVariants: ['42', 'forty-two']
});
```

### **Change API URL:**
```bash
API_URL=http://localhost:3000 ./run-automated-tests.sh
```

### **Skip Log Monitoring:**
```bash
node automated-qa-tests.js
# (Just run tests, no Azure logs)
```

---

## 📚 **FILES IN THIS DIRECTORY**

- **`automated-qa-tests.js`** - Main test script (Node.js)
- **`run-automated-tests.sh`** - Shell wrapper with log monitoring
- **`README.md`** - This file
- **`tutoring-text.js`** - (Deprecated, endpoint now in tutoring.js)

---

## ✅ **QUICK VERIFICATION**

Want to quickly verify everything works? Run this:

```bash
# 1. Run the tests
./run-automated-tests.sh

# 2. Check if Test 10A passed
grep "Test 10A" test-results/QA_FINAL_REPORT.md

# 3. Check validator activity
cat test-results/latest-validator-analysis.txt

# 4. If you see:
#    - Test 10A: ✅ PASS
#    - Validator: ✅ DETECTED
#    - Corrections: ✅ Made
# Then everything is working!
```

---

## 💡 **PRO TIPS**

1. **Run tests after every deployment** to catch regressions
2. **Save test results** in git for historical tracking
3. **Compare validator-analysis** between runs to ensure consistency
4. **Focus on critical tests first** (Test 10A is the most important!)
5. **Use test results** to prioritize development work

---

## 🎉 **SUMMARY**

**One command:**
```bash
./run-automated-tests.sh
```

**Gets you:**
- ✅ 26 automated tests across all subjects/grades
- ✅ Real Azure log monitoring
- ✅ Validator activity verification
- ✅ Comprehensive reports
- ✅ In 2-3 minutes

**No iOS app needed!** 🎉

---

*For questions or issues, check the Azure logs first, then review the validator analysis.*

