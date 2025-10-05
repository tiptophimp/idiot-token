const { ethers } = require("hardhat");

async function main() {
  const contractAddress = process.argv[2];
  
  if (!contractAddress) {
    console.error("Please provide contract address as argument");
    console.log("Usage: npx hardhat run scripts/verifyContracts.js --network base <contract_address>");
    process.exit(1);
  }

  console.log(`Verifying contract at address: ${contractAddress}`);
  
  try {
    await hre.run("verify:verify", {
      address: contractAddress,
      constructorArguments: [],
    });
    console.log("✅ Contract verified successfully!");
  } catch (error) {
    if (error.message.toLowerCase().includes("already verified")) {
      console.log("✅ Contract already verified!");
    } else {
      console.error("❌ Verification failed:", error.message);
    }
  }
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
