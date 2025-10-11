# 🚨 DEPLOYMENT POLICY - NO LIVE EDITS

## ⚠️ CRITICAL: STAGING REQUIRED

**Effective immediately:** All website changes MUST go through staging first.

### ❌ FORBIDDEN:
- Direct edits to production
- Running `deploy-now.ps1` without approval
- Making changes directly on live site
- Skipping staging for non-emergencies

### ✅ REQUIRED WORKFLOW:
1. **Make changes locally**
2. **Deploy to staging:** `.\deploy-staging.ps1`
3. **Test thoroughly:** https://stupidiots.com/staging
4. **Promote to production:** `.\promote-to-production.ps1`

---

## 🧪 STAGING ENVIRONMENT

- **URL:** https://stupidiots.com/staging
- **Purpose:** Safe testing before production
- **Features:** No caching, isolated environment

## 🚀 PRODUCTION PROMOTION

- **Command:** `.\promote-to-production.ps1`
- **Safety:** Creates automatic backup
- **Confirmation:** Requires typing "YES"

## 🆘 EMERGENCY ONLY

- **Command:** `.\deploy-now.ps1`
- **When:** Only if staging is down AND it's urgent
- **Process:** Document emergency, test locally first

---

**This policy prevents production issues and ensures quality! 🛡️**

