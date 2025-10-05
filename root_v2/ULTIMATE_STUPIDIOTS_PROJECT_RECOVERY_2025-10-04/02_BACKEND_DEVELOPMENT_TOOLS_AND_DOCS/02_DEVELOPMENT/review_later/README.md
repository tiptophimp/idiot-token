# 🎭 IDIOT Airdrop Kit - Complete Implementation

Complete airdrop system for IDIOT token on Base network.

## 📁 What's Included

### **Website Files:**
- `airdrop/index.html` - Professional claim portal
- `airdrop/idiocracy-1.json` - Merkle manifest template
- `announcements/` - Ready-to-post Discord/X content
- `templates/allowlist-template.csv` - Allowlist management

### **Smart Contracts:**
- `contracts/MerkleDistributor.sol` - Gas-efficient claim contract
- `hardhat.config.js` - Base network configuration

### **Tools:**
- `scripts/generate-merkle.js` - Build Merkle tree from CSV
- `package.json` - All dependencies included

## 🚀 Quick Start

### **1. Install Dependencies:**
```bash
npm install
```

### **2. Fill Allowlist:**
Edit `templates/allowlist-template.csv` with real addresses and amounts.

### **3. Generate Merkle Tree:**
```bash
npm run generate
```
This creates:
- `airdrop/idiocracy-1.json` - Complete manifest with proofs
- `airdrop/claims-with-proofs.json` - Individual claim data
- `airdrop/deploy.js` - Deployment script

### **4. Deploy Contract:**
```bash
# Set your private key
export PRIVATE_KEY="your_private_key_here"

# Deploy to Base
npm run deploy
```

### **5. Launch:**
1. Upload `airdrop/` folder to your website
2. Transfer 250M IDIOT tokens to the distributor
3. Set claim window dates
4. Announce the airdrop!

## 📊 Airdrop Details

- **Budget:** 250,000,000 IDIOT (25% of supply)
- **Pools:** Early Buyers 40% • LP 15% • Community 25% • Meme 10% • Partners 10%
- **Snapshot:** October 15, 2025 at 20:00 UTC
- **Claim Window:** 30 days
- **Contract:** 0x03a520b32C04BF3bEEf7BEb72E919cf822Ed34f1

## 🔧 Configuration

Edit `scripts/generate-merkle.js` to modify:
- Token contract address
- Snapshot time
- Pool allocations
- Claim window duration

## 📋 CSV Format

Your allowlist CSV should have these columns:
```csv
address,amount,pool,notes,twitter,discord,proof_url
0x123...,30000,community,Discord OG,@user,User#1234,https://...
```

## 🛡️ Security Features

- **Merkle Proofs** - Gas-efficient, transparent claims
- **Anti-Sybil** - One wallet per human screening
- **Time Windows** - Configurable claim periods
- **Sweep Function** - Unclaimed tokens return to Treasury
- **Reentrancy Guard** - Protection against attacks

## 📞 Support

This is a complete, production-ready airdrop system. Everything you need to launch Phase 3 is included.

**No more dithering - ship it!** 🎭
