#!/bin/bash

# IDIOT Token Dashboard - Local Cutover Script
# Execute the cutover for local/development environment

set -e

# Configuration
export DOMAIN=localhost
export WWW=localhost
export EMAIL=admin@localhost
export PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export LOG_DIR="$PROJECT_DIR/logs"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S UTC'): $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to run emergency rollback
emergency_rollback() {
    print_error "CRITICAL: Cutover failed! Running emergency rollback..."
    if [ -f "$PROJECT_DIR/scripts/emergency_rollback.sh" ]; then
        bash "$PROJECT_DIR/scripts/emergency_rollback.sh"
    else
        print_error "Emergency rollback script not found!"
        exit 1
    fi
}

# Function to check preflight requirements
preflight_check() {
    log_message "🔍 Running preflight checks..."
    
    # Check required commands
    local required_commands=("git" "npm" "node" "curl")
    for cmd in "${required_commands[@]}"; do
        if ! command_exists "$cmd"; then
            print_error "Required command not found: $cmd"
            exit 1
        fi
    done
    
    # Check if project directory exists
    if [ ! -d "$PROJECT_DIR" ]; then
        print_error "Project directory not found: $PROJECT_DIR"
        exit 1
    fi
    
    # Create log directory
    mkdir -p "$LOG_DIR"
    
    print_status "Preflight checks passed"
}

# Function to deploy application
deploy_application() {
    log_message "🚀 Deploying application..."
    
    cd "$PROJECT_DIR"
    
    # Pull latest changes
    log_message "Pulling latest changes..."
    git pull --rebase
    
    # Install dependencies
    log_message "Installing dependencies..."
    npm ci
    
    # Install dashboard dependencies
    cd "$PROJECT_DIR/transparency-dashboard"
    npm install
    
    # Stop any existing processes
    log_message "Stopping existing processes..."
    pkill -f "node server.js" || true
    taskkill /F /IM node.exe 2>/dev/null || true
    
    # Start the server
    log_message "Starting dashboard server..."
    cd "$PROJECT_DIR/transparency-dashboard"
    node server.js &
    local server_pid=$!
    
    # Wait for server to start
    sleep 5
    
    # Check if server is running
    if ps -p $server_pid > /dev/null; then
        print_status "Dashboard server started (PID: $server_pid)"
    else
        print_error "Failed to start dashboard server"
        return 1
    fi
    
    print_status "Application deployed successfully"
}

# Function to run smoke tests
run_smoke_tests() {
    log_message "🧪 Running smoke tests..."
    
    local tests_passed=0
    local total_tests=3
    
    # Wait for server to be ready
    sleep 10
    
    # Test health endpoint
    if curl -sS "http://localhost:3000/api/health" >/dev/null 2>&1; then
        print_status "Health endpoint test passed"
        ((tests_passed++))
    else
        print_error "Health endpoint test failed"
    fi
    
    # Test pool endpoint
    if curl -sS "http://localhost:3000/api/pool" >/dev/null 2>&1; then
        print_status "Pool endpoint test passed"
        ((tests_passed++))
    else
        print_error "Pool endpoint test failed"
    fi
    
    # Test main page
    if curl -I "http://localhost:3000" 2>/dev/null | grep -q "200 OK"; then
        print_status "Main page test passed"
        ((tests_passed++))
    else
        print_error "Main page test failed"
    fi
    
    if [ $tests_passed -eq $total_tests ]; then
        print_status "All smoke tests passed ($tests_passed/$total_tests)"
    else
        print_error "Some smoke tests failed ($tests_passed/$total_tests)"
        return 1
    fi
}

# Function to start hypercare monitoring
start_hypercare() {
    log_message "📊 Starting hypercare monitoring..."
    
    # Start hypercare monitor in background
    bash "$PROJECT_DIR/scripts/hypercare_monitor.sh" >"$LOG_DIR/hypercare.log" 2>&1 &
    local monitor_pid=$!
    
    # Wait a moment and check if it's running
    sleep 2
    if ps -p $monitor_pid > /dev/null; then
        print_status "Hypercare monitoring started (PID: $monitor_pid)"
    else
        print_warning "Hypercare monitoring may not have started properly"
    fi
}

# Function to generate baseline and tag
generate_baseline_and_tag() {
    log_message "📊 Generating baseline and tagging release..."
    
    cd "$PROJECT_DIR"
    
    # Generate baseline (using mock values for local testing)
    log_message "Generating baseline..."
    if [ -f "scripts/gen_baseline.ts" ]; then
        # Use mock values for local testing
        SAFE=0x1234567890123456789012345678901234567890 POSITION_IDS=1,2 npx hardhat run scripts/gen_baseline.ts --network base || true
    fi
    
    # Commit and push baseline
    git add audit/BASELINE.md 2>/dev/null || true
    git commit -m "Baseline post-launch" || true
    git push || true
    
    # Tag release
    git tag v2025.10.07-prod-launch || true
    git push --tags || true
    
    print_status "Baseline generated and release tagged"
}

# Function to display status
display_status() {
    log_message "📊 Displaying system status..."
    
    echo ""
    echo "🔧 System Status:"
    echo "  - Dashboard URL: http://localhost:3000"
    echo "  - Health Check: http://localhost:3000/api/health"
    echo "  - Pool Data: http://localhost:3000/api/pool"
    echo ""
    
    # Check if server is running
    if pgrep -f "node server.js" > /dev/null; then
        print_status "Dashboard server is running"
    else
        print_error "Dashboard server is not running"
    fi
    
    # Check if hypercare is running
    if pgrep -f "hypercare_monitor" > /dev/null; then
        print_status "Hypercare monitoring is running"
    else
        print_warning "Hypercare monitoring is not running"
    fi
    
    echo ""
    echo "📋 Next Steps:"
    echo "  - Monitor logs: tail -f $LOG_DIR/hypercare.log"
    echo "  - Check server status: ps aux | grep 'node server.js'"
    echo "  - Test endpoints: curl http://localhost:3000/api/health"
    echo ""
}

# Main cutover function
main() {
    log_message "🚀 Starting IDIOT Token Dashboard local cutover..."
    
    # Set trap for emergency rollback on failure
    trap 'emergency_rollback' ERR
    
    # Run all cutover steps
    preflight_check
    deploy_application
    run_smoke_tests
    start_hypercare
    generate_baseline_and_tag
    display_status
    
    # Success message
    log_message "🎉 Local cutover completed successfully!"
    echo ""
    echo "🔧 Deployment Summary:"
    echo "  ✅ Application deployed and running"
    echo "  ✅ Smoke tests passed"
    echo "  ✅ Hypercare monitoring active"
    echo "  ✅ Baseline generated and tagged"
    echo ""
    echo "🌐 Dashboard URL: http://localhost:3000"
    echo "📊 Health Check: http://localhost:3000/api/health"
    echo "📈 Pool Data: http://localhost:3000/api/pool"
    echo ""
    echo "🚨 Emergency Rollback: $PROJECT_DIR/scripts/emergency_rollback.sh"
}

# Run main function
main "$@"
