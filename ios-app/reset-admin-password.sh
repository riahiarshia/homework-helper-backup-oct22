#!/bin/bash

# Reset Admin Portal Password Script
# This script can be run from:
# 1. Your laptop (with Azure CLI)
# 2. Azure Cloud Shell
# 3. SSH into the web app

set -e

echo "🔐 Admin Portal Password Reset Tool"
echo "===================================="
echo ""

# Function to get database connection details
get_database_connection() {
    echo "🔍 Getting database connection details..."
    
    # Try to get from Azure Key Vault first
    if command -v az &> /dev/null && az account show &> /dev/null; then
        echo "   Using Azure Key Vault for database credentials..."
        
        # Get production database password from Key Vault
        PROD_PASSWORD=$(az keyvault secret show --vault-name "OpenAI-1" --name "Production-Database-Password" --query "value" -o tsv 2>/dev/null || echo "")
        
        if [ -n "$PROD_PASSWORD" ]; then
            echo "   ✅ Retrieved password from Azure Key Vault"
            DB_PASSWORD="$PROD_PASSWORD"
        else
            echo "   ⚠️  Could not retrieve from Key Vault, using default"
            DB_PASSWORD="HomeworkHelper2024!"
        fi
        
        # Get database host from Azure
        DB_HOST=$(az postgres flexible-server show --name "homework-helper-db" --resource-group "homework-helper-rg-f" --query "fullyQualifiedDomainName" -o tsv 2>/dev/null || echo "homework-helper-db.postgres.database.azure.com")
        DB_USER="homeworkadmin"
        DB_NAME="homework_helper"
        
    else
        echo "   Using default database connection..."
        DB_HOST="homework-helper-db.postgres.database.azure.com"
        DB_USER="homeworkadmin"
        DB_PASSWORD="HomeworkHelper2024!"
        DB_NAME="homework_helper"
    fi
    
    # Construct connection string
    DATABASE_URL="postgresql://$DB_USER:$DB_PASSWORD@$DB_HOST:5432/$DB_NAME"
    
    echo "   Database Host: $DB_HOST"
    echo "   Database User: $DB_USER"
    echo "   Database Name: $DB_NAME"
    echo ""
}

# Function to create the password reset script
create_reset_script() {
    local new_password="$1"
    local new_email="$2"
    
    cat > reset_admin_temp.js << EOF
const crypto = require('crypto');
const { Pool } = require('pg');

// Database connection
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: { rejectUnauthorized: false }
});

// Hash password with SHA256 (matches your auth system)
function hashPassword(password) {
  return crypto.createHash('sha256').update(password).digest('hex');
}

async function resetAdminPassword() {
  try {
    console.log('🔐 RESETTING ADMIN PASSWORD');
    console.log('==========================');
    console.log('');
    
    const username = 'admin';
    const newEmail = '$new_email';
    const newPassword = '$new_password';
    
    console.log('📋 New Admin Details:');
    console.log('   Username: admin');
    console.log('   Email: ' + newEmail);
    console.log('   Password: [HIDDEN]');
    console.log('');
    
    // Hash the new password
    console.log('⏳ Hashing new password...');
    const passwordHash = hashPassword(newPassword);
    console.log('   Hash generated: ' + passwordHash.substring(0, 20) + '...');
    console.log('');
    
    // Check if admin exists
    console.log('🔍 Checking for existing admin user...');
    const checkResult = await pool.query(
      'SELECT id, username, email, role FROM admin_users WHERE username = \$1',
      [username]
    );
    
    if (checkResult.rows.length > 0) {
      console.log('✅ Found existing admin user, updating...');
      
      // Update existing admin
      const updateResult = await pool.query(
        \`UPDATE admin_users 
         SET email = \$1, password_hash = \$2, updated_at = NOW()
         WHERE username = \$3 
         RETURNING id, username, email, role\`,
        [newEmail, passwordHash, username]
      );
      
      if (updateResult.rows.length > 0) {
        const admin = updateResult.rows[0];
        console.log('✅ Admin password updated successfully!');
        console.log('');
        console.log('📋 Updated Admin Details:');
        console.log('   Username: ' + admin.username);
        console.log('   Email: ' + admin.email);
        console.log('   Role: ' + admin.role);
      }
    } else {
      console.log('❌ Admin user not found, creating new one...');
      
      // Create new admin
      const createResult = await pool.query(
        \`INSERT INTO admin_users (username, email, password_hash, role, is_active, created_at)
         VALUES (\$1, \$2, \$3, 'super_admin', true, NOW())
         RETURNING id, username, email, role\`,
        [username, newEmail, passwordHash]
      );
      
      if (createResult.rows.length > 0) {
        const newAdmin = createResult.rows[0];
        console.log('✅ New admin user created successfully!');
        console.log('');
        console.log('📋 New Admin Details:');
        console.log('   Username: ' + newAdmin.username);
        console.log('   Email: ' + newAdmin.email);
        console.log('   Role: ' + newAdmin.role);
      }
    }
    
    // Verify the reset
    console.log('🔍 Verifying password reset...');
    const verifyResult = await pool.query(
      'SELECT username, email, role, password_hash FROM admin_users WHERE username = \$1',
      [username]
    );
    
    if (verifyResult.rows.length > 0) {
      const verified = verifyResult.rows[0];
      console.log('✅ Verification successful!');
      console.log('   Username: ' + verified.username);
      console.log('   Email: ' + verified.email);
      console.log('   Role: ' + verified.role);
      console.log('   Password Hash Length: ' + verified.password_hash.length);
      console.log('');
      console.log('🎉 ADMIN PASSWORD RESET COMPLETE!');
      console.log('');
      console.log('🔑 Login Credentials:');
      console.log('   Username: admin');
      console.log('   Password: $new_password');
      console.log('');
      console.log('🌐 Admin Portal URL:');
      console.log('   https://homework-helper-api.azurewebsites.net/admin/');
      console.log('');
      console.log('⚠️  Save these credentials securely!');
    }
    
  } catch (error) {
    console.error('❌ Error resetting admin password:', error.message);
    console.error('Full error:', error);
    process.exit(1);
  } finally {
    await pool.end();
  }
}

// Run the reset
resetAdminPassword();
EOF
}

# Function to run the reset
run_password_reset() {
    local new_password="$1"
    local new_email="$2"
    
    echo "🚀 Running password reset..."
    echo ""
    
    # Set database URL
    export DATABASE_URL="$DATABASE_URL"
    
    # Create the reset script
    create_reset_script "$new_password" "$new_email"
    
    # Check if Node.js is available
    if command -v node &> /dev/null; then
        echo "   Using Node.js to reset password..."
        node reset_admin_temp.js
    elif command -v psql &> /dev/null; then
        echo "   Using psql to reset password..."
        # Generate SHA256 hash using openssl
        PASSWORD_HASH=$(echo -n "$new_password" | openssl dgst -sha256 -hex | cut -d' ' -f2)
        
        # Update using psql
        psql "$DATABASE_URL" -c "
        UPDATE admin_users 
        SET email = '$new_email', password_hash = '$PASSWORD_HASH', updated_at = NOW()
        WHERE username = 'admin';
        
        -- If no rows updated, create new admin
        INSERT INTO admin_users (username, email, password_hash, role, is_active, created_at)
        SELECT 'admin', '$new_email', '$PASSWORD_HASH', 'super_admin', true, NOW()
        WHERE NOT EXISTS (SELECT 1 FROM admin_users WHERE username = 'admin');
        
        SELECT username, email, role FROM admin_users WHERE username = 'admin';
        "
    else
        echo "❌ Neither Node.js nor psql found. Cannot reset password."
        echo "   Please install Node.js or PostgreSQL client tools."
        exit 1
    fi
    
    # Clean up
    rm -f reset_admin_temp.js
    
    echo ""
    echo "🎉 Password reset completed!"
}

# Main script
main() {
    echo "This script will reset the admin portal password."
    echo ""
    
    # Get database connection
    get_database_connection
    
    # Get new credentials from user
    echo "📝 Enter new admin credentials:"
    echo ""
    
    read -p "New admin email (default: support_homework@arshia.com): " NEW_EMAIL
    NEW_EMAIL=${NEW_EMAIL:-support_homework@arshia.com}
    
    read -s -p "New admin password: " NEW_PASSWORD
    echo ""
    
    if [ -z "$NEW_PASSWORD" ]; then
        echo "❌ Password cannot be empty!"
        exit 1
    fi
    
    echo ""
    echo "📋 Summary:"
    echo "   Email: $NEW_EMAIL"
    echo "   Password: [HIDDEN]"
    echo "   Database: $DB_HOST"
    echo ""
    
    read -p "Continue with password reset? (y/N): " CONFIRM
    if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
        echo "❌ Password reset cancelled."
        exit 0
    fi
    
    echo ""
    
    # Run the password reset
    run_password_reset "$NEW_PASSWORD" "$NEW_EMAIL"
}

# Check if running in Azure App Service SSH
if [ -n "$WEBSITE_INSTANCE_ID" ]; then
    echo "🌐 Running in Azure App Service SSH"
    echo "   Make sure you're in the correct directory with package.json"
    echo ""
fi

# Run main function
main
