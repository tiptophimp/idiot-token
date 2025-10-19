# 📦 MIGRATION PLAN - Moving to Unified Directory

**Created:** 2025-10-16  
**Status:** In Progress  

---

## 🎯 OBJECTIVE
Move all scattered files from multiple locations into one unified directory structure at `C:\idiot-project\`

---

## 📍 SOURCE LOCATIONS (Known)

### Primary Source
- `C:\idiot-backup\idiot-token\` - Current working directory
  - Contains: public_html, reports, docs, scripts, data, etc.

### Other Potential Locations (To Be Identified)
- Various scattered folders across the system
- Empty directories
- Duplicate files

---

## 🗂️ MIGRATION STRATEGY

### Phase 1: Copy Critical Files (SAFE - No Deletions)
1. **Website files** → `C:\idiot-project\website\dev\`
   - Source: `C:\idiot-backup\idiot-token\public_html\`
   
2. **Token data** → `C:\idiot-project\token\`
   - Source: `C:\idiot-backup\idiot-token\data\`
   - Source: `C:\idiot-backup\idiot-token\scripts\idiot_*.py`
   
3. **Documentation** → `C:\idiot-project\docs\`
   - Source: `C:\idiot-backup\idiot-token\docs\`
   - Source: `C:\idiot-backup\idiot-token\reports\`
   
4. **Deployment config** → `C:\idiot-project\deploy\`
   - Source: `C:\idiot-backup\idiot-token\deploy\`
   - Source: `C:\idiot-backup\idiot-token\scripts\deploy_*.sh`

### Phase 2: Verification
- [ ] All critical files copied
- [ ] File counts match
- [ ] No data loss
- [ ] Structure makes sense

### Phase 3: Cleanup (User Approval Required)
- [ ] Identify duplicate files
- [ ] Identify empty directories
- [ ] Create cleanup plan
- [ ] Get user approval
- [ ] Execute cleanup
- [ ] Final verification

---

## 📋 MIGRATION CHECKLIST

### Website Files
- [ ] Copy `public_html/` to `website/dev/`
- [ ] Verify all HTML files
- [ ] Verify all images
- [ ] Verify all assets
- [ ] Check file structure intact

### Token Files  
- [ ] Copy `data/` folder
- [ ] Copy Python scripts
- [ ] Copy contract information
- [ ] Verify JSON files

### Documentation
- [ ] Copy `docs/` folder
- [ ] Copy `reports/` folder
- [ ] Merge with new docs
- [ ] Keep history

### Deployment
- [ ] Copy nginx configs
- [ ] Copy SSH keys (if present)
- [ ] Copy deployment scripts (old versions for reference)
- [ ] Document server information

### Git Setup
- [ ] Initialize git repo in C:\idiot-project
- [ ] Create .gitignore
- [ ] Create README
- [ ] Make initial commit (local only, not pushed yet)

---

## 🚨 SAFETY MEASURES

1. **NEVER delete source files** until verified in new location
2. **Compare file counts** before and after
3. **Test critical files** after migration
4. **Keep backups** of everything
5. **User approval** before any deletions

---

## 📊 PROGRESS TRACKING

### Completed
- [x] New directory structure created
- [x] Documentation framework established
- [x] Deployment scripts created

### In Progress
- [ ] Copying website files
- [ ] Copying token files
- [ ] Copying documentation

### Pending
- [ ] Git initialization
- [ ] Cleanup old locations
- [ ] Final verification

---

## 🔍 VERIFICATION COMMANDS

```bash
# Count files in old location
find C:/idiot-backup/idiot-token/public_html -type f | wc -l

# Count files in new location  
find C:/idiot-project/website/dev -type f | wc -l

# Compare directory structures
diff -qr C:/idiot-backup/idiot-token/public_html C:/idiot-project/website/dev

# Check for broken links or missing files
# (Manual testing in browser)
```

---

**Status will be updated as migration progresses.**

