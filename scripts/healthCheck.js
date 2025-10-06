// scripts/healthCheck.js - Comprehensive system health check
require("dotenv").config();
const { ethers } = require("hardhat");
const fetch = require("node-fetch");
const fs = require("fs");

const contracts = [
  {
    name: "Reserve",
    address: "0x6AD03686ab6c3bA2c77992995E4879c62dE88996",
  },
  {
    name: "Treasury", 
    address: "0x5817dccb35cd3a67520e5bda1ebc413cf097a8ee",
  },
  {
    name: "Team",
    address: "0x5817dccb35cd3a67520e5bda1ebc413cf097a8ee",
  },
  {
    name: "Community",
    address: "0x9d466e39799fec7204f40133ecc0beb115813c13",
  },
];

async function checkEnvironment() {
  console.log("🔧 Environment Check");
  console.log("===================");
  
  const requiredVars = ["PRIVATE_KEY", "BASESCAN_API_KEY"];
  const optionalVars = ["DISCORD_WEBHOOK_URL", "SLACK_WEBHOOK_URL"];
  
  let allGood = true;
  
  for (const varName of requiredVars) {
    const value = process.env[varName];
    if (!value || value.includes("YOUR_")) {
      console.log(`❌ ${varName}: Missing or not configured`);
      allGood = false;
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
  
  return allGood;
}

async function checkNetwork() {
  console.log("\n🌐 Network Check");
  console.log("================");
  
  try {
    const provider = new ethers.JsonRpcProvider("https://mainnet.base.org");
    const network = await provider.getNetwork();
    const blockNumber = await provider.getBlockNumber();
    
    console.log(`✅ Base Mainnet: Connected`);
    console.log(`   Chain ID: ${network.chainId}`);
    console.log(`   Block: ${blockNumber}`);
    
    return true;
  } catch (error) {
    console.log(`❌ Base Mainnet: Connection failed`);
    console.log(`   Error: ${error.message}`);
    return false;
  }
}

async function checkContracts() {
  console.log("\n📋 Contract Check");
  console.log("=================");
  
  let allVerified = true;
  
  for (const contract of contracts) {
    try {
      const url = `https://api.basescan.org/api?module=contract&action=getsourcecode&address=${contract.address}&apikey=${process.env.BASESCAN_API_KEY}`;
      const response = await fetch(url);
      const data = await response.json();
      
      if (data.status === "1" && data.result[0].SourceCode !== "") {
        console.log(`✅ ${contract.name}: Verified on BaseScan`);
      } else {
        console.log(`❌ ${contract.name}: Not verified on BaseScan`);
        allVerified = false;
      }
    } catch (error) {
      console.log(`⚠️  ${contract.name}: Check failed - ${error.message}`);
      allVerified = false;
    }
  }
  
  return allVerified;
}

async function checkIPFS() {
  console.log("\n🌐 IPFS Check");
  console.log("=============");
  
  try {
    const { create } = require('ipfs-http-client');
    const ipfs = create({ url: 'https://ipfs.infura.io:5001/api/v0' });
    
    // Test IPFS connection
    const version = await ipfs.version();
    console.log(`✅ IPFS Gateway: Connected`);
    console.log(`   Version: ${version.version}`);
    
    return true;
  } catch (error) {
    console.log(`❌ IPFS Gateway: Connection failed`);
    console.log(`   Error: ${error.message}`);
    return false;
  }
}

async function checkWebhooks() {
  console.log("\n📢 Webhook Check");
  console.log("================");
  
  const webhookUrl = process.env.DISCORD_WEBHOOK_URL || process.env.SLACK_WEBHOOK_URL;
  
  if (!webhookUrl || webhookUrl.includes("xxxxx")) {
    console.log("⚠️  Webhooks: Not configured");
    return false;
  }
  
  try {
    const isDiscord = webhookUrl.includes('discord.com');
    const payload = {
      content: "🔍 IDIOT Verification System Health Check"
    };
    
    const response = await fetch(webhookUrl, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload)
    });
    
    if (response.ok) {
      console.log(`✅ ${isDiscord ? 'Discord' : 'Slack'}: Webhook working`);
      return true;
    } else {
      console.log(`❌ Webhook: Failed (${response.status})`);
      return false;
    }
  } catch (error) {
    console.log(`❌ Webhook: Error - ${error.message}`);
    return false;
  }
}

async function checkAuditFiles() {
  console.log("\n📄 Audit Files Check");
  console.log("====================");
  
  const auditFile = "./audit/vesting_verification_log.md";
  const cidFile = "./audit/last_ipfs_cid.txt";
  
  if (fs.existsSync(auditFile)) {
    const stats = fs.statSync(auditFile);
    console.log(`✅ Audit Log: Exists (${stats.size} bytes)`);
    console.log(`   Modified: ${stats.mtime.toISOString()}`);
  } else {
    console.log(`⚠️  Audit Log: Not found`);
  }
  
  if (fs.existsSync(cidFile)) {
    const cid = fs.readFileSync(cidFile, 'utf8').trim();
    console.log(`✅ Last CID: ${cid}`);
  } else {
    console.log(`⚠️  Last CID: Not found`);
  }
}

async function checkDependencies() {
  console.log("\n📦 Dependencies Check");
  console.log("=====================");
  
  const requiredDeps = [
    'hardhat',
    '@nomicfoundation/hardhat-verify',
    'dotenv',
    'ethers',
    'node-fetch',
    'ipfs-http-client'
  ];
  
  let allInstalled = true;
  
  for (const dep of requiredDeps) {
    try {
      require(dep);
      console.log(`✅ ${dep}: Installed`);
    } catch (error) {
      console.log(`❌ ${dep}: Missing`);
      allInstalled = false;
    }
  }
  
  return allInstalled;
}

async function main() {
  console.log("🏥 IDIOT Verification System Health Check");
  console.log("==========================================\n");
  
  const checks = [
    { name: "Environment", fn: checkEnvironment },
    { name: "Network", fn: checkNetwork },
    { name: "Contracts", fn: checkContracts },
    { name: "IPFS", fn: checkIPFS },
    { name: "Webhooks", fn: checkWebhooks },
    { name: "Dependencies", fn: checkDependencies }
  ];
  
  const results = {};
  
  for (const check of checks) {
    try {
      results[check.name] = await check.fn();
    } catch (error) {
      console.log(`❌ ${check.name}: Error - ${error.message}`);
      results[check.name] = false;
    }
  }
  
  // Check audit files (non-critical)
  await checkAuditFiles();
  
  // Summary
  console.log("\n📊 Health Check Summary");
  console.log("=======================");
  
  const passed = Object.values(results).filter(Boolean).length;
  const total = Object.keys(results).length;
  
  for (const [name, passed] of Object.entries(results)) {
    console.log(`${passed ? '✅' : '❌'} ${name}: ${passed ? 'PASS' : 'FAIL'}`);
  }
  
  console.log(`\n🎯 Overall Status: ${passed}/${total} checks passed`);
  
  if (passed === total) {
    console.log("🎉 All systems operational!");
  } else {
    console.log("⚠️  Some issues detected. Review the output above.");
  }
  
  // Recommendations
  if (!results.Environment) {
    console.log("\n💡 Recommendation: Configure your .env file");
  }
  if (!results.Dependencies) {
    console.log("\n💡 Recommendation: Run 'npm install'");
  }
  if (!results.Network) {
    console.log("\n💡 Recommendation: Check your internet connection");
  }
  if (!results.Contracts) {
    console.log("\n💡 Recommendation: Run verification task");
  }
}

main().catch((error) => {
  console.error("❌ Health check failed:", error);
  process.exit(1);
});
