# 🔐 IDIOT Token - Safes, Timelocks & Management Guide
## Who Controls What & Where Everything Lives

---

## 📊 QUICK OVERVIEW - TOKEN ALLOCATION

| Location | Amount | % | Lock Period | Who Controls |
|----------|--------|---|-------------|--------------|
| **Reserve Timelock** | 449,022,067.81 IDIOT | 44.90% | 36 months | TR-SAFE (3-of-4) |
| **Community (OPS)** | 250,000,000 IDIOT | 25.00% | Distributor TL | OPS-SAFE (2-of-4) |
| **Liquidity Pool** | 150,000,000 IDIOT | 15.00% | 24m (planned) | HOT-LP → Lock |
| **Team Vesting** | 100,000,000 IDIOT | 10.00% | 48 months | TR-SAFE (3-of-4) |
| **Treasury Timelock** | 50,977,932.19 IDIOT | 5.06% | 30 months | TR-SAFE (3-of-4) |
| **Stray (to fix)** | 977,932.19 IDIOT | 0.10% | None | Needs move |
| **TOTAL** | 1,000,000,000 | 100% | — | — |

---

## 🏦 THE SAFES (Multisig Wallets)

### 1️⃣ TR-SAFE (Treasury Reserve Safe)
**Address:** `0x9901b910333A17C8B3b75560BafcE6a893abCD5E`

**Type:** 3-of-4 Multisig (Requires 3 signatures out of 4 owners)

**Owners (Signers):**
1. Ledger 1 (Blue) - `0xf123f1269Fcb1d0c6F1DCFc3EF1F68dEDDf52a5e`
2. Ledger 2 (Gold) - `0xB4EB7C7040c887d576a2e0Cdf60901A3087f5389`
3. HOT-OPS - `0x721d2adcCf634f4185edE152ee98cA836CF22EA6`
4. HOT-LP - `0xAC95d0B5603C7212a690bd089BAD472473496374`

**Controls:**
- ✅ Reserve Timelock (449M IDIOT)
- ✅ Treasury Timelock (51M IDIOT)
- ✅ Team Vesting (100M IDIOT)

**Purpose:**
- High-security governance for long-term funds
- Requires 3 out of 4 signatures for any transaction
- Manages 600M+ IDIOT (~60% of supply)

**Current Holdings:**
- Should hold 0 IDIOT directly (all in timelocks)
- 0.01-0.02 ETH per signer for gas only

---

### 2️⃣ OPS-SAFE (Operations Safe)
**Type:** 2-of-4 Multisig (Requires 2 signatures out of 4 owners)

**Owners (Signers):**
1. Ledger 1 (Blue)
2. Ledger 2 (Gold)
3. HOT-OPS
4. HOT-LP (or another hot wallet)

**Controls:**
- ✅ Community Distributor Timelock (250M IDIOT)
- ✅ Weekly emission claims
- ✅ Snapshot-based distributions

**Purpose:**
- Day-to-day operational control
- Lower threshold (2-of-4) for faster operations
- Manages community allocations and airdrops

**Current Holdings:**
- Community tokens for distribution
- Gas ETH for operations

---

## ⏰ THE TIMELOCKS (Vesting Contracts)

### 1️⃣ Reserve Timelock
**Contract:** `0x6AD03686ab6c3bA2c77992995E4879c62dE88996`

**Contains:** 449,022,067.81 IDIOT (44.90% of supply)

**Beneficiary:** TR-SAFE (`0x9901b910333A17C8B3b75560BafcE6a893abCD5E`)

**Deployed By:** Ledger 1 (`0xf123f1269Fcb1d0c6F1DCFc3EF1F68dEDDf52a5e`)

**Vesting Schedule:**
- **Start:** Unix timestamp 1759594033
- **Duration:** 93,312,000 seconds (~36 months / 3 years)
- **Unlock:** Linear vesting over 36 months
- **Cliff:** 12 months (recommended)

**Who Can Withdraw:**
- TR-SAFE (3-of-4 signatures required)
- Only after vesting period begins unlocking

**Transaction Hash:** `0xc384439cfedc2ebef9e12c63b404867530f39052933acef1341daadf90d7071e`

**Purpose:** Long-term stability reserve for future development, partnerships, listings

---

### 2️⃣ Treasury Timelock (aka Team Timelock)
**Contract:** `0x5817dccb35cd3a67520e5bda1ebc413cf097a8ee`

**Contains:** 50,977,932.19 IDIOT (5.06% of supply)

**Beneficiary:** TR-SAFE (`0x9901b910333A17C8B3b75560BafcE6a893abCD5E`)

**Deployed By:** Ledger 1 (`0xf123f1269Fcb1d0c6F1DCFc3EF1F68dEDDf52a5e`)

**Vesting Schedule:**
- **Start:** Unix timestamp 1759594033
- **Duration:** 77,760,000 seconds (~30 months / 2.5 years)
- **Alternative Duration:** 124,416,000 seconds (~48 months / 4 years) mentioned for team
- **Unlock:** Linear vesting
- **Cliff:** 0-6 months (configurable)

**Who Can Withdraw:**
- TR-SAFE (3-of-4 signatures required)
- Only after vesting period begins

**Transaction Hash:** `0x4cb6981be2177df930e3d2ea2f530e6402329527440f359aa043ecdf63b50245`

**Purpose:** 
- Runway for audits
- Exchange listings
- Operational expenses
- Marketing and development

---

### 3️⃣ Team Vesting Wallet
**Contract:** `0x6AD03686ab6c3bA2c77992995E4879c62dE88996`
*(Note: This appears to be the same address as Reserve Timelock - may need clarification)*

**Contains:** 100,000,000 IDIOT (10% of supply)

**Beneficiary:** Team Payout Wallet (controlled by TR-SAFE)

**Vesting Schedule:**
- **Cliff:** 12 months (cannot withdraw anything for first year)
- **Linear:** 24 months after cliff
- **Total Duration:** 36 months (12m cliff + 24m linear)

**Who Can Withdraw:**
- TR-SAFE controls the beneficiary wallet
- 3-of-4 signatures required
- Tokens unlock gradually after cliff

**Purpose:** Team compensation with strong vesting to align incentives

---

### 4️⃣ Community Distributor Timelock (Planned)
**Contains:** 250,000,000 IDIOT (25% of supply)

**Beneficiary:** OPS-SAFE (2-of-4 multisig)

**Currently Located:** HOT-OPS wallet (`0x721d2adcCf634f4185edE152ee98cA836CF22EA6`)

**Vesting Schedule:**
- Weekly emissions
- OR controlled distributor plan via Sablier
- Snapshot-based claims

**Who Can Manage:**
- OPS-SAFE (2-of-4 signatures)
- Lower threshold for faster community operations

**Purpose:** Community rewards, airdrops, marketing incentives, ecosystem growth

---

## 💧 LIQUIDITY POSITION

### Uniswap V3 LP Position
**Pool Address:** `0x763c9ab550dc0dabd32f40131481bf4ba4d8c1ea`

**Contains:** 150,000,000 IDIOT (15% of supply) + ETH

**NFT Token ID:** 3887185

**Current Owner:** Ledger 1 (`0xf123f1269Fcb1d0c6F1DCFc3EF1F68dEDDf52a5e`)

**Managed By:** HOT-LP wallet (`0xAC95d0B5603C7212a690bd089BAD472473496374`)

**Pair:** IDIOT/WETH

**Fee Tier:** 0.3%

**Lock Status:** ⚠️ NOT YET LOCKED

**Action Required:**
- Lock LP-NFT with UNCX or Team Finance
- Lock Duration: 24 months minimum
- Proves no rug pull
- Provides liquidity stability

**Who Controls:**
- Currently: Ledger 1 (owns the NFT)
- After lock: Locked in third-party contract (UNCX/Team Finance)
- Cannot be withdrawn during lock period

---

## 💼 HOT WALLETS (Operational Wallets)

### HOT-LP (Liquidity Operations)
**Address:** `0xAC95d0B5603C7212a690bd089BAD472473496374`

**Holdings:**
- 55.44 ETH (for LP operations)
- ~$990 reserved for LP seeding/adjustments

**Purpose:**
- Provides initial liquidity
- Manages LP positions
- Adjusts ranges if needed

**Security Level:** Hot wallet (higher risk)

**Should Hold:**
- Gas ETH only after LP is created
- 0 IDIOT (all IDIOT should be in LP or locked)

---

### HOT-OPS (Operations)
**Address:** `0x721d2adcCf634f4185edE152ee98cA836CF22EA6`

**Holdings:**
- 37.50 ETH
- IDIOT tokens (for operations)

**Purpose:**
- Approve/trigger community claims
- Pay gas for automated distributions
- Day-to-day operational signing

**Security Level:** Hot wallet (higher risk)

**Should Hold:**
- $50-$100 in ETH for gas
- 0 IDIOT (except temporary amounts for distributions)

---

## 🔐 COLD WALLETS (Hardware - Highest Security)

### Ledger 1 (Blue) - Main Cold Wallet
**Address:** `0xf123f1269Fcb1d0c6F1DCFc3EF1F68dEDDf52a5e`

**Type:** Nano S Plus (Hardware wallet)

**Holdings:**
- 349.83 ETH
- Owns LP-NFT (Token ID: 3887185)
- Primary deployer wallet

**Role:**
- Signer on TR-SAFE (3-of-4)
- Signer on OPS-SAFE (2-of-4)
- Deployed all contracts
- Should only hold gas ETH (0.01-0.02 ETH)

**Security:** Maximum (hardware wallet, offline storage)

---

### Ledger 2 (Gold) - Backup Cold Wallet
**Address:** `0xB4EB7C7040c887d576a2e0Cdf60901A3087f5389`

**Type:** Nano S Plus (Hardware wallet)

**Holdings:**
- Gas ETH only (0.01-0.02 ETH)
- No IDIOT

**Role:**
- Backup signer on TR-SAFE (3-of-4)
- Backup signer on OPS-SAFE (2-of-4)
- Redundant security

**Security:** Maximum (hardware wallet, offline storage)

---

## ⚠️ STRAY HOLDER (ACTION REQUIRED)

**Address:** `0x763c9aB5...BA4d8c1ea` (incomplete address in document)

**Contains:** 977,932.19 IDIOT (0.10% of supply)

**Issue:** Tokens sitting in random EOA (Externally Owned Account)

**Action Required:**
- Move to Treasury Timelock
- Should be controlled by TR-SAFE

**Risk:** Low amount but should be properly allocated

---

## 🎯 WHO DOES WHAT - MANAGEMENT MATRIX

### For Reserve Timelock (449M IDIOT):
1. **Check Balance:** Anyone can view on BaseScan
2. **Withdraw Vested:** TR-SAFE (requires 3 signatures)
3. **Change Beneficiary:** Cannot (immutable)
4. **View Schedule:** Anyone on BaseScan

### For Treasury Timelock (51M IDIOT):
1. **Check Balance:** Anyone can view on BaseScan
2. **Withdraw Vested:** TR-SAFE (requires 3 signatures)
3. **Approve Spending:** TR-SAFE (3 signatures)
4. **Change Beneficiary:** Cannot (immutable)

### For Team Vesting (100M IDIOT):
1. **Check Balance:** Anyone can view
2. **Withdraw After Cliff:** TR-SAFE (requires 3 signatures)
3. **Withdraw Before Cliff:** Impossible (locked)
4. **Change Schedule:** Cannot (immutable)

### For Community Distribution (250M IDIOT):
1. **Approve Claims:** OPS-SAFE (requires 2 signatures)
2. **Trigger Emissions:** OPS-SAFE (2 signatures)
3. **Emergency Stop:** OPS-SAFE (2 signatures)
4. **Set Snapshot:** OPS-SAFE (2 signatures)

### For Liquidity Pool (150M IDIOT):
1. **Add Liquidity:** HOT-LP wallet
2. **Adjust Range:** HOT-LP wallet (if not locked)
3. **Lock LP-NFT:** Ledger 1 (current owner)
4. **Unlock After Lock:** Impossible for 24 months
5. **Remove Liquidity:** Only after lock expires

---

## 🔑 SIGNATURE REQUIREMENTS SUMMARY

| Action | Safe/Wallet | Signatures Required | Signers |
|--------|-------------|---------------------|---------|
| **Withdraw from Reserve** | TR-SAFE | 3 of 4 | 2 Ledgers + 2 Hot |
| **Withdraw from Treasury** | TR-SAFE | 3 of 4 | 2 Ledgers + 2 Hot |
| **Withdraw from Team** | TR-SAFE | 3 of 4 | 2 Ledgers + 2 Hot |
| **Community Distribution** | OPS-SAFE | 2 of 4 | Any 2 signers |
| **Lock LP-NFT** | Ledger 1 | 1 (owner) | Ledger 1 only |
| **Emergency Actions** | TR-SAFE | 3 of 4 | 2 Ledgers + 2 Hot |

---

## 📋 OPERATIONAL WORKFLOWS

### To Withdraw from Timelocks:
1. Check vested amount on BaseScan
2. Create transaction in Safe UI
3. Get approval from 3 signers (for TR-SAFE)
4. Execute transaction
5. Funds go to Safe wallet
6. Create second transaction to move from Safe to destination
7. Get 3 approvals again
8. Execute

### To Distribute Community Tokens:
1. Create snapshot of eligible holders
2. Calculate distribution amounts
3. Create claim contract or manual distribution plan
4. Submit transaction to OPS-SAFE
5. Get 2 approvals
6. Execute distribution

### To Lock LP-NFT:
1. Go to UNCX or Team Finance
2. Connect Ledger 1 (owns the NFT)
3. Select LP-NFT (Token ID: 3887185)
4. Set lock duration: 24 months
5. Confirm transaction
6. Save lock proof URL
7. Publish on website for transparency

---

## 🚨 EMERGENCY SCENARIOS

### If Hot Wallet Compromised:
- Funds in timelocks are SAFE (controlled by TR-SAFE)
- Community tokens at RISK (only requires 2 signatures on OPS-SAFE)
- **Action:** Revoke compromised signer from both Safes immediately
- **Requires:** Other signers' approval

### If 1 Ledger Lost:
- TR-SAFE still works (need 3 of 4, have 3 remaining)
- OPS-SAFE still works (need 2 of 4, have 3 remaining)
- **Action:** Add new signer to replace lost one
- **Requires:** Current signers' approval

### If 2 Signers Lost:
- TR-SAFE fails (need 3, only have 2)
- OPS-SAFE still works (need 2, have 2)
- **Critical:** Funds in TR-SAFE timelocks become inaccessible
- **Prevention:** Keep backup seeds secure, consider adding 5th signer

---

## ✅ RECOMMENDED ACTIONS

### Immediate (Not Yet Done):
1. ⚠️ **Lock LP-NFT for 24 months** using UNCX or Team Finance
2. ⚠️ **Move 977,932 IDIOT** from stray address to Treasury Timelock
3. ⚠️ **Set up Community Distributor** timelock or Sablier stream
4. ⚠️ **Publish transparency page** with all addresses and lock proofs

### Regular Maintenance:
1. Monitor vesting schedules
2. Check Safe balances monthly
3. Verify lock status on LP
4. Update transparency documentation
5. Review access control quarterly

### Security Practices:
1. Store hardware wallets in separate physical locations
2. Keep backup seeds in fireproof/waterproof storage
3. Use hardware wallets for all TR-SAFE signatures
4. Minimize IDIOT holdings in hot wallets
5. Regular security audits

---

## 📊 CURRENT STATUS SUMMARY

| Item | Status | Action Needed |
|------|--------|---------------|
| **Reserve Timelock** | ✅ Deployed | None - vesting active |
| **Treasury Timelock** | ✅ Deployed | None - vesting active |
| **Team Vesting** | ✅ Deployed | None - vesting active |
| **Community Distributor** | ⚠️ Planned | Create timelock or Sablier |
| **LP Lock** | ❌ Not Locked | Lock for 24 months ASAP |
| **Stray IDIOT** | ⚠️ Needs Move | Transfer to Treasury |
| **TR-SAFE** | ✅ Active | Regular monitoring |
| **OPS-SAFE** | ✅ Active | Regular monitoring |

---

## 📞 KEY RESOURCES

### On-Chain Verification:
- **BaseScan:** https://basescan.org
- **Token Contract:** https://basescan.org/token/0xC29EF04CFFe38012dcfc1E96a2B368443f298dE1
- **Reserve Timelock:** https://basescan.org/address/0x6AD03686ab6c3bA2c77992995E4879c62dE88996
- **Treasury Timelock:** https://basescan.org/address/0x5817dccb35cd3a67520e5bda1ebc413cf097a8ee
- **TR-SAFE:** https://basescan.org/address/0x9901b910333A17C8B3b75560BafcE6a893abCD5E

### Management Tools:
- **Safe UI:** https://app.safe.global
- **Sablier (Vesting):** https://sablier.com
- **UNCX (LP Lock):** https://uncx.network
- **Team Finance (LP Lock):** https://team.finance

---

## 🎓 TECHNICAL NOTES

### OpenZeppelin Contracts Used:
- **VestingWallet:** For time-based token release
- **TimelockController:** For governance delays (if used)
- **ERC20:** Standard token implementation

### Sablier Integration:
- Supports cliff + linear vesting
- Base network compatible
- Human-readable UI
- Audited contracts

### Safe Multisig:
- Battle-tested security
- Base network support
- Module support for automation
- Transaction batching

---

**Document Version:** 1.0
**Last Updated:** October 19, 2025
**Network:** Base Mainnet (Chain ID: 8453)
**Total Supply:** 1,000,000,000 IDIOT

---

**END OF MANAGEMENT GUIDE**

