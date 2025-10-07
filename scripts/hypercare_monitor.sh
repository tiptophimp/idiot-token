#!/bin/bash

# IDIOT Token Dashboard - Hypercare Monitoring (Day 0-1)
# Monitors critical metrics every 1 minute with alerting

set -e

# Configuration
DASHBOARD_URL="https://www.stupidiots.com"
HEALTH_URL="$DASHBOARD_URL/api/health"
POOL_URL="$DASHBOARD_URL/api/pool"
AUDIT_DIR="./audit"
LOG_FILE="$AUDIT_DIR/hypercare_monitor.log"
ALERT_LOG="$AUDIT_DIR/alerts.log"

# Alert thresholds
MAX_5XX_RATE=1.0  # 1% over 5 minutes
LIQUIDITY_THRESHOLD=0
TICK_DRIFT_THRESHOLD=600
RPC_FAILOVER_THRESHOLD=3  # per hour

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Alert counters
declare -A alert_counts
declare -A last_alert_time

# Function to log with timestamp
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S UTC'): $1" | tee -a "$LOG_FILE"
}

# Function to send alert
send_alert() {
    local severity="$1"
    local message="$2"
    local alert_key="$3"
    
    # Rate limit alerts (max 1 per 5 minutes per alert type)
    local current_time=$(date +%s)
    local last_alert=${last_alert_time[$alert_key]:-0}
    local time_diff=$((current_time - last_alert))
    
    if [ $time_diff -lt 300 ]; then
        return 0  # Skip alert due to rate limiting
    fi
    
    last_alert_time[$alert_key]=$current_time
    alert_counts[$alert_key]=$((${alert_counts[$alert_key]:-0} + 1))
    
    log_message "🚨 ALERT [$severity]: $message"
    echo "$(date '+%Y-%m-%d %H:%M:%S UTC'): [$severity] $message" >> "$ALERT_LOG"
    
    # In production, add actual alerting here (email, Slack, PagerDuty, etc.)
    # Example: curl -X POST "$SLACK_WEBHOOK" -d "{\"text\":\"$message\"}"
}

# Function to check health endpoint
check_health() {
    local response=$(curl -s -w "%{http_code}" -o /tmp/health_response.json "$HEALTH_URL" 2>/dev/null || echo "000")
    local status_code="${response: -3}"
    
    if [ "$status_code" = "200" ]; then
        local health_data=$(cat /tmp/health_response.json)
        local overall_status=$(echo "$health_data" | jq -r '.status' 2>/dev/null || echo "unknown")
        
        if [ "$overall_status" = "healthy" ]; then
            log_message "✅ Health check passed"
            return 0
        elif [ "$overall_status" = "degraded" ]; then
            send_alert "WARNING" "Dashboard health degraded" "health_degraded"
            return 1
        else
            send_alert "CRITICAL" "Dashboard health critical: $overall_status" "health_critical"
            return 2
        fi
    else
        send_alert "CRITICAL" "Health endpoint returned $status_code" "health_5xx"
        return 2
    fi
}

# Function to check pool metrics
check_pool_metrics() {
    local response=$(curl -s -w "%{http_code}" -o /tmp/pool_response.json "$POOL_URL" 2>/dev/null || echo "000")
    local status_code="${response: -3}"
    
    if [ "$status_code" = "200" ]; then
        local pool_data=$(cat /tmp/pool_response.json)
        
        # Check liquidity
        local liquidity=$(echo "$pool_data" | jq -r '.liquidity' 2>/dev/null || echo "0")
        if [ "$liquidity" = "0" ]; then
            send_alert "CRITICAL" "Pool liquidity is zero!" "liquidity_zero"
        fi
        
        # Check tick drift
        local tick=$(echo "$pool_data" | jq -r '.tick' 2>/dev/null || echo "0")
        local tick_drift=$(echo "$tick" | sed 's/-//' | cut -d. -f1)
        if [ "$tick_drift" -gt "$TICK_DRIFT_THRESHOLD" ]; then
            send_alert "WARNING" "Tick drift $tick_drift > $TICK_DRIFT_THRESHOLD" "tick_drift"
        fi
        
        # Check TVL
        local tvl=$(echo "$pool_data" | jq -r '.tvl' 2>/dev/null || echo "0")
        log_message "📊 Pool metrics - Liquidity: $liquidity, Tick: $tick, TVL: $tvl"
        
        return 0
    else
        send_alert "CRITICAL" "Pool endpoint returned $status_code" "pool_5xx"
        return 2
    fi
}

# Function to check RPC failover
check_rpc_failover() {
    # This would need to be implemented based on your RPC monitoring setup
    # For now, we'll check if the health endpoint shows RPC issues
    local health_data=$(curl -s "$HEALTH_URL" 2>/dev/null || echo "{}")
    local rpc_status=$(echo "$health_data" | jq -r '.checks.rpc.status' 2>/dev/null || echo "unknown")
    
    if [ "$rpc_status" = "unhealthy" ]; then
        send_alert "WARNING" "RPC health check failed" "rpc_failover"
    fi
}

# Function to capture baseline snapshot
capture_baseline() {
    log_message "📸 Capturing baseline snapshot..."
    
    # Create baseline directory
    mkdir -p "$AUDIT_DIR/baseline"
    
    # Capture pool data
    curl -s "$POOL_URL" > "$AUDIT_DIR/baseline/pool_$(date +%Y%m%d_%H%M%S).json"
    
    # Capture vesting data
    curl -s "$DASHBOARD_URL/api/vesting-wallets" > "$AUDIT_DIR/baseline/vesting_$(date +%Y%m%d_%H%M%S).json"
    
    # Capture health status
    curl -s "$HEALTH_URL" > "$AUDIT_DIR/baseline/health_$(date +%Y%m%d_%H%M%S).json"
    
    # Update BASELINE.md
    cat > "$AUDIT_DIR/BASELINE.md" << EOF
# IDIOT Baseline Attestation - Post-Launch

**Generated at:** $(date -u +%Y-%m-%dT%H:%M:%SZ)  
**Status:** Post-Launch Hypercare  
**Version:** v2025.10.07-prod-cutover-1.1

## System Status
- **Dashboard:** $DASHBOARD_URL
- **Health Endpoint:** $HEALTH_URL
- **Pool Endpoint:** $POOL_URL
- **Monitoring:** Active hypercare monitoring

## Current Metrics
$(curl -s "$POOL_URL" | jq '.' 2>/dev/null || echo "Unable to fetch pool data")

## Vesting Wallets
$(curl -s "$DASHBOARD_URL/api/vesting-wallets" | jq '.' 2>/dev/null || echo "Unable to fetch vesting data")

## Health Status
$(curl -s "$HEALTH_URL" | jq '.' 2>/dev/null || echo "Unable to fetch health data")

## Alert Summary
$(if [ -f "$ALERT_LOG" ]; then tail -20 "$ALERT_LOG"; else echo "No alerts recorded"; fi)

---
*This baseline was captured during post-launch hypercare monitoring.*
EOF

    log_message "✅ Baseline snapshot captured"
}

# Function to check 5xx error rate
check_5xx_rate() {
    # This is a simplified check - in production you'd want more sophisticated monitoring
    local error_count=0
    local total_requests=0
    
    # Check last 5 minutes of logs (simplified)
    if [ -f "$LOG_FILE" ]; then
        local five_min_ago=$(date -d '5 minutes ago' '+%Y-%m-%d %H:%M:%S' 2>/dev/null || date -v-5M '+%Y-%m-%d %H:%M:%S' 2>/dev/null || echo "")
        if [ -n "$five_min_ago" ]; then
            error_count=$(grep -c "5xx\|CRITICAL" "$LOG_FILE" | tail -1 || echo "0")
            total_requests=$(grep -c "Health check\|Pool metrics" "$LOG_FILE" | tail -1 || echo "1")
        fi
    fi
    
    local error_rate=$(echo "scale=2; $error_count * 100 / $total_requests" | bc 2>/dev/null || echo "0")
    
    if (( $(echo "$error_rate > $MAX_5XX_RATE" | bc -l 2>/dev/null || echo "0") )); then
        send_alert "CRITICAL" "5xx error rate $error_rate% > $MAX_5XX_RATE%" "error_rate"
    fi
}

# Main monitoring loop
main() {
    log_message "🚀 Starting hypercare monitoring for $DASHBOARD_URL"
    
    # Create audit directory
    mkdir -p "$AUDIT_DIR"
    
    # Initial baseline capture
    capture_baseline
    
    # Monitoring loop
    local iteration=0
    while true; do
        iteration=$((iteration + 1))
        log_message "🔍 Monitoring iteration $iteration"
        
        # Run all checks
        check_health
        check_pool_metrics
        check_rpc_failover
        check_5xx_rate
        
        # Log current alert counts
        if [ ${#alert_counts[@]} -gt 0 ]; then
            log_message "📊 Alert summary:"
            for alert_type in "${!alert_counts[@]}"; do
                log_message "  - $alert_type: ${alert_counts[$alert_type]} alerts"
            done
        fi
        
        # Sleep for 1 minute
        sleep 60
    done
}

# Handle script interruption
trap 'log_message "🛑 Hypercare monitoring stopped"; exit 0' INT TERM

# Check dependencies
if ! command -v curl &> /dev/null; then
    echo "Error: curl is required but not installed."
    exit 1
fi

if ! command -v jq &> /dev/null; then
    echo "Error: jq is required but not installed."
    exit 1
fi

if ! command -v bc &> /dev/null; then
    echo "Error: bc is required but not installed."
    exit 1
fi

# Run main function
main "$@"
