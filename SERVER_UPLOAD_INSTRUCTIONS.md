# Server Upload Instructions - Clean Website Package

**Package:** `stupidiots_website_CLEAN.zip` (17.7MB)  
**Location:** `C:\Users\Ernest\Downloads\stupidiots_website_CLEAN.zip`  
**Date:** October 3, 2025, 8:27 PM

## 🎉 **CLEANUP RESULTS**

### **Before Cleanup:**
- **Size:** 31.4MB (original server content)
- **Files:** 163 files
- **Duplicates:** 81 files (50% waste)

### **After Cleanup:**
- **Size:** 17.7MB (44% reduction)
- **Files:** 83 files (49% reduction)
- **Duplicates:** 0 files

## 📦 **UPLOAD PACKAGE CONTENTS**

### **What's Included:**
- ✅ **Main website files** (index.html, community_rewards.html, learn.html)
- ✅ **All assets** (images, CSS, JS)
- ✅ **Documentation** (QA/, docs/, _notes/)
- ✅ **Configuration files** (.htaccess, README files)
- ✅ **Airdrop system** (complete functionality)

### **What's Removed:**
- ❌ **releases/ directory** (13MB duplicate)
- ❌ **Duplicate ZIP file** (13.8KB)
- ❌ **Test files** (deploy_test.txt, htaccess_rollback_legacy)

## 🚀 **UPLOAD STEPS**

### **Step 1: Access cPanel**
1. Log into your hosting control panel
2. Navigate to **File Manager**
3. Go to **public_html** directory

### **Step 2: Backup Current Site (Recommended)**
```bash
# Create backup of current site
mv public_html public_html_backup_$(date +%Y%m%d_%H%M%S)
```

### **Step 3: Upload Clean Package**
1. **Upload** `stupidiots_website_CLEAN.zip` to cPanel
2. **Extract** the ZIP file in public_html
3. **Move contents** from `site_clean/` to `public_html/`
4. **Delete** the empty `site_clean/` folder

### **Step 4: Set Permissions**
```bash
# Set proper permissions
chmod 644 *.html
chmod 644 *.css
chmod 644 *.js
chmod 644 assets/img/*
chmod 755 assets/
chmod 644 .htaccess
```

### **Step 5: Verify Upload**
1. **Check** website loads at your domain
2. **Test** all pages (index, community_rewards, learn)
3. **Verify** images display correctly
4. **Test** airdrop functionality

## 📋 **UPLOAD CHECKLIST**

### **Pre-Upload:**
- [ ] Backup current site
- [ ] Download clean package
- [ ] Verify package size (17.7MB)

### **During Upload:**
- [ ] Upload ZIP file
- [ ] Extract to public_html
- [ ] Move contents to root
- [ ] Set file permissions

### **Post-Upload:**
- [ ] Test main page loads
- [ ] Test all navigation links
- [ ] Verify images display
- [ ] Test airdrop system
- [ ] Check mobile responsiveness

## ⚠️ **IMPORTANT NOTES**

### **File Structure:**
```
public_html/
├── index.html
├── community_rewards.html
├── learn.html
├── .htaccess
├── assets/
│   ├── img/
│   └── legacy/
├── airdrop/
├── docs/
├── QA/
└── _notes/
```

### **Key Files to Verify:**
- **index.html** - Main page
- **.htaccess** - Server configuration
- **assets/img/cliff.png** - Hero background
- **airdrop/index.html** - Airdrop system

## 🎯 **EXPECTED RESULTS**

- **44% smaller** than original server content
- **49% fewer files** to manage
- **No duplicate content**
- **Cleaner directory structure**
- **Faster loading times**
- **Easier maintenance**

## 🔧 **TROUBLESHOOTING**

### **If Website Doesn't Load:**
1. Check file permissions
2. Verify .htaccess is present
3. Check for PHP errors in cPanel logs
4. Ensure all files uploaded completely

### **If Images Don't Display:**
1. Check assets/img/ directory exists
2. Verify image file permissions
3. Check .htaccess for image serving rules

### **If Airdrop Doesn't Work:**
1. Check airdrop/ directory exists
2. Verify JSON files are present
3. Check file permissions on airdrop files

---
*Clean package ready for upload - 44% space savings achieved*
