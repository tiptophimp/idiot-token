# 🚀 IDIOT Token Server Upload Guide

**Date:** October 4, 2025  
**Status:** Ready for Server Upload

## 📁 Files to Upload

### 🌐 Website Files (Public)
- `Tokenomics_Public_Transparency.html` → Upload to `/tokenomics/` or `/tokenomics.html`
- `IDIOT_Final_Reconciliation_Report.docx` → Upload to `/docs/` or `/reports/`

### 📊 Data Files (Public/Private)
- `wallet_balances_snapshot.json` → Upload to `/data/` or `/api/`
- `BaseScan_Verification_Receipts/` → Upload entire folder to `/verification/`

### 📋 Documentation (Private/Admin)
- `Audit_Summary.txt` → Upload to `/admin/` or `/docs/`

## 🎯 Recommended Server Structure

```
public_html/
├── tokenomics.html                    ← Tokenomics_Public_Transparency.html
├── docs/
│   ├── IDIOT_Final_Reconciliation_Report.docx
│   └── Audit_Summary.txt
├── data/
│   └── wallet_balances_snapshot.json
└── verification/
    ├── verification_data.json
    └── ledger_confirmation.json
```

## 🔗 Website Integration

### Tokenomics Page
1. Rename `Tokenomics_Public_Transparency.html` to `tokenomics.html`
2. Upload to your website root or `/tokenomics/` directory
3. Update navigation links to point to the new tokenomics page

### Contract Links
The tokenomics page includes direct links to:
- BaseScan Contract: https://basescan.org/address/0xC29EF04CFFe38012dcfc1E96a2B368443f298dE1
- Token Details: https://basescan.org/token/0xC29EF04CFFe38012dcfc1E96a2B368443f298dE1

## ✅ Verification Checklist

- [ ] All files uploaded to server
- [ ] Tokenomics page accessible at `/tokenomics.html`
- [ ] Contract links working
- [ ] Documentation accessible
- [ ] Data files properly organized

## 📞 Support

If you need help with server configuration or file organization, all files are ready and properly formatted for web deployment.

**Status:** ✅ Ready for Upload
