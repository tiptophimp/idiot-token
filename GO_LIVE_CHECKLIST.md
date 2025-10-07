# IDIOT Token Dashboard - Go-Live Checklist

**Target:** www.stupidiots.com  
**Date:** 2025-10-07  
**Version:** v2025.10.07-prod-cutover-1

## 🚀 **Pre-Deployment**

### ✅ **DNS Configuration**
- [ ] **Apex Domain:** Set ALIAS/ANAME or A record to your host target
- [ ] **WWW Subdomain:** Set CNAME → your app host
- [ ] **TTL:** Set to 300s during cutover
- [ ] **Propagation:** Verify DNS propagation with `dig www.stupidiots.com`

### ✅ **SSL/TLS Setup**
- [ ] **Certificate:** Obtain SSL certificate (Let's Encrypt recommended)
- [ ] **Force HTTPS:** Configure redirect from HTTP to HTTPS
- [ ] **HSTS:** Set `max-age=31536000; includeSubDomains; preload`
- [ ] **CSP:** Configure Content Security Policy
- [ ] **Security Headers:** Add X-Content-Type-Options, Referrer-Policy

### ✅ **Server Preparation**
- [ ] **Server:** Provision production server
- [ ] **OS:** Ubuntu 20.04+ or similar
- [ ] **Resources:** Minimum 2GB RAM, 2 CPU cores
- [ ] **Firewall:** Configure UFW with ports 22, 80, 443, 3000
- [ ] **Monitoring:** Set up basic monitoring

## 🔧 **Deployment**

### ✅ **Application Deployment**
- [ ] **Code:** Deploy latest code to production server
- [ ] **Dependencies:** Install Node.js 20+, PM2, Nginx
- [ ] **Environment:** Configure production environment variables
- [ ] **PM2:** Start application with PM2
- [ ] **Nginx:** Configure reverse proxy

### ✅ **Configuration Files**
- [ ] **Nginx:** Deploy `nginx/stupidiots.com.conf`
- [ ] **PM2:** Configure `ecosystem.config.js`
- [ ] **Environment:** Set up `.env` with production values
- [ ] **Logs:** Configure log rotation

### ✅ **Security Hardening**
- [ ] **Firewall:** Enable UFW with proper rules
- [ ] **Fail2ban:** Configure for Nginx protection
- [ ] **SSL:** Verify certificate installation
- [ ] **Headers:** Test security headers
- [ ] **Rate Limiting:** Verify rate limiting works

## 🧪 **Testing**

### ✅ **Smoke Tests**
```bash
# Run comprehensive smoke tests
./scripts/smoke_tests.sh

# Individual tests
curl -sS https://www.stupidiots.com/api/health
curl -sS https://www.stupidiots.com/api/pool
curl -sS https://www.stupidiots.com/api/dashboard
curl -I https://www.stupidiots.com
```

### ✅ **Functional Tests**
- [ ] **Health Endpoint:** Returns healthy status
- [ ] **Pool Data:** Shows correct price, reserves, TVL
- [ ] **Vesting Wallets:** Displays all 4 wallets correctly
- [ ] **Dashboard:** Main page loads without errors
- [ ] **API Endpoints:** All endpoints respond correctly

### ✅ **Performance Tests**
- [ ] **Response Time:** < 2 seconds for all endpoints
- [ ] **Load Test:** Handle 100+ concurrent requests
- [ ] **Memory Usage:** Stable memory consumption
- [ ] **CPU Usage:** Normal CPU utilization

### ✅ **Security Tests**
- [ ] **HTTPS Redirect:** HTTP redirects to HTTPS
- [ ] **Security Headers:** All headers present
- [ ] **Rate Limiting:** Blocks excessive requests
- [ ] **TLS Grade:** A+ rating on SSL Labs

## 📊 **Monitoring Setup**

### ✅ **Uptime Monitoring**
- [ ] **Service:** Configure external monitoring (UptimeRobot, Pingdom)
- [ ] **URL:** `https://www.stupidiots.com/api/health`
- [ ] **Interval:** Every 60 seconds
- [ ] **Alerts:** Email/SMS on failures

### ✅ **Alert Thresholds**
- [ ] **Liquidity = 0:** Critical alert
- [ ] **Tick drift > 600:** Warning alert
- [ ] **RPC failover > 3/hour:** Warning alert
- [ ] **5xx errors > 1% over 5min:** Critical alert

### ✅ **Log Management**
- [ ] **Rotation:** Configure log rotation (30-90 days retention)
- [ ] **Monitoring:** Set up log monitoring
- [ ] **Alerts:** Configure log-based alerts

## 🔄 **Post-Deployment**

### ✅ **DNS Optimization**
- [ ] **TTL Increase:** Raise DNS TTL to 3600-14400 after validation
- [ ] **Propagation:** Verify DNS changes propagated globally
- [ ] **CDN:** Consider CDN setup for better performance

### ✅ **Release Tagging**
```bash
# Tag the cutover release
git tag v2025.10.07-prod-cutover-1
git push --tags
```

### ✅ **Documentation**
- [ ] **Addresses:** Publish pool, token, Safe, vesting addresses
- [ ] **BaseScan Links:** Add links to BaseScan for all contracts
- [ ] **API Docs:** Document API endpoints
- [ ] **Monitoring:** Document monitoring setup

### ✅ **Team Notification**
- [ ] **Announcement:** Notify team of go-live
- [ ] **Monitoring:** Share monitoring dashboard access
- [ ] **Escalation:** Provide escalation procedures
- [ ] **Documentation:** Share operational procedures

## 🚨 **Rollback Plan**

### ✅ **Rollback Triggers**
- [ ] **Critical Issues:** System down, data corruption
- [ ] **Security Issues:** Breach, vulnerability exposure
- [ ] **Performance Issues:** Unacceptable response times
- [ ] **Data Issues:** Incorrect calculations, missing data

### ✅ **Rollback Procedure**
1. **Stop Services:** `systemctl stop idiot-dashboard`
2. **Revert Code:** Deploy previous stable version
3. **Restart Services:** `systemctl start idiot-dashboard`
4. **Verify:** Run smoke tests
5. **Communicate:** Notify team of rollback

## 📋 **Success Criteria**

### ✅ **Technical Success**
- [ ] All smoke tests pass
- [ ] Response times < 2 seconds
- [ ] 99.9% uptime in first 24 hours
- [ ] No critical errors in logs
- [ ] All monitoring alerts configured

### ✅ **Business Success**
- [ ] Dashboard accessible to public
- [ ] All vesting data accurate
- [ ] Pool data real-time and correct
- [ ] Security standards met
- [ ] Performance requirements met

## 🎯 **Go-Live Commands**

```bash
# 1. Deploy to production
sudo ./scripts/deploy_production.sh

# 2. Configure SSL
sudo certbot --nginx -d www.stupidiots.com -d stupidiots.com

# 3. Run smoke tests
./scripts/smoke_tests.sh

# 4. Tag release
git tag v2025.10.07-prod-cutover-1
git push --tags

# 5. Monitor for 24 hours
pm2 monit
tail -f /var/log/idiot-dashboard/combined.log
```

---

**Status:** ✅ Ready for Go-Live  
**Next Review:** Post-deployment validation  
**Owner:** IDIOT Team
