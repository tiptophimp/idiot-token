// scripts/assignGovernanceRoles.js - Assign DAO governance roles
import dotenv from "dotenv";
import pkg from "hardhat";
import fs from "fs";

const { ethers } = pkg;
dotenv.config();

const addressesFile = "./deployment/addresses.json";

async function assignGovernanceRole(contractName, contractAddress, role, account) {
  console.log(`\n🔐 Assigning ${role} role for ${contractName}`);
  console.log("=============================================");
  
  try {
    // Get contract instance
    const contract = await ethers.getContractAt("VestingContract", contractAddress);
    
    // Define role constants (these would be from your governance contract)
    const roles = {
      PROPOSER: "0x0000000000000000000000000000000000000000000000000000000000000001",
      EXECUTOR: "0x0000000000000000000000000000000000000000000000000000000000000002",
      ADMIN: "0x0000000000000000000000000000000000000000000000000000000000000000"
    };
    
    const roleHash = roles[role];
    if (!roleHash) {
      throw new Error(`Unknown role: ${role}`);
    }
    
    // Check if account already has role
    const hasRole = await contract.hasRole(roleHash, account);
    if (hasRole) {
      console.log(`ℹ️  ${account} already has ${role} role`);
      return { success: true, alreadyAssigned: true };
    }
    
    // Grant role
    const tx = await contract.grantRole(roleHash, account);
    console.log(`⏳ Transaction submitted: ${tx.hash}`);
    
    await tx.wait();
    console.log(`✅ ${role} role granted to ${account}`);
    
    // Verify role assignment
    const verifiedRole = await contract.hasRole(roleHash, account);
    if (verifiedRole) {
      console.log(`✅ Verification: ${account} now has ${role} role`);
    } else {
      console.log(`❌ Verification failed: ${account} does not have ${role} role`);
    }
    
    return {
      contractName,
      role,
      account,
      txHash: tx.hash,
      success: true
    };
    
  } catch (error) {
    console.error(`❌ Failed to assign ${role} role for ${contractName}:`, error.message);
    return {
      contractName,
      role,
      account,
      error: error.message,
      success: false
    };
  }
}

async function main() {
  console.log("🔐 IDIOT Token Governance Role Assignment");
  console.log("========================================\n");
  
  // Load addresses
  if (!fs.existsSync(addressesFile)) {
    console.error("❌ Addresses file not found. Run deployVesting.js first.");
    process.exit(1);
  }
  
  const addresses = JSON.parse(fs.readFileSync(addressesFile, 'utf8'));
  console.log("📄 Loaded contract addresses");
  
  // Define governance role assignments
  const governanceAssignments = [
    // TR-SAFE gets proposer and executor roles for Reserve, Treasury, Team
    { name: "Reserve", roles: ["PROPOSER", "EXECUTOR"], account: "0xTR_SAFE" },
    { name: "Treasury", roles: ["PROPOSER", "EXECUTOR"], account: "0xTR_SAFE" },
    { name: "Team", roles: ["PROPOSER", "EXECUTOR"], account: "0xTR_SAFE" },
    // OPS-SAFE gets proposer and executor roles for Community
    { name: "Community", roles: ["PROPOSER", "EXECUTOR"], account: "0xOPS_SAFE" },
  ];
  
  const results = [];
  
  // Assign roles for each contract
  for (const assignment of governanceAssignments) {
    const contractData = addresses[assignment.name];
    if (!contractData) {
      console.log(`⚠️  ${assignment.name} not found in addresses file, skipping...`);
      continue;
    }
    
    for (const role of assignment.roles) {
      const result = await assignGovernanceRole(
        assignment.name,
        contractData.address,
        role,
        assignment.account
      );
      
      results.push(result);
      
      // Update addresses file with role assignments
      if (result.success && !result.alreadyAssigned) {
        if (!addresses[assignment.name].governanceRoles) {
          addresses[assignment.name].governanceRoles = {};
        }
        addresses[assignment.name].governanceRoles[role] = {
          account: assignment.account,
          assignedAt: new Date().toISOString(),
          txHash: result.txHash
        };
      }
    }
  }
  
  // Save updated addresses
  fs.writeFileSync(addressesFile, JSON.stringify(addresses, null, 2));
  console.log(`\n💾 Updated addresses saved to: ${addressesFile}`);
  
  // Summary
  console.log("\n📊 Governance Role Assignment Summary");
  console.log("====================================");
  
  const successful = results.filter(r => r.success);
  const failed = results.filter(r => !r.success);
  const alreadyAssigned = results.filter(r => r.alreadyAssigned);
  
  console.log(`✅ Successful assignments: ${successful.length}`);
  console.log(`ℹ️  Already assigned: ${alreadyAssigned.length}`);
  console.log(`❌ Failed assignments: ${failed.length}`);
  
  for (const result of successful) {
    console.log(`   ${result.contractName} ${result.role}: ${result.account}`);
  }
  
  for (const result of alreadyAssigned) {
    console.log(`   ${result.contractName} ${result.role}: Already assigned`);
  }
  
  for (const result of failed) {
    console.log(`   ${result.contractName} ${result.role}: FAILED - ${result.error}`);
  }
  
  if (failed.length === 0) {
    console.log("\n🎉 All governance roles assigned successfully!");
    console.log("🔄 Next step: Revoke deployer roles");
  } else {
    console.log("\n⚠️  Some role assignments failed. Check the logs above.");
  }
}

main().catch((error) => {
  console.error("❌ Governance role assignment failed:", error);
  process.exit(1);
});
