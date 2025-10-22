#!/bin/bash

# Reset Admin Password - Simple Bash Script
echo "Admin Password Reset Tool"
echo "========================="
echo ""

# Ask for database name
echo "Select database:"
echo "1) homework-helper-db (Production)"
echo "2) homework-helper-staging-f (Staging)"
echo "3) Custom database name"
echo ""
read -p "Choose (1-3): " choice

case $choice in
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
        read -p "Enter resource group: " RESOURCE_GROUP
        ;;
    *)
        echo "Invalid choice!"
        exit 1
        ;;
esac

echo ""
echo "Database: $DB_NAME"
echo "Resource Group: $RESOURCE_GROUP"
echo ""

# Ask for new password
read -p "Enter new admin password: " NEW_PASSWORD
if [ -z "$NEW_PASSWORD" ]; then
    echo "Password cannot be empty!"
    exit 1
fi

# Ask for email
read -p "Enter admin email (default: support_homework@arshia.com): " NEW_EMAIL
NEW_EMAIL=${NEW_EMAIL:-support_homework@arshia.com}

echo ""
echo "Summary:"
echo "Database: $DB_NAME"
echo "Email: $NEW_EMAIL"
echo "Password: [HIDDEN]"
echo ""

read -p "Continue? (y/N): " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "Cancelled."
    exit 0
fi

echo ""
echo "Getting database connection..."

# Get database details from Azure
DB_HOST=$(az postgres flexible-server show --name "$DB_NAME" --resource-group "$RESOURCE_GROUP" --query "fullyQualifiedDomainName" -o tsv)
DB_USER=$(az postgres flexible-server show --name "$DB_NAME" --resource-group "$RESOURCE_GROUP" --query "administratorLogin" -o tsv)

echo "Host: $DB_HOST"
echo "User: $DB_USER"
echo ""

# Get database password
read -s -p "Enter database password: " DB_PASSWORD
echo ""

# Generate password hash
echo "Generating password hash..."
PASSWORD_HASH=$(echo -n "$NEW_PASSWORD" | openssl dgst -sha256 -hex | cut -d' ' -f2)

# Create connection string
CONNECTION_STRING="postgresql://$DB_USER:$DB_PASSWORD@$DB_HOST:5432/homework_helper"

echo "Resetting password..."

# Update admin password
psql "$CONNECTION_STRING" -c "
UPDATE admin_users 
SET email = '$NEW_EMAIL', password_hash = '$PASSWORD_HASH', updated_at = NOW()
WHERE username = 'admin';

INSERT INTO admin_users (username, email, password_hash, role, is_active, created_at)
SELECT 'admin', '$NEW_EMAIL', '$PASSWORD_HASH', 'super_admin', true, NOW()
WHERE NOT EXISTS (SELECT 1 FROM admin_users WHERE username = 'admin');

SELECT username, email, role FROM admin_users WHERE username = 'admin';
"

echo ""
echo "Password reset completed!"
echo ""
echo "New Login Credentials:"
echo "Username: admin"
echo "Password: $NEW_PASSWORD"
echo "Email: $NEW_EMAIL"
echo ""
echo "Admin Portal: https://homework-helper-api.azurewebsites.net/admin/"
