# 🚀 GitHub Actions Auto-Deployment Setup Guide

## ✅ What's Been Created

Your repository now has a **professional CI/CD pipeline** that automatically deploys to stupidiots.com when you push code to GitHub!

### 📋 Files Created:
- `.github/workflows/deploy.yml` - GitHub Actions workflow
- `.github/github-actions-deploy-key` - **Private SSH key** (DO NOT COMMIT)
- `.github/github-actions-deploy-key.pub` - Public SSH key
- `.github/DEPLOYMENT_SETUP.md` - This guide

---

## 🔧 SETUP INSTRUCTIONS (One-Time Only)

### **Step 1: Add Public SSH Key to Your Droplet** ⏱️ 2 minutes

1. **Copy the public key:**
   - Open: `.github/github-actions-deploy-key.pub`
   - Copy the entire contents (starts with `ssh-ed25519`)

2. **SSH into your droplet:**
   ```bash
   ssh root@68.183.149.106
   ```
   Password: `fNKmw2u6FW9N!ji`

3. **Add the key to authorized_keys:**
   ```bash
   # Create .ssh directory if it doesn't exist
   mkdir -p ~/.ssh
   chmod 700 ~/.ssh
   
   # Add the public key (paste the key you copied)
   echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFZGS/Xvoo41YLGFuUd37qaSgf7ZePtFtLEbUpPSbyrX github-actions-deploy@stupidiots.com" >> ~/.ssh/authorized_keys
   
   # Set proper permissions
   chmod 600 ~/.ssh/authorized_keys
   
   # Exit SSH
   exit
   ```

4. **Test the connection** (from your local machine):
   ```bash
   ssh -i .github/github-actions-deploy-key root@68.183.149.106
   ```
   - Should connect without password ✅
   - If it works, type `exit`

---

### **Step 2: Add Secrets to GitHub Repository** ⏱️ 3 minutes

1. **Go to your GitHub repository:**
   - Visit: https://github.com/tiptophimp/idiot-token

2. **Navigate to Settings:**
   - Click **"Settings"** tab (top right)
   - Click **"Secrets and variables"** → **"Actions"** (left sidebar)

3. **Add Secret #1: SSH_PRIVATE_KEY**
   - Click **"New repository secret"**
   - Name: `SSH_PRIVATE_KEY`
   - Value: Open `.github/github-actions-deploy-key` and copy **ENTIRE contents** including:
     ```
     -----BEGIN OPENSSH PRIVATE KEY-----
     [all the lines]
     -----END OPENSSH PRIVATE KEY-----
     ```
   - Click **"Add secret"**

4. **Add Secret #2: SERVER_IP**
   - Click **"New repository secret"**
   - Name: `SERVER_IP`
   - Value: `68.183.149.106`
   - Click **"Add secret"**

5. **Verify secrets exist:**
   - You should see:
     - ✅ `SSH_PRIVATE_KEY`
     - ✅ `SERVER_IP`

---

### **Step 3: Test the Pipeline** ⏱️ 5 minutes

1. **Commit and push the workflow:**
   ```bash
   git add .github/
   git commit -m "🚀 Add GitHub Actions auto-deployment pipeline"
   git push origin master
   ```

2. **Watch the deployment:**
   - Go to: https://github.com/tiptophimp/idiot-token/actions
   - You should see your workflow running
   - Click on the workflow to watch live logs
   - Wait for completion (~2-3 minutes)

3. **Verify deployment:**
   - Visit: http://stupidiots.com
   - Check: http://68.183.149.106
   - Both should show your updated site ✅

---

## 🎯 HOW TO USE THE PIPELINE

### **Automatic Deployment (Main Use Case):**

Every time you push to `main` or `master` branch, the site auto-deploys:

```bash
# Make changes to your site
nano index.html

# Commit and push
git add .
git commit -m "Update homepage content"
git push

# 🎉 Deployment happens automatically!
# Check progress at: https://github.com/tiptophimp/idiot-token/actions
```

### **Manual Deployment (Trigger Manually):**

1. Go to: https://github.com/tiptophimp/idiot-token/actions
2. Click **"🚀 Deploy to stupidiots.com"** workflow
3. Click **"Run workflow"** dropdown
4. Click **"Run workflow"** button
5. Deployment starts immediately

---

## 📊 WHAT THE PIPELINE DOES

### **Automated Steps:**

1. ✅ **Checks out your code** from GitHub
2. ✅ **Creates deployment package** (excludes .git, secure/, etc.)
3. ✅ **Backs up current site** (keeps last 5 backups)
4. ✅ **Uploads to server** via SSH
5. ✅ **Extracts and sets permissions**
6. ✅ **Reloads Nginx** (if running)
7. ✅ **Runs health checks** (verifies site is up)
8. ✅ **Cleans up temp files**
9. ✅ **Shows deployment summary**

### **Deployment Time:**
- ⏱️ Total: **2-3 minutes** from push to live

### **Backup System:**
- Location: `/var/www/backups/` on server
- Format: `backup-YYYYMMDD-HHMMSS.tar.gz`
- Retention: Last 5 backups kept

---

## 🔄 ROLLBACK (If Something Goes Wrong)

### **Option 1: Rollback via SSH (Fast)**

```bash
# SSH into server
ssh root@68.183.149.106

# List available backups
ls -lh /var/www/backups/

# Restore a backup (replace with actual backup filename)
cd /var/www/html
rm -rf *
tar -xzf /var/www/backups/backup-20251012-143022.tar.gz

# Exit
exit
```

### **Option 2: Rollback via Git (Proper)**

```bash
# Find the commit you want to revert to
git log --oneline

# Revert to previous commit (creates new commit)
git revert HEAD

# Or reset to specific commit (replace COMMIT_HASH)
git reset --hard COMMIT_HASH

# Push (triggers auto-deploy)
git push --force
```

---

## 🔍 MONITORING & DEBUGGING

### **View Deployment Logs:**
1. Go to: https://github.com/tiptophimp/idiot-token/actions
2. Click on any workflow run
3. Expand steps to see detailed logs

### **Common Issues:**

#### ❌ **"Permission denied (publickey)"**
- **Fix:** Re-check Step 1 - public key not added correctly to droplet

#### ❌ **"Health check failed"**
- **Fix:** SSH into server and check:
  ```bash
  systemctl status nginx
  ls -la /var/www/html/
  ```

#### ❌ **"Backup failed"**
- **Fix:** Create backup directory:
  ```bash
  ssh root@68.183.149.106 "mkdir -p /var/www/backups"
  ```

---

## 🛡️ SECURITY NOTES

### **✅ DO:**
- Keep `.github/github-actions-deploy-key` (private key) **LOCAL ONLY**
- It's already in `.gitignore` - don't commit it
- Store GitHub Secrets securely (only visible to repo admins)
- Regularly update server packages

### **❌ DON'T:**
- Never commit the private SSH key
- Never share your GitHub Secrets
- Never disable SSH key authentication

---

## 📈 NEXT STEPS (Optional Enhancements)

### **Add Slack/Discord Notifications:**
- Get notified when deployments succeed/fail
- Requires webhook URL in GitHub Secrets

### **Add Testing:**
- Run HTML validators before deploy
- Check for broken links
- Validate image sizes

### **Add Staging Environment:**
- Create `staging` branch
- Deploy to staging.stupidiots.com first
- Test before promoting to production

### **SSL/HTTPS:**
- Install Let's Encrypt certificate
- Auto-renewal in workflow
- Force HTTPS redirects

---

## 🎉 CONGRATULATIONS!

You now have a **professional-grade deployment pipeline** just like major tech companies use!

### **What You've Gained:**
- ⚡ **Instant deployments** (push → live in 2-3 minutes)
- 🔄 **Automatic backups** before every deploy
- 🏥 **Health checks** ensure site stays up
- 📊 **Deployment history** and logs
- 🛡️ **Rollback capability** if needed
- 🚀 **Zero manual work** - just push code

---

## 📞 NEED HELP?

If you encounter issues:
1. Check GitHub Actions logs first
2. Verify GitHub Secrets are set correctly
3. Test SSH connection manually
4. Check server logs: `ssh root@68.183.149.106 "journalctl -u nginx -n 50"`

---

**Created:** October 12, 2025  
**Status:** Ready to deploy  
**Automation:** ✅ Active  
**Repository:** https://github.com/tiptophimp/idiot-token

