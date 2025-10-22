const fs = require('fs');
const path = require('path');

// Read the current file
const filePath = path.join(__dirname, 'comprehensive-tests.js');
let content = fs.readFileSync(filePath, 'utf8');

// Define additions for each category (4 questions each × 25 categories = 100 questions)
const additions = [
  // Already added K-2 Math and Science (8 questions)
  
  // Grade3-5_Mathematics
  {
    after: "{ id: 'G35M5', problem: 'Round 47 to the nearest ten.', answer: '50', variants: ['50', 'fifty'], topic: 'Rounding' }",
    add: `,
    { id: 'G35M6', problem: '9 × 7 = ?', answer: '63', variants: ['63', 'sixty-three'], topic: 'Multiplication' },
    { id: 'G35M7', problem: '48 ÷ 8 = ?', answer: '6', variants: ['6', 'six'], topic: 'Division' },
    { id: 'G35M8', problem: 'What is 1/2 + 1/4?', answer: '3/4', variants: ['3/4', '0.75'], topic: 'Fractions' },
    { id: 'G35M9', problem: 'Round 83 to the nearest ten.', answer: '80', variants: ['80', 'eighty'], topic: 'Rounding' }`
  },
  
  // Grade3-5_Science
  {
    after: "{ id: 'G35S5', problem: 'What type of rock is formed by cooling lava?', answer: 'igneous', variants: ['igneous', 'igneous rock'], topic: 'Earth Science - Rocks' }",
    add: `,
    { id: 'G35S6', problem: 'What is H2O?', answer: 'water', variants: ['water'], topic: 'Physical Science - Matter' },
    { id: 'G35S7', problem: 'What planet is closest to the Sun?', answer: 'Mercury', variants: ['mercury'], topic: 'Earth Science - Solar System' },
    { id: 'G35S8', problem: 'What type of rock is formed by heat and pressure?', answer: 'metamorphic', variants: ['metamorphic', 'metamorphic rock'], topic: 'Earth Science - Rocks' },
    { id: 'G35S9', problem: 'What gas do plants release during photosynthesis?', answer: 'oxygen', variants: ['oxygen', 'O2'], topic: 'Life Science - Plants' }`
  },
  
  // Grade6-8_Mathematics
  {
    after: "{ id: 'G68M5', problem: 'What is the value of 2³?', answer: '8', variants: ['8', 'eight'], topic: 'Exponents' }",
    add: `,
    { id: 'G68M6', problem: 'Solve: 2x - 3 = 7', answer: 'x = 5', variants: ['5', 'x=5', 'x = 5'], topic: 'Pre-Algebra - Equations' },
    { id: 'G68M7', problem: 'What is 25% of 80?', answer: '20', variants: ['20'], topic: 'Percentages' },
    { id: 'G68M8', problem: 'What is the value of 3²?', answer: '9', variants: ['9', 'nine'], topic: 'Exponents' },
    { id: 'G68M9', problem: 'Simplify: 3(x + 2)', answer: '3x + 6', variants: ['3x+6', '3x + 6'], topic: 'Distributive Property' }`
  },
  
  // Grade6-8_Biology
  {
    after: "{ id: 'G68B5', problem: 'What is the process of cell division called?', answer: 'mitosis', variants: ['mitosis'], topic: 'Cell Division' }",
    add: `,
    { id: 'G68B6', problem: 'What is the basic unit of life?', answer: 'cell', variants: ['cell', 'the cell'], topic: 'Cell Biology' },
    { id: 'G68B7', problem: 'What carries oxygen in blood?', answer: 'red blood cells', variants: ['red blood cells', 'RBC', 'hemoglobin'], topic: 'Human Body' },
    { id: 'G68B8', problem: 'What is DNA short for?', answer: 'deoxyribonucleic acid', variants: ['deoxyribonucleic acid', 'dna'], topic: 'Genetics' },
    { id: 'G68B9', problem: 'What organelle produces ATP?', answer: 'mitochondria', variants: ['mitochondria', 'mitochondrion'], topic: 'Cell Biology' }`
  },
  
  // Grade6-8_Earth_Science
  {
    after: "{ id: 'G68E5', problem: 'What is the water cycle process where water vapor becomes liquid?', answer: 'condensation', variants: ['condensation'], topic: 'Water Cycle' }",
    add: `,
    { id: 'G68E6', problem: 'What is the hottest layer of Earth?', answer: 'inner core', variants: ['inner core', 'core'], topic: 'Earth Layers' },
    { id: 'G68E7', problem: 'What is the water cycle process where liquid becomes gas?', answer: 'evaporation', variants: ['evaporation'], topic: 'Water Cycle' },
    { id: 'G68E8', problem: 'What gas makes up 78% of Earth\\'s atmosphere?', answer: 'nitrogen', variants: ['nitrogen', 'N2'], topic: 'Atmosphere' },
    { id: 'G68E9', problem: 'What scale measures tornado intensity?', answer: 'Fujita', variants: ['Fujita', 'Fujita scale', 'F-scale'], topic: 'Weather' }`
  },
  
  // Grade6-8_Physics
  {
    after: "{ id: 'G68P5', problem: 'Sound travels faster in which medium: air or water?', answer: 'water', variants: ['water'], topic: 'Waves' }",
    add: `,
    { id: 'G68P6', problem: 'What is the unit of energy?', answer: 'Joule', variants: ['Joule', 'J', 'Joules'], topic: 'Energy' },
    { id: 'G68P7', problem: 'What type of energy is stored in food?', answer: 'chemical', variants: ['chemical', 'chemical energy'], topic: 'Energy' },
    { id: 'G68P8', problem: 'What is the formula for speed?', answer: 'speed = distance/time', variants: ['s=d/t', 'distance/time', 'speed = distance/time'], topic: 'Speed' },
    { id: 'G68P9', problem: 'Sound cannot travel through what?', answer: 'vacuum', variants: ['vacuum', 'a vacuum', 'space'], topic: 'Waves' }`
  }
];

// Apply each addition
additions.forEach((item, index) => {
  if (content.includes(item.after)) {
    content = content.replace(item.after, item.after + item.add);
    console.log(`✅ Added questions set ${index + 1}`);
  } else {
    console.log(`⚠️  Could not find anchor for set ${index + 1}`);
  }
});

// Write back
fs.writeFileSync(filePath, content, 'utf8');
console.log('\n📝 File updated! Added ' + (additions.length * 4 + 8) + ' questions so far.');

