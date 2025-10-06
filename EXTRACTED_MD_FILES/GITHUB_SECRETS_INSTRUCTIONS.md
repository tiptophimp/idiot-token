# 🔑 GitHub Secrets Setup Instructions

## **PRIVATE KEY RECEIVED ✅**

**Key Type:** ED25519 (OpenSSH format)  
**Comment:** hostinger-deploy@stupidiots.com

## **STEP 1: ADD TO GITHUB SECRETS**

### **Navigate to GitHub Repository:**
1. **Go to:** https://github.com/tiptophimp/idiot-token
2. **Click:** Settings (in repository menu)
3. **Click:** Secrets and variables → Actions
4. **Click:** "New repository secret"

### **Add These 3 Secrets:**

#### **Secret 1: HOSTINGER_SSH_KEY**
- **Name:** `HOSTINGER_SSH_KEY`
- **Value:** Copy the ENTIRE private key below (including BEGIN and END lines):

```
-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW
QyNTUxOQAAACDLaeOaul1Y4wxpIo06aHSsKS4NVeIrnH6Md07EimkMpwAAAKgaUgo/GlIK
PwAAAAtzc2gtZWQyNTUxOQAAACDLaeOaul1Y4wxpIo06aHSsKS4NVeIrnH6Md07EimkMpw
AAAEC6jE+uDJWeGDxKxByRADnQ2fVPN2dZH4ATRRNNKFSft8tp45q6XVjjDGkijTpodKwp
Lg1V4iucfox3TsSKaQynAAAAH2hvc3Rpbmdlci1kZXBsb3lAc3R1cGlkaW90cy5jb20BAg
MEBQY=
-----END OPENSSH PRIVATE KEY-----
```

#### **Secret 2: HOSTINGER_SSH_HOST**
- **Name:** `HOSTINGER_SSH_HOST`
- **Value:** `us-bos-web1384.main-hosting.eu`

#### **Secret 3: HOSTINGER_SSH_USER**
- **Name:** `HOSTINGER_SSH_USER`
- **Value:** `u939125353`

## **STEP 2: ADD PUBLIC KEY TO HOSTINGER**

### **Get the Public Key:**
The public key corresponding to your private key is:

```
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMtp45q6XVjjDGkijTpodKwpLg1V4iucfox3TsSKaQyn hostinger-deploy@stupidiots.com
```

### **Add to Hostinger:**
1. **Login to Hostinger** control panel
2. **Go to:** Advanced → SSH Access
3. **Add the public key** above to authorized_keys
4. **Save** the configuration

## **STEP 3: TEST AUTOMATED DEPLOYMENT**

### **After Adding Secrets:**
1. **Make a small change** to `10_MAIN_SITE/index.html`
2. **Commit and push:**
   ```bash
   git add 10_MAIN_SITE/index.html
   git commit -m "Test automated deployment with new SSH key"
   git push origin main
   ```
3. **Check GitHub Actions:** https://github.com/tiptophimp/idiot-token/actions
4. **Verify live site:** https://stupidiots.com

## **STEP 4: SUCCESS INDICATORS**

### **GitHub Actions Success:**
- ✅ **Green checkmark** on workflow run
- ✅ **"Deploy to Hostinger"** step completed
- ✅ **No SSH connection errors**

### **Live Site Success:**
- ✅ **Site updates** automatically after push
- ✅ **Changes appear** on live site within 2-3 minutes
- ✅ **No manual deployment** needed

## **TROUBLESHOOTING**

### **If GitHub Actions Fails:**
- **Check:** All 3 secrets are added correctly
- **Verify:** Private key includes BEGIN/END lines
- **Ensure:** No extra spaces or characters
- **Test:** Manual deployment with `bash manual_deploy.sh`

### **If SSH Connection Fails:**
- **Verify:** Public key is added to Hostinger
- **Check:** Host and user values are correct
- **Ensure:** Key format is correct (ED25519)

## **🎯 NEXT ACTION:**

**Add the 3 secrets to GitHub, then we'll test the automated deployment!**

---

**Once you've added the secrets, let me know and I'll help you test it!** 🚀
