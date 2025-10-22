#!/bin/bash

# Quick Admin Password Reset for Azure SSH
# Run this from Azure App Service SSH

set -e

echo "🔐 Quick Admin Password Reset (Azure SSH)"
echo "========================================"
echo ""

# Get new password from user
read -s -p "Enter new admin password: " NEW_PASSWORD
echo ""

if [ -z "$NEW_PASSWORD" ]; then
    echo "❌ Password cannot be empty!"
    exit 1
fi

read -p "Enter new admin email (default: support_homework@arshia.com): " NEW_EMAIL
NEW_EMAIL=${NEW_EMAIL:-support_homework@arshia.com}

echo ""
echo "📋 Resetting admin password..."
echo "   Email: $NEW_EMAIL"
echo "   Password: [HIDDEN]"
echo ""

# Generate SHA256 hash
PASSWORD_HASH=$(echo -n "$NEW_PASSWORD" | openssl dgst -sha256 -hex | cut -d' ' -f2)

echo "🔍 Generated password hash: ${PASSWORD_HASH:0:20}..."
echo ""

# Create the reset script
cat > reset_admin_quick.js << 'EOF'
const crypto = require('crypto');
const { Pool } = require('pg');

// Use environment DATABASE_URL
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: { rejectUnauthorized: false }
});

async function resetAdminPassword() {
  try {
    const username = 'admin';
    const newEmail = process.argv[2];
    const newPassword = process.argv[3];
    const passwordHash = crypto.createHash('sha256').update(newPassword).digest('hex');
    
    console.log('🔐 RESETTING ADMIN PASSWORD');
    console.log('==========================');
    console.log('');
    console.log('📋 New Admin Details:');
    console.log('   Username: admin');
    console.log('   Email: ' + newEmail);
    console.log('   Password: [HIDDEN]');
    console.log('');
    
    // Update or create admin
    const result = await pool.query(`
      INSERT INTO admin_users (username, email, password_hash, role, is_active, created_at)
      VALUES ($1, $2, $3, 'super_admin', true, NOW())
      ON CONFLICT (username) DO UPDATE SET
        email = EXCLUDED.email,
        password_hash = EXCLUDED.password_hash,
        updated_at = NOW()
      RETURNING username, email, role
    `, [username, newEmail, passwordHash]);
    
    if (result.rows.length > 0) {
      const admin = result.rows[0];
      console.log('✅ Admin password reset successfully!');
      console.log('');
      console.log('📋 Admin Details:');
      console.log('   Username: ' + admin.username);
      console.log('   Email: ' + admin.email);
      console.log('   Role: ' + admin.role);
      console.log('');
      console.log('🔑 Login Credentials:');
      console.log('   Username: admin');
      console.log('   Password: ' + newPassword);
      console.log('');
      console.log('🌐 Admin Portal URL:');
      console.log('   https://homework-helper-api.azurewebsites.net/admin/');
      console.log('');
      console.log('⚠️  Save these credentials securely!');
    }
    
  } catch (error) {
    console.error('❌ Error:', error.message);
    process.exit(1);
  } finally {
    await pool.end();
  }
}

resetAdminPassword();
EOF

# Run the reset
echo "🚀 Running password reset..."
node reset_admin_quick.js "$NEW_EMAIL" "$NEW_PASSWORD"

# Clean up
rm -f reset_admin_quick.js

echo ""
echo "🎉 Password reset completed!"
