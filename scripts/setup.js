// scripts/setup.js - One-time setup script for IDIOT verification system
import fs from "fs";
import { execSync } from "child_process";

console.log("🚀 Setting up IDIOT Token Verification System...\n");

// Check if .env exists
if (!fs.existsSync(".env")) {
  console.log("❌ .env file not found!");
  console.log("📝 Please copy env.template to .env and fill in your values:");
  console.log("   - PRIVATE_KEY (your deployer private key)");
  console.log("   - BASESCAN_API_KEY (from https://basescan.org/apis)");
  console.log("   - DISCORD_WEBHOOK_URL (optional, for notifications)");
  console.log("   - SLACK_WEBHOOK_URL (optional, alternative to Discord)");
  process.exit(1);
}

// Check if dependencies are installed
try {
  await import("node-fetch");
  await import("ipfs-http-client");
  console.log("✅ Dependencies already installed");
} catch (e) {
  console.log("📦 Installing dependencies...");
  try {
    execSync("npm install", { stdio: "inherit" });
    console.log("✅ Dependencies installed successfully");
  } catch (error) {
    console.error("❌ Failed to install dependencies:", error.message);
    process.exit(1);
  }
}

// Check if Foundry is installed
try {
  execSync("cast --version", { stdio: "pipe" });
  console.log("✅ Foundry (cast) is available");
} catch (e) {
  console.log("🔧 Installing Foundry...");
  try {
    execSync("npm install --global foundryup", { stdio: "inherit" });
    execSync("foundryup", { stdio: "inherit" });
    console.log("✅ Foundry installed successfully");
  } catch (error) {
    console.error("❌ Failed to install Foundry:", error.message);
    console.log("💡 Please install Foundry manually: https://book.getfoundry.sh/getting-started/installation");
  }
}

// Create audit directory if it doesn't exist
if (!fs.existsSync("audit")) {
  fs.mkdirSync("audit");
  console.log("📁 Created audit directory");
}

// Test environment variables
import dotenv from "dotenv";
dotenv.config();
const requiredVars = ["PRIVATE_KEY", "BASESCAN_API_KEY"];
const missingVars = requiredVars.filter(varName => !process.env[varName] || process.env[varName].includes("YOUR_"));

if (missingVars.length > 0) {
  console.log("⚠️  Missing or incomplete environment variables:");
  missingVars.forEach(varName => console.log(`   - ${varName}`));
  console.log("📝 Please update your .env file with the correct values");
}

// Check webhook configuration
const hasWebhook = process.env.DISCORD_WEBHOOK_URL || process.env.SLACK_WEBHOOK_URL;
if (!hasWebhook) {
  console.log("📢 No webhook configured - notifications will be skipped");
  console.log("💡 Add DISCORD_WEBHOOK_URL or SLACK_WEBHOOK_URL to .env for notifications");
}

console.log("\n🎯 Setup Complete! You can now:");
console.log("   1. Run 'Verify + Audit + Notify' task in Cursor (Ctrl+Shift+P → Tasks: Run Task)");
console.log("   2. Or run: npx hardhat run scripts/verifyAuditNotify.js --network base");
console.log("   3. Check audit/vesting_verification_log.md for results");

if (missingVars.length === 0 && hasWebhook) {
  console.log("\n✅ All systems ready for verification!");
} else {
  console.log("\n⚠️  Please complete the setup by updating your .env file");
}
