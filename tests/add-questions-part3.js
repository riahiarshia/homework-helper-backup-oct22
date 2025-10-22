const fs = require('fs');
const path = require('path');

const filePath = path.join(__dirname, 'comprehensive-tests.js');
let content = fs.readFileSync(filePath, 'utf8');

// Final 32 questions for Advanced and other categories
const additions = [
  // Advanced_Mathematics (4 more)
  {
    category: 'Advanced_Mathematics',
    after: "{ id: 'ADV_M10', problem: 'Solve: 2x + 7 = 15', answer: 'x = 4', variants: ['4', 'x=4', 'x = 4'], topic: 'Equations' }",
    add: `,
    { id: 'ADV_M11', problem: '15 + 8 = ?', answer: '23', variants: ['23', 'twenty-three'], topic: 'Addition' },
    { id: 'ADV_M12', problem: '72 ÷ 9 = ?', answer: '8', variants: ['8', 'eight'], topic: 'Division' },
    { id: 'ADV_M13', problem: 'Simplify: 5(2x - 1)', answer: '10x - 5', variants: ['10x-5', '10x - 5'], topic: 'Distribution' },
    { id: 'ADV_M14', problem: 'What is 20% of 150?', answer: '30', variants: ['30'], topic: 'Percentages' }`
  },
  
  // Advanced_Biology (4 more)
  {
    category: 'Advanced_Biology',
    after: "{ id: 'ADV_B10', problem: 'What is the study of heredity called?', answer: 'genetics', variants: ['genetics'], topic: 'Genetics' }",
    add: `,
    { id: 'ADV_B11', problem: 'What process do plants use to make glucose?', answer: 'photosynthesis', variants: ['photosynthesis'], topic: 'Photosynthesis' },
    { id: 'ADV_B12', problem: 'What is the control center of the cell?', answer: 'nucleus', variants: ['nucleus', 'the nucleus'], topic: 'Cell Biology' },
    { id: 'ADV_B13', problem: 'What are the products of cellular respiration?', answer: 'CO2 and water', variants: ['CO2 and water', 'carbon dioxide and water', 'co2 water'], topic: 'Cellular Respiration' },
    { id: 'ADV_B14', problem: 'What type of cell has a nucleus?', answer: 'eukaryotic', variants: ['eukaryotic', 'eukaryote'], topic: 'Cell Theory' }`
  },
  
  // Advanced_Chemistry (4 more)
  {
    category: 'Advanced_Chemistry',
    after: "{ id: 'ADV_C10', problem: 'What is Avogadro\\'s number (approximately)?', answer: '6.022 × 10²³', variants: ['6.022e23', '6.022 × 10²³', '6.02 × 10²³'], topic: 'Molar Calculations' }",
    add: `,
    { id: 'ADV_C11', problem: 'What is the formula for carbon dioxide?', answer: 'CO2', variants: ['CO2', 'co2'], topic: 'Chemical Formulas' },
    { id: 'ADV_C12', problem: 'What is the pH of a neutral solution?', answer: '7', variants: ['7', 'seven'], topic: 'pH' },
    { id: 'ADV_C13', problem: 'What is the symbol for calcium?', answer: 'Ca', variants: ['Ca'], topic: 'Elements' },
    { id: 'ADV_C14', problem: 'How many electrons can the second shell hold?', answer: '8', variants: ['8', 'eight'], topic: 'Electron Configuration' }`
  },
  
  // Advanced_Physics (4 more)
  {
    category: 'Advanced_Physics',
    after: "{ id: 'ADV_P10', problem: 'What is the acceleration due to gravity on Earth (approximately)?', answer: '9.8', variants: ['9.8', '9.8 m/s²', '10 m/s²'], topic: 'Gravity' }",
    add: `,
    { id: 'ADV_P11', problem: 'What is the formula for work?', answer: 'W = Fd', variants: ['W=Fd', 'Fd', 'force times distance'], topic: 'Work' },
    { id: 'ADV_P12', problem: 'What is the unit of power?', answer: 'Watt', variants: ['Watt', 'W', 'Watts'], topic: 'Power' },
    { id: 'ADV_P13', problem: 'What type of energy is in a stretched spring?', answer: 'potential', variants: ['potential', 'elastic potential', 'potential energy'], topic: 'Energy' },
    { id: 'ADV_P14', problem: 'What is the formula for kinetic energy?', answer: 'KE = ½mv²', variants: ['1/2 mv²', '½mv²', 'KE = 1/2 mv^2'], topic: 'Energy' }`
  },
  
  // Advanced_Earth_Science (4 more)
  {
    category: 'Advanced_Earth_Science',
    after: "{ id: 'ADV_E10', problem: 'What is the study of weather called?', answer: 'meteorology', variants: ['meteorology'], topic: 'Meteorology' }",
    add: `,
    { id: 'ADV_E11', problem: 'What causes day and night on Earth?', answer: 'rotation', variants: ['rotation', 'Earth\\'s rotation'], topic: 'Earth Rotation' },
    { id: 'ADV_E12', problem: 'What type of plate boundary causes earthquakes?', answer: 'transform', variants: ['transform', 'transform boundary'], topic: 'Plate Tectonics' },
    { id: 'ADV_E13', problem: 'What layer of atmosphere contains ozone?', answer: 'stratosphere', variants: ['stratosphere'], topic: 'Atmosphere' },
    { id: 'ADV_E14', problem: 'What is molten rock called when underground?', answer: 'magma', variants: ['magma'], topic: 'Volcanoes' }`
  },
  
  // English_Grammar (4 more)
  {
    category: 'English_Grammar',
    after: "{ id: 'ENG_G10', problem: 'What is the comparative form of \"good\"?', answer: 'better', variants: ['better'], topic: 'Comparatives' }",
    add: `,
    { id: 'ENG_G11', problem: 'What is the plural of \"mouse\"?', answer: 'mice', variants: ['mice'], topic: 'Plurals' },
    { id: 'ENG_G12', problem: 'What type of word modifies an adjective?', answer: 'adverb', variants: ['adverb'], topic: 'Adverbs' },
    { id: 'ENG_G13', problem: 'What is the past tense of \"go\"?', answer: 'went', variants: ['went'], topic: 'Verb Tenses' },
    { id: 'ENG_G14', problem: 'What connects two words or phrases?', answer: 'conjunction', variants: ['conjunction'], topic: 'Conjunctions' }`
  },
  
  // US_History (4 more)
  {
    category: 'US_History',
    after: "{ id: 'HIST_US10', problem: 'Who gave the \"I Have a Dream\" speech?', answer: 'Martin Luther King Jr.', variants: ['MLK', 'Martin Luther King', 'King'], topic: 'Civil Rights' }",
    add: `,
    { id: 'HIST_US11', problem: 'What was the first capital of the United States?', answer: 'New York', variants: ['New York', 'New York City', 'NYC'], topic: 'US History' },
    { id: 'HIST_US12', problem: 'How many amendments are in the Bill of Rights?', answer: '10', variants: ['10', 'ten'], topic: 'Government' },
    { id: 'HIST_US13', problem: 'What ocean is on the west coast of the United States?', answer: 'Pacific', variants: ['Pacific', 'Pacific Ocean'], topic: 'Geography' },
    { id: 'HIST_US14', problem: 'Who was the 16th President?', answer: 'Abraham Lincoln', variants: ['Lincoln', 'Abraham Lincoln', 'Abe Lincoln'], topic: 'Presidents' }`
  },
  
  // World_History (4 more)
  {
    category: 'World_History',
    after: "{ id: 'HIST_W10', problem: 'What Italian city is famous for its canals?', answer: 'Venice', variants: ['Venice'], topic: 'European Geography' }",
    add: `,
    { id: 'HIST_W11', problem: 'What year did World War II end?', answer: '1945', variants: ['1945'], topic: 'World War II' },
    { id: 'HIST_W12', problem: 'Who was the first person to walk on the moon?', answer: 'Neil Armstrong', variants: ['Neil Armstrong', 'Armstrong'], topic: '20th Century' },
    { id: 'HIST_W13', problem: 'What wall fell in 1989?', answer: 'Berlin Wall', variants: ['Berlin Wall', 'the Berlin Wall'], topic: 'Cold War' },
    { id: 'HIST_W14', problem: 'What is the largest continent?', answer: 'Asia', variants: ['Asia'], topic: 'Geography' }`
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
console.log(`\n📝 Part 3 complete! Added ${count} more questions.`);
console.log(`\n🎉 TOTAL: 100 NEW QUESTIONS ADDED!`);
console.log(`   - Part 1: 32 questions`);
console.log(`   - Part 2: 36 questions`);
console.log(`   - Part 3: ${count} questions`);
console.log(`   - Grand Total: ${32 + 36 + count} questions\n`);
