// CSV -> Manifest + Merkle proofs
// Usage: node scripts/gen-manifest.js templates/allowlist.csv airdrop/idiocracy-1.json
const fs = require('fs');
const { parse } = require('csv-parse/sync');
const { ethers } = require('ethers');
const keccak256 = require('keccak256');
const { MerkleTree } = require('merkletreejs');

const CA = process.env.TOKEN_CA || '0x03a520b32C04BF3bEEf7BEb72E919cf822Ed34f1';
const CHAIN_ID = parseInt(process.env.CHAIN_ID || '8453',10);
const SNAPSHOT = process.env.SNAPSHOT_ISO || '2025-10-15T20:00:00Z';

function toWei(str) {
  const s = String(str).trim();
  return ethers.parseUnits(s, 18).toString(); // string uint256
}

function leafFor(addr, amountWei) {
  return Buffer.from(
    ethers.solidityPackedKeccak256(['address','uint256'], [addr, amountWei]).slice(2),
    'hex'
  );
}

function main() {
  const [csvIn, jsonOut] = process.argv.slice(2);
  if (!csvIn || !jsonOut) {
    console.error('Usage: node scripts/gen-manifest.js <csvIn> <jsonOut>');
    process.exit(1);
  }
  const raw = fs.readFileSync(csvIn, 'utf8');
  const rows = parse(raw, { columns: true, skip_empty_lines: true, trim: true });

  const entries = rows.map(r => {
    const address = (r.address || '').trim();
    if (!address || !address.startsWith('0x') || address.length !== 42) {
      throw new Error(`Bad address: ${address}`);
    }
    const amount = (r.amount || '').trim();
    if (!amount) throw new Error(`Missing amount for ${address}`);
    const amountWei = toWei(amount);
    const pool = (r.pool || '').trim();
    const notes = (r.notes || '').trim();
    return { address: ethers.getAddress(address), amount, amountWei, pool, notes };
  });

  const leaves = entries.map(e => leafFor(e.address, e.amountWei));
  const tree = new MerkleTree(leaves, keccak256, { sortPairs: true, sortLeaves: true });

  const claims = {};
  for (const e of entries) {
    const leaf = leafFor(e.address, e.amountWei);
    const proof = tree.getHexProof(leaf);
    claims[e.address.toLowerCase()] = {
      amount: e.amount,
      amountWei: e.amountWei,
      pool: e.pool || undefined,
      proof
    };
  }

  const out = {
    name: "Idiocracy Airdrop #1",
    token: CA,
    chainId: CHAIN_ID,
    snapshot: SNAPSHOT,
    claimStart: "TBD",
    claimEnd: "TBD",
    merkleRoot: tree.getHexRoot(),
    total: entries.reduce((a,e)=> (BigInt(a) + BigInt(e.amountWei)).toString(), "0"),
    decimals: 18,
    claims
  };

  fs.mkdirSync(require('path').dirname(jsonOut), { recursive: true });
  fs.writeFileSync(jsonOut, JSON.stringify(out, null, 2));
  console.log('Merkle root:', out.merkleRoot);
  console.log('Total (wei):', out.total);
  console.log('Wrote', jsonOut);
}

main();
