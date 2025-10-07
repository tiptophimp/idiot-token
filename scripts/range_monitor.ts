import pkg from "hardhat";
const { ethers } = pkg;
import fs from "fs";

const POOL = process.env.POOL ?? "0x763c9aB550dC0DAbd32F40131481Bf4BA4d8c1ea";
const NFPM = process.env.NFPM ?? "0x03a520b32C04BF3bEEf7BEb72E919cf822Ed34f1";
const TREASURY_SAFE = process.env.TREASURY_SAFE!;
const POSITION_IDS = (process.env.POSITION_IDS ?? "").split(",").map(s=>s.trim()).filter(Boolean);
const TICK_THRESHOLD = Number(process.env.TICK_THRESHOLD ?? "600");

const POOL_ABI = [
  "function slot0() view returns (uint160,int24,uint16,uint16,uint16,uint8,bool)"
];

const NFPM_ABI = [
  "function positions(uint256) view returns (uint96,address,address,address,uint24,int24,int24,uint128,uint256,uint256,uint128,uint128)"
];

function nearestUsableTick(tick: number, spacing: number) {
  return Math.floor(tick / spacing) * spacing;
}

async function main() {
  if (!TREASURY_SAFE || POSITION_IDS.length === 0) {
    throw new Error("Set TREASURY_SAFE and POSITION_IDS=comma,separated,ids");
  }

  const [signer] = await ethers.getSigners();
  const pool = new ethers.Contract(POOL, POOL_ABI, signer);
  const nfpm = new ethers.Contract(NFPM, NFPM_ABI, signer);

  console.log("📊 Range Management SLO Monitor");
  console.log("===============================");
  console.log(`Pool: ${POOL}`);
  console.log(`Tick Threshold: ±${TICK_THRESHOLD}`);
  console.log("");

  // Get current pool state
  const slot0 = await pool.slot0();
  const currentTick = Number(slot0[1]);
  const sqrtPriceX96 = slot0[0];

  console.log(`Current Tick: ${currentTick}`);
  console.log(`Sqrt Price: ${sqrtPriceX96.toString()}`);
  console.log("");

  const auditFile = "./audit/LP_actions.md";
  if (!fs.existsSync("./audit")) fs.mkdirSync("./audit");

  let needsRecenter = false;
  const actions = [];

  for (const idStr of POSITION_IDS) {
    const id = BigInt(idStr);
    try {
      const pos = await nfpm.positions(id);
      const tickLower = Number(pos[5]);
      const tickUpper = Number(pos[6]);
      const liquidity = pos[7];
      const tickMid = Math.floor((tickLower + tickUpper) / 2);
      const tickDeviation = Math.abs(currentTick - tickMid);

      console.log(`Position #${id}:`);
      console.log(`  Range: ${tickLower} to ${tickUpper}`);
      console.log(`  Mid: ${tickMid}`);
      console.log(`  Deviation: ${tickDeviation} ticks`);
      console.log(`  Liquidity: ${liquidity.toString()}`);

      // Check SLO conditions
      const condition1 = tickDeviation > TICK_THRESHOLD;
      const condition2 = liquidity === 0n;

      if (condition1 || condition2) {
        needsRecenter = true;
        const reason = condition1 ? `tick deviation ${tickDeviation} > ${TICK_THRESHOLD}` : "liquidity = 0";
        console.log(`  ⚠️  ACTION REQUIRED: ${reason}`);
        
        actions.push({
          positionId: id.toString(),
          reason,
          currentTick,
          tickLower,
          tickUpper,
          tickMid,
          tickDeviation,
          liquidity: liquidity.toString()
        });
      } else {
        console.log(`  ✅ Within SLO`);
      }
      console.log("");
    } catch (e: any) {
      console.error(`❌ Error checking position #${id}:`, e.message ?? e);
    }
  }

  // Log actions to audit file
  if (actions.length > 0) {
    const timestamp = new Date().toISOString();
    const logEntry = `## ${timestamp} - Range Management Alert

**Trigger:** SLO violation detected
**Current Tick:** ${currentTick}
**Threshold:** ±${TICK_THRESHOLD}

### Actions Required:
${actions.map(action => `
**Position #${action.positionId}:**
- Reason: ${action.reason}
- Current Tick: ${action.currentTick}
- Position Range: ${action.tickLower} to ${action.tickUpper}
- Mid Tick: ${action.tickMid}
- Deviation: ${action.tickDeviation}
- Liquidity: ${action.liquidity}
`).join('')}

### Recommended Action:
\`\`\`bash
POSITION_ID=${actions[0].positionId} \\
SAFE_RECIPIENT=${TREASURY_SAFE} \\
npx hardhat run scripts/recenter_liquidity.ts --network base
\`\`\`

---
`;

    fs.appendFileSync(auditFile, logEntry);
    console.log(`📝 Actions logged to ${auditFile}`);
  }

  if (needsRecenter) {
    console.log("🚨 SLO VIOLATION - Recenter required");
    console.log(`Run: POSITION_ID=${actions[0].positionId} SAFE_RECIPIENT=${TREASURY_SAFE} npx hardhat run scripts/recenter_liquidity.ts --network base`);
    process.exit(1);
  } else {
    console.log("✅ All positions within SLO");
  }
}

main().catch((e) => {
  console.error("❌ Range monitoring failed:", e);
  process.exit(1);
});
