# 🤝 PART 3: COLLABORATIVE TESTING GUIDE

**Date:** October 22, 2025  
**Purpose:** Step-by-step guide for conducting comprehensive K-12 QA testing  
**Roles:** User tests via iOS app, AI analyzes results

---

## 🎯 **TESTING WORKFLOW**

### **Your Role (User):**
1. Submit problems via iOS app (take photos or type)
2. Screenshot iOS results (answers, hints, steps)
3. Share Azure logs for each test
4. Note any issues or observations

### **My Role (AI Assistant):**
1. Analyze Azure logs for validator activity
2. Evaluate correctness and educational quality
3. Score each test using rubric
4. Compile statistics and recommendations

---

## 📋 **TESTING CHECKLIST**

### **✅ Before Starting:**
- [ ] iOS app installed and logged in
- [ ] Azure logs accessible (or willing to share screenshots)
- [ ] Test framework reviewed (Part 2)
- [ ] ~2-3 hours available for testing

### **✅ During Testing:**
- [ ] Test one problem at a time
- [ ] Wait for full response before next test
- [ ] Screenshot each result
- [ ] Copy/paste Azure logs for each test
- [ ] Note any errors or crashes

### **✅ After Testing:**
- [ ] Share all logs and screenshots
- [ ] Provide any observations
- [ ] Review my analysis
- [ ] Discuss findings and next steps

---

## 🧪 **QUICK START: CRITICAL TESTS FIRST**

Before running all 88+ tests, let's verify the system works with **5 critical tests**:

### **Critical Test #1: Math Geometry (Known Working)**
- **Problem:** Test 2C from framework
- **Expected:** ✅ Pass
- **Purpose:** Verify baseline validator works

### **Critical Test #2: Physics Projectile (Recently Fixed)**
- **Problem:** Test 10A from framework
- **Expected:** ⚠️ Pending verification
- **Purpose:** Verify Universal Physics Validator works
- **⭐ THIS IS THE KEY TEST! ⭐**

### **Critical Test #3: Simple K-2 Math**
- **Problem:** Test 1A from framework
- **Expected:** ✅ Pass
- **Purpose:** Verify elementary-level language works

### **Critical Test #4: High School Calculus**
- **Problem:** Test 5C from framework
- **Expected:** ⚠️ Unknown
- **Purpose:** Test upper limit of difficulty

### **Critical Test #5: English Grammar**
- **Problem:** Test 13C from framework
- **Expected:** ⚠️ Unknown
- **Purpose:** Test non-STEM subject

---

## 🚀 **EXECUTION: START HERE**

### **STEP 1: Verify Physics Validator is Working**

**Problem to submit:**
> "A projectile is launched from a 50 m building with velocity 20 m/s. Find the time it hits the ground."

**What to look for in Azure logs:**
```
✅ MUST SEE:
🔬 Universal Physics Validator: Starting...
🎯 Detected: Kinematics problem (projectile/motion)
📐 Kinematics values: h₀=50m, v₀=20m/s, g=9.8m/s²
✅ Calculated correct time: 5.83 seconds
🔧 Step X: Time 5.0s → 5.8s
✅ Universal Physics Validator: Complete

❌ FAILURE IF YOU SEE:
- No "📐 Kinematics values" line
- No "🔧" correction lines
- Final answer still shows 5.0s instead of 5.8s
```

**What to check on iOS:**
- **Correct Answer:** Should be **5.8 seconds** (NOT 5.0 seconds)
- **Steps:** Should show 5-7 steps
- **Options:** Should include "5.8 s" or close to it
- **Equation:** Should show `-50 = 20t - 4.9t²`

**⚠️ IF THIS TEST FAILS:**
- Stop further testing
- Share logs with me
- We need to debug validator first

**✅ IF THIS TEST PASSES:**
- Proceed to Step 2

---

### **STEP 2: Run Critical Tests 1, 3, 4, 5**

Submit each problem from the Quick Start list above.

**For each test, record:**

```
TEST: [Test ID]
PROBLEM: [Full text of problem]
iOS ANSWER: [What app said]
EXPECTED: [From framework]
MATCH: [Yes/No]
SCREENSHOT: [Attach]
AZURE LOGS: [Copy/paste relevant section]
NOTES: [Any observations]
```

**Share results with me after all 5 critical tests.**

---

### **STEP 3: Full Testing (If Critical Tests Pass)**

If all 5 critical tests pass (or show expected behavior), proceed with full testing:

#### **Testing Schedule (Recommended):**

**Session 1: Mathematics (1 hour)**
- Tests 1A-1D (K-2)
- Tests 2A-2D (3-5)
- Tests 3A-3D (6-8)
- Tests 4A-4D (9-10)
- Tests 5A-5D (11-12)
- **Total:** 20 tests

**Session 2: Science (1 hour)**
- Tests 6A-6D (K-2)
- Tests 7A-7D (3-5)
- Tests 8A-8D (6-8)
- Tests 9A-9D (9-10)
- Tests 10A-10D (11-12)
- **Total:** 20 tests

**Session 3: English & Social Studies (45 min)**
- Tests 11A-11D (K-2 English)
- Tests 12A-12D (3-5 English)
- Tests 13A-13D (6-8 English)
- Tests 14A-14D (9-12 English)
- Tests 15A-15D (3-5 Social Studies)
- Tests 16A-16D (6-8 Social Studies)
- Tests 17A-17D (9-12 Social Studies)
- **Total:** 28 tests

**Session 4 (Optional): Logic/CS (15 min)**
- Tests 18A-18D (6-8)
- Tests 19A-19D (9-12)
- **Total:** 8 tests

---

## 📊 **LOGGING TEMPLATE**

### **Option A: Detailed Logging (Preferred)**

For each test, create an entry like this:

```markdown
---
## TEST 1A - RUN 1

**Grade:** K-2
**Subject:** Mathematics
**Topic:** Basic Addition
**Problem:** "If you have 3 apples and get 5 more apples, how many apples do you have?"

**iOS Response:**
- **Answer:** 8 apples
- **Steps:** 3 steps shown
- **Hint:** "Try counting all the apples together..."

**Azure Logs:**
[Copy relevant section here]

**Evaluation:**
- Understanding: 20/20 ✅
- Correctness: 30/30 ✅
- Reasoning: 20/20 ✅
- Hint Quality: 15/15 ✅
- Grade Fit: 10/10 ✅
- Clarity: 5/5 ✅
**Total: 100/100 - EXCELLENT ✅**

**Notes:** Perfect response, age-appropriate language, clear explanation.

---
```

### **Option B: Quick Logging (Minimum)**

Use a spreadsheet or table:

| Test ID | Grade | Subject | Topic | Answer | Correct? | Score | Notes |
|---------|-------|---------|-------|--------|----------|-------|-------|
| 1A | K-2 | Math | Addition | 8 | ✅ | 100 | Perfect |
| 1B | K-2 | Math | Counting | 40 | ✅ | 95 | Minor hint issue |

---

## 🎯 **WHAT I NEED FROM YOU**

### **Minimum Information Per Test:**
1. **Test ID** (e.g., Test 1A)
2. **Problem submitted** (exact text or screenshot)
3. **App's answer** (what iOS showed)
4. **Was it correct?** (Yes/No)
5. **Azure logs** (at least the validator section)

### **Bonus Information (Helpful):**
- Screenshots of iOS app
- Observations about language/clarity
- Any errors or crashes
- Student feedback (if testing with real students)

---

## 📈 **ANALYSIS DELIVERABLES**

### **After All Testing, I Will Provide:**

#### **1. Complete Results Table**
```
| Grade | Subject | Topic | Run 1 | Run 2 | Run 3 | Run 4 | Avg | Status |
|-------|---------|-------|-------|-------|-------|-------|-----|--------|
| K-2   | Math    | Add   | 100   | 95    | 100   | 100   | 99  | ✅ Pass |
| ...   | ...     | ...   | ...   | ...   | ...   | ...   | ... | ...    |
```

#### **2. Summary Statistics**
- Overall accuracy rate
- Pass rate by subject
- Pass rate by grade level
- Consistency analysis (variance across runs)
- Validator effectiveness

#### **3. Detailed Analysis**
- **Strengths:** What the app does well
- **Weaknesses:** Where improvements needed
- **Consistency Issues:** Problems with variable results
- **Validator Coverage:** What's protected vs unprotected

#### **4. Recommendations**
- Priority fixes (high impact)
- Nice-to-have improvements
- Validator additions needed
- Prompt engineering suggestions

#### **5. Test Report (Professional Format)**
- Executive summary
- Methodology
- Results by category
- Statistical analysis
- Findings and conclusions
- Action items

---

## 🚨 **COMMON ISSUES & TROUBLESHOOTING**

### **Issue #1: App Not Responding**
- **Solution:** Restart app, check internet connection
- **If persists:** Check Azure logs for server errors

### **Issue #2: Wrong Answer (Consistent)**
- **Solution:** This is expected - we're testing to find these!
- **Action:** Log it, move to next test

### **Issue #3: Azure Logs Not Showing Validators**
- **Solution:** App might be using cached/old deployment
- **Action:** Restart Azure app (I can do this)

### **Issue #4: App Crashes**
- **Solution:** Note the problem that caused it
- **Action:** Skip that test, try again later

### **Issue #5: Can't Access Azure Logs**
- **Solution:** Just share iOS screenshots
- **Action:** I'll work with what's available

---

## ⏱️ **TIME ESTIMATES**

### **Quick Testing (Critical 5):** 15-20 minutes
- 5 problems × 3 min each = 15 min
- Plus logging: ~5 min

### **Full Testing (88 tests):** 3-4 hours
- 88 problems × 2 min each = 176 min (3 hours)
- Plus logging: ~1 hour
- **Recommendation:** Split across multiple sessions

### **Focused Testing (20 tests):** 1 hour
- Pick one subject (e.g., all Math tests)
- 20 problems × 2 min = 40 min
- Plus logging: ~20 min

---

## 🎯 **RECOMMENDED APPROACH**

### **TODAY: Quick Verification (30 min)**
1. ✅ Test projectile problem (verify validator)
2. ✅ Test 4 more critical tests
3. ✅ Share results
4. ✅ Review my analysis
5. ✅ Decide if ready for full testing

### **THIS WEEK: Focused Testing (2-3 hours)**
- Choose 1-2 subjects (e.g., Math + Science)
- Run all tests for those subjects (40-50 tests)
- Get comprehensive data for priority areas

### **NEXT WEEK: Complete Testing (4 hours)**
- Complete remaining subjects
- Run consistency checks (4 runs per category)
- Final analysis and report

---

## ✅ **LET'S START!**

### **Right Now - Submit This Problem:**

> "A projectile is launched from a 50 m building with velocity 20 m/s. Find the time it hits the ground."

### **Then Share:**
1. What answer iOS gave you
2. Azure logs (any section with validators)
3. Your observation (did it look right?)

### **I Will:**
1. Analyze the logs
2. Verify validator is working
3. Tell you if we're ready for full testing or need to fix something first

---

## 📞 **COMMUNICATION DURING TESTING**

- **After each critical test:** Share results immediately
- **After batches of 5-10:** Quick update
- **If errors occur:** Stop and share details
- **When complete:** Share full log dump

---

## 🎉 **SUCCESS CRITERIA**

### **For Critical Tests:**
- [ ] Physics validator extracts values
- [ ] Physics validator corrects wrong answers
- [ ] Math validators working
- [ ] Age-appropriate language K-2
- [ ] Complex problems handled (11-12)

### **For Full Testing:**
- [ ] ≥75% overall accuracy
- [ ] ≥90% accuracy on math (with validators)
- [ ] ≥80% consistency across runs
- [ ] <5% critical failures
- [ ] Age-appropriate across all grades

---

## 📝 **QUICK REFERENCE: TEST IDS**

**Math:** 1A-1D (K-2), 2A-2D (3-5), 3A-3D (6-8), 4A-4D (9-10), 5A-5D (11-12)  
**Science:** 6A-6D (K-2), 7A-7D (3-5), 8A-8D (6-8), 9A-9D (9-10), 10A-10D (11-12)  
**English:** 11A-11D (K-2), 12A-12D (3-5), 13A-13D (6-8), 14A-14D (9-12)  
**Social Studies:** 15A-15D (3-5), 16A-16D (6-8), 17A-17D (9-12)  
**Logic/CS:** 18A-18D (6-8), 19A-19D (9-12)

---

**Ready to begin! Start with the projectile problem and share results.** 🚀

*Created: October 22, 2025*

