# 🧪 STAGING ENVIRONMENT SETUP

**Date:** October 11, 2025  
**Status:** ✅ **ACTIVE - NO MORE LIVE EDITS!**

---

## 🚨 IMPORTANT: NO MORE DIRECT LIVE EDITS

**From now on, ALL changes must go through staging first!**

### ❌ NEVER DO THIS:
- Direct edits to production
- Running `deploy-now.ps1` without testing
- Making changes directly on live site

### ✅ ALWAYS DO THIS:
1. Make changes locally
2. Deploy to staging
3. Test thoroughly
4. Promote to production

---

## 🏗️ STAGING ENVIRONMENT

### **Staging URL:**
- **https://stupidiots.com/staging**

### **Server Setup:**
- **Directory:** `/var/www/staging`
- **Nginx:** Configured with no-cache headers
- **Permissions:** www-data:www-data

### **Features:**
- ✅ No caching (always fresh)
- ✅ Isolated from production
- ✅ Same file structure as production
- ✅ Safe testing environment

---

## 📋 DEPLOYMENT WORKFLOW

### **Step 1: Deploy to Staging**
```powershell
.\deploy-staging.ps1
```

**What it does:**
- Creates clean deployment package
- Uploads to `/var/www/staging`
- Sets proper permissions
- Clears staging directory first

### **Step 2: Test Thoroughly**
Visit: **https://stupidiots.com/staging**

**Test checklist:**
- [ ] All pages load correctly
- [ ] Images display properly
- [ ] Links work
- [ ] Forms function
- [ ] Mobile responsive
- [ ] No console errors
- [ ] Performance is good

### **Step 3: Promote to Production**
```powershell
.\promote-to-production.ps1
```

**What it does:**
- Creates backup of current production
- Copies staging to production
- Sets proper permissions
- Requires "YES" confirmation

---

## 🔧 AVAILABLE SCRIPTS

### **deploy-staging.ps1**
- Deploys current code to staging
- Safe for testing
- Never affects production

### **promote-to-production.ps1**
- Promotes tested staging to live
- Creates automatic backup
- Requires confirmation

### **deploy-now.ps1** (DEPRECATED)
- ⚠️ **DO NOT USE** - Direct to production
- Only for emergency fixes
- Must be approved first

---

## 🛡️ SAFETY FEATURES

### **Automatic Backups**
Every promotion creates a timestamped backup:
```
/var/www/html.backup.YYYYMMDD_HHMMSS
```

### **Confirmation Required**
Production promotion requires typing "YES"

### **No-Cache Headers**
Staging always shows latest version

### **Isolated Environment**
Staging cannot affect production data

---

## 📊 BENEFITS

### **Quality Assurance**
- Test changes before going live
- Catch bugs in staging
- Verify functionality works

### **Risk Reduction**
- No accidental production breaks
- Easy rollback with backups
- Controlled deployments

### **Team Collaboration**
- Share staging URL for review
- Multiple people can test
- Clear approval process

---

## 🚨 EMERGENCY PROCEDURES

### **If Production Breaks:**
1. Check recent backups: `ls /var/www/html.backup.*`
2. Restore from backup:
   ```bash
   ssh root@68.183.149.106
   cd /var/www/html
   rm -rf *
   cp -r /var/www/html.backup.YYYYMMDD_HHMMSS/* .
   chown -R www-data:www-data /var/www/html
   ```

### **If Staging Breaks:**
- Safe to fix - doesn't affect production
- Redeploy with `deploy-staging.ps1`

---

## 📝 COMMIT WORKFLOW

### **For Regular Changes:**
1. Make changes locally
2. Test locally (open index.html in browser)
3. Commit to git:
   ```bash
   git add .
   git commit -m "Describe changes"
   git push origin master
   ```
4. Deploy to staging:
   ```powershell
   .\deploy-staging.ps1
   ```
5. Test at https://stupidiots.com/staging
6. Promote to production:
   ```powershell
   .\promote-to-production.ps1
   ```

### **For Emergency Fixes:**
1. Document the emergency
2. Make minimal fix
3. Test in staging first (if possible)
4. Use `deploy-now.ps1` only if staging is down
5. Create incident report

---

## 🎯 BEST PRACTICES

### **Always:**
- Test in staging first
- Create meaningful commit messages
- Document any special changes
- Keep backups current

### **Never:**
- Skip staging for non-emergencies
- Deploy untested code
- Forget to backup before major changes
- Work directly on production

---

## 🔗 QUICK REFERENCE

| Action | Command | URL |
|--------|---------|-----|
| Deploy to staging | `.\deploy-staging.ps1` | https://stupidiots.com/staging |
| Promote to production | `.\promote-to-production.ps1` | https://stupidiots.com |
| Emergency deploy | `.\deploy-now.ps1` | https://stupidiots.com |

---

## 📞 SUPPORT

**If you need help:**
1. Check this documentation first
2. Test in staging environment
3. Create backup before changes
4. Document any issues

---

**Remember: Staging first, production second! 🧪➡️🚀**

