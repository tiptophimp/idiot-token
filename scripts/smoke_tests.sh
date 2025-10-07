#!/bin/bash

# IDIOT Token Dashboard - Smoke Tests
# Run after deployment to verify all systems

set -e

# Configuration
BASE_URL="https://www.stupidiots.com"
LOCAL_URL="http://localhost:3000"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_test() {
    echo -e "${YELLOW}🧪 Testing: $1${NC}"
}

print_pass() {
    echo -e "${GREEN}✅ PASS: $1${NC}"
}

print_fail() {
    echo -e "${RED}❌ FAIL: $1${NC}"
}

# Function to test endpoint
test_endpoint() {
    local url="$1"
    local description="$2"
    local expected_field="$3"
    
    print_test "$description"
    
    if curl -sS --max-time 30 --retry 3 "$url" | grep -q "$expected_field"; then
        print_pass "$description"
        return 0
    else
        print_fail "$description"
        return 1
    fi
}

# Function to test JSON response
test_json_endpoint() {
    local url="$1"
    local description="$2"
    local jq_filter="$3"
    
    print_test "$description"
    
    local response=$(curl -sS --max-time 30 --retry 3 "$url")
    if echo "$response" | jq -e "$jq_filter" > /dev/null 2>&1; then
        print_pass "$description"
        return 0
    else
        print_fail "$description - Response: $response"
        return 1
    fi
}

# Function to test HTTP status
test_http_status() {
    local url="$1"
    local description="$2"
    local expected_status="$3"
    
    print_test "$description"
    
    local status_code=$(curl -sS -o /dev/null -w "%{http_code}" --max-time 30 "$url")
    if [ "$status_code" = "$expected_status" ]; then
        print_pass "$description (Status: $status_code)"
        return 0
    else
        print_fail "$description (Expected: $expected_status, Got: $status_code)"
        return 1
    fi
}

# Main test function
run_smoke_tests() {
    echo "🚀 IDIOT Token Dashboard - Smoke Tests"
    echo "====================================="
    echo ""
    
    local failed_tests=0
    
    # Test 1: Health endpoint
    if ! test_json_endpoint "$BASE_URL/api/health" "Health endpoint" ".status == \"healthy\""; then
        ((failed_tests++))
    fi
    
    # Test 2: Pool endpoint
    if ! test_json_endpoint "$BASE_URL/api/pool" "Pool endpoint" ".pool"; then
        ((failed_tests++))
    fi
    
    # Test 3: Dashboard endpoint
    if ! test_endpoint "$BASE_URL/api/dashboard" "Dashboard endpoint" "tokenInfo"; then
        ((failed_tests++))
    fi
    
    # Test 4: Vesting wallets endpoint
    if ! test_json_endpoint "$BASE_URL/api/vesting-wallets" "Vesting wallets endpoint" ".[0]"; then
        ((failed_tests++))
    fi
    
    # Test 5: Main dashboard page
    if ! test_endpoint "$BASE_URL/" "Main dashboard page" "IDIOT"; then
        ((failed_tests++))
    fi
    
    # Test 6: HTTPS redirect
    if ! test_http_status "http://www.stupidiots.com" "HTTP to HTTPS redirect" "301"; then
        ((failed_tests++))
    fi
    
    # Test 7: TLS/SSL
    print_test "TLS/SSL configuration"
    if openssl s_client -connect www.stupidiots.com:443 -servername www.stupidiots.com < /dev/null 2>/dev/null | grep -q "Verify return code: 0"; then
        print_pass "TLS/SSL configuration"
    else
        print_fail "TLS/SSL configuration"
        ((failed_tests++))
    fi
    
    # Test 8: Security headers
    print_test "Security headers"
    local headers=$(curl -I -sS "$BASE_URL" 2>/dev/null)
    if echo "$headers" | grep -q "Strict-Transport-Security" && \
       echo "$headers" | grep -q "X-Content-Type-Options" && \
       echo "$headers" | grep -q "X-Frame-Options"; then
        print_pass "Security headers present"
    else
        print_fail "Security headers missing"
        ((failed_tests++))
    fi
    
    # Test 9: Rate limiting (test with multiple requests)
    print_test "Rate limiting"
    local rate_limit_triggered=false
    for i in {1..15}; do
        if curl -sS "$BASE_URL/api/health" > /dev/null 2>&1; then
            continue
        else
            rate_limit_triggered=true
            break
        fi
    done
    
    if [ "$rate_limit_triggered" = true ]; then
        print_pass "Rate limiting working"
    else
        print_warning "Rate limiting not triggered (may be normal)"
    fi
    
    # Test 10: Performance (response time)
    print_test "Response time"
    local response_time=$(curl -sS -o /dev/null -w "%{time_total}" "$BASE_URL/api/health" 2>/dev/null)
    local response_time_ms=$(echo "$response_time * 1000" | bc)
    
    if (( $(echo "$response_time < 2.0" | bc -l) )); then
        print_pass "Response time acceptable (${response_time_ms}ms)"
    else
        print_fail "Response time too slow (${response_time_ms}ms)"
        ((failed_tests++))
    fi
    
    # Summary
    echo ""
    echo "====================================="
    if [ $failed_tests -eq 0 ]; then
        echo -e "${GREEN}🎉 ALL TESTS PASSED!${NC}"
        echo "The IDIOT Token Dashboard is ready for production."
        exit 0
    else
        echo -e "${RED}❌ $failed_tests TESTS FAILED${NC}"
        echo "Please check the failed tests and fix issues before going live."
        exit 1
    fi
}

# Check dependencies
if ! command -v curl &> /dev/null; then
    echo "Error: curl is required but not installed."
    exit 1
fi

if ! command -v jq &> /dev/null; then
    echo "Error: jq is required but not installed."
    exit 1
fi

if ! command -v openssl &> /dev/null; then
    echo "Error: openssl is required but not installed."
    exit 1
fi

if ! command -v bc &> /dev/null; then
    echo "Error: bc is required but not installed."
    exit 1
fi

# Run tests
run_smoke_tests
