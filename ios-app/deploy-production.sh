#!/bin/bash

# ========================================
# Deploy to Azure Production Environment
# ========================================

set -e

echo "🚀 Deploying Homework Helper Backend to Production..."
echo ""

# Pre-deployment validation
echo "Running pre-deployment checks..."
./pre-deploy-check.sh production

if [ $? -ne 0 ]; then
    echo "❌ Pre-deployment checks failed! Aborting deployment."
    exit 1
fi

echo ""

# Configuration
RESOURCE_GROUP="homework-helper-rg"
APP_NAME="homework-helper-api"

# Navigate to backend
cd backend

# Install production dependencies only
echo "📦 Installing dependencies..."
npm ci --production

# Create deployment package (exclude dev files)
echo "📦 Creating deployment package..."
zip -r ../production-deploy.zip . \
  -x "node_modules/*" \
  -x ".git/*" \
  -x ".env*" \
  -x "*.log" \
  -x "*.zip" \
  -x "tests/*" \
  -x "*.md"

cd ..

# Deploy to Azure
echo "☁️ Deploying to Azure App Service: $APP_NAME..."
az webapp deployment source config-zip \
  --resource-group $RESOURCE_GROUP \
  --name $APP_NAME \
  --src production-deploy.zip

# Clean up
rm production-deploy.zip

echo ""
echo "✅ Deployment complete!"
echo ""
echo "🔗 Your production backend is at:"
echo "   https://$APP_NAME.azurewebsites.net"
echo ""
echo "🧪 Test it:"
echo "   curl https://$APP_NAME.azurewebsites.net/health"
echo ""
