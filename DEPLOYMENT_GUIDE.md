# IDIOT Token Dashboard - Production Deployment Guide

**Target:** www.stupidiots.com  
**Version:** v2025.10.07-prod  
**Status:** Ready for Production

## 🎯 Deployment Overview

This guide covers deploying the IDIOT Token Transparency Dashboard to www.stupidiots.com with full production hardening, monitoring, and operational procedures.

## 📋 Pre-Deployment Checklist

### ✅ System Requirements
- [ ] Node.js 20+ installed
- [ ] PM2 process manager installed
- [ ] Nginx or Apache configured
- [ ] SSL certificate ready
- [ ] Domain DNS configured
- [ ] Environment variables set

### ✅ Security Hardening
- [ ] All dependencies audited (`npm audit --omit=dev`)
- [ ] Environment variables secured
- [ ] API keys rotated and secured
- [ ] Firewall rules configured
- [ ] Rate limiting enabled

### ✅ Monitoring Setup
- [ ] Health check endpoints configured
- [ ] Uptime monitoring enabled
- [ ] Alert thresholds set
- [ ] Log aggregation configured

## 🚀 Production Deployment

### 1. Server Setup

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Node.js 20
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install PM2 globally
sudo npm install -g pm2

# Install Nginx
sudo apt install nginx -y
```

### 2. Application Deployment

```bash
# Clone repository
git clone https://github.com/tiptophimp/idiot-token.git
cd idiot-token

# Checkout production tag
git checkout v2025.10.07-prod

# Install dependencies
npm ci --production

# Install dashboard dependencies
cd transparency-dashboard
npm ci --production
cd ..
```

### 3. Environment Configuration

Create `/etc/idiot-dashboard/.env`:
```bash
# RPC Configuration
RPC_URL_PRIMARY=https://mainnet.base.org
RPC_URL_ALCHEMY=https://base-mainnet.g.alchemy.com/v2/YOUR_KEY
RPC_URL_INFURA=https://base-mainnet.infura.io/v3/YOUR_KEY

# API Keys
ETHERSCAN_API_KEY=your_etherscan_v2_key

# Dashboard Configuration
PORT=3000
NODE_ENV=production

# Monitoring
HEALTH_CHECK_INTERVAL=30000
LOG_LEVEL=info
```

### 4. PM2 Configuration

Create `/etc/idiot-dashboard/ecosystem.config.js`:
```javascript
module.exports = {
  apps: [{
    name: 'idiot-dashboard',
    script: './transparency-dashboard/server.js',
    cwd: '/etc/idiot-dashboard',
    instances: 1,
    exec_mode: 'cluster',
    env: {
      NODE_ENV: 'production',
      PORT: 3000
    },
    env_production: {
      NODE_ENV: 'production',
      PORT: 3000
    },
    log_file: '/var/log/idiot-dashboard/combined.log',
    out_file: '/var/log/idiot-dashboard/out.log',
    error_file: '/var/log/idiot-dashboard/error.log',
    log_date_format: 'YYYY-MM-DD HH:mm:ss Z',
    max_memory_restart: '1G',
    restart_delay: 4000,
    max_restarts: 10,
    min_uptime: '10s'
  }]
};
```

### 5. Nginx Configuration

Create `/etc/nginx/sites-available/stupidiots.com`:
```nginx
server {
    listen 80;
    server_name www.stupidiots.com stupidiots.com;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name www.stupidiots.com stupidiots.com;

    # SSL Configuration
    ssl_certificate /path/to/ssl/cert.pem;
    ssl_certificate_key /path/to/ssl/private.key;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-RSA-AES256-GCM-SHA512:DHE-RSA-AES256-GCM-SHA512;
    ssl_prefer_server_ciphers off;

    # Security Headers
    add_header X-Frame-Options DENY;
    add_header X-Content-Type-Options nosniff;
    add_header X-XSS-Protection "1; mode=block";
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains";

    # Rate Limiting
    limit_req_zone $binary_remote_addr zone=api:10m rate=10r/m;
    limit_req_zone $binary_remote_addr zone=dashboard:10m rate=30r/m;

    # Main Dashboard
    location / {
        limit_req zone=dashboard burst=20 nodelay;
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }

    # API Endpoints
    location /api/ {
        limit_req zone=api burst=10 nodelay;
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # Health Check (no rate limiting)
    location /api/health {
        proxy_pass http://localhost:3000;
        access_log off;
    }

    # Static Assets
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
        proxy_pass http://localhost:3000;
    }
}
```

### 6. System Service Setup

Create `/etc/systemd/system/idiot-dashboard.service`:
```ini
[Unit]
Description=IDIOT Token Dashboard
After=network.target

[Service]
Type=forking
User=www-data
WorkingDirectory=/etc/idiot-dashboard
ExecStart=/usr/bin/pm2 start ecosystem.config.js --env production
ExecReload=/usr/bin/pm2 reload ecosystem.config.js --env production
ExecStop=/usr/bin/pm2 stop ecosystem.config.js
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

### 7. Deployment Commands

```bash
# Enable and start services
sudo systemctl enable idiot-dashboard
sudo systemctl start idiot-dashboard

# Enable and start Nginx
sudo systemctl enable nginx
sudo systemctl start nginx

# Check status
sudo systemctl status idiot-dashboard
sudo systemctl status nginx

# Check PM2 status
pm2 status
pm2 logs idiot-dashboard
```

## 🔍 Post-Deployment Verification

### 1. Health Checks
```bash
# Check dashboard health
curl -s https://www.stupidiots.com/api/health | jq

# Check all endpoints
curl -s https://www.stupidiots.com/api/dashboard | jq '.tokenInfo'
curl -s https://www.stupidiots.com/api/vesting-wallets | jq '.[0]'
curl -s https://www.stupidiots.com/api/pool | jq '.liquidity'
```

### 2. Performance Testing
```bash
# Load test (install apache2-utils first)
sudo apt install apache2-utils

# Test API endpoints
ab -n 1000 -c 10 https://www.stupidiots.com/api/health
ab -n 100 -c 5 https://www.stupidiots.com/api/dashboard
```

### 3. Security Verification
```bash
# Check SSL configuration
openssl s_client -connect www.stupidiots.com:443 -servername www.stupidiots.com

# Test rate limiting
for i in {1..20}; do curl -s https://www.stupidiots.com/api/health; done
```

## 📊 Monitoring Setup

### 1. Uptime Monitoring
Configure external monitoring service (UptimeRobot, Pingdom, etc.):
- **URL:** `https://www.stupidiots.com/api/health`
- **Interval:** 5 minutes
- **Timeout:** 30 seconds
- **Alert:** Email/SMS on failure

### 2. Log Monitoring
```bash
# Set up log rotation
sudo nano /etc/logrotate.d/idiot-dashboard

# Content:
/var/log/idiot-dashboard/*.log {
    daily
    missingok
    rotate 30
    compress
    delaycompress
    notifempty
    create 644 www-data www-data
    postrotate
        pm2 reloadLogs
    endscript
}
```

### 3. System Monitoring
```bash
# Install monitoring tools
sudo apt install htop iotop nethogs

# Monitor resources
htop
iotop
nethogs
```

## 🔄 Maintenance Procedures

### Daily
- [ ] Check health endpoint
- [ ] Review error logs
- [ ] Monitor resource usage

### Weekly
- [ ] Run fee collection script
- [ ] Check liquidity status
- [ ] Review performance metrics

### Monthly
- [ ] Update dependencies
- [ ] Review security logs
- [ ] Test backup procedures

## 🚨 Troubleshooting

### Common Issues

**Dashboard not loading:**
```bash
# Check PM2 status
pm2 status
pm2 logs idiot-dashboard

# Restart if needed
pm2 restart idiot-dashboard
```

**API errors:**
```bash
# Check health endpoint
curl -s https://www.stupidiots.com/api/health | jq

# Check RPC connectivity
curl -s https://mainnet.base.org
```

**High memory usage:**
```bash
# Check memory usage
pm2 monit

# Restart if needed
pm2 restart idiot-dashboard
```

## 📞 Support

For production issues:
1. Check health endpoints first
2. Review logs for errors
3. Check system resources
4. Escalate to team if needed

**Emergency Contacts:**
- Discord: #idiot-support
- Email: support@stupidiots.com
- GitHub: Issues tab

---

**Deployment Status:** ✅ Ready for Production  
**Last Updated:** 2025-10-07  
**Next Review:** 2025-11-07
