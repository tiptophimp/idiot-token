# IDIOT — MerkleDistributor Tool (Base)

This is a plug-and-play Hardhat project to generate a Merkle tree from your allowlist CSV, deploy a distributor, and set the root/times.

## Requirements
- Node 18+
- `npm i`
- Copy `env.example` → `.env` and fill `RPC_URL` and `PRIVATE_KEY` (Base mainnet or testnet).

## Files you care about
- `contracts/MerkleDistributor.sol` — claim contract
- `scripts/gen-manifest.js` — CSV → JSON manifest (with proofs)
- `scripts/check-proof.js` — sanity check one address against the JSON
- `scripts/deploy.js` — deploy distributor
- `scripts/set-root.js` — set merkle root & claim window
- `templates/allowlist.csv` — put your allowlist here (address,amount,pool,notes,...) in **whole tokens**
- `airdrop/idiocracy-1.json` — generated manifest for the website + proofs for on-chain claims

## Quickstart

1) Install
```bash
npm install
cp env.example .env
# fill RPC_URL + PRIVATE_KEY
```

2) Put your allowlist in `templates/allowlist.csv`
```csv
address,amount,pool,notes
0xabc...,25000,community,Discord OG
...
```

3) Generate manifest + proofs
```bash
npm run gen:manifest
# writes airdrop/idiocracy-1.json and prints the Merkle root
```

4) Deploy distributor
```bash
npm run build
npm run deploy
# copy the address it prints
```

5) Set root + window
```bash
# use the root printed in step 3 and your dates (unix seconds)
npm run set:root
```

6) Upload the JSON to your site
Put `airdrop/idiocracy-1.json` at `/public_html/airdrop/idiocracy-1.json`

Your claim UI can now show eligibility and pass proofs to the contract

Note: Manifest contains both amount (human tokens string) and amountWei (uint256 string) so UI and on-chain agree.

## Environment Variables

```bash
# Required for deployment
RPC_URL=https://mainnet.base.org
PRIVATE_KEY=0xYOUR_PRIVATE_KEY

# Optional overrides
TOKEN_CA=0x03a520b32C04BF3bEEf7BEb72E919cf822Ed34f1
CHAIN_ID=8453
SNAPSHOT_ISO=2025-10-15T20:00:00Z

# For set-root script
DISTRIBUTOR=0xDeployedDistributorAddress
MERKLE_ROOT=0xYourMerkleRoot
CLAIM_START=1760731200  # Unix timestamp
CLAIM_END=1763409600    # Unix timestamp
```

## Security Features

- **Merkle Proofs** - Gas-efficient, transparent claims
- **Time Windows** - Configurable claim periods  
- **Sweep Function** - Unclaimed tokens return to Treasury
- **Ownable** - Admin functions protected
- **SafeERC20** - Safe token transfers

## Production Checklist

- [ ] Fill allowlist CSV with real addresses
- [ ] Generate manifest and verify Merkle root
- [ ] Deploy contract to Base mainnet
- [ ] Transfer 250M IDIOT tokens to distributor
- [ ] Set merkle root and claim window
- [ ] Upload JSON manifest to website
- [ ] Test claim portal functionality
- [ ] Announce airdrop launch

**Ready to ship Phase 3!** 🎭
