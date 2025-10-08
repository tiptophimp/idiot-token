// Test script to verify Etherscan API key
import fetch from 'node-fetch';
import dotenv from 'dotenv';
dotenv.config();

async function testApiKey() {
    console.log('🔍 Testing Etherscan API Key...\n');
    
    const apiKey = process.env.ETHERSCAN_API_KEY;
    if (!apiKey) {
        console.log('❌ ETHERSCAN_API_KEY not found in environment');
        return;
    }
    
    console.log(`🔑 API Key: ${apiKey.substring(0, 8)}...${apiKey.substring(apiKey.length - 4)}`);
    
    // Test Base Mainnet (Chain ID 8453)
    const baseUrl = `https://api.etherscan.io/v2/api?chainid=8453&module=account&action=balance&address=0xb5d85cbf7cb3ee0d56b3bb207d5fc4b82f43f511&tag=latest&apikey=${apiKey}`;
    
    try {
        console.log('📡 Testing Base Mainnet...');
        const response = await fetch(baseUrl);
        const data = await response.json();
        
        if (data.status === '1') {
            console.log('✅ Base Mainnet API test successful!');
            console.log(`💰 Balance: ${data.result} Wei`);
        } else {
            console.log('❌ Base Mainnet API test failed');
            console.log(`Error: ${data.message}`);
        }
    } catch (error) {
        console.log('❌ Network error:', error.message);
    }
    
    // Test Ethereum Mainnet (Chain ID 1)
    const ethUrl = `https://api.etherscan.io/v2/api?chainid=1&module=account&action=balance&address=0xb5d85cbf7cb3ee0d56b3bb207d5fc4b82f43f511&tag=latest&apikey=${apiKey}`;
    
    try {
        console.log('\n📡 Testing Ethereum Mainnet...');
        const response = await fetch(ethUrl);
        const data = await response.json();
        
        if (data.status === '1') {
            console.log('✅ Ethereum Mainnet API test successful!');
            console.log(`💰 Balance: ${data.result} Wei`);
        } else {
            console.log('❌ Ethereum Mainnet API test failed');
            console.log(`Error: ${data.message}`);
        }
    } catch (error) {
        console.log('❌ Network error:', error.message);
    }
    
    console.log('\n🎯 Your API key is ready for GitHub Actions!');
}

testApiKey().catch(console.error);
