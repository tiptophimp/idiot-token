// node scripts/check-proof.js airdrop/idiocracy-1.json 0xYourAddress
const fs = require('fs');
const { ethers } = require('ethers');

async function main() {
  const [manifestPath, addr] = process.argv.slice(2);
  if (!manifestPath || !addr) {
    console.error('Usage: node scripts/check-proof.js <manifest.json> <address>');
    process.exit(1);
  }
  const m = JSON.parse(fs.readFileSync(manifestPath, 'utf8'));
  const key = addr.toLowerCase();
  const c = m.claims[key];
  if (!c) {
    console.log('No allocation for', addr);
    return;
  }
  console.log('Address:', addr);
  console.log('Amount:', c.amount, 'IDIOT');
  console.log('AmountWei:', c.amountWei);
  console.log('Proof:', c.proof);
  console.log('MerkleRoot:', m.merkleRoot);
}

main();
