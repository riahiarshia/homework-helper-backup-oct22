#!/bin/bash

##############################################################################
# AUTOMATED QA TEST RUNNER WITH LOG STREAM MONITORING
# 
# This script:
# 1. Starts Azure log stream monitoring in background
# 2. Runs automated tests
# 3. Captures both API responses AND Azure logs
# 4. Analyzes validator activity
# 5. Generates comprehensive report
##############################################################################

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
RESULTS_DIR="${SCRIPT_DIR}/../test-results"
LOG_FILE="${RESULTS_DIR}/azure-logs-$(date +%Y%m%d_%H%M%S).log"
TEST_OUTPUT="${RESULTS_DIR}/test-output-$(date +%Y%m%d_%H%M%S).log"

# Create results directory
mkdir -p "$RESULTS_DIR"

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                                                            ║${NC}"
echo -e "${BLUE}║   🤖 AUTOMATED K-12 QA TESTING WITH LOG MONITORING         ║${NC}"
echo -e "${BLUE}║                                                            ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Check if Azure CLI is installed
if ! command -v az &> /dev/null; then
    echo -e "${RED}❌ Azure CLI not found. Installing...${NC}"
    # For macOS
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install azure-cli
    else
        echo "Please install Azure CLI manually: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli"
        exit 1
    fi
fi

# Check if logged in to Azure
echo -e "${BLUE}🔐 Checking Azure authentication...${NC}"
if ! az account show &> /dev/null; then
    echo -e "${YELLOW}⚠️  Not logged in to Azure. Please login:${NC}"
    az login
fi

# Start Azure log stream in background
echo -e "${BLUE}📊 Starting Azure log stream monitoring...${NC}"
echo "Logs will be saved to: $LOG_FILE"

az webapp log tail \
    --resource-group homework-helper-rg-f \
    --name homework-helper-api \
    > "$LOG_FILE" 2>&1 &

LOG_STREAM_PID=$!
echo -e "${GREEN}✅ Log stream started (PID: $LOG_STREAM_PID)${NC}"
echo ""

# Wait for log stream to initialize
echo -e "${BLUE}⏳ Waiting 5 seconds for log stream to initialize...${NC}"
sleep 5

# Run the automated tests
echo -e "${BLUE}🧪 Starting automated tests...${NC}"
echo "Test output will be saved to: $TEST_OUTPUT"
echo ""

cd "$SCRIPT_DIR/.."

if node tests/automated-qa-tests.js 2>&1 | tee "$TEST_OUTPUT"; then
    TEST_EXIT_CODE=0
    echo -e "${GREEN}✅ Tests completed successfully${NC}"
else
    TEST_EXIT_CODE=$?
    echo -e "${RED}❌ Tests failed with exit code $TEST_EXIT_CODE${NC}"
fi

# Wait a bit to capture final logs
echo ""
echo -e "${BLUE}⏳ Waiting 10 seconds to capture final logs...${NC}"
sleep 10

# Stop log stream
echo -e "${BLUE}🛑 Stopping log stream...${NC}"
kill $LOG_STREAM_PID 2>/dev/null || true
wait $LOG_STREAM_PID 2>/dev/null || true
echo -e "${GREEN}✅ Log stream stopped${NC}"
echo ""

# Analyze logs for validator activity
echo -e "${BLUE}🔍 Analyzing logs for validator activity...${NC}"
echo ""

VALIDATOR_REPORT="${RESULTS_DIR}/validator-analysis-$(date +%Y%m%d_%H%M%S).txt"

{
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║          VALIDATOR ACTIVITY ANALYSIS                       ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo ""
    echo "Log file: $LOG_FILE"
    echo "Generated: $(date)"
    echo ""
    
    # Check for Universal Physics Validator
    echo "🔬 Universal Physics Validator:"
    if grep -q "Universal Physics Validator: Starting" "$LOG_FILE"; then
        echo "  ✅ DETECTED"
        echo "  Activations: $(grep -c "Universal Physics Validator: Starting" "$LOG_FILE")"
        
        # Check for value extraction
        if grep -q "📐 Kinematics values:" "$LOG_FILE"; then
            echo "  ✅ Value extraction working"
            grep "📐 Kinematics values:" "$LOG_FILE" | head -3
        else
            echo "  ❌ Value extraction NOT working"
        fi
        
        # Check for corrections
        if grep -q "🔧 Step" "$LOG_FILE"; then
            echo "  ✅ Corrections made"
            echo "  Corrections count: $(grep -c "🔧 Step" "$LOG_FILE")"
            grep "🔧 Step" "$LOG_FILE" | head -3
        else
            echo "  ⚠️  No corrections needed (or validator not fixing)"
        fi
    else
        echo "  ❌ NOT DETECTED"
    fi
    echo ""
    
    # Check for Universal Math Validator
    echo "🧮 Universal Math Validator:"
    if grep -q "Universal Math Validator: Starting" "$LOG_FILE"; then
        echo "  ✅ DETECTED"
        echo "  Activations: $(grep -c "Universal Math Validator: Starting" "$LOG_FILE")"
    else
        echo "  ❌ NOT DETECTED"
    fi
    echo ""
    
    # Check for Universal Answer Verification
    echo "🎯 Universal Answer Verification Validator:"
    if grep -q "Universal Answer Verification Validator: Starting" "$LOG_FILE"; then
        echo "  ✅ DETECTED"
        echo "  Activations: $(grep -c "Universal Answer Verification Validator: Starting" "$LOG_FILE")"
        
        # Check for target variable detection
        if grep -q "🎯 Target variable detected:" "$LOG_FILE"; then
            echo "  ✅ Target detection working"
            grep "🎯 Target variable detected:" "$LOG_FILE" | head -3
        fi
    else
        echo "  ❌ NOT DETECTED"
    fi
    echo ""
    
    # Check for Chemistry/Physics Validator
    echo "🔬 Chemistry/Physics Validator:"
    if grep -q "Chemistry/Physics Validator: Starting" "$LOG_FILE"; then
        echo "  ✅ DETECTED"
        echo "  Activations: $(grep -c "Chemistry/Physics Validator: Starting" "$LOG_FILE")"
    else
        echo "  ❌ NOT DETECTED"
    fi
    echo ""
    
    # Check for Options Consistency Validator
    echo "🎯 Options Consistency Validator:"
    if grep -q "Options Consistency Validator: Starting" "$LOG_FILE"; then
        echo "  ✅ DETECTED"
        echo "  Activations: $(grep -c "Options Consistency Validator: Starting" "$LOG_FILE")"
    else
        echo "  ❌ NOT DETECTED"
    fi
    echo ""
    
    # Check for errors
    echo "❌ Errors Detected:"
    if grep -qi "error" "$LOG_FILE"; then
        echo "  ⚠️  Errors found:"
        grep -i "error" "$LOG_FILE" | grep -v "Zero errors" | head -5
    else
        echo "  ✅ No errors"
    fi
    echo ""
    
    # Summary
    echo "═══════════════════════════════════════════════════════════"
    echo "SUMMARY:"
    echo "═══════════════════════════════════════════════════════════"
    echo "Total log lines: $(wc -l < "$LOG_FILE")"
    echo "Validator activations:"
    echo "  - Physics: $(grep -c "Universal Physics Validator: Starting" "$LOG_FILE" || echo 0)"
    echo "  - Math: $(grep -c "Universal Math Validator: Starting" "$LOG_FILE" || echo 0)"
    echo "  - Chemistry: $(grep -c "Chemistry/Physics Validator: Starting" "$LOG_FILE" || echo 0)"
    echo "  - Answer Verification: $(grep -c "Universal Answer Verification" "$LOG_FILE" || echo 0)"
    echo "  - Options: $(grep -c "Options Consistency Validator" "$LOG_FILE" || echo 0)"
    echo ""
    echo "Corrections made: $(grep -c "🔧 Step" "$LOG_FILE" || echo 0)"
    echo ""
    
} > "$VALIDATOR_REPORT"

# Display validator report
cat "$VALIDATOR_REPORT"

# Save to main results
cp "$VALIDATOR_REPORT" "${RESULTS_DIR}/latest-validator-analysis.txt"

echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}✅ TESTING COMPLETE!${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo "📁 Results Location: $RESULTS_DIR"
echo "  - Test results: test-results/qa-test-results.json"
echo "  - Test report: test-results/QA_FINAL_REPORT.md"
echo "  - Azure logs: $(basename "$LOG_FILE")"
echo "  - Test output: $(basename "$TEST_OUTPUT")"
echo "  - Validator analysis: $(basename "$VALIDATOR_REPORT")"
echo ""
echo -e "${YELLOW}📊 Next steps:${NC}"
echo "  1. Review test-results/QA_FINAL_REPORT.md"
echo "  2. Check validator-analysis for validator activity"
echo "  3. Review Azure logs for detailed debugging"
echo ""

exit $TEST_EXIT_CODE

