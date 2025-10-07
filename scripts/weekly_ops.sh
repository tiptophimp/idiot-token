#!/bin/bash

# IDIOT Token Weekly Operations Script
# Run every Sunday at 2 AM UTC
# Usage: ./scripts/weekly_ops.sh

set -e

echo "=== IDIOT Token Weekly Operations - $(date) ==="

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
AUDIT_DIR="$PROJECT_DIR/audit"
LOG_FILE="$AUDIT_DIR/LP_actions.md"

# Ensure audit directory exists
mkdir -p "$AUDIT_DIR"

# Function to log with timestamp
log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S UTC'): $1" | tee -a "$LOG_FILE"
}

# Function to check health endpoint
check_health() {
    local health_url="http://localhost:3000/api/health"
    local status=$(curl -s "$health_url" | jq -r '.status' 2>/dev/null || echo "error")
    
    if [ "$status" = "healthy" ]; then
        echo "✅ Health check passed"
        return 0
    elif [ "$status" = "degraded" ]; then
        echo "⚠️ Health check degraded"
        return 1
    else
        echo "❌ Health check failed"
        return 2
    fi
}

# Function to check liquidity status
check_liquidity() {
    local health_url="http://localhost:3000/api/health"
    local liquidity_status=$(curl -s "$health_url" | jq -r '.checks.liquidity.status' 2>/dev/null || echo "unknown")
    
    if [ "$liquidity_status" = "healthy" ]; then
        echo "✅ Liquidity healthy"
        return 0
    elif [ "$liquidity_status" = "critical" ]; then
        echo "🚨 Liquidity critical - immediate action required"
        return 2
    else
        echo "⚠️ Liquidity status: $liquidity_status"
        return 1
    fi
}

# Function to check tick drift
check_tick_drift() {
    local health_url="http://localhost:3000/api/health"
    local tick_drift=$(curl -s "$health_url" | jq -r '.checks.tickDrift.drift' 2>/dev/null || echo "0")
    
    if [ "$tick_drift" -gt 600 ]; then
        echo "⚠️ Tick drift $tick_drift > 600 - recenter recommended"
        return 1
    else
        echo "✅ Tick drift $tick_drift within acceptable range"
        return 0
    fi
}

# Function to run fee collection
run_fee_collection() {
    echo "🔄 Running fee collection..."
    cd "$PROJECT_DIR"
    
    if [ -f "scripts/cron_collect_fees.ts" ]; then
        npx hardhat run scripts/cron_collect_fees.ts --network base
        log_action "Fee collection completed successfully"
    else
        echo "⚠️ Fee collection script not found"
        log_action "Fee collection script not found - manual review required"
    fi
}

# Function to run recenter if needed
run_recenter_if_needed() {
    local tick_drift=$(curl -s "http://localhost:3000/api/health" | jq -r '.checks.tickDrift.drift' 2>/dev/null || echo "0")
    
    if [ "$tick_drift" -gt 600 ]; then
        echo "🔄 Running liquidity recenter..."
        cd "$PROJECT_DIR"
        
        if [ -f "scripts/recenter_liquidity.ts" ]; then
            npx hardhat run scripts/recenter_liquidity.ts --network base
            log_action "Liquidity recenter completed - tick drift was $tick_drift"
        else
            echo "⚠️ Recenter script not found"
            log_action "Recenter script not found - manual intervention required for tick drift $tick_drift"
        fi
    fi
}

# Function to update baseline if needed
update_baseline_if_needed() {
    echo "🔄 Checking if baseline update is needed..."
    cd "$PROJECT_DIR"
    
    # Check if any LP positions have changed
    local current_positions=$(curl -s "http://localhost:3000/api/pool" | jq -r '.liquidity' 2>/dev/null || echo "0")
    local last_baseline_positions=$(grep "liquidity:" "$AUDIT_DIR/BASELINE.md" 2>/dev/null | head -1 | grep -o '[0-9]*' | tail -1 || echo "0")
    
    if [ "$current_positions" != "$last_baseline_positions" ]; then
        echo "📊 Updating baseline - liquidity changed from $last_baseline_positions to $current_positions"
        
        if [ -f "scripts/gen_baseline.ts" ]; then
            SAFE="0xTR_SAFE" POSITION_IDS="1,2,3" npx hardhat run scripts/gen_baseline.ts --network base
            log_action "Baseline updated - liquidity changed from $last_baseline_positions to $current_positions"
        else
            echo "⚠️ Baseline generator not found"
            log_action "Baseline generator not found - manual update required"
        fi
    else
        echo "✅ Baseline up to date"
    fi
}

# Function to commit weekly changes
commit_weekly_changes() {
    echo "📝 Committing weekly changes..."
    cd "$PROJECT_DIR"
    
    # Add audit files
    git add audit/LP_actions.md audit/BASELINE.md 2>/dev/null || true
    
    # Check if there are changes to commit
    if ! git diff --staged --quiet; then
        git commit -m "Weekly ops: $(date +%Y-%m-%d) - $(git log --oneline -1 | cut -d' ' -f2-)"
        git tag "weekly-$(date +%Y%m%d)"
        git push --tags
        log_action "Weekly changes committed and tagged"
    else
        echo "✅ No changes to commit"
        log_action "No changes to commit this week"
    fi
}

# Main execution
main() {
    log_action "=== Weekly Operations Started ==="
    
    # Check system health
    echo "🔍 Checking system health..."
    check_health
    health_exit_code=$?
    
    # Check liquidity
    echo "🔍 Checking liquidity status..."
    check_liquidity
    liquidity_exit_code=$?
    
    # Check tick drift
    echo "🔍 Checking tick drift..."
    check_tick_drift
    tick_drift_exit_code=$?
    
    # Run fee collection
    run_fee_collection
    
    # Run recenter if needed
    if [ $tick_drift_exit_code -ne 0 ]; then
        run_recenter_if_needed
    fi
    
    # Update baseline if needed
    update_baseline_if_needed
    
    # Commit changes
    commit_weekly_changes
    
    # Final health check
    echo "🔍 Final health check..."
    check_health
    final_health_exit_code=$?
    
    # Summary
    echo ""
    echo "=== Weekly Operations Summary ==="
    echo "Health Status: $([ $final_health_exit_code -eq 0 ] && echo "✅ Healthy" || echo "⚠️ Issues detected")"
    echo "Liquidity Status: $([ $liquidity_exit_code -eq 0 ] && echo "✅ Healthy" || echo "⚠️ Issues detected")"
    echo "Tick Drift: $([ $tick_drift_exit_code -eq 0 ] && echo "✅ Normal" || echo "⚠️ High drift")"
    echo "Log File: $LOG_FILE"
    
    log_action "=== Weekly Operations Completed ==="
    
    # Exit with appropriate code
    if [ $final_health_exit_code -eq 0 ] && [ $liquidity_exit_code -eq 0 ]; then
        exit 0
    else
        exit 1
    fi
}

# Run main function
main "$@"
