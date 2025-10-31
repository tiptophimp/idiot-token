# DNS Restoration Plan for stupidiots.com
**Date:** October 21, 2025  
**Status:** Ready to execute after lunch

## Current Situation

### ✅ FIXED - GitHub Repository & Deployment
- Git repository restored to commit `58cf620` (v5.0 with rotating coins)
- CNAME file corrected to `www.stupidiots.com`
- GitHub Pages successfully deployed (#75)
- **The correct site is live on GitHub's servers and ready to serve**

### ❌ BROKEN - DNS Configuration
- Domain's nameservers still point to DigitalOcean (`ns1/2/3.digitalocean.com`)
- DNS zone was deleted from DigitalOcean 11 hours ago
- Result: Domain doesn't resolve at all

## Root Cause Analysis

**What happened:**
1. October 11: Site moved from Hostinger to DigitalOcean droplet
2. DNS nameservers changed to DigitalOcean
3. Recently: Moved to GitHub Pages, deleted DigitalOcean droplet
4. Today: Deleted stupidiots.com DNS zone from DigitalOcean
5. **Problem:** Nameservers still point to DigitalOcean where DNS zone no longer exists

**My mistake today:**
- Did `git reset --hard 58cf620` which accidentally reverted CNAME from `www.stupidiots.com` to `stupidiots.com`
- This broke the GitHub Pages custom domain configuration
- **Fixed:** Pushed corrected CNAME file

## Action Plan (After Lunch)

### Step 1: Switch Nameservers to Hostinger (5 minutes work)

**In Hostinger dashboard:**
1. Go to Domains → stupidiots.com → Manage
2. Find the "Connect domain" prompt
3. Click **"Connect"** to switch nameservers to:
   - `ns1.dns-parking.com`
   - `ns2.dns-parking.com`

**Timeline:** Takes effect immediately in Hostinger, but DNS propagation takes 24-48 hours globally

### Step 2: Configure DNS Records (After nameservers propagate)

**Once nameservers are switched (24-48 hours later):**

In Hostinger → Domains → stupidiots.com → DNS Management:

**Add 4 A Records (for apex domain):**
```
Type: A    Name: @    Points to: 185.199.108.153    TTL: 3600
Type: A    Name: @    Points to: 185.199.109.153    TTL: 3600
Type: A    Name: @    Points to: 185.199.110.153    TTL: 3600
Type: A    Name: @    Points to: 185.199.111.153    TTL: 3600
```

**Add 1 CNAME Record (for www subdomain):**
```
Type: CNAME    Name: www    Points to: tiptophimp.github.io    TTL: 3600
```

**Timeline:** 15-30 minutes after adding records

## Total Timeline

- **Today (after lunch):** Switch nameservers (5 minutes)
- **24-48 hours:** Nameserver propagation
- **Then:** Add DNS records (5 minutes)
- **15-30 minutes:** DNS propagation
- **TOTAL:** 1-2 days for site to be fully live

## Verification Commands

After nameserver switch:
```bash
nslookup stupidiots.com
# Should eventually show Hostinger nameservers
```

After DNS records are added:
```bash
nslookup www.stupidiots.com
# Should show: CNAME -> tiptophimp.github.io
# Then: IPs -> 185.199.xxx.xxx

nslookup stupidiots.com
# Should show: IPs -> 185.199.108/109/110/111.153
```

Or check online: https://dnschecker.org

## What's Currently Working

- ✅ GitHub Pages is serving the correct v5.0 site
- ✅ CNAME file correctly configured
- ✅ All site files are correct and deployed
- ✅ The site works if accessed via GitHub's direct URL

**The site is 100% ready - just waiting for DNS to point to it!**

## Future Prevention

**CRITICAL:** Always follow the documented workflow:
1. Make changes in `website/dev/`
2. Test locally with `python -m http.server 8004` (from website/dev/)
3. Copy to staging
4. Test staging
5. Commit to gh-pages branch
6. Verify deployment on live site

**NEVER:**
- Edit files directly in the root directory
- Skip local testing
- Use `git reset --hard` without checking what you're reverting
- Bypass the documented workflow

---

**Next action:** After lunch, switch nameservers in Hostinger




