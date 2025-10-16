# 🧠 IDIOT Token Project

**Smart About Dumb Fun**

This is the unified development repository for the IDIOT Token ecosystem, including:
- 🌐 stupidiots.com website
- 🪙 IDIOT Token development & maintenance
- 📊 Community management tools
- 🚀 Deployment automation

---

## 📂 Directory Structure

```
C:\idiot-project\
├── _STATUS.md              ← READ THIS FIRST every session
├── website\
│   ├── dev\                ← Active development
│   ├── staging-ready\      ← Ready for staging deployment
│   ├── production-ready\   ← Ready for production deployment
│   └── backups\            ← Rolling 4 backups (auto-managed)
├── token\
│   ├── data\               ← Token info, tokenomics
│   ├── scripts\            ← Payout, rewards, roles scripts
│   ├── contracts\          ← Smart contract info
│   └── docs\               ← Token documentation
├── deploy\
│   ├── scripts\            ← Deployment automation
│   ├── nginx\              ← Server configs
│   └── ssh-keys\           ← SSH keys (gitignored)
└── docs\
    ├── WORKFLOW.md         ← Sacred deployment workflow
    ├── procedures\         ← SOPs and guides
    ├── reports\            ← Status reports
    └── incidents\          ← Incident reports
```

---

## 🔄 WORKFLOW (MANDATORY)

**NEVER deviate from this workflow!**

### The 5-Step Process:

1. **LOCAL DEV** → Work in `website/dev/`
2. **LOCAL REVIEW** → Open in browser, test thoroughly
3. **STAGING** → Deploy to staging server, test live
4. **REPO COMMIT** → Commit blessed code to GitHub
5. **AUTO-DEPLOY** → CI/CD pushes to production

**Full details:** See `docs/WORKFLOW.md`

---

## 🚀 Quick Commands

### Local Browser Preview
```bash
bash deploy/scripts/local-browser-preview.sh
```

### Deploy to Staging
```bash
bash deploy/scripts/deploy-to-staging.sh
```

### Rollback Production
```bash
bash deploy/scripts/rollback-production.sh
```

### Create Backup
```bash
bash deploy/scripts/backup-rotation.sh
```

---

## 🌐 Live Sites

- **Production:** https://stupidiots.com
- **Staging:** https://stupidiots.com/staging
- **Server:** 68.183.149.106

---

## 📋 Before You Start

1. Read `_STATUS.md` to see current state
2. Read `docs/WORKFLOW.md` to understand process
3. Never push to production without staging test
4. Always maintain 4 rolling backups
5. Follow the workflow - NO EXCEPTIONS

---

## 🛡️ Safety Features

- ✅ Rolling 4-backup system
- ✅ Automatic backups before deploys
- ✅ Staging environment mandatory
- ✅ Rollback capability
- ✅ Git version control
- ✅ Clean separation of environments

---

## 🚨 Emergency Rollback

If production breaks:
```bash
bash deploy/scripts/rollback-production.sh
```
Select a backup and restore immediately.

---

## 📞 Key Information

**Contract:** 0xC29EF04CFFe38012dcfc1E96a2B368443f298dE1  
**Network:** Base Mainnet (Chain ID: 8453)  
**Repository:** GitHub (to be configured)  
**Server:** DigitalOcean Droplet  

---

## ⚠️ Remember

> "This workflow exists because of the Oct 16 near-deletion incident.  
> Follow it religiously. Your future self will thank you."

---

**Created:** 2025-10-16  
**Version:** 1.0

