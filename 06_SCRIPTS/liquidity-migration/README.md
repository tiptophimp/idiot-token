# IDIOT Token Liquidity Migration Scripts

This directory contains Hardhat scripts for migrating IDIOT Token liquidity from Uniswap V2 to V3 on Base network.

## Contract Address
- **IDIOT Token**: `0xC29EF04CFFe38012dcfc1E96a2B368443f298dE1`
- **WETH**: `0x4200000000000000000000000000000000000006`
- **Network**: Base Mainnet

## Setup

1. **Install dependencies:**
   ```bash
   cd 06_SCRIPTS/liquidity-migration
   npm install
   ```

2. **Configure environment:**
   ```bash
   cp env.example .env
   # Edit .env with your private key and BaseScan API key
   ```

3. **Verify configuration:**
   ```bash
   npx hardhat compile
   ```

## Scripts

### 1. Remove V2 Liquidity
```bash
npm run remove-v2
# or
npx hardhat run removeV2Liquidity.js --network base
```

### 2. Add V3 Liquidity
```bash
npm run add-v3
# or
npx hardhat run addV3Liquidity.js --network base
```

### 3. Full Migration
```bash
npm run migrate
```

## Prerequisites

- Sufficient ETH balance for gas fees
- IDIOT Token and WETH in your wallet
- Existing V2 LP tokens (for removal)
- Private key with appropriate permissions

## Post-Migration Verification

1. **Check GeckoTerminal:**
   - Visit: https://www.geckoterminal.com/base/pools
   - Search for IDIOT/WETH pair

2. **Verify on BaseScan:**
   - Check transaction hashes
   - Verify token transfers

3. **Community Announcement:**
   - Share new pool address
   - Update documentation

## Safety Notes

- ⚠️ **Test on testnet first**
- ⚠️ **Verify contract addresses**
- ⚠️ **Check slippage settings**
- ⚠️ **Ensure sufficient gas fees**

## Troubleshooting

- **Insufficient balance**: Add more ETH/WETH
- **Transaction failed**: Check gas limits
- **Pool not found**: Verify token addresses
- **Approval failed**: Check token allowances
