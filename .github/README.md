# 🤖 GitHub Actions Automation

## 📦 What's Inside

This directory contains the **automated deployment system** for stupidiots.com.

### 📁 Files:

| File | Purpose | Commit? |
|------|---------|---------|
| `workflows/deploy.yml` | Main deployment workflow | ✅ Yes |
| `DEPLOYMENT_SETUP.md` | Full setup guide | ✅ Yes |
| `QUICK_START.md` | Quick reference | ✅ Yes |
| `github-actions-deploy-key.pub` | Public SSH key | ✅ Yes |
| `github-actions-deploy-key` | **Private SSH key** | ❌ **NO - NEVER!** |

---

## 🚀 Quick Links

- **Setup Instructions:** [DEPLOYMENT_SETUP.md](./DEPLOYMENT_SETUP.md)
- **Quick Start:** [QUICK_START.md](./QUICK_START.md)
- **View Workflows:** https://github.com/tiptophimp/idiot-token/actions

---

## ⚡ Status

- **Pipeline:** Ready to activate
- **Setup Required:** Yes (one-time, 5 minutes)
- **Auto-Deploy:** Will work after setup

---

## 🔐 Security

The private key (`github-actions-deploy-key`) is:
- ✅ Protected by `.gitignore`
- ✅ Never committed to GitHub
- ✅ Stored as GitHub Secret after setup
- ✅ Used only by GitHub Actions

---

**Next Step:** Follow [QUICK_START.md](./QUICK_START.md) to activate!

