// scripts/test-github-api.js - Test API key in GitHub Actions
import fetch from "node-fetch";

async function testAPI() {
  console.log("🧪 Testing BaseScan API in GitHub Actions");
  console.log("==========================================\n");

  const apiKey = process.env.BASESCAN_API_KEY;
  
  if (!apiKey) {
    console.log("❌ BASESCAN_API_KEY not found");
    console.log("💡 Add BASESCAN_API_KEY to GitHub Secrets");
    process.exit(1);
  }

  console.log(`✅ API Key found: ${apiKey.substring(0, 8)}...`);

  // Test API with a simple request
  const testAddress = "0x6AD03686ab6c3bA2c77992995E4879c62dE88996";
  const url = `https://api.basescan.org/api?module=contract&action=getsourcecode&address=${testAddress}&apikey=${apiKey}`;

  try {
    console.log("🔍 Testing API connection...");
    const response = await fetch(url);
    const data = await response.json();

    console.log(`📊 API Response Status: ${data.status}`);
    console.log(`📊 API Message: ${data.message}`);

    if (data.status === "1") {
      console.log("✅ API Key is working!");
      console.log(`📊 Contract: ${data.result[0].ContractName || 'Unknown'}`);
      console.log(`🔗 Verified: ${data.result[0].SourceCode ? 'Yes' : 'No'}`);
    } else {
      console.log("❌ API Error:", data.message);
      
      if (data.message.includes("Invalid API Key")) {
        console.log("💡 Your API key is invalid");
        console.log("💡 Get a new key from: https://basescan.org/apis");
      } else if (data.message.includes("Max rate limit")) {
        console.log("💡 Rate limit exceeded - wait and try again");
      } else {
        console.log("💡 Unknown API error - check your key");
      }
    }
  } catch (error) {
    console.log("❌ Network error:", error.message);
  }
}

testAPI().catch(console.error);
