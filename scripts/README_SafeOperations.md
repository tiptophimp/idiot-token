# Safe Operations Scripts

This directory contains scripts for managing Uniswap V3 liquidity positions with Safe multisig integration.

## Scripts Overview

### 1. `recenter_liquidity.ts` - Re-center Position to Safe
**Purpose:** Remove existing liquidity position, collect fees, and mint new position directly to Safe multisig.

**Features:**
- Reads current position details (tokens, fee, range, liquidity)
- Removes all liquidity from existing position
- Collects accumulated fees to signer
- Calculates new tick range around current price
- Mints new position directly to Safe recipient
- Uses current token balances as desired amounts

**Usage:**
```bash
POSITION_ID=123 \
SAFE_RECIPIENT=0xYourTreasurySafe \
npx hardhat run scripts/recenter_liquidity.ts --network base
```

**Environment Variables:**
- `POSITION_ID` (required): Token ID of existing position to re-center
- `SAFE_RECIPIENT` (required): Safe multisig address to receive new position
- `TICK_WIDTH` (optional): ±ticks around current price (default: 600)
- `SLIPPAGE_BPS` (optional): Slippage in basis points (default: 300 = 3%)
- `NFPM` (optional): Non-Fungible Position Manager address
- `POOL` (optional): Pool address

### 2. `cron_collect_fees.ts` - Automated Fee Collection
**Purpose:** Collect accumulated fees from multiple positions and send to Safe multisig.

**Features:**
- Processes multiple position IDs in one transaction
- Collects maximum available fees from each position
- Sends all collected fees to Safe recipient
- Error handling for individual position failures
- Designed for automated/cron execution

**Usage:**
```bash
SAFE_RECIPIENT=0xYourTreasurySafe \
POSITION_IDS=123,124,125 \
npx hardhat run scripts/cron_collect_fees.ts --network base
```

**Environment Variables:**
- `SAFE_RECIPIENT` (required): Safe multisig address to receive fees
- `POSITION_IDS` (required): Comma-separated list of position IDs
- `NFPM` (optional): Non-Fungible Position Manager address

## Automation Setup

### PM2 (Linux/Production)
```bash
# Start fee collector as PM2 process
pm2 start npx --name idiot-fee-collector --interpreter bash -- \
  hardhat run scripts/cron_collect_fees.ts --network base

# Set weekly cron schedule (Mondays at 1 PM)
pm2 set pm2:cron:idiot-fee-collector "0 13 * * 1"

# Save PM2 configuration
pm2 save
```

### Manual Cron (Linux)
Add to crontab:
```bash
# Weekly fee collection (Mondays at 1 PM)
0 13 * * 1 cd /path/to/idiot && SAFE_RECIPIENT=0xYourTreasurySafe POSITION_IDS=123,124 npx hardhat run scripts/cron_collect_fees.ts --network base
```

### Render/Hosting Services
Set up as scheduled job with environment variables:
- `SAFE_RECIPIENT`: Your Safe multisig address
- `POSITION_IDS`: Comma-separated position IDs
- `NFPM`: Position manager address (optional)

## Security Considerations

### Ledger Integration
- All scripts support Ledger hardware wallet signing
- No private keys required in environment
- Transactions must be approved on device

### Safe Multisig
- New positions are minted directly to Safe
- Fee collections are sent to Safe
- Requires Safe transaction approval for position management

### Slippage Protection
- Default 3% slippage protection on re-centering
- Configurable via `SLIPPAGE_BPS` environment variable
- Minimum amounts calculated automatically

## Workflow Examples

### Initial Position Setup
1. Deploy initial position with `uniswapV3_addLiquidity.ts`
2. Note the returned position ID
3. Transfer position NFT to Safe multisig

### Regular Maintenance
1. **Weekly:** Run `cron_collect_fees.ts` to collect accumulated fees
2. **As needed:** Run `recenter_liquidity.ts` when price moves significantly

### Emergency Operations
1. **Position Management:** Use Safe to manage position parameters
2. **Fee Collection:** Manual execution of `cron_collect_fees.ts`
3. **Position Removal:** Use Safe to decrease liquidity to zero

## Troubleshooting

### Common Issues
1. **"No balances to provide after collect"**
   - Position had no liquidity or fees
   - Check position status before re-centering

2. **"Set SAFE_RECIPIENT and POSITION_ID"**
   - Missing required environment variables
   - Verify environment setup

3. **"Position not found"**
   - Invalid position ID
   - Position may have been burned

4. **"Insufficient allowance"**
   - Token approvals needed
   - Script handles this automatically

### Debug Mode
Add logging to see detailed transaction information:
```bash
DEBUG=1 npx hardhat run scripts/recenter_liquidity.ts --network base
```

## Integration with Transparency Dashboard

These scripts work seamlessly with the transparency dashboard:
- Pool data is displayed in real-time
- Position information can be tracked
- Fee collection history is logged
- Safe operations are transparent

## Best Practices

1. **Test on Base Sepolia first** before mainnet operations
2. **Monitor gas prices** for optimal transaction timing
3. **Set appropriate tick ranges** based on volatility expectations
4. **Regular fee collection** to maximize returns
5. **Safe multisig governance** for position management decisions

---

*These scripts provide complete liquidity management capabilities with Safe multisig integration for the IDIOT token ecosystem.*
