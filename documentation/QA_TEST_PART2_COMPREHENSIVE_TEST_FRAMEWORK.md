# 📚 PART 2: COMPREHENSIVE K-12 TEST FRAMEWORK

**Date:** October 22, 2025  
**Purpose:** Complete QA test suite for Homework Helper app  
**Coverage:** All grades (K-12), All subjects, 4 runs per category  
**Total Tests:** 100+ test cases

---

## 🎯 **TEST FRAMEWORK STRUCTURE**

### **Test Categories:**
1. **Mathematics** (K-12) - 24 tests (6 grade bands × 4 runs)
2. **Science** (K-12) - 24 tests (6 grade bands × 4 runs)
3. **English Language Arts** (K-12) - 16 tests (4 grade bands × 4 runs)
4. **Social Studies** (3-12) - 16 tests (4 grade bands × 4 runs)
5. **Logic/CS** (Optional) - 8 tests (2 grade bands × 4 runs)

**Total:** 88 minimum test cases

---

## 📊 **EVALUATION RUBRIC**

### **Scoring System:**

Each test scores 0-100 points across 6 criteria:

| Criterion | Weight | Points | Description |
|-----------|--------|--------|-------------|
| **Understanding** | 20% | 0-20 | Did app understand the question? |
| **Correctness** | 30% | 0-30 | Is the answer mathematically/factually correct? |
| **Reasoning** | 20% | 0-20 | Are steps logical and valid? |
| **Hint Quality** | 15% | 0-15 | Are hints helpful without giving away answer? |
| **Grade Fit** | 10% | 0-10 | Is difficulty appropriate for grade level? |
| **Clarity** | 5% | 0-5 | Is language clear and grammatically correct? |

### **Pass/Fail Thresholds:**
- **90-100:** ✅ **Excellent**
- **75-89:** ✅ **Pass**
- **60-74:** ⚠️ **Marginal** (needs review)
- **<60:** ❌ **Fail**

---

# 🧮 **SECTION 1: MATHEMATICS**

## **Grade Band: K-2 (Early Elementary)**

### **Test 1A: Basic Addition**
**Problem:** "If you have 3 apples and get 5 more apples, how many apples do you have?"

**Expected Behavior:**
- **Steps:** 2-3 simple steps
- **Options:** [5, 6, 7, 8]
- **Correct Answer:** 8
- **Hint Example:** "Try counting all the apples together. Start with 3 and add 5 more."
- **Language Level:** Simple, visual

**Validator:** Basic arithmetic validator

---

### **Test 1B: Counting by 10s**
**Problem:** "Count by tens: 10, 20, 30, __, 50. What number goes in the blank?"

**Expected Behavior:**
- **Steps:** 2 steps (identify pattern, continue)
- **Options:** [35, 40, 45, 50]
- **Correct Answer:** 40
- **Hint:** "What number comes after 30 when counting by tens?"

---

### **Test 1C: Simple Subtraction**
**Problem:** "Sara has 9 crayons. She gives 4 to her friend. How many crayons does Sara have left?"

**Expected Behavior:**
- **Steps:** 2-3 steps
- **Options:** [3, 4, 5, 6]
- **Correct Answer:** 5
- **Hint:** "Start with 9 and take away 4."

---

### **Test 1D: Shape Recognition**
**Problem:** "How many sides does a triangle have?"

**Expected Behavior:**
- **Steps:** 1-2 steps
- **Options:** [2, 3, 4, 5]
- **Correct Answer:** 3
- **Hint:** "Think about the shape of a triangle. Count each straight edge."

---

## **Grade Band: 3-5 (Upper Elementary)**

### **Test 2A: Multiplication Word Problem**
**Problem:** "A box has 6 rows of eggs with 5 eggs in each row. How many eggs are in the box?"

**Expected Behavior:**
- **Steps:** 3-4 steps
- **Options:** [25, 30, 35, 40]
- **Correct Answer:** 30
- **Hint:** "Multiply the number of rows by the number of eggs in each row."
- **Validator:** Basic arithmetic validator

---

### **Test 2B: Fraction Equivalence**
**Problem:** "Which fraction is equivalent to 1/2?"

**Expected Behavior:**
- **Steps:** 3-4 steps
- **Options:** ["1/4", "2/4", "3/4", "4/8"]
- **Correct Answer:** "2/4" or "4/8"
- **Hint:** "Think about what you can multiply both the top and bottom by."

---

### **Test 2C: Perimeter Calculation**
**Problem:** "A rectangle is 8 meters long and 3 meters wide. What is its perimeter?"

**Expected Behavior:**
- **Steps:** 4-5 steps
- **Options:** ["11 m", "22 m", "24 m", "26 m"]
- **Correct Answer:** "22 m"
- **Hint:** "Remember: perimeter means all the sides added together."
- **Validator:** ✅ Rectangle validator active

---

### **Test 2D: Division with Remainder**
**Problem:** "If 23 cookies are shared equally among 4 friends, how many cookies does each friend get, and how many are left over?"

**Expected Behavior:**
- **Steps:** 4-5 steps
- **Options:** ["5 remainder 3", "5 remainder 2", "6 remainder 1", "4 remainder 7"]
- **Correct Answer:** "5 remainder 3"
- **Hint:** "Divide 23 by 4. How many times does 4 go into 23?"

---

## **Grade Band: 6-8 (Middle School)**

### **Test 3A: Algebraic Expression**
**Problem:** "Simplify: 3x + 5x - 2x"

**Expected Behavior:**
- **Steps:** 3-4 steps
- **Options:** ["6x", "8x", "10x", "6x - 2"]
- **Correct Answer:** "6x"
- **Hint:** "Combine the like terms. All terms have 'x'."

---

### **Test 3B: Percentage Calculation**
**Problem:** "What is 25% of 80?"

**Expected Behavior:**
- **Steps:** 3-4 steps
- **Options:** ["10", "15", "20", "25"]
- **Correct Answer:** "20"
- **Hint:** "25% means 25 out of 100. Or you can multiply 80 by 0.25."
- **Validator:** Percentage validator

---

### **Test 3C: Pythagorean Theorem**
**Problem:** "A right triangle has legs of 3 cm and 4 cm. What is the length of the hypotenuse?"

**Expected Behavior:**
- **Steps:** 4-5 steps
- **Options:** ["5 cm", "6 cm", "7 cm", "8 cm"]
- **Correct Answer:** "5 cm"
- **Hint:** "Use a² + b² = c². So 3² + 4² = c²"
- **Validator:** Pythagorean validator (if built)

---

### **Test 3D: Ratio Problem**
**Problem:** "The ratio of boys to girls in a class is 3:5. If there are 15 girls, how many boys are there?"

**Expected Behavior:**
- **Steps:** 4-5 steps
- **Options:** ["6", "9", "12", "15"]
- **Correct Answer:** "9"
- **Hint:** "If 5 parts = 15 girls, how much is 1 part? Then find 3 parts."

---

## **Grade Band: 9-10 (Early High School)**

### **Test 4A: Solving Linear Equations**
**Problem:** "Solve for x: 2x + 7 = 19"

**Expected Behavior:**
- **Steps:** 4-5 steps
- **Options:** ["x = 5", "x = 6", "x = 7", "x = 12"]
- **Correct Answer:** "x = 6"
- **Hint:** "First, subtract 7 from both sides. Then divide by 2."

---

### **Test 4B: Quadratic Factoring**
**Problem:** "Factor: x² + 5x + 6"

**Expected Behavior:**
- **Steps:** 4-6 steps
- **Options:** ["(x + 2)(x + 3)", "(x + 1)(x + 6)", "(x - 2)(x - 3)", "(x + 4)(x + 1)"]
- **Correct Answer:** "(x + 2)(x + 3)"
- **Hint:** "Find two numbers that multiply to 6 and add to 5."

---

### **Test 4C: System of Equations**
**Problem:** "Solve the system: x + y = 10 and x - y = 4"

**Expected Behavior:**
- **Steps:** 5-7 steps
- **Options:** ["x=7, y=3", "x=6, y=4", "x=8, y=2", "x=5, y=5"]
- **Correct Answer:** "x=7, y=3"
- **Hint:** "Try adding the two equations together to eliminate y."

---

### **Test 4D: Function Evaluation**
**Problem:** "If f(x) = 2x² - 3x + 1, find f(3)"

**Expected Behavior:**
- **Steps:** 3-4 steps
- **Options:** ["10", "12", "14", "16"]
- **Correct Answer:** "10"
- **Hint:** "Replace x with 3 everywhere you see it: f(3) = 2(3)² - 3(3) + 1"

---

## **Grade Band: 11-12 (Advanced High School)**

### **Test 5A: Trigonometry**
**Problem:** "If sin(θ) = 0.5 and 0° < θ < 90°, what is θ?"

**Expected Behavior:**
- **Steps:** 3-4 steps
- **Options:** ["30°", "45°", "60°", "90°"]
- **Correct Answer:** "30°"
- **Hint:** "Which common angle has a sine of 1/2?"

---

### **Test 5B: Logarithms**
**Problem:** "Solve for x: log₂(x) = 5"

**Expected Behavior:**
- **Steps:** 3-4 steps
- **Options:** ["10", "16", "25", "32"]
- **Correct Answer:** "32"
- **Hint:** "Remember: if log₂(x) = 5, then 2⁵ = x"

---

### **Test 5C: Derivatives (Calculus)**
**Problem:** "Find the derivative of f(x) = 3x² + 4x - 5"

**Expected Behavior:**
- **Steps:** 4-5 steps
- **Options:** ["6x + 4", "3x + 4", "6x² + 4x", "6x - 4"]
- **Correct Answer:** "6x + 4"
- **Hint:** "Use the power rule: bring down the exponent and reduce the exponent by 1."

---

### **Test 5D: Probability**
**Problem:** "What is the probability of rolling a sum of 7 with two fair dice?"

**Expected Behavior:**
- **Steps:** 5-6 steps
- **Options:** ["1/6", "1/9", "1/12", "1/3"]
- **Correct Answer:** "1/6"
- **Hint:** "How many ways can you get 7? (1,6), (2,5), (3,4), (4,3), (5,2), (6,1). Total outcomes = 36."

---

# 🔬 **SECTION 2: SCIENCE**

## **Grade Band: K-2 (Early Elementary)**

### **Test 6A: Animal Classification**
**Problem:** "Which animal is a mammal?"

**Expected Behavior:**
- **Steps:** 2-3 steps
- **Options:** ["Snake", "Dog", "Fish", "Bird"]
- **Correct Answer:** "Dog"
- **Hint:** "Mammals have fur and feed milk to their babies."

---

### **Test 6B: Weather**
**Problem:** "What do you use to measure temperature?"

**Expected Behavior:**
- **Steps:** 1-2 steps
- **Options:** ["Ruler", "Thermometer", "Scale", "Clock"]
- **Correct Answer:** "Thermometer"
- **Hint:** "Think about what tool tells us if it's hot or cold."

---

### **Test 6C: Plants**
**Problem:** "What do plants need to grow?"

**Expected Behavior:**
- **Steps:** 2-3 steps
- **Options:** ["Only water", "Water and sunlight", "Only soil", "Only air"]
- **Correct Answer:** "Water and sunlight"
- **Hint:** "Plants need more than one thing to stay healthy and grow."

---

### **Test 6D: Seasons**
**Problem:** "In which season do leaves fall from many trees?"

**Expected Behavior:**
- **Steps:** 1-2 steps
- **Options:** ["Spring", "Summer", "Fall", "Winter"]
- **Correct Answer:** "Fall"
- **Hint:** "This season comes after summer and before winter."

---

## **Grade Band: 3-5 (Upper Elementary)**

### **Test 7A: States of Matter**
**Problem:** "When water freezes, it changes from a liquid to a ___"

**Expected Behavior:**
- **Steps:** 2-3 steps
- **Options:** ["Gas", "Solid", "Plasma", "Vapor"]
- **Correct Answer:** "Solid"
- **Hint:** "Think about what ice is."

---

### **Test 7B: Food Chain**
**Problem:** "In a food chain, what do we call an animal that eats plants?"

**Expected Behavior:**
- **Steps:** 2-3 steps
- **Options:** ["Carnivore", "Herbivore", "Omnivore", "Decomposer"]
- **Correct Answer:** "Herbivore"
- **Hint:** "The prefix 'herb-' relates to plants."

---

### **Test 7C: Simple Machines**
**Problem:** "Which simple machine is a seesaw an example of?"

**Expected Behavior:**
- **Steps:** 2-3 steps
- **Options:** ["Pulley", "Lever", "Inclined plane", "Wheel and axle"]
- **Correct Answer:** "Lever"
- **Hint:** "It has a bar that turns on a fixed point called a fulcrum."

---

### **Test 7D: Earth's Layers**
**Problem:** "What is the outermost layer of Earth called?"

**Expected Behavior:**
- **Steps:** 2-3 steps
- **Options:** ["Core", "Mantle", "Crust", "Atmosphere"]
- **Correct Answer:** "Crust"
- **Hint:** "This is the layer we live on."

---

## **Grade Band: 6-8 (Middle School)**

### **Test 8A: Physics - Force**
**Problem:** "A 5 kg object accelerates at 2 m/s². What is the force applied? (F = ma)"

**Expected Behavior:**
- **Steps:** 3-4 steps
- **Options:** ["7 N", "10 N", "15 N", "20 N"]
- **Correct Answer:** "10 N"
- **Hint:** "Multiply mass by acceleration: F = m × a"
- **Validator:** ✅ F=ma validator active

---

### **Test 8B: Chemistry - Periodic Table**
**Problem:** "What is the chemical symbol for oxygen?"

**Expected Behavior:**
- **Steps:** 1-2 steps
- **Options:** ["O", "O2", "Ox", "Om"]
- **Correct Answer:** "O"
- **Hint:** "It's a single letter that matches the first letter of oxygen."

---

### **Test 8C: Biology - Cells**
**Problem:** "What is the powerhouse of the cell?"

**Expected Behavior:**
- **Steps:** 1-2 steps
- **Options:** ["Nucleus", "Mitochondria", "Ribosome", "Cell membrane"]
- **Correct Answer:** "Mitochondria"
- **Hint:** "This organelle produces energy (ATP) for the cell."

---

### **Test 8D: Earth Science - Water Cycle**
**Problem:** "When water vapor cools and turns into water droplets, this process is called ___"

**Expected Behavior:**
- **Steps:** 2-3 steps
- **Options:** ["Evaporation", "Condensation", "Precipitation", "Transpiration"]
- **Correct Answer:** "Condensation"
- **Hint:** "This is how clouds form."

---

## **Grade Band: 9-10 (Early High School)**

### **Test 9A: Physics - Kinematics**
**Problem:** "A car accelerates from rest at 3 m/s² for 5 seconds. What is its final velocity?"

**Expected Behavior:**
- **Steps:** 3-4 steps
- **Options:** ["8 m/s", "12 m/s", "15 m/s", "20 m/s"]
- **Correct Answer:** "15 m/s"
- **Hint:** "Use v = v₀ + at. Since it starts from rest, v₀ = 0."
- **Validator:** Kinematics validator

---

### **Test 9B: Chemistry - Balancing Equations**
**Problem:** "Balance the equation: H₂ + O₂ → H₂O"

**Expected Behavior:**
- **Steps:** 4-5 steps
- **Options:** ["H₂ + O₂ → H₂O", "2H₂ + O₂ → 2H₂O", "H₂ + 2O₂ → H₂O", "2H₂ + 2O₂ → 2H₂O"]
- **Correct Answer:** "2H₂ + O₂ → 2H₂O"
- **Hint:** "Count atoms on each side. You need 4 H and 2 O on both sides."
- **Validator:** ⚠️ Chemistry validator (basic)

---

### **Test 9C: Biology - Genetics**
**Problem:** "In a Punnett square for Tt × Tt, what percentage of offspring will be TT?"

**Expected Behavior:**
- **Steps:** 4-5 steps
- **Options:** ["0%", "25%", "50%", "75%"]
- **Correct Answer:** "25%"
- **Hint:** "Draw a 2×2 grid. TT appears in 1 out of 4 squares."

---

### **Test 9D: Earth Science - Plate Tectonics**
**Problem:** "What type of boundary is formed when two plates move apart?"

**Expected Behavior:**
- **Steps:** 2-3 steps
- **Options:** ["Convergent", "Divergent", "Transform", "Subduction"]
- **Correct Answer:** "Divergent"
- **Hint:** "Think about the word 'diverge' which means to separate."

---

## **Grade Band: 11-12 (Advanced High School)**

### **Test 10A: Physics - Projectile Motion** ⭐
**Problem:** "A projectile is launched from a 50 m building with velocity 20 m/s. Find the time it hits the ground."

**Expected Behavior:**
- **Steps:** 5-7 steps
- **Options:** ["2.5 s", "4.5 s", "5.8 s", "6.0 s"]
- **Correct Answer:** "5.8 s"
- **Hint:** "Use h = h₀ + v₀t - ½gt². Set up the quadratic equation."
- **Validator:** ✅ Universal Physics Validator (Kinematics)
- **⚠️ CRITICAL TEST:** This is the problem we've been working on!

---

### **Test 10B: Chemistry - Molar Mass**
**Problem:** "What is the molar mass of H₂SO₄? (H=1, S=32, O=16)"

**Expected Behavior:**
- **Steps:** 4-5 steps
- **Options:** ["82 g/mol", "90 g/mol", "98 g/mol", "106 g/mol"]
- **Correct Answer:** "98 g/mol"
- **Hint:** "Add: (2×1) + (1×32) + (4×16)"
- **Validator:** ⚠️ Chemistry validator

---

### **Test 10C: Biology - Photosynthesis**
**Problem:** "What is the chemical equation for photosynthesis?"

**Expected Behavior:**
- **Steps:** 2-3 steps
- **Options:** ["6CO₂ + 6H₂O → C₆H₁₂O₆ + 6O₂", "C₆H₁₂O₆ + 6O₂ → 6CO₂ + 6H₂O", "CO₂ + H₂O → CH₄ + O₂", "2H₂ + O₂ → 2H₂O"]
- **Correct Answer:** "6CO₂ + 6H₂O → C₆H₁₂O₆ + 6O₂"
- **Hint:** "Plants use carbon dioxide and water to make glucose and oxygen."

---

### **Test 10D: Physics - Ohm's Law**
**Problem:** "A circuit has 10 V and 2 A of current. What is the resistance?"

**Expected Behavior:**
- **Steps:** 3-4 steps
- **Options:** ["2 Ω", "5 Ω", "10 Ω", "20 Ω"]
- **Correct Answer:** "5 Ω"
- **Hint:** "Use V = IR. Solve for R: R = V/I"
- **Validator:** ✅ Ohm's Law validator

---

# 📖 **SECTION 3: ENGLISH LANGUAGE ARTS**

## **Grade Band: K-2 (Early Elementary)**

### **Test 11A: Vocabulary**
**Problem:** "Which word means 'not happy'?"

**Expected Behavior:**
- **Steps:** 1-2 steps
- **Options:** ["Sad", "Mad", "Glad", "Bad"]
- **Correct Answer:** "Sad"
- **Hint:** "Think about how you feel when something makes you unhappy."

---

### **Test 11B: Rhyming Words**
**Problem:** "Which word rhymes with 'cat'?"

**Expected Behavior:**
- **Steps:** 1-2 steps
- **Options:** ["Dog", "Hat", "Car", "Cup"]
- **Correct Answer:** "Hat"
- **Hint:** "Listen to the ending sound: c-AT."

---

### **Test 11C: Sentence Completion**
**Problem:** "The dog ___ running in the park."

**Expected Behavior:**
- **Steps:** 2 steps
- **Options:** ["is", "are", "am", "be"]
- **Correct Answer:** "is"
- **Hint:** "The dog is one animal, so we use 'is'."

---

### **Test 11D: Story Sequence**
**Problem:** "Put these in order: 1) She ate breakfast. 2) She woke up. 3) She went to school. What comes first?"

**Expected Behavior:**
- **Steps:** 2-3 steps
- **Options:** ["1", "2", "3", "All at once"]
- **Correct Answer:** "2"
- **Hint:** "What do you do first thing in the morning?"

---

## **Grade Band: 3-5 (Upper Elementary)**

### **Test 12A: Parts of Speech**
**Problem:** "In the sentence 'The quick brown fox jumps,' what is 'quick'?"

**Expected Behavior:**
- **Steps:** 2-3 steps
- **Options:** ["Noun", "Verb", "Adjective", "Adverb"]
- **Correct Answer:** "Adjective"
- **Hint:** "It describes the fox."

---

### **Test 12B: Synonyms**
**Problem:** "Which word is a synonym for 'big'?"

**Expected Behavior:**
- **Steps:** 1-2 steps
- **Options:** ["Small", "Large", "Tiny", "Little"]
- **Correct Answer:** "Large"
- **Hint:** "A synonym means almost the same thing."

---

### **Test 12C: Subject-Verb Agreement**
**Problem:** "The boys ___ playing soccer."

**Expected Behavior:**
- **Steps:** 2-3 steps
- **Options:** ["is", "are", "was", "be"]
- **Correct Answer:** "are"
- **Hint:** "'Boys' is plural, so we need a plural verb."

---

### **Test 12D: Reading Comprehension**
**Problem:** "Read: 'The sun was setting behind the mountains. Sarah felt peaceful.' How did Sarah feel?"

**Expected Behavior:**
- **Steps:** 1-2 steps
- **Options:** ["Angry", "Peaceful", "Scared", "Excited"]
- **Correct Answer:** "Peaceful"
- **Hint:** "Look for the word that describes Sarah's feeling."

---

## **Grade Band: 6-8 (Middle School)**

### **Test 13A: Literary Devices**
**Problem:** "Identify the literary device: 'The wind whispered through the trees.'"

**Expected Behavior:**
- **Steps:** 2-3 steps
- **Options:** ["Simile", "Metaphor", "Personification", "Alliteration"]
- **Correct Answer:** "Personification"
- **Hint:** "The wind is being given a human action (whispering)."

---

### **Test 13B: Main Idea**
**Problem:** "What is the main idea of a paragraph about recycling benefits, climate change, and waste reduction?"

**Expected Behavior:**
- **Steps:** 2-3 steps
- **Options:** ["Types of recycling bins", "Benefits of recycling", "How to recycle plastic", "History of recycling"]
- **Correct Answer:** "Benefits of recycling"
- **Hint:** "What is the paragraph mostly about?"

---

### **Test 13C: Comma Usage**
**Problem:** "Where should a comma go? 'I bought apples oranges and bananas.'"

**Expected Behavior:**
- **Steps:** 2-3 steps
- **Options:** ["After apples and oranges", "Only after apples", "Only after oranges", "No comma needed"]
- **Correct Answer:** "After apples and oranges"
- **Hint:** "Use commas to separate items in a list."

---

### **Test 13D: Inference**
**Problem:** "Read: 'Tom grabbed his umbrella and rain boots before heading out.' What can you infer?"

**Expected Behavior:**
- **Steps:** 2-3 steps
- **Options:** ["It's sunny", "It's raining or might rain", "It's snowing", "It's windy"]
- **Correct Answer:** "It's raining or might rain"
- **Hint:** "Why would Tom need an umbrella and rain boots?"

---

## **Grade Band: 9-12 (High School)**

### **Test 14A: Theme Analysis**
**Problem:** "In a story where a character learns that honesty is important, what is the theme?"

**Expected Behavior:**
- **Steps:** 2-3 steps
- **Options:** ["Friendship", "Honesty", "Adventure", "Family"]
- **Correct Answer:** "Honesty"
- **Hint:** "The theme is the lesson or message of the story."

---

### **Test 14B: Rhetorical Devices**
**Problem:** "Identify the device: 'Ask not what your country can do for you—ask what you can do for your country.'"

**Expected Behavior:**
- **Steps:** 2-3 steps
- **Options:** ["Anaphora", "Chiasmus", "Hyperbole", "Irony"]
- **Correct Answer:** "Chiasmus"
- **Hint:** "The sentence structure is reversed in the second part."

---

### **Test 14C: Essay Structure**
**Problem:** "Where should you state your main argument in an essay?"

**Expected Behavior:**
- **Steps:** 1-2 steps
- **Options:** ["Conclusion", "Body paragraphs", "Introduction (thesis)", "Title"]
- **Correct Answer:** "Introduction (thesis)"
- **Hint:** "This is where you tell readers what you'll argue."

---

### **Test 14D: Grammar - Active/Passive Voice**
**Problem:** "Convert to active voice: 'The ball was thrown by John.'"

**Expected Behavior:**
- **Steps:** 2-3 steps
- **Options:** ["John threw the ball", "The ball threw John", "John was throwing", "The ball throws"]
- **Correct Answer:** "John threw the ball"
- **Hint:** "Make John the subject who performs the action."

---

# 🌍 **SECTION 4: SOCIAL STUDIES**

## **Grade Band: 3-5 (Upper Elementary)**

### **Test 15A: U.S. Geography**
**Problem:** "What is the capital of the United States?"

**Expected Behavior:**
- **Steps:** 1-2 steps
- **Options:** ["New York", "Washington D.C.", "Los Angeles", "Chicago"]
- **Correct Answer:** "Washington D.C."
- **Hint:** "It's named after the first president."

---

### **Test 15B: Community Helpers**
**Problem:** "Who helps put out fires?"

**Expected Behavior:**
- **Steps:** 1 step
- **Options:** ["Police officer", "Firefighter", "Doctor", "Teacher"]
- **Correct Answer:** "Firefighter"
- **Hint:** "This person works at a fire station."

---

### **Test 15C: Basic Economics**
**Problem:** "What do we call money you earn from working?"

**Expected Behavior:**
- **Steps:** 1-2 steps
- **Options:** ["Expenses", "Income", "Taxes", "Savings"]
- **Correct Answer:** "Income"
- **Hint:** "This is money coming IN to you."

---

### **Test 15D: Map Skills**
**Problem:** "On a map, what does a compass rose show?"

**Expected Behavior:**
- **Steps:** 1-2 steps
- **Options:** ["Directions (N, S, E, W)", "Distance", "Cities", "Rivers"]
- **Correct Answer:** "Directions (N, S, E, W)"
- **Hint:** "It helps you know which way is north, south, east, and west."

---

## **Grade Band: 6-8 (Middle School)**

### **Test 16A: American History**
**Problem:** "What year did the United States declare independence?"

**Expected Behavior:**
- **Steps:** 1-2 steps
- **Options:** ["1492", "1776", "1865", "1945"]
- **Correct Answer:** "1776"
- **Hint:** "This is celebrated on July 4th."

---

### **Test 16B: Civics**
**Problem:** "How many branches are in the U.S. government?"

**Expected Behavior:**
- **Steps:** 1-2 steps
- **Options:** ["Two", "Three", "Four", "Five"]
- **Correct Answer:** "Three"
- **Hint:** "Legislative, Executive, and Judicial."

---

### **Test 16C: World Geography**
**Problem:** "Which continent is Egypt located on?"

**Expected Behavior:**
- **Steps:** 1-2 steps
- **Options:** ["Asia", "Africa", "Europe", "South America"]
- **Correct Answer:** "Africa"
- **Hint:** "It's home to the pyramids and the Nile River."

---

### **Test 16D: Cultural Studies**
**Problem:** "What holiday celebrates the harvest and is on the fourth Thursday of November in the U.S.?"

**Expected Behavior:**
- **Steps:** 1-2 steps
- **Options:** ["Halloween", "Thanksgiving", "Christmas", "Labor Day"]
- **Correct Answer:** "Thanksgiving"
- **Hint:** "Families often eat turkey on this day."

---

## **Grade Band: 9-12 (High School)**

### **Test 17A: World History**
**Problem:** "What event started World War I?"

**Expected Behavior:**
- **Steps:** 2-3 steps
- **Options:** ["Pearl Harbor attack", "Assassination of Archduke Franz Ferdinand", "Bombing of Hiroshima", "Fall of Berlin Wall"]
- **Correct Answer:** "Assassination of Archduke Franz Ferdinand"
- **Hint:** "This happened in 1914 in Sarajevo."

---

### **Test 17B: Economics**
**Problem:** "What is the law of supply and demand?"

**Expected Behavior:**
- **Steps:** 3-4 steps
- **Options:** ["Prices stay constant", "When demand increases and supply decreases, prices rise", "Government sets all prices", "Supply doesn't affect price"]
- **Correct Answer:** "When demand increases and supply decreases, prices rise"
- **Hint:** "Think about what happens when many people want something rare."

---

### **Test 17C: Government**
**Problem:** "What is a filibuster?"

**Expected Behavior:**
- **Steps:** 2-3 steps
- **Options:** ["A type of tax", "A prolonged speech to delay a vote", "A government election", "A constitutional amendment"]
- **Correct Answer:** "A prolonged speech to delay a vote"
- **Hint:** "It's a tactic used in the Senate."

---

### **Test 17D: Geography**
**Problem:** "What imaginary line divides the Earth into Northern and Southern Hemispheres?"

**Expected Behavior:**
- **Steps:** 1-2 steps
- **Options:** ["Prime Meridian", "Equator", "Tropic of Cancer", "International Date Line"]
- **Correct Answer:** "Equator"
- **Hint:** "It's at 0° latitude."

---

# 💻 **SECTION 5: LOGIC & COMPUTER SCIENCE (Optional)**

## **Grade Band: 6-8 (Middle School)**

### **Test 18A: Pattern Recognition**
**Problem:** "What comes next in the sequence: 2, 4, 8, 16, ___?"

**Expected Behavior:**
- **Steps:** 2-3 steps
- **Options:** ["20", "24", "32", "64"]
- **Correct Answer:** "32"
- **Hint:** "Each number is double the previous one."

---

### **Test 18B: Basic Logic**
**Problem:** "If all cats are animals, and Fluffy is a cat, what can we conclude?"

**Expected Behavior:**
- **Steps:** 2-3 steps
- **Options:** ["Fluffy is an animal", "Fluffy is not an animal", "All animals are cats", "Cannot determine"]
- **Correct Answer:** "Fluffy is an animal"
- **Hint:** "This is called a logical syllogism."

---

### **Test 18C: Algorithm Thinking**
**Problem:** "To make a sandwich, which step comes first?"

**Expected Behavior:**
- **Steps:** 2 steps
- **Options:** ["Put on toppings", "Get bread", "Cut sandwich", "Eat sandwich"]
- **Correct Answer:** "Get bread"
- **Hint:** "You need the base before you can add anything."

---

### **Test 18D: Basic Coding Concept**
**Problem:** "In a loop that runs 5 times, starting at 0, what is the last value?"

**Expected Behavior:**
- **Steps:** 2-3 steps
- **Options:** ["3", "4", "5", "6"]
- **Correct Answer:** "4"
- **Hint:** "Count: 0, 1, 2, 3, 4. That's 5 numbers total."

---

## **Grade Band: 9-12 (High School)**

### **Test 19A: Boolean Logic**
**Problem:** "What is the result of: (True AND False) OR True?"

**Expected Behavior:**
- **Steps:** 3-4 steps
- **Options:** ["True", "False", "Undefined", "Error"]
- **Correct Answer:** "True"
- **Hint:** "First evaluate (True AND False) = False. Then False OR True = True."

---

### **Test 19B: Binary Math**
**Problem:** "Convert binary 1011 to decimal."

**Expected Behavior:**
- **Steps:** 4-5 steps
- **Options:** ["9", "10", "11", "12"]
- **Correct Answer:** "11"
- **Hint:** "Calculate: 1×8 + 0×4 + 1×2 + 1×1"

---

### **Test 19C: Algorithm Complexity**
**Problem:** "If a function takes 2 seconds for 10 items and 4 seconds for 20 items, what is its complexity?"

**Expected Behavior:**
- **Steps:** 3-4 steps
- **Options:** ["O(1)", "O(n)", "O(n²)", "O(log n)"]
- **Correct Answer:** "O(n)"
- **Hint:** "The time doubles when input doubles = linear growth."

---

### **Test 19D: Pseudocode**
**Problem:** "What does this do? FOR i = 1 TO 5: PRINT i * 2"

**Expected Behavior:**
- **Steps:** 2-3 steps
- **Options:** ["Prints 1,2,3,4,5", "Prints 2,4,6,8,10", "Prints 5 twice", "Prints 10"]
- **Correct Answer:** "Prints 2,4,6,8,10"
- **Hint:** "It multiplies each number from 1 to 5 by 2."

---

# 📊 **TEST EXECUTION TEMPLATE**

## **For Each Test, Record:**

```
TEST ID: [e.g., Test 1A]
GRADE: [e.g., K-2]
SUBJECT: [e.g., Mathematics]
TOPIC: [e.g., Basic Addition]
RUN #: [1, 2, 3, or 4]
DATE/TIME: [timestamp]

PROBLEM SUBMITTED: [exact text]
EXPECTED ANSWER: [from framework]
AI ANSWER: [from app]
MATCH: [Yes/No]

SCORING:
- Understanding: [0-20]
- Correctness: [0-30]
- Reasoning: [0-20]
- Hint Quality: [0-15]
- Grade Fit: [0-10]
- Clarity: [0-5]
TOTAL: [0-100]

RESULT: [✅ Pass / ⚠️ Marginal / ❌ Fail]

VALIDATOR STATUS: [Active/Inactive/Corrected/Not Applicable]

NOTES: [Any observations]
```

---

# 🎯 **TESTING PROTOCOL**

## **Phase 1: Initial Run (Run #1)**
- Test all 19 categories with first problem (Test XA)
- Log all results
- Identify major failures

## **Phase 2: Second Run (Run #2)**
- Test all 19 categories with second problem (Test XB)
- Compare consistency with Run #1

## **Phase 3: Third Run (Run #3)**
- Test all 19 categories with third problem (Test XC)
- Statistical analysis of trends

## **Phase 4: Fourth Run (Run #4)**
- Test all 19 categories with fourth problem (Test XD)
- Final consistency check
- Complete analysis

---

# ✅ **NEXT STEPS**

1. **Review this framework** - User confirms test cases are appropriate
2. **Begin testing** - User submits problems via iOS app
3. **Log results** - User shares Azure logs for each test
4. **Analyze data** - I compile results and provide recommendations

---

**Framework Complete. Ready for Part 3: Collaborative Testing.**

*Created: October 22, 2025*

