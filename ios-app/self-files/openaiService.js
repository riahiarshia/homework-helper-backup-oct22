iconst axios = require('axios');
const fs = require('fs');
const path = require('path');
const config = require('../config');
const usageTrackingService = require('./usageTrackingService');
const { evaluate } = require('mathjs');

/* ------------------------------- Logger ---------------------------------- */
// Writes to console + file. File defaults to Azure App Service logs folder.
class Logger {
  constructor() {
    const defaultDir = '/home/LogFiles/Application';
    const defaultFile = path.join(defaultDir, 'app.log');
    this.filePath = process.env.LOG_FILE_PATH || defaultFile;

    try {
      fs.mkdirSync(path.dirname(this.filePath), { recursive: true });
      this.stream = fs.createWriteStream(this.filePath, { flags: 'a', encoding: 'utf8' });
    } catch (e) {
      // If file logging fails, we’ll still log to console.
      console.error('⚠️ [LOGGER] Failed to open log file:', this.filePath, e?.message);
      this.stream = null;
    }
  }

  line(level, msg, data) {
    const ts = new Date().toISOString();
    let payload = '';
    if (data !== undefined) {
      try {
        payload = ' ' + JSON.stringify(data);
      } catch {
        payload = ' ' + String(data);
      }
    }
    return `[${ts}] ${level} ${msg}${payload}\n`;
  }

  write(level, msg, data) {
    const text = this.line(level, msg, data);
    // Console
    if (level === 'ERROR') console.error(text.trim());
    else console.log(text.trim());
    // File
    if (this.stream) {
      try { this.stream.write(text); } catch { /* ignore */ }
    }
  }

  debug(msg, data) { this.write('DEBUG', msg, data); }
  info(msg, data)  { this.write('INFO',  msg, data); }
  error(msg, data) { this.write('ERROR', msg, data); }
}

const logger = new Logger();
/* ------------------------------------------------------------------------ */

class OpenAIService {
  constructor() {
    this.baseURL = config.openai.baseURL;
  }

  // Choose model by task type
  getModel(taskType = 'default') {
    const models = config.openai.models || {};
    const chosen = models[taskType] || models.default || config.openai.model;
    return chosen;
  }

  // 🧮 Local math evaluation (number only; units stripped)
  evaluateExpression(expression) {
    try {
      if (!expression) return null;
      const val = evaluate(expression);
      if (typeof val === 'number' && !isNaN(val)) {
        return val.toString();
      }
      return null;
    } catch (err) {
      logger.error('❌ [MATH] Failed to evaluate expression', { expression, error: err?.message });
      return null;
    }
  }

  async validateImageQuality({ imageData, apiKey, userId, deviceId, metadata = {} }) {
    const systemPrompt = `You are an image quality assessor for homework analysis. Evaluate the image quality for homework analysis purposes.

CRITICAL QUALITY CHECKS:
1. Text Readability: Can all text, numbers, and symbols be clearly read?
2. Image Sharpness: Is the image in focus and not blurry?
3. Lighting: Is the image well-lit without shadows or glare?
4. Completeness: Is the entire homework visible without being cut off?
5. Resolution: Is the image high enough resolution to read small text?
6. Orientation: Is the image properly oriented (not upside down or sideways)?

RESPOND WITH EXACTLY THIS JSON FORMAT:
{
  "isGoodQuality": true/false,
  "confidence": 0.0-1.0,
  "issues": ["specific issue 1", "specific issue 2"],
  "recommendations": ["specific recommendation 1", "specific recommendation 2"]
}

QUALITY STANDARDS:
- Good Quality: Text is clear, image is sharp, well-lit, complete, and properly oriented
- Poor Quality: Blurry text, poor lighting, cut-off content, or any readability issues

Be strict but fair in your assessment.`;

    const base64Image = imageData.toString('base64');
    const dataURL = `data:image/jpeg;base64,${base64Image}`;

    const messages = [
      { role: 'system', content: systemPrompt },
      {
        role: 'user',
        content: [
          { type: 'text', text: 'Please evaluate the quality of this homework image for analysis purposes. Check for text readability, image sharpness, lighting, completeness, and orientation.' },
          { type: 'image_url', image_url: { url: dataURL } }
        ]
      }
    ];

    const requestBody = {
      model: this.getModel('imageAnalysis'),
      messages,
      max_tokens: 500,
      temperature: 0.1,
      response_format: { type: 'json_object' }
    };

    logger.info('📤 [validateImageQuality] Sending request', { model: requestBody.model });

    try {
      const response = await axios.post(`${this.baseURL}/chat/completions`, requestBody, {
        headers: { Authorization: `Bearer ${apiKey}`, 'Content-Type': 'application/json' },
        timeout: 30000
      });

      let result;
      if (response.data?.choices?.[0]) {
        const content = response.data.choices[0].message.content;
        result = JSON.parse(content);

        // Logs (trim to useful bits)
        logger.debug('📥 [validateImageQuality] OpenAI usage', response.data.usage || {});
        logger.debug('🧾 [validateImageQuality] Content', content);
        logger.debug('✅ [validateImageQuality] Parsed', result);

        // Usage tracking
        if (userId && response.data.usage) {
          await usageTrackingService.trackUsage({
            userId, deviceId, endpoint: 'validate_image',
            model: requestBody.model, usage: response.data.usage, metadata
          });
        }
      } else {
        throw new Error('Invalid response from OpenAI API');
      }

      return result;
    } catch (error) {
      logger.error('❌ [validateImageQuality] Error', { status: error?.response?.status, message: error?.message });
      if (error.response?.status === 401) throw Object.assign(new Error('Invalid OpenAI API key'), { status: 401 });
      if (error.response?.status === 429) throw Object.assign(new Error('OpenAI API rate limit exceeded'), { status: 429 });
      throw error;
    }
  }

  async analyzeHomework({ imageData, problemText, teacherMethodImageData, userGradeLevel, apiKey, userId, deviceId, metadata = {} }) {
    const systemPrompt = `You are "Homework Mentor" — a precise and patient AI tutor that helps students solve their exact homework questions step by step.

❗️DO NOT compute numeric answers. Instead, output a "calc" object with a valid mathematical expression only. The server will compute the final number.
Example:
"calc": { "expression": "2 * (320 + 163)" }

ABSOLUTE RULES:
1) ONLY use numbers that appear in the image.
2) If you see a blank, the student must fill it.
3) Read all digits precisely; include signs/decimals/fractions.
4) Options must be realistic for the actual problem.
5) Do not assume anything not visible.`;

    const userPrompt = `Read the image carefully. Respond in JSON. For each step, include "calc.expression" but DO NOT compute the numeric result. The server evaluates the math.`;

    const messages = [{ role: 'system', content: systemPrompt }];

    if (imageData) {
      const base64Image = imageData.toString('base64');
      const dataURL = `data:image/jpeg;base64,${base64Image}`;
      const contentArray = [{ type: 'text', text: userPrompt }];

      if (problemText) contentArray.push({ type: 'text', text: `Additional context: ${problemText}` });
      contentArray.push({ type: 'image_url', image_url: { url: dataURL, detail: 'high' } });

      if (teacherMethodImageData) {
        const base64Teacher = teacherMethodImageData.toString('base64');
        const teacherURL = `data:image/jpeg;base64,${base64Teacher}`;
        contentArray.push({ type: 'text', text: "Here is the teacher's example:" });
        contentArray.push({ type: 'image_url', image_url: { url: teacherURL, detail: 'high' } });
      }

      messages.push({ role: 'user', content: contentArray });
    } else if (problemText) {
      messages.push({ role: 'user', content: `${userPrompt}\n\nProblem: ${problemText}` });
    }

    const requestBody = {
      model: this.getModel('homework'),
      messages,
      max_tokens: config.openai.maxTokens,
      temperature: 0,
      response_format: { type: 'json_object' }
    };

    logger.info('📤 [analyzeHomework] Sending request', { model: requestBody.model, hasImage: !!imageData, hasTeacherMethod: !!teacherMethodImageData });

    try {
      const response = await axios.post(`${this.baseURL}/chat/completions`, requestBody, {
        headers: { Authorization: `Bearer ${apiKey}`, 'Content-Type': 'application/json' },
        timeout: 60000
      });

      let result;
      if (response.data?.choices?.[0]) {
        const content = response.data.choices[0].message.content;
        result = JSON.parse(content);

        // ✅ Evaluate math locally & overwrite correctAnswer with number
        if (Array.isArray(result?.steps)) {
          result.steps = result.steps.map((step, idx) => {
            const expr = step?.calc?.expression;
            const evaluated = this.evaluateExpression(expr);
            if (evaluated !== null) {
              logger.debug('🧮 [analyzeHomework] Step evaluation', { stepIndex: idx, expression: expr, evaluated });
              step.correctAnswer = evaluated;
            } else {
              logger.debug('🧮 [analyzeHomework] Step has no/invalid expression', { stepIndex: idx, expression: expr });
            }
            return step;
          });
        }

        // Logs (trim to useful bits)
        logger.debug('📥 [analyzeHomework] OpenAI usage', response.data.usage || {});
        logger.debug('🧾 [analyzeHomework] Content', content);
        logger.debug('✅ [analyzeHomework] Parsed', result);

        // Usage tracking
        if (userId && response.data.usage) {
          await usageTrackingService.trackUsage({
            userId, deviceId, endpoint: 'analyze_homework',
            model: requestBody.model, usage: response.data.usage, metadata
          });
        }
      } else {
        throw new Error('Invalid response from OpenAI API');
      }

      return result;
    } catch (error) {
      logger.error('❌ [analyzeHomework] Error', { status: error?.response?.status, message: error?.message });
      if (error.response?.status === 401) throw Object.assign(new Error('Invalid OpenAI API key'), { status: 401 });
      if (error.response?.status === 429) throw Object.assign(new Error('OpenAI API rate limit exceeded'), { status: 429 });
      throw error;
    }
  }

  async generateHint({ step, problemContext, userGradeLevel, apiKey, userId, deviceId, metadata = {} }) {
    const systemPrompt = `You are "Homework Mentor" — provide a subtle hint without revealing the final numeric result.`;

    const userPrompt = `PROBLEM CONTEXT: ${problemContext}
STEP QUESTION: ${step.question}
STEP EXPLANATION: ${step.explanation}
AVAILABLE OPTIONS: ${step.options?.join(', ') || 'N/A'}
CORRECT ANSWER (for context only): ${step.correctAnswer}`;

    const messages = [
      { role: 'system', content: systemPrompt },
      { role: 'user', content: userPrompt }
    ];

    const requestBody = {
      model: this.getModel('homework'),
      messages,
      max_tokens: 400,
      temperature: config.openai.temperature
    };

    logger.info('📤 [generateHint] Sending request', { model: requestBody.model });

    try {
      const response = await axios.post(`${this.baseURL}/chat/completions`, requestBody, {
        headers: { Authorization: `Bearer ${apiKey}`, 'Content-Type': 'application/json' },
        timeout: 30000
      });

      let content;
      if (response.data?.choices?.[0]) {
        content = response.data.choices[0].message.content;

        logger.debug('📥 [generateHint] OpenAI usage', response.data.usage || {});
        logger.debug('💡 [generateHint] Content', content);

        if (userId && response.data.usage) {
          await usageTrackingService.trackUsage({
            userId, deviceId, endpoint: 'generate_hint',
            model: requestBody.model, usage: response.data.usage, metadata
          });
        }
      } else {
        throw new Error('Invalid response from OpenAI API');
      }

      return content;
    } catch (error) {
      logger.error('❌ [generateHint] Error', { status: error?.response?.status, message: error?.message });
      if (error.response?.status === 401) throw Object.assign(new Error('Invalid OpenAI API key'), { status: 401 });
      if (error.response?.status === 429) throw Object.assign(new Error('OpenAI API rate limit exceeded'), { status: 429 });
      throw error;
    }
  }

  async verifyAnswer({ answer, step }) {
    // Prefer local evaluation when expression present
    const expr = step?.calc?.expression;
    const expected = this.evaluateExpression(expr);

    if (expected !== null) {
      const isCorrect = String(answer).trim() === String(expected).trim();
      logger.info('🔎 [verifyAnswer] Local evaluation', { expression: expr, expected, studentAnswer: String(answer), result: isCorrect ? 'CORRECT' : 'INCORRECT' });
      return { isCorrect, verification: isCorrect ? 'CORRECT' : 'INCORRECT' };
    }

    // Fallback: strict string comparison to provided correctAnswer
    const isCorrect = String(answer).trim() === String(step.correctAnswer).trim();
    logger.info('🔎 [verifyAnswer] Fallback compare', { expected: String(step.correctAnswer), studentAnswer: String(answer), result: isCorrect ? 'CORRECT' : 'INCORRECT' });
    return { isCorrect, verification: isCorrect ? 'CORRECT' : 'INCORRECT' };
  }

  async generateChatResponse({ messages, apiKey, userId, deviceId, metadata = {} }) {
    const systemPrompt = `You are "Homework Mentor" — an intelligent and patient tutor.`;

    const openaiMessages = [
      { role: 'system', content: systemPrompt },
      ...messages.map(msg => ({ role: msg.role || 'user', content: msg.content }))
    ];

    const requestBody = {
      model: this.getModel('chat'),
      messages: openaiMessages,
      max_tokens: 800,
      temperature: 0.2
    };

    logger.info('📤 [generateChatResponse] Sending request', { model: requestBody.model });

    try {
      const response = await axios.post(`${this.baseURL}/chat/completions`, requestBody, {
        headers: { Authorization: `Bearer ${apiKey}`, 'Content-Type': 'application/json' },
        timeout: 30000
      });

      let content;
      if (response.data?.choices?.[0]) {
        content = response.data.choices[0].message.content;

        logger.debug('📥 [generateChatResponse] OpenAI usage', response.data.usage || {});
        logger.debug('💬 [generateChatResponse] Content', content);

        if (userId && response.data.usage) {
          await usageTrackingService.trackUsage({
            userId, deviceId, endpoint: 'chat_response',
            model: requestBody.model, usage: response.data.usage, metadata
          });
        }
      } else {
        throw new Error('Invalid response from OpenAI API');
      }

      return content;
    } catch (error) {
      logger.error('❌ [generateChatResponse] Error', { status: error?.response?.status, message: error?.message });
      if (error.response?.status === 401) throw Object.assign(new Error('Invalid OpenAI API key'), { status: 401 });
      if (error.response?.status === 429) throw Object.assign(new Error('OpenAI API rate limit exceeded'), { status: 429 });
      throw error;
    }
  }
}

module.exports = new OpenAIService();

