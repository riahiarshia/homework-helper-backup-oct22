#!/bin/bash

# Apply admin_audit_log table migration to production database
# This fixes the missing table error in admin routes

echo "🔧 Applying admin_audit_log table migration..."

# Check if we're in the right directory
if [ ! -f "backend/database/add_admin_audit_log.sql" ]; then
    echo "❌ Error: Migration file not found. Please run from project root."
    exit 1
fi

# Apply the migration
echo "📊 Adding admin_audit_log table to production database..."
psql $DATABASE_URL -f backend/database/add_admin_audit_log.sql

if [ $? -eq 0 ]; then
    echo "✅ admin_audit_log table created successfully!"
    echo "🎉 Admin portal audit logging should now work properly."
else
    echo "❌ Error: Failed to create admin_audit_log table"
    exit 1
fi

echo "🔍 Verifying table creation..."
psql $DATABASE_URL -c "SELECT COUNT(*) FROM admin_audit_log;"

echo "✅ Migration complete!"
