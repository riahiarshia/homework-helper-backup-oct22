#!/bin/bash

# Simple script to reset staging admin password - Copy this to Azure Web SSH

echo "Resetting admin password..."

# Hash the new password
PASSWORD_HASH=$(echo -n "A@dMin%f$7" | openssl dgst -sha256 | cut -d' ' -f2)

# Add username column if missing
psql "$DATABASE_URL" -c "ALTER TABLE admin_users ADD COLUMN IF NOT EXISTS username VARCHAR(100);"

# Update admin user
psql "$DATABASE_URL" -c "
UPDATE admin_users 
SET 
    password_hash = '$PASSWORD_HASH',
    username = 'admin'
WHERE email = 'admin@homeworkhelper.com';
"

# Verify update
psql "$DATABASE_URL" -c "SELECT id, email, username, is_active FROM admin_users;"

echo "✅ Admin password reset to: A@dMin%f$7"
echo "Username: admin"
echo "Password: A@dMin%f$7"
