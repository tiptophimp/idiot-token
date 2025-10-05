# TODO Assets - Missing Files Analysis

*Generated: 2025-01-01*
*Branch: staging-local*

## Site Structure Confirmation

### ✅ CONFIRMED STRUCTURE
- **Entry File:** `01_LIVE_SITE/main_site_ready_for_upload/main_site/index.html` (136KB)
- **Assets Directory:** `01_LIVE_SITE/main_site_ready_for_upload/main_site/assets/img/`
- **Airdrop Directory:** `01_LIVE_SITE/main_site_ready_for_upload/main_site/airdrop/`

### ✅ EXISTING ASSETS
**Images Found:**
- `coin-1.png` (2.3MB) - Main coin image
- `idiot_coin_1.png` (2.2MB) - Secondary coin image  
- `logo.png` (101KB) - Website logo
- `favicon.ico` (5.6KB) - Browser icon
- `og-image.png` (58KB) - Social media image (1200×630)
- `idiot-logo-icon_64.png` (5.4KB) - Social icon
- `idiot-coin-32x32-lime-fixed.svg` (14KB) - 32×32 SVG logo

**Airdrop Files:**
- `airdrop/index.html` (7.6KB) - Airdrop portal
- `airdrop/idiocracy-1.json` (1.8KB) - Airdrop manifest

**Whitepaper Files Found:**
- Multiple versions in development folders
- Latest: `02_DEVELOPMENT/review_later/site/assets/img/Community/IDIOT_Whitepaper_Branded_v2.pdf`

## ❌ MISSING ASSETS

### Required Files Not in Main Site:
1. **512×512 PNG Logo** - Need high-res logo for app stores
   - Target Path: `assets/img/logo-512.png`
   - Current: Only have 101KB logo.png (unknown dimensions)

2. **Hero Banner Image** - Need cliff.png for banner
   - Target Path: `assets/img/cliff.png` 
   - Status: Exists in 04_ASSETS but not in main site

3. **Whitepaper in Main Site** - Need official whitepaper
   - Target Path: `docs/IDIOT_Whitepaper.pdf`
   - Current: Only in development folders

4. **32×32 PNG Favicon** - Need PNG version of favicon
   - Target Path: `assets/img/favicon-32x32.png`
   - Current: Only have favicon.ico

## 📋 ACTION ITEMS

### High Priority:
- [ ] Copy `cliff.png` from 04_ASSETS to main site assets
- [ ] Create 512×512 PNG version of logo
- [ ] Copy latest whitepaper to docs/ directory
- [ ] Create 32×32 PNG favicon

### Medium Priority:
- [ ] Verify all image dimensions meet requirements
- [ ] Optimize image file sizes if needed
- [ ] Create additional social media image sizes

### Low Priority:
- [ ] Create additional favicon sizes (16×16, 48×48)
- [ ] Create app icon variations

## 📁 RECOMMENDED FILE STRUCTURE

```
01_LIVE_SITE/main_site_ready_for_upload/main_site/
├── index.html
├── assets/
│   └── img/
│       ├── logo.png (current)
│       ├── logo-512.png (needed)
│       ├── cliff.png (needed)
│       ├── favicon.ico (current)
│       ├── favicon-32x32.png (needed)
│       ├── og-image.png (current)
│       └── [other existing images]
├── airdrop/
│   ├── index.html (current)
│   └── idiocracy-1.json (current)
└── docs/
    └── IDIOT_Whitepaper.pdf (needed)
```

## 🎯 NEXT STEPS

1. Copy missing assets from 04_ASSETS to main site
2. Create required image sizes
3. Organize whitepaper in docs/ directory
4. Verify all links in index.html point to correct files
