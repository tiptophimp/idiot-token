# 🚀 Quick Start - Auto-Deployment

## ⚡ TL;DR - 3 Steps to Setup

### 1️⃣ Add SSH Key to Server (1 minute)
```bash
ssh root@68.183.149.106
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFZGS/Xvoo41YLGFuUd37qaSgf7ZePtFtLEbUpPSbyrX github-actions-deploy@stupidiots.com" >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
exit
```

### 2️⃣ Add GitHub Secrets (2 minutes)
Go to: https://github.com/tiptophimp/idiot-token/settings/secrets/actions

**Add these 2 secrets:**
1. `SSH_PRIVATE_KEY` → Copy from `.github/github-actions-deploy-key`
2. `SERVER_IP` → `68.183.149.106`

### 3️⃣ Push to GitHub (30 seconds)
```bash
git add .github/
git commit -m "🚀 Add auto-deployment"
git push
```

**Done!** Watch at: https://github.com/tiptophimp/idiot-token/actions

---

## 🎯 Daily Usage

Just push code as normal:
```bash
git add .
git commit -m "Update site"
git push
```

**Site auto-deploys in 2-3 minutes!** ✨

---

## 🔄 Rollback

```bash
ssh root@68.183.149.106
cd /var/www/html && rm -rf * && tar -xzf /var/www/backups/$(ls -t /var/www/backups/ | head -1)
```

---

**Full docs:** See `DEPLOYMENT_SETUP.md`

