# Azure CLI Deployment Commands for OpenAI Logging Updates

## Quick Deployment

### Option 1: Run the deployment script
```bash
./deploy-logging-updates.sh
```

### Option 2: Manual deployment commands

#### 1. Create deployment package
```bash
# Create deployment directory
mkdir azure-logging-deployment
cd azure-logging-deployment

# Copy updated files with logging
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
cp ../routes/*.js ./
cp ../middleware/*.js ./
cp ../Services/*.js ./

# Create zip package
zip -r logging-updates-deployment.zip ./*
```

#### 2. Deploy to Azure
```bash
# Replace with your actual values
RESOURCE_GROUP="your-resource-group"
APP_NAME="your-app-name"

# Deploy the package
az webapp deployment source config-zip \
  --resource-group "$RESOURCE_GROUP" \
  --name "$APP_NAME" \
  --src logging-updates-deployment.zip
```

#### 3. Install dependencies and restart
```bash
# Install dependencies
az webapp ssh --resource-group "$RESOURCE_GROUP" --name "$APP_NAME" --command "npm install"

# Create logs directory
az webapp ssh --resource-group "$RESOURCE_GROUP" --name "$APP_NAME" --command "mkdir -p /home/LogFiles/custom"

# Restart the app service
az webapp restart --resource-group "$RESOURCE_GROUP" --name "$APP_NAME"
```

#### 4. Test deployment
```bash
# Test the deployment
curl https://$APP_NAME.azurewebsites.net/api/health
```

## What Gets Deployed

### New Files:
- `Services/loggingService.js` - Centralized logging service

### Updated Files:
- `Services/openaiService.js` - Added comprehensive logging to all OpenAI API calls
- `routes/imageAnalysis.js` - Added logging to all image analysis endpoints
- `routes/homework.js` - Added logging to homework submission endpoints

### Logging Features:
- ✅ All OpenAI API requests and responses
- ✅ Homework submission context and analysis
- ✅ Hint generation and answer verification
- ✅ Chat responses and image validation
- ✅ Complete math logic and reasoning capture

## Log Location
All logs are written to: `/home/LogFiles/custom/homework-math.log`

## Troubleshooting
- If SSH fails, use Azure Portal Console
- Check logs: `az webapp log tail --resource-group "$RESOURCE_GROUP" --name "$APP_NAME"`
- Verify deployment: `az webapp show --resource-group "$RESOURCE_GROUP" --name "$APP_NAME"`
