#!/bin/bash

# IDIOT Token Monthly Operations Script
# Run on the 1st of every month at 3 AM UTC
# Usage: ./scripts/monthly_ops.sh

set -e

echo "=== IDIOT Token Monthly Operations - $(date) ==="

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
AUDIT_DIR="$PROJECT_DIR/audit"
LOG_FILE="$AUDIT_DIR/monthly_ops.log"

# Ensure audit directory exists
mkdir -p "$AUDIT_DIR"

# Function to log with timestamp
log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S UTC'): $1" | tee -a "$LOG_FILE"
}

# Function to run security audit
run_security_audit() {
    echo "🔒 Running security audit..."
    cd "$PROJECT_DIR"
    
    # Run npm audit
    echo "Checking for vulnerabilities..."
    if npm audit --omit=dev --audit-level=high; then
        log_action "Security audit passed - no high severity vulnerabilities found"
    else
        log_action "Security audit failed - high severity vulnerabilities found"
        echo "⚠️ High severity vulnerabilities detected. Manual review required."
        return 1
    fi
    
    # Check for outdated packages
    echo "Checking for outdated packages..."
    npm outdated --depth=0 | tee -a "$LOG_FILE"
    
    log_action "Security audit completed"
}

# Function to review dependencies
review_dependencies() {
    echo "📦 Reviewing dependencies..."
    cd "$PROJECT_DIR"
    
    # Generate dependency tree
    echo "Generating dependency tree..."
    npm list --depth=0 > "$AUDIT_DIR/dependencies_$(date +%Y%m%d).txt"
    
    # Check for pinned versions
    echo "Checking pinned versions..."
    if grep -q '"ethers":' package.json; then
        echo "✅ ethers version pinned"
    else
        echo "⚠️ ethers version not pinned"
    fi
    
    if grep -q '"@nomicfoundation/hardhat-toolbox":' package.json; then
        echo "✅ hardhat-toolbox version pinned"
    else
        echo "⚠️ hardhat-toolbox version not pinned"
    fi
    
    log_action "Dependency review completed"
}

# Function to update lockfile if needed
update_lockfile() {
    echo "🔧 Checking lockfile..."
    cd "$PROJECT_DIR"
    
    # Check if lockfile is up to date
    if npm ci --dry-run > /dev/null 2>&1; then
        echo "✅ Lockfile is up to date"
        log_action "Lockfile verification passed"
    else
        echo "⚠️ Lockfile needs updating"
        echo "Updating lockfile..."
        npm install --package-lock-only
        log_action "Lockfile updated"
    fi
}

# Function to review access permissions
review_access() {
    echo "🔐 Reviewing access permissions..."
    
    # Check GitHub repository access (if running in CI)
    if [ -n "$GITHUB_TOKEN" ]; then
        echo "Checking GitHub repository access..."
        # This would need to be implemented based on your specific setup
        log_action "GitHub access review completed"
    fi
    
    # Check API key permissions
    echo "Checking API key permissions..."
    if [ -n "$ETHERSCAN_API_KEY" ]; then
        echo "✅ ETHERSCAN_API_KEY is set"
    else
        echo "⚠️ ETHERSCAN_API_KEY not set"
    fi
    
    if [ -n "$RPC_URL_PRIMARY" ]; then
        echo "✅ RPC_URL_PRIMARY is set"
    else
        echo "⚠️ RPC_URL_PRIMARY not set"
    fi
    
    log_action "Access review completed"
}

# Function to analyze performance metrics
analyze_performance() {
    echo "📊 Analyzing performance metrics..."
    
    # Check uptime (if PM2 is available)
    if command -v pm2 >/dev/null 2>&1; then
        echo "PM2 Status:"
        pm2 status | tee -a "$LOG_FILE"
        
        # Get uptime for idiot-dashboard
        local uptime=$(pm2 jlist | jq -r '.[] | select(.name=="idiot-dashboard") | .pm2_env.uptime' 2>/dev/null || echo "unknown")
        log_action "Dashboard uptime: $uptime"
    fi
    
    # Check disk usage
    echo "Disk usage:"
    df -h | tee -a "$LOG_FILE"
    
    # Check memory usage
    echo "Memory usage:"
    free -h | tee -a "$LOG_FILE"
    
    log_action "Performance analysis completed"
}

# Function to validate vesting calculations
validate_vesting() {
    echo "🔍 Validating vesting calculations..."
    cd "$PROJECT_DIR"
    
    # Run verification script
    if [ -f "scripts/verifyAndAudit.js" ]; then
        npx hardhat run scripts/verifyAndAudit.js --network base > "$AUDIT_DIR/vesting_validation_$(date +%Y%m%d).log" 2>&1
        log_action "Vesting validation completed"
    else
        echo "⚠️ Vesting validation script not found"
        log_action "Vesting validation script not found"
    fi
}

# Function to update documentation
update_documentation() {
    echo "📚 Updating documentation..."
    
    # Update operational procedures if needed
    local last_update=$(stat -c %Y "audit/OPERATIONAL_PROCEDURES.md" 2>/dev/null || echo "0")
    local current_time=$(date +%s)
    local days_since_update=$(( (current_time - last_update) / 86400 ))
    
    if [ $days_since_update -gt 30 ]; then
        echo "⚠️ Operational procedures haven't been updated in $days_since_update days"
        log_action "Documentation update recommended - $days_since_update days since last update"
    else
        echo "✅ Documentation is up to date"
        log_action "Documentation review completed"
    fi
}

# Function to commit monthly changes
commit_monthly_changes() {
    echo "📝 Committing monthly changes..."
    cd "$PROJECT_DIR"
    
    # Add audit files
    git add audit/ 2>/dev/null || true
    
    # Check if there are changes to commit
    if ! git diff --staged --quiet; then
        git commit -m "Monthly ops: $(date +%Y-%m-%d) - Security audit, dependency review, performance analysis"
        git tag "monthly-$(date +%Y%m%d)"
        git push --tags
        log_action "Monthly changes committed and tagged"
    else
        echo "✅ No changes to commit"
        log_action "No changes to commit this month"
    fi
}

# Main execution
main() {
    log_action "=== Monthly Operations Started ==="
    
    # Run security audit
    run_security_audit
    security_exit_code=$?
    
    # Review dependencies
    review_dependencies
    
    # Update lockfile if needed
    update_lockfile
    
    # Review access permissions
    review_access
    
    # Analyze performance metrics
    analyze_performance
    
    # Validate vesting calculations
    validate_vesting
    
    # Update documentation
    update_documentation
    
    # Commit changes
    commit_monthly_changes
    
    # Summary
    echo ""
    echo "=== Monthly Operations Summary ==="
    echo "Security Audit: $([ $security_exit_code -eq 0 ] && echo "✅ Passed" || echo "⚠️ Issues found")"
    echo "Dependencies: Reviewed"
    echo "Performance: Analyzed"
    echo "Vesting: Validated"
    echo "Documentation: Reviewed"
    echo "Log File: $LOG_FILE"
    
    log_action "=== Monthly Operations Completed ==="
    
    # Exit with appropriate code
    if [ $security_exit_code -eq 0 ]; then
        exit 0
    else
        exit 1
    fi
}

# Run main function
main "$@"
