#!/bin/bash

# Create Fresh Staging Database from Backup
# This script creates a completely new staging database from the backup

echo "🏗️  CREATING FRESH STAGING DATABASE FROM BACKUP"
echo "================================================="
echo ""

# Configuration
STAGING_RG="homework-helper-stage-rg-f"
STAGING_APP="homework-helper-staging"
NEW_DB_NAME="homework-helper-staging-fresh"
BACKUP_DIR="production-backup-20251018-142346"
DB_PASSWORD="HomeworkHelper2024!"

echo "📋 Fresh Database Configuration:"
echo "   Resource Group: $STAGING_RG"
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

# Step 1: Create new PostgreSQL server
echo "🏗️  Step 1: Creating new PostgreSQL flexible server..."
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

# Step 2: Create database
echo "📋 Step 2: Creating database 'homework_helper'..."
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

# Create comprehensive schema for Homework Helper
psql "$NEW_DATABASE_URL" << EOF
-- Homework Helper Database Schema from Backup
-- Create all necessary tables and relationships

-- Users table
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255),
    apple_user_id VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT true,
    subscription_status VARCHAR(50) DEFAULT 'trial',
    subscription_expires_at TIMESTAMP
);

-- Admin users table
CREATE TABLE IF NOT EXISTS admin_users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP,
    is_active BOOLEAN DEFAULT true
);

-- Homework submissions table
CREATE TABLE IF NOT EXISTS homework_submissions (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    image_url TEXT,
    analysis_result TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Usage tracking table
CREATE TABLE IF NOT EXISTS usage_tracking (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    action VARCHAR(100),
    details JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Monthly usage tracking
CREATE TABLE IF NOT EXISTS monthly_usage (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    month INTEGER NOT NULL,
    year INTEGER NOT NULL,
    usage_count INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, month, year)
);

-- Device tracking table
CREATE TABLE IF NOT EXISTS device_tracking (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    device_id VARCHAR(255),
    device_info JSONB,
    last_seen TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Entitlements ledger table
CREATE TABLE IF NOT EXISTS entitlements_ledger (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    action VARCHAR(100),
    amount INTEGER,
    balance INTEGER,
    details JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Subscription data table
CREATE TABLE IF NOT EXISTS subscription_data (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    subscription_id VARCHAR(255),
    status VARCHAR(50),
    plan VARCHAR(100),
    expires_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_apple_id ON users(apple_user_id);
CREATE INDEX IF NOT EXISTS idx_homework_user_id ON homework_submissions(user_id);
CREATE INDEX IF NOT EXISTS idx_usage_user_id ON usage_tracking(user_id);
CREATE INDEX IF NOT EXISTS idx_monthly_usage_user_id ON monthly_usage(user_id);
CREATE INDEX IF NOT EXISTS idx_device_tracking_user_id ON device_tracking(user_id);
CREATE INDEX IF NOT EXISTS idx_entitlements_user_id ON entitlements_ledger(user_id);
CREATE INDEX IF NOT EXISTS idx_subscription_user_id ON subscription_data(user_id);

-- Insert default admin user (password: admin123)
INSERT INTO admin_users (email, password_hash) 
VALUES ('admin@homeworkhelper.com', '\$2b\$10\$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi')
ON CONFLICT (email) DO NOTHING;

EOF

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

echo "🎉 Fresh staging database creation completed!"
echo ""
echo "📋 Summary:"
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
echo "📊 Database Details:"
echo "   Host: $NEW_DB_HOST"
echo "   Database: homework_helper"
echo "   User: homeworkadmin"
echo "   Password: $DB_PASSWORD"
echo ""
echo "🎉 Fresh staging database created successfully!"
