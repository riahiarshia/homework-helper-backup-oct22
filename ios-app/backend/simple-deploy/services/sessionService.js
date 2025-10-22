const fs = require('fs');
const path = require('path');

class SessionService {
  constructor() {
    this.sessions = new Map(); // In-memory storage for now
    this.sessionDir = path.join(process.cwd(), 'LogFiles', 'sessions');
    this.ensureSessionDirectory();
  }

  ensureSessionDirectory() {
    if (!fs.existsSync(this.sessionDir)) {
      fs.mkdirSync(this.sessionDir, { recursive: true });
    }
  }

  // Create a new tutoring session
  createSession({ userId, deviceId, problemContext, currentStep, totalSteps, subject, difficulty }) {
    const sessionId = `${userId}_${deviceId}_${Date.now()}`;
    const session = {
      sessionId,
      userId,
      deviceId,
      problemContext,
      currentStep: currentStep || 1,
      totalSteps: totalSteps || 5,
      subject: subject || 'Math',
      difficulty: difficulty || 'medium',
      steps: [],
      studentAnswers: [],
      createdAt: new Date().toISOString(),
      lastActivity: new Date().toISOString(),
      isCompleted: false
    };

    this.sessions.set(sessionId, session);
    this.saveSessionToFile(session);
    
    console.log(`📚 Created new tutoring session: ${sessionId}`);
    return session;
  }

  // Get current session
  getSession(sessionId) {
    return this.sessions.get(sessionId);
  }

  // Add student answer and progress to next step
  addStudentAnswer(sessionId, studentAnswer, nextStep) {
    const session = this.sessions.get(sessionId);
    if (!session) {
      throw new Error('Session not found');
    }

    // Add the student's answer
    session.studentAnswers.push({
      step: session.currentStep,
      answer: studentAnswer,
      timestamp: new Date().toISOString()
    });

    // Add the next step
    if (nextStep) {
      session.steps.push(nextStep);
      session.currentStep = nextStep.currentStep;
    }

    session.lastActivity = new Date().toISOString();

    // Check if session is completed
    if (session.currentStep >= session.totalSteps) {
      session.isCompleted = true;
      console.log(`🎉 Session completed: ${sessionId}`);
    }

    this.sessions.set(sessionId, session);
    this.saveSessionToFile(session);
    
    return session;
  }

  // Get session progress
  getSessionProgress(sessionId) {
    const session = this.sessions.get(sessionId);
    if (!session) {
      return null;
    }

    return {
      sessionId: session.sessionId,
      currentStep: session.currentStep,
      totalSteps: session.totalSteps,
      progress: `${session.currentStep}/${session.totalSteps}`,
      isCompleted: session.isCompleted,
      stepsCompleted: session.studentAnswers.length,
      lastActivity: session.lastActivity
    };
  }

  // Save session to file for persistence
  saveSessionToFile(session) {
    try {
      const filePath = path.join(this.sessionDir, `${session.sessionId}.json`);
      fs.writeFileSync(filePath, JSON.stringify(session, null, 2));
    } catch (error) {
      console.error('❌ Failed to save session to file:', error);
    }
  }

  // Load session from file
  loadSessionFromFile(sessionId) {
    try {
      const filePath = path.join(this.sessionDir, `${sessionId}.json`);
      if (fs.existsSync(filePath)) {
        const sessionData = fs.readFileSync(filePath, 'utf8');
        const session = JSON.parse(sessionData);
        this.sessions.set(sessionId, session);
        return session;
      }
    } catch (error) {
      console.error('❌ Failed to load session from file:', error);
    }
    return null;
  }

  // Get all sessions for a user
  getUserSessions(userId) {
    const userSessions = [];
    for (const [sessionId, session] of this.sessions) {
      if (session.userId === userId) {
        userSessions.push({
          sessionId: session.sessionId,
          problemContext: session.problemContext,
          currentStep: session.currentStep,
          totalSteps: session.totalSteps,
          isCompleted: session.isCompleted,
          createdAt: session.createdAt,
          lastActivity: session.lastActivity
        });
      }
    }
    return userSessions;
  }

  // Clean up old sessions (older than 24 hours)
  cleanupOldSessions() {
    const now = new Date();
    const oneDayAgo = new Date(now.getTime() - 24 * 60 * 60 * 1000);
    
    for (const [sessionId, session] of this.sessions) {
      const sessionTime = new Date(session.createdAt);
      if (sessionTime < oneDayAgo) {
        this.sessions.delete(sessionId);
        console.log(`🧹 Cleaned up old session: ${sessionId}`);
      }
    }
  }
}

module.exports = new SessionService();
