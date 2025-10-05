# 🚀 GitHub → Hostinger Auto-Deployment Setup

## ✅ What's Configured

Your GitHub repository now has a complete auto-deployment workflow that will:
- ✅ Trigger on every push to `main` branch
- ✅ Create deployment package from `cleaned_deployment` folder
- ✅ Upload files directly to Hostinger via FTP
- ✅ Create backup artifacts for each deployment

## 🔧 Required GitHub Secrets Setup

You need to add these secrets to your GitHub repository:

### 1. Go to GitHub Repository Settings
- Visit: https://github.com/tiptophimp/idiot-token/settings/secrets/actions
- Click "New repository secret" for each secret below

### 2. Add These Secrets (SSH Method - Recommended):

| Secret Name | Value | Description |
|-------------|-------|-------------|
| `HOSTINGER_SSH_KEY` | `[Your Private SSH Key]` | Your Hostinger private SSH key |
| `HOSTINGER_SSH_HOST` | `us-bos-web1384.main-hosting.eu` | Your Hostinger SSH host |
| `HOSTINGER_SSH_USER` | `u939125353` | Your Hostinger SSH username |

### 3. SSH Key Setup:

**You already have an SSH key configured!** The public key is:
```
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDaU3CraneEIyrTcD0hK0hKS/n/xIGxf+kbJiNs2sOOqRXPBmF8jmGCwHPL1grfC0vZtQyptpS4V6bLK8XFd6kJE3wa7TuOzDNBjGqU0oxrtm3GgBiUz9gJzmSFg1vPbL709TQRt1Uuqj98CXhMp3vtXX5tVc+sfJt3OZFdNry9Y14yffeTZeorXTxe63NMNT1oy0QJhC+0CMI0hfIyRA3BQSh9bituTFEn+ySdMftpgksxgU2qUz9rFWAHsTBHhr0NrzQnjv+Xl+V6jJa6QKbFIW6qGkbdEOMUrVAYgBOEYw61bs3fKPCoB7VBoBb0M3/oYBpW1yeUwxxmIGaJE+1YFi0S9o1aLTo9SU6UmC2hswn29iBJ9R5wgUB6ar9rPYqC3OVekJ1ZBthOCy86n0fN9ZUwGGYrrL+t5ZD+IrnLewJ1Y9oZBJaoy2ApBoyHyk6VD3v5ixX+n2IW422zH4STrAEXCN9gPV4Svy6+svi5kdyDtJcr+x+5mqdhbeO74hU= u939125353@us-bos-web1384.main-hosting.eu
```

**To get your private key:**
1. Go to your Hostinger control panel
2. Navigate to SSH Access section
3. Download or copy your private key
4. Add it as `HOSTINGER_SSH_KEY` secret

## 🎯 How It Works

### Automatic Deployment Flow:
1. **Push to GitHub** → Triggers workflow
2. **Package Creation** → Uses `cleaned_deployment` folder
3. **FTP Upload** → Direct upload to Hostinger
4. **Live Site** → Updates automatically at https://stupidiots.com

### Manual Trigger:
- Go to Actions tab in GitHub
- Click "Deploy to Hostinger" workflow
- Click "Run workflow" button

## 📁 Deployment Source

The workflow prioritizes these folders in order:
1. `cleaned_deployment/` (preferred - your clean files)
2. `01_LIVE_SITE/main_site/` (fallback)
3. `public_html/` (last resort)

## 🔍 Monitoring Deployments

- **GitHub Actions**: https://github.com/tiptophimp/idiot-token/actions
- **Live Site**: https://stupidiots.com
- **Deployment Logs**: Check Actions tab for detailed logs

## 🚨 Troubleshooting

### If deployment fails:
1. Check GitHub Actions logs
2. Verify FTP credentials are correct
3. Ensure `cleaned_deployment` folder exists
4. Check Hostinger file permissions

### If files don't appear:
1. Verify FTP path is `/public_html/`
2. Check if files are being overwritten
3. Look for permission issues in logs

## 🎉 Ready to Deploy!

Once you add the GitHub secrets, every push to main will automatically deploy to your live site!

---
*Created by Novalex - Your AI Assistant* 🤖
