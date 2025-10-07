// scripts/uniswapV3_increaseLiquidity.ts
import pkg from "hardhat";
const { ethers } = pkg;

const NFPM = "0x03a520b32C04BF3bEEf7BEb72E919cf822Ed34f1";
const WETH = "0x4200000000000000000000000000000000000006";
const IDIOT = "0xC29EF04CFFe38012dcfc1E96a2B368443f298dE1";

const ERC20_ABI = ["function approve(address,uint256) returns (bool)"];
const NFPM_ABI = [
  "function increaseLiquidity((uint256 tokenId,uint256 amount0Desired,uint256 amount1Desired,uint256 amount0Min,uint256 amount1Min,uint256 deadline)) returns (uint128,uint256,uint256)"
];

async function main() {
  const [signer] = await ethers.getSigners();
  const tokenId = Number(process.env.POSITION_ID);
  
  if (!tokenId) {
    console.error("❌ Please set POSITION_ID environment variable");
    console.log("Usage: POSITION_ID=123 npx hardhat run scripts/uniswapV3_increaseLiquidity.ts --network base");
    process.exit(1);
  }

  console.log("🚀 Increasing liquidity for position", tokenId);
  console.log(`📝 Signer: ${await signer.getAddress()}`);

  const nfpm = new ethers.Contract(NFPM, NFPM_ABI, signer);
  const weth = new ethers.Contract(WETH, ERC20_ABI, signer);
  const idiot = new ethers.Contract(IDIOT, ERC20_ABI, signer);

  const add0 = ethers.parseEther("0.05");                // edit
  const add1 = ethers.parseUnits("1000000", 18);         // edit

  console.log(`💰 Adding WETH: ${ethers.formatEther(add0)}`);
  console.log(`💰 Adding IDIOT: ${ethers.formatUnits(add1, 18)}`);

  await (await weth.approve(NFPM, add0)).wait();
  console.log("✅ WETH approved");
  
  await (await idiot.approve(NFPM, add1)).wait();
  console.log("✅ IDIOT approved");

  const params = {
    tokenId,
    amount0Desired: add0,
    amount1Desired: add1,
    amount0Min: 0,
    amount1Min: 0,
    deadline: Math.floor(Date.now()/1000)+900
  };
  
  console.log("📋 Increasing liquidity with params:", {
    tokenId,
    amount0Desired: ethers.formatEther(add0),
    amount1Desired: ethers.formatUnits(add1, 18)
  });

  const tx = await nfpm.increaseLiquidity(params);
  console.log("⏳ Transaction submitted:", tx.hash);
  
  const r = await tx.wait();
  console.log("✅ Liquidity increased successfully!");
  console.log("📄 Transaction hash:", r?.hash);
}

main().catch(e=>{
  console.error("❌ Error:", e);
  process.exit(1);
});
