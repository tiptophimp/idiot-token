# IDIOT Token Cursor Integration Stack

Complete professional-grade local environment setup for IDIOT token vesting contract verification with one-click execution via Cursor Tasks.

## 🧱 Project Structure

```
idiot-token/
├── hardhat.config.js          # Hardhat configuration with Base network
├── package.json               # Dependencies and scripts
├── .env                       # Environment variables (create from env.template)
├── .vscode/
│   └── tasks.json            # Cursor task definitions
├── audit/
│   └── vesting_verification_log.md  # Generated audit logs
└── scripts/
    ├── verifyAuditNotify.js   # Enhanced verification script
    ├── verifyAndAudit.js      # Original verification script
    └── setup.js              # One-time setup script
```

## ⚙️ Quick Setup

### 1. Install Dependencies
```bash
npm install
```

### 2. Configure Environment
Copy `env.template` to `.env` and fill in your values:
```bash
cp env.template .env
```

Required values:
- `PRIVATE_KEY`: Your deployer private key (0x...)
- `BASESCAN_API_KEY`: Get from https://basescan.org/apis

Optional values:
- `DISCORD_WEBHOOK_URL`: For Discord notifications
- `SLACK_WEBHOOK_URL`: For Slack notifications (alternative to Discord)

### 3. Install Foundry (for code hash verification)
```bash
npm install --global foundryup
foundryup
```

### 4. Run Setup Script
```bash
npx hardhat run scripts/setup.js
```

## 🪄 Cursor Tasks

### Available Tasks (Ctrl+Shift+P → Tasks: Run Task)

1. **Verify + Audit + Notify** (Main task)
   - Verifies all vesting contracts on Base mainnet
   - Creates comprehensive audit log
   - Sends notifications to Discord/Slack
   - Uploads audit to IPFS for immutable storage

2. **Verify + Audit + Notify (Testnet)**
   - Same as above but for Base Sepolia testnet

3. **Install Dependencies**
   - Installs all required npm packages

4. **Compile Contracts**
   - Compiles Solidity contracts

## 🚀 Usage

### One-Click Execution
1. Open Command Palette: `Ctrl+Shift+P`
2. Select: "Tasks: Run Task"
3. Choose: "Verify + Audit + Notify"
4. Watch the magic happen! ✨

### Manual Execution
```bash
npx hardhat run scripts/verifyAuditNotify.js --network base
```

## 📊 Features

### ✅ Automatic Verification
- Verifies all 4 vesting contracts on BaseScan
- Handles "Already Verified" cases gracefully
- Retry logic for network hiccups (3 attempts with 10s delay)

### 📝 Comprehensive Audit Logging
- Creates `audit/vesting_verification_log.md`
- Records contract addresses, owners, parameters
- Includes code hashes for tamper detection
- Immutable proof of vesting parameters

### 🔔 Smart Notifications
- Discord webhook integration with rich embeds
- Slack webhook support
- Success/failure status reporting
- IPFS links for immutable storage

### 🌐 IPFS Integration
- Automatic upload of audit logs to IPFS
- Immutable storage for compliance
- Public IPFS URLs for verification

### 🔄 Error Handling
- Automatic retry on network failures
- Graceful error recovery
- Detailed error reporting

## 📋 Contract Details

| Pool | Address | Owner SAFE | Start Date | Duration |
|------|---------|------------|------------|----------|
| Reserve | `0x6AD03686ab6c3bA2c77992995E4879c62dE88996` | TR-SAFE | 2026-04-01 | 3 years |
| Treasury | `0x5817dccb35cd3a67520e5bda1ebc413cf097a8ee` | TR-SAFE | 2026-04-01 | 2 years |
| Team | `0x5817dccb35cd3a67520e5bda1ebc413cf097a8ee` | TR-SAFE | 2026-10-01 | 3 years |
| Community | `0x9d466e39799fec7204f40133ecc0beb115813c13` | OPS-SAFE | 2025-10-07 | 2 years |

## 🔒 Security Features

- **Immutability**: Constructor parameters are `immutable` in Solidity
- **Multisig Control**: All contracts owned by SAFE multisigs
- **No Admin Functions**: No setter functions for vesting parameters
- **Code Hash Verification**: Tamper detection via bytecode hashes
- **IPFS Storage**: Immutable audit trail on decentralized storage

## 🛠️ Troubleshooting

### Common Issues

1. **"Private key not found"**
   - Check your `.env` file has correct `PRIVATE_KEY`
   - Ensure it starts with `0x`

2. **"BaseScan API key invalid"**
   - Get a free API key from https://basescan.org/apis
   - Add it to `.env` as `BASESCAN_API_KEY`

3. **"Cast command not found"**
   - Install Foundry: `npm install --global foundryup && foundryup`

4. **Webhook notifications not working**
   - Check webhook URL format
   - Test webhook manually first

### Manual Verification

If automated verification fails, you can manually verify contracts:

```bash
npx hardhat verify --network base <CONTRACT_ADDRESS> <CONSTRUCTOR_ARGS>
```

## 📈 Post-Run Verification

After successful execution, verify:

1. **BaseScan**: All contracts show "Contract Source Code Verified"
2. **Audit Log**: `audit/vesting_verification_log.md` contains all details
3. **Webhook**: Discord/Slack received notification
4. **IPFS**: Audit log is stored immutably (if configured)

## 🎯 Next Steps

- Set up automated runs via GitHub Actions
- Configure monitoring alerts for contract changes
- Add additional verification checks as needed
- Customize webhook messages for your team

---

*This integration provides a complete, professional-grade verification system for IDIOT token vesting contracts with full audit trails and immutable proof of parameters.*
