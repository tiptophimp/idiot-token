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

### 2. Add These Secrets

| Secret Name | Value | Description |
|-------------|-------|-------------|
| `HOSTINGER_FTP_SERVER` | `stupidiots.com` | Your Hostinger domain |
| `HOSTINGER_FTP_USERNAME` | `u939125353.srv855356hstgrcloud` | Your Hostinger FTP username |
| `HOSTINGER_FTP_PASSWORD` | `r!dZuXG3ohvr2F2D` | Your Hostinger FTP password |

### 3. Alternative: SSH Key Method (More Secure)

If you prefer SSH keys over FTP passwords:

1. Generate SSH key pair:
```bash
ssh-keygen -t rsa -b 4096 -C "github-deploy@stupidiots.com" -f hostinger_deploy_key
```

2. Add public key to Hostinger:
   - Copy `hostinger_deploy_key.pub` content
   - Add to Hostinger SSH keys section

3. Add these secrets instead:
   - `HOSTINGER_SSH_HOST`: `stupidiots.com`
   - `HOSTINGER_SSH_USERNAME`: `u939125353`
   - `HOSTINGER_SSH_PRIVATE_KEY`: Content of `hostinger_deploy_key` (private key)

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
