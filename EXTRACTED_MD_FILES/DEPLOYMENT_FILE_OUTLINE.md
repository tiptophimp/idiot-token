# IDIOT Token Website - Deployment File Outline

**Deployment Date:** January 19, 2025  
**Package:** stupidiots_website_live.zip (12.7MB)  
**Target:** Web Server public_html/ directory  

## 📁 **FILES TO BE UPLOADED TO SERVER**

### 🌐 **Core Website Files**
```
public_html/
├── index.html                          (152KB - Main homepage)
├── community_rewards.html              (7.8KB - Rewards page)
├── learn.html                          (14KB - Educational hub)
├── .htaccess                           (Server configuration)
├── website-copy-freeze.md              (Content reference)
└── README_LOCAL_BUILD.md               (Build notes)
```

### 🎨 **Assets Directory**
```
public_html/assets/
├── img/
│   ├── cliff.png                       (2.6MB - Hero banner)
│   ├── coin-1.png                      (2.4MB - Main coin image)
│   ├── favicon.ico                     (5.7KB - Browser icon)
│   ├── idiot_coin_1.png                (2.2MB - Secondary coin)
│   ├── idiot-coin-32x32-lime-fixed.svg (14KB - SVG favicon)
│   ├── idiot-coin-512.png              (366KB - High-res coin)
│   ├── idiot-logo-icon_64.png          (5.4KB - Social icon)
│   ├── logo.png                        (101KB - Main logo)
│   └── og-image.png                    (58KB - Social media image)
└── legacy/
    ├── coin-1.png                      (Legacy coin image)
    ├── favicon.ico                     (Legacy favicon)
    ├── idiot_coin_1.png                (Legacy coin)
    ├── idiot-coin-32x32-lime-fixed.svg (Legacy SVG)
    ├── idiot-logo-icon_64.png          (Legacy social icon)
    ├── logo.png                        (Legacy logo)
    ├── og-image.png                    (Legacy OG image)
    └── README_ASSETS_LEGACY.md         (Legacy assets info)
```

### 🎁 **Airdrop System**
```
public_html/airdrop/
├── idiocracy/                          (Empty directory)
├── idiocracy-1.json                    (1.8KB - Airdrop manifest)
├── index.html                          (7.6KB - Claim portal)
└── ping.json                           (54B - Health check)
```

### 📚 **Documentation**
```
public_html/docs/
├── how-to-buy-idiot-on-base.html      (Buying guide)
├── IDIOT_How_to_Claim_OnePager.rtf    (Claim guide)
├── IDIOT_LP_Participant_Guide.rtf     (LP guide)
├── IDIOT_OnePage_Community_Transparency.pdf (Transparency doc)
├── IDIOT_Ops_Runbook.pdf              (Operations manual)
├── IDIOT_Whitepaper.pdf               (Project whitepaper)
└── legacy/
    ├── complete-buying-guide.html     (Legacy buying guide)
    ├── how-to-buy-on-base.html        (Legacy base guide)
    ├── metamask-setup.html            (Legacy MetaMask guide)
    ├── README_LEGACY_DOCS.md          (Legacy docs info)
    └── sending-receiving-guide.html   (Legacy transfer guide)
```

### 🗂️ **Legacy Content**
```
public_html/legacy/
├── brand-voice-memes.html             (Legacy memes page)
└── README_LEGACY_PAGES.md             (Legacy pages info)
```

### 📋 **Development Notes** (Optional - for reference)
```
public_html/_notes/
├── community_rewards_stub.html        (Rewards stub)
├── DEPLOYMENT_COMPLETION_SUMMARY.md   (Deployment status)
├── IDIOT_Community_Airdrop_Plan.rtf   (Airdrop planning)
├── IDIOT_Execution_Playbook_2025-10-01 2146.rtf (Launch guide)
├── IDIOT_Gameplan_Tokenomics_Vesting_Governance.rtf (Tokenomics)
├── IDIOT_How_to_Claim_OnePager.rtf   (Claim instructions)
├── IDIOT_LP_Funding_Guide.rtf         (LP funding guide)
├── IDIOT_LP_Participant_Guide.rtf     (LP participant guide)
├── IDIOT_OnePage_Community_Transparency.pdf (Transparency)
├── IDIOT_Ops_Runbook.pdf              (Operations runbook)
├── IDIOT_Tokenomics_OnePager_2025-10-01 2146.rtf (Tokenomics)
├── IDIOT_Whitepaper_v1_2025-01-02.pdf (Whitepaper v1)
├── PACKET_COMPLETION_SUMMARY.md       (Development progress)
├── qa-tracker.md                      (QA validation)
├── readme-digests.md                  (Project structure)
└── todo-assets.md                     (Asset requirements)
```

### 🔍 **QA Reports** (Optional - for reference)
```
public_html/QA/
└── reports/
    └── S1_INVENTORY_REPORT.md         (Asset inventory)
```

## 📊 **DEPLOYMENT SUMMARY**

### **Total Files:** 50+ files
### **Total Size:** ~12.7MB (compressed)
### **Key Components:**
- ✅ **Main Website** - Complete responsive site
- ✅ **Airdrop Portal** - Full claim system
- ✅ **Educational Content** - Trading guides
- ✅ **Assets** - All images and icons optimized
- ✅ **Documentation** - Comprehensive project docs
- ✅ **Server Config** - Security and performance settings

### **Critical Files for Live Site:**
1. `index.html` - Main homepage
2. `assets/img/` - All visual assets
3. `airdrop/` - Airdrop system
4. `.htaccess` - Server configuration
5. `learn.html` - Educational content

## 🎯 **DEPLOYMENT INSTRUCTIONS**

1. **Upload** `stupidiots_website_live.zip` to `public_html/`
2. **Extract** all files to `public_html/`
3. **Verify** main files are in root directory
4. **Test** website functionality
5. **Delete** ZIP file after successful extraction

---
*Generated by Novalex - AI Assistant*
