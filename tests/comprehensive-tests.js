/**
 * COMPREHENSIVE K-12 TEST SUITE - ALL SUBJECTS
 * 
 * Coverage: 5 tests per subject per grade band
 * Subjects: Math, Science (Biology, Chemistry, Physics, Earth Science), English
 * 
 * Total: ~100+ tests across all K-12 subjects
 */

const axios = require('axios');
const fs = require('fs');
const path = require('path');

// Configuration
const CONFIG = {
  apiUrl: process.env.API_URL || 'https://homework-helper-api.azurewebsites.net',
  testUserId: 'test-user-comprehensive',
  testDeviceId: 'test-device-comprehensive',
  outputDir: path.join(__dirname, '../test-results'),
  logFile: path.join(__dirname, '../test-results/comprehensive-test-results.json'),
  reportFile: path.join(__dirname, '../test-results/COMPREHENSIVE_TEST_REPORT.md')
};

if (!fs.existsSync(CONFIG.outputDir)) {
  fs.mkdirSync(CONFIG.outputDir, { recursive: true });
}

// COMPREHENSIVE TEST SUITE
const COMPREHENSIVE_TESTS = {
  // ========================================
  // K-2 (EARLY ELEMENTARY)
  // ========================================
  'K-2_Mathematics': [
    { id: 'K2M1', problem: '3 + 4 = ?', answer: '7', variants: ['7', 'seven'], topic: 'Basic Addition' },
    { id: 'K2M2', problem: '10 - 6 = ?', answer: '4', variants: ['4', 'four'], topic: 'Basic Subtraction' },
    { id: 'K2M3', problem: 'Count: 5, 10, 15, __, 25. What comes next?', answer: '20', variants: ['20', 'twenty'], topic: 'Skip Counting' },
    { id: 'K2M4', problem: 'A square has how many sides?', answer: '4', variants: ['4', 'four', '4 sides'], topic: 'Shapes' },
    { id: 'K2M5', problem: 'Which is bigger: 8 or 5?', answer: '8', variants: ['8', 'eight'], topic: 'Number Comparison' },
    { id: 'K2M6', problem: '2 + 2 = ?', answer: '4', variants: ['4', 'four'], topic: 'Basic Addition' },
    { id: 'K2M7', problem: '8 - 3 = ?', answer: '5', variants: ['5', 'five'], topic: 'Basic Subtraction' },
    { id: 'K2M8', problem: 'How many sides does a triangle have?', answer: '3', variants: ['3', 'three', '3 sides'], topic: 'Shapes' },
    { id: 'K2M9', problem: 'Count: 2, 4, 6, __, 10. Fill in the blank.', answer: '8', variants: ['8', 'eight'], topic: 'Skip Counting' }
  ],
  'K-2_Science': [
    { id: 'K2S1', problem: 'What do plants need to grow? A) Water B) Toys C) Cars D) Books', answer: 'A', variants: ['A', 'water', 'A)', 'a'], topic: 'Life Science - Plants' },
    { id: 'K2S2', problem: 'Is the sun a star? Yes or No?', answer: 'Yes', variants: ['yes', 'y'], topic: 'Earth Science - Sun' },
    { id: 'K2S3', problem: 'What season comes after winter? A) Spring B) Summer C) Fall D) Winter', answer: 'A', variants: ['A', 'spring', 'A)', 'a'], topic: 'Earth Science - Seasons' },
    { id: 'K2S4', problem: 'Do fish live in water or on land?', answer: 'water', variants: ['water', 'in water'], topic: 'Life Science - Animals' },
    { id: 'K2S5', problem: 'What color do you get when you mix blue and yellow?', answer: 'green', variants: ['green'], topic: 'Physical Science - Colors' },
    { id: 'K2S6', problem: 'What helps birds fly? A) Wings B) Feet C) Eyes D) Nose', answer: 'A', variants: ['A', 'wings', 'A)', 'a'], topic: 'Life Science - Animals' },
    { id: 'K2S7', problem: 'Is ice hot or cold?', answer: 'cold', variants: ['cold'], topic: 'Physical Science - Temperature' },
    { id: 'K2S8', problem: 'What do we call a baby cat?', answer: 'kitten', variants: ['kitten', 'a kitten'], topic: 'Life Science - Animals' },
    { id: 'K2S9', problem: 'Does the moon give us light at night? Yes or No?', answer: 'Yes', variants: ['yes', 'y'], topic: 'Earth Science - Moon' }
  ],

  // ========================================
  // 3-5 (UPPER ELEMENTARY)
  // ========================================
  'Grade3-5_Mathematics': [
    { id: 'G35M1', problem: '7 × 8 = ?', answer: '56', variants: ['56', 'fifty-six'], topic: 'Multiplication' },
    { id: 'G35M2', problem: '36 ÷ 4 = ?', answer: '9', variants: ['9', 'nine'], topic: 'Division' },
    { id: 'G35M3', problem: 'What is 1/4 + 1/4?', answer: '1/2', variants: ['1/2', '2/4', '0.5'], topic: 'Fractions' },
    { id: 'G35M4', problem: 'A rectangle has length 6 cm and width 4 cm. What is its area?', answer: '24', variants: ['24', '24 cm²', '24 square cm'], topic: 'Area' },
    { id: 'G35M5', problem: 'Round 47 to the nearest ten.', answer: '50', variants: ['50', 'fifty'], topic: 'Rounding' },
    { id: 'G35M6', problem: '9 × 7 = ?', answer: '63', variants: ['63', 'sixty-three'], topic: 'Multiplication' },
    { id: 'G35M7', problem: '48 ÷ 8 = ?', answer: '6', variants: ['6', 'six'], topic: 'Division' },
    { id: 'G35M8', problem: 'What is 1/2 + 1/4?', answer: '3/4', variants: ['3/4', '0.75'], topic: 'Fractions' },
    { id: 'G35M9', problem: 'Round 83 to the nearest ten.', answer: '80', variants: ['80', 'eighty'], topic: 'Rounding' }
  ],
  'Grade3-5_Science': [
    { id: 'G35S1', problem: 'What are the three states of matter?', answer: 'solid, liquid, gas', variants: ['solid liquid gas', 'solid, liquid, gas'], topic: 'Physical Science - Matter' },
    { id: 'G35S2', problem: 'What is the process by which plants make food called?', answer: 'photosynthesis', variants: ['photosynthesis'], topic: 'Life Science - Plants' },
    { id: 'G35S3', problem: 'How many planets are in our solar system?', answer: '8', variants: ['8', 'eight'], topic: 'Earth Science - Solar System' },
    { id: 'G35S4', problem: 'What is the center of an atom called?', answer: 'nucleus', variants: ['nucleus', 'the nucleus'], topic: 'Physical Science - Atoms' },
    { id: 'G35S5', problem: 'What type of rock is formed by cooling lava?', answer: 'igneous', variants: ['igneous', 'igneous rock'], topic: 'Earth Science - Rocks' },
    { id: 'G35S6', problem: 'What is H2O?', answer: 'water', variants: ['water'], topic: 'Physical Science - Matter' },
    { id: 'G35S7', problem: 'What planet is closest to the Sun?', answer: 'Mercury', variants: ['mercury'], topic: 'Earth Science - Solar System' },
    { id: 'G35S8', problem: 'What type of rock is formed by heat and pressure?', answer: 'metamorphic', variants: ['metamorphic', 'metamorphic rock'], topic: 'Earth Science - Rocks' },
    { id: 'G35S9', problem: 'What gas do plants release during photosynthesis?', answer: 'oxygen', variants: ['oxygen', 'O2'], topic: 'Life Science - Plants' }
  ],

  // ========================================
  // 6-8 (MIDDLE SCHOOL)
  // ========================================
  'Grade6-8_Mathematics': [
    { id: 'G68M1', problem: 'Solve: 3x + 5 = 20', answer: 'x = 5', variants: ['5', 'x=5', 'x = 5'], topic: 'Pre-Algebra - Equations' },
    { id: 'G68M2', problem: 'What is 30% of 150?', answer: '45', variants: ['45'], topic: 'Percentages' },
    { id: 'G68M3', problem: 'Simplify: 4(2x - 3)', answer: '8x - 12', variants: ['8x-12', '8x - 12'], topic: 'Distributive Property' },
    { id: 'G68M4', problem: 'The ratio of boys to girls is 2:3. If there are 12 boys, how many girls are there?', answer: '18', variants: ['18'], topic: 'Ratios' },
    { id: 'G68M5', problem: 'What is the value of 2³?', answer: '8', variants: ['8', 'eight'], topic: 'Exponents' },
    { id: 'G68M6', problem: 'Solve: 2x - 3 = 7', answer: 'x = 5', variants: ['5', 'x=5', 'x = 5'], topic: 'Pre-Algebra - Equations' },
    { id: 'G68M7', problem: 'What is 25% of 80?', answer: '20', variants: ['20'], topic: 'Percentages' },
    { id: 'G68M8', problem: 'What is the value of 3²?', answer: '9', variants: ['9', 'nine'], topic: 'Exponents' },
    { id: 'G68M9', problem: 'Simplify: 3(x + 2)', answer: '3x + 6', variants: ['3x+6', '3x + 6'], topic: 'Distributive Property' }
  ],
  'Grade6-8_Biology': [
    { id: 'G68B1', problem: 'What is the powerhouse of the cell?', answer: 'mitochondria', variants: ['mitochondria', 'mitochondrion'], topic: 'Cell Biology' },
    { id: 'G68B2', problem: 'What process do animals use to get energy from food?', answer: 'cellular respiration', variants: ['cellular respiration', 'respiration'], topic: 'Cellular Respiration' },
    { id: 'G68B3', problem: 'What are the building blocks of proteins?', answer: 'amino acids', variants: ['amino acids', 'amino acid'], topic: 'Biochemistry' },
    { id: 'G68B4', problem: 'What organ pumps blood throughout the body?', answer: 'heart', variants: ['heart', 'the heart'], topic: 'Human Body' },
    { id: 'G68B5', problem: 'What is the process of cell division called?', answer: 'mitosis', variants: ['mitosis'], topic: 'Cell Division' },
    { id: 'G68B6', problem: 'What is the basic unit of life?', answer: 'cell', variants: ['cell', 'the cell'], topic: 'Cell Biology' },
    { id: 'G68B7', problem: 'What carries oxygen in blood?', answer: 'red blood cells', variants: ['red blood cells', 'RBC', 'hemoglobin'], topic: 'Human Body' },
    { id: 'G68B8', problem: 'What is DNA short for?', answer: 'deoxyribonucleic acid', variants: ['deoxyribonucleic acid', 'dna'], topic: 'Genetics' },
    { id: 'G68B9', problem: 'What organelle produces ATP?', answer: 'mitochondria', variants: ['mitochondria', 'mitochondrion'], topic: 'Cell Biology' }
  ],
  'Grade6-8_Earth_Science': [
    { id: 'G68E1', problem: 'What layer of Earth do we live on?', answer: 'crust', variants: ['crust', 'the crust'], topic: 'Earth Layers' },
    { id: 'G68E2', problem: 'What causes tides on Earth?', answer: 'the moon', variants: ['moon', 'the moon', 'moon\'s gravity'], topic: 'Tides' },
    { id: 'G68E3', problem: 'What is the most abundant gas in Earth\'s atmosphere?', answer: 'nitrogen', variants: ['nitrogen', 'N2'], topic: 'Atmosphere' },
    { id: 'G68E4', problem: 'What type of boundary creates mountains?', answer: 'convergent', variants: ['convergent', 'convergent boundary'], topic: 'Plate Tectonics' },
    { id: 'G68E5', problem: 'What is the water cycle process where water vapor becomes liquid?', answer: 'condensation', variants: ['condensation'], topic: 'Water Cycle' },
    { id: 'G68E6', problem: 'What is the hottest layer of Earth?', answer: 'inner core', variants: ['inner core', 'core'], topic: 'Earth Layers' },
    { id: 'G68E7', problem: 'What is the water cycle process where liquid becomes gas?', answer: 'evaporation', variants: ['evaporation'], topic: 'Water Cycle' },
    { id: 'G68E8', problem: 'What gas makes up 78% of Earth\'s atmosphere?', answer: 'nitrogen', variants: ['nitrogen', 'N2'], topic: 'Atmosphere' },
    { id: 'G68E9', problem: 'What scale measures tornado intensity?', answer: 'Fujita', variants: ['Fujita', 'Fujita scale', 'F-scale'], topic: 'Weather' }
  ],
  'Grade6-8_Physics': [
    { id: 'G68P1', problem: 'What is the unit of force?', answer: 'Newton', variants: ['Newton', 'N', 'Newtons'], topic: 'Forces' },
    { id: 'G68P2', problem: 'If speed = distance/time, what is the speed of an object that travels 100 meters in 20 seconds?', answer: '5', variants: ['5', '5 m/s'], topic: 'Speed' },
    { id: 'G68P3', problem: 'What type of energy does a moving object have?', answer: 'kinetic', variants: ['kinetic', 'kinetic energy'], topic: 'Energy' },
    { id: 'G68P4', problem: 'What is the formula for work?', answer: 'W = F × d', variants: ['W=Fd', 'F*d', 'force times distance'], topic: 'Work' },
    { id: 'G68P5', problem: 'Sound travels faster in which medium: air or water?', answer: 'water', variants: ['water'], topic: 'Waves' },
    { id: 'G68P6', problem: 'What is the unit of energy?', answer: 'Joule', variants: ['Joule', 'J', 'Joules'], topic: 'Energy' },
    { id: 'G68P7', problem: 'What type of energy is stored in food?', answer: 'chemical', variants: ['chemical', 'chemical energy'], topic: 'Energy' },
    { id: 'G68P8', problem: 'What is the formula for speed?', answer: 'speed = distance/time', variants: ['s=d/t', 'distance/time', 'speed = distance/time'], topic: 'Speed' },
    { id: 'G68P9', problem: 'Sound cannot travel through what?', answer: 'vacuum', variants: ['vacuum', 'a vacuum', 'space'], topic: 'Waves' }
  ],

  // ========================================
  // 9-10 (EARLY HIGH SCHOOL)
  // ========================================
  'Grade9-10_Algebra': [
    { id: 'G910A1', problem: 'Solve: 2x² - 8 = 0', answer: 'x = ±2', variants: ['±2', '2', '-2', 'x=2 or x=-2'], topic: 'Quadratic Equations' },
    { id: 'G910A2', problem: 'Factor: x² + 7x + 12', answer: '(x + 3)(x + 4)', variants: ['(x+3)(x+4)', '(x + 3)(x + 4)'], topic: 'Factoring' },
    { id: 'G910A3', problem: 'Simplify: √48', answer: '4√3', variants: ['4√3', '4*sqrt(3)', '4sqrt3'], topic: 'Radicals' },
    { id: 'G910A4', problem: 'What is the slope of the line y = 3x + 5?', answer: '3', variants: ['3'], topic: 'Linear Equations' },
    { id: 'G910A5', problem: 'Evaluate: (-2)³', answer: '-8', variants: ['-8'], topic: 'Exponents' },
    { id: 'G910A6', problem: 'Factor: x² - 16', answer: '(x+4)(x-4)', variants: ['(x+4)(x-4)', '(x-4)(x+4)'], topic: 'Factoring' },
    { id: 'G910A7', problem: 'Simplify: √64', answer: '8', variants: ['8', 'eight'], topic: 'Radicals' },
    { id: 'G910A8', problem: 'What is the slope of y = -2x + 3?', answer: '-2', variants: ['-2'], topic: 'Linear Equations' },
    { id: 'G910A9', problem: 'Solve: x² = 25', answer: 'x = ±5', variants: ['±5', '5', '-5', 'x=5 or x=-5'], topic: 'Quadratic Equations' }
  ],
  'Grade9-10_Geometry': [
    { id: 'G910G1', problem: 'What is the sum of angles in a triangle?', answer: '180', variants: ['180', '180°', '180 degrees'], topic: 'Triangles' },
    { id: 'G910G2', problem: 'Find the area of a circle with radius 5. (Use π ≈ 3.14)', answer: '78.5', variants: ['78.5', '25π', '78.5 square units'], topic: 'Circles' },
    { id: 'G910G3', problem: 'If two angles are complementary and one is 35°, what is the other?', answer: '55', variants: ['55', '55°'], topic: 'Angle Relationships' },
    { id: 'G910G4', problem: 'What is the volume of a cube with side length 3?', answer: '27', variants: ['27', '27 cubic units'], topic: 'Volume' },
    { id: 'G910G5', problem: 'In a 30-60-90 triangle, if the shortest side is 1, what is the hypotenuse?', answer: '2', variants: ['2'], topic: 'Special Triangles' },
    { id: 'G910G6', problem: 'What is the sum of angles in a quadrilateral?', answer: '360', variants: ['360', '360°', '360 degrees'], topic: 'Angles' },
    { id: 'G910G7', problem: 'What is the circumference formula for a circle?', answer: 'C = 2πr', variants: ['2πr', '2*pi*r', 'C=2πr'], topic: 'Circles' },
    { id: 'G910G8', problem: 'What is the volume formula for a sphere?', answer: 'V = (4/3)πr³', variants: ['4/3*pi*r^3', '(4/3)πr³'], topic: 'Volume' },
    { id: 'G910G9', problem: 'If two angles are supplementary and one is 120°, what is the other?', answer: '60', variants: ['60', '60°'], topic: 'Angle Relationships' }
  ],
  'Grade9-10_Biology': [
    { id: 'G910B1', problem: 'What is the basic unit of heredity?', answer: 'gene', variants: ['gene', 'genes'], topic: 'Genetics' },
    { id: 'G910B2', problem: 'What process do plants use to convert sunlight into energy?', answer: 'photosynthesis', variants: ['photosynthesis'], topic: 'Photosynthesis' },
    { id: 'G910B3', problem: 'What are the four bases in DNA?', answer: 'A, T, C, G', variants: ['ATCG', 'A T C G', 'adenine thymine cytosine guanine'], topic: 'DNA' },
    { id: 'G910B4', problem: 'What type of blood cell fights infection?', answer: 'white blood cell', variants: ['white blood cell', 'WBC', 'leukocyte'], topic: 'Immune System' },
    { id: 'G910B5', problem: 'What organelle contains genetic material?', answer: 'nucleus', variants: ['nucleus', 'the nucleus'], topic: 'Cell Structure' },
    { id: 'G910B6', problem: 'What are the three types of RNA?', answer: 'mRNA, tRNA, rRNA', variants: ['mrna trna rrna', 'messenger transfer ribosomal'], topic: 'Molecular Biology' },
    { id: 'G910B7', problem: 'What process do cells use to divide for growth?', answer: 'mitosis', variants: ['mitosis'], topic: 'Cell Division' },
    { id: 'G910B8', problem: 'What is the universal energy currency of cells?', answer: 'ATP', variants: ['ATP', 'adenosine triphosphate'], topic: 'Cellular Energy' },
    { id: 'G910B9', problem: 'What blood type is the universal donor?', answer: 'O negative', variants: ['O-', 'O negative', 'type O negative'], topic: 'Immune System' }
  ],
  'Grade9-10_Chemistry': [
    { id: 'G910C1', problem: 'What is the chemical symbol for sodium?', answer: 'Na', variants: ['Na'], topic: 'Elements' },
    { id: 'G910C2', problem: 'How many electrons can the first shell hold?', answer: '2', variants: ['2', 'two'], topic: 'Electron Configuration' },
    { id: 'G910C3', problem: 'What is the pH of a neutral solution?', answer: '7', variants: ['7', 'seven'], topic: 'Acids and Bases' },
    { id: 'G910C4', problem: 'Balance: H₂ + O₂ → H₂O. What coefficient goes in front of H₂O?', answer: '2', variants: ['2'], topic: 'Balancing Equations' },
    { id: 'G910C5', problem: 'What is the molar mass of water (H₂O)?', answer: '18', variants: ['18', '18 g/mol'], topic: 'Molar Mass' },
    { id: 'G910C6', problem: 'What is the symbol for potassium?', answer: 'K', variants: ['K'], topic: 'Elements' },
    { id: 'G910C7', problem: 'How many protons does carbon have?', answer: '6', variants: ['6', 'six'], topic: 'Atomic Structure' },
    { id: 'G910C8', problem: 'What type of bond forms between metals?', answer: 'metallic', variants: ['metallic', 'metallic bond'], topic: 'Chemical Bonding' },
    { id: 'G910C9', problem: 'What is the pH of a strong acid?', answer: '0-3', variants: ['low', 'below 7', '0-3', 'less than 7'], topic: 'Acids and Bases' }
  ],
  'Grade9-10_Physics': [
    { id: 'G910P1', problem: 'What is Newton\'s second law? F = ?', answer: 'F = ma', variants: ['ma', 'F=ma', 'mass times acceleration'], topic: 'Newton\'s Laws' },
    { id: 'G910P2', problem: 'A car moves at 20 m/s. After 5 seconds of acceleration at 2 m/s², what is its new velocity?', answer: '30', variants: ['30', '30 m/s'], topic: 'Kinematics' },
    { id: 'G910P3', problem: 'What is the kinetic energy of a 2 kg object moving at 3 m/s? (KE = ½mv²)', answer: '9', variants: ['9', '9 J'], topic: 'Energy' },
    { id: 'G910P4', problem: 'What is the unit of electric current?', answer: 'Ampere', variants: ['Ampere', 'A', 'Amp'], topic: 'Electricity' },
    { id: 'G910P5', problem: 'What is the frequency of a wave with wavelength 2 m traveling at 10 m/s?', answer: '5', variants: ['5', '5 Hz'], topic: 'Waves' },
    { id: 'G910P6', problem: 'What is the formula for momentum?', answer: 'p = mv', variants: ['mv', 'p=mv', 'mass times velocity'], topic: 'Momentum' },
    { id: 'G910P7', problem: 'What is the unit of frequency?', answer: 'Hertz', variants: ['Hertz', 'Hz'], topic: 'Waves' },
    { id: 'G910P8', problem: 'What type of current alternates direction?', answer: 'AC', variants: ['AC', 'alternating current'], topic: 'Electricity' },
    { id: 'G910P9', problem: 'What is the acceleration due to gravity (approximate)?', answer: '9.8', variants: ['9.8', '9.8 m/s²', '10 m/s²'], topic: 'Gravity' }
  ],

  // ========================================
  // 11-12 (LATE HIGH SCHOOL)
  // ========================================
  'Grade11-12_Calculus': [
    { id: 'G1112M1', problem: 'Find the derivative of f(x) = x³', answer: '3x²', variants: ['3x²', '3x^2', '3*x^2'], topic: 'Derivatives' },
    { id: 'G1112M2', problem: 'What is the integral of 2x?', answer: 'x²', variants: ['x²', 'x^2', 'x squared'], topic: 'Integrals' },
    { id: 'G1112M3', problem: 'Evaluate: lim(x→0) sin(x)/x', answer: '1', variants: ['1'], topic: 'Limits' },
    { id: 'G1112M4', problem: 'Find dy/dx if y = eˣ', answer: 'eˣ', variants: ['e^x', 'eˣ', 'exp(x)'], topic: 'Exponential Functions' },
    { id: 'G1112M5', problem: 'What is the second derivative of x⁴?', answer: '12x²', variants: ['12x²', '12x^2'], topic: 'Higher Derivatives' },
    { id: 'G1112M6', problem: 'What is the derivative of sin(x)?', answer: 'cos(x)', variants: ['cos(x)', 'cosx'], topic: 'Trigonometric Derivatives' },
    { id: 'G1112M7', problem: 'What is the integral of x?', answer: 'x²/2', variants: ['x^2/2', 'x²/2', '(1/2)x^2'], topic: 'Integrals' },
    { id: 'G1112M8', problem: 'Find the derivative of x²', answer: '2x', variants: ['2x'], topic: 'Derivatives' },
    { id: 'G1112M9', problem: 'What is lim(x→∞) 1/x?', answer: '0', variants: ['0', 'zero'], topic: 'Limits' }
  ],
  'Grade11-12_Biology': [
    { id: 'G1112B1', problem: 'What is the final stage of mitosis?', answer: 'telophase', variants: ['telophase'], topic: 'Cell Division' },
    { id: 'G1112B2', problem: 'What molecule carries genetic information?', answer: 'DNA', variants: ['DNA', 'deoxyribonucleic acid'], topic: 'Molecular Biology' },
    { id: 'G1112B3', problem: 'What type of selection favors extreme phenotypes?', answer: 'disruptive', variants: ['disruptive', 'disruptive selection'], topic: 'Evolution' },
    { id: 'G1112B4', problem: 'What is the site of protein synthesis?', answer: 'ribosome', variants: ['ribosome', 'ribosomes'], topic: 'Protein Synthesis' },
    { id: 'G1112B5', problem: 'What is the study of energy flow through ecosystems called?', answer: 'energetics', variants: ['energetics', 'ecosystem energetics'], topic: 'Ecology' },
    { id: 'G1112B6', problem: 'What is the process of making proteins called?', answer: 'translation', variants: ['translation'], topic: 'Protein Synthesis' },
    { id: 'G1112B7', problem: 'What is the first stage of mitosis?', answer: 'prophase', variants: ['prophase'], topic: 'Cell Division' },
    { id: 'G1112B8', problem: 'What molecule stores genetic information?', answer: 'DNA', variants: ['DNA', 'deoxyribonucleic acid'], topic: 'Molecular Biology' },
    { id: 'G1112B9', problem: 'What type of selection reduces variation?', answer: 'stabilizing', variants: ['stabilizing', 'stabilizing selection'], topic: 'Evolution' }
  ],
  'Grade11-12_Chemistry': [
    { id: 'G1112C1', problem: 'What is the ideal gas constant R in SI units?', answer: '8.314', variants: ['8.314', '8.314 J/(mol·K)'], topic: 'Gas Laws' },
    { id: 'G1112C2', problem: 'What type of bond involves the sharing of electrons?', answer: 'covalent', variants: ['covalent', 'covalent bond'], topic: 'Chemical Bonding' },
    { id: 'G1112C3', problem: 'Calculate the molarity of a solution with 2 moles of solute in 4 liters.', answer: '0.5', variants: ['0.5', '0.5 M'], topic: 'Molarity' },
    { id: 'G1112C4', problem: 'What is the oxidation number of oxygen in H₂O?', answer: '-2', variants: ['-2'], topic: 'Oxidation States' },
    { id: 'G1112C5', problem: 'What principle states that orbitals fill from lowest to highest energy?', answer: 'Aufbau', variants: ['Aufbau', 'Aufbau principle'], topic: 'Electron Configuration' },
    { id: 'G1112C6', problem: 'What is the unit of pressure?', answer: 'Pascal', variants: ['Pascal', 'Pa', 'atm'], topic: 'Gas Laws' },
    { id: 'G1112C7', problem: 'What type of bond involves electron sharing?', answer: 'covalent', variants: ['covalent', 'covalent bond'], topic: 'Chemical Bonding' },
    { id: 'G1112C8', problem: 'What is Avogadro\'s number (order of magnitude)?', answer: '6.022 × 10²³', variants: ['6.022e23', '6.022 × 10²³'], topic: 'Molar Calculations' },
    { id: 'G1112C9', problem: 'What is the oxidation number of hydrogen in H₂O?', answer: '+1', variants: ['+1', '1'], topic: 'Oxidation States' }
  ],
  'Grade11-12_Physics': [
    { id: 'G1112P1', problem: 'What is the escape velocity from Earth (approximately)?', answer: '11.2', variants: ['11.2', '11.2 km/s', '11200 m/s'], topic: 'Gravitation' },
    { id: 'G1112P2', problem: 'What is Planck\'s constant (approximately)?', answer: '6.626 × 10⁻³⁴', variants: ['6.626e-34', '6.626 × 10⁻³⁴'], topic: 'Quantum Physics' },
    { id: 'G1112P3', problem: 'What is the first law of thermodynamics about?', answer: 'energy conservation', variants: ['conservation of energy', 'energy conservation'], topic: 'Thermodynamics' },
    { id: 'G1112P4', problem: 'What particle has no charge?', answer: 'neutron', variants: ['neutron', 'neutrons'], topic: 'Particle Physics' },
    { id: 'G1112P5', problem: 'What is the speed of light in m/s?', answer: '3 × 10⁸', variants: ['3×10^8', '3e8', '300000000'], topic: 'Electromagnetism' },
    { id: 'G1112P6', problem: 'What is the second law of thermodynamics about?', answer: 'entropy', variants: ['entropy', 'entropy increases'], topic: 'Thermodynamics' },
    { id: 'G1112P7', problem: 'What is the gravitational constant G approximately?', answer: '6.67 × 10⁻¹¹', variants: ['6.67e-11', '6.67 × 10⁻¹¹'], topic: 'Gravitation' },
    { id: 'G1112P8', problem: 'What particle has a negative charge?', answer: 'electron', variants: ['electron', 'electrons'], topic: 'Particle Physics' },
    { id: 'G1112P9', problem: 'What is the formula for wavelength?', answer: 'λ = v/f', variants: ['v/f', 'λ = v/f', 'wavelength = velocity/frequency'], topic: 'Quantum Physics' }
  ],

  // ========================================
  // EXTENDED TESTS - 80 MORE TESTS
  // ========================================

  // Advanced Mathematics (10 tests)
  'Advanced_Mathematics': [
    { id: 'ADV_M1', problem: '15, 30, 45, __, 75. Fill in the blank.', answer: '60', variants: ['60', 'sixty'], topic: 'Number Patterns' },
    { id: 'ADV_M2', problem: 'Solve: 5x - 3 = 22', answer: 'x = 5', variants: ['5', 'x=5', 'x = 5'], topic: 'Linear Equations' },
    { id: 'ADV_M3', problem: 'What is the slope formula? m = ?', answer: 'm = (y₂-y₁)/(x₂-x₁)', variants: ['rise over run', 'change in y over change in x', '(y2-y1)/(x2-x1)'], topic: 'Slope' },
    { id: 'ADV_M4', problem: '12 + 8 = ?', answer: '20', variants: ['20', 'twenty'], topic: 'Addition' },
    { id: 'ADV_M5', problem: 'What is the quadratic formula?', answer: 'x = (-b ± √(b²-4ac))/(2a)', variants: ['quadratic formula', 'x = -b plus or minus'], topic: 'Quadratics' },
    { id: 'ADV_M6', problem: 'Factor: x² - 9', answer: '(x+3)(x-3)', variants: ['(x+3)(x-3)', '(x-3)(x+3)'], topic: 'Factoring' },
    { id: 'ADV_M7', problem: '24 ÷ 6 = ?', answer: '4', variants: ['4', 'four'], topic: 'Division' },
    { id: 'ADV_M8', problem: 'Simplify: 2(3x + 4)', answer: '6x + 8', variants: ['6x+8', '6x + 8'], topic: 'Distribution' },
    { id: 'ADV_M9', problem: 'What is 15% of 200?', answer: '30', variants: ['30'], topic: 'Percentages' },
    { id: 'ADV_M10', problem: 'Solve: 2x + 7 = 15', answer: 'x = 4', variants: ['4', 'x=4', 'x = 4'], topic: 'Equations' },
    { id: 'ADV_M11', problem: '15 + 8 = ?', answer: '23', variants: ['23', 'twenty-three'], topic: 'Addition' },
    { id: 'ADV_M12', problem: '72 ÷ 9 = ?', answer: '8', variants: ['8', 'eight'], topic: 'Division' },
    { id: 'ADV_M13', problem: 'Simplify: 5(2x - 1)', answer: '10x - 5', variants: ['10x-5', '10x - 5'], topic: 'Distribution' },
    { id: 'ADV_M14', problem: 'What is 20% of 150?', answer: '30', variants: ['30'], topic: 'Percentages' }
  ],

  // Biology - Advanced Topics (10 tests)
  'Advanced_Biology': [
    { id: 'ADV_B1', problem: 'What process do plants use to convert light into energy?', answer: 'photosynthesis', variants: ['photosynthesis'], topic: 'Photosynthesis' },
    { id: 'ADV_B2', problem: 'What process do cells use to convert glucose into ATP?', answer: 'cellular respiration', variants: ['cellular respiration', 'respiration'], topic: 'Cellular Respiration' },
    { id: 'ADV_B3', problem: 'What organelle is responsible for photosynthesis?', answer: 'chloroplast', variants: ['chloroplast', 'chloroplasts'], topic: 'Cell Organelles' },
    { id: 'ADV_B4', problem: 'What is the basic unit of life?', answer: 'cell', variants: ['cell', 'the cell'], topic: 'Cell Theory' },
    { id: 'ADV_B5', problem: 'What molecule stores genetic information?', answer: 'DNA', variants: ['DNA', 'deoxyribonucleic acid'], topic: 'Genetics' },
    { id: 'ADV_B6', problem: 'What type of selection occurs in a stable environment?', answer: 'stabilizing', variants: ['stabilizing', 'stabilizing selection'], topic: 'Evolution' },
    { id: 'ADV_B7', problem: 'What type of selection favors extreme phenotypes?', answer: 'disruptive', variants: ['disruptive', 'disruptive selection'], topic: 'Natural Selection' },
    { id: 'ADV_B8', problem: 'What is the powerhouse of the cell?', answer: 'mitochondria', variants: ['mitochondria', 'mitochondrion'], topic: 'Cell Biology' },
    { id: 'ADV_B9', problem: 'What are the products of photosynthesis?', answer: 'glucose and oxygen', variants: ['glucose and oxygen', 'sugar and oxygen', 'glucose & O2'], topic: 'Photosynthesis Products' },
    { id: 'ADV_B10', problem: 'What is the study of heredity called?', answer: 'genetics', variants: ['genetics'], topic: 'Genetics' },
    { id: 'ADV_B11', problem: 'What process do plants use to make glucose?', answer: 'photosynthesis', variants: ['photosynthesis'], topic: 'Photosynthesis' },
    { id: 'ADV_B12', problem: 'What is the control center of the cell?', answer: 'nucleus', variants: ['nucleus', 'the nucleus'], topic: 'Cell Biology' },
    { id: 'ADV_B13', problem: 'What are the products of cellular respiration?', answer: 'CO2 and water', variants: ['CO2 and water', 'carbon dioxide and water', 'co2 water'], topic: 'Cellular Respiration' },
    { id: 'ADV_B14', problem: 'What type of cell has a nucleus?', answer: 'eukaryotic', variants: ['eukaryotic', 'eukaryote'], topic: 'Cell Theory' }
  ],

  // Chemistry - Extended (10 tests)
  'Advanced_Chemistry': [
    { id: 'ADV_C1', problem: 'What is the chemical formula for water?', answer: 'H₂O', variants: ['H2O', 'H₂O'], topic: 'Chemical Formulas' },
    { id: 'ADV_C2', problem: 'What is the pH of pure water?', answer: '7', variants: ['7', 'seven'], topic: 'pH' },
    { id: 'ADV_C3', problem: 'What type of bond involves electron sharing?', answer: 'covalent', variants: ['covalent', 'covalent bond'], topic: 'Chemical Bonds' },
    { id: 'ADV_C4', problem: 'What type of bond involves electron transfer?', answer: 'ionic', variants: ['ionic', 'ionic bond'], topic: 'Ionic Bonds' },
    { id: 'ADV_C5', problem: 'What is the symbol for gold?', answer: 'Au', variants: ['Au'], topic: 'Elements' },
    { id: 'ADV_C6', problem: 'What is the symbol for iron?', answer: 'Fe', variants: ['Fe'], topic: 'Periodic Table' },
    { id: 'ADV_C7', problem: 'What is the atomic number of carbon?', answer: '6', variants: ['6', 'six'], topic: 'Atomic Structure' },
    { id: 'ADV_C8', problem: 'How many valence electrons does oxygen have?', answer: '6', variants: ['6', 'six'], topic: 'Electron Configuration' },
    { id: 'ADV_C9', problem: 'What phase change occurs when a solid becomes a gas?', answer: 'sublimation', variants: ['sublimation'], topic: 'Phase Changes' },
    { id: 'ADV_C10', problem: 'What is Avogadro\'s number (approximately)?', answer: '6.022 × 10²³', variants: ['6.022e23', '6.022 × 10²³', '6.02 × 10²³'], topic: 'Molar Calculations' },
    { id: 'ADV_C11', problem: 'What is the formula for carbon dioxide?', answer: 'CO2', variants: ['CO2', 'co2'], topic: 'Chemical Formulas' },
    { id: 'ADV_C12', problem: 'What is the pH of a neutral solution?', answer: '7', variants: ['7', 'seven'], topic: 'pH' },
    { id: 'ADV_C13', problem: 'What is the symbol for calcium?', answer: 'Ca', variants: ['Ca'], topic: 'Elements' },
    { id: 'ADV_C14', problem: 'How many electrons can the second shell hold?', answer: '8', variants: ['8', 'eight'], topic: 'Electron Configuration' }
  ],

  // Physics - Extended (10 tests)
  'Advanced_Physics': [
    { id: 'ADV_P1', problem: 'What is Newton\'s second law? F = ?', answer: 'F = ma', variants: ['ma', 'F=ma', 'mass times acceleration'], topic: 'Newton\'s Laws' },
    { id: 'ADV_P2', problem: 'What is the formula for kinetic energy?', answer: 'KE = ½mv²', variants: ['1/2 mv²', '½mv²', 'KE = 1/2 mv^2'], topic: 'Energy' },
    { id: 'ADV_P3', problem: 'What is the unit of power?', answer: 'Watt', variants: ['Watt', 'W', 'Watts'], topic: 'Power' },
    { id: 'ADV_P4', problem: 'What is Ohm\'s law? V = ?', answer: 'V = IR', variants: ['IR', 'V=IR'], topic: 'Electricity' },
    { id: 'ADV_P5', problem: 'What type of energy does a raised object have?', answer: 'potential', variants: ['potential', 'potential energy', 'gravitational potential'], topic: 'Potential Energy' },
    { id: 'ADV_P6', problem: 'What causes an object to accelerate?', answer: 'force', variants: ['force', 'a force', 'net force'], topic: 'Forces' },
    { id: 'ADV_P7', problem: 'What is the speed of sound in air (approximately)?', answer: '343', variants: ['343', '343 m/s', '340 m/s'], topic: 'Waves' },
    { id: 'ADV_P8', problem: 'What type of current flows in one direction?', answer: 'direct', variants: ['direct', 'DC', 'direct current'], topic: 'Electricity' },
    { id: 'ADV_P9', problem: 'What is the formula for gravitational potential energy?', answer: 'PE = mgh', variants: ['mgh', 'PE=mgh'], topic: 'Gravitational Energy' },
    { id: 'ADV_P10', problem: 'What is the acceleration due to gravity on Earth (approximately)?', answer: '9.8', variants: ['9.8', '9.8 m/s²', '10 m/s²'], topic: 'Gravity' },
    { id: 'ADV_P11', problem: 'What is the formula for work?', answer: 'W = Fd', variants: ['W=Fd', 'Fd', 'force times distance'], topic: 'Work' },
    { id: 'ADV_P12', problem: 'What is the unit of power?', answer: 'Watt', variants: ['Watt', 'W', 'Watts'], topic: 'Power' },
    { id: 'ADV_P13', problem: 'What type of energy is in a stretched spring?', answer: 'potential', variants: ['potential', 'elastic potential', 'potential energy'], topic: 'Energy' },
    { id: 'ADV_P14', problem: 'What is the formula for kinetic energy?', answer: 'KE = ½mv²', variants: ['1/2 mv²', '½mv²', 'KE = 1/2 mv^2'], topic: 'Energy' }
  ],

  // Earth Science - Extended (10 tests)
  'Advanced_Earth_Science': [
    { id: 'ADV_E1', problem: 'What causes tides on Earth?', answer: 'the moon', variants: ['moon', 'the moon', 'moon\'s gravity'], topic: 'Tides' },
    { id: 'ADV_E2', problem: 'What type of plate boundary creates mountains?', answer: 'convergent', variants: ['convergent', 'convergent boundary'], topic: 'Plate Tectonics' },
    { id: 'ADV_E3', problem: 'What type of rock forms from cooling magma?', answer: 'igneous', variants: ['igneous', 'igneous rock'], topic: 'Rock Types' },
    { id: 'ADV_E4', problem: 'What layer of Earth contains the crust and upper mantle?', answer: 'lithosphere', variants: ['lithosphere'], topic: 'Earth Layers' },
    { id: 'ADV_E5', problem: 'What scale measures earthquake magnitude?', answer: 'Richter', variants: ['Richter', 'Richter scale'], topic: 'Earthquakes' },
    { id: 'ADV_E6', problem: 'What gas makes up most of Earth\'s atmosphere?', answer: 'nitrogen', variants: ['nitrogen', 'N2'], topic: 'Atmosphere' },
    { id: 'ADV_E7', problem: 'What process moves water from liquid to gas?', answer: 'evaporation', variants: ['evaporation'], topic: 'Water Cycle' },
    { id: 'ADV_E8', problem: 'What type of volcano has explosive eruptions?', answer: 'composite', variants: ['composite', 'stratovolcano'], topic: 'Volcanoes' },
    { id: 'ADV_E9', problem: 'What causes seasons on Earth?', answer: 'axial tilt', variants: ['tilt', 'axial tilt', 'Earth\'s tilt'], topic: 'Seasons' },
    { id: 'ADV_E10', problem: 'What is the study of weather called?', answer: 'meteorology', variants: ['meteorology'], topic: 'Meteorology' },
    { id: 'ADV_E11', problem: 'What causes day and night on Earth?', answer: 'rotation', variants: ['rotation', 'Earth\'s rotation'], topic: 'Earth Rotation' },
    { id: 'ADV_E12', problem: 'What type of plate boundary causes earthquakes?', answer: 'transform', variants: ['transform', 'transform boundary'], topic: 'Plate Tectonics' },
    { id: 'ADV_E13', problem: 'What layer of atmosphere contains ozone?', answer: 'stratosphere', variants: ['stratosphere'], topic: 'Atmosphere' },
    { id: 'ADV_E14', problem: 'What is molten rock called when underground?', answer: 'magma', variants: ['magma'], topic: 'Volcanoes' }
  ],

  // English Language Arts - Grammar (10 tests)
  'English_Grammar': [
    { id: 'ENG_G1', problem: 'What part of speech describes an action?', answer: 'verb', variants: ['verb'], topic: 'Parts of Speech' },
    { id: 'ENG_G2', problem: 'What punctuation mark ends a question?', answer: 'question mark', variants: ['question mark', '?'], topic: 'Punctuation' },
    { id: 'ENG_G3', problem: 'What is the plural of "child"?', answer: 'children', variants: ['children'], topic: 'Plurals' },
    { id: 'ENG_G4', problem: 'What type of word modifies a verb?', answer: 'adverb', variants: ['adverb'], topic: 'Adverbs' },
    { id: 'ENG_G5', problem: 'What type of word modifies a noun?', answer: 'adjective', variants: ['adjective'], topic: 'Adjectives' },
    { id: 'ENG_G6', problem: 'What is the past tense of "run"?', answer: 'ran', variants: ['ran'], topic: 'Verb Tenses' },
    { id: 'ENG_G7', problem: 'What is the subject in "The dog barks"?', answer: 'dog', variants: ['dog', 'the dog'], topic: 'Sentence Structure' },
    { id: 'ENG_G8', problem: 'What type of sentence asks a question?', answer: 'interrogative', variants: ['interrogative', 'question'], topic: 'Sentence Types' },
    { id: 'ENG_G9', problem: 'What connects two independent clauses?', answer: 'conjunction', variants: ['conjunction', 'coordinating conjunction'], topic: 'Conjunctions' },
    { id: 'ENG_G10', problem: 'What is the comparative form of "good"?', answer: 'better', variants: ['better'], topic: 'Comparatives' },
    { id: 'ENG_G11', problem: 'What is the plural of "mouse"?', answer: 'mice', variants: ['mice'], topic: 'Plurals' },
    { id: 'ENG_G12', problem: 'What type of word modifies an adjective?', answer: 'adverb', variants: ['adverb'], topic: 'Adverbs' },
    { id: 'ENG_G13', problem: 'What is the past tense of "go"?', answer: 'went', variants: ['went'], topic: 'Verb Tenses' },
    { id: 'ENG_G14', problem: 'What connects two words or phrases?', answer: 'conjunction', variants: ['conjunction'], topic: 'Conjunctions' }
  ],

  // US History (10 tests)
  'US_History': [
    { id: 'HIST_US1', problem: 'What year did America declare independence?', answer: '1776', variants: ['1776'], topic: 'American Revolution' },
    { id: 'HIST_US2', problem: 'Who was the first President of the United States?', answer: 'George Washington', variants: ['Washington', 'George Washington'], topic: 'Presidents' },
    { id: 'HIST_US3', problem: 'What document begins "We the People"?', answer: 'Constitution', variants: ['Constitution', 'US Constitution'], topic: 'Founding Documents' },
    { id: 'HIST_US4', problem: 'How many original colonies were there?', answer: '13', variants: ['13', 'thirteen'], topic: 'Colonial America' },
    { id: 'HIST_US5', problem: 'What war was fought from 1861-1865?', answer: 'Civil War', variants: ['Civil War', 'American Civil War'], topic: 'Civil War' },
    { id: 'HIST_US6', problem: 'Who wrote the Declaration of Independence?', answer: 'Thomas Jefferson', variants: ['Jefferson', 'Thomas Jefferson'], topic: 'Declaration' },
    { id: 'HIST_US7', problem: 'What ocean is on the east coast of the United States?', answer: 'Atlantic', variants: ['Atlantic', 'Atlantic Ocean'], topic: 'Geography' },
    { id: 'HIST_US8', problem: 'How many branches of government does the US have?', answer: '3', variants: ['3', 'three'], topic: 'Government' },
    { id: 'HIST_US9', problem: 'What year did World War II end?', answer: '1945', variants: ['1945'], topic: 'World War II' },
    { id: 'HIST_US10', problem: 'Who gave the "I Have a Dream" speech?', answer: 'Martin Luther King Jr.', variants: ['MLK', 'Martin Luther King', 'King'], topic: 'Civil Rights' },
    { id: 'HIST_US11', problem: 'What was the first capital of the United States?', answer: 'New York', variants: ['New York', 'New York City', 'NYC'], topic: 'US History' },
    { id: 'HIST_US12', problem: 'How many amendments are in the Bill of Rights?', answer: '10', variants: ['10', 'ten'], topic: 'Government' },
    { id: 'HIST_US13', problem: 'What ocean is on the west coast of the United States?', answer: 'Pacific', variants: ['Pacific', 'Pacific Ocean'], topic: 'Geography' },
    { id: 'HIST_US14', problem: 'Who was the 16th President?', answer: 'Abraham Lincoln', variants: ['Lincoln', 'Abraham Lincoln', 'Abe Lincoln'], topic: 'Presidents' }
  ],

  // World History (10 tests)
  'World_History': [
    { id: 'HIST_W1', problem: 'What ancient civilization built the pyramids?', answer: 'Egypt', variants: ['Egypt', 'Egyptians', 'Ancient Egypt'], topic: 'Ancient Civilizations' },
    { id: 'HIST_W2', problem: 'What year did World War I begin?', answer: '1914', variants: ['1914'], topic: 'World War I' },
    { id: 'HIST_W3', problem: 'What empire did Julius Caesar lead?', answer: 'Roman', variants: ['Roman', 'Rome', 'Roman Empire'], topic: 'Ancient Rome' },
    { id: 'HIST_W4', problem: 'What wall separated East and West Germany?', answer: 'Berlin Wall', variants: ['Berlin Wall', 'the Berlin Wall'], topic: 'Cold War' },
    { id: 'HIST_W5', problem: 'What disease caused the Black Death?', answer: 'plague', variants: ['plague', 'bubonic plague'], topic: 'Medieval History' },
    { id: 'HIST_W6', problem: 'Who was the first emperor of China?', answer: 'Qin Shi Huang', variants: ['Qin Shi Huang', 'Qin', 'Shi Huang'], topic: 'Chinese History' },
    { id: 'HIST_W7', problem: 'What revolution began in France in 1789?', answer: 'French Revolution', variants: ['French Revolution'], topic: 'Revolutions' },
    { id: 'HIST_W8', problem: 'What ship sank in 1912 after hitting an iceberg?', answer: 'Titanic', variants: ['Titanic', 'the Titanic'], topic: '20th Century' },
    { id: 'HIST_W9', problem: 'What continent is the Sahara Desert on?', answer: 'Africa', variants: ['Africa'], topic: 'Geography' },
    { id: 'HIST_W10', problem: 'What Italian city is famous for its canals?', answer: 'Venice', variants: ['Venice'], topic: 'European Geography' },
    { id: 'HIST_W11', problem: 'What year did World War II end?', answer: '1945', variants: ['1945'], topic: 'World War II' },
    { id: 'HIST_W12', problem: 'Who was the first person to walk on the moon?', answer: 'Neil Armstrong', variants: ['Neil Armstrong', 'Armstrong'], topic: '20th Century' },
    { id: 'HIST_W13', problem: 'What wall fell in 1989?', answer: 'Berlin Wall', variants: ['Berlin Wall', 'the Berlin Wall'], topic: 'Cold War' },
    { id: 'HIST_W14', problem: 'What is the largest continent?', answer: 'Asia', variants: ['Asia'], topic: 'Geography' }
  ]
};

console.log(`\n📊 COMPREHENSIVE TEST SUITE LOADED`);
console.log(`Total test categories: ${Object.keys(COMPREHENSIVE_TESTS).length}`);
let totalTests = 0;
Object.values(COMPREHENSIVE_TESTS).forEach(tests => totalTests += tests.length);
console.log(`Total tests: ${totalTests}\n`);

module.exports = { COMPREHENSIVE_TESTS, CONFIG };

