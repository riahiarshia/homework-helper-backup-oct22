#!/bin/bash

# Comprehensive Ledger and Deployment Monitoring Script
# Monitors every 10 seconds until ledger shows data

set -e

echo "🔍 LEDGER & DEPLOYMENT MONITOR"
echo "=============================="
echo "Monitoring every 10 seconds until ledger shows data..."
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Counters
attempt=0
success_count=0
failure_count=0

# Function to log with timestamp
log() {
    echo -e "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Function to check GitHub deployment status
check_deployment() {
    log "${BLUE}📊 Checking GitHub deployment status...${NC}"
    
    # Get latest deployment
    local latest_run=$(gh run list --limit 1 --json databaseId,status,conclusion,workflowName,headBranch,createdAt 2>/dev/null || echo "[]")
    
    if [[ "$latest_run" == "[]" ]]; then
        log "${RED}❌ No deployment runs found${NC}"
        return 1
    fi
    
    local status=$(echo "$latest_run" | jq -r '.[0].status')
    local conclusion=$(echo "$latest_run" | jq -r '.[0].conclusion')
    local workflow=$(echo "$latest_run" | jq -r '.[0].workflowName')
    
    log "${BLUE}   Workflow: $workflow${NC}"
    log "${BLUE}   Status: $status${NC}"
    log "${BLUE}   Conclusion: $conclusion${NC}"
    
    if [[ "$status" == "completed" && "$conclusion" == "success" ]]; then
        log "${GREEN}✅ Deployment successful${NC}"
        return 0
    elif [[ "$status" == "completed" && "$conclusion" == "failure" ]]; then
        log "${RED}❌ Deployment failed${NC}"
        return 1
    elif [[ "$status" == "in_progress" ]]; then
        log "${YELLOW}⏳ Deployment in progress...${NC}"
        return 2
    else
        log "${YELLOW}⚠️  Deployment status: $status / $conclusion${NC}"
        return 2
    fi
}

# Function to check production health
check_production_health() {
    log "${BLUE}🏥 Checking production health...${NC}"
    
    local response=$(curl -s -w "%{http_code}" https://homework-helper-api.azurewebsites.net/api/health 2>/dev/null || echo "000")
    local http_code="${response: -3}"
    local body="${response%???}"
    
    if [[ "$http_code" == "200" ]]; then
        local status=$(echo "$body" | jq -r '.status' 2>/dev/null || echo "unknown")
        local env=$(echo "$body" | jq -r '.environment' 2>/dev/null || echo "unknown")
        log "${GREEN}✅ Production health: $status ($env)${NC}"
        return 0
    else
        log "${RED}❌ Production health check failed (HTTP $http_code)${NC}"
        return 1
    fi
}

# Function to check ledger stats
check_ledger_stats() {
    log "${BLUE}📋 Checking ledger statistics...${NC}"
    
    # Try to get ledger stats via API
    local response=$(curl -s -w "%{http_code}" https://homework-helper-api.azurewebsites.net/api/ledger/public-stats 2>/dev/null || echo "000")
    local http_code="${response: -3}"
    local body="${response%???}"
    
    if [[ "$http_code" == "200" ]]; then
        local total_records=$(echo "$body" | jq -r '.ledger.total_records' 2>/dev/null || echo "0")
        local trial_count=$(echo "$body" | jq -r '.ledger.trial_count' 2>/dev/null || echo "0")
        local active_count=$(echo "$body" | jq -r '.ledger.active_count' 2>/dev/null || echo "0")
        
        log "${BLUE}   Total Records: $total_records${NC}"
        log "${BLUE}   Trial Records: $trial_count${NC}"
        log "${BLUE}   Active Records: $active_count${NC}"
        
        if [[ "$total_records" -gt 0 ]]; then
            log "${GREEN}✅ Ledger has data! ($total_records records)${NC}"
            return 0
        else
            log "${YELLOW}⚠️  Ledger is empty (0 records)${NC}"
            return 1
        fi
    else
        log "${RED}❌ Failed to get ledger stats (HTTP $http_code)${NC}"
        return 1
    fi
}

# Function to check ledger records
check_ledger_records() {
    log "${BLUE}📄 Checking ledger records...${NC}"
    
    local response=$(curl -s -w "%{http_code}" https://homework-helper-api.azurewebsites.net/api/admin/ledger/records?limit=5 2>/dev/null || echo "000")
    local http_code="${response: -3}"
    local body="${response%???}"
    
    if [[ "$http_code" == "200" ]]; then
        local record_count=$(echo "$body" | jq -r '.records | length' 2>/dev/null || echo "0")
        log "${BLUE}   Records returned: $record_count${NC}"
        
        if [[ "$record_count" -gt 0 ]]; then
            log "${GREEN}✅ Ledger records are accessible${NC}"
            return 0
        else
            log "${YELLOW}⚠️  No ledger records returned${NC}"
            return 1
        fi
    else
        log "${RED}❌ Failed to get ledger records (HTTP $http_code)${NC}"
        return 1
    fi
}

# Function to check admin portal
check_admin_portal() {
    log "${BLUE}🔧 Checking admin portal accessibility...${NC}"
    
    local response=$(curl -s -w "%{http_code}" https://homework-helper-api.azurewebsites.net/admin/ 2>/dev/null || echo "000")
    local http_code="${response: -3}"
    
    if [[ "$http_code" == "200" ]]; then
        log "${GREEN}✅ Admin portal accessible${NC}"
        return 0
    else
        log "${RED}❌ Admin portal not accessible (HTTP $http_code)${NC}"
        return 1
    fi
}

# Function to check system info
check_system_info() {
    log "${BLUE}📊 Checking system information...${NC}"
    
    local response=$(curl -s -w "%{http_code}" https://homework-helper-api.azurewebsites.net/api/ledger/system-info 2>/dev/null || echo "000")
    local http_code="${response: -3}"
    local body="${response%???}"
    
    if [[ "$http_code" == "200" ]]; then
        local users=$(echo "$body" | jq -r '.system.users' 2>/dev/null || echo "0")
        local subscriptions=$(echo "$body" | jq -r '.system.subscriptions' 2>/dev/null || echo "0")
        local ledger_records=$(echo "$body" | jq -r '.system.ledger_records' 2>/dev/null || echo "0")
        
        log "${BLUE}   Users: $users${NC}"
        log "${BLUE}   Subscriptions: $subscriptions${NC}"
        log "${BLUE}   Ledger Records: $ledger_records${NC}"
        
        log "${GREEN}✅ System info accessible${NC}"
        return 0
    else
        log "${RED}❌ Failed to get system info (HTTP $http_code)${NC}"
        return 1
    fi
}

# Function to monitor Azure logs
monitor_azure_logs() {
    log "${BLUE}📋 Monitoring Azure application logs...${NC}"
    
    # Get recent logs from Azure
    local log_output=$(az webapp log tail --name homework-helper-api --resource-group homework-helper-rg --timeout 5 2>/dev/null | tail -10 || echo "No logs available")
    
    if [[ "$log_output" != "No logs available" ]]; then
        log "${BLUE}   Recent logs:${NC}"
        echo "$log_output" | while IFS= read -r line; do
            log "${BLUE}   $line${NC}"
        done
        log "${GREEN}✅ Log monitoring active${NC}"
        return 0
    else
        log "${YELLOW}⚠️  No recent logs available${NC}"
        return 1
    fi
}

# Function to attempt fixes
attempt_fixes() {
    log "${YELLOW}🔧 Attempting to fix issues...${NC}"
    
    # Check if we need to restart the app
    log "${BLUE}   Checking if app restart is needed...${NC}"
    
    # Try to trigger a simple API call to wake up the app
    curl -s https://homework-helper-api.azurewebsites.net/api/health >/dev/null 2>&1 || true
    
    # Wait a moment for app to wake up
    sleep 5
    
    return 0
}

# Function to create test ledger data
create_test_ledger_data() {
    log "${YELLOW}🧪 Attempting to create test ledger data...${NC}"
    
    # This would require admin authentication, so we'll just log the attempt
    log "${BLUE}   Note: Test data creation requires admin authentication${NC}"
    log "${BLUE}   Please check admin portal manually if needed${NC}"
    
    return 0
}

# Main monitoring loop
monitor_loop() {
    while true; do
        attempt=$((attempt + 1))
        
        log "${BLUE}🔄 Monitoring attempt #$attempt${NC}"
        echo ""
        
        # Check deployment status
        if check_deployment; then
            success_count=$((success_count + 1))
        else
            failure_count=$((failure_count + 1))
        fi
        
        # Check production health
        if check_production_health; then
            success_count=$((success_count + 1))
        else
            failure_count=$((failure_count + 1))
        fi
        
        # Check admin portal
        if check_admin_portal; then
            success_count=$((success_count + 1))
        else
            failure_count=$((failure_count + 1))
        fi
        
        # Check system info
        if check_system_info; then
            success_count=$((success_count + 1))
        else
            failure_count=$((failure_count + 1))
        fi
        
        # Check ledger stats
        ledger_has_data=false
        if check_ledger_stats; then
            success_count=$((success_count + 1))
            ledger_has_data=true
        else
            failure_count=$((failure_count + 1))
        fi
        
        # Check ledger records
        if check_ledger_records; then
            success_count=$((success_count + 1))
        else
            failure_count=$((failure_count + 1))
        fi
        
        # Monitor Azure logs (only every 5th attempt to avoid spam)
        if [[ $((attempt % 5)) -eq 0 ]]; then
            if monitor_azure_logs; then
                success_count=$((success_count + 1))
            else
                failure_count=$((failure_count + 1))
            fi
        fi
        
        echo ""
        log "${BLUE}📊 Summary: $success_count successes, $failure_count failures${NC}"
        
        # If ledger has data, we're done!
        if [[ "$ledger_has_data" == true ]]; then
            log "${GREEN}🎉 SUCCESS! Ledger is showing data!${NC}"
            log "${GREEN}✅ Monitoring complete - ledger is functional${NC}"
            break
        fi
        
        # If we've had many failures, try to fix things
        if [[ $failure_count -gt 10 ]]; then
            attempt_fixes
            create_test_ledger_data
            failure_count=0  # Reset counter after fixes
        fi
        
        log "${BLUE}⏳ Waiting 10 seconds before next check...${NC}"
        echo "----------------------------------------"
        sleep 10
    done
}

# Function to handle network errors gracefully
handle_network_error() {
    log "${YELLOW}⚠️  Network error detected, retrying in 5 seconds...${NC}"
    sleep 5
}

# Main execution
main() {
    log "${GREEN}🚀 Starting comprehensive ledger and deployment monitoring${NC}"
    log "${BLUE}Target: https://homework-helper-api.azurewebsites.net${NC}"
    log "${BLUE}Admin Portal: https://homework-helper-api.azurewebsites.net/admin/${NC}"
    echo ""
    
    # Set up error handling
    trap handle_network_error ERR
    
    # Start monitoring
    monitor_loop
}

# Run the monitoring
main "$@"
