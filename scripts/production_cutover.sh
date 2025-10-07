#!/bin/bash

# IDIOT Token Dashboard - Production Cutover Script
# Execute the complete production deployment

set -e

# Configuration
export DOMAIN=stupidiots.com
export WWW=www.stupidiots.com
export EMAIL=admin@$DOMAIN
export PROJECT_DIR="/srv/stupidiots"
export LOG_DIR="/var/log"

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
    
    # Check if running as root for system operations
    if [ "$EUID" -ne 0 ]; then
        print_warning "Some operations require root privileges. Please run with sudo."
    fi
    
    # Check required commands
    local required_commands=("git" "npm" "pm2" "nginx" "certbot" "curl")
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
    
    # Build if needed
    log_message "Building application..."
    npm run build || true
    
    # Restart PM2
    log_message "Restarting PM2..."
    pm2 restart stupidiots-dashboard || pm2 start ecosystem.config.js --env production
    
    # Test nginx config
    log_message "Testing nginx configuration..."
    nginx -t
    
    # Reload nginx
    log_message "Reloading nginx..."
    systemctl reload nginx
    
    print_status "Application deployed successfully"
}

# Function to setup TLS
setup_tls() {
    log_message "🔒 Setting up TLS certificates..."
    
    # Run certbot
    certbot --nginx -d $DOMAIN -d $WWW --agree-tos -m $EMAIL --redirect --non-interactive
    
    # Enable certbot timer
    if ! systemctl list-timers | grep -q certbot; then
        systemctl enable --now certbot.timer
    fi
    
    print_status "TLS setup completed"
}

# Function to start hypercare monitoring
start_hypercare() {
    log_message "📊 Starting hypercare monitoring..."
    
    # Start hypercare monitor in background
    bash "$PROJECT_DIR/scripts/hypercare_monitor.sh" >"$LOG_DIR/hypercare.log" 2>&1 &
    disown
    
    print_status "Hypercare monitoring started"
}

# Function to run smoke tests
run_smoke_tests() {
    log_message "🧪 Running smoke tests..."
    
    local tests_passed=0
    local total_tests=3
    
    # Test health endpoint
    if curl -sS "https://$DOMAIN/api/health" >/dev/null 2>&1; then
        print_status "Health endpoint test passed"
        ((tests_passed++))
    else
        print_error "Health endpoint test failed"
    fi
    
    # Test pool endpoint
    if curl -sS "https://$DOMAIN/api/pool" >/dev/null 2>&1; then
        print_status "Pool endpoint test passed"
        ((tests_passed++))
    else
        print_error "Pool endpoint test failed"
    fi
    
    # Test main page
    if curl -I "https://$DOMAIN" 2>/dev/null | grep -q "200 OK"; then
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

# Function to setup cron jobs
setup_cron_jobs() {
    log_message "⏰ Setting up cron jobs..."
    
    # Example weekly Monday 13:00 UTC fee collection
    cat > /etc/cron.d/idiot-fee-collector << EOF
# IDIOT Token Dashboard - Fee Collection
# Weekly Monday 13:00 UTC
0 13 * * 1 cd $PROJECT_DIR && SAFE_RECIPIENT=0x<safe> POSITION_IDS=123,124 npx hardhat run scripts/cron_collect_fees.ts --network base >> $LOG_DIR/fees.log 2>&1
EOF
    
    # Restart cron service
    systemctl restart cron || systemctl restart crond
    
    print_status "Cron jobs configured"
}

# Function to generate baseline and tag
generate_baseline_and_tag() {
    log_message "📊 Generating baseline and tagging release..."
    
    cd "$PROJECT_DIR"
    
    # Generate baseline
    SAFE=0x<safe> POSITION_IDS=123,124 npx hardhat run scripts/gen_baseline.ts --network base
    
    # Commit and push baseline
    git add audit/BASELINE.md
    git commit -m "Baseline post-launch"
    git push
    
    # Tag release
    git tag v2025.10.07-prod-launch
    git push --tags
    
    print_status "Baseline generated and release tagged"
}

# Main cutover function
main() {
    log_message "🚀 Starting IDIOT Token Dashboard production cutover..."
    
    # Set trap for emergency rollback on failure
    trap 'emergency_rollback' ERR
    
    # Run all cutover steps
    preflight_check
    deploy_application
    setup_tls
    start_hypercare
    run_smoke_tests
    setup_cron_jobs
    generate_baseline_and_tag
    
    # Success message
    log_message "🎉 Production cutover completed successfully!"
    echo ""
    echo "🔧 Deployment Summary:"
    echo "  ✅ Application deployed and running"
    echo "  ✅ TLS certificates configured"
    echo "  ✅ Hypercare monitoring active"
    echo "  ✅ Smoke tests passed"
    echo "  ✅ Cron jobs configured"
    echo "  ✅ Baseline generated and tagged"
    echo ""
    echo "🌐 Dashboard URL: https://$DOMAIN"
    echo "📊 Health Check: https://$DOMAIN/api/health"
    echo "📈 Pool Data: https://$DOMAIN/api/pool"
    echo ""
    echo "📋 Next Steps:"
    echo "  - Monitor hypercare logs: tail -f $LOG_DIR/hypercare.log"
    echo "  - Check PM2 status: pm2 status"
    echo "  - Verify nginx: systemctl status nginx"
    echo "  - Review alerts and metrics"
    echo ""
    echo "🚨 Emergency Rollback: $PROJECT_DIR/scripts/emergency_rollback.sh"
}

# Run main function
main "$@"
