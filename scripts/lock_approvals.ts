import pkg from "hardhat";
const { ethers } = pkg;

const WETH = "0x4200000000000000000000000000000000000006";
const IDIOT = "0xC29EF04CFFe38012dcfc1E96a2B368443f298dE1";
const NFPM = "0x03a520b32C04BF3bEEf7BEb72E919cf822Ed34f1";

const ERC20_ABI = [
  "function allowance(address,address) view returns (uint256)",
  "function approve(address,uint256) returns (bool)"
];

async function main() {
  const [signer] = await ethers.getSigners();
  const owner = await signer.getAddress();

  console.log("🔒 Locking ERC20 Approvals to NFPM");
  console.log("==================================");
  console.log(`Owner: ${owner}`);
  console.log(`NFPM: ${NFPM}`);
  console.log("");

  // Check current allowances
  const wethContract = new ethers.Contract(WETH, ERC20_ABI, signer);
  const idiotContract = new ethers.Contract(IDIOT, ERC20_ABI, signer);

  const wethAllowance = await wethContract.allowance(owner, NFPM);
  const idiotAllowance = await idiotContract.allowance(owner, NFPM);

  console.log("Current Allowances:");
  console.log(`WETH: ${ethers.formatEther(wethAllowance)}`);
  console.log(`IDIOT: ${ethers.formatEther(idiotAllowance)}`);
  console.log("");

  // Lock approvals to zero
  if (wethAllowance > 0n) {
    console.log("🔒 Locking WETH approval...");
    const tx1 = await wethContract.approve(NFPM, 0);
    await tx1.wait();
    console.log("✅ WETH approval locked");
  } else {
    console.log("✅ WETH already locked");
  }

  if (idiotAllowance > 0n) {
    console.log("🔒 Locking IDIOT approval...");
    const tx2 = await idiotContract.approve(NFPM, 0);
    await tx2.wait();
    console.log("✅ IDIOT approval locked");
  } else {
    console.log("✅ IDIOT already locked");
  }

  // Verify locks
  const finalWethAllowance = await wethContract.allowance(owner, NFPM);
  const finalIdiotAllowance = await idiotContract.allowance(owner, NFPM);

  console.log("");
  console.log("Final Allowances:");
  console.log(`WETH: ${ethers.formatEther(finalWethAllowance)}`);
  console.log(`IDIOT: ${ethers.formatEther(finalIdiotAllowance)}`);

  if (finalWethAllowance === 0n && finalIdiotAllowance === 0n) {
    console.log("");
    console.log("🎉 ALL APPROVALS LOCKED - Security hardened");
  } else {
    console.log("");
    console.log("⚠️  WARNING - Some approvals still active");
  }
}

main().catch((e) => {
  console.error("❌ Approval locking failed:", e);
  process.exit(1);
});
