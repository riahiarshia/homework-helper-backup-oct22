# Production Environment Setup

## Overview
This document outlines the production environment setup for the Homework Helper application.

## Production Environment Details
- **URL**: https://homework-helper-api.azurewebsites.net
- **Environment**: production
- **Deployment**: Manual approval required
- **Branch**: main

## Setup Steps

### 1. Create Production Environment
1. Go to: https://github.com/riahiarshia/HomeworkHelper/settings/environments
2. Click "New environment"
3. Name: `production`
4. Description: `Production environment for live application`
5. Click "Configure environment"

### 2. Add Production Secrets
In the production environment, add these secrets:

#### AZURE_CREDENTIALS_PROD
```json
{
  "clientId": "YOUR_AZURE_CLIENT_ID",
  "clientSecret": "YOUR_AZURE_CLIENT_SECRET", 
  "subscriptionId": "YOUR_AZURE_SUBSCRIPTION_ID",
  "tenantId": "YOUR_AZURE_TENANT_ID",
  "activeDirectoryEndpointUrl": "https://login.microsoftonline.com",
  "resourceManagerEndpointUrl": "https://management.azure.com/",
  "activeDirectoryGraphResourceId": "https://graph.windows.net/",
  "sqlManagementEndpointUrl": "https://management.core.windows.net:8443/",
  "galleryEndpointUrl": "https://gallery.azure.com/",
  "managementEndpointUrl": "https://management.core.windows.net/"
}
```

#### AZURE_WEBAPP_PUBLISH_PROFILE_PROD
Add your Azure Web App publish profile XML content here.

### 3. Set Up Protection Rules
In the production environment settings:
- ✅ **Required reviewers**: Add your GitHub username
- ✅ **Dismiss stale reviews**: When new commits are pushed
- ✅ **Wait timer**: 5 minutes
- ✅ **Restrict to specific branches**: `main` only

## Deployment Process

### Automatic Deployment
1. Push changes to `main` branch
2. GitHub Actions will trigger production deployment
3. Manual approval required in GitHub Actions
4. Deployment will proceed after approval

### Manual Deployment
1. Go to Actions tab in GitHub
2. Find the production deployment workflow
3. Click "Run workflow" if needed
4. Approve the deployment when prompted

## Health Check
After deployment, verify the production environment:
- **Health endpoint**: https://homework-helper-api.azurewebsites.net/api/health
- **Expected response**: `{"status":"ok","environment":"production"}`

## Troubleshooting
- Check GitHub Actions logs for deployment issues
- Verify Azure credentials are correct
- Ensure production environment exists and is configured
- Check Azure App Service logs if needed

## Security Notes
- Production environment requires manual approval
- Secrets are stored securely in GitHub Secrets
- No sensitive data should be committed to the repository
- Use environment variables for configuration
