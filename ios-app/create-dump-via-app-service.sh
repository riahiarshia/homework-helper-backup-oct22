#!/bin/bash

# Create Production Database Dump via App Service
# This script uses the production App Service to create a database dump

echo "📦 CREATING PRODUCTION DUMP VIA APP SERVICE"
echo "============================================"
echo ""

# Configuration
PROD_RG="homework-helper-rg-f"
PROD_APP="homework-helper-api"
STAGING_RG="homework-helper-stage-rg-f"
STAGING_DB="homework-helper-staging-fresh"
STAGING_PASSWORD="HomeworkHelper2024!"

echo "📋 Configuration:"
echo "   Production App: $PROD_APP"
echo "   Production RG: $PROD_RG"
echo "   Staging Database: $STAGING_DB"
echo ""

# Step 1: Create a simple Node.js script to dump the database
echo "📝 Step 1: Creating database dump script..."

cat > dump-script.js << 'EOF'
const { exec } = require('child_process');
const fs = require('fs');

// Get database connection details from environment
const dbHost = process.env.DATABASE_URL.split('@')[1].split(':')[0];
const dbPort = process.env.DATABASE_URL.split(':')[3].split('/')[0];
const dbName = process.env.DATABASE_URL.split('/')[3];
const dbUser = process.env.DATABASE_URL.split('//')[1].split(':')[0];
const dbPassword = process.env.DATABASE_URL.split(':')[2].split('@')[0];

console.log('Database connection details:');
console.log('Host:', dbHost);
console.log('Port:', dbPort);
console.log('Database:', dbName);
console.log('User:', dbUser);
console.log('Password:', dbPassword ? '***' : 'NOT SET');

// Create pg_dump command
const dumpCommand = `pg_dump postgresql://${dbUser}:${dbPassword}@${dbHost}:${dbPort}/${dbName}?sslmode=require --clean --no-owner --no-privileges --format=plain`;

console.log('Executing pg_dump...');
exec(dumpCommand, (error, stdout, stderr) => {
    if (error) {
        console.error('Error:', error);
        return;
    }
    
    if (stderr) {
        console.error('Stderr:', stderr);
    }
    
    console.log('Dump completed successfully');
    console.log('Output length:', stdout.length);
    
    // Write to file
    fs.writeFileSync('/tmp/production-dump.sql', stdout);
    console.log('Dump saved to /tmp/production-dump.sql');
});
EOF

echo "✅ Database dump script created"
echo ""

# Step 2: Deploy the script to production App Service
echo "🚀 Step 2: Deploying script to production App Service..."

# Create a temporary zip with just the dump script
zip temp-dump.zip dump-script.js package.json

# Deploy to production App Service
az webapp deployment source config-zip \
    --resource-group $PROD_RG \
    --name $PROD_APP \
    --src temp-dump.zip

if [ $? -eq 0 ]; then
    echo "✅ Script deployed to production App Service"
else
    echo "❌ Failed to deploy script to production App Service"
    exit 1
fi

echo ""

# Step 3: Execute the script via App Service
echo "⚡ Step 3: Executing dump script..."

# Execute the script via App Service console
az webapp ssh --name $PROD_APP --resource-group $PROD_RG --command "node dump-script.js"

echo ""

# Step 4: Download the dump file
echo "📥 Step 4: Downloading dump file..."

# Download the dump file from the App Service
az webapp ssh --name $PROD_APP --resource-group $PROD_RG --command "cat /tmp/production-dump.sql" > production-dump-$(date +%Y%m%d-%H%M%S).sql

if [ $? -eq 0 ]; then
    echo "✅ Production dump downloaded successfully"
    DUMP_FILE="production-dump-$(date +%Y%m%d-%H%M%S).sql"
    echo "   Dump file: $DUMP_FILE"
    echo "   Size: $(ls -lh $DUMP_FILE | awk '{print $5}')"
else
    echo "❌ Failed to download production dump"
    exit 1
fi

echo ""

# Step 5: Import data to staging database
echo "📥 Step 5: Importing data to staging database..."

STAGING_HOST=$(az postgres flexible-server show --name $STAGING_DB --resource-group $STAGING_RG --query "fullyQualifiedDomainName" -o tsv)
STAGING_DATABASE_URL="postgresql://homeworkadmin:$STAGING_PASSWORD@$STAGING_HOST:5432/homework_helper"

psql "$STAGING_DATABASE_URL" < "$DUMP_FILE"

if [ $? -eq 0 ]; then
    echo "✅ Production data imported successfully to staging database"
else
    echo "❌ Failed to import production data to staging database"
    exit 1
fi

echo ""

# Step 6: Verify data import
echo "🔍 Step 6: Verifying data import..."
psql "$STAGING_DATABASE_URL" -c "SELECT tablename, n_tup_ins as row_count FROM pg_stat_user_tables WHERE schemaname = 'public' ORDER BY n_tup_ins DESC;"

echo ""

# Step 7: Restart staging App Service
echo "🔄 Step 7: Restarting staging App Service..."
az webapp restart --name homework-helper-staging --resource-group $STAGING_RG

echo ""

# Cleanup
rm -f dump-script.js temp-dump.zip

echo "🎉 PRODUCTION DATA IMPORT COMPLETED!"
echo "===================================="
echo ""
echo "📋 Summary:"
echo "   ✅ Production database dumped via App Service"
echo "   ✅ Data imported to staging: $STAGING_DB"
echo "   ✅ Staging App Service restarted"
echo ""
echo "🔍 Next Steps:"
echo "   1. Test the staging environment: https://homework-helper-staging.azurewebsites.net"
echo "   2. Verify all functionality with real data"
echo ""
echo "🎉 Production data successfully imported to staging!"
