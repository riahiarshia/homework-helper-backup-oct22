#!/bin/bash

# Deploy Backup Branch to Staging Environment
# This script deploys the homeworkhelper_goodbackups branch to staging

echo "🚀 DEPLOYING BACKUP BRANCH TO STAGING ENVIRONMENT"
echo "=================================================="
echo ""

# Configuration
STAGING_RG="homework-helper-stage-rg-f"
STAGING_APP="homework-helper-staging"
STAGING_DB="homework-helper-staging-db"
BACKUP_DIR="production-backup-20251018-142346"

echo "📋 Deployment Configuration:"
echo "   Resource Group: $STAGING_RG"
echo "   App Service: $STAGING_APP"
echo "   Database: $STAGING_DB"
echo "   Source: $BACKUP_DIR"
echo ""

# Verify we're on the backup branch
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" != "homeworkhelper_goodbackups" ]; then
    echo "❌ Error: Not on homeworkhelper_goodbackups branch"
    echo "   Current branch: $CURRENT_BRANCH"
    echo "   Please checkout homeworkhelper_goodbackups branch first"
    exit 1
fi

echo "✅ Confirmed on backup branch: $CURRENT_BRANCH"
echo ""

# Verify backup directory exists
if [ ! -d "$BACKUP_DIR" ]; then
    echo "❌ Error: Backup directory not found: $BACKUP_DIR"
    exit 1
fi

echo "✅ Backup directory found: $BACKUP_DIR"
echo ""

# Verify staging resources exist
echo "🔍 Verifying staging resources..."
az group show --name $STAGING_RG --output none
if [ $? -ne 0 ]; then
    echo "❌ Error: Staging resource group not found: $STAGING_RG"
    exit 1
fi

az webapp show --name $STAGING_APP --resource-group $STAGING_RG --output none
if [ $? -ne 0 ]; then
    echo "❌ Error: Staging app service not found: $STAGING_APP"
    exit 1
fi

echo "✅ Staging resources verified"
echo ""

# Create deployment package from backup
echo "📦 Creating deployment package from backup..."
DEPLOY_DIR="staging-deploy-$(date +%Y%m%d-%H%M%S)"
mkdir -p $DEPLOY_DIR

# Copy backend files from backup
echo "   Copying backend services..."
cp -r $BACKUP_DIR/server.js $DEPLOY_DIR/
cp -r $BACKUP_DIR/package.json $DEPLOY_DIR/
cp -r $BACKUP_DIR/package-lock.json $DEPLOY_DIR/
cp -r $BACKUP_DIR/routes/ $DEPLOY_DIR/
cp -r $BACKUP_DIR/middleware/ $DEPLOY_DIR/
cp -r $BACKUP_DIR/migrations/ $DEPLOY_DIR/
cp -r $BACKUP_DIR/config.js $DEPLOY_DIR/
cp -r $BACKUP_DIR/public/ $DEPLOY_DIR/

# Create staging-specific environment file
echo "   Creating staging environment configuration..."
cat > $DEPLOY_DIR/.env << EOF
# Staging Environment Configuration
NODE_ENV=staging
PORT=8080

# Database Configuration (will be set via App Service settings)
DATABASE_URL=\${DATABASE_URL}

# Azure Key Vault Configuration
AZURE_KEY_VAULT_NAME=OpenAI-1
AZURE_TENANT_ID=c3b32785-891b-4be9-90c2-c6d313ab4895
AZURE_CLIENT_ID=25c1dc23-3925-49f1-94d3-4e702da5fa9b
AZURE_CLIENT_SECRET=\${AZURE_CLIENT_SECRET}
OPENAI_SECRET_NAME=OpenAi

# API Configuration
API_KEY_HEADER=X-API-Key
RATE_LIMIT_WINDOW_MS=900000
RATE_LIMIT_MAX_REQUESTS=100
EOF

echo "✅ Deployment package created: $DEPLOY_DIR"
echo ""

# Deploy to staging
echo "🚀 Deploying to staging..."
cd $DEPLOY_DIR

# Install dependencies
echo "   Installing dependencies..."
npm install --production

# Create deployment zip
echo "   Creating deployment package..."
zip -r ../staging-deployment.zip . -x "*.git*" "node_modules/.cache/*"

cd ..

# Deploy to Azure App Service
echo "   Deploying to Azure App Service..."
az webapp deployment source config-zip \
    --resource-group $STAGING_RG \
    --name $STAGING_APP \
    --src staging-deployment.zip

if [ $? -eq 0 ]; then
    echo "✅ Deployment successful!"
else
    echo "❌ Deployment failed!"
    exit 1
fi

# Clean up deployment files
echo "🧹 Cleaning up deployment files..."
rm -rf $DEPLOY_DIR
rm -f staging-deployment.zip

echo ""
echo "🎉 STAGING DEPLOYMENT COMPLETED!"
echo "================================="
echo ""
echo "📋 Deployment Summary:"
echo "   App Service: $STAGING_APP"
echo "   URL: https://$STAGING_APP.azurewebsites.net"
echo "   Resource Group: $STAGING_RG"
echo ""
echo "🔍 Next Steps:"
echo "   1. Verify the deployment at: https://$STAGING_APP.azurewebsites.net"
echo "   2. Check application logs if needed"
echo "   3. Test key functionality"
echo ""
echo "✅ Backup branch successfully deployed to staging!"
