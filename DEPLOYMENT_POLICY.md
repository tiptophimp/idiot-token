# 🚨 DEPLOYMENT POLICY - STAGING-FIRST WORKFLOW

## ✅ **CURRENT STATUS: v2.0 LIVE**

**Production:** https://stupidiots.com  
**Staging:** https://stupidiots.com/staging  
**Version:** v2.0 (Clean, 9 files only)

---

## 🎯 **NEW WORKFLOW (EFFECTIVE NOW)**

### **✅ PRODUCTION IS NOW CLEAN:**
- ✅ Only website files (9 items)
- ✅ No internal docs, scripts, or .md files
- ✅ v2.0 with cache-busting headers
- ✅ Ready for public use

### **🧪 STAGING FOR ALL FUTURE EDITS:**
- ✅ Test all changes in staging first
- ✅ Deploy to staging: `.\deploy-staging.ps1`
- ✅ Test at: https://stupidiots.com/staging
- ✅ Promote to production: `.\promote-to-production.ps1`

---

## 📋 **MANDATORY PROCESS**

### **For ANY website changes:**

1. **Make changes locally**
2. **Deploy to staging:** `.\deploy-staging.ps1`
3. **Test thoroughly:** https://stupidiots.com/staging
4. **Verify everything works**
5. **Promote to production:** `.\promote-to-production.ps1`

### **❌ NEVER DO:**
- Direct edits to production
- Skip staging for non-emergencies
- Use `deploy-now.ps1` without approval

---

## 🛡️ **SAFETY FEATURES**

### **Automatic Backups:**
- Every promotion creates backup: `/var/www/html.backup.YYYYMMDD_HHMMSS`
- Old "dirty" production backed up as: `/var/www/html.backup.20251011_233735`

### **Clean Production:**
- Only 9 website files (was 84 files)
- No internal documentation exposed
- Professional, clean appearance

---

## 🔗 **QUICK REFERENCE**

| Action | Command | URL |
|--------|---------|-----|
| Deploy to staging | `.\deploy-staging.ps1` | https://stupidiots.com/staging |
| Promote to production | `.\promote-to-production.ps1` | https://stupidiots.com |
| Emergency deploy | `.\deploy-now.ps1` | https://stupidiots.com |

---

## 📊 **BEFORE vs AFTER**

### **❌ OLD PRODUCTION (84 files):**
- Internal .md files
- PowerShell scripts
- Excel spreadsheets
- Development files
- Backup files
- Configuration files

### **✅ NEW PRODUCTION (9 files):**
- index.html
- about.html
- community.html
- tokenomics-interactive.html
- vesting-schedule.html
- whitepaper.html
- Plus clean folders (assets/, airdrop/, etc.)

---

## 🎉 **SUCCESS!**

**Production is now clean and professional!**  
**Staging environment ready for all future edits!**  
**No more accidental internal file exposure!**

---

**Remember: Staging first, production second! 🧪➡️🚀**
