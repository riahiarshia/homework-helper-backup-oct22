// Simple endpoint to create database dump
const express = require('express');
const { exec } = require('child_process');
const fs = require('fs');
const app = express();

app.get('/create-dump', (req, res) => {
    console.log('Creating database dump...');
    
    // Get database connection details from environment
    const dbUrl = process.env.DATABASE_URL;
    if (!dbUrl) {
        return res.status(500).json({ error: 'DATABASE_URL not found' });
    }
    
    console.log('Database URL found, creating dump...');
    
    // Create pg_dump command
    const dumpCommand = `pg_dump "${dbUrl}" --clean --no-owner --no-privileges --format=plain`;
    
    exec(dumpCommand, (error, stdout, stderr) => {
        if (error) {
            console.error('Error:', error);
            return res.status(500).json({ error: error.message });
        }
        
        if (stderr) {
            console.error('Stderr:', stderr);
        }
        
        console.log('Dump completed successfully');
        console.log('Output length:', stdout.length);
        
        // Return the dump content
        res.setHeader('Content-Type', 'application/octet-stream');
        res.setHeader('Content-Disposition', 'attachment; filename=production-dump.sql');
        res.send(stdout);
    });
});

app.get('/health', (req, res) => {
    res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

const port = process.env.PORT || 3000;
app.listen(port, () => {
    console.log(`Dump service listening on port ${port}`);
});
