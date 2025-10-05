/**
 * Ledger Confirmation Phase
 * Confirms ownership and signs verification metadata
 * Author: IDIOT Token Audit System
 */

import { ethers } from "ethers";
import TransportNodeHid from "@ledgerhq/hw-transport-node-hid";
import AppEth from "@ledgerhq/hw-app-eth";
import fs from "fs";

const provider = new ethers.JsonRpcProvider("https://mainnet.base.org");
const DEPLOYER_ADDRESS = "0xf123f1269Fcb1d0c6F1DCFc3EF1F68dEDDf52a5e";

async function performLedgerConfirmation() {
  console.log("🔐 Ledger Confirmation Phase");
  console.log("=============================");
  console.log("Purpose: Confirm ownership and sign verification metadata");
  console.log("Cost: Zero (no gas required for message signing)\n");

  try {
    // Connect to Ledger
    console.log("🔍 Connecting to Ledger device...");
    const transport = await TransportNodeHid.create();
    const eth = new AppEth(transport);
    const path = "44'/60'/0'/0/0";
    const addr = await eth.getAddress(path);
    
    console.log(`✅ Ledger connected: ${addr.address}`);
    
    // Verify this is the correct deployer address
    if (addr.address.toLowerCase() !== DEPLOYER_ADDRESS.toLowerCase()) {
      throw new Error(`Ledger address (${addr.address}) does not match deployer address (${DEPLOYER_ADDRESS})`);
    }
    
    console.log("✅ Deployer address confirmed");

    // Prepare verification message
    const verificationMessage = {
      timestamp: new Date().toISOString(),
      purpose: "IDIOT Token Verification Confirmation",
      contractAddress: "0xC29EF04CFFe38012dcfc1E96a2B368443f298dE1",
      network: "Base Mainnet",
      chainId: 8453,
      deployerAddress: DEPLOYER_ADDRESS,
      message: "I confirm the IDIOT Token distribution and verification data is accurate and complete."
    };

    const messageHash = ethers.keccak256(ethers.toUtf8Bytes(JSON.stringify(verificationMessage)));
    
    console.log("\n📝 Preparing verification message for signing...");
    console.log(`Message Hash: ${messageHash}`);
    console.log("This is a zero-cost message signature (no gas required)");

    // Sign the verification message
    console.log("\n🧾 Signing verification message with Ledger...");
    console.log("Please confirm the signature on your Ledger device");
    
    const signature = await eth.signPersonalMessage(path, messageHash.substring(2));
    
    console.log("✅ Message signed successfully!");
    console.log(`Signature: ${signature}`);

    // Create confirmation data
    const confirmationData = {
      ...verificationMessage,
      ledgerSignature: signature,
      ledgerAddress: addr.address,
      confirmationStatus: "CONFIRMED",
      signedAt: new Date().toISOString()
    };

    // Save confirmation data
    fs.writeFileSync("docs_final/BaseScan_Verification_Receipts/ledger_confirmation.json", JSON.stringify(confirmationData, null, 2));
    
    console.log("\n✅ Ledger Confirmation Complete!");
    console.log("📄 Confirmation data saved to docs_final/BaseScan_Verification_Receipts/ledger_confirmation.json");
    
    console.log("\n🎉 All verification phases complete!");
    console.log("Ready to generate final documentation package...");

    return confirmationData;

  } catch (error) {
    console.error("\n❌ Ledger confirmation failed:");
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

// Run confirmation
performLedgerConfirmation().catch(console.error);
