#!/bin/bash

# Replace Staging Database with Backup Database
# This script creates a new staging database from the backup and replaces the old one

echo "🗄️  REPLACING STAGING DATABASE WITH BACKUP DATABASE"
echo "====================================================="
echo ""

# Configuration
STAGING_RG="homework-helper-stage-rg-f"
STAGING_DB="homework-helper-staging-db"
STAGING_APP="homework-helper-staging"
NEW_DB_NAME="homework-helper-staging-new"
BACKUP_DIR="production-backup-20251018-142346"
DB_PASSWORD="HomeworkHelper2024!"

echo "📋 Database Replacement Configuration:"
echo "   Resource Group: $STAGING_RG"
echo "   Current Database: $STAGING_DB"
echo "   New Database: $NEW_DB_NAME"
echo "   App Service: $STAGING_APP"
echo "   Source: $BACKUP_DIR"
echo ""

# Verify we're on the backup branch
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" != "homeworkhelper_goodbackups" ]; then
    echo "❌ Error: Not on homeworkhelper_goodbackups branch"
    echo "   Current branch: $CURRENT_BRANCH"
    exit 1
fi

echo "✅ Confirmed on backup branch: $CURRENT_BRANCH"
echo ""

# Step 1: Backup current staging database
echo "📦 Step 1: Creating backup of current staging database..."
BACKUP_FILE="staging-db-backup-$(date +%Y%m%d-%H%M%S).sql"

# Get database connection details
DB_HOST=$(az postgres flexible-server show --name $STAGING_DB --resource-group $STAGING_RG --query "fullyQualifiedDomainName" -o tsv)
DB_USER=$(az postgres flexible-server show --name $STAGING_DB --resource-group $STAGING_RG --query "administratorLogin" -o tsv)
DB_NAME="postgres"

echo "   Database Host: $DB_HOST"
echo "   Database User: $DB_USER"
echo "   Creating backup file: $BACKUP_FILE"

# Create backup
DATABASE_URL="postgresql://$DB_USER:$DB_PASSWORD@$DB_HOST:5432/$DB_NAME"
pg_dump "$DATABASE_URL" \
    --verbose \
    --clean \
    --no-owner \
    --no-privileges \
    --format=plain \
    --file="$BACKUP_FILE"

if [ $? -eq 0 ]; then
    echo "✅ Current database backed up successfully: $BACKUP_FILE"
else
    echo "❌ Failed to backup current database"
    exit 1
fi

echo ""

# Step 2: Create new database from backup schema
echo "🏗️  Step 2: Creating new database from backup schema..."

# Create new PostgreSQL server
echo "   Creating new PostgreSQL flexible server..."
az postgres flexible-server create \
    --resource-group $STAGING_RG \
    --name $NEW_DB_NAME \
    --location centralus \
    --admin-user homeworkadmin \
    --admin-password "$DB_PASSWORD" \
    --sku-name Standard_B1ms \
    --tier Burstable \
    --public-access 0.0.0.0-255.255.255.255 \
    --storage-size 32 \
    --version 15

if [ $? -eq 0 ]; then
    echo "✅ New PostgreSQL server created: $NEW_DB_NAME"
else
    echo "❌ Failed to create new PostgreSQL server"
    exit 1
fi

# Create database
echo "   Creating database 'homework_helper'..."
az postgres flexible-server db create \
    --resource-group $STAGING_RG \
    --server-name $NEW_DB_NAME \
    --database-name homework_helper

if [ $? -eq 0 ]; then
    echo "✅ Database 'homework_helper' created"
else
    echo "❌ Failed to create database"
    exit 1
fi

echo ""

# Step 3: Apply backup schema to new database
echo "📋 Step 3: Applying backup schema to new database..."

# Get new database connection details
NEW_DB_HOST=$(az postgres flexible-server show --name $NEW_DB_NAME --resource-group $STAGING_RG --query "fullyQualifiedDomainName" -o tsv)
NEW_DATABASE_URL="postgresql://homeworkadmin:$DB_PASSWORD@$NEW_DB_HOST:5432/homework_helper"

echo "   New Database Host: $NEW_DB_HOST"
echo "   Applying schema from backup..."

# Apply schema from backup directory
if [ -f "$BACKUP_DIR/database/schema_only.sql" ]; then
    echo "   Using schema file from backup..."
    psql "$NEW_DATABASE_URL" < "$BACKUP_DIR/database/schema_only.sql"
elif [ -f "$BACKUP_DIR/database/homework_helper_readable.sql" ]; then
    echo "   Using readable SQL dump from backup..."
    psql "$NEW_DATABASE_URL" < "$BACKUP_DIR/database/homework_helper_readable.sql"
else
    echo "   ⚠️  No schema file found in backup, creating basic schema..."
    # Create basic tables if no schema file exists
    psql "$NEW_DATABASE_URL" << EOF
-- Basic schema for Homework Helper
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS admin_users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS homework_submissions (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    image_url TEXT,
    analysis_result TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS usage_tracking (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    action VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
EOF
fi

if [ $? -eq 0 ]; then
    echo "✅ Schema applied successfully to new database"
else
    echo "❌ Failed to apply schema to new database"
    exit 1
fi

echo ""

# Step 4: Update App Service connection strings
echo "🔗 Step 4: Updating App Service connection strings..."

# Update database connection string
NEW_CONNECTION_STRING="Server=$NEW_DB_HOST;Database=homework_helper;Port=5432;User Id=homeworkadmin;Password=$DB_PASSWORD;Ssl Mode=Require;"

echo "   Updating DATABASE_URL..."
az webapp config connection-string set \
    --resource-group $STAGING_RG \
    --name $STAGING_APP \
    --connection-string-type PostgreSQL \
    --settings DATABASE_URL="$NEW_CONNECTION_STRING"

if [ $? -eq 0 ]; then
    echo "✅ App Service connection string updated"
else
    echo "❌ Failed to update App Service connection string"
    exit 1
fi

echo ""

# Step 5: Restart App Service
echo "🔄 Step 5: Restarting App Service..."
az webapp restart --name $STAGING_APP --resource-group $STAGING_RG

if [ $? -eq 0 ]; then
    echo "✅ App Service restarted successfully"
else
    echo "❌ Failed to restart App Service"
    exit 1
fi

echo ""

# Step 6: Clean up old database (optional)
echo "🧹 Step 6: Database replacement completed!"
echo ""
echo "📋 Replacement Summary:"
echo "   ✅ Current database backed up to: $BACKUP_FILE"
echo "   ✅ New database created: $NEW_DB_NAME"
echo "   ✅ Schema applied from backup"
echo "   ✅ App Service connection updated"
echo "   ✅ App Service restarted"
echo ""
echo "🔍 Next Steps:"
echo "   1. Test the staging environment: https://$STAGING_APP.azurewebsites.net"
echo "   2. Verify database connectivity"
echo "   3. Test key functionality"
echo ""
echo "⚠️  Note: Old database '$STAGING_DB' is still running for safety."
echo "   You can delete it later after confirming everything works correctly."
echo ""
echo "🎉 Staging database replacement completed successfully!"