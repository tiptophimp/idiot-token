import { ethers } from "ethers";
import dotenv from "dotenv";
dotenv.config();

const provider = new ethers.JsonRpcProvider("https://mainnet.base.org");
const wallet = new ethers.Wallet(process.env.PRIVATE_KEY, provider);
const token = new ethers.Contract(
  "0xC29EF04CFFe38012dcfc1E96a2B368443f298dE1",
  ["function transfer(address to, uint256 amount) returns (bool)"],
  wallet
);

async function main() {
  console.log("🔧 Vesting Wallet 3 Correction Script");
  console.log("=====================================\n");
  
  const vestingWallet3 = "0x9d466e39799fec7204f40133ecc0beb115813c13";
  const amount = ethers.parseUnits("100000000", 18); // 100,000,000 IDIOT
  
  console.log(`From: ${await wallet.getAddress()}`);
  console.log(`To: ${vestingWallet3}`);
  console.log(`Amount: 100,000,000 IDIOT`);
  console.log(`Network: Base Mainnet\n`);
  
  try {
    // Check current balance of Vesting Wallet 3
    const currentBalance = await token.balanceOf(vestingWallet3);
    console.log(`Current Vesting Wallet 3 balance: ${ethers.formatUnits(currentBalance, 18)} IDIOT`);
    
    if (currentBalance > 0) {
      console.log("⚠️  Vesting Wallet 3 already has tokens. Skipping transfer.");
      return;
    }
    
    console.log("🚀 Sending 100,000,000 IDIOT to Vesting Wallet 3...");
    
    const tx = await token.transfer(vestingWallet3, amount, {
      gasLimit: 100000
    });
    
    console.log(`⏳ Transaction submitted: ${tx.hash}`);
    console.log("⏳ Waiting for confirmation...");
    
    const receipt = await tx.wait();
    
    console.log("\n✅ TRANSFER SUCCESSFUL!");
    console.log(`Transaction Hash: ${receipt.transactionHash}`);
    console.log(`Block Number: ${receipt.blockNumber}`);
    console.log(`Gas Used: ${receipt.gasUsed.toString()}`);
    
    // Verify the transfer
    const newBalance = await token.balanceOf(vestingWallet3);
    console.log(`\n📊 New Vesting Wallet 3 balance: ${ethers.formatUnits(newBalance, 18)} IDIOT`);
    
  } catch (error) {
    console.error("\n❌ TRANSFER FAILED:");
    console.error(error.message);
    process.exit(1);
  }
}

main().catch(console.error);
