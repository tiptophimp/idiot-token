# IDIOT Token Deployment Project

This project contains the smart contracts and deployment scripts for the IDIOT Token on Base mainnet.

## Project Structure

```
root_v2/
├── contracts/
│   └── IdiotToken.sol          # Main token contract
├── scripts/
│   ├── deploy.js               # Deploy token contract
│   ├── testDistributeAllocations.js  # Execute token distribution
│   └── verifyContracts.js      # Verify contracts on BaseScan
├── hardhat.config.js           # Hardhat configuration for Base
├── package.json               # Dependencies and scripts
└── .env.example              # Environment variables template
```

## Setup Instructions

1. **Install Dependencies**
   ```bash
   npm install
   ```

2. **Configure Environment**
   ```bash
   cp .env.example .env
   # Edit .env and add your BaseScan API key
   ```

3. **Connect Ledger Hardware Wallet**
   - Open MetaMask
   - Connect your Ledger
   - Switch to Base Mainnet network
   - Ensure Ledger app is open to Ethereum

## Available Commands

- `npm run compile` - Compile contracts
- `npm run deploy` - Deploy token to Base mainnet
- `npm run distribute` - Execute token distribution
- `npm run verify` - Verify contracts on BaseScan

## Deployment Process

1. **Deploy Token**
   ```bash
   npx hardhat run scripts/deploy.js --network base
   ```

2. **Verify Contract**
   ```bash
   npx hardhat verify --network base <contract_address>
   ```

3. **Distribute Allocations**
   ```bash
   npx hardhat run scripts/testDistributeAllocations.js --network base
   ```

## Important Notes

- This project uses Ledger hardware wallet for signing
- All transactions are executed on Base mainnet
- Private keys are not stored in this project
- Contract verification requires BaseScan API key
