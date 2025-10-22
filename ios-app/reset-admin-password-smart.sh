#!/bin/bash

# Smart Admin Password Reset Script
# Asks which database to connect to and handles multiple environments

set -e

echo "🔐 Smart Admin Password Reset Tool"
echo "=================================="
echo ""

# Function to detect available databases
detect_databases() {
    echo "🔍 Detecting available databases..."
    echo ""
    
    AVAILABLE_DBS=()
    
    # Check if Azure CLI is available
    if command -v az &> /dev/null && az account show &> /dev/null; then
        echo "   ✅ Azure CLI detected"
        
        # Try to get production database
        PROD_HOST=$(az postgres flexible-server show --name "homework-helper-db" --resource-group "homework-helper-rg-f" --query "fullyQualifiedDomainName" -o tsv 2>/dev/null || echo "")
        if [ -n "$PROD_HOST" ]; then
            AVAILABLE_DBS+=("production:$PROD_HOST")
            echo "   ✅ Production database found: $PROD_HOST"
        fi
        
        # Try to get staging database
        STAGING_HOST=$(az postgres flexible-server show --name "homework-helper-staging-f" --resource-group "homework-helper-rg-f" --query "fullyQualifiedDomainName" -o tsv 2>/dev/null || echo "")
        if [ -n "$STAGING_HOST" ]; then
            AVAILABLE_DBS+=("staging:$STAGING_HOST")
            echo "   ✅ Staging database found: $STAGING_HOST"
        fi
    fi
    
    # Add manual options
    AVAILABLE_DBS+=("manual:Enter custom connection")
    AVAILABLE_DBS+=("environment:Use DATABASE_URL environment variable")
    
    echo ""
}

# Function to get database connection details
get_database_connection() {
    echo "📋 Available database options:"
    echo ""
    
    for i in "${!AVAILABLE_DBS[@]}"; do
        IFS=':' read -r name host <<< "${AVAILABLE_DBS[$i]}"
        echo "   $((i+1)). $name"
        if [ "$name" != "manual" ] && [ "$name" != "environment" ]; then
            echo "      Host: $host"
        fi
    done
    echo ""
    
    # Get user choice
    read -p "Select database (1-${#AVAILABLE_DBS[@]}): " DB_CHOICE
    
    if ! [[ "$DB_CHOICE" =~ ^[0-9]+$ ]] || [ "$DB_CHOICE" -lt 1 ] || [ "$DB_CHOICE" -gt "${#AVAILABLE_DBS[@]}" ]; then
        echo "❌ Invalid selection!"
        exit 1
    fi
    
    # Get selected database info
    SELECTED_DB="${AVAILABLE_DBS[$((DB_CHOICE-1))]}"
    IFS=':' read -r DB_TYPE DB_HOST <<< "$SELECTED_DB"
    
    echo ""
    echo "📋 Selected: $DB_TYPE"
    echo ""
    
    # Handle different database types
    case "$DB_TYPE" in
        "production")
            echo "🔍 Getting production database credentials..."
            
            # Try to get from Azure Key Vault
            if command -v az &> /dev/null; then
                PROD_PASSWORD=$(az keyvault secret show --vault-name "OpenAI-1" --name "Production-Database-Password" --query "value" -o tsv 2>/dev/null || echo "")
                if [ -n "$PROD_PASSWORD" ]; then
                    echo "   ✅ Retrieved password from Azure Key Vault"
                    DB_PASSWORD="$PROD_PASSWORD"
                else
                    echo "   ⚠️  Could not retrieve from Key Vault, using default"
                    DB_PASSWORD="HomeworkHelper2024!"
                fi
            else
                DB_PASSWORD="HomeworkHelper2024!"
            fi
            
            DB_USER="homeworkadmin"
            DB_NAME="homework_helper"
            ;;
            
        "staging")
            echo "🔍 Getting staging database credentials..."
            
            # Try to get from Azure Key Vault
            if command -v az &> /dev/null; then
                STAGING_PASSWORD=$(az keyvault secret show --vault-name "OpenAI-1" --name "Staging-Database-Password" --query "value" -o tsv 2>/dev/null || echo "")
                if [ -n "$STAGING_PASSWORD" ]; then
                    echo "   ✅ Retrieved password from Azure Key Vault"
                    DB_PASSWORD="$STAGING_PASSWORD"
                else
                    echo "   ⚠️  Could not retrieve from Key Vault, using default"
                    DB_PASSWORD="HomeworkHelper2024!"
                fi
            else
                DB_PASSWORD="HomeworkHelper2024!"
            fi
            
            DB_USER="homeworkadmin"
            DB_NAME="homework_helper"
            ;;
            
        "manual")
            echo "📝 Enter custom database connection details:"
            read -p "Database Host: " DB_HOST
            read -p "Database User (default: homeworkadmin): " DB_USER
            DB_USER=${DB_USER:-homeworkadmin}
            read -p "Database Name (default: homework_helper): " DB_NAME
            DB_NAME=${DB_NAME:-homework_helper}
            read -s -p "Database Password: " DB_PASSWORD
            echo ""
            ;;
            
        "environment")
            if [ -n "$DATABASE_URL" ]; then
                echo "   ✅ Using DATABASE_URL environment variable"
                echo "   Connection: ${DATABASE_URL:0:50}..."
                # Parse DATABASE_URL
                # This is a simplified parser - in production you'd want a more robust one
                if [[ $DATABASE_URL =~ postgresql://([^:]+):([^@]+)@([^:]+):([^/]+)/(.+) ]]; then
                    DB_USER="${BASH_REMATCH[1]}"
                    DB_PASSWORD="${BASH_REMATCH[2]}"
                    DB_HOST="${BASH_REMATCH[3]}"
                    DB_PORT="${BASH_REMATCH[4]}"
                    DB_NAME="${BASH_REMATCH[5]}"
                else
                    echo "❌ Invalid DATABASE_URL format!"
                    exit 1
                fi
            else
                echo "❌ DATABASE_URL environment variable not set!"
                exit 1
            fi
            ;;
    esac
    
    # Construct connection string
    if [ "$DB_TYPE" = "environment" ]; then
        DATABASE_URL="$DATABASE_URL"
    else
        DATABASE_URL="postgresql://$DB_USER:$DB_PASSWORD@$DB_HOST:5432/$DB_NAME"
    fi
    
    echo ""
    echo "📋 Database Connection Details:"
    echo "   Type: $DB_TYPE"
    echo "   Host: $DB_HOST"
    echo "   User: $DB_USER"
    echo "   Database: $DB_NAME"
    echo "   Connection String: ${DATABASE_URL:0:50}..."
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
    
    // Update or create admin user
    console.log('🔄 Updating admin user...');
    const result = await pool.query(\`
      INSERT INTO admin_users (username, email, password_hash, role, is_active, created_at)
      VALUES (\$1, \$2, \$3, 'super_admin', true, NOW())
      ON CONFLICT (username) DO UPDATE SET
        email = EXCLUDED.email,
        password_hash = EXCLUDED.password_hash,
        updated_at = NOW()
      RETURNING username, email, role
    \`, [username, newEmail, passwordHash]);
    
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
    echo "You can choose which database to connect to."
    echo ""
    
    # Detect available databases
    detect_databases
    
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
    echo "   Database: $DB_TYPE ($DB_HOST)"
    echo "   Email: $NEW_EMAIL"
    echo "   Password: [HIDDEN]"
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
