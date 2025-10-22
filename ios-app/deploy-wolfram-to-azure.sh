#!/bin/bash

# Wolfram|Alpha Deployment Script for Azure
echo "🚀 Deploying Wolfram|Alpha integration to Azure..."

# Check if Azure CLI is installed
if ! command -v az &> /dev/null; then
    echo "❌ Azure CLI not found. Please install it first:"
    echo "   https://docs.microsoft.com/en-us/cli/azure/install-azure-cli"
    exit 1
fi

# Check if logged in to Azure
if ! az account show &> /dev/null; then
    echo "❌ Not logged in to Azure. Please run: az login"
    exit 1
fi

# Get your App Service details
echo "📋 Please provide your Azure App Service details:"
read -p "Resource Group Name: " RESOURCE_GROUP
read -p "App Service Name: " APP_NAME

echo "📦 Preparing deployment package..."

# Create deployment directory
mkdir -p azure-deployment
cd azure-deployment

# Copy essential files
cp ../Services/wolframService.js ./
cp ../backend/services/openaiService.js ./
cp ../routes/debug-math.js ./
cp ../server.js ./
cp ../package.json ./
cp ../public/debug-math.html ./

# Create deployment zip
zip -r wolfram-deployment.zip ./*

echo "🚀 Deploying to Azure App Service: $APP_NAME"

# Deploy using Azure CLI
az webapp deployment source config-zip \
  --resource-group "$RESOURCE_GROUP" \
  --name "$APP_NAME" \
  --src wolfram-deployment.zip

echo "📦 Installing dependencies..."
az webapp ssh --resource-group "$RESOURCE_GROUP" --name "$APP_NAME" --command "npm install wolfram-alpha-api"

echo "🔄 Restarting App Service..."
az webapp restart --resource-group "$RESOURCE_GROUP" --name "$APP_NAME"

echo "✅ Deployment complete!"
echo "🧪 Test your deployment at: https://$APP_NAME.azurewebsites.net/api/debug-math/test"

# Cleanup
cd ..
rm -rf azure-deployment

echo "🎉 Wolfram|Alpha integration deployed successfully!"
