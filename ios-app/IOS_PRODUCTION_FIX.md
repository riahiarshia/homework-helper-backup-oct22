# iOS Production URL Fix

## Problem
The iOS app was hardcoded to use the staging environment URL (`https://homework-helper-staging.azurewebsites.net`) even for production builds, causing the app to receive HTML error pages instead of proper JSON responses.

## Root Cause
In `HomeworkHelper/Config.swift`, line 17 was set to:
```swift
static let current: AppEnvironment = .staging
```

This caused the iOS app to always connect to the staging environment regardless of the build configuration.

## Solution
Changed the environment configuration to use production:
```swift
static let current: AppEnvironment = .production
```

## Result
- ✅ iOS app now connects to production URL: `https://homework-helper-api.azurewebsites.net`
- ✅ Production API returns proper JSON responses
- ✅ No more HTML error pages causing JSON parsing errors
- ✅ iOS app will receive correct API responses

## Environment URLs
- **Development**: `http://10.253.17.4:3000` (local)
- **Staging**: `https://homework-helper-staging.azurewebsites.net`
- **Production**: `https://homework-helper-api.azurewebsites.net` ✅

## Testing
The production API is confirmed working:
```bash
curl https://homework-helper-api.azurewebsites.net/api/health
# Returns: {"status":"ok","timestamp":"2025-10-16T22:16:38.475Z","environment":"production"}
```

## Future Environment Switching
To switch environments in the future, modify line 17 in `Config.swift`:
- For development: `static let current: AppEnvironment = .development`
- For staging: `static let current: AppEnvironment = .staging`
- For production: `static let current: AppEnvironment = .production`
