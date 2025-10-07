// scripts/uniswapV3_addLiquidity.ts
import pkg from "hardhat";
const { ethers } = pkg;

// ---- config ----
const NFPM = "0x03a520b32C04BF3bEEf7BEb72E919cf822Ed34f1";
const POOL = "0x763c9aB550dC0DAbd32F40131481Bf4BA4d8c1ea";
const WETH = "0x4200000000000000000000000000000000000006";
const IDIOT = "0xC29EF04CFFe38012dcfc1E96a2B368443f298dE1";
const FEE = 3000;            // 0.3%
const TICK_SPACING = 60;     // for 0.3%
// desired deposit (edit as needed)
const AMOUNT_WETH = ethers.parseEther("0.2");        // 0.2 WETH
const AMOUNT_IDIOT = ethers.parseUnits("5000000", 18); // 5,000,000 IDIOT
const SLIPPAGE_BPS = 300; // 3% min-out padding

// ---- minimal ABIs ----
const ERC20_ABI = [
  "function approve(address spender,uint256 value) external returns (bool)",
  "function allowance(address owner,address spender) view returns (uint256)",
  "function decimals() view returns (uint8)",
  "function balanceOf(address) view returns (uint256)"
];
const WETH_ABI = [...ERC20_ABI, "function deposit() payable", "function withdraw(uint256)"];
const POOL_ABI = [
  "function slot0() view returns (uint160 sqrtPriceX96,int24 tick,uint16,uint16,uint16,uint8,bool)",
  "function token0() view returns (address)", "function token1() view returns (address)"
];
const NFPM_ABI = [
  "function mint((address token0,address token1,uint24 fee,int24 tickLower,int24 tickUpper,uint256 amount0Desired,uint256 amount1Desired,uint256 amount0Min,uint256 amount1Min,address recipient,uint256 deadline)) external payable returns (uint256 tokenId,uint128 liquidity,uint256 amount0,uint256 amount1)"
];

function nearestUsableTick(tick: number, spacing: number) {
  const r = Math.floor(tick / spacing) * spacing;
  return r;
}

async function main() {
  const [signer] = await ethers.getSigners();
  console.log("🚀 Adding liquidity to IDIOT/WETH pool");
  console.log(`📝 Signer: ${await signer.getAddress()}`);

  const pool = new ethers.Contract(POOL, POOL_ABI, signer);
  const [ , currentTick ] = await pool.slot0();
  console.log(`📍 Current tick: ${currentTick}`);

  // choose a symmetric range around current tick
  const width = 10 * TICK_SPACING; // ~600 ticks wide
  const lower = nearestUsableTick(Number(currentTick) - width, TICK_SPACING);
  const upper = nearestUsableTick(Number(currentTick) + width, TICK_SPACING);
  console.log(`📊 Range: ${lower} to ${upper} (width: ${width})`);

  // token0 = WETH per your pool
  const token0 = new ethers.Contract(WETH, WETH_ABI, signer);
  const token1 = new ethers.Contract(IDIOT, ERC20_ABI, signer);
  const nfpm  = new ethers.Contract(NFPM, NFPM_ABI, signer);

  // wrap ETH if needed
  const balWETH = await token0.balanceOf(await signer.getAddress());
  console.log(`💰 WETH balance: ${ethers.formatEther(balWETH)}`);
  
  if (balWETH < AMOUNT_WETH) {
    const toWrap = AMOUNT_WETH - balWETH;
    console.log(`🔄 Wrapping ${ethers.formatEther(toWrap)} ETH to WETH`);
    const tx = await token0.deposit({ value: toWrap });
    await tx.wait();
    console.log("✅ WETH wrapped");
  }

  // approve NFPM
  const need0 = (await token0.allowance(await signer.getAddress(), NFPM)) < AMOUNT_WETH;
  const need1 = (await token1.allowance(await signer.getAddress(), NFPM)) < AMOUNT_IDIOT;
  
  if (need0) {
    console.log("🔐 Approving WETH for NFPM");
    await (await token0.approve(NFPM, AMOUNT_WETH)).wait();
  }
  if (need1) {
    console.log("🔐 Approving IDIOT for NFPM");
    await (await token1.approve(NFPM, AMOUNT_IDIOT)).wait();
  }

  // min amounts with slippage guard
  const amount0Min = (AMOUNT_WETH * BigInt(10000 - SLIPPAGE_BPS)) / 10000n;
  const amount1Min = (AMOUNT_IDIOT * BigInt(10000 - SLIPPAGE_BPS)) / 10000n;

  const params = {
    token0: WETH,
    token1: IDIOT,
    fee: FEE,
    tickLower: lower,
    tickUpper: upper,
    amount0Desired: AMOUNT_WETH,
    amount1Desired: AMOUNT_IDIOT,
    amount0Min,
    amount1Min,
    recipient: await signer.getAddress(),
    deadline: Math.floor(Date.now() / 1000) + 900
  };

  console.log("📋 Minting position with params:");
  console.log(`   WETH: ${ethers.formatEther(AMOUNT_WETH)}`);
  console.log(`   IDIOT: ${ethers.formatUnits(AMOUNT_IDIOT, 18)}`);
  console.log(`   Min WETH: ${ethers.formatEther(amount0Min)}`);
  console.log(`   Min IDIOT: ${ethers.formatUnits(amount1Min, 18)}`);

  const tx = await nfpm.mint(params);
  console.log("⏳ Transaction submitted:", tx.hash);
  
  const receipt = await tx.wait();
  console.log("✅ Position minted successfully!");
  console.log("📄 Transaction hash:", receipt?.hash);
  
  // Extract tokenId from logs
  const mintEvent = receipt?.logs.find(log => {
    try {
      const parsed = nfpm.interface.parseLog(log);
      return parsed?.name === 'IncreaseLiquidity';
    } catch {
      return false;
    }
  });
  
  if (mintEvent) {
    const parsed = nfpm.interface.parseLog(mintEvent);
    console.log("🎫 Position Token ID:", parsed?.args.tokenId?.toString());
  }
}

main().catch((e) => { 
  console.error("❌ Error:", e); 
  process.exit(1); 
});
