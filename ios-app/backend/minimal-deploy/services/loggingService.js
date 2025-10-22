const fs = require('fs');
const path = require('path');

class LoggingService {
  constructor() {
    // Use absolute path for production compatibility
    this.logDir = path.join(process.cwd(), 'LogFiles', 'custom');
    this.ensureLogDirectory();
    console.log('📝 LoggingService initialized. Log directory:', this.logDir);
  }

  ensureLogDirectory() {
    if (!fs.existsSync(this.logDir)) {
      fs.mkdirSync(this.logDir, { recursive: true });
    }
  }

  getTimestamp() {
    return new Date().toISOString();
  }

  formatLogEntry(level, message, data = null) {
    const timestamp = this.getTimestamp();
    const logEntry = {
      timestamp,
      level,
      message,
      data: data ? JSON.stringify(data, null, 2) : null
    };
    return JSON.stringify(logEntry, null, 2);
  }

  writeToFile(filename, content) {
    try {
      const filePath = path.join(this.logDir, filename);
      console.log('📝 Writing to log file:', filePath);
      fs.appendFileSync(filePath, content + '\n\n');
      console.log('✅ Successfully wrote to log file');
    } catch (error) {
      console.error('❌ Failed to write to log file:', error);
      console.error('Log directory exists:', fs.existsSync(this.logDir));
      console.error('Log directory:', this.logDir);
    }
  }

  logOpenAIInteraction(interaction) {
    const {
      userId,
      deviceId,
      endpoint,
      requestData,
      responseData,
      model,
      tokens,
      duration,
      error
    } = interaction;

    const logEntry = this.formatLogEntry('INFO', 'OpenAI Interaction', {
      userId: userId || 'anonymous',
      deviceId: deviceId || 'unknown',
      endpoint: endpoint || 'unknown',
      model: model || 'unknown',
      tokens: tokens || 0,
      duration: duration || 0,
      requestData: requestData,
      responseData: responseData,
      error: error || null,
      timestamp: this.getTimestamp()
    });

    this.writeToFile('homework-math.log', logEntry);
  }

  logMathProblem(problemData) {
    const {
      userId,
      deviceId,
      problemText,
      imageData,
      teacherMethodImage,
      userGradeLevel,
      analysisResult,
      error
    } = problemData;

    const logEntry = this.formatLogEntry('INFO', 'Math Problem Analysis', {
      userId: userId || 'anonymous',
      deviceId: deviceId || 'unknown',
      problemText: problemText || 'No text provided',
      hasImage: !!imageData,
      hasTeacherMethod: !!teacherMethodImage,
      userGradeLevel: userGradeLevel || 'unknown',
      analysisResult: analysisResult,
      error: error || null,
      timestamp: this.getTimestamp()
    });

    this.writeToFile('homework-math.log', logEntry);
  }

  logSystemEvent(event, data = {}) {
    const logEntry = this.formatLogEntry('SYSTEM', event, {
      ...data,
      timestamp: this.getTimestamp()
    });

    this.writeToFile('homework-math.log', logEntry);
  }

  logError(error, context = {}) {
    const logEntry = this.formatLogEntry('ERROR', 'System Error', {
      error: error.message || error,
      stack: error.stack || null,
      context: context,
      timestamp: this.getTimestamp()
    });

    this.writeToFile('homework-math.log', logEntry);
  }

  // Log all text sent to OpenAI
  logOpenAIText(text, type = 'request') {
    const logEntry = this.formatLogEntry('OPENAI_TEXT', `OpenAI ${type}`, {
      type: type,
      text: text,
      length: text ? text.length : 0,
      timestamp: this.getTimestamp()
    });

    this.writeToFile('homework-math.log', logEntry);
  }

  // Log all responses from OpenAI
  logOpenAIResponse(response, type = 'response') {
    const logEntry = this.formatLogEntry('OPENAI_RESPONSE', `OpenAI ${type}`, {
      type: type,
      response: response,
      length: response ? response.length : 0,
      timestamp: this.getTimestamp()
    });

    this.writeToFile('homework-math.log', logEntry);
  }
}

module.exports = new LoggingService();
