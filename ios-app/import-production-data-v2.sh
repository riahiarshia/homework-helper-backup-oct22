#!/bin/bash

# Import Production Data to Staging Database (Version 2)
# This script creates a dump from production using the connection string from Key Vault

echo "📥 IMPORTING PRODUCTION DATA TO STAGING (V2)"
echo "============================================="
echo ""

# Configuration
STAGING_RG="homework-helper-stage-rg-f"
STAGING_DB="homework-helper-staging-fresh"
STAGING_PASSWORD="HomeworkHelper2024!"

echo "📋 Import Configuration:"
echo "   Staging Database: $STAGING_DB"
echo "   Staging RG: $STAGING_RG"
echo ""

# Step 1: Get production connection string from Key Vault
echo "🔍 Step 1: Getting production connection string from Key Vault..."
PROD_CONNECTION_STRING=$(az keyvault secret show --vault-name OpenAI-1 --name Production-Database-ConnectionString --query 'value' -o tsv)

if [ -z "$PROD_CONNECTION_STRING" ]; then
    echo "❌ Failed to get production connection string from Key Vault"
    exit 1
fi

echo "   ✅ Production connection string retrieved"
echo ""

# Step 2: Create production database dump
echo "📦 Step 2: Creating production database dump..."
DUMP_FILE="production-dump-$(date +%Y%m%d-%H%M%S).sql"

echo "   Creating dump file: $DUMP_FILE"
echo "   This may take a few minutes..."

# Create dump from production using connection string
pg_dump "$PROD_CONNECTION_STRING" \
    --verbose \
    --clean \
    --no-owner \
    --no-privileges \
    --format=plain \
    --file="$DUMP_FILE"

if [ $? -eq 0 ]; then
    echo "✅ Production database dump created successfully: $DUMP_FILE"
    DUMP_SIZE=$(ls -lh "$DUMP_FILE" | awk '{print $5}')
    echo "   Dump file info:"
    echo "   - Size: $DUMP_SIZE"
    echo "   - Lines: $(wc -l < "$DUMP_FILE")"
else
    echo "❌ Failed to create production database dump"
    echo "   Trying alternative approach..."
    
    # Try with PostgreSQL URL format
    PROD_URL="postgresql://homeworkadmin:HomeworkHelper2024!@homework-helper-db.postgres.database.azure.com:5432/homework_helper?sslmode=require"
    
    echo "   Attempting with PostgreSQL URL format..."
    pg_dump "$PROD_URL" \
        --verbose \
        --clean \
        --no-owner \
        --no-privileges \
        --format=plain \
        --file="$DUMP_FILE"
    
    if [ $? -eq 0 ]; then
        echo "✅ Production database dump created successfully: $DUMP_FILE"
        DUMP_SIZE=$(ls -lh "$DUMP_FILE" | awk '{print $5}')
        echo "   Dump file info:"
        echo "   - Size: $DUMP_SIZE"
        echo "   - Lines: $(wc -l < "$DUMP_FILE")"
    else
        echo "❌ Failed to create production database dump with both methods"
        exit 1
    fi
fi

echo ""

# Step 3: Get staging database details
echo "🔍 Step 3: Getting staging database details..."
STAGING_HOST=$(az postgres flexible-server show --name $STAGING_DB --resource-group $STAGING_RG --query "fullyQualifiedDomainName" -o tsv)

echo "   Staging Host: $STAGING_HOST"
echo ""

# Step 4: Import data to staging database
echo "📥 Step 4: Importing production data to staging database..."
echo "   This may take a few minutes..."

STAGING_DATABASE_URL="postgresql://homeworkadmin:$STAGING_PASSWORD@$STAGING_HOST:5432/homework_helper"
psql "$STAGING_DATABASE_URL" < "$DUMP_FILE"

if [ $? -eq 0 ]; then
    echo "✅ Production data imported successfully to staging database"
else
    echo "❌ Failed to import production data to staging database"
    exit 1
fi

echo ""

# Step 5: Verify data import
echo "🔍 Step 5: Verifying data import..."
echo "   Checking table row counts..."

psql "$STAGING_DATABASE_URL" -c "
SELECT 
    schemaname,
    tablename,
    n_tup_ins as row_count
FROM pg_stat_user_tables 
WHERE schemaname = 'public'
ORDER BY n_tup_ins DESC;
"

echo ""

# Step 6: Restart App Service to ensure fresh connections
echo "🔄 Step 6: Restarting App Service..."
az webapp restart --name homework-helper-staging --resource-group $STAGING_RG

if [ $? -eq 0 ]; then
    echo "✅ App Service restarted successfully"
else
    echo "❌ Failed to restart App Service"
fi

echo ""

# Step 7: Clean up dump file (optional)
echo "🧹 Step 7: Cleaning up..."
echo "   Keeping dump file for reference: $DUMP_FILE"
echo "   (You can delete it later if not needed)"

echo ""

echo "🎉 PRODUCTION DATA IMPORT COMPLETED!"
echo "===================================="
echo ""
echo "📋 Summary:"
echo "   ✅ Production database dumped: $DUMP_FILE"
echo "   ✅ Data imported to staging: $STAGING_DB"
echo "   ✅ App Service restarted"
echo ""
echo "🔍 Next Steps:"
echo "   1. Test the staging environment: https://homework-helper-staging.azurewebsites.net"
echo "   2. Verify all functionality with real data"
echo "   3. Test admin portal and user features"
echo ""
echo "📊 Database Details:"
echo "   Staging Host: $STAGING_HOST"
echo "   Database: homework_helper"
echo "   User: homeworkadmin"
echo "   Password: $STAGING_PASSWORD"
echo ""
echo "🎉 Production data successfully imported to staging!"
