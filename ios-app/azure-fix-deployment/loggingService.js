const fs = require('fs');
const path = require('path');

class LoggingService {
  constructor() {
    this.logFilePath = '/home/LogFiles/custom/homework-math.log';
    this.ensureLogDirectory();
  }

  ensureLogDirectory() {
    try {
      const logDir = path.dirname(this.logFilePath);
      if (!fs.existsSync(logDir)) {
        fs.mkdirSync(logDir, { recursive: true });
        console.log(`📁 Created log directory: ${logDir}`);
      }
    } catch (error) {
      console.error('❌ Failed to create log directory:', error);
      // Fallback to console logging only in Azure
      this.logFilePath = null;
    }
  }

  formatTimestamp() {
    return new Date().toISOString();
  }

  formatLogEntry(type, data) {
    const timestamp = this.formatTimestamp();
    return {
      timestamp,
      type,
      data
    };
  }

  writeLog(entry) {
    try {
      if (this.logFilePath) {
        const logLine = JSON.stringify(entry) + '\n';
        fs.appendFileSync(this.logFilePath, logLine);
      } else {
        // Fallback to console logging in Azure
        console.log('📝 LOG ENTRY:', JSON.stringify(entry, null, 2));
      }
    } catch (error) {
      console.error('❌ Failed to write to log file:', error);
      // Fallback to console logging
      console.log('📝 LOG ENTRY:', JSON.stringify(entry, null, 2));
    }
  }

  logOpenAIRequest(endpoint, requestData) {
    const entry = this.formatLogEntry('OPENAI_REQUEST', {
      endpoint,
      request: {
        model: requestData.model,
        messages: requestData.messages ? requestData.messages.map(msg => ({
          role: msg.role,
          content: typeof msg.content === 'string' ? 
            msg.content.substring(0, 500) + (msg.content.length > 500 ? '...' : '') :
            msg.content
        })) : null,
        max_tokens: requestData.max_tokens,
        temperature: requestData.temperature,
        response_format: requestData.response_format
      },
      metadata: requestData.metadata || {}
    });
    
    this.writeLog(entry);
    console.log(`📤 OpenAI Request logged: ${endpoint}`);
  }

  logOpenAIResponse(endpoint, responseData, requestMetadata = {}) {
    const entry = this.formatLogEntry('OPENAI_RESPONSE', {
      endpoint,
      response: {
        model: responseData.model,
        usage: responseData.usage,
        choices: responseData.choices ? responseData.choices.map(choice => ({
          index: choice.index,
          message: {
            role: choice.message.role,
            content: choice.message.content ? 
              choice.message.content.substring(0, 1000) + (choice.message.content.length > 1000 ? '...' : '') :
              null
          },
          finish_reason: choice.finish_reason
        })) : null
      },
      requestMetadata
    });
    
    this.writeLog(entry);
    console.log(`📥 OpenAI Response logged: ${endpoint}`);
  }

  logOpenAIError(endpoint, error, requestData = {}) {
    const entry = this.formatLogEntry('OPENAI_ERROR', {
      endpoint,
      error: {
        message: error.message,
        status: error.status,
        code: error.code
      },
      request: requestData,
      stack: error.stack
    });
    
    this.writeLog(entry);
    console.log(`❌ OpenAI Error logged: ${endpoint} - ${error.message}`);
  }

  logHomeworkSubmission(userId, deviceId, submissionData) {
    const entry = this.formatLogEntry('HOMEWORK_SUBMISSION', {
      userId,
      deviceId,
      submission: {
        problemId: submissionData.problemId,
        subject: submissionData.subject,
        difficulty: submissionData.difficulty,
        gradeLevel: submissionData.gradeLevel,
        hasImage: !!submissionData.imageData,
        hasTeacherMethod: !!submissionData.teacherMethodImageData,
        problemText: submissionData.problemText ? 
          submissionData.problemText.substring(0, 200) + (submissionData.problemText.length > 200 ? '...' : '') :
          null
      },
      timestamp: this.formatTimestamp()
    });
    
    this.writeLog(entry);
    console.log(`📝 Homework submission logged for user: ${userId}`);
  }

  logHomeworkAnalysis(userId, deviceId, analysisResult) {
    const entry = this.formatLogEntry('HOMEWORK_ANALYSIS', {
      userId,
      deviceId,
      analysis: {
        subject: analysisResult.subject,
        difficulty: analysisResult.difficulty,
        stepCount: analysisResult.steps ? analysisResult.steps.length : 0,
        steps: analysisResult.steps ? analysisResult.steps.map((step, index) => ({
          stepIndex: index,
          question: step.question ? 
            step.question.substring(0, 200) + (step.question.length > 200 ? '...' : '') :
            null,
          explanation: step.explanation ? 
            step.explanation.substring(0, 300) + (step.explanation.length > 300 ? '...' : '') :
            null,
          optionsCount: step.options ? step.options.length : 0,
          correctAnswer: step.correctAnswer
        })) : null,
        finalAnswer: analysisResult.finalAnswer
      },
      timestamp: this.formatTimestamp()
    });
    
    this.writeLog(entry);
    console.log(`🧠 Homework analysis logged for user: ${userId}`);
  }

  logHintGeneration(userId, deviceId, hintData) {
    const entry = this.formatLogEntry('HINT_GENERATION', {
      userId,
      deviceId,
      hint: {
        problemContext: hintData.problemContext ? 
          hintData.problemContext.substring(0, 200) + (hintData.problemContext.length > 200 ? '...' : '') :
          null,
        stepQuestion: hintData.step ? hintData.step.question : null,
        gradeLevel: hintData.userGradeLevel,
        hintText: hintData.hint ? 
          hintData.hint.substring(0, 500) + (hintData.hint.length > 500 ? '...' : '') :
          null
      },
      timestamp: this.formatTimestamp()
    });
    
    this.writeLog(entry);
    console.log(`💡 Hint generation logged for user: ${userId}`);
  }

  logAnswerVerification(userId, deviceId, verificationData) {
    const entry = this.formatLogEntry('ANSWER_VERIFICATION', {
      userId,
      deviceId,
      verification: {
        answer: verificationData.answer,
        stepQuestion: verificationData.step ? verificationData.step.question : null,
        correctAnswer: verificationData.step ? verificationData.step.correctAnswer : null,
        isCorrect: verificationData.result ? verificationData.result.isCorrect : null,
        verification: verificationData.result ? verificationData.result.verification : null,
        gradeLevel: verificationData.userGradeLevel
      },
      timestamp: this.formatTimestamp()
    });
    
    this.writeLog(entry);
    console.log(`✅ Answer verification logged for user: ${userId}`);
  }

  logChatResponse(userId, deviceId, chatData) {
    const entry = this.formatLogEntry('CHAT_RESPONSE', {
      userId,
      deviceId,
      chat: {
        messageCount: chatData.messages ? chatData.messages.length : 0,
        problemContext: chatData.problemContext ? 
          chatData.problemContext.substring(0, 200) + (chatData.problemContext.length > 200 ? '...' : '') :
          null,
        gradeLevel: chatData.userGradeLevel,
        response: chatData.response ? 
          chatData.response.substring(0, 1000) + (chatData.response.length > 1000 ? '...' : '') :
          null
      },
      timestamp: this.formatTimestamp()
    });
    
    this.writeLog(entry);
    console.log(`💬 Chat response logged for user: ${userId}`);
  }

  logImageValidation(userId, deviceId, validationData) {
    const entry = this.formatLogEntry('IMAGE_VALIDATION', {
      userId,
      deviceId,
      validation: {
        isGoodQuality: validationData.isGoodQuality,
        confidence: validationData.confidence,
        issues: validationData.issues,
        recommendations: validationData.recommendations,
        fileSize: validationData.metadata ? validationData.metadata.fileSize : null,
        mimeType: validationData.metadata ? validationData.metadata.mimeType : null
      },
      timestamp: this.formatTimestamp()
    });
    
    this.writeLog(entry);
    console.log(`🖼️ Image validation logged for user: ${userId}`);
  }
}

module.exports = new LoggingService();
