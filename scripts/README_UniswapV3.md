# 🏊 Uniswap V3 Liquidity Management Scripts

Complete set of Hardhat scripts for managing IDIOT/WETH liquidity on Base mainnet.

## 📋 Available Scripts

### 1. **Add Liquidity** (`uniswapV3_addLiquidity.ts`)
Creates a new liquidity position in the IDIOT/WETH pool.

```bash
npx hardhat run scripts/uniswapV3_addLiquidity.ts --network base
```

**Features:**
- ✅ Automatic WETH wrapping if needed
- ✅ Smart tick range calculation (±600 ticks around current price)
- ✅ Slippage protection (3% default)
- ✅ Ledger hardware wallet support
- ✅ Detailed transaction logging

**Configuration:**
- **WETH Amount:** 0.2 WETH (editable in script)
- **IDIOT Amount:** 5,000,000 IDIOT (editable in script)
- **Fee Tier:** 0.3% (3000)
- **Slippage:** 3% (300 bps)

### 2. **Increase Liquidity** (`uniswapV3_increaseLiquidity.ts`)
Adds more liquidity to an existing position.

```bash
POSITION_ID=123 npx hardhat run scripts/uniswapV3_increaseLiquidity.ts --network base
```

**Features:**
- ✅ Position ID validation
- ✅ Configurable amounts
- ✅ Automatic approvals
- ✅ Ledger hardware wallet support

**Configuration:**
- **WETH Amount:** 0.05 WETH (editable in script)
- **IDIOT Amount:** 1,000,000 IDIOT (editable in script)

### 3. **Collect Fees** (`uniswapV3_collectFees.ts`)
Collects accumulated fees from a position.

```bash
POSITION_ID=123 npx hardhat run scripts/uniswapV3_collectFees.ts --network base
```

**Features:**
- ✅ Collects all available fees
- ✅ Position ID validation
- ✅ Fee amount reporting
- ✅ Ledger hardware wallet support

### 4. **Pool Information** (`uniswapV3_poolInfo.ts`)
Displays real-time pool data and statistics.

```bash
npx hardhat run scripts/uniswapV3_poolInfo.ts --network base
```

**Features:**
- ✅ Current price calculation
- ✅ Liquidity amount
- ✅ Tick information
- ✅ Pool status
- ✅ Token addresses

## 🔧 Configuration

### Pool Details
- **Pool Address:** `0x763c9aB550dC0DAbd32F40131481Bf4BA4d8c1ea`
- **Token0:** WETH (`0x4200000000000000000000000000000000000006`)
- **Token1:** IDIOT (`0xC29EF04CFFe38012dcfc1E96a2B368443f298dE1`)
- **Fee Tier:** 0.3% (3000)
- **Tick Spacing:** 60

### Contract Addresses
- **NFPM:** `0x03a520b32C04BF3bEEf7BEb72E919cf822Ed34f1`
- **Factory:** `0x33128a8fC17869897dcE68Ed026d694621f6FDfD`

## 🚀 Quick Start

### Prerequisites
1. **Ledger connected** and unlocked
2. **Ethereum app open** on Ledger
3. **BaseScan API key** in `.env`
4. **Sufficient balances** (WETH and IDIOT)

### Step 1: Check Pool Info
```bash
npx hardhat run scripts/uniswapV3_poolInfo.ts --network base
```

### Step 2: Add Initial Liquidity
```bash
npx hardhat run scripts/uniswapV3_addLiquidity.ts --network base
```

### Step 3: Note Position ID
After adding liquidity, note the **Position Token ID** from the output.

### Step 4: Increase Liquidity (Optional)
```bash
POSITION_ID=123 npx hardhat run scripts/uniswapV3_increaseLiquidity.ts --network base
```

### Step 5: Collect Fees (When Available)
```bash
POSITION_ID=123 npx hardhat run scripts/uniswapV3_collectFees.ts --network base
```

## 📊 Understanding the Output

### Add Liquidity Output
```
🚀 Adding liquidity to IDIOT/WETH pool
📝 Signer: 0x...
📍 Current tick: 160456
📊 Range: 154456 to 166456 (width: 600)
💰 WETH balance: 1.0
🔄 Wrapping 0.2 ETH to WETH
✅ WETH wrapped
🔐 Approving WETH for NFPM
🔐 Approving IDIOT for NFPM
📋 Minting position with params:
   WETH: 0.2
   IDIOT: 5000000.0
   Min WETH: 0.194
   Min IDIOT: 4850000.0
⏳ Transaction submitted: 0x...
✅ Position minted successfully!
📄 Transaction hash: 0x...
🎫 Position Token ID: 123
```

### Pool Info Output
```
📊 Fetching IDIOT/WETH pool information
📝 Signer: 0x...
🏊 Pool: 0x763c9aB550dC0DAbd32F40131481Bf4BA4d8c1ea

📈 Pool Information:
==================
🏊 Pool Address: 0x763c9aB550dC0DAbd32F40131481Bf4BA4d8c1ea
💰 Fee Tier: 3000 (0.3%)
🔓 Unlocked: Yes

📊 Current State:
==================
📐 Sqrt Price (X96): 241536863667801693065806418520103
📍 Current Tick: 160456
💧 Liquidity: 324048569951682407338

🪙 Tokens:
==========
Token0: 0x4200000000000000000000000000000000000006
Token1: 0xC29EF04CFFe38012dcfc1E96a2B368443f298dE1

💱 Calculated Price: 0.000000000000000001
   (Token1 per Token0)

💧 Formatted Liquidity: 324.048569951682407338
```

## ⚠️ Important Notes

### Slippage Protection
- Default 3% slippage protection
- Adjust `SLIPPAGE_BPS` in scripts if needed
- Higher slippage = more likely to succeed, less price protection

### Tick Range Strategy
- **Current:** ±600 ticks around current price
- **Wider range:** More liquidity, less concentrated
- **Narrower range:** More concentrated, higher fees

### Gas Considerations
- **Add Liquidity:** ~200,000 gas
- **Increase Liquidity:** ~150,000 gas
- **Collect Fees:** ~100,000 gas
- **Pool Info:** ~50,000 gas (view function)

## 🔒 Security Features

- **Ledger Integration:** All transactions signed with hardware wallet
- **Slippage Protection:** Prevents excessive price impact
- **Approval Management:** Automatic token approvals
- **Error Handling:** Comprehensive error messages
- **Transaction Validation:** Confirms successful execution

## 📈 Monitoring

### Dashboard Integration
The transparency dashboard automatically displays:
- Real-time pool price
- Current liquidity
- Pool status
- Fee tier information

### BaseScan Links
All transactions are viewable on BaseScan:
- Pool: https://basescan.org/address/0x763c9aB550dC0DAbd32F40131481Bf4BA4d8c1ea
- NFPM: https://basescan.org/address/0x03a520b32C04BF3bEEf7BEb72E919cf822Ed34f1

## 🛠️ Troubleshooting

### Common Issues
1. **"Insufficient balance"** → Check WETH/IDIOT balances
2. **"Position not found"** → Verify POSITION_ID is correct
3. **"Slippage too high"** → Increase SLIPPAGE_BPS or wait for better price
4. **"Ledger not detected"** → Ensure Ledger is connected and unlocked

### Debug Commands
```bash
# Check balances
npx hardhat run scripts/uniswapV3_poolInfo.ts --network base

# Verify position exists
cast call 0x03a520b32C04BF3bEEf7BEb72E919cf822Ed34f1 "positions(uint256)" 123 --rpc-url https://mainnet.base.org
```

---

**Built for IDIOT token ecosystem on Base mainnet** 🧠
