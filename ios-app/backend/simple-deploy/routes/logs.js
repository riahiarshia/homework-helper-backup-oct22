const express = require('express');
const fs = require('fs');
const path = require('path');
const router = express.Router();

// Endpoint to view the homework-math.log file
router.get('/homework-math', (req, res) => {
  try {
    const logPath = path.join(process.cwd(), 'LogFiles', 'custom', 'homework-math.log');
    
    if (!fs.existsSync(logPath)) {
      return res.status(404).json({
        error: 'Log file not found',
        path: logPath,
        message: 'The homework-math.log file does not exist yet. Make a homework analysis request first.'
      });
    }

    const logContent = fs.readFileSync(logPath, 'utf8');
    const lines = logContent.split('\n').filter(line => line.trim());
    
    res.json({
      success: true,
      path: logPath,
      totalLines: lines.length,
      lastModified: fs.statSync(logPath).mtime,
      content: logContent
    });
  } catch (error) {
    console.error('Error reading log file:', error);
    res.status(500).json({
      error: 'Failed to read log file',
      message: error.message
    });
  }
});

// Endpoint to get log file info
router.get('/info', (req, res) => {
  try {
    const logPath = path.join(process.cwd(), 'LogFiles', 'custom', 'homework-math.log');
    const logDir = path.join(process.cwd(), 'LogFiles', 'custom');
    
    const info = {
      logPath: logPath,
      logDir: logDir,
      logDirExists: fs.existsSync(logDir),
      logFileExists: fs.existsSync(logPath),
      currentWorkingDir: process.cwd()
    };

    if (fs.existsSync(logPath)) {
      const stats = fs.statSync(logPath);
      info.fileSize = stats.size;
      info.lastModified = stats.mtime;
      info.created = stats.birthtime;
    }

    res.json(info);
  } catch (error) {
    res.status(500).json({
      error: 'Failed to get log info',
      message: error.message
    });
  }
});

module.exports = router;
