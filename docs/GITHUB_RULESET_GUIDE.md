# GitHub Repository Ruleset Guide

## Protection Goals
1. **Prevent repository deletion**
2. **Protect main and staging branches**
3. **Enforce CI checks before merge**
4. **Prevent force pushes**

---

## Step 1: Enable Branch Protection Rules

### For `main` branch:
1. Go to **Settings** → **Branches** → **Add branch protection rule**
2. Branch name pattern: `main`
3. Enable:
   - ✅ Require a pull request before merging
   - ✅ Require status checks to pass before merging
     - Add: `deploy` (your CI workflow)
   - ✅ Require branches to be up to date before merging
   - ✅ Do not allow bypassing the above settings
   - ✅ Restrict deletions (prevents branch deletion)
   - ✅ Block force pushes

### For `staging` branch:
1. Add another rule with pattern: `staging`
2. Enable:
   - ✅ Require status checks to pass before merging
     - Add: `deploy-staging`
   - ✅ Restrict deletions
   - ✅ Block force pushes
   - ⚠️ Allow force pushes with lease (optional, for emergency fixes)

---

## Step 2: Repository-Level Protection (GitHub Settings)

### Prevent Repository Deletion:
1. Go to **Settings** → **General** → scroll to **Danger Zone**
2. There is NO direct "lock repo from deletion" toggle in free GitHub
3. **Workarounds:**
   - **Best:** Organization-level rulesets (requires GitHub Teams/Enterprise)
   - **Alternative:** Transfer repo to an Organization account and set owner permissions carefully

### If using GitHub Free/Pro (personal account):
- Repo deletion requires your account credentials
- No additional lock mechanism available
- **Mitigation:** 
  - Enable 2FA on your account
  - Keep regular backups/mirrors
  - Document recovery procedures

---

## Step 3: Organization Rulesets (if you have GitHub Teams/Enterprise)

1. Go to **Organization Settings** → **Repository rulesets** → **New ruleset**
2. Name: `IDIOT Site Protection`
3. Target: `All repositories` or select `stupidiots-website`
4. Rules:
   - ✅ Restrict deletions
   - ✅ Restrict updates (prevent destructive changes)
   - ✅ Require linear history
   - ✅ Require signed commits (optional, but recommended)
   - ✅ Block force pushes
   - ✅ Require status checks to pass
   - ✅ Require pull request reviews before merging

5. Enforcement: `Active` (not Evaluate mode)
6. Bypass list: Add only trusted admins if needed

---

## Step 4: Additional Protections

### Require 2FA for collaborators:
1. **Settings** → **Moderation options** → **Require two-factor authentication**

### Audit log:
1. **Settings** → **Security** → **Audit log** (view all destructive actions)

### Deploy keys (read-only):
- CI deploy keys should be **write-only to deployment target**, not repo

---

## Current Repo Status Check

Run these commands to verify current protection:

```bash
# Check if main/staging have protection
gh api repos/:owner/:repo/branches/main/protection

# List all rulesets (requires org)
gh api orgs/:org/rulesets
```

---

## Emergency Recovery Plan

If repo is accidentally deleted:
1. **GitHub retains deleted repos for 90 days** (contact support immediately)
2. Restore from local clone: `git push --mirror https://github.com/tiptophimp/idiot-token-backup.git`
3. Use tarball backups in `wallets_safes/` directory

---

## Recommended Next Steps

1. ✅ Set up branch protection for `main` and `staging` (do this now)
2. ✅ Enable 2FA on your GitHub account
3. ✅ Create a backup mirror on GitLab or BitBucket
4. ✅ Document who has admin access
5. ⚠️ Consider moving to GitHub Organization account for better controls

---

## Quick Setup Commands (requires GitHub CLI)

```bash
# Protect main branch
gh api repos/:owner/:repo/branches/main/protection \
  --method PUT \
  --field required_status_checks='{"strict":true,"contexts":["deploy"]}' \
  --field enforce_admins=true \
  --field required_pull_request_reviews='{"required_approving_review_count":1}' \
  --field restrictions=null \
  --field allow_force_pushes=false \
  --field allow_deletions=false

# Protect staging branch
gh api repos/:owner/:repo/branches/staging/protection \
  --method PUT \
  --field required_status_checks='{"strict":true,"contexts":["deploy-staging"]}' \
  --field enforce_admins=false \
  --field required_pull_request_reviews=null \
  --field restrictions=null \
  --field allow_force_pushes=false \
  --field allow_deletions=false
```

---

**Priority Action:** Go to https://github.com/tiptophimp/idiot-token/settings/branches and set up branch protection rules for `main` and `staging` **right now**.

