// scripts/transferOwnership.js - Transfer ownership to governance contracts
import dotenv from "dotenv";
import pkg from "hardhat";
import fs from "fs";

const { ethers } = pkg;
dotenv.config();

const addressesFile = "./deployment/addresses.json";

async function transferOwnership(contractName, contractAddress, newOwner) {
  console.log(`\n🔄 Transferring ${contractName} ownership`);
  console.log("=====================================");
  
  try {
    // Get contract instance
    const contract = await ethers.getContractAt("VestingContract", contractAddress);
    
    // Get current owner
    const currentOwner = await contract.owner();
    console.log(`📝 Current owner: ${currentOwner}`);
    console.log(`🎯 New owner: ${newOwner}`);
    
    // Transfer ownership
    const tx = await contract.transferOwnership(newOwner);
    console.log(`⏳ Transaction submitted: ${tx.hash}`);
    
    await tx.wait();
    console.log(`✅ Ownership transferred successfully!`);
    
    // Verify transfer
    const verifiedOwner = await contract.owner();
    if (verifiedOwner.toLowerCase() === newOwner.toLowerCase()) {
      console.log(`✅ Verification: Owner is now ${verifiedOwner}`);
    } else {
      console.log(`❌ Verification failed: Owner is still ${verifiedOwner}`);
    }
    
    return {
      contractName,
      contractAddress,
      oldOwner: currentOwner,
      newOwner: verifiedOwner,
      txHash: tx.hash,
      success: true
    };
    
  } catch (error) {
    console.error(`❌ Failed to transfer ${contractName} ownership:`, error.message);
    return {
      contractName,
      contractAddress,
      error: error.message,
      success: false
    };
  }
}

async function main() {
  console.log("🔄 IDIOT Token Ownership Transfer");
  console.log("================================\n");
  
  // Load addresses
  if (!fs.existsSync(addressesFile)) {
    console.error("❌ Addresses file not found. Run deployVesting.js first.");
    process.exit(1);
  }
  
  const addresses = JSON.parse(fs.readFileSync(addressesFile, 'utf8'));
  console.log("📄 Loaded contract addresses");
  
  // Define ownership transfers
  const ownershipTransfers = [
    { name: "Reserve", newOwner: "0xTR_SAFE" },
    { name: "Treasury", newOwner: "0xTR_SAFE" },
    { name: "Team", newOwner: "0xTR_SAFE" },
    { name: "Community", newOwner: "0xOPS_SAFE" },
  ];
  
  const results = [];
  
  // Transfer ownership for each contract
  for (const transfer of ownershipTransfers) {
    const contractData = addresses[transfer.name];
    if (!contractData) {
      console.log(`⚠️  ${transfer.name} not found in addresses file, skipping...`);
      continue;
    }
    
    const result = await transferOwnership(
      transfer.name,
      contractData.address,
      transfer.newOwner
    );
    
    results.push(result);
    
    // Update addresses file with new owner
    if (result.success) {
      addresses[transfer.name].owner = result.newOwner;
      addresses[transfer.name].ownershipTransferredAt = new Date().toISOString();
      addresses[transfer.name].ownershipTxHash = result.txHash;
    }
  }
  
  // Save updated addresses
  fs.writeFileSync(addressesFile, JSON.stringify(addresses, null, 2));
  console.log(`\n💾 Updated addresses saved to: ${addressesFile}`);
  
  // Summary
  console.log("\n📊 Ownership Transfer Summary");
  console.log("============================");
  
  const successful = results.filter(r => r.success);
  const failed = results.filter(r => !r.success);
  
  console.log(`✅ Successful transfers: ${successful.length}/${results.length}`);
  console.log(`❌ Failed transfers: ${failed.length}/${results.length}`);
  
  for (const result of successful) {
    console.log(`   ${result.contractName}: ${result.oldOwner} → ${result.newOwner}`);
  }
  
  for (const result of failed) {
    console.log(`   ${result.contractName}: FAILED - ${result.error}`);
  }
  
  if (successful.length === results.length) {
    console.log("\n🎉 All ownership transfers completed successfully!");
    console.log("🔄 Next step: Assign governance roles");
  } else {
    console.log("\n⚠️  Some ownership transfers failed. Check the logs above.");
  }
}

main().catch((error) => {
  console.error("❌ Ownership transfer failed:", error);
  process.exit(1);
});
