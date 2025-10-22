#!/bin/bash

# Simple Admin Password Reset
# Just asks for database name and new password

set -e

echo "🔐 Simple Admin Password Reset"
echo "============================="
echo ""

# Get database name from user
echo "📋 Available databases:"
echo "   1. homework-helper-db (Production)"
echo "   2. homework-helper-staging-f (Staging)"
echo "   3. Enter custom database name"
echo ""

read -p "Select database (1-3): " DB_CHOICE

case "$DB_CHOICE" in
    1)
        DB_NAME="homework-helper-db"
        RESOURCE_GROUP="homework-helper-rg-f"
        ;;
    2)
        DB_NAME="homework-helper-staging-f"
        RESOURCE_GROUP="homework-helper-rg-f"
        ;;
    3)
        read -p "Enter database name: " DB_NAME
        read -p "Enter resource group (default: homework-helper-rg-f): " RESOURCE_GROUP
        RESOURCE_GROUP=${RESOURCE_GROUP:-homework-helper-rg-f}
        ;;
    *)
        echo "❌ Invalid selection!"
        exit 1
        ;;
esac

echo ""
echo "📋 Selected database: $DB_NAME"
echo "   Resource group: $RESOURCE_GROUP"
echo ""

# Get new password
read -s -p "Enter new admin password: " NEW_PASSWORD
echo ""

if [ -z "$NEW_PASSWORD" ]; then
    echo "❌ Password cannot be empty!"
    exit 1
fi

read -p "Enter new admin email (default: support_homework@arshia.com): " NEW_EMAIL
NEW_EMAIL=${NEW_EMAIL:-support_homework@arshia.com}

echo ""
echo "📋 Summary:"
echo "   Database: $DB_NAME"
echo "   Email: $NEW_EMAIL"
echo "   Password: [HIDDEN]"
echo ""

read -p "Continue with password reset? (y/N): " CONFIRM
if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
    echo "❌ Password reset cancelled."
    exit 0
fi

echo ""
echo "🚀 Resetting admin password..."

# Get database connection details from Azure
echo "🔍 Getting database connection details..."
DB_HOST=$(az postgres flexible-server show --name "$DB_NAME" --resource-group "$RESOURCE_GROUP" --query "fullyQualifiedDomainName" -o tsv)
DB_USER=$(az postgres flexible-server show --name "$DB_NAME" --resource-group "$RESOURCE_GROUP" --query "administratorLogin" -o tsv)

echo "   Host: $DB_HOST"
echo "   User: $DB_USER"
echo ""

# Get database password
read -s -p "Enter database password: " DB_PASSWORD
echo ""

# Generate SHA256 hash of new password
echo "⏳ Generating password hash..."
PASSWORD_HASH=$(echo -n "$NEW_PASSWORD" | openssl dgst -sha256 -hex | cut -d' ' -f2)

echo "   Hash: ${PASSWORD_HASH:0:20}..."
echo ""

# Create connection string
DATABASE_URL="postgresql://$DB_USER:$DB_PASSWORD@$DB_HOST:5432/homework_helper"

# Reset the password using psql
echo "🔄 Resetting password in database..."

psql "$DATABASE_URL" -c "
UPDATE admin_users 
SET email = '$NEW_EMAIL', password_hash = '$PASSWORD_HASH', updated_at = NOW()
WHERE username = 'admin';

-- If no rows updated, create new admin
INSERT INTO admin_users (username, email, password_hash, role, is_active, created_at)
SELECT 'admin', '$NEW_EMAIL', '$PASSWORD_HASH', 'super_admin', true, NOW()
WHERE NOT EXISTS (SELECT 1 FROM admin_users WHERE username = 'admin');

-- Show the result
SELECT username, email, role FROM admin_users WHERE username = 'admin';
"

echo ""
echo "✅ Admin password reset completed!"
echo ""
echo "🔑 New Login Credentials:"
echo "   Username: admin"
echo "   Password: $NEW_PASSWORD"
echo "   Email: $NEW_EMAIL"
echo ""
echo "🌐 Admin Portal URL:"
echo "   https://homework-helper-api.azurewebsites.net/admin/"
echo ""
echo "⚠️  Save these credentials securely!"
