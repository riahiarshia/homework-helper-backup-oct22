// Script to add 100 new questions to comprehensive-tests.js
const fs = require('fs');

const newQuestions = {
  'K-2_Mathematics': [
    "{ id: 'K2M6', problem: '2 + 2 = ?', answer: '4', variants: ['4', 'four'], topic: 'Basic Addition' }",
    "{ id: 'K2M7', problem: '8 - 3 = ?', answer: '5', variants: ['5', 'five'], topic: 'Basic Subtraction' }",
    "{ id: 'K2M8', problem: 'How many sides does a triangle have?', answer: '3', variants: ['3', 'three', '3 sides'], topic: 'Shapes' }",
    "{ id: 'K2M9', problem: 'Count: 2, 4, 6, __, 10. Fill in the blank.', answer: '8', variants: ['8', 'eight'], topic: 'Skip Counting' }"
  ],
  'K-2_Science': [
    "{ id: 'K2S6', problem: 'What helps birds fly? A) Wings B) Feet C) Eyes D) Nose', answer: 'A', variants: ['A', 'wings', 'A)', 'a'], topic: 'Life Science - Animals' }",
    "{ id: 'K2S7', problem: 'Is ice hot or cold?', answer: 'cold', variants: ['cold'], topic: 'Physical Science - Temperature' }",
    "{ id: 'K2S8', problem: 'What do we call a baby cat?', answer: 'kitten', variants: ['kitten', 'a kitten'], topic: 'Life Science - Animals' }",
    "{ id: 'K2S9', problem: 'Does the moon give us light at night? Yes or No?', answer: 'Yes', variants: ['yes', 'y'], topic: 'Earth Science - Moon' }"
  ],
  'Grade3-5_Mathematics': [
    "{ id: 'G35M6', problem: '9 × 7 = ?', answer: '63', variants: ['63', 'sixty-three'], topic: 'Multiplication' }",
    "{ id: 'G35M7', problem: '48 ÷ 8 = ?', answer: '6', variants: ['6', 'six'], topic: 'Division' }",
    "{ id: 'G35M8', problem: 'What is 1/2 + 1/4?', answer: '3/4', variants: ['3/4', '0.75'], topic: 'Fractions' }",
    "{ id: 'G35M9', problem: 'Round 83 to the nearest ten.', answer: '80', variants: ['80', 'eighty'], topic: 'Rounding' }"
  ],
  'Grade3-5_Science': [
    "{ id: 'G35S6', problem: 'What is H2O?', answer: 'water', variants: ['water'], topic: 'Physical Science - Matter' }",
    "{ id: 'G35S7', problem: 'What planet is closest to the Sun?', answer: 'Mercury', variants: ['mercury'], topic: 'Earth Science - Solar System' }",
    "{ id: 'G35S8', problem: 'What type of rock is formed by heat and pressure?', answer: 'metamorphic', variants: ['metamorphic', 'metamorphic rock'], topic: 'Earth Science - Rocks' }",
    "{ id: 'G35S9', problem: 'What gas do plants release during photosynthesis?', answer: 'oxygen', variants: ['oxygen', 'O2'], topic: 'Life Science - Plants' }"
  ],
  'Grade6-8_Mathematics': [
    "{ id: 'G68M6', problem: 'Solve: 2x - 3 = 7', answer: 'x = 5', variants: ['5', 'x=5', 'x = 5'], topic: 'Pre-Algebra - Equations' }",
    "{ id: 'G68M7', problem: 'What is 25% of 80?', answer: '20', variants: ['20'], topic: 'Percentages' }",
    "{ id: 'G68M8', problem: 'What is the value of 3²?', answer: '9', variants: ['9', 'nine'], topic: 'Exponents' }",
    "{ id: 'G68M9', problem: 'Simplify: 3(x + 2)', answer: '3x + 6', variants: ['3x+6', '3x + 6'], topic: 'Distributive Property' }"
  ],
  'Grade6-8_Biology': [
    "{ id: 'G68B6', problem: 'What is the basic unit of life?', answer: 'cell', variants: ['cell', 'the cell'], topic: 'Cell Biology' }",
    "{ id: 'G68B7', problem: 'What carries oxygen in blood?', answer: 'red blood cells', variants: ['red blood cells', 'RBC', 'hemoglobin'], topic: 'Human Body' }",
    "{ id: 'G68B8', problem: 'What is DNA short for?', answer: 'deoxyribonucleic acid', variants: ['deoxyribonucleic acid', 'dna'], topic: 'Genetics' }",
    "{ id: 'G68B9', problem: 'What organelle produces ATP?', answer: 'mitochondria', variants: ['mitochondria', 'mitochondrion'], topic: 'Cell Biology' }"
  ],
  'Grade6-8_Earth_Science': [
    "{ id: 'G68E6', problem: 'What is the hottest layer of Earth?', answer: 'inner core', variants: ['inner core', 'core'], topic: 'Earth Layers' }",
    "{ id: 'G68E7', problem: 'What is the water cycle process where liquid becomes gas?', answer: 'evaporation', variants: ['evaporation'], topic: 'Water Cycle' }",
    "{ id: 'G68E8', problem: 'What gas makes up 78% of Earth\\'s atmosphere?', answer: 'nitrogen', variants: ['nitrogen', 'N2'], topic: 'Atmosphere' }",
    "{ id: 'G68E9', problem: 'What scale measures tornado intensity?', answer: 'Fujita', variants: ['Fujita', 'Fujita scale', 'F-scale'], topic: 'Weather' }"
  ],
  'Grade6-8_Physics': [
    "{ id: 'G68P6', problem: 'What is the unit of energy?', answer: 'Joule', variants: ['Joule', 'J', 'Joules'], topic: 'Energy' }",
    "{ id: 'G68P7', problem: 'What type of energy is stored in food?', answer: 'chemical', variants: ['chemical', 'chemical energy'], topic: 'Energy' }",
    "{ id: 'G68P8', problem: 'What is the formula for speed?', answer: 'speed = distance/time', variants: ['s=d/t', 'distance/time', 'speed = distance/time'], topic: 'Speed' }",
    "{ id: 'G68P9', problem: 'Sound cannot travel through what?', answer: 'vacuum', variants: ['vacuum', 'a vacuum', 'space'], topic: 'Waves' }"
  ]
};

console.log('New questions structure created.');
console.log('Total new questions:', Object.values(newQuestions).flat().length);
