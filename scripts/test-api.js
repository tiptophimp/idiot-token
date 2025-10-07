// scripts/test-api.js - Test BaseScan API key
import dotenv from "dotenv";
import fetch from "node-fetch";

dotenv.config();

async function testBaseScanAPI() {
  console.log("🧪 Testing BaseScan API Key");
  console.log("===========================\n");

  const apiKey = process.env.BASESCAN_API_KEY;
  
  if (!apiKey) {
    console.log("❌ BASESCAN_API_KEY not found in environment");
    console.log("💡 Make sure you've added it to GitHub Secrets");
    return;
  }

  console.log(`✅ API Key found: ${apiKey.substring(0, 8)}...`);

  // Test with a simple contract lookup
  const testAddress = "0x6AD03686ab6c3bA2c77992995E4879c62dE88996"; // Reserve contract
  const url = `https://api.basescan.org/api?module=contract&action=getsourcecode&address=${testAddress}&apikey=${apiKey}`;

  try {
    console.log("🔍 Testing API connection...");
    const response = await fetch(url);
    const data = await response.json();

    if (data.status === "1") {
      console.log("✅ API Key is working!");
      console.log(`📊 Contract found: ${data.result[0].ContractName || 'Unknown'}`);
      console.log(`🔗 Source code: ${data.result[0].SourceCode ? 'Available' : 'Not verified'}`);
    } else {
      console.log("❌ API Error:", data.message);
      if (data.message.includes("Invalid API Key")) {
        console.log("💡 Your API key is invalid. Please check it in GitHub Secrets");
      } else if (data.message.includes("Max rate limit reached")) {
        console.log("💡 Rate limit exceeded. Wait a moment and try again");
      }
    }
  } catch (error) {
    console.log("❌ Network error:", error.message);
    console.log("💡 Check your internet connection");
  }
}

testBaseScanAPI().catch(console.error);
