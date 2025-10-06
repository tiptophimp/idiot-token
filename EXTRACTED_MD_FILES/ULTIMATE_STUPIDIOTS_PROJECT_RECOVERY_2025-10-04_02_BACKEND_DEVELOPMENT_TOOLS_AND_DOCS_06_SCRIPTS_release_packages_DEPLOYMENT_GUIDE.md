# IDIOT Token - Production Deployment Guide

*Release: stupidiots-release-20250101-1500*
*Date: January 1, 2025*
*Status: Ready for Production*

## 📦 RELEASE PACKAGE CONTENTS

```
stupidiots-release-20250101-1500/
├── index.html              (144KB - Main website)
├── assets/
│   └── img/
│       ├── coin-1.png      (2.3MB - Main coin image)
│       ├── favicon.ico      (5.6KB - Browser icon)
│       ├── idiot_coin_1.png (2.2MB - Secondary coin)
│       ├── idiot-coin-32x32-lime-fixed.svg (14KB - SVG favicon)
│       ├── idiot-logo-icon_64.png (5.4KB - Social icon)
│       ├── logo.png         (101KB - Website logo)
│       └── og-image.png     (58KB - Social media image)
└── airdrop/
    ├── index.html          (7.6KB - Airdrop portal)
    └── idiocracy-1.json    (1.8KB - Airdrop manifest)
```

## 🚀 DEPLOYMENT STEPS

### 1. BACKUP CURRENT PRODUCTION
```bash
# Create backup of current production
cp -r /path/to/current/production /path/to/backups/production-backup-$(date +%Y%m%d-%H%M)
```

### 2. STAGING DEPLOYMENT
```bash
# Upload to staging directory
scp -r stupidiots-release-20250101-1500/ user@server:/staging/releases/20250101-1500/

# Extract on server
ssh user@server "cd /staging/releases/20250101-1500 && unzip -o stupidiots-release-20250101-1500.zip"

# Point staging to new release
ssh user@server "ln -sfn /staging/releases/20250101-1500 /staging/current"
```

### 3. STAGING VALIDATION
- [ ] **Desktop Testing:** Open staging URL on desktop browser
- [ ] **Mobile Testing:** Test on mobile device or responsive mode
- [ ] **Link Validation:** Test all Uniswap, DexScreener, BaseScan links
- [ ] **Functionality:** Test contract copy, price updates, buy bar
- [ ] **Performance:** Check page load speed and responsiveness

### 4. PRODUCTION DEPLOYMENT
```bash
# Copy validated release to production
scp -r stupidiots-release-20250101-1500/ user@server:/production/

# Update production symlink
ssh user@server "ln -sfn /production/stupidiots-release-20250101-1500 /production/current"

# Verify deployment
curl -I https://stupidiots.com/
```

### 5. POST-DEPLOYMENT VERIFICATION
- [ ] **Homepage Loads:** https://stupidiots.com/ loads correctly
- [ ] **All Links Work:** Uniswap, DexScreener, BaseScan functional
- [ ] **Mobile Responsive:** Site works on mobile devices
- [ ] **Performance:** Page loads quickly
- [ ] **Analytics:** Tracking codes active

## 🔧 TECHNICAL SPECIFICATIONS

### Server Requirements
- **Web Server:** Apache/Nginx
- **PHP:** Not required (static site)
- **SSL:** Required (HTTPS only)
- **CDN:** Recommended for image optimization

### File Permissions
```bash
# Set proper permissions
chmod 644 *.html *.json *.png *.ico *.svg
chmod 755 assets/ airdrop/ assets/img/
```

### Nginx Configuration
```nginx
server {
    listen 443 ssl;
    server_name stupidiots.com www.stupidiots.com;
    
    root /path/to/production/current;
    index index.html;
    
    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
    
    # Cache static assets
    location ~* \.(png|jpg|jpeg|gif|ico|svg|css|js)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
```

## 🎯 NEW FEATURES IN THIS RELEASE

### ✅ UX IMPROVEMENTS
- **Sticky Header:** Logo left, navigation center, actions right
- **Buy Bar:** Appears on scroll with contract copy and live price
- **Mobile Optimized:** Responsive design with proper touch targets
- **Accessibility:** WCAG compliant with focus states and ARIA labels

### ✅ FUNCTIONALITY ENHANCEMENTS
- **Contract Copy:** Clickable pills in header and buy bar
- **Live Price:** Real-time price updates in header and buy bar
- **Tooltips:** Helpful explanations for key financial terms
- **Smart Navigation:** Streamlined menu with essential links

### ✅ CONTENT LOCK-IN
- **Tokenomics:** All final numbers locked and verified
- **Contract Address:** Consistent across all instances
- **Links:** All trading and explorer links validated
- **Airdrop:** Complete allocation and timeline details

## 🔄 ROLLBACK PLAN

### If Issues Occur:
```bash
# Immediate rollback to previous version
ssh user@server "ln -sfn /production/previous-release /production/current"

# Verify rollback
curl -I https://stupidiots.com/
```

### Backup Locations:
- **Current Backup:** `/backups/production-backup-YYYYMMDD-HHMM/`
- **Previous Release:** `/production/previous-release/`
- **Staging:** `/staging/releases/20250101-1500/`

## 📊 MONITORING

### Key Metrics to Watch:
- **Page Load Time:** Should be < 3 seconds
- **Mobile Performance:** Core Web Vitals scores
- **Error Rates:** 404s, 500s, JavaScript errors
- **User Engagement:** Time on page, click-through rates

### Tools:
- **Google PageSpeed Insights:** Performance monitoring
- **Google Search Console:** SEO and indexing
- **Analytics:** User behavior and conversion tracking

## ✅ DEPLOYMENT CHECKLIST

### Pre-Deployment:
- [ ] All tests passed in staging
- [ ] Backup current production
- [ ] Verify release package integrity
- [ ] Check server resources and capacity

### During Deployment:
- [ ] Upload files to staging first
- [ ] Test staging thoroughly
- [ ] Deploy to production
- [ ] Update DNS/load balancer if needed

### Post-Deployment:
- [ ] Verify homepage loads
- [ ] Test all critical functionality
- [ ] Check mobile responsiveness
- [ ] Monitor error logs
- [ ] Update monitoring dashboards

## 🎉 SUCCESS CRITERIA

**Deployment is successful when:**
- ✅ Website loads without errors
- ✅ All trading links work correctly
- ✅ Mobile experience is smooth
- ✅ Performance metrics are acceptable
- ✅ No critical errors in logs

**Release Package:** `stupidiots-release-20250101-1500.zip`
**Ready for Production:** ✅ YES
