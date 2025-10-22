const axios = require('axios');
const config = require('../config');
const usageTrackingService = require('./usageTrackingService');
const loggingService = require('./loggingService');
// const WolframService = require('../../Services/wolframService'); // Temporarily disabled

class OpenAIService {
  constructor() {
    this.baseURL = config.openai.baseURL;
    // this.wolframService = new WolframService(); // Temporarily disabled
  }

  // Helper method to get the appropriate model for each task type
  getModel(taskType = 'default') {
    const models = config.openai.models || {};
    return models[taskType] || models.default || config.openai.model;
  }

  // Helper method to check if problem should use Wolfram|Alpha
  shouldUseWolframForMath(problemText) {
    if (!problemText) return false;
    
    // Use Wolfram|Alpha for mathematical problems
    const mathPatterns = [
      /\d+\s*[+\-*/=]\s*\d+/, // Basic arithmetic
      /[a-zA-Z]\s*[+\-*/=]/, // Algebra
      /area|perimeter|volume|angle/i, // Geometry
      /solve|calculate|find/i, // Problem solving
      /equation|formula/i, // Equations
      /graph|plot/i, // Graphing
      /derivative|integral|limit/i, // Calculus
      /probability|statistics/i, // Statistics
      /trigonometry|sin|cos|tan/i, // Trigonometry
      /fraction|decimal|percent/i, // Number concepts
      /square root|sqrt|cube root/i, // Roots
      /exponent|power|\^|\*\*/i // Exponents
    ];
    
    return mathPatterns.some(pattern => pattern.test(problemText));
  }

  async validateImageQuality({ imageData, apiKey, userId, deviceId, metadata = {} }) {
    const systemPrompt = `You are an image quality assessor for homework analysis. Evaluate the image quality for homework analysis purposes.

    CRITICAL QUALITY CHECKS:
    1. **Text Readability**: Can all text, numbers, and symbols be clearly read?
    2. **Image Sharpness**: Is the image in focus and not blurry?
    3. **Lighting**: Is the image well-lit without shadows or glare?
    4. **Completeness**: Is the entire homework visible without being cut off?
    5. **Resolution**: Is the image high enough resolution to read small text?
    6. **Orientation**: Is the image properly oriented (not upside down or sideways)?

    RESPOND WITH EXACTLY THIS JSON FORMAT:
    {
      "isGoodQuality": true/false,
      "confidence": 0.0-1.0,
      "issues": ["specific issue 1", "specific issue 2"],
      "recommendations": ["specific recommendation 1", "specific recommendation 2"]
    }

    QUALITY STANDARDS:
    - **Good Quality**: Text is clear, image is sharp, well-lit, complete, and properly oriented
    - **Poor Quality**: Blurry text, poor lighting, cut-off content, or any readability issues

    Be strict but fair in your assessment.`;

    const base64Image = imageData.toString('base64');
    const dataURL = `data:image/jpeg;base64,${base64Image}`;

    const messages = [
      { role: "system", content: systemPrompt },
      { role: "user", content: [
        { type: "text", text: "Please evaluate the quality of this homework image for analysis purposes. Check for text readability, image sharpness, lighting, completeness, and orientation." },
        { type: "image_url", image_url: { url: dataURL } }
      ]}
    ];

    const requestBody = {
      model: this.getModel('imageAnalysis'),
      messages: messages,
      max_tokens: 500,
      temperature: 0.1, // Low temperature for consistent quality assessment
      response_format: { type: "json_object" }
    };

    try {
      const response = await axios.post(`${this.baseURL}/chat/completions`, requestBody, {
        headers: {
          'Authorization': `Bearer ${apiKey}`,
          'Content-Type': 'application/json'
        },
        timeout: 30000 // 30 second timeout for validation
      });

      if (response.data && response.data.choices && response.data.choices[0]) {
        const content = response.data.choices[0].message.content;
        const result = JSON.parse(content);
        
        // Track usage if userId provided
        if (userId && response.data.usage) {
          await usageTrackingService.trackUsage({
            userId,
            deviceId,
            endpoint: 'validate_image',
            model: this.getModel('imageAnalysis'),
            usage: response.data.usage,
            metadata
          });
        }
        
        return result;
      } else {
        throw new Error('Invalid response from OpenAI API');
      }
    } catch (error) {
      if (error.response) {
        if (error.response.status === 401) {
          const authError = new Error('Invalid OpenAI API key');
          authError.status = 401;
          throw authError;
        } else if (error.response.status === 429) {
          const rateLimitError = new Error('OpenAI API rate limit exceeded');
          rateLimitError.status = 429;
          throw rateLimitError;
        }
      }
      throw error;
    }
  }

  async analyzeHomework({ imageData, problemText, teacherMethodImageData, userGradeLevel, apiKey, userId, deviceId, metadata = {} }) {
    const startTime = Date.now();
    
    // Log the start of homework analysis
    loggingService.logMathProblem({
      userId,
      deviceId,
      problemText,
      imageData: imageData ? 'Image data provided' : null,
      teacherMethodImage: teacherMethodImageData ? 'Teacher method image provided' : null,
      userGradeLevel,
      analysisResult: 'Starting analysis...'
    });

    const systemPrompt = `You are "Homework Mentor" — a precise and patient AI tutor that guides students through their homework problems ONE STEP AT A TIME.
    
    STEP-BY-STEP TUTORING PHILOSOPHY:
    - NEVER provide the final answer immediately
    - Guide students through ONE step at a time
    - Build understanding progressively
    - Verify each step before moving to the next
    - Let students discover the answer through guided steps
    
    ABSOLUTE RULES - NEVER VIOLATE:
    1. ONLY use numbers that appear in the image - NEVER invent numbers
    2. If you see blank space in a sentence/equation, the student must FILL that space
    3. Read ALL digits with extreme precision - state each number you see
    4. Options must be realistic possibilities based on the actual problem, not random numbers
    5. NEVER make assumptions - only work with what's visible
    6. NEVER reveal the final answer - only guide to the next step
    
    VISUAL BLANK SPACE DETECTION:
    - A blank space in a sentence means "fill this in" even without explicit instructions
    - Look for: gaps in sentences, empty boxes, underlines ____, [  ], ( ), □, or missing parts
    - Pattern examples:
      * "5 + ___ = 10" ← blank to fill
      * "The answer is ___" ← blank to fill  
      * "Calculate: 7 × [  ]" ← blank to fill
      * "Area = ____" ← blank to fill
      * If you see "word word ___ word" ← that's a blank!
    - Even if it doesn't say "fill in the blank", a visual gap IS a fill-in-the-blank question
    - State: "I see a blank space that needs to be filled"
    
    NUMBER READING PROTOCOL:
    - Read each number OUT LOUD in your analysis: "I see the number 5", "I see the number 12"
    - Double-check similar digits: 1≠7, 3≠8, 5≠6, 0≠O, 2≠Z
    - Look for: decimal points (3.5), negative signs (-5), fractions (1/2)
    - If unclear: "The number appears to be X (verify if image unclear)"
    - FORBIDDEN: Making up numbers not in the image
    
    ANSWER OPTIONS MUST:
    - Be relevant to the actual problem shown
    - Include the correct answer based on visible numbers
    - Include plausible wrong answers (common mistakes)
    - NEVER include random unrelated numbers
    - Example: If problem is "5 + 3", options could be ["7", "8", "9", "6"] NOT ["42", "100", "1000"]
    
    TEACHER'S METHOD (CRITICAL):
    ${teacherMethodImageData ? `
    - A SECOND IMAGE has been provided showing the TEACHER'S PREFERRED METHOD
    - You MUST follow the exact method, steps, and approach shown in the teacher's example
    - Study the teacher's method image carefully and replicate that exact solving approach
    - Use the same terminology, notation, and step sequence as shown in the teacher's example
    - If the teacher shows a specific formula layout or calculation method, use that EXACT format
    - Your steps should mirror the teacher's method as closely as possible
    - When creating steps, reference "As your teacher showed..." or "Following your teacher's method..."
    - This is MANDATORY - the student must learn their teacher's specific approach
    ` : '- No specific teacher method provided - you may use any appropriate solving method'}
    
    CORE PRINCIPLES:
    - Focus ONLY on the exact problem shown
    - State every number you see clearly
    - Identify visual gaps/blanks as fill-in questions
    - Guide to fill the exact blank shown
    - Never include extra prose outside JSON

    AGE-APPROPRIATE LANGUAGE for ${userGradeLevel}:
    
    Elementary (K-5):
    - Use simple words and concrete examples
    - Instead of formulas, show step-by-step addition/subtraction
    - Example: "length + length + width + width" NOT "2 × (length + width)"
    - Use visual language: "all four sides", "count each one", "add together"
    - Explanations should be like talking to a 10-year-old
    
    Middle School (6-8):
    - Can introduce basic formulas with explanations
    - Show both formula AND what it means in simple terms
    - Use more formal math language but keep it clear
    
    High School (9-12):
    - Use standard mathematical notation and formulas
    - Can use algebraic expressions and abstract concepts
    - Professional mathematical language is appropriate`;

    const userPrompt = `STEP-BY-STEP TUTORING APPROACH:
    ${teacherMethodImageData ? `
    
    ⚠️ CRITICAL: A TEACHER'S METHOD IMAGE HAS BEEN PROVIDED!
    - You will see TWO images: the student's problem AND an example of the teacher's preferred method
    - First, study the teacher's method example to understand the EXACT approach required
    - Then guide the student through the SAME METHOD step by step
    - Use the same terminology and format shown in the teacher's example
    - Your guidance MUST follow the teacher's method - this is non-negotiable
    ` : ''}

    YOUR TASK: Provide ONLY the FIRST STEP of guidance, not the complete solution.

    STEP 1 - ANALYZE THE PROBLEM:
    First, analyze the problem image and state:
    - "I see [number] problems on this sheet"
    - "Problem 1 shows: [exact text/equation including any gaps or blanks]"
    - "Numbers I can see: [list each number]"
    - "I notice [describe any blank spaces, gaps, boxes, or underlines]"
    ${teacherMethodImageData ? `
    
    Then, analyze the teacher's method image:
    - "The teacher's example shows: [describe the method, steps, and approach]"
    - "Key steps in the teacher's method: [list the specific steps]"
    - "I will guide you through this exact method step by step"
    ` : ''}
    
    STEP 2 - IDENTIFY THE FIRST STEP:
    Look for what the student needs to do FIRST:
    - What information do they need to identify?
    - What is the first calculation or step?
    - What formula or method should they use first?
    - What should they write down or identify?
    
    STEP 3 - CREATE GUIDANCE FOR FIRST STEP ONLY:
    - Provide a clear question about the first step
    - Give multiple choice options that are DISTINCT and CLEAR
    - Options should be specific actions, not vague concepts
    - Include one correct approach and realistic wrong answers
    - Do NOT solve the problem - just guide to the first step
    - Do NOT reveal the final answer

    MULTIPLE CHOICE OPTIONS REQUIREMENTS:
    - Make options SPECIFIC and ACTIONABLE
    - Each option should be a clear, distinct step
    - Wrong options should be common mistakes students make
    - Avoid vague options like "Use a formula" - be specific
    - Example for perimeter: ["Add length + width + length + width", "Multiply length × width", "Add length + width", "Use the area formula"]

    FORMAT RULES:
    Respond in JSON with this exact structure for STEP-BY-STEP TUTORING:
    {
      "subject": "Math / Science / English / etc.",
      "difficulty": "easy / medium / hard",
      "currentStep": {
        "question": "What should you do FIRST to solve this problem?",
        "explanation": "Guidance for the first step only - what to identify or calculate first",
        "options": ["Specific action A", "Specific action B", "Specific action C", "Specific action D"],
        "correctAnswer": "The correct first step approach",
        "hint": "Additional hint if the student needs help with this step"
      },
      "totalSteps": 5,
      "problemDescription": "Brief description of what the student needs to solve",
      "nextStepPreview": "After completing this step, you'll need to [brief description of next step]",
      "progress": "Step 1 of 5 - Getting started",
      "finalAnswer": "Please complete all steps to find the final answer."
    }

    CRITICAL: Every step MUST have ALL four fields: question, explanation, options, correctAnswer.
    NEVER return a step with missing fields. If you're unsure about any field, provide a reasonable default.

    MATH ACCURACY REQUIREMENTS:
    - ALWAYS double-check your arithmetic calculations
    - For perimeter problems: P = 2 × (length + width)
    - For area problems: A = length × width
    - Show your work step by step
    - Verify your final answer makes sense
    - If calculating 2 × (320 + 163), the result is 2 × 483 = 966, NOT 646

    GUIDING STYLE:
    - Use 3–5 short, targeted steps per problem
    - Label each step with which problem it's solving (e.g., "Problem 1:", "Problem 2:")
    - Each question should build toward that problem's answer
    - Include multiple choice options that make sense, but only one is fully correct
    - Do NOT reveal the correct answer inside the question or explanation text — only in "correctAnswer"
    - For word problems: identify key facts, convert them into equations, solve step by step

    SUBJECT BEHAVIOR:
    - Math: show equations, calculate step by step, include units
    - Science: identify data, explain reasoning, conclude clearly
    - English/Reading: identify context clues, grammar rules, or main idea
    - History/Social Studies: identify factual events, names, or causes/effects clearly

    MANDATORY: Create steps for EVERY problem visible on the homework sheet. Count them and verify completeness before responding.`;

    const messages = [
      { role: "system", content: systemPrompt }
    ];

    if (imageData) {
      const base64Image = imageData.toString('base64');
      const dataURL = `data:image/jpeg;base64,${base64Image}`;
      
      const contentArray = [
        { type: "text", text: userPrompt }
      ];
      
      if (problemText) {
        contentArray.push({ type: "text", text: `Additional context: ${problemText}` });
      }
      
      // Add the main problem image
      contentArray.push({
        type: "image_url",
        image_url: { 
          url: dataURL,
          detail: "high"
        }
      });
      
      // Add teacher method image if provided
      if (teacherMethodImageData) {
        const base64TeacherMethod = teacherMethodImageData.toString('base64');
        const teacherMethodDataURL = `data:image/jpeg;base64,${base64TeacherMethod}`;
        
        contentArray.push({
          type: "text",
          text: "Here is the teacher's example showing the preferred method to solve this type of problem:"
        });
        
        contentArray.push({
          type: "image_url",
          image_url: { 
            url: teacherMethodDataURL,
            detail: "high"
          }
        });
      }
      
      messages.push({
        role: "user",
        content: contentArray
      });
    } else if (problemText) {
      messages.push({
        role: "user",
        content: `${userPrompt}\n\nProblem: ${problemText}`
      });
    }

    const requestBody = {
      model: this.getModel('homework'),
      messages: messages,
      max_tokens: config.openai.maxTokens,
      temperature: config.openai.temperature,
      response_format: { type: "json_object" }
    };

    // Log the system prompt
    console.log('🔍 Logging system prompt...');
    loggingService.logOpenAIText(systemPrompt, 'system_prompt');
    
    // Log the user prompt (messages)
    console.log('🔍 Logging user messages...');
    loggingService.logOpenAIText(JSON.stringify(messages, null, 2), 'user_messages');
    
    // Log the full request
    loggingService.logOpenAIInteraction({
      userId,
      deviceId,
      endpoint: 'analyze-homework',
      requestData: requestBody,
      model: this.getModel('homework'),
      tokens: 0, // Will be updated after response
      duration: 0, // Will be updated after response
      error: null
    });

    try {
      const response = await axios.post(`${this.baseURL}/chat/completions`, requestBody, {
        headers: {
          'Authorization': `Bearer ${apiKey}`,
          'Content-Type': 'application/json'
        },
        timeout: 60000 // 60 second timeout
      });

      if (response.data && response.data.choices && response.data.choices[0]) {
        const content = response.data.choices[0].message.content;
        
        // Log the raw response from OpenAI
        console.log('🔍 Logging raw response...');
        loggingService.logOpenAIResponse(content, 'raw_response');
        
        const result = JSON.parse(content);
        
        // Log the parsed result
        console.log('🔍 Logging parsed result...');
        loggingService.logOpenAIResponse(JSON.stringify(result, null, 2), 'parsed_result');
        
    // Validate and fix the response structure
    if (result.steps && Array.isArray(result.steps)) {
      result.steps = result.steps.map((step, index) => {
        // Ensure all required fields are present
        if (!step.question) {
          step.question = `Step ${index + 1}: ${step.explanation ? step.explanation.substring(0, 50) + '...' : 'Complete this step'}`;
        }
        if (!step.options || !Array.isArray(step.options) || step.options.length === 0) {
          step.options = ['Option A', 'Option B', 'Option C', 'Option D'];
        }
        if (!step.correctAnswer) {
          step.correctAnswer = step.options[0] || 'Option A';
        }
        if (!step.explanation) {
          step.explanation = 'Follow the steps to solve this problem.';
        }
        
        // MATH VALIDATION: Check for common arithmetic errors
        if (step.correctAnswer && step.options && step.options.length > 0) {
          const answer = step.correctAnswer;
          const options = step.options;
          
          // Check if this is a perimeter calculation
          if (step.question && step.question.toLowerCase().includes('perimeter') && 
              step.question.toLowerCase().includes('rectangle') && 
              step.question.toLowerCase().includes('lap')) {
            
            // Extract dimensions from the problem context
            const widthMatch = step.explanation?.match(/(\d+)\s*m.*width/i) || 
                             step.explanation?.match(/width.*?(\d+)\s*m/i);
            const lengthMatch = step.explanation?.match(/(\d+)\s*m.*length/i) || 
                               step.explanation?.match(/length.*?(\d+)\s*m/i);
            
            if (widthMatch && lengthMatch) {
              const width = parseInt(widthMatch[1]);
              const length = parseInt(lengthMatch[1]);
              const correctPerimeter = 2 * (width + length);
              
              // Check if the AI's answer is wrong
              const aiAnswer = parseInt(answer.replace(/[^\d]/g, ''));
              if (aiAnswer !== correctPerimeter) {
                console.log(`🔧 MATH FIX: AI said ${aiAnswer}m, but correct answer is ${correctPerimeter}m} (width: ${width}m, length: ${length}m)`);
                
                // Fix the answer
                step.correctAnswer = `${correctPerimeter} m`;
                
                // Update options if needed
                const correctOption = `${correctPerimeter} m`;
                if (!options.includes(correctOption)) {
                  // Replace the first option with the correct answer
                  options[0] = correctOption;
                }
                
                // Update explanation
                step.explanation = `We need to calculate the perimeter of the rectangular playground to find the distance of one lap. The perimeter formula is P = 2 × (length + width). With width = ${width}m and length = ${length}m: P = 2 × (${width} + ${length}) = 2 × ${width + length} = ${correctPerimeter}m.`;
              }
            }
          }
        }
        
        return step;
      });
    }
        
        // Ensure required top-level fields exist
        if (!result.subject) {
          result.subject = 'Mathematics';
        }
        if (!result.difficulty) {
          result.difficulty = 'medium';
        }
        if (!result.finalAnswer) {
          result.finalAnswer = 'Please complete all steps to find the final answer.';
        }
        
        // Log the final result
        loggingService.logOpenAIResponse(JSON.stringify(result, null, 2), 'final_result');
        
        // Log successful completion
        const duration = Date.now() - startTime;
        loggingService.logOpenAIInteraction({
          userId,
          deviceId,
          endpoint: 'analyze-homework',
          requestData: requestBody,
          responseData: result,
          model: this.getModel('homework'),
          tokens: response.data.usage ? response.data.usage.total_tokens : 0,
          duration: duration,
          error: null
        });
        
        // Track usage if userId provided
        if (userId && response.data.usage) {
          await usageTrackingService.trackUsage({
            userId,
            deviceId,
            endpoint: 'analyze_homework',
            model: this.getModel('imageAnalysis'),
            usage: response.data.usage,
            metadata
          });
        }
        
        return result;
      } else {
        throw new Error('Invalid response from OpenAI API');
      }
    } catch (error) {
      // Log the error
      loggingService.logError(error, {
        userId,
        deviceId,
        endpoint: 'analyze-homework',
        requestData: requestBody,
        duration: Date.now() - startTime
      });
      
      if (error.response) {
        if (error.response.status === 401) {
          const authError = new Error('Invalid OpenAI API key');
          authError.status = 401;
          throw authError;
        } else if (error.response.status === 429) {
          const rateLimitError = new Error('OpenAI API rate limit exceeded');
          rateLimitError.status = 429;
          throw rateLimitError;
        }
      }
      throw error;
    }
  }

  async generateHint({ step, problemContext, userGradeLevel, apiKey, userId, deviceId, metadata = {} }) {
    const systemPrompt = `You are "Homework Mentor" — a precise and patient AI tutor that helps students solve their exact homework questions step by step.
    Provide a subtle hint without giving away the answer. Use age-appropriate language and examples for ${userGradeLevel}.
    
    CRITICAL AGE-APPROPRIATE GUIDANCE:
    
    For Elementary Students (K-5):
    - Use concrete, visual examples instead of abstract formulas
    - Break complex concepts into simple repeated additions
    - Example: Instead of "2 × (length + width)", say "Add all four sides: length + length + width + width"
    - Use drawings in words: "Imagine the rectangle has 2 long sides and 2 short sides"
    - Show actual numbers without revealing the final answer: "If the sides are 5 and 3, add: 5 + 5 + 3 + 3"
    - Use everyday language: "count", "add together", "put side by side"
    
    For Middle School (6-8):
    - Can introduce simple formulas with explanations
    - Show both the formula AND the concrete breakdown
    - Example: "Perimeter = 2 × length + 2 × width, which means adding the two long sides and two short sides"
    - Use visual representations when helpful
    
    For High School (9-12):
    - Can use standard mathematical notation and formulas
    - Provide algebraic or formula-based hints
    - Example: "Use the formula P = 2(l + w) or 2l + 2w"
    
    IMPORTANT:
    - NEVER provide the final numerical answer
    - Show the pattern or method, not the solution
    - Guide thinking with questions: "What are we adding together?"
    - Use specific numbers from the problem to illustrate WITHOUT solving completely
    
    Focus on guiding the student's thinking, not solving for them.`;

    const userPrompt = `CRITICAL: Stay STRICTLY on topic. The hint MUST be directly related to THIS SPECIFIC problem.

PROBLEM CONTEXT: ${problemContext}

CURRENT STEP QUESTION: ${step.question}

STEP EXPLANATION: ${step.explanation}

AVAILABLE OPTIONS: ${step.options ? step.options.join(', ') : 'N/A'}

CORRECT ANSWER (for context only - DO NOT reveal): ${step.correctAnswer}

STUDENT GRADE LEVEL: ${userGradeLevel}

REQUIREMENTS FOR YOUR HINT:
1. ✅ MUST be directly related to "${problemContext}" - the actual problem the student is solving
2. ✅ MUST help answer "${step.question}" specifically
3. ✅ MUST use concepts from "${step.explanation}"
4. ❌ DO NOT talk about unrelated subjects (no math examples for social studies!)
5. ❌ DO NOT use generic examples (boxes, apples, etc.) unless they're in the original problem
6. ❌ DO NOT give away the final answer
7. ✅ Guide the student's thinking with questions or partial steps
8. ✅ Use age-appropriate language for ${userGradeLevel}

EXAMPLE OF GOOD HINT:
If problem is about "What year did Columbus discover America?":
✅ GOOD: "Think about the famous rhyme: 'In fourteen hundred ninety-two...' What year does that refer to?"
❌ BAD: "Think about adding and subtracting boxes" (WRONG SUBJECT!)

EXAMPLE OF BAD HINT:
If problem is about social studies:
❌ BAD: "Imagine you have 5 boxes and add 3 more boxes" (This is math, not social studies!)

Provide a helpful, age-appropriate hint that is DIRECTLY RELATED to the problem context and question above.`;

    const messages = [
      { role: "system", content: systemPrompt },
      { role: "user", content: userPrompt }
    ];

    const requestBody = {
      model: this.getModel('homework'),
      messages: messages,
      max_tokens: 400,
      temperature: config.openai.temperature
    };

    try {
      const response = await axios.post(`${this.baseURL}/chat/completions`, requestBody, {
        headers: {
          'Authorization': `Bearer ${apiKey}`,
          'Content-Type': 'application/json'
        },
        timeout: 30000 // 30 second timeout
      });

      if (response.data && response.data.choices && response.data.choices[0]) {
        const content = response.data.choices[0].message.content;
        
        // Track usage if userId provided
        if (userId && response.data.usage) {
          await usageTrackingService.trackUsage({
            userId,
            deviceId,
            endpoint: 'generate_hint',
            model: this.getModel('imageAnalysis'),
            usage: response.data.usage,
            metadata
          });
        }
        
        return content;
      } else {
        throw new Error('Invalid response from OpenAI API');
      }
    } catch (error) {
      if (error.response) {
        if (error.response.status === 401) {
          const authError = new Error('Invalid OpenAI API key');
          authError.status = 401;
          throw authError;
        } else if (error.response.status === 429) {
          const rateLimitError = new Error('OpenAI API rate limit exceeded');
          rateLimitError.status = 429;
          throw rateLimitError;
        }
      }
      throw error;
    }
  }

  async verifyAnswer({ answer, step, problemContext, userGradeLevel, apiKey, userId, deviceId, metadata = {} }) {
    const systemPrompt = `You are "Homework Mentor" — a precise and patient AI tutor that helps students solve their exact homework questions step by step.
    You are verifying a student's homework answer. Accuracy is ESSENTIAL to prevent misleading the student.`;

    const userPrompt = `CRITICAL: You are verifying a student's homework answer. Accuracy is ESSENTIAL to prevent misleading the student.

    Question: ${step.question}
    Expected Correct Answer: ${step.correctAnswer}
    Student's Selected Answer: ${answer}
    All Available Options: ${step.options ? step.options.join(', ') : 'N/A'}
    
    VERIFICATION REQUIREMENTS:
    1. Check if the student's answer is mathematically/factually correct
    2. Consider equivalent expressions (e.g., "2+3" = "5", "half" = "0.5", "subtract 4" = "minus 4")
    3. Be strict about factual accuracy - if it's wrong, it's wrong
    4. Consider the student's grade level: ${userGradeLevel}
    
    EXAMPLES OF ACCEPTABLE VARIATIONS:
    - Mathematical: "5" = "five" = "2+3" = "10/2"
    - Operations: "add 3" = "plus 3" = "3 more"
    - Fractions: "1/2" = "half" = "0.5"
    
    RESPOND WITH EXACTLY ONE WORD:
    - "CORRECT" if the answer is right (including equivalent forms)
    - "INCORRECT" if the answer is wrong or misleading
    
    The student's education depends on your accuracy. Be thorough but fair.`;

    const messages = [
      { role: "system", content: systemPrompt },
      { role: "user", content: userPrompt }
    ];

    const requestBody = {
      model: this.getModel('homework'),
      messages: messages,
      max_tokens: 100,
      temperature: 0.0 // Deterministic for verification
    };

    try {
      const response = await axios.post(`${this.baseURL}/chat/completions`, requestBody, {
        headers: {
          'Authorization': `Bearer ${apiKey}`,
          'Content-Type': 'application/json'
        },
        timeout: 30000 // 30 second timeout
      });

      if (response.data && response.data.choices && response.data.choices[0]) {
        const content = response.data.choices[0].message.content;
        const trimmedResponse = content.trim().toUpperCase();
        const isCorrect = trimmedResponse.includes("CORRECT") && !trimmedResponse.includes("INCORRECT");
        
        // Track usage if userId provided
        if (userId && response.data.usage) {
          await usageTrackingService.trackUsage({
            userId,
            deviceId,
            endpoint: 'verify_answer',
            model: this.getModel('imageAnalysis'),
            usage: response.data.usage,
            metadata
          });
        }
        
        return {
          isCorrect: isCorrect,
          verification: trimmedResponse
        };
      } else {
        throw new Error('Invalid response from OpenAI API');
      }
    } catch (error) {
      if (error.response) {
        if (error.response.status === 401) {
          const authError = new Error('Invalid OpenAI API key');
          authError.status = 401;
          throw authError;
        } else if (error.response.status === 429) {
          const rateLimitError = new Error('OpenAI API rate limit exceeded');
          rateLimitError.status = 429;
          throw rateLimitError;
        }
      }
      throw error;
    }
  }

  async getNextStep({ currentStep, studentAnswer, problemContext, userGradeLevel, apiKey, userId, deviceId, metadata = {} }) {
    const startTime = Date.now();
    
    // Log the next step request
    loggingService.logMathProblem({
      userId,
      deviceId,
      problemText: problemContext,
      currentStep,
      studentAnswer,
      userGradeLevel,
      analysisResult: 'Getting next step...'
    });

    const systemPrompt = `You are "Homework Mentor" — a precise and patient AI tutor that guides students through their homework problems ONE STEP AT A TIME.
    
    STEP-BY-STEP TUTORING PHILOSOPHY:
    - Build on the student's previous step
    - Guide them to the NEXT logical step
    - Verify their understanding before moving forward
    - Never jump ahead to the final answer
    - Let students discover the solution through guided steps
    
    CURRENT SITUATION:
    - Student is on step ${currentStep}
    - Their answer to the previous step: "${studentAnswer}"
    - Problem context: "${problemContext}"
    - Grade level: ${userGradeLevel}
    
    YOUR TASK: Provide the NEXT step in the learning process.
    
    STEP-BY-STEP APPROACH:
    1. Acknowledge their previous step and answer
    2. If their answer was correct, guide them to the next logical step
    3. If their answer was incorrect, provide gentle correction and guide them back on track
    4. Always build understanding progressively
    5. Never reveal the final answer - only guide to the next step
    
    RESPONSE FORMAT:
    {
      "subject": "Math / Science / English / etc.",
      "difficulty": "easy / medium / hard",
      "currentStep": ${currentStep + 1},
      "totalSteps": 5,
      "previousStepFeedback": "Feedback on their previous answer",
      "currentStep": {
        "question": "What should you do NEXT to continue solving this problem?",
        "explanation": "Guidance for the next step - building on what they've done",
        "options": ["Option A", "Option B", "Option C", "Option D"],
        "correctAnswer": "The correct next step approach",
        "hint": "Additional hint if the student needs help with this step"
      },
      "nextStepPreview": "After completing this step, you'll need to [brief description of next step]",
      "progress": "Step ${currentStep + 1} of 5 - Building on your progress"
    }`;

    const messages = [
      { role: "system", content: systemPrompt },
      { role: "user", content: `I'm working on this problem: "${problemContext}". I just completed step ${currentStep} and my answer was "${studentAnswer}". What should I do next?` }
    ];

    const requestBody = {
      model: this.getModel('homework'),
      messages: messages,
      max_tokens: 1000,
      temperature: 0.3,
      response_format: { type: "json_object" }
    };

    // Log the system prompt
    console.log('🔍 Logging system prompt for next step...');
    loggingService.logOpenAIText(systemPrompt, 'next_step_system_prompt');

    // Log the user prompt
    console.log('🔍 Logging user messages for next step...');
    loggingService.logOpenAIText(JSON.stringify(messages, null, 2), 'next_step_user_messages');

    // Log the full request
    loggingService.logOpenAIInteraction({
      userId,
      deviceId,
      endpoint: 'get-next-step',
      requestData: requestBody,
      model: this.getModel('homework'),
      tokens: 0,
      duration: 0,
      error: null
    });

    try {
      const response = await axios.post(`${this.baseURL}/chat/completions`, requestBody, {
        headers: {
          'Authorization': `Bearer ${apiKey}`,
          'Content-Type': 'application/json'
        },
        timeout: 60000
      });

      if (response.data && response.data.choices && response.data.choices[0]) {
        const content = response.data.choices[0].message.content;

        // Log the raw response
        console.log('🔍 Logging raw response for next step...');
        loggingService.logOpenAIResponse(content, 'next_step_raw_response');

        const result = JSON.parse(content);

        // Log the parsed result
        console.log('🔍 Logging parsed result for next step...');
        loggingService.logOpenAIResponse(JSON.stringify(result, null, 2), 'next_step_parsed_result');

        // Log the final result
        loggingService.logOpenAIResponse(JSON.stringify(result, null, 2), 'next_step_final_result');

        // Log successful completion
        const duration = Date.now() - startTime;
        loggingService.logOpenAIInteraction({
          userId,
          deviceId,
          endpoint: 'get-next-step',
          requestData: requestBody,
          responseData: result,
          model: this.getModel('homework'),
          tokens: response.data.usage ? response.data.usage.total_tokens : 0,
          duration: duration,
          error: null
        });

        return result;
      } else {
        throw new Error('Invalid response from OpenAI API');
      }
    } catch (error) {
      // Log the error
      loggingService.logError(error, {
        userId,
        deviceId,
        endpoint: 'get-next-step',
        requestData: requestBody,
        duration: Date.now() - startTime
      });

      console.error('❌ Error in getNextStep:', error);
      throw error;
    }
  }

  async generateChatResponse({ messages, problemContext, userGradeLevel, apiKey, userId, deviceId, metadata = {} }) {
    const systemPrompt = `You are "Homework Mentor" — an intelligent and patient tutor that helps students solve their exact homework questions step by step.

CRITICAL BEHAVIORS:
- You must focus ONLY on the specific question or context provided
- Provide helpful, educational guidance without giving away answers
- Adapt your language and explanations to the student's grade level: ${userGradeLevel}
- Be encouraging and supportive while maintaining educational standards

AGE-APPROPRIATE GUIDANCE:
- Elementary (K-5): Use simple language, visual examples, concrete concepts
- Middle School (6-8): Introduce formulas with clear explanations
- High School (9-12): Use appropriate mathematical notation and abstract concepts`;

    // Convert iOS ChatMessage format to OpenAI format
    const openaiMessages = [
      { role: "system", content: systemPrompt },
      ...messages.map(msg => ({
        role: msg.role || "user", // Handle different message formats
        content: msg.content
      }))
    ];

    const requestBody = {
      model: this.getModel('chat'),
      messages: openaiMessages,
      max_tokens: 800,
      temperature: 0.2
    };

    try {
      const response = await axios.post(`${this.baseURL}/chat/completions`, requestBody, {
        headers: {
          'Authorization': `Bearer ${apiKey}`,
          'Content-Type': 'application/json'
        },
        timeout: 30000 // 30 second timeout
      });

      if (response.data && response.data.choices && response.data.choices[0]) {
        const content = response.data.choices[0].message.content;
        
        // Track usage if userId provided
        if (userId && response.data.usage) {
          await usageTrackingService.trackUsage({
            userId,
            deviceId,
            endpoint: 'chat_response',
            model: this.getModel('imageAnalysis'),
            usage: response.data.usage,
            metadata
          });
        }
        
        return content;
      } else {
        throw new Error('Invalid response from OpenAI API');
      }
    } catch (error) {
      if (error.response) {
        if (error.response.status === 401) {
          const authError = new Error('Invalid OpenAI API key');
          authError.status = 401;
          throw authError;
        } else if (error.response.status === 429) {
          const rateLimitError = new Error('OpenAI API rate limit exceeded');
          rateLimitError.status = 429;
          throw rateLimitError;
        }
      }
      throw error;
    }
  }

  /**
   * Analyze homework with Wolfram|Alpha integration for math problems
   * @param {Object} params - Analysis parameters
   * @returns {Object} - Analysis result with Wolfram|Alpha for math problems
   */
  async analyzeHomeworkWithWolfram({ imageData, problemText, teacherMethodImageData, userGradeLevel, apiKey, userId, deviceId, metadata = {} }) {
    try {
      // Check if this is a math problem that should use Wolfram|Alpha
      const isMathProblem = this.shouldUseWolframForMath(problemText);
      
      if (isMathProblem && problemText) {
        console.log('🧮 Math problem detected, using Wolfram|Alpha for calculation...');
        
        try {
          // Use Wolfram|Alpha to solve the math problem
          // const wolframResult = await this.wolframService.solveMathProblem(problemText); // Temporarily disabled
          const wolframResult = { success: false, error: 'Wolfram service disabled' };
          
          if (wolframResult.success) {
            console.log('✅ Wolfram|Alpha solved the problem successfully');
            
            // Use OpenAI for the educational presentation and step-by-step guidance
            const openaiResult = await this.analyzeHomework({
              imageData,
              problemText,
              teacherMethodImageData,
              userGradeLevel,
              apiKey,
              userId,
              deviceId,
              metadata
            });
            
            // Enhance the OpenAI result with Wolfram|Alpha's accurate answer
            if (openaiResult && typeof openaiResult === 'object') {
              // Add Wolfram|Alpha data to the result
              openaiResult.wolframAlpha = {
                used: true,
                answer: wolframResult.answer,
                method: wolframResult.method,
                confidence: wolframResult.confidence,
                steps: wolframResult.steps
              };
              
              // Update the final answer with Wolfram|Alpha's result
              if (openaiResult.finalAnswer) {
                openaiResult.finalAnswer += ` (Verified by Wolfram|Alpha: ${wolframResult.answer})`;
              }
              
              // Update steps with Wolfram|Alpha verification
              if (openaiResult.steps && Array.isArray(openaiResult.steps)) {
                openaiResult.steps.push({
                  question: "Verification: Check our answer",
                  explanation: `Let's verify our answer using Wolfram|Alpha: ${wolframResult.answer}`,
                  options: ["Correct", "Needs review", "Different method", "Check calculation"],
                  correctAnswer: "Correct"
                });
              }
            }
            
            return openaiResult;
          } else {
            console.log('⚠️ Wolfram|Alpha failed, falling back to OpenAI only');
            // Fall back to regular OpenAI analysis
            return await this.analyzeHomework({
              imageData,
              problemText,
              teacherMethodImageData,
              userGradeLevel,
              apiKey,
              userId,
              deviceId,
              metadata
            });
          }
        } catch (wolframError) {
          console.error('❌ Wolfram|Alpha error:', wolframError.message);
          console.log('🔄 Falling back to OpenAI only');
          
          // Fall back to regular OpenAI analysis
          return await this.analyzeHomework({
            imageData,
            problemText,
            teacherMethodImageData,
            userGradeLevel,
            apiKey,
            userId,
            deviceId,
            metadata
          });
        }
      } else {
        // Not a math problem or no problem text, use regular OpenAI analysis
        console.log('📝 Non-math problem or no text, using OpenAI only');
        return await this.analyzeHomework({
          imageData,
          problemText,
          teacherMethodImageData,
          userGradeLevel,
          apiKey,
          userId,
          deviceId,
          metadata
        });
      }
    } catch (error) {
      console.error('❌ Error in analyzeHomeworkWithWolfram:', error);
      throw error;
    }
  }
}

module.exports = new OpenAIService();
