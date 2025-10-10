# IDIOT Token - Project Repository

**IDIOT Token** on Base Mainnet - Smart about dumb fun.

## 🌐 Live Website
- **Website:** https://stupidiots.com
- **Contract:** `0xC29EF04CFFe38012dcfc1E96a2B368443f298dE1`
- **Network:** Base (Chain ID: 8453)

## 📋 Project Structure

This repository contains project documentation, tokenomics, and deployment automation for the IDIOT Token website.

### Key Files:
- **Tokenomics:** `IDIOT_Complete_Tokenomics_Reference.csv`
- **Distribution Plan:** `IDIOT_Funding_Plan.csv`
- **Holdings Snapshot:** `IDIOT_Holdings_and_Vesting_Snapshot.md`
- **SEC Compliance:** `IDIOT_SEC_Compliance_Strategy.md`
- **Liquidity Analysis:** `IDIOT_Liquidity_Pool_Analysis.csv`

## 🚀 Deployment

Automated deployment via GitHub Actions on push to `master` branch.

### Required GitHub Secrets:
- `IDIOT_SSH_PRIVATE_KEY` - SSH private key for server access
- `SERVER_IP` - Server IP address
- `SERVER_USER` - Server username

## 🔒 Security

Sensitive files (SSH keys, passwords, wallet files) are excluded via `.gitignore` and never committed to the repository.

## 📄 License

Project documentation and materials for IDIOT Token.

---

**Website:** https://stupidiots.com  
**Contract:** 0xC29EF04CFFe38012dcfc1E96a2B368443f298dE1  
**Network:** Base Mainnet
