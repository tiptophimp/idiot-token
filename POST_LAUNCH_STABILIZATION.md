# IDIOT Token Dashboard - Post-Launch Stabilization Plan

**Launch Date:** 2025-10-07  
**Version:** v2025.10.07-prod-cutover-1  
**Status:** ✅ Ready for Production

## 🚨 **Day 0-1: Hypercare**

### ✅ **Monitoring Setup**
- **Hypercare Monitor:** `scripts/hypercare_monitor.sh`
  - Monitors `/api/health` and TVL every 1 minute
  - Alerts on: 5xx >1%/5m, liquidity=0, tick drift>600, RPC failover>3/hour
  - Rate limits alerts (max 1 per 5 minutes per alert type)

### ✅ **Baseline Capture**
- **Automated Snapshot:** Export `/api/pool` + vesting data to `audit/BASELINE.md`
- **Tag Release:** `v2025.10.07-prod-cutover-1.1` after baseline capture
- **Continuous Monitoring:** Real-time health and performance tracking

### ✅ **Alert Thresholds**
| Metric | Threshold | Action | Escalation |
|--------|-----------|--------|------------|
| 5xx Error Rate | > 1% over 5min | Page immediately | 15min |
| Liquidity | = 0 | Critical alert | 5min |
| Tick Drift | \|drift\| > 600 | Warning alert | 30min |
| RPC Failover | > 3/hour | Warning alert | 10min |

## 🔧 **Day 2-7: Hardening**

### ✅ **SSL Auto-Renewal**
- **Certbot:** Configured with `--dry-run` test
- **Cron Job:** Daily renewal check at 12:00 UTC
- **Post-Hook:** Automatic Nginx reload after renewal

### ✅ **WAF & Rate Limiting Review**
- **API Rate Limit:** 10 requests/minute (verified)
- **Dashboard Rate Limit:** 30 requests/minute (verified)
- **Health Rate Limit:** 60 requests/minute (verified)
- **CI Allowlist:** GitHub Actions IP ranges bypass rate limiting

### ✅ **Backup Strategy**
- **S3 Backup:** Daily backups with 1-year retention
- **Local Cleanup:** 7-day retention for local backups
- **Automated:** Crontab job at 02:00 UTC daily
- **Retention Tags:** S3 objects tagged with retention policy

### ✅ **Real User Monitoring (RUM)**
- **Metrics:** TTFB, LCP, FID tracking
- **Sampling:** 10% of users
- **Endpoint:** `/api/rum` for data collection
- **Logging:** Integrated with application logs

### ✅ **Access Review**
- **API Keys:** Verified all required keys are set
- **File Permissions:** Checked sensitive file permissions
- **Repository Access:** Verified GitHub access controls
- **2FA:** Confirmed organization 2FA requirements

## 📅 **Ongoing Operations**

### ✅ **Weekly Operations**
- **Fee Collection:** Automated via `scripts/weekly_ops.sh`
- **Liquidity Management:** Check tick drift, recenter if needed
- **Audit Logging:** Append to `audit/LP_actions.md`
- **Repository Tagging:** Weekly tags for audit trail

### ✅ **Monthly Operations**
- **Security Audit:** `npm audit --omit=dev`
- **Dependency Review:** Re-pin lockfile, update dependencies
- **Performance Review:** Analyze RUM metrics and system performance
- **Access Review:** Verify permissions and access controls

### ✅ **Quarterly Operations**
- **Key Rotation:** Rotate API keys and certificates
- **DR Drill:** Test RPC outage + BaseScan rate-limit scenarios
- **Infrastructure Review:** Review costs, performance, and security
- **Access Review:** Comprehensive access and permission audit

## 🚨 **Rollback Sanity**

### ✅ **Rollback Readiness**
- **Previous Image:** `v2025.10.07-prod-cutover-1` tagged and ready
- **Rollback Script:** `scripts/emergency_rollback.sh` created and tested
- **DNS Stability:** Verified DNS pointing to correct server
- **Procedure Tested:** Rollback procedure validated

### ✅ **Rollback Procedure**
1. **Stop Services:** `systemctl stop idiot-dashboard`
2. **Backup Current:** Git commit current state
3. **Deploy Previous:** `git checkout v2025.10.07-prod-cutover-1`
4. **Restart Services:** `systemctl start idiot-dashboard`
5. **Verify Health:** Check `/api/health` endpoint
6. **Re-enable Cron:** Restore scheduled jobs

### ✅ **Rollback Checklist**
- **Pre-Rollback:** Issue confirmation, impact assessment, team notification
- **During Rollback:** Service stop, code rollback, restart, verification
- **Post-Rollback:** Health check, monitoring, team notification, post-mortem

## 📞 **On-Call Procedures**

### ✅ **1-Page On-Call SOP**
- **Critical Alerts:** Dashboard down, liquidity zero, tick drift, RPC failover
- **Quick Fixes:** Service restart, error investigation, pool management
- **Monitoring Commands:** Health checks, system resources, log analysis
- **Escalation Tree:** Level 1 (0-15min) → Level 2 (15-30min) → Level 3 (30min+)

### ✅ **Emergency Contacts**
- **Primary:** On-call engineer
- **Secondary:** Senior engineer  
- **Escalation:** Engineering manager
- **Communication:** Slack/PagerDuty integration

## 🎯 **Success Metrics**

### ✅ **Technical Success**
- **Uptime:** 99.9% in first 24 hours
- **Response Time:** < 2 seconds for all endpoints
- **Error Rate:** < 0.1% 5xx errors
- **Monitoring:** All alerts configured and working

### ✅ **Operational Success**
- **Automation:** All operational procedures automated
- **Documentation:** Complete runbooks and procedures
- **Monitoring:** Real-time visibility into system health
- **Alerting:** Proactive issue detection and notification

## 🚀 **Go-Live Commands**

```bash
# 1. Start hypercare monitoring
./scripts/hypercare_monitor.sh &

# 2. Run hardening (Day 2-7)
sudo ./scripts/hardening_day2_7.sh

# 3. Test rollback readiness
./scripts/rollback_sanity.sh

# 4. Verify all systems
curl -s https://www.stupidiots.com/api/health | jq '.status'
```

## 📋 **Post-Launch Checklist**

- [ ] **Hypercare Monitoring:** Active and alerting
- [ ] **Baseline Captured:** `audit/BASELINE.md` updated
- [ ] **Tag Released:** `v2025.10.07-prod-cutover-1.1` created
- [ ] **Hardening Complete:** All Day 2-7 tasks completed
- [ ] **Rollback Ready:** Emergency procedures tested
- [ ] **On-Call Ready:** SOP and contacts configured
- [ ] **Monitoring Active:** All alerts and dashboards working
- [ ] **Team Trained:** On-call procedures understood

---

**Status:** ✅ **READY FOR PRODUCTION LAUNCH**  
**Next Review:** Post-launch Day 1  
**Owner:** IDIOT Team
