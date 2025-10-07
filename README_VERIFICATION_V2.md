# IDIOT Token Verification System - Etherscan V2

> **Upgraded to Etherscan V2** - Single API key for all chains (Base, Ethereum, Polygon, etc.)

## 🔧 Etherscan V2 Upgrade

This project has been upgraded to use **Etherscan V2 API** with a single unified API key that works across all supported chains.

### Key Changes:
- ✅ **Single API Key**: One `ETHERSCAN_API_KEY` for all chains
- ✅ **Unified Endpoints**: All chains use `https://api.etherscan.io/v2/api`
- ✅ **Simplified Configuration**: No more per-chain API keys
- ✅ **Future-Proof**: V2 is the new standard (V1 deprecated May 31, 2025)

## 🚀 Quick Start

### 1. Environment Setup
```bash
# Copy environment template
cp env.template .env

# Edit .env with your Etherscan V2 API key
ETHERSCAN_API_KEY=your_etherscan_v2_key_here
RPC_URL_PRIMARY=https://mainnet.base.org
RPC_URL_SEPOLIA=https://sepolia.base.org
```

### 2. Install Dependencies
```bash
npm install
```

### 3. Verify Contracts
```bash
# Verify on Base mainnet
npx hardhat verify --network base 0xYourContract <constructor_args>

# Verify on Base Sepolia testnet
npx hardhat verify --network baseSepolia 0xYourContract <constructor_args>

# Run verification audit
npx hardhat run scripts/verifyAndAudit.js --network base
```

## 🔑 API Key Setup

### Get Your Etherscan V2 API Key:
1. Visit [Etherscan.io APIs](https://etherscan.io/apis)
2. Create account or login
3. Generate new API key
4. **Important**: This single key works for ALL chains (Base, Ethereum, Polygon, etc.)

### GitHub Secrets:
```yaml
# Required secrets for CI/CD
ETHERSCAN_API_KEY: your_etherscan_v2_key
RPC_URL_PRIMARY: https://mainnet.base.org
RPC_URL_ALCHEMY: https://base-mainnet.g.alchemy.com/v2/your_key
RPC_URL_INFURA: https://base-mainnet.infura.io/v3/your_key
```

## 📋 Verification Commands

### Manual Verification:
```bash
# Verify specific contract
npx hardhat verify --network base 0xContractAddress "arg1" "arg2"

# Verify with constructor args file
npx hardhat verify --network base 0xContractAddress --constructor-args arguments.js

# Verify with flattened source
npx hardhat verify --network base 0xContractAddress --flatten
```

### Automated Verification:
```bash
# Run full audit (verifies all vesting wallets)
npx hardhat run scripts/verifyAndAudit.js --network base

# Test on Sepolia
npx hardhat run scripts/verifyAndAudit.js --network baseSepolia
```

## 🏗️ Configuration

### hardhat.config.cjs
```javascript
module.exports = {
  etherscan: {
    // Single V2 key covers all chains
    apiKey: process.env.ETHERSCAN_API_KEY,
    customChains: [
      {
        network: "base",
        chainId: 8453,
        urls: {
          apiURL: "https://api.etherscan.io/v2/api",
          browserURL: "https://basescan.org",
        },
      },
      {
        network: "baseSepolia", 
        chainId: 84532,
        urls: {
          apiURL: "https://api.etherscan.io/v2/api",
          browserURL: "https://sepolia.basescan.org",
        },
      },
    ],
  },
};
```

## 🔄 Migration from V1

### Before (V1 - Deprecated):
```javascript
// Old per-chain keys
etherscan: {
  apiKey: {
    base: process.env.BASESCAN_API_KEY,
    mainnet: process.env.ETHERSCAN_API_KEY,
    polygon: process.env.POLYGONSCAN_API_KEY,
  }
}
```

### After (V2 - Current):
```javascript
// New unified key
etherscan: {
  apiKey: process.env.ETHERSCAN_API_KEY, // Single key for all chains
}
```

## 🚨 Important Notes

### Deprecation Timeline:
- **V1 API**: Deprecated May 31, 2025
- **V2 API**: Current standard, future-proof
- **Migration**: Required before deprecation date

### Benefits of V2:
- ✅ **Simplified**: One key instead of multiple
- ✅ **Cost-effective**: Single subscription covers all chains
- ✅ **Maintainable**: Easier to manage and rotate
- ✅ **Future-proof**: New chains automatically supported

## 🛠️ Troubleshooting

### Common Issues:

1. **"Invalid API Key"**
   - Ensure you're using Etherscan V2 key (not BaseScan-specific)
   - Verify key is active and has sufficient quota

2. **"Contract not verified"**
   - Check constructor arguments match deployment
   - Ensure contract source code is available
   - Verify network configuration

3. **"Rate limit exceeded"**
   - Wait before retrying
   - Consider upgrading API plan if needed

### Debug Commands:
```bash
# Check API key validity
curl "https://api.etherscan.io/v2/api?module=account&action=balance&address=0x0000000000000000000000000000000000000000&tag=latest&apikey=YOUR_KEY"

# Test network connectivity
npx hardhat run scripts/verifyAndAudit.js --network base --verbose
```

## 📚 Resources

- [Etherscan V2 Documentation](https://docs.etherscan.io/v2)
- [Hardhat Verify Plugin](https://hardhat.org/hardhat-runner/plugins/nomicfoundation-hardhat-verify)
- [Base Network Documentation](https://docs.base.org)
- [IDIOT Token Contract](https://basescan.org/token/0xC29EF04CFFe38012dcfc1E96a2B368443f298dE1)

---

**Last Updated**: January 2025  
**Version**: 2.0.0 (Etherscan V2)  
**Status**: ✅ Production Ready
