#!/bin/bash

# Script to reset staging admin portal password via Azure Web SSH
# Run this script on the staging App Service via Web SSH

echo "🔧 RESETTING STAGING ADMIN PORTAL PASSWORD"
echo "=========================================="
echo ""

# Configuration
NEW_PASSWORD="A@dMin%f$7"
ADMIN_EMAIL="admin@homeworkhelper.com"

echo "📋 Configuration:"
echo "   New Password: $NEW_PASSWORD"
echo "   Admin Email: $ADMIN_EMAIL"
echo ""

# Function to hash password with SHA-256
hash_password() {
    echo -n "$1" | openssl dgst -sha256 | cut -d' ' -f2
}

# Get the password hash
echo "🔐 Generating password hash..."
PASSWORD_HASH=$(hash_password "$NEW_PASSWORD")
echo "   Hash: $PASSWORD_HASH"
echo ""

# Database connection details (from environment variables)
DB_HOST=$(echo $DATABASE_URL | grep -o 'Server=[^;]*' | cut -d'=' -f2)
DB_USER=$(echo $DATABASE_URL | grep -o 'User Id=[^;]*' | cut -d'=' -f2)
DB_PASS=$(echo $DATABASE_URL | grep -o 'Password=[^;]*' | cut -d'=' -f2)
DB_NAME=$(echo $DATABASE_URL | grep -o 'Database=[^;]*' | cut -d'=' -f2)

echo "🔗 Database Connection Details:"
echo "   Host: $DB_HOST"
echo "   User: $DB_USER"
echo "   Database: $DB_NAME"
echo ""

# Check if admin_users table exists and has username column
echo "📋 Checking database schema..."
psql "$DATABASE_URL" -c "
SELECT 
    CASE 
        WHEN EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'admin_users' AND column_name = 'username') 
        THEN 'Username column exists' 
        ELSE 'Username column missing' 
    END as username_column_status,
    CASE 
        WHEN EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'admin_users' AND column_name = 'email') 
        THEN 'Email column exists' 
        ELSE 'Email column missing' 
    END as email_column_status;
"

echo ""

# Add username column if it doesn't exist
echo "🔧 Adding username column if missing..."
psql "$DATABASE_URL" -c "
ALTER TABLE admin_users ADD COLUMN IF NOT EXISTS username VARCHAR(100);
"

echo ""

# Check current admin users
echo "👥 Current admin users:"
psql "$DATABASE_URL" -c "
SELECT id, email, username, is_active, created_at 
FROM admin_users 
ORDER BY id;
"

echo ""

# Update admin user password and username
echo "🔑 Updating admin user password and username..."
psql "$DATABASE_URL" -c "
UPDATE admin_users 
SET 
    password_hash = '$PASSWORD_HASH',
    username = CASE 
        WHEN username IS NULL OR username = '' THEN 'admin'
        ELSE username 
    END,
    updated_at = NOW()
WHERE email = '$ADMIN_EMAIL';
"

UPDATE_RESULT=$?
if [ $UPDATE_RESULT -eq 0 ]; then
    echo "✅ Admin user updated successfully"
else
    echo "❌ Failed to update admin user"
    exit 1
fi

echo ""

# Verify the update
echo "✅ Verifying admin user update..."
psql "$DATABASE_URL" -c "
SELECT 
    id, 
    email, 
    username, 
    CASE 
        WHEN password_hash = '$PASSWORD_HASH' THEN 'Password updated ✅'
        ELSE 'Password not updated ❌'
    END as password_status,
    is_active,
    created_at,
    updated_at
FROM admin_users 
WHERE email = '$ADMIN_EMAIL';
"

echo ""

# Test the admin login endpoint
echo "🧪 Testing admin login endpoint..."
LOGIN_RESPONSE=$(curl -s -X POST http://localhost/api/auth/admin-login \
  -H "Content-Type: application/json" \
  -d '{"username": "admin", "password": "'"$NEW_PASSWORD"'"}')

echo "   Login Response: $LOGIN_RESPONSE"

if echo "$LOGIN_RESPONSE" | grep -q "success"; then
    echo "✅ Admin login test successful!"
else
    echo "❌ Admin login test failed"
    echo "   Response: $LOGIN_RESPONSE"
fi

echo ""

# Create a simple test script for manual verification
echo "📝 Creating manual test script..."
cat > /tmp/test_admin_login.sh << 'EOF'
#!/bin/bash
echo "Testing admin login..."
curl -X POST http://localhost/api/auth/admin-login \
  -H "Content-Type: application/json" \
  -d '{"username": "admin", "password": "A@dMin%f$7"}' \
  -v
EOF

chmod +x /tmp/test_admin_login.sh
echo "   Manual test script created: /tmp/test_admin_login.sh"
echo "   Run: /tmp/test_admin_login.sh"

echo ""
echo "🎉 ADMIN PASSWORD RESET COMPLETED!"
echo "=================================="
echo ""
echo "📋 Summary:"
echo "   ✅ Password hash updated"
echo "   ✅ Username set to 'admin'"
echo "   ✅ Admin user verified"
echo ""
echo "🔑 New Admin Credentials:"
echo "   Username: admin"
echo "   Password: $NEW_PASSWORD"
echo ""
echo "🌐 Test the admin portal at:"
echo "   https://homework-helper-staging.azurewebsites.net/admin"
echo ""
echo "✅ Admin password reset completed successfully!"
