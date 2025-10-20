# SSL Certificate Fix for stupidiots.com

## Problem Identified
- **Error:** `net::ERR_CERT_COMMON_NAME_INVALID`
- **Cause:** GitHub Pages certificate is for `*.github.io` not `stupidiots.com`
- **Root Cause:** Custom domain HTTPS not properly enabled in GitHub settings

## Current Status
✅ DNS configured correctly (pointing to GitHub Pages)
✅ CNAME file exists in repository
❌ GitHub Pages custom domain HTTPS not activated

## Fix Steps (MANUAL - User Must Complete)

### 1. Access GitHub Pages Settings
Go to: https://github.com/tiptophimp/idiot-token/settings/pages

### 2. Configure Custom Domain
In the "Custom domain" section:
- If empty: Enter `stupidiots.com` and click Save
- If already filled: Remove it, wait 10 seconds, re-enter `stupidiots.com`, click Save

### 3. Enable HTTPS
- Check the box: ☑️ **Enforce HTTPS**
- GitHub will auto-provision Let's Encrypt SSL certificate
- **Wait time:** 5-15 minutes for certificate provisioning

### 4. Verification
After 15 minutes, check:
```bash
curl -I https://stupidiots.com
```

Should see:
- `HTTP/2 200` (not certificate error)
- Valid SSL certificate for stupidiots.com

## Alternative: Use GitHub CLI (If Installed)
```bash
gh api repos/tiptophimp/idiot-token/pages \
  --method PUT \
  -F source[branch]=gh-pages \
  -F cname=stupidiots.com \
  -F https_enforced=true
```

## Why This Happens
GitHub Pages requires explicit configuration to:
1. Recognize custom domains
2. Request SSL certificates from Let's Encrypt
3. Install and serve certificates

Simply having a CNAME file is not enough - the repository settings must also be configured.

## Expected Timeline
- DNS propagation: Already complete ✅
- GitHub domain verification: 1-2 minutes
- SSL certificate issuance: 5-15 minutes
- Full propagation: Up to 24 hours (usually much faster)

## Support
If issue persists after 24 hours:
- Check GitHub Pages status: https://www.githubstatus.com
- Contact GitHub Support
- Consider using Cloudflare for SSL proxy

---
Date: 2025-10-20
Status: Awaiting user action in GitHub settings

