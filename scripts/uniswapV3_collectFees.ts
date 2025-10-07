// scripts/uniswapV3_collectFees.ts
import pkg from "hardhat";
const { ethers } = pkg;

const NFPM = "0x03a520b32C04BF3bEEf7BEb72E919cf822Ed34f1";
const ABI = [
  "function collect((uint256 tokenId,address recipient,uint128 amount0Max,uint128 amount1Max)) returns (uint256,uint256)"
];

async function main() {
  const [signer] = await ethers.getSigners();
  const tokenId = Number(process.env.POSITION_ID);
  
  if (!tokenId) {
    console.error("❌ Please set POSITION_ID environment variable");
    console.log("Usage: POSITION_ID=123 npx hardhat run scripts/uniswapV3_collectFees.ts --network base");
    process.exit(1);
  }

  console.log("💰 Collecting fees for position", tokenId);
  console.log(`📝 Signer: ${await signer.getAddress()}`);

  const nfpm = new ethers.Contract(NFPM, ABI, signer);
  const params = {
    tokenId,
    recipient: await signer.getAddress(),
    amount0Max: 2n**128n - 1n,
    amount1Max: 2n**128n - 1n
  };
  
  console.log("📋 Collecting all available fees...");
  
  const tx = await nfpm.collect(params);
  console.log("⏳ Transaction submitted:", tx.hash);
  
  const r = await tx.wait();
  console.log("✅ Fees collected successfully!");
  console.log("📄 Transaction hash:", r?.hash);
  
  // Parse the collect event to show amounts
  const collectEvent = r?.logs.find(log => {
    try {
      const parsed = nfpm.interface.parseLog(log);
      return parsed?.name === 'Collect';
    } catch {
      return false;
    }
  });
  
  if (collectEvent) {
    const parsed = nfpm.interface.parseLog(collectEvent);
    console.log("💵 Collected amounts:");
    console.log(`   Token0 (WETH): ${ethers.formatEther(parsed?.args.amount0 || 0)}`);
    console.log(`   Token1 (IDIOT): ${ethers.formatUnits(parsed?.args.amount1 || 0, 18)}`);
  }
}

main().catch(e=>{
  console.error("❌ Error:", e);
  process.exit(1);
});
