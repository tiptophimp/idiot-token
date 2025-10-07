// scripts/deployVesting.js - Deploy vesting contracts and update addresses
import dotenv from "dotenv";
import pkg from "hardhat";
import fs from "fs";

const { ethers } = pkg;
dotenv.config();

const addressesFile = "./deployment/addresses.json";

// Vesting contract parameters
const vestingParams = [
  {
    name: "Reserve",
    safe: "0xTR_SAFE", // Replace with actual TR-SAFE address
    start: 1770076800, // 2026-04-01
    duration: 94608000, // 3 years
  },
  {
    name: "Treasury", 
    safe: "0xTR_SAFE", // Replace with actual TR-SAFE address
    start: 1770076800, // 2026-04-01
    duration: 63072000, // 2 years
  },
  {
    name: "Team",
    safe: "0xTR_SAFE", // Replace with actual TR-SAFE address
    start: 1793481600, // 2026-10-01
    duration: 94608000, // 3 years
  },
  {
    name: "Community",
    safe: "0xOPS_SAFE", // Replace with actual OPS-SAFE address
    start: 1759795200, // 2025-10-07
    duration: 63072000, // 2 years
  },
];

async function deployVestingContract(params) {
  console.log(`\n🚀 Deploying ${params.name} Vesting Contract`);
  console.log("==========================================");
  
  // Get deployer
  const [deployer] = await ethers.getSigners();
  console.log(`📝 Deployer: ${deployer.address}`);
  
  // Deploy vesting contract
  const VestingContract = await ethers.getContractFactory("VestingContract");
  const vesting = await VestingContract.deploy(
    params.safe,
    params.start,
    params.duration
  );
  
  await vesting.waitForDeployment();
  const address = await vesting.getAddress();
  
  console.log(`✅ ${params.name} deployed to: ${address}`);
  console.log(`🔗 BaseScan: https://basescan.org/address/${address}`);
  console.log(`👤 Owner: ${params.safe}`);
  console.log(`📅 Start: ${new Date(params.start * 1000).toISOString()}`);
  console.log(`⏱️  Duration: ${Math.floor(params.duration / 86400 / 30)} months`);
  
  return {
    name: params.name,
    address,
    safe: params.safe,
    start: params.start,
    duration: params.duration,
    deployer: deployer.address,
    txHash: vesting.deploymentTransaction().hash
  };
}

async function main() {
  console.log("🏗️  IDIOT Token Vesting Contract Deployment");
  console.log("==========================================\n");
  
  // Check if addresses file exists
  let addresses = {};
  if (fs.existsSync(addressesFile)) {
    addresses = JSON.parse(fs.readFileSync(addressesFile, 'utf8'));
    console.log("📄 Found existing addresses file");
  } else {
    console.log("📄 Creating new addresses file");
  }
  
  // Deploy all vesting contracts
  const deployedContracts = [];
  
  for (const params of vestingParams) {
    try {
      const contract = await deployVestingContract(params);
      deployedContracts.push(contract);
      
      // Update addresses file
      addresses[contract.name] = {
        address: contract.address,
        safe: contract.safe,
        start: contract.start,
        duration: contract.duration,
        deployer: contract.deployer,
        txHash: contract.txHash,
        deployedAt: new Date().toISOString()
      };
      
    } catch (error) {
      console.error(`❌ Failed to deploy ${params.name}:`, error.message);
    }
  }
  
  // Save updated addresses
  fs.writeFileSync(addressesFile, JSON.stringify(addresses, null, 2));
  console.log(`\n💾 Addresses saved to: ${addressesFile}`);
  
  // Summary
  console.log("\n📊 Deployment Summary");
  console.log("====================");
  console.log(`✅ Successfully deployed: ${deployedContracts.length}/${vestingParams.length} contracts`);
  
  for (const contract of deployedContracts) {
    console.log(`   ${contract.name}: ${contract.address}`);
  }
  
  if (deployedContracts.length === vestingParams.length) {
    console.log("\n🎉 All vesting contracts deployed successfully!");
    console.log("🔄 Next step: Transfer ownership to governance contracts");
  } else {
    console.log("\n⚠️  Some contracts failed to deploy. Check the logs above.");
  }
}

main().catch((error) => {
  console.error("❌ Deployment failed:", error);
  process.exit(1);
});
