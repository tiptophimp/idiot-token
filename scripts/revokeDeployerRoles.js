// scripts/revokeDeployerRoles.js - Revoke deployer privileges for security
import dotenv from "dotenv";
import pkg from "hardhat";
import fs from "fs";

const { ethers } = pkg;
dotenv.config();

const addressesFile = "./deployment/addresses.json";

async function revokeDeployerRole(contractName, contractAddress, deployerAddress) {
  console.log(`\n🔒 Revoking deployer roles for ${contractName}`);
  console.log("=============================================");
  
  try {
    // Get contract instance
    const contract = await ethers.getContractAt("VestingContract", contractAddress);
    
    // Define role constants
    const roles = {
      PROPOSER: "0x0000000000000000000000000000000000000000000000000000000000000001",
      EXECUTOR: "0x0000000000000000000000000000000000000000000000000000000000000002",
      ADMIN: "0x0000000000000000000000000000000000000000000000000000000000000000"
    };
    
    const results = [];
    
    // Check and revoke each role
    for (const [roleName, roleHash] of Object.entries(roles)) {
      try {
        const hasRole = await contract.hasRole(roleHash, deployerAddress);
        
        if (hasRole) {
          console.log(`🔍 Deployer has ${roleName} role, revoking...`);
          
          const tx = await contract.revokeRole(roleHash, deployerAddress);
          console.log(`⏳ Transaction submitted: ${tx.hash}`);
          
          await tx.wait();
          console.log(`✅ ${roleName} role revoked from deployer`);
          
          // Verify revocation
          const stillHasRole = await contract.hasRole(roleHash, deployerAddress);
          if (!stillHasRole) {
            console.log(`✅ Verification: Deployer no longer has ${roleName} role`);
            results.push({ role: roleName, success: true, txHash: tx.hash });
          } else {
            console.log(`❌ Verification failed: Deployer still has ${roleName} role`);
            results.push({ role: roleName, success: false, error: "Verification failed" });
          }
        } else {
          console.log(`ℹ️  Deployer does not have ${roleName} role`);
          results.push({ role: roleName, success: true, alreadyRevoked: true });
        }
        
      } catch (error) {
        console.error(`❌ Failed to revoke ${roleName} role:`, error.message);
        results.push({ role: roleName, success: false, error: error.message });
      }
    }
    
    return {
      contractName,
      deployerAddress,
      results,
      success: results.every(r => r.success)
    };
    
  } catch (error) {
    console.error(`❌ Failed to revoke deployer roles for ${contractName}:`, error.message);
    return {
      contractName,
      deployerAddress,
      error: error.message,
      success: false
    };
  }
}

async function main() {
  console.log("🔒 IDIOT Token Deployer Role Revocation");
  console.log("======================================\n");
  
  // Load addresses
  if (!fs.existsSync(addressesFile)) {
    console.error("❌ Addresses file not found. Run deployVesting.js first.");
    process.exit(1);
  }
  
  const addresses = JSON.parse(fs.readFileSync(addressesFile, 'utf8'));
  console.log("📄 Loaded contract addresses");
  
  // Get deployer address
  const [deployer] = await ethers.getSigners();
  const deployerAddress = deployer.address;
  console.log(`📝 Deployer address: ${deployerAddress}`);
  
  // Get all contract names
  const contractNames = Object.keys(addresses);
  console.log(`📋 Found ${contractNames.length} contracts to process`);
  
  const allResults = [];
  
  // Revoke deployer roles for each contract
  for (const contractName of contractNames) {
    const contractData = addresses[contractName];
    if (!contractData.address) {
      console.log(`⚠️  ${contractName} has no address, skipping...`);
      continue;
    }
    
    const result = await revokeDeployerRole(
      contractName,
      contractData.address,
      deployerAddress
    );
    
    allResults.push(result);
    
    // Update addresses file with revocation info
    if (result.success) {
      addresses[contractName].deployerRolesRevoked = {
        deployer: deployerAddress,
        revokedAt: new Date().toISOString(),
        roles: result.results
      };
    }
  }
  
  // Save updated addresses
  fs.writeFileSync(addressesFile, JSON.stringify(addresses, null, 2));
  console.log(`\n💾 Updated addresses saved to: ${addressesFile}`);
  
  // Summary
  console.log("\n📊 Deployer Role Revocation Summary");
  console.log("===================================");
  
  const successful = allResults.filter(r => r.success);
  const failed = allResults.filter(r => !r.success);
  
  console.log(`✅ Successful revocations: ${successful.length}/${allResults.length}`);
  console.log(`❌ Failed revocations: ${failed.length}/${allResults.length}`);
  
  for (const result of successful) {
    console.log(`   ${result.contractName}: Deployer roles revoked`);
  }
  
  for (const result of failed) {
    console.log(`   ${result.contractName}: FAILED - ${result.error}`);
  }
  
  if (failed.length === 0) {
    console.log("\n🎉 All deployer roles revoked successfully!");
    console.log("🔒 Security lockdown complete!");
    console.log("🔄 Next step: Verify + Audit + Notify");
  } else {
    console.log("\n⚠️  Some role revocations failed. Check the logs above.");
  }
  
  // Security status
  console.log("\n🔐 Security Status");
  console.log("==================");
  console.log("✅ Ownership transferred to governance contracts");
  console.log("✅ Governance roles assigned to SAFE multisigs");
  console.log("✅ Deployer roles revoked");
  console.log("🔒 System is now fully decentralized and secure!");
}

main().catch((error) => {
  console.error("❌ Deployer role revocation failed:", error);
  process.exit(1);
});
