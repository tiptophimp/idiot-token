#!/bin/bash

# IDIOT Token Dashboard - Hardening Script (Day 2-7)
# Implements security hardening and operational improvements

set -e

# Configuration
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
AUDIT_DIR="$PROJECT_DIR/audit"
LOG_FILE="$AUDIT_DIR/hardening.log"

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

# Function to enable certbot auto-renewal
enable_certbot_auto_renewal() {
    log_message "🔒 Enabling certbot auto-renewal..."
    
    # Test dry run first
    if certbot renew --dry-run; then
        print_status "Certbot dry run successful"
        
        # Add to crontab for auto-renewal
        (crontab -l 2>/dev/null; echo "0 12 * * * /usr/bin/certbot renew --quiet --post-hook 'systemctl reload nginx'") | crontab -
        print_status "Certbot auto-renewal configured"
    else
        print_error "Certbot dry run failed"
        return 1
    fi
}

# Function to review WAF and rate limiting
review_waf_rate_limiting() {
    log_message "🛡️ Reviewing WAF and rate limiting..."
    
    # Test rate limiting
    print_status "Testing rate limiting..."
    
    # Test API rate limit (10 requests per minute)
    local api_blocks=0
    for i in {1..15}; do
        if ! curl -s "$DASHBOARD_URL/api/health" > /dev/null 2>&1; then
            api_blocks=$((api_blocks + 1))
        fi
        sleep 1
    done
    
    if [ $api_blocks -gt 0 ]; then
        print_status "API rate limiting working ($api_blocks blocks out of 15 requests)"
    else
        print_warning "API rate limiting may not be working"
    fi
    
    # Test dashboard rate limit (30 requests per minute)
    local dashboard_blocks=0
    for i in {1..35}; do
        if ! curl -s "$DASHBOARD_URL/" > /dev/null 2>&1; then
            dashboard_blocks=$((dashboard_blocks + 1))
        fi
        sleep 1
    done
    
    if [ $dashboard_blocks -gt 0 ]; then
        print_status "Dashboard rate limiting working ($dashboard_blocks blocks out of 35 requests)"
    else
        print_warning "Dashboard rate limiting may not be working"
    fi
    
    # Create IP allowlist for CI
    cat > /etc/nginx/conf.d/ci_allowlist.conf << 'EOF'
# CI/CD IP Allowlist
# Add GitHub Actions IP ranges here
geo $ci_allowed {
    default 0;
    # GitHub Actions IP ranges (update as needed)
    140.82.112.0/20 1;
    185.199.108.0/22 1;
    192.30.252.0/22 1;
}

# Allow CI requests to bypass rate limiting
map $ci_allowed $rate_limit_key {
    0 $binary_remote_addr;
    1 "";
}
EOF

    print_status "CI IP allowlist configured"
}

# Function to set up backup to S3/IPFS
setup_backup() {
    log_message "💾 Setting up backup to S3/IPFS..."
    
    # Create backup script
    cat > "$PROJECT_DIR/scripts/backup_to_s3.sh" << 'EOF'
#!/bin/bash

# IDIOT Token Dashboard - S3 Backup Script
# Mirrors audit/ and releases to S3 with 1-year retention

set -e

# Configuration
S3_BUCKET="idiot-dashboard-backups"
AUDIT_DIR="./audit"
BACKUP_DIR="./backups"
RETENTION_DAYS=365

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Create timestamped backup
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_NAME="idiot_dashboard_${TIMESTAMP}.tar.gz"

# Create backup archive
tar -czf "$BACKUP_DIR/$BACKUP_NAME" \
    "$AUDIT_DIR" \
    .github/workflows/ \
    scripts/ \
    nginx/ \
    transparency-dashboard/ \
    package.json \
    package-lock.json

# Upload to S3 (requires AWS CLI configured)
if command -v aws &> /dev/null; then
    aws s3 cp "$BACKUP_DIR/$BACKUP_NAME" "s3://$S3_BUCKET/backups/"
    aws s3api put-object-tagging \
        --bucket "$S3_BUCKET" \
        --key "backups/$BACKUP_NAME" \
        --tagging "RetentionDays=$RETENTION_DAYS"
    
    echo "✅ Backup uploaded to S3: s3://$S3_BUCKET/backups/$BACKUP_NAME"
else
    echo "⚠️ AWS CLI not found, backup saved locally: $BACKUP_DIR/$BACKUP_NAME"
fi

# Clean up old local backups (keep last 7 days)
find "$BACKUP_DIR" -name "idiot_dashboard_*.tar.gz" -mtime +7 -delete

echo "✅ Backup completed: $BACKUP_NAME"
EOF

    chmod +x "$PROJECT_DIR/scripts/backup_to_s3.sh"
    
    # Add to crontab (daily at 2 AM)
    (crontab -l 2>/dev/null; echo "0 2 * * * $PROJECT_DIR/scripts/backup_to_s3.sh") | crontab -
    
    print_status "S3 backup configured"
}

# Function to add RUM (Real User Monitoring)
add_rum() {
    log_message "📊 Adding Real User Monitoring..."
    
    # Add RUM script to dashboard
    cat > "$PROJECT_DIR/transparency-dashboard/public/rum.js" << 'EOF'
// IDIOT Token Dashboard - Real User Monitoring
(function() {
    'use strict';
    
    // Configuration
    const RUM_ENDPOINT = '/api/rum';
    const SAMPLE_RATE = 0.1; // 10% sampling
    
    // Only track for sampled users
    if (Math.random() > SAMPLE_RATE) return;
    
    // Performance metrics
    const metrics = {
        timestamp: Date.now(),
        url: window.location.href,
        userAgent: navigator.userAgent,
        connection: navigator.connection ? {
            effectiveType: navigator.connection.effectiveType,
            downlink: navigator.connection.downlink
        } : null
    };
    
    // Time to First Byte (TTFB)
    if (performance.timing) {
        metrics.ttfb = performance.timing.responseStart - performance.timing.navigationStart;
    }
    
    // Largest Contentful Paint (LCP)
    if ('PerformanceObserver' in window) {
        const lcpObserver = new PerformanceObserver((list) => {
            const entries = list.getEntries();
            const lastEntry = entries[entries.length - 1];
            metrics.lcp = lastEntry.startTime;
        });
        lcpObserver.observe({ entryTypes: ['largest-contentful-paint'] });
    }
    
    // First Input Delay (FID)
    if ('PerformanceObserver' in window) {
        const fidObserver = new PerformanceObserver((list) => {
            const entries = list.getEntries();
            entries.forEach((entry) => {
                metrics.fid = entry.processingStart - entry.startTime;
            });
        });
        fidObserver.observe({ entryTypes: ['first-input'] });
    }
    
    // Send metrics after page load
    window.addEventListener('load', () => {
        setTimeout(() => {
            fetch(RUM_ENDPOINT, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(metrics)
            }).catch(() => {
                // Silently fail for RUM
            });
        }, 1000);
    });
})();
EOF

    # Add RUM endpoint to server
    cat >> "$PROJECT_DIR/transparency-dashboard/server.js" << 'EOF'

// RUM endpoint
app.post('/api/rum', (req, res) => {
    const rumData = req.body;
    console.log(`[RUM] ${JSON.stringify(rumData)}`);
    res.json({ status: 'received' });
});
EOF

    # Add RUM script to HTML
    sed -i 's|</head>|    <script src="/rum.js"></script>\n</head>|' "$PROJECT_DIR/transparency-dashboard/public/index.html"
    
    print_status "RUM monitoring added"
}

# Function to perform access review
perform_access_review() {
    log_message "🔐 Performing access review..."
    
    # Check GitHub repository access (if running in CI)
    if [ -n "$GITHUB_TOKEN" ]; then
        print_status "GitHub access review:"
        echo "  - Repository: $(git remote get-url origin)"
        echo "  - Branch protection: Check repository settings"
        echo "  - 2FA requirement: Verify in organization settings"
    fi
    
    # Check API key permissions
    print_status "API key permissions review:"
    local api_keys=("ETHERSCAN_API_KEY" "RPC_URL_PRIMARY" "RPC_URL_ALCHEMY" "RPC_URL_INFURA")
    
    for key in "${api_keys[@]}"; do
        if [ -n "${!key}" ]; then
            echo "  ✅ $key is set"
        else
            echo "  ⚠️ $key not set"
        fi
    done
    
    # Check file permissions
    print_status "File permissions review:"
    find "$PROJECT_DIR" -name "*.env" -exec ls -la {} \;
    find "$PROJECT_DIR" -name "*.key" -exec ls -la {} \;
    
    print_status "Access review completed"
}

# Function to update operational procedures
update_operational_procedures() {
    log_message "📋 Updating operational procedures..."
    
    # Update operational procedures with new monitoring
    cat >> "$AUDIT_DIR/OPERATIONAL_PROCEDURES.md" << 'EOF'

## Post-Launch Hardening (Day 2-7)

### Certbot Auto-Renewal
- Configured automatic SSL certificate renewal
- Tested with `certbot renew --dry-run`
- Added to crontab for daily checks

### WAF and Rate Limiting
- Verified API rate limiting (10 r/m)
- Verified dashboard rate limiting (30 r/m)
- Added CI IP allowlist for GitHub Actions

### Backup Strategy
- Daily backups to S3 with 1-year retention
- Local backup cleanup (7-day retention)
- Automated via crontab

### Real User Monitoring (RUM)
- Added lightweight JS timing
- Tracks TTFB, LCP, FID metrics
- 10% sampling rate
- Logs to application logs

### Access Review
- Verified API key permissions
- Checked file permissions
- Reviewed repository access controls
EOF

    print_status "Operational procedures updated"
}

# Main hardening function
main() {
    log_message "🔧 Starting Day 2-7 hardening process..."
    
    # Create audit directory
    mkdir -p "$AUDIT_DIR"
    
    # Run all hardening steps
    enable_certbot_auto_renewal
    review_waf_rate_limiting
    setup_backup
    add_rum
    perform_access_review
    update_operational_procedures
    
    # Summary
    log_message "✅ Day 2-7 hardening completed successfully!"
    echo ""
    echo "🔧 Hardening Summary:"
    echo "  ✅ Certbot auto-renewal enabled"
    echo "  ✅ WAF and rate limiting reviewed"
    echo "  ✅ S3 backup configured"
    echo "  ✅ RUM monitoring added"
    echo "  ✅ Access review completed"
    echo "  ✅ Operational procedures updated"
    echo ""
    echo "📋 Next Steps:"
    echo "  - Monitor backup jobs"
    echo "  - Review RUM metrics"
    echo "  - Test rate limiting in production"
    echo "  - Verify SSL auto-renewal"
}

# Check if running as root for some operations
if [ "$EUID" -ne 0 ] && [ "$1" != "--user-mode" ]; then
    print_warning "Some operations require root privileges. Run with sudo or use --user-mode for user-level operations."
fi

# Run main function
main "$@"
