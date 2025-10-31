# 🔒 SACRED WORKFLOW - NEVER DEVIATE FROM THIS

**Version:** 1.0  
**Established:** 2025-10-16  
**Status:** MANDATORY - NO EXCEPTIONS

---

## 📜 THE GOSPEL: SIMPLIFIED UPDATE PROCESS

**When you say "update" - everything happens automatically:**

```
┌─────────────────────────────────────────────────────────────┐
│  AUTOMATIC UPDATE PROCESS                                   │
│  (Just say "update" and it all happens)                     │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│  1. CREATE LOCAL BACKUP                                     │
│  ├─ Automatic rolling backup created                       │
│  ├─ Keeps 4 most recent backups                            │
│  └─ Stored in: website\backups\                            │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│  2. BUMP VERSION AUTOMATICALLY                              │
│  ├─ Version increments (v5.0 → v5.1 → v5.2, etc.)         │
│  ├─ Updated in index.html footer                           │
│  └─ Included in commit message                             │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┘
│  3. UPDATE STAGING REPO                                     │
│  ├─ Commit changes to staging branch                       │
│  ├─ Push to staging repository                             │
│  └─ Deploys to: https://tiptophimp.github.io/idiot-token-staging/ │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│  4. UPDATE PRODUCTION REPO                                  │
│  ├─ Commit changes to gh-pages branch                      │
│  ├─ Push to production repository                          │
│  └─ Deploys to: https://www.stupidiots.com                 │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│  ✅ DONE - Everything updated automatically!               │
│  ├─ Backup created ✓                                       │
│  ├─ Version bumped ✓                                       │
│  ├─ Staging updated ✓                                      │
│  └─ Production updated ✓                                   │
└─────────────────────────────────────────────────────────────┘
```

**That's it! Simple. When you say "update" - it all happens automatically.**

**Rollback Available:** If anything goes wrong, we have backups in `website\backups\` to restore from.

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

### Update Everything (Simplified)

**Just say "update" and everything happens automatically:**

The AI assistant will automatically:
1. ✅ Create local backup (rolling 4 backups)
2. ✅ Bump version automatically (v5.0 → v5.1 → v5.2, etc.)
3. ✅ Update staging repo (commit and push)
4. ✅ Update production repo (commit and push)

**No manual steps needed!** Just say "update" and it's done.

**Rollback:** If anything goes wrong, backups are in `website\backups\` for easy restoration.

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
- [ ] **Version bumped (automatically via script)**
- [ ] Commit message written
- [ ] Pushed to repo
- [ ] CI/CD deployment verified
- [ ] **Version verified at bottom of page**

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

