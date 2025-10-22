# Azure CLI Deployment Commands

## Prerequisites
1. Install Azure CLI: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli
2. Login: `az login`
3. Get your App Service details

## Quick Deployment Commands

### 1. Create Deployment Package
```bash
# Create deployment directory
mkdir azure-deployment
cd azure-deployment

# Copy essential files
cp ../Services/wolframService.js ./
cp ../backend/services/openaiService.js ./
cp ../routes/debug-math.js ./
cp ../server.js ./
cp ../package.json ./
cp ../public/debug-math.html ./

# Create zip package
zip -r wolfram-deployment.zip ./*
```

### 2. Deploy to Azure
```bash
# Replace with your actual values
RESOURCE_GROUP="your-resource-group"
APP_NAME="your-app-name"

# Deploy the package
az webapp deployment source config-zip \
  --resource-group "$RESOURCE_GROUP" \
  --name "$APP_NAME" \
  --src wolfram-deployment.zip
```

### 3. Install Dependencies
```bash
# Install missing dependencies
az webapp ssh --resource-group "$RESOURCE_GROUP" --name "$APP_NAME" --command "npm install @azure/keyvault-secrets @azure/identity mathjs axios"
```

### 4. Restart App
```bash
# Restart the app service
az webapp restart --resource-group "$RESOURCE_GROUP" --name "$APP_NAME"
```

### 5. Test Deployment
```bash
# Test the deployment
curl https://$APP_NAME.azurewebsites.net/api/debug-math/test
```

## Alternative: Direct File Upload
```bash
# Upload individual files
az webapp deployment source config-zip \
  --resource-group "$RESOURCE_GROUP" \
  --name "$APP_NAME" \
  --src package.json

# Then install dependencies
az webapp ssh --resource-group "$RESOURCE_GROUP" --name "$APP_NAME" --command "npm install"
```

## Troubleshooting
- If SSH fails, use Azure Portal Console
- Check logs: `az webapp log tail --resource-group "$RESOURCE_GROUP" --name "$APP_NAME"`
- Verify deployment: `az webapp show --resource-group "$RESOURCE_GROUP" --name "$APP_NAME"`


