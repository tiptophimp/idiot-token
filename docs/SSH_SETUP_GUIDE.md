# 🔐 SSH Setup Guide for Windows

**Server:** 68.183.149.106  
**User:** deploy  
**Purpose:** Access DigitalOcean server for deployments  

---

## ✅ Step 1: Check if SSH Key Exists

### Option A: Check for existing key
```powershell
# Check if you have an SSH key already
Get-ChildItem $env:USERPROFILE\.ssh\
```

Look for files like:
- `id_rsa` (private key)
- `id_rsa.pub` (public key)
- `deploy_key` or similar

### Option B: Find the key location
Check these locations:
- `C:\Users\Ernest\.ssh\`
- `C:\idiot-project\deploy\ssh-keys\`
- Anywhere you might have saved it

---

## ✅ Step 2: If No Key Exists, Create One

### Generate new SSH key:
```powershell
# Create .ssh directory if it doesn't exist
mkdir $env:USERPROFILE\.ssh -ErrorAction SilentlyContinue

# Generate new key
ssh-keygen -t rsa -b 4096 -C "deploy@stupidiots.com" -f $env:USERPROFILE\.ssh\deploy_key

# Press Enter for no passphrase (or set one if you prefer)
```

This creates:
- `C:\Users\Ernest\.ssh\deploy_key` (private - keep secret!)
- `C:\Users\Ernest\.ssh\deploy_key.pub` (public - add to server)

---

## ✅ Step 3: Add Public Key to Server

### You need to add the public key to the server. Two options:

### Option A: If you have password access
```powershell
# Copy public key to clipboard
Get-Content $env:USERPROFILE\.ssh\deploy_key.pub | clip

# Then SSH with password and add it:
ssh deploy@68.183.149.106

# On server, run:
mkdir -p ~/.ssh
chmod 700 ~/.ssh
nano ~/.ssh/authorized_keys
# Paste the key (Ctrl+Shift+V), save (Ctrl+O, Enter, Ctrl+X)
chmod 600 ~/.ssh/authorized_keys
exit
```

### Option B: If key is already on server
The key might already be there from previous setup. Test it (Step 4).

---

## ✅ Step 4: Test SSH Connection

### Quick test:
```powershell
# Test connection (without key specified - uses default)
ssh deploy@68.183.149.106 "echo 'SSH works!'"

# Test with specific key
ssh -i $env:USERPROFILE\.ssh\deploy_key deploy@68.183.149.106 "echo 'SSH works!'"
```

### What you should see:
- ✅ `SSH works!` = Connection successful
- ❌ `Permission denied` = Key not on server or wrong key
- ❌ `Connection refused` = Server issue or firewall

---

## ✅ Step 5: Copy Key to Project Directory

### For deployment scripts to work:
```powershell
# Copy private key to project (scripts expect it here)
Copy-Item $env:USERPROFILE\.ssh\deploy_key C:\idiot-project\deploy\ssh-keys\deploy_key

# Verify it's there
Get-ChildItem C:\idiot-project\deploy\ssh-keys\
```

**IMPORTANT:** This directory is gitignored, so the key won't be committed.

---

## ✅ Step 6: Verify Server Access

Run this test script:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/test-ssh.ps1
```

Should show:
- ✅ SSH connection works
- ✅ Server details (OS, disk space, etc.)
- ✅ Production directory exists
- ✅ Permissions are correct

---

## 🔍 Troubleshooting

### Problem: "Permission denied (publickey)"
**Solution:** 
1. Public key not on server, OR
2. Using wrong private key

**Fix:**
```powershell
# Add public key to server (see Step 3)
# OR use correct key path
ssh -i C:\path\to\your\key deploy@68.183.149.106
```

### Problem: "ssh: command not found"
**Solution:** SSH not installed or not in PATH

**Fix:**
- Windows 10/11: SSH should be installed by default
- Check: `Get-Command ssh`
- If missing: Install OpenSSH (Windows Settings > Apps > Optional Features)

### Problem: "Connection timed out"
**Solution:** 
1. Server is down, OR
2. Firewall blocking, OR
3. Wrong IP address

**Fix:**
```powershell
# Test if server is reachable
Test-NetConnection -ComputerName 68.183.149.106 -Port 22
```

### Problem: Key permissions error
**Solution:** Windows doesn't need chmod, but ensure key is in right place

**Fix:**
```powershell
# Key should be in:
C:\Users\Ernest\.ssh\deploy_key
# OR
C:\idiot-project\deploy\ssh-keys\deploy_key
```

---

## 📋 Quick Reference Commands

```powershell
# Test SSH
ssh deploy@68.183.149.106 "echo 'SSH works!'"

# Test with specific key
ssh -i C:\idiot-project\deploy\ssh-keys\deploy_key deploy@68.183.149.106 "echo 'Test'"

# Check what's in production directory
ssh -i C:\idiot-project\deploy\ssh-keys\deploy_key deploy@68.183.149.106 "ls -la /var/www/stupidiots.com/public_html/"

# Check disk space
ssh -i C:\idiot-project\deploy\ssh-keys\deploy_key deploy@68.183.149.106 "df -h"

# Check nginx status
ssh -i C:\idiot-project\deploy\ssh-keys\deploy_key deploy@68.183.149.106 "sudo systemctl status nginx"
```

---

## ✅ Next Steps After SSH Works

1. Run deployment script audit fixes
2. Test staging deployment
3. Verify production status
4. Setup automated deployments

---

**Created:** 2025-10-16  
**For:** stupidiots.com deployment setup  
**Status:** Ready to follow

