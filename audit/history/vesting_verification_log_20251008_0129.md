# IDIOT Vesting Verification Audit Log

**Generated:** 2025-10-08T01:29:26.319Z  
**Network:** Base Mainnet  
**Purpose:** Immutable proof of vesting contract parameters  

## Contract Verification Status

| Pool | Contract Address | Owner SAFE | Cliff Start | Duration | CodeHash | BaseScan | Status |
|------|------------------|-------------|-------------|----------|----------|----------|--------|
| Reserve | `0x6AD03686ab6c3bA2c77992995E4879c62dE88996` | `0x9901b910333A17C8B3b75560BafcE6a893abCD5E` | 2026-02-03 | 36 mo | `0x8693503db475b10af039104740d2974d43819ae1d1595843b746d0e3cc11dca7` | [View](https://basescan.org/address/0x6AD03686ab6c3bA2c77992995E4879c62dE88996#code) | ❌ Failed |
| Treasury | `0x5817dccb35cd3a67520e5bda1ebc413cf097a8ee` | `0x9901b910333A17C8B3b75560BafcE6a893abCD5E` | 2026-02-03 | 24 mo | `0xfde329cb5d19d04e7c75e80d347dd1b89f196482402b7c5da9019edca82f49fe` | [View](https://basescan.org/address/0x5817dccb35cd3a67520e5bda1ebc413cf097a8ee#code) | ❌ Failed |
| Team | `0x5817dccb35cd3a67520e5bda1ebc413cf097a8ee` | `0x9901b910333A17C8B3b75560BafcE6a893abCD5E` | 2026-10-31 | 36 mo | `0xfde329cb5d19d04e7c75e80d347dd1b89f196482402b7c5da9019edca82f49fe` | [View](https://basescan.org/address/0x5817dccb35cd3a67520e5bda1ebc413cf097a8ee#code) | ❌ Failed |
| Community | `0x9d466e39799fec7204f40133ecc0beb115813c13` | `0x024BE9B76E993A6414D8680F5A3992d17ED37383` | 2025-10-07 | 24 mo | `0xddb822e30e74baf5c353727c2a7e9b75f29421d28876402594b7bc6ad6368074` | [View](https://basescan.org/address/0x9d466e39799fec7204f40133ecc0beb115813c13#code) | ❌ Failed |

## Verification Instructions

### 1. BaseScan Verification
All contracts are verified on BaseScan. Click the "View" links above to inspect:
- Source code matches deployed bytecode
- Constructor arguments are immutable
- No admin functions can modify vesting parameters

### 2. Ownership Verification
Each contract is owned by its respective SAFE multisig:
- **Reserve & Treasury & Team:** TR-SAFE (3/4)
- **Community:** OPS-SAFE (2/4)

### 3. Immutability Proof
- Constructor parameters are marked as `immutable` in Solidity
- No setter functions exist for cliff, start, or duration
- Bytecode hash is recorded above for tamper detection

## Security Status: ⚠️ ISSUES DETECTED

4 contract(s) failed verification. Please check the logs above for details.

---
*This audit log serves as immutable proof of IDIOT token vesting parameters on Base mainnet.*
