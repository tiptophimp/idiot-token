import { ethers } from "ethers";
import fs from "fs";

const provider = new ethers.JsonRpcProvider("https://mainnet.base.org");
const tokenAddress = "0xC29EF04CFFe38012dcfc1E96a2B368443f298dE1";
const abi = [
  "function balanceOf(address) view returns (uint256)",
  "function transfer(address to, uint256 amount) returns (bool)"
];

const token = new ethers.Contract(tokenAddress, abi, provider);

const addresses = {
  deployer: "0xf123f1269Fcb1d0c6F1DCFc3EF1F68dEDDf52a5e",
  lpHot: "0xAC95d0B5603C7212a690bd089BAD472473496374",
  opsHot: "0x721d2adcCf634f4185edE152ee98cA836CF22EA6",
  team: "0x5817DcCb35cd3a67520e5bda1ebc413cf097a8ee",
  vest1: "0x6AD03686ab6c3bA2c77992995E4879c62dE88996",
  vest3: "0x9d466e39799fec7204f40133ecc0beb115813c13"
};

async function checkBalances() {
  console.log(`🔍 Checking IDIOT token balances...`);
  console.log(`Token Address: ${tokenAddress}`);
  console.log(`Network: Base Mainnet\n`);
  
  let results = [];
  let totalBalance = ethers.BigNumber.from(0);
  
  for (const [name, addr] of Object.entries(addresses)) {
    try {
      const bal = await token.balanceOf(addr);
      const formatted = ethers.formatUnits(bal, 18);
      const balanceBN = ethers.BigNumber.from(bal);
      totalBalance = totalBalance.add(balanceBN);
      
      results.push({ 
        name, 
        address: addr, 
        balance: formatted,
        balanceWei: bal.toString()
      });
      
      console.log(`${name.padEnd(8)}: ${formatted.padStart(20)} IDIOT`);
    } catch (error) {
      console.error(`❌ Error checking ${name} (${addr}):`, error.message);
      results.push({ 
        name, 
        address: addr, 
        balance: "ERROR",
        balanceWei: "0",
        error: error.message
      });
    }
  }
  
  console.log(`\n📊 Total Balance Checked: ${ethers.formatUnits(totalBalance, 18)} IDIOT`);
  
  // Save results to file
  const auditData = {
    timestamp: new Date().toISOString(),
    tokenAddress: tokenAddress,
    network: "Base Mainnet",
    totalBalanceChecked: ethers.formatUnits(totalBalance, 18),
    wallets: results
  };
  
  fs.writeFileSync("balances.json", JSON.stringify(auditData, null, 2));
  console.log("\n✅ Balance audit saved to balances.json");
  
  // Check for Vesting Wallet 3 specifically
  const vest3Result = results.find(r => r.name === "vest3");
  if (vest3Result && vest3Result.balance === "0.0") {
    console.log("\n⚠️  VESTING WALLET 3 HAS ZERO BALANCE - CORRECTION NEEDED");
    console.log("   Run: npx hardhat run scripts/fixVesting3.js --network base");
  } else if (vest3Result) {
    console.log(`\n✅ Vesting Wallet 3 balance: ${vest3Result.balance} IDIOT`);
  }
}

checkBalances().catch(console.error);
