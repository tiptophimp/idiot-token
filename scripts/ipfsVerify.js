// scripts/ipfsVerify.js - IPFS CID verification and integrity check
const fs = require("fs");
const { create } = require("ipfs-http-client");

const auditFilePath = "./audit/vesting_verification_log.md";
const ipfs = create({ url: "https://ipfs.infura.io:5001/api/v0" });

async function verifyIPFSIntegrity() {
  console.log("🔍 IPFS Audit Integrity Verification");
  console.log("=====================================\n");

  // Check if audit file exists
  if (!fs.existsSync(auditFilePath)) {
    console.error("❌ Audit file not found:", auditFilePath);
    console.log("💡 Run the main verification task first to generate the audit log");
    process.exit(1);
  }

  try {
    // Read the current audit file
    const file = fs.readFileSync(auditFilePath);
    console.log(`📄 Reading audit file: ${auditFilePath}`);
    console.log(`📊 File size: ${file.length} bytes\n`);

    // Upload to IPFS and get CID
    console.log("🌐 Uploading to IPFS...");
    const result = await ipfs.add(file);
    const currentCID = result.path;
    
    console.log(`✅ Current CID: ${currentCID}`);
    console.log(`🔗 IPFS URL: https://ipfs.io/ipfs/${currentCID}`);
    console.log(`🔗 Gateway URL: https://gateway.pinata.cloud/ipfs/${currentCID}`);

    // Check if there's a previous CID stored
    const cidFile = "./audit/last_ipfs_cid.txt";
    if (fs.existsSync(cidFile)) {
      const previousCID = fs.readFileSync(cidFile, 'utf8').trim();
      console.log(`\n📋 Previous CID: ${previousCID}`);
      
      if (currentCID === previousCID) {
        console.log("✅ Integrity Check: PASSED");
        console.log("🔒 Audit file has not changed - CID matches previous upload");
      } else {
        console.log("⚠️  Integrity Check: CHANGED");
        console.log("📝 Audit file has been modified since last IPFS upload");
        console.log("💡 This is normal if you've run verification again");
      }
    } else {
      console.log("\n📋 No previous CID found - this is the first IPFS upload");
    }

    // Store current CID for future comparison
    fs.writeFileSync(cidFile, currentCID);
    console.log(`\n💾 CID saved to: ${cidFile}`);

    // Additional verification - check file content hash
    const crypto = require("crypto");
    const fileHash = crypto.createHash("sha256").update(file).digest("hex");
    console.log(`🔐 File SHA256: ${fileHash}`);

    // Try to retrieve from IPFS to verify it's accessible
    console.log("\n🔄 Verifying IPFS accessibility...");
    try {
      const retrieved = await ipfs.cat(currentCID);
      const retrievedHash = crypto.createHash("sha256").update(retrieved).digest("hex");
      
      if (fileHash === retrievedHash) {
        console.log("✅ IPFS Retrieval: SUCCESS");
        console.log("🌐 File is accessible and matches original content");
      } else {
        console.log("❌ IPFS Retrieval: MISMATCH");
        console.log("⚠️  Retrieved content doesn't match original file");
      }
    } catch (retrieveError) {
      console.log("⚠️  IPFS Retrieval: UNAVAILABLE");
      console.log("💡 This is normal - IPFS content may take time to propagate");
      console.log(`   Error: ${retrieveError.message}`);
    }

    console.log("\n🎯 Verification Complete!");
    console.log("📊 Summary:");
    console.log(`   - Current CID: ${currentCID}`);
    console.log(`   - File Size: ${file.length} bytes`);
    console.log(`   - SHA256: ${fileHash}`);
    console.log(`   - IPFS URL: https://ipfs.io/ipfs/${currentCID}`);

  } catch (error) {
    console.error("❌ IPFS verification failed:", error.message);
    
    if (error.message.includes("ECONNREFUSED")) {
      console.log("💡 IPFS gateway may be down. Try again later.");
    } else if (error.message.includes("timeout")) {
      console.log("💡 IPFS upload timed out. Check your internet connection.");
    } else {
      console.log("💡 Check your IPFS configuration and try again.");
    }
    
    process.exit(1);
  }
}

// Run verification
verifyIPFSIntegrity().catch((error) => {
  console.error("❌ Unexpected error:", error);
  process.exit(1);
});
