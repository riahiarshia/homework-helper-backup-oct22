#!/bin/bash

# Azure CLI Deployment Script for OpenAI Logging Updates
echo "🚀 Deploying OpenAI logging updates via Azure CLI..."

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

echo "📦 Preparing deployment package with logging updates..."

# Create deployment directory
mkdir -p azure-logging-deployment
cd azure-logging-deployment

# Copy updated files with logging
echo "📁 Copying updated files..."
cp ../Services/loggingService.js ./
cp ../Services/openaiService.js ./
cp ../routes/imageAnalysis.js ./
cp ../routes/homework.js ./

# Copy essential existing files
cp ../server.js ./
cp ../package.json ./
cp ../config.js ./
cp ../Services/azureService.js ./
cp ../Services/usageTrackingService.js ./
cp ../Services/homeworkTrackingService.js ./

# Copy all route files
cp ../routes/*.js ./

# Copy middleware
cp ../middleware/*.js ./

# Copy other essential services
cp ../Services/*.js ./

echo "📦 Creating deployment zip package..."
zip -r logging-updates-deployment.zip ./*

echo "🚀 Deploying to Azure App Service: $APP_NAME"

# Deploy using Azure CLI
az webapp deployment source config-zip \
  --resource-group "$RESOURCE_GROUP" \
  --name "$APP_NAME" \
  --src logging-updates-deployment.zip

echo "📦 Installing dependencies..."
az webapp ssh --resource-group "$RESOURCE_GROUP" --name "$APP_NAME" --command "npm install"

echo "🔄 Restarting App Service..."
az webapp restart --resource-group "$RESOURCE_GROUP" --name "$APP_NAME"

echo "📊 Checking deployment status..."
az webapp show --resource-group "$RESOURCE_GROUP" --name "$APP_NAME" --query "state"

echo "📝 Checking logs directory..."
az webapp ssh --resource-group "$RESOURCE_GROUP" --name "$APP_NAME" --command "mkdir -p /home/LogFiles/custom"

echo "✅ Deployment complete!"
echo "🧪 Test your deployment at: https://$APP_NAME.azurewebsites.net/api/health"
echo "📊 Logs will be written to: /home/LogFiles/custom/homework-math.log"

# Cleanup
cd ..
rm -rf azure-logging-deployment

echo "🎉 OpenAI logging updates deployed successfully!"
echo ""
echo "📋 What was deployed:"
echo "  ✅ New logging service (Services/loggingService.js)"
echo "  ✅ Updated OpenAI service with comprehensive logging"
echo "  ✅ Updated image analysis routes with logging"
echo "  ✅ Updated homework routes with logging"
echo ""
echo "📝 All OpenAI communications will now be logged to:"
echo "  /home/LogFiles/custom/homework-math.log"
