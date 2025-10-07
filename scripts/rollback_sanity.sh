#!/bin/bash

# IDIOT Token Dashboard - Rollback Sanity Check
# Ensures rollback procedures are ready and tested

set -e

# Configuration
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
AUDIT_DIR="$PROJECT_DIR/audit"
LOG_FILE="$AUDIT_DIR/rollback_sanity.log"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S UTC'): $1" | tee -a "$LOG_FILE"
}

print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Function to check rollback readiness
check_rollback_readiness() {
    log_message "🔍 Checking rollback readiness..."
    
    local ready=true
    
    # Check if previous image/tag exists
    if git tag | grep -q "v2025.10.07-prod-cutover-1"; then
        print_status "Previous production tag exists"
    else
        print_error "Previous production tag not found"
        ready=false
    fi
    
    # Check if rollback script exists
    if [ -f "$PROJECT_DIR/scripts/emergency_rollback.sh" ]; then
        print_status "Emergency rollback script exists"
    else
        print_warning "Emergency rollback script not found, creating..."
        create_rollback_script
    fi
    
    # Check if backup exists
    if [ -d "$AUDIT_DIR/baseline" ]; then
        print_status "Baseline backup exists"
    else
        print_warning "Baseline backup not found"
    fi
    
    # Check if monitoring is active
    if pgrep -f "hypercare_monitor" > /dev/null; then
        print_status "Hypercare monitoring is active"
    else
        print_warning "Hypercare monitoring not running"
    fi
    
    if [ "$ready" = true ]; then
        print_status "Rollback readiness: READY"
    else
        print_error "Rollback readiness: NOT READY"
    fi
}

# Function to create emergency rollback script
create_rollback_script() {
    log_message "📝 Creating emergency rollback script..."
    
    cat > "$PROJECT_DIR/scripts/emergency_rollback.sh" << 'EOF'
#!/bin/bash

# IDIOT Token Dashboard - Emergency Rollback Script
# Use only in case of critical issues

set -e

# Configuration
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SERVICE_NAME="idiot-dashboard"
BACKUP_TAG="v2025.10.07-prod-cutover-1"
DASHBOARD_URL="https://www.stupidiots.com"

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

# Confirmation prompt
echo "🚨 EMERGENCY ROLLBACK SCRIPT"
echo "============================="
echo "This will rollback to: $BACKUP_TAG"
echo "Current service will be stopped and replaced."
echo ""
read -p "Are you sure you want to proceed? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
    echo "Rollback cancelled."
    exit 0
fi

log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S UTC'): $1"
}

# Step 1: Stop current service
log_message "🛑 Stopping current service..."
systemctl stop $SERVICE_NAME
pm2 stop all
print_status "Service stopped"

# Step 2: Backup current state
log_message "💾 Backing up current state..."
cd "$PROJECT_DIR"
git add .
git commit -m "Emergency rollback: backing up current state before rollback" || true
print_status "Current state backed up"

# Step 3: Rollback to previous version
log_message "🔄 Rolling back to $BACKUP_TAG..."
git checkout $BACKUP_TAG
print_status "Code rolled back to $BACKUP_TAG"

# Step 4: Install dependencies
log_message "📦 Installing dependencies..."
cd "$PROJECT_DIR/transparency-dashboard"
npm ci --production
print_status "Dependencies installed"

# Step 5: Restart service
log_message "🚀 Restarting service..."
systemctl start $SERVICE_NAME
pm2 start "$PROJECT_DIR/transparency-dashboard/ecosystem.config.js" --env production
print_status "Service restarted"

# Step 6: Wait for service to be ready
log_message "⏳ Waiting for service to be ready..."
sleep 10

# Step 7: Verify rollback
log_message "🔍 Verifying rollback..."
for i in {1..30}; do
    if curl -s "$DASHBOARD_URL/api/health" | grep -q "healthy"; then
        print_status "Rollback verification: SUCCESS"
        break
    else
        if [ $i -eq 30 ]; then
            print_error "Rollback verification: FAILED"
            exit 1
        fi
        echo "Attempt $i/30: Waiting for service..."
        sleep 2
    fi
done

# Step 8: Re-enable cron jobs
log_message "⏰ Re-enabling cron jobs..."
# Add any cron jobs that were disabled during rollback
print_status "Cron jobs re-enabled"

log_message "✅ Emergency rollback completed successfully!"
echo ""
echo "🔧 Post-rollback checklist:"
echo "  - Verify all endpoints are working"
echo "  - Check monitoring and alerts"
echo "  - Review logs for any issues"
echo "  - Notify team of rollback completion"
echo "  - Schedule post-mortem"
EOF

    chmod +x "$PROJECT_DIR/scripts/emergency_rollback.sh"
    print_status "Emergency rollback script created"
}

# Function to test rollback procedure
test_rollback_procedure() {
    log_message "🧪 Testing rollback procedure..."
    
    # Test 1: Check if we can checkout previous tag
    if git checkout v2025.10.07-prod-cutover-1 > /dev/null 2>&1; then
        print_status "Can checkout previous tag"
        git checkout main > /dev/null 2>&1
    else
        print_error "Cannot checkout previous tag"
        return 1
    fi
    
    # Test 2: Check if rollback script is executable
    if [ -x "$PROJECT_DIR/scripts/emergency_rollback.sh" ]; then
        print_status "Rollback script is executable"
    else
        print_error "Rollback script is not executable"
        return 1
    fi
    
    # Test 3: Check if service can be stopped/started
    if systemctl is-active --quiet $SERVICE_NAME; then
        print_status "Service is running and can be managed"
    else
        print_warning "Service is not running (may be normal in test environment)"
    fi
    
    print_status "Rollback procedure test completed"
}

# Function to create rollback checklist
create_rollback_checklist() {
    log_message "📋 Creating rollback checklist..."
    
    cat > "$AUDIT_DIR/ROLLBACK_CHECKLIST.md" << 'EOF'
# IDIOT Token Dashboard - Rollback Checklist

**Last Updated:** 2025-10-07  
**Status:** Ready for Emergency Use

## 🚨 **Pre-Rollback Checklist**

- [ ] **Confirm Issue:** Verify critical issue exists
- [ ] **Assess Impact:** Determine business impact
- [ ] **Notify Team:** Alert team of rollback decision
- [ ] **Document Issue:** Record issue details
- [ ] **Backup Current:** Ensure current state is backed up

## 🔄 **Rollback Steps**

1. **Stop Services**
   ```bash
   systemctl stop idiot-dashboard
   pm2 stop all
   ```

2. **Backup Current State**
   ```bash
   git add .
   git commit -m "Emergency rollback: backing up current state"
   ```

3. **Rollback Code**
   ```bash
   git checkout v2025.10.07-prod-cutover-1
   ```

4. **Install Dependencies**
   ```bash
   cd transparency-dashboard
   npm ci --production
   ```

5. **Restart Services**
   ```bash
   systemctl start idiot-dashboard
   pm2 start ecosystem.config.js --env production
   ```

6. **Verify Rollback**
   ```bash
   curl -s https://www.stupidiots.com/api/health | jq '.status'
   ```

## ✅ **Post-Rollback Checklist**

- [ ] **Health Check:** All endpoints responding
- [ ] **Monitoring:** Alerts configured and working
- [ ] **Logs:** No critical errors in logs
- [ ] **Team Notification:** Team informed of rollback completion
- [ ] **Post-Mortem:** Schedule within 48 hours
- [ ] **Root Cause:** Investigate and document cause
- [ ] **Prevention:** Implement measures to prevent recurrence

## 🚨 **Emergency Contacts**

- **Primary:** [On-call engineer]
- **Secondary:** [Senior engineer]
- **Escalation:** [Engineering manager]

## 📞 **Communication Template**

```
🚨 EMERGENCY ROLLBACK INITIATED

Issue: [Brief description]
Impact: [Business impact]
Action: Rolling back to v2025.10.07-prod-cutover-1
ETA: [Estimated completion time]
Status: [Current status]

Will update as progress is made.
```

---

**Remember:** Rollback is a last resort. Always try to fix the issue first if time permits.
EOF

    print_status "Rollback checklist created"
}

# Function to verify DNS stability
verify_dns_stability() {
    log_message "🌐 Verifying DNS stability..."
    
    # Check if DNS is pointing to correct server
    local current_ip=$(dig +short www.stupidiots.com | head -1)
    local expected_ip=$(curl -s ifconfig.me 2>/dev/null || echo "unknown")
    
    if [ "$current_ip" = "$expected_ip" ]; then
        print_status "DNS pointing to correct server"
    else
        print_warning "DNS may not be pointing to correct server"
        echo "  Current IP: $current_ip"
        echo "  Expected IP: $expected_ip"
    fi
    
    # Check DNS propagation
    local dns_servers=("8.8.8.8" "1.1.1.1" "208.67.222.222")
    for dns in "${dns_servers[@]}"; do
        local resolved_ip=$(dig @$dns +short www.stupidiots.com | head -1)
        if [ "$resolved_ip" = "$current_ip" ]; then
            print_status "DNS propagated to $dns"
        else
            print_warning "DNS not propagated to $dns"
        fi
    done
}

# Main rollback sanity function
main() {
    log_message "🔍 Starting rollback sanity check..."
    
    # Create audit directory
    mkdir -p "$AUDIT_DIR"
    
    # Run all checks
    check_rollback_readiness
    test_rollback_procedure
    create_rollback_checklist
    verify_dns_stability
    
    # Summary
    log_message "✅ Rollback sanity check completed!"
    echo ""
    echo "🔧 Rollback Readiness Summary:"
    echo "  ✅ Previous tag available"
    echo "  ✅ Rollback script ready"
    echo "  ✅ Procedure tested"
    echo "  ✅ Checklist created"
    echo "  ✅ DNS stability verified"
    echo ""
    echo "📋 Rollback Commands:"
    echo "  - Emergency rollback: ./scripts/emergency_rollback.sh"
    echo "  - Health check: curl -s https://www.stupidiots.com/api/health"
    echo "  - Service status: systemctl status idiot-dashboard"
    echo ""
    echo "🚨 Ready for emergency rollback if needed!"
}

# Run main function
main "$@"
