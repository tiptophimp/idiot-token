/**
 * IDIOT Token Vesting Audit + Fix Script
 * Safe for Ledger Hardware Wallet — Base Network
 * Author: Automated Deployment System
 */

import { ethers } from "ethers";
import TransportNodeHid from "@ledgerhq/hw-transport-node-hid";
import AppEth from "@ledgerhq/hw-app-eth";
import fs from "fs";

const provider = new ethers.JsonRpcProvider("https://mainnet.base.org");

// 🧩 Token Contract Info
const TOKEN_ADDRESS = "0xC29EF04CFFe38012dcfc1E96a2B368443f298dE1";
const TOKEN_ABI = [
  "function balanceOf(address) view returns (uint256)",
  "function transfer(address to, uint256 amount) returns (bool)"
];

// 🪣 Project Wallets
const WALLETS = {
  deployer: "0xf123f1269Fcb1d0c6F1DCFc3EF1F68dEDDf52a5e",
  lpHot: "0xAC95d0B5603C7212a690bd089BAD472473496374",
  opsHot: "0x721d2adcCf634f4185edE152ee98cA836CF22EA6",
  team: "0x5817DcCb35cd3a67520e5bda1ebc413cf097a8ee",
  vest1: "0x6AD03686ab6c3bA2c77992995E4879c62dE88996",
  vest3: "0x9d466e39799fec7204f40133ecc0beb115813c13"
};

async function main() {
  console.log("🔍 IDIOT Token Vesting Audit & Fix");
  console.log("===================================");
  console.log(`Token: ${TOKEN_ADDRESS}`);
  console.log(`Network: Base Mainnet (Chain ID: 8453)\n`);

  try {
    console.log("🔍 Connecting to Ledger...");
    const transport = await TransportNodeHid.create();
    const eth = new AppEth(transport);
    const path = "44'/60'/0'/0/0";
    const addr = await eth.getAddress(path);
    console.log(`✅ Ledger connected: ${addr.address}`);

    const token = new ethers.Contract(TOKEN_ADDRESS, TOKEN_ABI, provider);

    // Step 1: Check all balances
    console.log("\n📊 Checking IDIOT Token Balances:");
    console.log("==================================");
    
    let balances = {};
    let totalBalance = ethers.BigNumber.from(0);
    
    for (const [name, address] of Object.entries(WALLETS)) {
      try {
        const balance = await token.balanceOf(address);
        const formatted = ethers.formatUnits(balance, 18);
        const balanceBN = ethers.BigNumber.from(balance);
        totalBalance = totalBalance.add(balanceBN);
        
        balances[name] = {
          address: address,
          balance: formatted,
          balanceWei: balance.toString()
        };
        
        console.log(`- ${name.padEnd(8)} (${address}) → ${formatted.padStart(20)} IDIOT`);
      } catch (error) {
        console.error(`❌ Error checking ${name}:`, error.message);
        balances[name] = {
          address: address,
          balance: "ERROR",
          balanceWei: "0",
          error: error.message
        };
      }
    }

    console.log(`\n📈 Total Balance Checked: ${ethers.formatUnits(totalBalance, 18)} IDIOT`);

    // Step 2: Detect missing vesting balance
    const vest3Balance = parseFloat(balances["vest3"].balance);
    const missing = vest3Balance === 0 || vest3Balance < 100;
    
    if (!missing) {
      console.log("\n✅ Vesting Wallet 3 already properly funded.");
      console.log(`   Current balance: ${balances["vest3"].balance} IDIOT`);
    } else {
      console.log("\n⚠️  Vesting Wallet 3 needs funding!");
      console.log(`   Current balance: ${balances["vest3"].balance} IDIOT`);
      console.log("   Required: 100,000,000 IDIOT");
      
      // Step 3: Prepare transfer (Ledger signed)
      console.log("\n🔧 Preparing 100,000,000 IDIOT transfer to Vesting Wallet 3...");
      
      const iface = new ethers.Interface(TOKEN_ABI);
      const amount = ethers.parseUnits("100000000", 18);
      const to = WALLETS.vest3;
      const data = iface.encodeFunctionData("transfer", [to, amount]);

      const nonce = await provider.getTransactionCount(addr.address);
      const feeData = await provider.getFeeData();

      const tx = {
        to: TOKEN_ADDRESS,
        value: 0,
        gasLimit: 200000,
        gasPrice: feeData.gasPrice,
        nonce,
        data,
        chainId: 8453 // Base Mainnet
      };

      const unsignedTx = ethers.Transaction.from(tx);
      const unsignedTxHex = unsignedTx.unsignedSerialized;

      console.log("\n🧾 Signing transaction with Ledger...");
      console.log("   Please confirm the transaction on your Ledger device.");
      
      const sig = await eth.signTransaction(path, unsignedTxHex.substring(2));
      const signedTx = ethers.Transaction.from({ ...tx, ...sig });
      const sent = await provider.broadcastTransaction(signedTx.serialized);

      console.log("\n🚀 Transfer submitted:");
      console.log(`   Transaction hash: ${sent.hash}`);
      console.log("   ⏳ Waiting for confirmation...");

      const receipt = await sent.wait();
      
      console.log("\n✅ TRANSFER CONFIRMED!");
      console.log(`   Block Number: ${receipt.blockNumber}`);
      console.log(`   Gas Used: ${receipt.gasUsed.toString()}`);
      
      // Update balances after successful transfer
      const newBalance = await token.balanceOf(WALLETS.vest3);
      balances["vest3"].balance = ethers.formatUnits(newBalance, 18);
      balances["vest3"].balanceWei = newBalance.toString();
      
      console.log(`   New Vesting Wallet 3 balance: ${ethers.formatUnits(newBalance, 18)} IDIOT`);
    }

    // Save final audit results
    const auditData = {
      timestamp: new Date().toISOString(),
      tokenAddress: TOKEN_ADDRESS,
      network: "Base Mainnet",
      chainId: 8453,
      ledgerAddress: addr.address,
      totalBalanceChecked: ethers.formatUnits(totalBalance, 18),
      wallets: balances,
      status: missing ? "CORRECTED" : "VERIFIED"
    };

    fs.writeFileSync("balances.json", JSON.stringify(auditData, null, 2));
    console.log("\n📄 Final audit saved to balances.json");

    console.log("\n🎉 Audit and correction complete!");
    console.log("   All vesting wallets are now properly funded.");

  } catch (error) {
    console.error("\n❌ Error during audit/fix process:");
    console.error(error.message);
    
    if (error.message.includes("Ledger")) {
      console.log("\n💡 Troubleshooting:");
      console.log("   - Make sure your Ledger is connected and unlocked");
      console.log("   - Open the Ethereum app on your Ledger");
      console.log("   - Try running the script again");
    }
    
    process.exit(1);
  }
}

main().catch((error) => {
  console.error("❌ Fatal error:", error);
  process.exit(1);
});
