# IDIOT Token Operational Procedures

**Last Updated:** 2025-10-07  
**Version:** v2025.10.07-prod  
**Status:** Production Ready

## 🚨 Emergency Contacts & Escalation

### Critical Issues (Liquidity = 0, RPC Failover >3x/hour)
1. **Immediate Response:** Check `/api/health` endpoint
2. **Escalate:** Notify team via Discord/Slack
3. **Action:** Run `recenter_liquidity.ts` if tick drift > 600
4. **Document:** Log all actions in `audit/LP_actions.md`

### Degraded Service (Time sync issues, partial RPC failures)
1. **Monitor:** Check time sync status and RPC health
2. **Investigate:** Review logs for root cause
3. **Mitigate:** Switch to backup RPC if needed
4. **Document:** Update status page and logs

## 📅 Weekly Operations

### Fee Collection (Every Sunday 2 AM UTC)
```bash
# Run automated fee collection
cd /c/idiot
npx hardhat run scripts/cron_collect_fees.ts --network base

# Log results
echo "$(date): Fee collection completed" >> audit/LP_actions.md
```

### Liquidity Management Check
```bash
# Check current pool status
curl -s http://localhost:3000/api/health | jq '.checks.liquidity'

# If tick drift > 600, run recenter
npx hardhat run scripts/recenter_liquidity.ts --network base
```

### Repository Maintenance
```bash
# Tag weekly operations
git add audit/LP_actions.md
git commit -m "Weekly ops: $(date +%Y-%m-%d)"
git tag "weekly-$(date +%Y%m%d)"
git push --tags
```

## 📅 Monthly Operations

### Security Audit
```bash
# Run dependency audit
npm audit --omit=dev

# Review and update pinned versions
npm list --depth=0

# Update lockfile if needed
npm install --package-lock-only
```

### Access Review
- [ ] Review GitHub repository access
- [ ] Check API key permissions
- [ ] Verify Safe multisig signers
- [ ] Update documentation

### Performance Review
- [ ] Analyze uptime metrics
- [ ] Review RPC usage patterns
- [ ] Check time sync accuracy
- [ ] Validate vesting calculations

## 📅 Quarterly Operations

### Key Rotation
```bash
# Rotate ETHERSCAN_API_KEY
# Update .env and GitHub Secrets
# Test verification with new key
npx hardhat run scripts/verifyAndAudit.js --network base
```

### Disaster Recovery Drill
1. **Simulate RPC Outage:**
   - Disable primary RPC
   - Verify failover to backup
   - Test time sync resilience

2. **Simulate BaseScan Rate Limit:**
   - Test verification with rate-limited key
   - Verify graceful degradation
   - Check audit logging

3. **Document Results:**
   - Update DR procedures
   - Record lessons learned
   - Update runbooks

### Infrastructure Review
- [ ] Review hosting costs and performance
- [ ] Check backup and retention policies
- [ ] Validate monitoring alerts
- [ ] Update operational procedures

## 🔧 Monitoring & Alerts

### Health Check Endpoints
- **Primary:** `GET /api/health`
- **Status:** `GET /api/status`
- **Pool:** `GET /api/pool`

### Alert Thresholds
- **Critical:** Liquidity = 0
- **Warning:** Tick drift > 600
- **Warning:** RPC failover > 3x/hour
- **Warning:** Time sync circuit breaker open

### Monitoring Setup
```bash
# Example monitoring script
#!/bin/bash
HEALTH_URL="http://localhost:3000/api/health"
STATUS=$(curl -s $HEALTH_URL | jq -r '.status')

if [ "$STATUS" = "critical" ]; then
    echo "ALERT: System status is CRITICAL"
    # Send notification
fi
```

## 📊 Baseline Maintenance

### After Any LP Changes
```bash
# Regenerate baseline
SAFE="0xTR_SAFE" POSITION_IDS="1,2,3" npx hardhat run scripts/gen_baseline.ts --network base

# Commit changes
git add audit/BASELINE.md
git commit -m "Update baseline: $(date +%Y-%m-%d)"
```

### After Vesting Moves
```bash
# Verify vesting wallets
npx hardhat run scripts/verifyAndAudit.js --network base

# Update baseline if needed
# (run baseline generator)
```

## 🚀 Deployment Procedures

### Production Deployment
1. **Pre-deployment:**
   - Run full test suite
   - Verify all health checks
   - Check time sync accuracy

2. **Deployment:**
   - Tag with production version
   - Deploy to production environment
   - Verify all endpoints

3. **Post-deployment:**
   - Monitor health for 24 hours
   - Verify all integrations
   - Update documentation

### Rollback Procedures
1. **Identify Issue:**
   - Check health endpoints
   - Review logs
   - Determine scope

2. **Execute Rollback:**
   - Revert to previous tag
   - Restore from backup if needed
   - Verify system health

3. **Document:**
   - Record incident details
   - Update procedures
   - Conduct post-mortem

## 📋 Checklist Templates

### Pre-Production Checklist
- [ ] All tests passing
- [ ] Health checks green
- [ ] Time sync accurate
- [ ] Dependencies audited
- [ ] Documentation updated
- [ ] Monitoring configured
- [ ] Backup procedures tested

### Post-Incident Checklist
- [ ] Root cause identified
- [ ] Fix implemented
- [ ] Monitoring updated
- [ ] Procedures revised
- [ ] Team notified
- [ ] Documentation updated
- [ ] Follow-up scheduled

---

**Note:** This document should be reviewed and updated monthly. All operational changes must be documented and approved by the team.
