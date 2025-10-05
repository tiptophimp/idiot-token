const { ethers } = require('hardhat');

async function main() {
  const distAddr = process.env.DISTRIBUTOR;
  const root = process.env.MERKLE_ROOT;
  const start = process.env.CLAIM_START || '0';
  const end = process.env.CLAIM_END || '0';
  if (!distAddr || !root) {
    console.error('Set DISTRIBUTOR and MERKLE_ROOT (and optionally CLAIM_START, CLAIM_END)');
    process.exit(1);
  }
  const dist = await ethers.getContractAt('MerkleDistributor', distAddr);
  console.log('Setting root...', root);
  const tx1 = await dist.setMerkleRoot(root);
  await tx1.wait();
  console.log('Setting window...', start, end);
  const tx2 = await dist.setWindow(start, end);
  await tx2.wait();
  console.log('Done.');
}

main().catch((e)=>{ console.error(e); process.exit(1); });
