# GitHub Organization Account Guide

## What is a GitHub Organization?

A GitHub Organization is a **shared account** where multiple people can collaborate across many projects at once. Think of it as a "company account" vs your personal account.

---

## Key Differences: Personal vs Organization

| Feature | Personal Account | Organization Account |
|---------|-----------------|---------------------|
| **Cost** | Free for public repos | **Free for public repos** |
| **Repository deletion protection** | ❌ No | ✅ Yes (with rulesets) |
| **Team management** | N/A | ✅ Create teams with different permissions |
| **Audit logs** | Basic | ✅ Advanced (90-day retention) |
| **Repository rulesets** | Branch protection only | ✅ Repo-level and org-level rulesets |
| **SAML/SSO** | ❌ No | ✅ Yes (Enterprise only) |
| **Billing** | Per user | Per organization |
| **Who owns the repos?** | You personally | The organization (survives if you leave) |

---

## ✅ Pros of Using an Organization

### Security & Control:
1. **Prevent repo deletion** with org-level rulesets
2. **Granular permissions:** Owner, Admin, Write, Read roles
3. **Team-based access:** Create teams (e.g., "Core Devs", "Auditors") with specific permissions
4. **Audit logs:** See who did what and when
5. **Required 2FA:** Force all members to use two-factor authentication

### Collaboration:
1. **Multiple owners:** No single point of failure
2. **Professional appearance:** `github.com/IDIOT-Token/idiot-token` instead of personal username
3. **Separate personal and project work**
4. **Easier to onboard/offboard contributors**

### Advanced Features (free):
1. **Organization-wide rulesets:** Apply protection rules to all repos at once
2. **Pinned repositories:** Showcase key projects
3. **Organization profile README:** Custom landing page
4. **GitHub Sponsors:** Accept donations/funding as an organization
5. **GitHub Pages with custom domain** per project

---

## ❌ Cons / Considerations

1. **Slight complexity:** One more account to manage
2. **Transfer process:** Repos need to be transferred (takes ~5 minutes)
3. **Old links redirect:** `tiptophimp/idiot-token` → `IDIOT-Org/idiot-token` (GitHub handles this automatically)
4. **CI secrets:** Need to be reconfigured in the new org settings
5. **No going back easily:** Can transfer back, but it's a manual process

---

## Cost Breakdown

### Free Tier (Perfect for IDIOT):
- ✅ Unlimited public repositories
- ✅ Unlimited collaborators
- ✅ 2,000 GitHub Actions minutes/month
- ✅ 500MB GitHub Packages storage
- ✅ Community support
- ✅ Repository rulesets (the main reason you'd do this)

### GitHub Team ($4/user/month):
- Everything in Free, plus:
- 3,000 Actions minutes/month
- Draft pull requests
- Protected branches for private repos
- Multiple reviewers

### GitHub Enterprise ($21/user/month):
- SAML SSO
- Advanced auditing
- Priority support

**For IDIOT:** Free tier is perfect. You're only using public repos and CI.

---

## What's Involved in Setting Up?

### Step 1: Create the Organization (5 minutes)
1. Go to https://github.com/settings/organizations
2. Click **New organization**
3. Choose **Free** plan
4. Pick a name: e.g., `IDIOT-Token`, `StupidIdiots`, `IDIOT-Project`
5. Add your email and agree to ToS

### Step 2: Transfer the Repository (5 minutes)
1. Go to your current repo: https://github.com/tiptophimp/idiot-token
2. **Settings** → **General** → scroll to **Danger Zone** → **Transfer ownership**
3. Type the new organization name
4. Confirm transfer
5. **All stars, forks, issues, PRs, and commit history transfer with it**

### Step 3: Reconfigure CI/CD (10 minutes)
1. Go to org settings: `https://github.com/organizations/IDIOT-Token/settings/secrets/actions`
2. Add secrets:
   - `SSH_PRIVATE_KEY` (your deploy key)
   - `DROPLET_HOST` (68.183.149.106)
   - `DROPLET_USER` (deploy)
3. Update any workflows that reference the old repo path (usually auto-updates)

### Step 4: Set Up Organization Rulesets (5 minutes)
1. **Organization Settings** → **Repository rulesets** → **New ruleset**
2. Name: `Repository Deletion Protection`
3. Target: **All repositories**
4. Rules:
   - ✅ **Restrict deletions** ← This is the key one
   - ✅ Restrict updates
   - ✅ Block force pushes
5. Save and activate

### Step 5: Configure Teams & Permissions (optional, 5 minutes)
1. **Teams** → **New team**
2. Create teams like:
   - `core` (Admin access)
   - `contributors` (Write access)
   - `auditors` (Read access)
3. Add members to teams

**Total time: ~30 minutes**

---

## What Happens to Existing Links?

GitHub automatically redirects:
- ✅ `github.com/tiptophimp/idiot-token` → `github.com/IDIOT-Token/idiot-token`
- ✅ All clone URLs redirect
- ✅ All issue/PR links redirect
- ✅ GitHub Actions continue working (with secret updates)
- ✅ Stars, forks, watchers all carry over

**Only thing that breaks:** Local git remotes (easy fix below)

---

## Local Git Remote Update (after transfer)

If you've already cloned the repo locally:

```bash
# Check current remote
git remote -v

# Update to new org URL
git remote set-url origin https://github.com/IDIOT-Token/idiot-token.git

# Or if using SSH
git remote set-url origin git@github.com:IDIOT-Token/idiot-token.git

# Verify
git remote -v
```

---

## Recommended Organization Name Options

1. **IDIOT-Token** (professional, clear)
2. **StupidIdiots** (matches your domain stupidiots.com)
3. **IDIOT-Project** (generic, scalable)
4. **TheIDIOT** (short, memorable)

I recommend: **`StupidIdiots`** since it matches your domain and branding.

---

## What You'll Gain for IDIOT

### Immediate Benefits:
1. ✅ **Repo deletion protection** (main goal)
2. ✅ Professional org URL: `github.com/StupidIdiots/idiot-token`
3. ✅ Separation of personal and project identity
4. ✅ Easier to add/remove contributors (auditors, developers)
5. ✅ Better optics for potential partners/investors

### Future Benefits:
1. Multiple projects under one brand (e.g., `StupidIdiots/contracts`, `StupidIdiots/governance`)
2. Org-wide GitHub Sponsors
3. Organization profile README (marketing page)
4. Team-based permissions for future hires/contributors

---

## Alternative: Stay Personal + Backups

If you don't want to create an org, you can:

1. **Set up automated backups:**
   ```bash
   # Daily cron job to mirror to GitLab
   git push --mirror gitlab.com/tiptophimp/idiot-token-backup
   ```

2. **Enable 2FA** on your GitHub account (prevents unauthorized deletion)

3. **Keep local clones** on multiple machines

4. **Export repo to tar.gz weekly:**
   ```bash
   gh repo archive tiptophimp/idiot-token --output idiot-token-backup.tar.gz
   ```

**But:** This doesn't prevent accidental deletion by you. Org rulesets do.

---

## My Recommendation

**Create the organization.** Here's why:

1. ✅ **Free** (no cost difference)
2. ✅ Solves your deletion protection requirement
3. ✅ Takes 30 minutes total
4. ✅ Matches your brand (stupidiots.com)
5. ✅ Future-proofs for team growth
6. ✅ Professional appearance for audits/partnerships

**Suggested name:** `StupidIdiots`  
**URL:** `github.com/StupidIdiots/idiot-token`

---

## Next Steps

If you want to proceed, I can:

1. ✅ Walk you through creating the org (requires browser access)
2. ✅ Generate the exact CI secret values to paste
3. ✅ Create a migration checklist
4. ✅ Update all documentation with new URLs

**Or:** Just enable the backups + 2FA strategy instead.

Let me know which direction you prefer!

