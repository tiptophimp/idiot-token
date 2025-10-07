import pkg from "hardhat";
const { ethers } = pkg;

const NFPM = process.env.NFPM ?? "0x03a520b32C04BF3bEEf7BEb72E919cf822Ed34f1";
const TREASURY_SAFE = process.env.TREASURY_SAFE!; // required
const POSITION_IDS = (process.env.POSITION_IDS ?? "").split(",").map(s=>s.trim()).filter(Boolean);

const NFPM_ABI = [
  "function ownerOf(uint256) view returns (address)",
  "function positions(uint256) view returns (uint96,address,address,address,uint24,int24,int24,uint128,uint256,uint256,uint128,uint128)"
];

async function main() {
  if (!TREASURY_SAFE || POSITION_IDS.length === 0) {
    throw new Error("Set TREASURY_SAFE and POSITION_IDS=comma,separated,ids");
  }

  const [signer] = await ethers.getSigners();
  const nfpm = new ethers.Contract(NFPM, NFPM_ABI, signer);

  console.log("🔍 Verifying NFPM Position Custody");
  console.log("==================================");
  console.log(`Treasury Safe: ${TREASURY_SAFE}`);
  console.log(`Position IDs: ${POSITION_IDS.join(", ")}`);
  console.log("");

  let allSecure = true;

  for (const idStr of POSITION_IDS) {
    const id = BigInt(idStr);
    try {
      const owner = await nfpm.ownerOf(id);
      const pos = await nfpm.positions(id);
      const token0 = pos[2];
      const token1 = pos[3];
      const fee = Number(pos[4]);
      const tickLower = Number(pos[5]);
      const tickUpper = Number(pos[6]);
      const liquidity = pos[7];

      const isSecure = owner.toLowerCase() === TREASURY_SAFE.toLowerCase();
      const status = isSecure ? "✅ SECURE" : "❌ UNSECURE";
      
      console.log(`Position #${id}:`);
      console.log(`  Owner: ${owner}`);
      console.log(`  Status: ${status}`);
      console.log(`  Tokens: ${token0}/${token1}`);
      console.log(`  Fee: ${fee} (${(fee/10000).toFixed(2)}%)`);
      console.log(`  Range: ${tickLower} to ${tickUpper}`);
      console.log(`  Liquidity: ${liquidity.toString()}`);
      console.log("");

      if (!isSecure) {
        allSecure = false;
        console.log(`⚠️  ACTION REQUIRED: Transfer position #${id} to Treasury Safe`);
        console.log(`   Command: npx hardhat run scripts/transfer_position.ts --network base`);
        console.log("");
      }
    } catch (e: any) {
      console.error(`❌ Error checking position #${id}:`, e.message ?? e);
      allSecure = false;
    }
  }

  if (allSecure) {
    console.log("🎉 ALL POSITIONS SECURE - Treasury Safe has custody of all NFTs");
  } else {
    console.log("⚠️  SECURITY ALERT - Some positions not under Treasury Safe custody");
    process.exit(1);
  }
}

main().catch((e) => {
  console.error("❌ Custody verification failed:", e);
  process.exit(1);
});
