#!/bin/bash

# Reset Admin Password - Azure Environment
# No az login needed - runs directly in Azure CLI/SSH

set -e

echo "🔐 Admin Password Reset (Azure Environment)"
echo "==========================================="
echo ""

# Function to get database connection from Azure
get_azure_database() {
    echo "🔍 Getting database connection from Azure..."
    echo ""
    
    # Get production database details
    echo "📋 Available databases:"
    echo "   1. Production Database"
    echo "   2. Staging Database"
    echo "   3. Manual Entry"
    echo ""
    
    read -p "Select database (1-3): " DB_CHOICE
    
    case "$DB_CHOICE" in
        1)
            echo "   ✅ Selected: Production Database"
            DB_HOST=$(az postgres flexible-server show --name "homework-helper-db" --resource-group "homework-helper-rg-f" --query "fullyQualifiedDomainName" -o tsv)
            DB_USER="homeworkadmin"
            DB_NAME="homework_helper"
            
            # Get password from Azure Key Vault
            DB_PASSWORD=$(az keyvault secret show --vault-name "OpenAI-1" --name "Production-Database-Password" --query "value" -o tsv)
            ;;
        2)
            echo "   ✅ Selected: Staging Database"
            DB_HOST=$(az postgres flexible-server show --name "homework-helper-staging-f" --resource-group "homework-helper-rg-f" --query "fullyQualifiedDomainName" -o tsv)
            DB_USER="homeworkadmin"
            DB_NAME="homework_helper"
            
            # Get password from Azure Key Vault
            DB_PASSWORD=$(az keyvault secret show --vault-name "OpenAI-1" --name "Staging-Database-Password" --query "value" -o tsv)
            ;;
        3)
            echo "   ✅ Selected: Manual Entry"
            read -p "Database Host: " DB_HOST
            read -p "Database User (default: homeworkadmin): " DB_USER
            DB_USER=${DB_USER:-homeworkadmin}
            read -p "Database Name (default: homework_helper): " DB_NAME
            DB_NAME=${DB_NAME:-homework_helper}
            read -s -p "Database Password: " DB_PASSWORD
            echo ""
            ;;
        *)
            echo "❌ Invalid selection!"
            exit 1
            ;;
    esac
    
    # Construct connection string
    DATABASE_URL="postgresql://$DB_USER:$DB_PASSWORD@$DB_HOST:5432/$DB_NAME"
    
    echo ""
    echo "📋 Database Connection:"
    echo "   Host: $DB_HOST"
    echo "   User: $DB_USER"
    echo "   Database: $DB_NAME"
    echo "   Connection: ${DATABASE_URL:0:50}..."
    echo ""
}

# Function to create reset script
create_reset_script() {
    local new_password="$1"
    local new_email="$2"
    
    cat > reset_admin_azure.js << 'EOF'
const crypto = require('crypto');
const { Pool } = require('pg');

// Database connection
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: { rejectUnauthorized: false }
});

async function resetAdminPassword() {
  try {
    const username = 'admin';
    const newEmail = process.argv[2];
    const newPassword = process.argv[3];
    
    console.log('🔐 RESETTING ADMIN PASSWORD');
    console.log('==========================');
    console.log('');
    console.log('📋 New Admin Details:');
    console.log('   Username: admin');
    console.log('   Email: ' + newEmail);
    console.log('   Password: [HIDDEN]');
    console.log('');
    
    // Hash password with SHA256
    const passwordHash = crypto.createHash('sha256').update(newPassword).digest('hex');
    console.log('⏳ Password hashed with SHA256...');
    console.log('');
    
    // Update or create admin user
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
}

# Main function
main() {
    echo "This script resets the admin portal password."
    echo "No az login needed - you're already in Azure!"
    echo ""
    
    # Get database connection
    get_azure_database
    
    # Get new credentials
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
    echo "   Database: $DB_HOST"
    echo "   Email: $NEW_EMAIL"
    echo "   Password: [HIDDEN]"
    echo ""
    
    read -p "Continue with password reset? (y/N): " CONFIRM
    if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
        echo "❌ Password reset cancelled."
        exit 0
    fi
    
    echo ""
    echo "🚀 Running password reset..."
    
    # Set database URL and run reset
    export DATABASE_URL="$DATABASE_URL"
    create_reset_script "$NEW_PASSWORD" "$NEW_EMAIL"
    
    # Run the reset
    node reset_admin_azure.js "$NEW_EMAIL" "$NEW_PASSWORD"
    
    # Clean up
    rm -f reset_admin_azure.js
    
    echo ""
    echo "🎉 Password reset completed!"
}

# Run main function
main
