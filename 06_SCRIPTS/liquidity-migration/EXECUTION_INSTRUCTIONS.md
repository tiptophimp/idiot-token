# 🚀 IDIOT TOKEN - FINALIZATION EXECUTION GUIDE

## 📋 OVERVIEW
This comprehensive script finalizes all vesting contracts and consolidates liquidity from V2 to V3 on Base Mainnet.

## ⚡ QUICK EXECUTION

### 1. Install Dependencies
```bash
cd 06_SCRIPTS/liquidity-migration
npm install
```

### 2. Set Environment Variables
Create `.env` file:
```
RPC_URL="https://mainnet.base.org"
PRIVATE_KEY="YOUR_PRIVATE_KEY_HERE"
BASESCAN_API_KEY="YOUR_BASESCAN_API_KEY_HERE"
```

### 3. Execute Finalization
```bash
npm run finalize
```

## 🎯 WHAT THE SCRIPT DOES

### ✅ VERIFICATION PHASE
- Verifies all wallet balances match expected allocations
- Confirms token distribution is correct
- Validates vesting contract status

### 💰 LIQUIDITY MIGRATION
- Removes all V2 liquidity from deprecated pool
- Consolidates tokens for V3 migration
- Prepares V3 liquidity addition

### 📊 TRANSPARENCY REPORT
- Generates comprehensive audit report
- Documents all wallet allocations
- Creates JSON report for public transparency

## 🔐 SECURITY FEATURES
- All transactions require manual confirmation
- Comprehensive error handling
- Detailed logging of all operations
- Rollback capabilities for failed operations

## 📄 OUTPUT FILES
- `vesting_finalization_report.json` - Complete audit report
- Console logs with detailed operation status
- Transaction hashes for all operations

## ⚠️ IMPORTANT NOTES
- **Test on Base testnet first** before mainnet execution
- **Ensure sufficient ETH** for gas fees
- **Backup wallet** before execution
- **Review all allocations** before confirming

## 🎉 EXPECTED RESULTS
After execution:
- ✅ All vesting contracts properly funded
- ✅ V2 liquidity completely removed
- ✅ V3 liquidity ready for addition
- ✅ Complete transparency report generated
- ✅ Project 100% finalized

---
**Ready to execute? Run `npm run finalize` when ready!** 🚀
