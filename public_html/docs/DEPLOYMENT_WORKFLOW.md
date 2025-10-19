# Deployment Workflow - IDIOT Token Project
**Last Updated:** October 19, 2025 - 9:35 AM

---

## 🎯 Understanding the File Structure

### **CRITICAL CONCEPT:**
GitHub Pages serves files from the **ROOT** of the `gh-pages` branch, NOT from subdirectories.

### **Two Locations:**

1. **Development Files** (`website/dev/`)
   - This is where we make changes
   - Full development environment
   - All source files
   - Location: `c:\idiot-project\website\dev\`

2. **Production Files** (root)
   - This is what GitHub Pages serves
   - Must be synced from `website/dev/`
   - Location: `c:\idiot-project\` (root)

---

## 📋 Deployment Process

### **Step 1: Make Changes**
Always edit files in `website/dev/`:
```
website/dev/index.html
website/dev/staking/index.html
website/dev/partnerships/index.html
website/dev/docs/*.html
website/dev/legal/*.html
etc.
```

### **Step 2: Test Locally**
```powershell
cd website/dev
python -m http.server 8004
```
Open: http://localhost:8004

### **Step 3: Sync to Production Root**
```powershell
# Make sure you're on gh-pages branch
git checkout gh-pages

# Run the sync script
powershell -ExecutionPolicy Bypass -File scripts/sync-dev-to-production.ps1
```

This script copies:
- `website/dev/index.html` → `index.html`
- `website/dev/staking/` → `staking/`
- `website/dev/partnerships/` → `partnerships/`
- `website/dev/docs/` → `docs/`
- `website/dev/legal/` → `legal/`
- `website/dev/assets/logo.png` → `assets/logo.png`
- All other pages

### **Step 4: Commit and Push**
```powershell
git add -A
git commit -m "Update: [describe your changes]"
git push origin gh-pages
```

### **Step 5: Verify**
```powershell
scripts/check-production.ps1
```

Or visit: https://tiptophimp.github.io/idiot-token/

---

## 🚨 Common Mistakes

### ❌ **WRONG: Editing root files directly**
```
# DON'T DO THIS:
edit index.html (in root)
git commit
git push
```
**Problem:** Changes will be overwritten next time you sync from `website/dev/`

### ✅ **CORRECT: Edit in website/dev/, then sync**
```
# DO THIS:
edit website/dev/index.html
run sync-dev-to-production.ps1
git commit
git push
```

---

## 📁 File Mapping

| Development (website/dev/) | Production (root) |
|---------------------------|-------------------|
| `index.html` | `index.html` |
| `staking/index.html` | `staking/index.html` |
| `partnerships/index.html` | `partnerships/index.html` |
| `docs/*.html` | `docs/*.html` |
| `legal/*.html` | `legal/*.html` |
| `assets/logo.png` | `assets/logo.png` |
| `whitepaper.html` | `whitepaper.html` |
| `tokenomics-interactive.html` | `tokenomics-interactive.html` |
| `vesting-schedule.html` | `vesting-schedule.html` |
| `community.html` | `community.html` |
| `about.html` | `about.html` |

---

## 🔄 Why This Structure?

### **Reason 1: GitHub Pages Limitation**
GitHub Pages serves from:
- Root of `gh-pages` branch
- OR `/docs` folder
- OR `main` branch root

We use `gh-pages` root, so files must be in the root.

### **Reason 2: Development Isolation**
- Keep development files organized in `website/dev/`
- Prevent accidental production edits
- Maintain clean separation

### **Reason 3: Easy Rollback**
- `website/dev/` is always the source of truth
- Can always re-sync if root gets messed up
- Clear deployment process

---

## 🛠️ Automation Script

### **sync-dev-to-production.ps1**

**Location:** `scripts/sync-dev-to-production.ps1`

**What it does:**
1. Checks you're on `gh-pages` branch
2. Copies all files from `website/dev/` to root
3. Maintains directory structure
4. Shows progress for each file

**Usage:**
```powershell
powershell -ExecutionPolicy Bypass -File scripts/sync-dev-to-production.ps1
```

**Output:**
```
========================================
  Syncing Dev to Production Root
========================================

[OK] On gh-pages branch

Syncing main index.html...
[OK] index.html synced
Syncing assets...
[OK] logo.png synced
...
========================================
  Sync Complete!
========================================
```

---

## 📊 Deployment Checklist

Before every deployment:

- [ ] Made changes in `website/dev/`
- [ ] Tested locally (http://localhost:8004)
- [ ] Switched to `gh-pages` branch
- [ ] Ran `sync-dev-to-production.ps1`
- [ ] Reviewed changes (`git status`)
- [ ] Committed with clear message
- [ ] Pushed to `gh-pages`
- [ ] Verified production (`check-production.ps1`)
- [ ] Updated `SESSION_HANDOFF.md` if major changes

---

## 🔍 Troubleshooting

### **Problem: Production not updating**
**Solution:**
1. Check you're on `gh-pages` branch: `git branch --show-current`
2. Run sync script: `scripts/sync-dev-to-production.ps1`
3. Commit and push: `git add -A && git commit -m "Sync" && git push origin gh-pages`
4. Wait 1-2 minutes for GitHub Pages to rebuild
5. Hard refresh browser (Ctrl+Shift+R)

### **Problem: Changes lost after sync**
**Solution:**
- You probably edited root files instead of `website/dev/`
- Always edit in `website/dev/`
- Re-apply your changes to `website/dev/`
- Run sync script again

### **Problem: Missing pages on production**
**Solution:**
1. Check files exist in `website/dev/`
2. Run sync script
3. Verify files copied to root: `ls docs/`, `ls staking/`, etc.
4. Commit and push

---

## 📝 Quick Reference

### **Development:**
```powershell
# Edit files
code website/dev/index.html

# Test locally
cd website/dev
python -m http.server 8004
```

### **Deployment:**
```powershell
# Switch to production branch
git checkout gh-pages

# Sync files
powershell -ExecutionPolicy Bypass -File scripts/sync-dev-to-production.ps1

# Deploy
git add -A
git commit -m "Update: [description]"
git push origin gh-pages

# Verify
scripts/check-production.ps1
```

---

## 🎯 Best Practices

1. **Always edit in `website/dev/`** - Never edit root files directly
2. **Test before deploying** - Use local server
3. **Use the sync script** - Don't manually copy files
4. **Clear commit messages** - Describe what changed
5. **Verify after deploy** - Run production check
6. **Update documentation** - Keep SESSION_HANDOFF.md current

---

## 🔗 Related Documentation

- `SESSION_HANDOFF.md` - Current project status
- `_STATUS.md` - Deployment status
- `scripts/sync-dev-to-production.ps1` - Sync script
- `scripts/check-production.ps1` - Verification script

---

**Remember:** `website/dev/` is the source of truth. Always edit there, then sync to root!

