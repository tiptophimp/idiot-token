# IDIOT Token Dashboard - On-Call SOP

**Emergency Contact:** [Your PagerDuty/Slack Channel]  
**Escalation:** [Team Lead] → [Engineering Manager] → [CTO]  
**Last Updated:** 2025-10-07

## 🚨 **Critical Alerts (Page Immediately)**

| Alert | Threshold | Action | Escalation |
|-------|-----------|--------|------------|
| **Dashboard Down** | 5xx > 1% over 5min | Check `/api/health`, restart PM2 | 15min |
| **Liquidity Zero** | Pool liquidity = 0 | Check pool contract, alert team | 5min |
| **Tick Drift** | \|tick drift\| > 600 | Run `recenter_liquidity.ts` | 30min |
| **RPC Failover** | > 3 times/hour | Switch to backup RPC | 10min |
| **SSL Expiry** | < 7 days | Renew certificate | 1 hour |

## 🔧 **Quick Fixes**

### Dashboard Down
```bash
# Check status
pm2 status
systemctl status idiot-dashboard

# Restart if needed
pm2 restart idiot-dashboard
systemctl restart idiot-dashboard

# Check logs
pm2 logs idiot-dashboard --lines 50
tail -f /var/log/idiot-dashboard/error.log
```

### High Error Rate
```bash
# Check recent errors
grep -i "error\|exception" /var/log/idiot-dashboard/error.log | tail -20

# Check RPC connectivity
curl -s https://mainnet.base.org -X POST -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}'

# Check rate limiting
curl -I https://www.stupidiots.com/api/health
```

### Pool Issues
```bash
# Check pool data
curl -s https://www.stupidiots.com/api/pool | jq '.'

# Run recenter if needed
cd /etc/idiot-dashboard
npx hardhat run scripts/recenter_liquidity.ts --network base
```

## 📊 **Monitoring Commands**

### Health Checks
```bash
# Overall health
curl -s https://www.stupidiots.com/api/health | jq '.'

# Pool metrics
curl -s https://www.stupidiots.com/api/pool | jq '{priceUsd, tvl, tick}'

# Vesting wallets
curl -s https://www.stupidiots.com/api/vesting-wallets | jq '.[0]'
```

### System Resources
```bash
# PM2 status
pm2 monit

# System resources
htop
df -h
free -h

# Nginx status
systemctl status nginx
nginx -t
```

### Logs
```bash
# Application logs
tail -f /var/log/idiot-dashboard/combined.log
tail -f /var/log/idiot-dashboard/error.log

# Nginx logs
tail -f /var/log/nginx/stupidiots.com.error.log
tail -f /var/log/nginx/stupidiots.com.access.log

# System logs
journalctl -u idiot-dashboard -f
```

## 🚨 **Rollback Procedure**

### Emergency Rollback
```bash
# 1. Stop current service
systemctl stop idiot-dashboard
pm2 stop all

# 2. Deploy previous version
cd /etc/idiot-dashboard
git checkout v2025.10.07-prod-cutover-1
npm ci --production

# 3. Restart service
systemctl start idiot-dashboard
pm2 start ecosystem.config.js --env production

# 4. Verify
curl -s https://www.stupidiots.com/api/health | jq '.status'
```

### DNS Rollback (If Needed)
```bash
# Update DNS to point to backup server
# Or use load balancer to route traffic
```

## 📞 **Escalation Tree**

1. **Level 1 (0-15min):** On-call engineer
   - Check alerts, restart services, basic troubleshooting
   
2. **Level 2 (15-30min):** Senior engineer
   - Complex issues, code changes, infrastructure problems
   
3. **Level 3 (30min+):** Engineering manager
   - Major outages, security issues, business impact

## 🔍 **Common Issues & Solutions**

| Issue | Symptoms | Solution |
|-------|----------|----------|
| **Rate Limiting** | 429 errors | Check IP allowlist, adjust limits |
| **RPC Timeout** | Connection refused | Switch to backup RPC |
| **Memory Leak** | High memory usage | Restart PM2, check for leaks |
| **SSL Issues** | Certificate errors | Renew with certbot |
| **Database** | Connection errors | Check RPC endpoints |

## 📋 **Post-Incident**

1. **Document** incident in `audit/incidents/`
2. **Update** runbook with lessons learned
3. **Schedule** post-mortem within 48 hours
4. **Implement** preventive measures

## 🛠️ **Useful Commands**

```bash
# Quick health check
curl -s https://www.stupidiots.com/api/health | jq '.status'

# Check all endpoints
for endpoint in health pool vesting-wallets; do
  echo "Testing $endpoint..."
  curl -s "https://www.stupidiots.com/api/$endpoint" | jq '.status // .pool // .[0].name' 2>/dev/null || echo "Failed"
done

# Monitor in real-time
watch -n 5 'curl -s https://www.stupidiots.com/api/health | jq ".status"'

# Check recent errors
grep -i "error\|exception" /var/log/idiot-dashboard/error.log | tail -10
```

---

**Remember:** When in doubt, escalate. Better to over-communicate than miss a critical issue.
