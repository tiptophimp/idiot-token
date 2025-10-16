# 🧠 IDIOT Token Project

**Smart About Dumb Fun**

This is the unified development repository for the IDIOT Token ecosystem, including:
- 🌐 stupidiots.com website
- 🪙 IDIOT Token development & maintenance
- 📊 Community management tools
- 🚀 Deployment automation

---

## ⚠️ CRITICAL: START EVERY SESSION HERE

### 🚨 **READ THIS FILE FIRST: [`SESSION_HANDOFF.md`](SESSION_HANDOFF.md)**

**Before doing ANYTHING:**
1. Open and read `SESSION_HANDOFF.md`
2. It contains the complete current state
3. All context you need to continue

**At the end of every session:**
1. Update `SESSION_HANDOFF.md`
2. Commit the changes
3. Never skip this step

See [`_START_HERE.md`](_START_HERE.md) for detailed instructions.

---

## 📂 Directory Structure

```
C:\idiot-project\
├── _START_HERE.md          ← READ THIS EVERY SESSION
├── SESSION_HANDOFF.md      ← CURRENT STATE (read first!)
├── SESSION_HANDOFF_TEMPLATE.md ← Template for updates
├── _STATUS.md              ← Quick status reference
├── README.md               ← This file
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
    ├── SESSION_HANDOFF.md  ← Backup copy
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

## 📋 Session Management

### Starting a New Session
1. **READ:** `SESSION_HANDOFF.md` (has complete context)
2. **REVIEW:** Check what's in progress, what's blocking
3. **CONTINUE:** Pick up where the last session left off

### Ending a Session
1. **UPDATE:** `SESSION_HANDOFF.md` with current state
2. **COMMIT:** Changes to git
3. **VERIFY:** Handoff checklist is complete

### For AI Assistants
**Always start with:**
```
Read SESSION_HANDOFF.md and tell me what we're working on
```

**Always end with:**
```
Update SESSION_HANDOFF.md with today's progress and commit it
```

---

## 🛡️ Safety Features

- ✅ Rolling 4-backup system
- ✅ Automatic backups before deploys
- ✅ Staging environment mandatory
- ✅ Rollback capability
- ✅ Git version control
- ✅ Clean separation of environments
- ✅ Session handoff system

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

> "Never start a session without reading SESSION_HANDOFF.md.  
> Never end a session without updating it."

---

**Created:** 2025-10-16  
**Version:** 2.0 (with session handoff system)
