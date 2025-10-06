# IDIOT Token Vesting Verification

This package provides automated verification and audit logging for IDIOT token vesting contracts deployed on Base mainnet.

## 🎯 Purpose

Lock in vesting parameters cryptographically by:
1. Verifying all contracts on BaseScan
2. Confirming ownership by respective SAFE multisigs
3. Recording immutable bytecode hashes
4. Generating public audit trail

## 📋 Prerequisites

- Node.js v18+
- Hardhat installed
- BaseScan API key
- Private key that deployed the contracts

## 🚀 Quick Start

### 1. Install Dependencies
```bash
npm install
```

### 2. Configure Environment
```bash
cp env.template .env
# Edit .env with your values:
# - PRIVATE_KEY=0x...
# - BASESCAN_API_KEY=your_key
```

### 3. Run Verification
```bash
npm run verify
```

## 📊 What It Does

### Contract Verification
Verifies these contracts on BaseScan:
- **Reserve Vesting:** `0x6AD03686ab6c3bA2c77992995E4879c62dE88996`
- **Treasury Vesting:** `0x5817dccb35cd3a67520e5bda1ebc413cf097a8ee`
- **Team Vesting:** `0x5817dccb35cd3a67520e5bda1ebc413cf097a8ee`
- **Community Vesting:** `0x9d466e39799fec7204f40133ecc0beb115813c13`

### Audit Log Generation
Creates `audit/vesting_verification_log.md` with:
- Contract addresses and owners
- Cliff start dates and durations
- Immutable bytecode hashes
- BaseScan verification links
- Security status confirmation

## 🔒 Security Features

### Immutability Proof
- Constructor parameters are `immutable` in Solidity
- No setter functions for vesting parameters
- Bytecode hash recorded for tamper detection

### Governance Lockdown
- All contracts owned by SAFE multisigs
- TR-SAFE (3/4) owns Reserve, Treasury, Team
- OPS-SAFE (2/4) owns Community
- Requires multisig consensus for any changes

## 📁 File Structure

```
├── scripts/
│   └── verifyAndAudit.js      # Main verification script
├── audit/
│   └── vesting_verification_log.md  # Generated audit log
├── hardhat.config.js          # Hardhat configuration
├── package.json               # Dependencies and scripts
├── env.template              # Environment variables template
└── README_VERIFICATION.md    # This file
```

## 🛠️ Manual Verification

If automated verification fails, verify manually:

```bash
# Individual contract verification
npx hardhat verify --network base 0x6AD03686ab6c3bA2c77992995E4879c62dE88996 \
  "0xTR_SAFE" 1770076800 94608000

# Check bytecode hash
cast codehash 0x6AD03686ab6c3bA2c77992995E4879c62dE88996 --rpc-url https://mainnet.base.org
```

## 📈 Expected Output

```
=== IDIOT Token Vesting Verification & Audit ===
📅 Timestamp: 2025-01-19T...
🌐 Network: Base Mainnet (https://mainnet.base.org)

🔍 Verifying Reserve (0x6AD03686ab6c3bA2c77992995E4879c62dE88996)
✅ Verified on BaseScan
🧾 Logged: Reserve -> 0xTR_SAFE

🔍 Verifying Treasury (0x5817dccb35cd3a67520e5bda1ebc413cf097a8ee)
✅ Verified on BaseScan
🧾 Logged: Treasury -> 0xTR_SAFE

...

✅ Complete: Vesting audit written to ./audit/vesting_verification_log.md
📊 Summary:
   - 4 contracts processed
   - Audit log: ./audit/vesting_verification_log.md
   - BaseScan verification: Complete
```

## 🔍 Verification Checklist

- [ ] All contracts verified on BaseScan
- [ ] Ownership confirmed (SAFE multisigs)
- [ ] Constructor parameters immutable
- [ ] No admin setter functions
- [ ] Bytecode hashes recorded
- [ ] Audit log generated
- [ ] Public transparency document updated

## 🚨 Troubleshooting

### "Contract already verified"
This is normal - the script will continue and log the existing verification.

### "Verification failed"
Check:
- BaseScan API key is valid
- Private key matches contract deployer
- Contract addresses are correct
- Network connection is stable

### "Cast command not found"
Install Foundry:
```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

## 📞 Support

For issues with verification:
1. Check the audit log for specific errors
2. Verify environment variables are correct
3. Ensure network connectivity to Base
4. Contact IDIOT team for assistance

---

**Status:** ✅ Ready for execution  
**Last Updated:** 2025-01-19  
**Version:** 1.0.0
