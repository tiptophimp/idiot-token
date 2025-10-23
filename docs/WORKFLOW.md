# 🔒 SACRED WORKFLOW - NEVER DEVIATE FROM THIS

**Version:** 1.0  
**Established:** 2025-10-16  
**Status:** MANDATORY - NO EXCEPTIONS

---

## 📜 THE GOSPEL: 5-STEP DEPLOYMENT PROCESS

```
┌─────────────────────────────────────────────────────────────┐
│  Step 1: LOCAL DEVELOPMENT                                  │
│  ├─ Work in: C:\idiot-project\website\dev\                 │
│  ├─ Make changes to HTML, CSS, JS, images                  │
│  └─ Save frequently                                         │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│  Step 2: LOCAL BROWSER REVIEW (CRITICAL!)                  │
│  ├─ Open files directly in browser from Explorer           │
│  ├─ No cache issues, see real changes                      │
│  ├─ Review ALL changes thoroughly                          │
│  ├─ Fix any issues found                                   │
│  └─ Only proceed when LOCAL looks perfect                  │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│  Step 3: STAGING DEPLOYMENT                                │
│  ├─ Switch to staging branch: git checkout staging         │
│  ├─ Copy/merge your changes                                │
│  ├─ Commit and push to staging repo                        │
│  ├─ Deploys to: https://tiptophimp.github.io/idiot-token-staging/ │
│  ├─ Test LIVE on staging site                              │
│  ├─ Check all links, images, functionality                 │
│  └─ Only proceed when STAGING perfect                      │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│  Step 4: COMMIT TO PRODUCTION                              │
│  ├─ Switch to gh-pages: git checkout gh-pages              │
│  ├─ Copy/merge approved changes from staging               │
│  ├─ Git add, commit, push to GitHub                        │
│  ├─ Repo stays CLEAN (no broken commits!)                  │
│  ├─ Write clear commit message                             │
│  └─ Push to gh-pages branch                                │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│  Step 5: AUTOMATIC PRODUCTION DEPLOYMENT                   │
│  ├─ GitHub Pages automatically deploys                     │
│  ├─ Usually takes 1-3 minutes                              │
│  ├─ Deploys to: https://www.stupidiots.com                 │
│  ├─ Verify deployment successful                           │
│  └─ Test live site                                         │
└─────────────────────────────────────────────────────────────┘
```

---

## 🛡️ SAFETY MECHANISMS

### Backup System (Rolling 4)
- **Location:** `C:\idiot-project\website\backups\`
- **Rotation:** Keep 4 most recent, delete oldest
- **Naming:** `backup_YYYYMMDD_HHMMSS.tar.gz`
- **Created:** Before EVERY staging and production deploy
- **Stored:** Both locally and on server

### Automatic Checks
- ✅ Backup created before deploy
- ✅ Target directory verified
- ✅ Files validated
- ✅ Deployment verified
- ✅ Rollback available

---

## ❌ NEVER DO THIS

### Prohibited Actions:
1. ❌ Skip local browser review
2. ❌ Deploy to production without staging test
3. ❌ Commit broken code to repo
4. ❌ Run `rm -rf` without backup
5. ❌ Disable safety checks
6. ❌ Ignore failed commits
7. ❌ Deviate from this workflow

---

## 🚨 ROLLBACK PROCEDURE

### If Production Breaks:
```bash
# 1. Check available backups
ls -lh C:\idiot-project\website\backups\

# 2. Run rollback script
bash C:\idiot-project\deploy\scripts\rollback-production.sh

# 3. Select backup to restore
# 4. Verify restoration
curl -I https://stupidiots.com/
```

---

## 📁 DIRECTORY STRUCTURE

```
C:\idiot-project\
├── _STATUS.md              ← READ THIS FIRST
├── website\
│   ├── dev\                ← Step 1: Local development
│   ├── staging-ready\      ← Step 3: Ready for staging
│   ├── production-ready\   ← Step 4: Ready for production
│   └── backups\            ← Rolling 4 backups
├── token\                  ← Token dev & maintenance
├── deploy\
│   └── scripts\            ← Deployment automation
└── docs\                   ← Documentation
    └── WORKFLOW.md         ← YOU ARE HERE
```

---

## 🎯 QUICK REFERENCE COMMANDS

### Local Browser Review
```bash
# Windows: Open file in default browser
start C:\idiot-project\website\dev\index.html

# Or: Right-click in Explorer → Open with → Chrome/Firefox
```

### Deploy to Staging
```bash
cd C:\idiot-project
git checkout staging
# Make your changes or merge from dev
git add .
git commit -m "Description of changes"
git push origin staging
git push staging-origin staging:gh-pages
```

### Check Staging
```
https://tiptophimp.github.io/idiot-token-staging/
```

### Deploy to Production
```bash
cd C:\idiot-project
git checkout gh-pages
# Merge approved changes from staging
git add .
git commit -m "Description of changes"
git push origin gh-pages
```

### Check Production
```
https://www.stupidiots.com/
```

### Rollback
```bash
bash deploy/scripts/rollback-production.sh
```

---

## 📝 DEPLOYMENT CHECKLIST

Before EVERY deployment, verify:

### Pre-Deployment
- [ ] Changes tested in local browser
- [ ] All links work
- [ ] All images load
- [ ] No console errors
- [ ] Mobile responsive
- [ ] Cross-browser tested

### Staging
- [ ] Deployed to staging successfully
- [ ] Tested live on staging server
- [ ] No cache issues
- [ ] All functionality works
- [ ] Ready for production

### Production
- [ ] Backup created (verify!)
- [ ] Staging approved
- [ ] Commit message written
- [ ] Pushed to repo
- [ ] CI/CD deployment verified

---

## 🏆 SUCCESS METRICS

You're following the workflow correctly if:
- ✅ Zero broken commits in repo
- ✅ Zero production surprises
- ✅ Always have 4 backups
- ✅ Can rollback in < 5 minutes
- ✅ Clean git history
- ✅ No emergency fixes

---

**This workflow exists because of the Oct 16 near-deletion incident.**  
**Follow it religiously. Your future self will thank you.**

---

**Questions? Read this document again. Still questions? Read _STATUS.md**

