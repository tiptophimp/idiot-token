# 🔑 GitHub SSH Secrets Setup

## ✅ **Ready to Configure!**

You have an SSH key ready: `stupidiots-deploy` (ed25519)

## 🎯 **Add These 3 GitHub Secrets:**

Go to: https://github.com/tiptophimp/idiot-token/settings/secrets/actions

### **Secret 1: HOSTINGER_SSH_KEY**
- **Name**: `HOSTINGER_SSH_KEY`
- **Value**: Your private SSH key content (the entire private key file)
- **How to get**: Download from Hostinger SSH Access section

### **Secret 2: HOSTINGER_SSH_HOST**
- **Name**: `HOSTINGER_SSH_HOST`
- **Value**: `us-bos-web1384.main-hosting.eu`

### **Secret 3: HOSTINGER_SSH_USER**
- **Name**: `HOSTINGER_SSH_USER`
- **Value**: `u939125353`

## 🔍 **How to Get Your Private Key:**

1. **Go to Hostinger Control Panel**
2. **Navigate to SSH Access**
3. **Find your key**: `stupidiots-deploy`
4. **Download or copy the private key**
5. **Add it as `HOSTINGER_SSH_KEY` secret**

## 🚀 **After Adding Secrets:**

1. **Go to Actions tab** in GitHub
2. **Find the latest workflow run**
3. **Click "Re-run jobs"** to test with new secrets
4. **Watch it deploy automatically!**

## ✅ **Expected Result:**

- Workflow will connect via SSH
- Files will sync to `/public_html/`
- Your site will update at https://stupidiots.com
- **Fully automated deployment!** 🎉

---
*Once you add these secrets, every push to main will automatically deploy to your live site!*
