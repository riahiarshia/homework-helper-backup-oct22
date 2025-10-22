const fs = require('fs');
const path = require('path');

const filePath = path.join(__dirname, 'comprehensive-tests.js');
let content = fs.readFileSync(filePath, 'utf8');

// Remaining categories (68 more questions needed)
const additions = [
  // Grade9-10_Algebra
  {
    category: 'Grade9-10_Algebra',
    after: "{ id: 'G910A5', problem: 'Evaluate: (-2)³', answer: '-8', variants: ['-8'], topic: 'Exponents' }",
    add: `,
    { id: 'G910A6', problem: 'Factor: x² - 16', answer: '(x+4)(x-4)', variants: ['(x+4)(x-4)', '(x-4)(x+4)'], topic: 'Factoring' },
    { id: 'G910A7', problem: 'Simplify: √64', answer: '8', variants: ['8', 'eight'], topic: 'Radicals' },
    { id: 'G910A8', problem: 'What is the slope of y = -2x + 3?', answer: '-2', variants: ['-2'], topic: 'Linear Equations' },
    { id: 'G910A9', problem: 'Solve: x² = 25', answer: 'x = ±5', variants: ['±5', '5', '-5', 'x=5 or x=-5'], topic: 'Quadratic Equations' }`
  },
  
  // Grade9-10_Geometry
  {
    category: 'Grade9-10_Geometry',
    after: "{ id: 'G910G5', problem: 'In a 30-60-90 triangle, if the shortest side is 1, what is the hypotenuse?', answer: '2', variants: ['2'], topic: 'Special Triangles' }",
    add: `,
    { id: 'G910G6', problem: 'What is the sum of angles in a quadrilateral?', answer: '360', variants: ['360', '360°', '360 degrees'], topic: 'Angles' },
    { id: 'G910G7', problem: 'What is the circumference formula for a circle?', answer: 'C = 2πr', variants: ['2πr', '2*pi*r', 'C=2πr'], topic: 'Circles' },
    { id: 'G910G8', problem: 'What is the volume formula for a sphere?', answer: 'V = (4/3)πr³', variants: ['4/3*pi*r^3', '(4/3)πr³'], topic: 'Volume' },
    { id: 'G910G9', problem: 'If two angles are supplementary and one is 120°, what is the other?', answer: '60', variants: ['60', '60°'], topic: 'Angle Relationships' }`
  },
  
  // Grade9-10_Biology
  {
    category: 'Grade9-10_Biology',
    after: "{ id: 'G910B5', problem: 'What organelle contains genetic material?', answer: 'nucleus', variants: ['nucleus', 'the nucleus'], topic: 'Cell Structure' }",
    add: `,
    { id: 'G910B6', problem: 'What are the three types of RNA?', answer: 'mRNA, tRNA, rRNA', variants: ['mrna trna rrna', 'messenger transfer ribosomal'], topic: 'Molecular Biology' },
    { id: 'G910B7', problem: 'What process do cells use to divide for growth?', answer: 'mitosis', variants: ['mitosis'], topic: 'Cell Division' },
    { id: 'G910B8', problem: 'What is the universal energy currency of cells?', answer: 'ATP', variants: ['ATP', 'adenosine triphosphate'], topic: 'Cellular Energy' },
    { id: 'G910B9', problem: 'What blood type is the universal donor?', answer: 'O negative', variants: ['O-', 'O negative', 'type O negative'], topic: 'Immune System' }`
  },
  
  // Grade9-10_Chemistry
  {
    category: 'Grade9-10_Chemistry',
    after: "{ id: 'G910C5', problem: 'What is the molar mass of water (H₂O)?', answer: '18', variants: ['18', '18 g/mol'], topic: 'Molar Mass' }",
    add: `,
    { id: 'G910C6', problem: 'What is the symbol for potassium?', answer: 'K', variants: ['K'], topic: 'Elements' },
    { id: 'G910C7', problem: 'How many protons does carbon have?', answer: '6', variants: ['6', 'six'], topic: 'Atomic Structure' },
    { id: 'G910C8', problem: 'What type of bond forms between metals?', answer: 'metallic', variants: ['metallic', 'metallic bond'], topic: 'Chemical Bonding' },
    { id: 'G910C9', problem: 'What is the pH of a strong acid?', answer: '0-3', variants: ['low', 'below 7', '0-3', 'less than 7'], topic: 'Acids and Bases' }`
  },
  
  // Grade9-10_Physics
  {
    category: 'Grade9-10_Physics',
    after: "{ id: 'G910P5', problem: 'What is the frequency of a wave with wavelength 2 m traveling at 10 m/s?', answer: '5', variants: ['5', '5 Hz'], topic: 'Waves' }",
    add: `,
    { id: 'G910P6', problem: 'What is the formula for momentum?', answer: 'p = mv', variants: ['mv', 'p=mv', 'mass times velocity'], topic: 'Momentum' },
    { id: 'G910P7', problem: 'What is the unit of frequency?', answer: 'Hertz', variants: ['Hertz', 'Hz'], topic: 'Waves' },
    { id: 'G910P8', problem: 'What type of current alternates direction?', answer: 'AC', variants: ['AC', 'alternating current'], topic: 'Electricity' },
    { id: 'G910P9', problem: 'What is the acceleration due to gravity (approximate)?', answer: '9.8', variants: ['9.8', '9.8 m/s²', '10 m/s²'], topic: 'Gravity' }`
  },
  
  // Grade11-12_Calculus
  {
    category: 'Grade11-12_Calculus',
    after: "{ id: 'G1112M5', problem: 'What is the second derivative of x⁴?', answer: '12x²', variants: ['12x²', '12x^2'], topic: 'Higher Derivatives' }",
    add: `,
    { id: 'G1112M6', problem: 'What is the derivative of sin(x)?', answer: 'cos(x)', variants: ['cos(x)', 'cosx'], topic: 'Trigonometric Derivatives' },
    { id: 'G1112M7', problem: 'What is the integral of x?', answer: 'x²/2', variants: ['x^2/2', 'x²/2', '(1/2)x^2'], topic: 'Integrals' },
    { id: 'G1112M8', problem: 'Find the derivative of x²', answer: '2x', variants: ['2x'], topic: 'Derivatives' },
    { id: 'G1112M9', problem: 'What is lim(x→∞) 1/x?', answer: '0', variants: ['0', 'zero'], topic: 'Limits' }`
  },
  
  // Grade11-12_Biology
  {
    category: 'Grade11-12_Biology',
    after: "{ id: 'G1112B5', problem: 'What is the study of energy flow through ecosystems called?', answer: 'energetics', variants: ['energetics', 'ecosystem energetics'], topic: 'Ecology' }",
    add: `,
    { id: 'G1112B6', problem: 'What is the process of making proteins called?', answer: 'translation', variants: ['translation'], topic: 'Protein Synthesis' },
    { id: 'G1112B7', problem: 'What is the first stage of mitosis?', answer: 'prophase', variants: ['prophase'], topic: 'Cell Division' },
    { id: 'G1112B8', problem: 'What molecule stores genetic information?', answer: 'DNA', variants: ['DNA', 'deoxyribonucleic acid'], topic: 'Molecular Biology' },
    { id: 'G1112B9', problem: 'What type of selection reduces variation?', answer: 'stabilizing', variants: ['stabilizing', 'stabilizing selection'], topic: 'Evolution' }`
  },
  
  // Grade11-12_Chemistry
  {
    category: 'Grade11-12_Chemistry',
    after: "{ id: 'G1112C5', problem: 'What principle states that orbitals fill from lowest to highest energy?', answer: 'Aufbau', variants: ['Aufbau', 'Aufbau principle'], topic: 'Electron Configuration' }",
    add: `,
    { id: 'G1112C6', problem: 'What is the unit of pressure?', answer: 'Pascal', variants: ['Pascal', 'Pa', 'atm'], topic: 'Gas Laws' },
    { id: 'G1112C7', problem: 'What type of bond involves electron sharing?', answer: 'covalent', variants: ['covalent', 'covalent bond'], topic: 'Chemical Bonding' },
    { id: 'G1112C8', problem: 'What is Avogadro\\'s number (order of magnitude)?', answer: '6.022 × 10²³', variants: ['6.022e23', '6.022 × 10²³'], topic: 'Molar Calculations' },
    { id: 'G1112C9', problem: 'What is the oxidation number of hydrogen in H₂O?', answer: '+1', variants: ['+1', '1'], topic: 'Oxidation States' }`
  },
  
  // Grade11-12_Physics
  {
    category: 'Grade11-12_Physics',
    after: "{ id: 'G1112P5', problem: 'What is the speed of light in m/s?', answer: '3 × 10⁸', variants: ['3×10^8', '3e8', '300000000'], topic: 'Electromagnetism' }",
    add: `,
    { id: 'G1112P6', problem: 'What is the second law of thermodynamics about?', answer: 'entropy', variants: ['entropy', 'entropy increases'], topic: 'Thermodynamics' },
    { id: 'G1112P7', problem: 'What is the gravitational constant G approximately?', answer: '6.67 × 10⁻¹¹', variants: ['6.67e-11', '6.67 × 10⁻¹¹'], topic: 'Gravitation' },
    { id: 'G1112P8', problem: 'What particle has a negative charge?', answer: 'electron', variants: ['electron', 'electrons'], topic: 'Particle Physics' },
    { id: 'G1112P9', problem: 'What is the formula for wavelength?', answer: 'λ = v/f', variants: ['v/f', 'λ = v/f', 'wavelength = velocity/frequency'], topic: 'Quantum Physics' }`
  }
];

let count = 0;
additions.forEach((item) => {
  if (content.includes(item.after)) {
    content = content.replace(item.after, item.after + item.add);
    count += 4;
    console.log(`✅ Added 4 questions to ${item.category}`);
  } else {
    console.log(`⚠️  Could not find anchor for ${item.category}`);
  }
});

fs.writeFileSync(filePath, content, 'utf8');
console.log(`\n📝 Part 2 complete! Added ${count} more questions.`);
