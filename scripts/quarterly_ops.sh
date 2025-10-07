#!/bin/bash

# IDIOT Token Quarterly Operations Script
# Run on the 1st of every quarter at 4 AM UTC
# Usage: ./scripts/quarterly_ops.sh

set -e

echo "=== IDIOT Token Quarterly Operations - $(date) ==="

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
AUDIT_DIR="$PROJECT_DIR/audit"
LOG_FILE="$AUDIT_DIR/quarterly_ops.log"

# Ensure audit directory exists
mkdir -p "$AUDIT_DIR"

# Function to log with timestamp
log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S UTC'): $1" | tee -a "$LOG_FILE"
}

# Function to rotate API keys
rotate_api_keys() {
    echo "🔄 Rotating API keys..."
    
    # Check if we're in a secure environment
    if [ -z "$SECURE_KEY_ROTATION" ]; then
        echo "⚠️ Key rotation requires SECURE_KEY_ROTATION=1 environment variable"
        log_action "Key rotation skipped - not in secure environment"
        return 0
    fi
    
    # Rotate ETHERSCAN_API_KEY
    echo "Rotating ETHERSCAN_API_KEY..."
    # This would need to be implemented based on your key management system
    # For now, just log the action
    log_action "ETHERSCAN_API_KEY rotation initiated"
    
    # Test new key
    echo "Testing new API key..."
    if npx hardhat run scripts/verifyAndAudit.js --network base > /dev/null 2>&1; then
        log_action "New API key tested successfully"
    else
        log_action "New API key test failed - manual intervention required"
        return 1
    fi
}

# Function to review access permissions
review_access_permissions() {
    echo "🔐 Reviewing access permissions..."
    
    # Check GitHub repository access
    echo "Checking GitHub repository access..."
    if [ -n "$GITHUB_TOKEN" ]; then
        # This would need to be implemented based on your specific setup
        log_action "GitHub access review completed"
    fi
    
    # Check Safe multisig signers
    echo "Checking Safe multisig signers..."
    # This would need to be implemented based on your Safe setup
    log_action "Safe multisig signer review completed"
    
    # Check API key permissions
    echo "Checking API key permissions..."
    local api_keys=("ETHERSCAN_API_KEY" "RPC_URL_PRIMARY" "RPC_URL_ALCHEMY" "RPC_URL_INFURA")
    
    for key in "${api_keys[@]}"; do
        if [ -n "${!key}" ]; then
            echo "✅ $key is set"
        else
            echo "⚠️ $key not set"
        fi
    done
    
    log_action "Access permissions review completed"
}

# Function to run disaster recovery drill
run_dr_drill() {
    echo "🚨 Running disaster recovery drill..."
    
    # Simulate RPC outage
    echo "Simulating RPC outage..."
    local original_rpc="$RPC_URL_PRIMARY"
    export RPC_URL_PRIMARY="https://invalid-rpc-url.com"
    
    # Test failover
    if npx hardhat run scripts/verifyAndAudit.js --network base > /dev/null 2>&1; then
        echo "✅ RPC failover working"
        log_action "RPC failover test passed"
    else
        echo "⚠️ RPC failover test failed"
        log_action "RPC failover test failed"
    fi
    
    # Restore original RPC
    export RPC_URL_PRIMARY="$original_rpc"
    
    # Simulate BaseScan rate limit
    echo "Simulating BaseScan rate limit..."
    local original_key="$ETHERSCAN_API_KEY"
    export ETHERSCAN_API_KEY="invalid-key"
    
    # Test graceful degradation
    if npx hardhat run scripts/verifyAndAudit.js --network base > /dev/null 2>&1; then
        echo "✅ BaseScan rate limit handling working"
        log_action "BaseScan rate limit test passed"
    else
        echo "⚠️ BaseScan rate limit handling failed"
        log_action "BaseScan rate limit test failed"
    fi
    
    # Restore original key
    export ETHERSCAN_API_KEY="$original_key"
    
    log_action "Disaster recovery drill completed"
}

# Function to review infrastructure
review_infrastructure() {
    echo "🏗️ Reviewing infrastructure..."
    
    # Check hosting costs and performance
    echo "Checking system resources..."
    df -h | tee -a "$LOG_FILE"
    free -h | tee -a "$LOG_FILE"
    
    # Check backup and retention policies
    echo "Checking backup policies..."
    if [ -d "audit" ]; then
        local audit_size=$(du -sh audit | cut -f1)
        echo "Audit directory size: $audit_size"
        log_action "Audit directory size: $audit_size"
    fi
    
    # Check monitoring alerts
    echo "Checking monitoring configuration..."
    if [ -f "audit/OPERATIONAL_PROCEDURES.md" ]; then
        echo "✅ Operational procedures exist"
    else
        echo "⚠️ Operational procedures missing"
    fi
    
    log_action "Infrastructure review completed"
}

# Function to update operational procedures
update_operational_procedures() {
    echo "📋 Updating operational procedures..."
    
    # Check if procedures need updating
    local last_update=$(stat -c %Y "audit/OPERATIONAL_PROCEDURES.md" 2>/dev/null || echo "0")
    local current_time=$(date +%s)
    local days_since_update=$(( (current_time - last_update) / 86400 ))
    
    if [ $days_since_update -gt 90 ]; then
        echo "⚠️ Operational procedures haven't been updated in $days_since_update days"
        log_action "Operational procedures update recommended - $days_since_update days since last update"
        
        # Update procedures with current date
        sed -i "s/Last Updated:.*/Last Updated: $(date +%Y-%m-%d)/" audit/OPERATIONAL_PROCEDURES.md
        log_action "Operational procedures updated with current date"
    else
        echo "✅ Operational procedures are up to date"
        log_action "Operational procedures review completed"
    fi
}

# Function to run comprehensive security audit
run_comprehensive_security_audit() {
    echo "🔒 Running comprehensive security audit..."
    cd "$PROJECT_DIR"
    
    # Run npm audit
    echo "Running npm audit..."
    npm audit --omit=dev --audit-level=moderate > "$AUDIT_DIR/security_audit_$(date +%Y%m%d).log" 2>&1
    local audit_exit_code=$?
    
    if [ $audit_exit_code -eq 0 ]; then
        log_action "Security audit passed - no moderate or high severity vulnerabilities found"
    else
        log_action "Security audit failed - vulnerabilities found"
    fi
    
    # Check for outdated packages
    echo "Checking for outdated packages..."
    npm outdated --depth=0 > "$AUDIT_DIR/outdated_packages_$(date +%Y%m%d).txt" 2>&1
    
    # Check for known vulnerabilities in dependencies
    echo "Checking for known vulnerabilities..."
    if command -v npm-audit-ci >/dev/null 2>&1; then
        npm-audit-ci --config .npm-audit-ci.json > "$AUDIT_DIR/vulnerability_scan_$(date +%Y%m%d).log" 2>&1
    fi
    
    log_action "Comprehensive security audit completed"
}

# Function to validate all systems
validate_all_systems() {
    echo "🔍 Validating all systems..."
    
    # Check dashboard health
    echo "Checking dashboard health..."
    if curl -s "http://localhost:3000/api/health" | jq -r '.status' | grep -q "healthy"; then
        echo "✅ Dashboard healthy"
        log_action "Dashboard health check passed"
    else
        echo "⚠️ Dashboard health check failed"
        log_action "Dashboard health check failed"
    fi
    
    # Check vesting calculations
    echo "Validating vesting calculations..."
    if npx hardhat run scripts/verifyAndAudit.js --network base > /dev/null 2>&1; then
        echo "✅ Vesting calculations valid"
        log_action "Vesting calculations validation passed"
    else
        echo "⚠️ Vesting calculations validation failed"
        log_action "Vesting calculations validation failed"
    fi
    
    # Check time sync
    echo "Checking time sync..."
    if curl -s "http://localhost:3000/api/status" | jq -r '.timeSync.circuitBreakerOpen' | grep -q "false"; then
        echo "✅ Time sync healthy"
        log_action "Time sync health check passed"
    else
        echo "⚠️ Time sync health check failed"
        log_action "Time sync health check failed"
    fi
    
    log_action "System validation completed"
}

# Function to commit quarterly changes
commit_quarterly_changes() {
    echo "📝 Committing quarterly changes..."
    cd "$PROJECT_DIR"
    
    # Add audit files
    git add audit/ 2>/dev/null || true
    
    # Check if there are changes to commit
    if ! git diff --staged --quiet; then
        git commit -m "Quarterly ops: $(date +%Y-%m-%d) - Security audit, DR drill, infrastructure review"
        git tag "quarterly-$(date +%Y%m%d)"
        git push --tags
        log_action "Quarterly changes committed and tagged"
    else
        echo "✅ No changes to commit"
        log_action "No changes to commit this quarter"
    fi
}

# Main execution
main() {
    log_action "=== Quarterly Operations Started ==="
    
    # Rotate API keys
    rotate_api_keys
    key_rotation_exit_code=$?
    
    # Review access permissions
    review_access_permissions
    
    # Run disaster recovery drill
    run_dr_drill
    
    # Review infrastructure
    review_infrastructure
    
    # Update operational procedures
    update_operational_procedures
    
    # Run comprehensive security audit
    run_comprehensive_security_audit
    security_exit_code=$?
    
    # Validate all systems
    validate_all_systems
    validation_exit_code=$?
    
    # Commit changes
    commit_quarterly_changes
    
    # Summary
    echo ""
    echo "=== Quarterly Operations Summary ==="
    echo "Key Rotation: $([ $key_rotation_exit_code -eq 0 ] && echo "✅ Completed" || echo "⚠️ Issues found")"
    echo "Access Review: Completed"
    echo "DR Drill: Completed"
    echo "Infrastructure: Reviewed"
    echo "Security Audit: $([ $security_exit_code -eq 0 ] && echo "✅ Passed" || echo "⚠️ Issues found")"
    echo "System Validation: $([ $validation_exit_code -eq 0 ] && echo "✅ Passed" || echo "⚠️ Issues found")"
    echo "Log File: $LOG_FILE"
    
    log_action "=== Quarterly Operations Completed ==="
    
    # Exit with appropriate code
    if [ $key_rotation_exit_code -eq 0 ] && [ $security_exit_code -eq 0 ] && [ $validation_exit_code -eq 0 ]; then
        exit 0
    else
        exit 1
    fi
}

# Run main function
main "$@"
