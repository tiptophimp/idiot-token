# GitHub Actions Deployment Setup Guide

## 🚨 Current Issue

Your GitHub Actions workflow is failing because the required secrets are not configured.

**Missing Secrets:**
- ❌ `IDIOT_SSH_PRIVATE_KEY` - SSH private key for server authentication
- ❌ `SERVER_IP` - Your server IP address
- ❌ `SERVER_USER` - Server username

---

## 🔧 Solution: Set Up SSH Key Authentication

### Step 1: Generate SSH Key on Your Local Machine

**On Windows (Git Bash):**
```bash
ssh-keygen -t ed25519 -C "idiot-token-deployment" -f ~/.ssh/idiot_deploy_key
```

**Press Enter** when prompted for passphrase (leave it empty for automation).

This creates two files:
- `~/.ssh/idiot_deploy_key` (private key) ← This goes to GitHub
- `~/.ssh/idiot_deploy_key.pub` (public key) ← This goes to server

---

### Step 2: Copy Public Key to Server

**Option A: Using password (one time):**
```bash
type %USERPROFILE%\.ssh\idiot_deploy_key.pub | ssh root@68.183.149.106 "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
```

**Password when prompted:** `fNKmw2u6FW9N!ji`

**Option B: Manual copy:**
1. Read the public key:
   ```bash
   type %USERPROFILE%\.ssh\idiot_deploy_key.pub
   ```
2. SSH into server:
   ```bash
   ssh root@68.183.149.106
   ```
3. Add the key:
   ```bash
   mkdir -p ~/.ssh
   echo "PASTE_PUBLIC_KEY_HERE" >> ~/.ssh/authorized_keys
   chmod 600 ~/.ssh/authorized_keys
   ```

---

### Step 3: Test SSH Key Authentication

```bash
ssh -i %USERPROFILE%\.ssh\idiot_deploy_key root@68.183.149.106 "echo 'SSH key works!'"
```

If this works without prompting for password, you're ready!

---

### Step 4: Add Secrets to GitHub

1. **Go to your GitHub repository:**
   https://github.com/tiptophimp/idiot-token

2. **Navigate to Settings:**
   Click `Settings` → `Secrets and variables` → `Actions`

3. **Add three secrets:**

   **A) IDIOT_SSH_PRIVATE_KEY**
   - Click `New repository secret`
   - Name: `IDIOT_SSH_PRIVATE_KEY`
   - Value: Copy the ENTIRE content of your private key:
     ```bash
     type %USERPROFILE%\.ssh\idiot_deploy_key
     ```
   - Should start with `-----BEGIN OPENSSH PRIVATE KEY-----`
   - Should end with `-----END OPENSSH PRIVATE KEY-----`
   - Click `Add secret`

   **B) SERVER_IP**
   - Click `New repository secret`
   - Name: `SERVER_IP`
   - Value: `68.183.149.106`
   - Click `Add secret`

   **C) SERVER_USER**
   - Click `New repository secret`
   - Name: `SERVER_USER`
   - Value: `root`
   - Click `Add secret`

---

### Step 5: Test GitHub Actions

Once secrets are added:

1. Go to your repo on GitHub
2. Make a small change (edit README.md, add a space)
3. Commit and push
4. Go to `Actions` tab
5. Watch the workflow run

It should now succeed! ✅

---

## 🚀 Alternative: Manual Deployment (Works Now)

If you want to deploy RIGHT NOW without setting up GitHub Actions:

### Using Password-Based Script:

```batch
deploy-password.bat
```

This will:
1. Create deployment package
2. Upload to server (you'll enter password)
3. Extract and configure on server
4. ✅ Done!

**Password:** `fNKmw2u6FW9N!ji`

---

## 📋 Quick Setup Checklist

- [ ] Generate SSH key pair on local machine
- [ ] Copy public key to server's `~/.ssh/authorized_keys`
- [ ] Test SSH key authentication (no password prompt)
- [ ] Add `IDIOT_SSH_PRIVATE_KEY` to GitHub Secrets
- [ ] Add `SERVER_IP` to GitHub Secrets
- [ ] Add `SERVER_USER` to GitHub Secrets
- [ ] Push a change to trigger workflow
- [ ] Verify deployment succeeds

---

## 🆘 Troubleshooting

### "Permission denied (publickey)"
- Public key not properly added to server
- Try manual copy method in Step 2B

### "Host key verification failed"
- First time connecting to server
- Add to known_hosts: `ssh-keyscan 68.183.149.106 >> ~/.ssh/known_hosts`

### "tar: command not found" on Windows
- Install Git for Windows (includes tar)
- Or use WSL (Windows Subsystem for Linux)

### Workflow still fails after adding secrets
- Check secrets are named EXACTLY as shown (case-sensitive)
- Ensure private key includes BEGIN/END lines
- Check GitHub Actions logs for specific error

---

## 🎯 Recommended Approach

**For now:**
1. Use `deploy-password.bat` for immediate deployments
2. Deploy your v2.0 realistic tokenomics to the website

**For automation:**
1. Set up SSH keys (10 minutes)
2. Add secrets to GitHub (2 minutes)
3. Future deployments = just push to GitHub

---

**Need help?** Check the GitHub Actions logs in the `Actions` tab of your repository for specific error messages.

