# Ledger Admin Guide

## Overview

The Entitlements Ledger is a privacy-compliant system that tracks subscription transactions without storing personally identifiable information (PII). This guide explains how to use the admin portal to view and manage ledger records.

## What is the Entitlements Ledger?

The ledger system serves three purposes:
1. **Fraud Prevention**: Detect trial abuse across account deletions
2. **Accounting Compliance**: Maintain transaction records for financial audits  
3. **Business Analytics**: Understand subscription patterns (aggregated, anonymized)

## Legal Compliance

- **No PII stored**: Only hashed transaction IDs and metadata
- **GDPR compliant**: De-identified data for legitimate business purposes
- **Apple compliant**: Follows App Store guidelines for transaction tracking
- **Retention policy**: Records automatically purged after 24 months

## Admin Portal Features

### 1. View Ledger Statistics
- Total ledger records
- Trial usage counts
- Active/expired/canceled subscriptions
- Date ranges of oldest/newest records

### 2. Browse Ledger Records
- **Hash Preview**: First 16 characters of hashed transaction ID
- **Product ID**: What subscription was purchased
- **Subscription Group**: Apple subscription group identifier
- **Ever Trial**: Whether this transaction ever used a trial
- **Status**: Current subscription status (active/expired/canceled)
- **Timestamps**: When first and last seen

### 3. Filter Records
- **All**: Show all ledger records
- **Trials Only**: Show records where `ever_trial = true`
- **Active**: Show currently active subscriptions
- **Expired**: Show expired subscriptions

### 4. Search User Records
- Search by user email to find their ledger records
- View both user entitlements (with PII) and ledger records (without PII)
- See the relationship between user accounts and ledger entries

### 5. Reset Ledger Records

#### Reset by User
- Clear all ledger records for a specific user
- Allows user to get a new trial (use with caution)
- Requires reason for audit trail
- Logs all actions in admin audit log

#### Reset by Hash
- Delete specific ledger records by hash preview
- More granular control over record deletion
- Requires confirmation and reason
- Useful for cleaning up test data

## How to Use the Admin Portal

### Accessing the Ledger
1. Log into the admin portal
2. Click on the "🔐 Ledger" tab
3. View statistics and browse records

### Searching for a User's Records
1. Click "🔍 Search User" button
2. Enter the user's email address
3. View their entitlements and ledger records
4. Use this to understand why they can't get a trial

### Resetting User Trial History
1. Click "🔄 Reset User" button
2. Enter the user's email address
3. Provide a detailed reason (minimum 10 characters)
4. Click "Reset Ledger"
5. The system will clear their trial history

### Resetting Specific Records
1. Click "🗑️ Reset by Hash" button
2. Enter at least 16 characters of the hash preview
3. Provide a detailed reason
4. Confirm the deletion
5. The system will remove matching records

## Safety Features

### Audit Trail
- All reset operations are logged in the admin audit log
- Includes admin user, target user, reason, and timestamp
- Cannot be deleted or modified

### Confirmation Dialogs
- Reset operations require confirmation
- Clear warnings about irreversible actions
- Reason must be provided for all operations

### Access Control
- Only admin users can access ledger functions
- All operations require authentication
- IP addresses are logged for security

## Common Use Cases

### Legitimate Trial Reset
**Scenario**: User had technical issues during trial and wants another chance
1. Search for user's records to verify they used trial
2. Use "Reset User" to clear their trial history
3. Provide reason: "Technical issues during original trial period"

### Clean Up Test Data
**Scenario**: Remove test transactions from production ledger
1. Find test records by hash preview
2. Use "Reset by Hash" to remove specific records
3. Provide reason: "Removing test transaction data"

### Investigate Trial Issues
**Scenario**: User claims they never got a trial but system shows they did
1. Search user's email to find their records
2. Review both entitlements and ledger data
3. Check if they had previous subscriptions or trials

## Data Structure

### Ledger Records (No PII)
```
- original_transaction_id_hash: SHA-256 hash of Apple transaction ID
- product_id: Subscription product identifier
- subscription_group_id: Apple subscription group
- ever_trial: Boolean flag for trial usage
- status: active/expired/canceled
- first_seen_at: First transaction timestamp
- last_seen_at: Last update timestamp
```

### User Entitlements (Contains PII)
```
- user_id: Links to users table
- email: User's email address
- original_transaction_id: Plain Apple transaction ID
- product_id: Subscription product
- is_trial: Current trial status
- status: Subscription status
- purchase_at: Purchase timestamp
- expires_at: Expiration timestamp
```

## Troubleshooting

### Ledger Shows Empty
- Check if LEDGER_SALT environment variable is set
- Verify database connection
- Check if records exist in entitlements_ledger table

### Reset Not Working
- Ensure user exists in database
- Check if user has entitlements to reset
- Verify admin permissions
- Check audit log for error details

### Search Not Finding Users
- Verify email address is correct
- Check if user exists in users table
- Ensure user has entitlements records

## Security Notes

- Ledger records cannot be linked back to individuals
- Hash cannot be reversed without LEDGER_SALT
- No PII is stored in ledger table
- All operations are logged and auditable
- Access is restricted to admin users only

## Contact

For questions about the ledger system, contact the engineering team.

**Last Updated**: October 16, 2025  
**Version**: 1.0
