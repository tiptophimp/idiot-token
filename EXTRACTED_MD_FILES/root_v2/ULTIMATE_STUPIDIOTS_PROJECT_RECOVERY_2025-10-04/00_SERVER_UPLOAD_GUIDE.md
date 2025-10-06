# 🚀 IDIOT Token Website - Server Upload Guide

## 📁 Files Ready for Upload
**Location:** `C:\idiot\01_LIVE_SITE\main_site_ready_for_upload.zip`

## ⚡ Quick Upload Process (5 minutes)

### Step 1: Access Your Server
- Log into your hosting control panel (cPanel, Plesk, etc.)
- Navigate to **File Manager** or use **FTP**

### Step 2: Backup Current Site (IMPORTANT!)
- Download current `public_html` folder as backup
- Or rename it to `public_html_backup_$(date)`

### Step 3: Upload New Files
**Option A: Upload ZIP file**
1. Upload `main_site_ready_for_upload.zip` to `public_html/`
2. Extract the ZIP file
3. Move contents from `main_site/` folder to root of `public_html/`
4. Delete the empty `main_site/` folder

**Option B: Upload Individual Files**
Upload these files/folders to `public_html/`:
- `index.html`
- `assets/` (entire folder)
- `airdrop/` (entire folder)

### Step 4: Verify Upload
- Visit your website
- Check all images load correctly
- Test all buttons and links
- Verify mobile responsiveness

## 🔧 What's Updated in This Version

### ✅ Layout Fixes
- **Menu/banner overlap** - Fixed spacing issues
- **Contract address** - Moved below banner, better styling
- **Tagline text** - Moved below banner, proper colors
- **Logo removed** - Cleaner header design

### ✅ Mobile Improvements
- **Responsive design** - Works on all screen sizes
- **Touch-friendly** - Better mobile interaction
- **Chatbot mobile** - Optimized for mobile devices

### ✅ Visual Updates
- **Bot button** - Now uses `idiot_coin_1.png` image
- **Color consistency** - All elements use website color scheme
- **Better typography** - Improved readability

## 📋 File Structure After Upload
```
public_html/
├── index.html          (Main website)
├── assets/
│   └── img/
│       ├── coin-1.png
│       ├── favicon.ico
│       ├── idiot_coin_1.png
│       ├── idiot-coin-32x32-lime-fixed.svg
│       ├── idiot-logo-icon_64.png
│       ├── logo.png
│       └── og-image.png
└── airdrop/
    ├── index.html
    └── idiocracy-1.json
```

## ⚠️ Important Notes
- **Test first** - Check everything works before going live
- **Keep backup** - Don't delete old files until confirmed working
- **Check paths** - Ensure all image references work
- **Mobile test** - Test on phone/tablet

## 🆘 If Something Goes Wrong
1. **Restore backup** - Upload your backup files
2. **Check file permissions** - Ensure files are readable
3. **Clear cache** - Browser and server cache
4. **Check error logs** - Look for any server errors

## ✅ Success Checklist
- [ ] Website loads without errors
- [ ] All images display correctly
- [ ] Menu doesn't overlap banner
- [ ] Contract address is visible below banner
- [ ] Bot button shows coin image
- [ ] Mobile version works properly
- [ ] All links and buttons function

---
**Upload Time:** ~5 minutes
**Files:** 1 ZIP file (main_site_ready_for_upload.zip)
**Location:** C:\idiot\01_LIVE_SITE\
