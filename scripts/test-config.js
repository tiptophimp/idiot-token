// scripts/test-config.js - Test configuration without running verification
import dotenv from "dotenv";
import pkg from "hardhat";

const { ethers } = pkg;
dotenv.config();

async function testConfiguration() {
  console.log("🧪 Testing IDIOT Token Configuration");
  console.log("===================================\n");

  // Test environment variables
  console.log("🔧 Environment Variables:");
  console.log(`   PRIVATE_KEY: ${process.env.PRIVATE_KEY ? '✅ Set' : '❌ Missing'}`);
  console.log(`   BASESCAN_API_KEY: ${process.env.BASESCAN_API_KEY ? '✅ Set' : '❌ Missing'}`);
  console.log(`   DISCORD_WEBHOOK_URL: ${process.env.DISCORD_WEBHOOK_URL ? '✅ Set' : '⚠️  Not set (optional)'}`);
  console.log(`   SLACK_WEBHOOK_URL: ${process.env.SLACK_WEBHOOK_URL ? '✅ Set' : '⚠️  Not set (optional)'}`);
  console.log(`   IPFS_PROJECT_ID: ${process.env.IPFS_PROJECT_ID ? '✅ Set' : '⚠️  Not set (optional)'}`);
  console.log(`   IPFS_PROJECT_SECRET: ${process.env.IPFS_PROJECT_SECRET ? '✅ Set' : '⚠️  Not set (optional)'}`);

  // Test network connection
  console.log("\n🌐 Network Connection Test:");
  try {
    const provider = new ethers.JsonRpcProvider("https://mainnet.base.org");
    const network = await provider.getNetwork();
    console.log(`   ✅ Base Mainnet: Connected (Chain ID: ${network.chainId})`);
  } catch (error) {
    console.log(`   ❌ Base Mainnet: Connection failed - ${error.message}`);
  }

  // Test hardhat config
  console.log("\n⚙️ Hardhat Configuration:");
  try {
    // Import the config dynamically
    const configModule = await import('../hardhat.config.cjs');
    const config = configModule.default || configModule;
    console.log(`   ✅ Config loaded successfully`);
    console.log(`   ✅ Base network configured: ${config.networks?.base ? 'Yes' : 'No'}`);
    console.log(`   ✅ Etherscan API key configured: ${config.etherscan?.apiKey?.base ? 'Yes' : 'No'}`);
    console.log(`   ✅ Custom chains configured: ${config.etherscan?.customChains ? 'Yes' : 'No'}`);
  } catch (error) {
    console.log(`   ❌ Config error: ${error.message}`);
  }

  console.log("\n📊 Configuration Summary:");
  const requiredVars = ['PRIVATE_KEY', 'BASESCAN_API_KEY'];
  const missingRequired = requiredVars.filter(varName => !process.env[varName] || process.env[varName].includes('YOUR_'));

  if (missingRequired.length === 0) {
    console.log("   🎉 All required configuration is present!");
    console.log("   🚀 Ready to run verification workflow");
  } else {
    console.log(`   ⚠️  Missing required variables: ${missingRequired.join(', ')}`);
    console.log("   📝 Please configure these in your .env file or GitHub Secrets");
  }

  console.log("\n💡 Next Steps:");
  console.log("   1. Add missing environment variables to .env (local) or GitHub Secrets (CI)");
  console.log("   2. Run: npx hardhat run scripts/verifyAuditNotify.js --network base");
  console.log("   3. Or push to main branch to trigger GitHub Actions workflow");
}

testConfiguration().catch(console.error);
