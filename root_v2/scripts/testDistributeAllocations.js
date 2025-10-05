// testDistributeAllocations.js
//
// Purpose: Distribute IDIOT tokens from CSV file to vesting wallets on Base Mainnet
// Location: /root_v2/scripts/testDistributeAllocations.js
//
// Prerequisites:
// 1. Your .env file includes PRIVATE_KEY for the token owner wallet
// 2. CSV file with allocations exists at specified path
// 3. You have sufficient IDIOT tokens in the owner wallet

const { ethers } = require("hardhat");
const fs = require("fs");
const csv = require("csv-parser");
require("dotenv").config();

async function main() {
  console.log("=== IDIOT Token Allocation Distributor ===\n");

  // --- Configuration ---
  const tokenAddress = "0xC29EF04CFFe38012dcfc1E96a2B368443f298dE1"; // Verified IDIOT Token
  const csvFilePath = "C:/idiot/IDIOT_Allocations_v1_1_2025-10-01 2146.csv"; // Update this path
  const networkName = "base";
  const provider = new ethers.providers.JsonRpcProvider("https://mainnet.base.org");

  // --- Connect signer ---
  const wallet = new ethers.Wallet(process.env.PRIVATE_KEY, provider);
  const signer = wallet.connect(provider);
  console.log(`Using signer: ${await signer.getAddress()}`);
  console.log(`Connected to network: ${networkName}`);

  // --- Load contract ---
  const abi = [
    "function transfer(address to, uint256 amount) external returns (bool)",
    "function balanceOf(address account) view returns (uint256)",
    "function decimals() view returns (uint8)",
  ];

  const token = new ethers.Contract(tokenAddress, abi, signer);

  // --- Check balance ---
  const balance = await token.balanceOf(await signer.getAddress());
  console.log(`Current owner balance: ${ethers.utils.formatUnits(balance, 18)} IDIOT`);

  // --- Read CSV allocations ---
  const allocations = [];
  
  if (!fs.existsSync(csvFilePath)) {
    console.error(`❌ CSV file not found at: ${csvFilePath}`);
    console.log("Please update the csvFilePath variable with the correct path to your allocations file.");
    process.exit(1);
  }

  console.log(`📄 Reading allocations from: ${csvFilePath}`);
  
  await new Promise((resolve, reject) => {
    fs.createReadStream(csvFilePath)
      .pipe(csv())
      .on("data", (data) => {
        if (data.address && data.amount) {
          allocations.push({
            address: data.address,
            amount: data.amount
          });
        }
      })
      .on("end", resolve)
      .on("error", reject);
  });

  console.log(`📊 Found ${allocations.length} allocations to process`);

  // --- Process each allocation ---
  let successCount = 0;
  let totalAmount = ethers.BigNumber.from(0);

  for (let i = 0; i < allocations.length; i++) {
    const { address, amount } = allocations[i];
    
    try {
      const amountWei = ethers.utils.parseUnits(amount, 18);
      totalAmount = totalAmount.add(amountWei);
      
      console.log(`\n[${i + 1}/${allocations.length}] Transferring ${amount} IDIOT to ${address}...`);
      
      const tx = await token.transfer(address, amountWei, {
        gasLimit: 100000, // Adjust gas limit as needed
      });
      
      console.log(`⏳ Transaction submitted: ${tx.hash}`);
      const receipt = await tx.wait();
      
      console.log(`✅ Success! Gas used: ${receipt.gasUsed.toString()}`);
      successCount++;
      
    } catch (error) {
      console.error(`❌ Failed to transfer to ${address}:`, error.message);
    }
  }

  console.log(`\n🎉 Distribution Complete!`);
  console.log(`✅ Successful transfers: ${successCount}/${allocations.length}`);
  console.log(`💰 Total amount distributed: ${ethers.utils.formatUnits(totalAmount, 18)} IDIOT`);
}

main().catch((error) => {
  console.error("\n❌ Error executing distribution:");
  console.error(error);
  process.exitCode = 1;
});
