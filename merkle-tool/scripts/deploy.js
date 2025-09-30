const { ethers } = require('hardhat');

async function main() {
  const token = process.env.TOKEN_CA || '0x03a520b32C04BF3bEEf7BEb72E919cf822Ed34f1';
  const Distributor = await ethers.getContractFactory('MerkleDistributor');
  const dist = await Distributor.deploy(token);
  await dist.waitForDeployment();
  console.log('MerkleDistributor:', await dist.getAddress());
}

main().catch((e)=>{ console.error(e); process.exit(1); });
