// scripts/ci-setup.js - CI/CD setup and validation script
import dotenv from "dotenv";
import fs from "fs";
import { execSync } from "child_process";

dotenv.config();

console.log("🚀 IDIOT Contract Verification CI/CD Setup");
console.log("==========================================\n");

// Check if running in GitHub Actions
const isCI = process.env.GITHUB_ACTIONS === 'true';
const isLocal = !isCI;

console.log(`Environment: ${isCI ? 'GitHub Actions' : 'Local Development'}`);

// Validate required environment variables
function validateEnvironment() {
  console.log("\n🔧 Environment Validation");
  console.log("=========================");
  
  const requiredVars = ["PRIVATE_KEY", "BASESCAN_API_KEY"];
  const optionalVars = ["DISCORD_WEBHOOK_URL", "SLACK_WEBHOOK_URL"];
  
  let allValid = true;
  
  for (const varName of requiredVars) {
    const value = process.env[varName];
    if (!value || value.includes("YOUR_") || value.includes("xxxxx")) {
      console.log(`❌ ${varName}: Missing or not configured`);
      allValid = false;
    } else {
      console.log(`✅ ${varName}: Configured`);
    }
  }
  
  for (const varName of optionalVars) {
    const value = process.env[varName];
    if (value && !value.includes("xxxxx")) {
      console.log(`✅ ${varName}: Configured`);
    } else {
      console.log(`⚠️  ${varName}: Not configured (optional)`);
    }
  }
  
  return allValid;
}

// Check GitHub Actions specific environment
function checkCISetup() {
  if (!isCI) return true;
  
  console.log("\n🤖 GitHub Actions Setup");
  console.log("=======================");
  
  const ciVars = [
    "GITHUB_WORKFLOW",
    "GITHUB_RUN_ID", 
    "GITHUB_SHA",
    "GITHUB_ACTIONS"
  ];
  
  let ciValid = true;
  
  for (const varName of ciVars) {
    const value = process.env[varName];
    if (value) {
      console.log(`✅ ${varName}: ${value}`);
    } else {
      console.log(`⚠️  ${varName}: Not set`);
      ciValid = false;
    }
  }
  
  return ciValid;
}

// Install dependencies
function installDependencies() {
  console.log("\n📦 Dependency Installation");
  console.log("===========================");
  
  try {
    console.log("Installing npm packages...");
    execSync("npm ci", { stdio: "inherit" });
    console.log("✅ npm packages installed");
    
    console.log("Installing Foundry...");
    execSync("npm install -g foundryup", { stdio: "inherit" });
    execSync("foundryup", { stdio: "inherit" });
    console.log("✅ Foundry installed");
    
    return true;
  } catch (error) {
    console.error("❌ Dependency installation failed:", error.message);
    return false;
  }
}

// Compile contracts
function compileContracts() {
  console.log("\n🔨 Contract Compilation");
  console.log("=======================");
  
  try {
    execSync("npx hardhat compile", { stdio: "inherit" });
    console.log("✅ Contracts compiled successfully");
    return true;
  } catch (error) {
    console.error("❌ Contract compilation failed:", error.message);
    return false;
  }
}

// Create audit directory
function setupAuditDirectory() {
  console.log("\n📁 Audit Directory Setup");
  console.log("========================");
  
  if (!fs.existsSync("audit")) {
    fs.mkdirSync("audit");
    console.log("✅ Created audit directory");
  } else {
    console.log("✅ Audit directory exists");
  }
  
  return true;
}

// Main setup function
async function main() {
  const steps = [
    { name: "Environment Validation", fn: validateEnvironment },
    { name: "CI Setup Check", fn: checkCISetup },
    { name: "Dependency Installation", fn: installDependencies },
    { name: "Contract Compilation", fn: compileContracts },
    { name: "Audit Directory Setup", fn: setupAuditDirectory }
  ];
  
  const results = {};
  
  for (const step of steps) {
    try {
      results[step.name] = await step.fn();
    } catch (error) {
      console.error(`❌ ${step.name} failed:`, error.message);
      results[step.name] = false;
    }
  }
  
  // Summary
  console.log("\n📊 Setup Summary");
  console.log("================");
  
  const passed = Object.values(results).filter(Boolean).length;
  const total = Object.keys(results).length;
  
  for (const [name, passed] of Object.entries(results)) {
    console.log(`${passed ? '✅' : '❌'} ${name}: ${passed ? 'PASS' : 'FAIL'}`);
  }
  
  console.log(`\n🎯 Overall Status: ${passed}/${total} steps completed`);
  
  if (passed === total) {
    console.log("🎉 CI/CD setup complete! Ready for verification.");
    
    if (isCI) {
      console.log("\n🤖 GitHub Actions Environment Ready");
      console.log("===================================");
      console.log(`Workflow: ${process.env.GITHUB_WORKFLOW}`);
      console.log(`Run ID: ${process.env.GITHUB_RUN_ID}`);
      console.log(`Commit: ${process.env.GITHUB_SHA}`);
    }
  } else {
    console.log("⚠️  Some setup steps failed. Review the output above.");
    process.exit(1);
  }
}

main().catch((error) => {
  console.error("❌ CI setup failed:", error);
  process.exit(1);
});
