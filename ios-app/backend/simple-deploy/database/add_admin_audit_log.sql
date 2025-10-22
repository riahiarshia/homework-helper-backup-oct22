-- Add admin_audit_log table to existing database
-- This fixes the missing table error in admin routes

CREATE TABLE IF NOT EXISTS admin_audit_log (
    id SERIAL PRIMARY KEY,
    admin_user_id VARCHAR(255) NOT NULL,
    admin_username VARCHAR(255),
    admin_email VARCHAR(255),
    action VARCHAR(255) NOT NULL,
    target_type VARCHAR(100),
    target_id VARCHAR(255),
    target_email VARCHAR(255),
    target_username VARCHAR(255),
    details TEXT,
    ip_address INET,
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_admin_audit_log_admin_user_id ON admin_audit_log(admin_user_id);
CREATE INDEX IF NOT EXISTS idx_admin_audit_log_created_at ON admin_audit_log(created_at);
CREATE INDEX IF NOT EXISTS idx_admin_audit_log_action ON admin_audit_log(action);

-- Insert a sample audit log entry to test the table
INSERT INTO admin_audit_log (admin_user_id, admin_username, admin_email, action, details, ip_address, user_agent)
VALUES ('system', 'system', 'system@homeworkhelper.com', 'table_created', 'admin_audit_log table created', '127.0.0.1', 'migration-script');
