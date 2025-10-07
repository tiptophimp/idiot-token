#!/usr/bin/env node

// scripts/test_etherscan_v2.js
// Test Etherscan V2 API with multiple chains

const fetch = require('node-fetch');

async function testEtherscanV2() {
  console.log('🔍 Testing Etherscan V2 API Migration\n');

  // Test addresses and chains
  const testCases = [
    {
      name: 'Base Mainnet',
      chainId: 8453,
      address: '0xb5d85cbf7cb3ee0d56b3bb207d5fc4b82f43f511', // Example address
      expectedExplorer: 'https://basescan.org'
    },
    {
      name: 'Base Sepolia',
      chainId: 84532,
      address: '0xb5d85cbf7cb3ee0d56b3bb207d5fc4b82f43f511',
      expectedExplorer: 'https://sepolia.basescan.org'
    },
    {
      name: 'Ethereum Mainnet',
      chainId: 1,
      address: '0xb5d85cbf7cb3ee0d56b3bb207d5fc4b82f43f511',
      expectedExplorer: 'https://etherscan.io'
    }
  ];

  const apiKey = process.env.ETHERSCAN_API_KEY || 'YourApiKeyToken';
  
  if (apiKey === 'YourApiKeyToken') {
    console.log('⚠️  Warning: Using placeholder API key. Set ETHERSCAN_API_KEY environment variable for real testing.');
  }

  for (const testCase of testCases) {
    console.log(`\n📡 Testing ${testCase.name} (Chain ID: ${testCase.chainId})`);
    
    try {
      const url = `https://api.etherscan.io/v2/api?chainid=${testCase.chainId}&module=account&action=balance&address=${testCase.address}&tag=latest&apikey=${apiKey}`;
      
      console.log(`  URL: ${url.replace(apiKey, '***')}`);
      
      const response = await fetch(url);
      const data = await response.json();
      
      if (data.status === '1') {
        console.log(`  ✅ Success: ${data.result} wei`);
        console.log(`  📊 Explorer: ${testCase.expectedExplorer}/address/${testCase.address}`);
      } else {
        console.log(`  ❌ Error: ${data.message || 'Unknown error'}`);
        if (data.result) {
          console.log(`  📝 Result: ${data.result}`);
        }
      }
      
    } catch (error) {
      console.log(`  ❌ Network Error: ${error.message}`);
    }
  }

  console.log('\n🔧 V2 API Migration Benefits:');
  console.log('  - Single API key for all chains');
  console.log('  - Unified endpoint: https://api.etherscan.io/v2/api');
  console.log('  - Chain-specific via chainid parameter');
  console.log('  - Simplified configuration');

  console.log('\n📋 Configuration Update:');
  console.log('  - Updated hardhat.config.cjs with V2 URLs');
  console.log('  - Added chainid parameter to apiURL');
  console.log('  - Maintained browserURL for each chain');
}

// Run the test
testEtherscanV2().catch(console.error);
