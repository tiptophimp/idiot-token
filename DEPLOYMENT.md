# IDIOT Token - Simple Deployment Guide

## 🚀 How to Deploy Your Website

### **One Command Deployment:**

```powershell
.\deploy-now.ps1
```

**That's it!** Your website deploys in ~10 seconds.

---

## 📋 Complete Workflow

### When You Make Changes:

1. **Edit your files** (HTML, CSS, images, docs, etc.)

2. **Deploy to website:**
   ```powershell
   .\deploy-now.ps1
   ```

3. **Save to Git (optional):**
   ```powershell
   git add .
   git commit -m "Describe your changes"
   git push origin master
   ```

---

## 🔧 Alternative Deployment Methods

### **Method 1: PowerShell (Recommended)**
```powershell
.\deploy-now.ps1
```
- ✅ Fastest (10 seconds)
- ✅ Uses SSH key (no password)
- ✅ Most reliable

### **Method 2: Password-based**
```batch
deploy-password.bat
```
- ✅ Works if SSH key has issues
- ⚠️ Requires entering password: `fNKmw2u6FW9N!ji`

### **Method 3: Manual SSH**
```powershell
ssh -i "$env:USERPROFILE\.ssh\idiot_deploy_key" root@68.183.149.106
# Then manually update files on server
```
- ⚠️ For advanced users only

---

## 🌐 After Deployment

**Your website updates instantly at:**
- **https://stupidiots.com**

**Verify deployment:**
- Check website in browser
- Hit Ctrl+F5 to force refresh (clear cache)

---

## ❓ Troubleshooting

### "SSH key not found"
- **Solution:** Use `deploy-password.bat` instead

### "Permission denied"
- **Solution:** Check SSH key exists: `ls "$env:USERPROFILE\.ssh\idiot_deploy_key"`

### "tar: command not found"
- **Solution:** Install Git for Windows (includes tar)

---

## 📊 What Gets Deployed

When you run `.\deploy-now.ps1`, it:
1. ✅ Creates deployment package (excludes .git, secure files)
2. ✅ Uploads to server via SCP
3. ✅ Extracts files to `/var/www/html`
4. ✅ Sets proper permissions
5. ✅ Cleans up temporary files

---

## 🎯 Best Practices

- **Deploy often:** Small changes are easier to debug
- **Test locally first:** Review changes before deploying
- **Backup important files:** Git is your backup
- **Check the website:** Always verify after deployment

---

## 🚫 What NOT to Deploy

These files are automatically excluded:
- `.git/` (Git history)
- `secure/` (private keys, passwords)
- `*.pem` (SSH keys)
- `*password*.txt` (password files)
- `*.csv`, `*.xlsx` (internal spreadsheets)
- `audit-log.zip` (sensitive audit files)

---

## 💡 Why No GitHub Actions?

GitHub Actions kept failing due to runner environment issues. 

**Manual deployment is:**
- ✅ More reliable
- ✅ Faster to execute
- ✅ Easier to debug
- ✅ Simpler to understand

**For a single-person project, one-command deployment is perfect!**

---

**Need help? Check the script: `deploy-now.ps1`**

**Website:** https://stupidiots.com  
**Contract:** 0xC29EF04CFFe38012dcfc1E96a2B368443f298dE1  
**Network:** Base Mainnet

