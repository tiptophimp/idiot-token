# IDIOT Token - Project Repository

**IDIOT Token** on Base Mainnet - Smart about dumb fun.

## 🌐 Live Website
- **Website:** https://stupidiots.com
- **Contract:** `0xC29EF04CFFe38012dcfc1E96a2B368443f298dE1`
- **Network:** Base (Chain ID: 8453)

## 📊 Tokenomics (v2.0 - Current)

**See:** [`IDIOT_Tokenomics_REALISTIC.md`](IDIOT_Tokenomics_REALISTIC.md) for complete details.

**Quick Summary:**
- **Total Supply:** 1,000,000,000 IDIOT (fixed)
- **Taxes:** 0% buy / 0% sell (permanent)
- **Distribution:** 65% Treasury | 25% Community | 10% Liquidity
- **Governance:** Transparent multisig control (3-of-4 Treasury, 2-of-4 Ops)
- **Philosophy:** Honest tokenomics, no BS

### 🔄 What Changed (v1.0 → v2.0)

We've updated from complex vesting plans to realistic, transparent tokenomics. This better reflects our actual implementation and prioritizes honesty over elaborate promises.

**Read the full evolution:** [`CHANGELOG.md`](CHANGELOG.md)

---

## 📋 Project Documentation

### Current (v2.0):
- **`IDIOT_Tokenomics_REALISTIC.md`** - Current honest tokenomics
- **`IDIOT_Website_Content_Update.md`** - Guide for website updates
- **`CHANGELOG.md`** - Project evolution and version history

### Reference (v1.0 - Archived):
- `IDIOT_Complete_Tokenomics_Reference.csv` - Original planned tokenomics
- `IDIOT_Funding_Plan.csv` - Initial distribution plan
- `IDIOT_Holdings_and_Vesting_Snapshot.md` - Planned vesting schedules
- `IDIOT_SEC_Compliance_Strategy.md` - Compliance framework
- `IDIOT_Liquidity_Pool_Analysis.csv` - LP analysis

### Technical:
- `IDIOT_Multisig_Analysis.md` - Multisig structure and strategy
- Deployment scripts (`.sh`, `.ps1`, `.bat`)
- GitHub Actions workflow (`.github/workflows/deploy.yml`)

---

## 🚀 Deployment

### **Automated Deployment (Active! ✅)**

Website automatically deploys when you push to `master`:

```bash
git add .
git commit -m "Your changes"
git push origin master
```

Deployment takes ~30 seconds. Check status: https://github.com/tiptophimp/idiot-token/actions

### **Manual Deployment (Backup)**

If you need to deploy without pushing to GitHub:

```bash
# Windows
DEPLOY.bat

# Or PowerShell
.\deploy-now.ps1
```

### **GitHub Secrets (Configured):**
- ✅ `IDIOT_SSH_PRIVATE_KEY` - SSH private key for server access
- ✅ `SERVER_IP` - Server IP address  
- ✅ `SERVER_USER` - Server username

---

## 🔗 Key Links

- **Website:** https://stupidiots.com
- **Contract:** https://basescan.org/token/0xC29EF04CFFe38012dcfc1E96a2B368443f298dE1
- **Treasury Safe:** https://basescan.org/address/0x9901b910333A17C8B3b75560BafcE6a893abCD5E
- **Ops Safe:** https://basescan.org/address/0x024BE9B76E993A6414D8680F5A3992d17ED37383
- **Uniswap Pool:** https://app.uniswap.org/explore/pools/base/0x763c9aB550dC0DAbd32F40131481Bf4BA4d8c1ea

---

## 🔒 Security

Sensitive files (SSH keys, passwords, wallet files) are excluded via `.gitignore` and never committed to the repository.

---

## 📈 Releases

- **v2.0-realistic** (Current) - Honest, transparent tokenomics
- **v1.0-initial** (Archived) - Original planning phase

---

**Built with transparency. Community-first. No BS.**
