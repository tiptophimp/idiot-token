// scripts/uniswapV3_poolInfo.ts
import pkg from "hardhat";
const { ethers } = pkg;

const POOL = "0x763c9aB550dC0DAbd32F40131481Bf4BA4d8c1ea";
const ABI = [
  "function slot0() view returns (uint160,int24,uint16,uint16,uint16,uint8,bool)",
  "function liquidity() view returns (uint128)",
  "function token0() view returns (address)",
  "function token1() view returns (address)",
  "function fee() view returns (uint24)"
];

async function main() {
  const [signer] = await ethers.getSigners();
  console.log("📊 Fetching IDIOT/WETH pool information");
  console.log(`📝 Signer: ${signer ? await signer.getAddress() : 'No signer available'}`);
  console.log(`🏊 Pool: ${POOL}`);

  // Use provider instead of signer for view functions
  const provider = ethers.provider;
  const pool = new ethers.Contract(POOL, ABI, provider);
  
  console.log("⏳ Fetching pool data...");
  
  const [sqrt, tick, observationIndex, observationCardinality, observationCardinalityNext, feeProtocol, unlocked] = await pool.slot0();
  const liq = await pool.liquidity();
  const t0 = await pool.token0();
  const t1 = await pool.token1();
  const fee = await pool.fee();
  
  console.log("\n📈 Pool Information:");
  console.log("==================");
  console.log(`🏊 Pool Address: ${POOL}`);
  console.log(`💰 Fee Tier: ${fee} (${Number(fee)/10000}%)`);
  console.log(`🔓 Unlocked: ${unlocked ? 'Yes' : 'No'}`);
  
  console.log("\n📊 Current State:");
  console.log("==================");
  console.log(`📐 Sqrt Price (X96): ${sqrt.toString()}`);
  console.log(`📍 Current Tick: ${Number(tick)}`);
  console.log(`💧 Liquidity: ${liq.toString()}`);
  
  console.log("\n🪙 Tokens:");
  console.log("==========");
  console.log(`Token0: ${t0}`);
  console.log(`Token1: ${t1}`);
  
  console.log("\n📊 Observations:");
  console.log("================");
  console.log(`Index: ${observationIndex}`);
  console.log(`Cardinality: ${observationCardinality}`);
  console.log(`Next Cardinality: ${observationCardinalityNext}`);
  console.log(`Fee Protocol: ${feeProtocol}`);
  
  // Calculate price from sqrtPriceX96
  const price = (Number(sqrt) / 2**96) ** 2;
  console.log(`\n💱 Calculated Price: ${price.toFixed(18)}`);
  console.log(`   (Token1 per Token0)`);
  
  // Format liquidity for readability
  const formattedLiquidity = ethers.formatUnits(liq, 18);
  console.log(`\n💧 Formatted Liquidity: ${formattedLiquidity}`);
  
  console.log("\n✅ Pool info retrieved successfully!");
}

main().catch(e=>{
  console.error("❌ Error:", e);
  process.exit(1);
});
