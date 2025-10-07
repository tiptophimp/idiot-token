import pkg from "hardhat";
const { ethers } = pkg;
import { execSync } from "child_process";
import fs from "fs";

const POSITION_ID = process.env.POSITION_ID!;
const TICK_LOWER = process.env.TICK_LOWER!;
const TICK_UPPER = process.env.TICK_UPPER!;
const REASON = process.env.REASON || "LP update";

async function main() {
  if (!POSITION_ID || !TICK_LOWER || !TICK_UPPER) {
    throw new Error("Set POSITION_ID, TICK_LOWER, TICK_UPPER environment variables");
  }

  console.log("📋 Change Control - LP Update");
  console.log("=============================");
  console.log(`Position ID: ${POSITION_ID}`);
  console.log(`Tick Range: ${TICK_LOWER} to ${TICK_UPPER}`);
  console.log(`Reason: ${REASON}`);
  console.log("");

  // Get current timestamp
  const timestamp = new Date().toISOString();
  const dateTag = new Date().toISOString().split('T')[0].replace(/-/g, '');

  // Stage all changes
  console.log("📦 Staging changes...");
  execSync("git add .", { stdio: 'inherit' });

  // Create commit message
  const commitMessage = `LP update: POSITION_ID=${POSITION_ID}, ticks ${TICK_LOWER}/${TICK_UPPER}`;
  
  console.log("💾 Committing changes...");
  execSync(`git commit -m "${commitMessage}"`, { stdio: 'inherit' });

  // Create tag
  const tagName = `v1.0-lp-${dateTag}`;
  console.log(`🏷️  Creating tag: ${tagName}`);
  execSync(`git tag ${tagName}`, { stdio: 'inherit' });

  // Log to audit file
  const auditFile = "./audit/LP_actions.md";
  if (!fs.existsSync("./audit")) fs.mkdirSync("./audit");

  const logEntry = `## ${timestamp} - LP Change Control

**Position ID:** ${POSITION_ID}
**Tick Range:** ${TICK_LOWER} to ${TICK_UPPER}
**Reason:** ${REASON}
**Git Tag:** ${tagName}
**Commit:** ${commitMessage}

### Change Summary:
- Position parameters updated
- New tick range set
- All changes committed and tagged
- Audit trail maintained

---
`;

  fs.appendFileSync(auditFile, logEntry);

  console.log("");
  console.log("✅ Change Control Complete");
  console.log(`📝 Tag: ${tagName}`);
  console.log(`📄 Audit: ${auditFile}`);
  console.log("");
  console.log("🔄 Next Steps:");
  console.log("1. Push changes: git push origin main --tags");
  console.log("2. Verify position on BaseScan");
  console.log("3. Update monitoring if needed");
}

main().catch((e) => {
  console.error("❌ Change control failed:", e);
  process.exit(1);
});
