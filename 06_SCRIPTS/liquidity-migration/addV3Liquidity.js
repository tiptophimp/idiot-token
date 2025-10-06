const { ethers } = require("hardhat");

async function main() {
  console.log("🔄 Starting V3 Liquidity Addition...");
  
  // Contract addresses
  const TOKEN0 = "0xC29EF04CFFe38012dcfc1E96a2B368443f298dE1"; // IDIOT Token
  const WETH = "0x4200000000000000000000000000000000000006"; // WETH on Base
  const V3_ROUTER = "0x2626664c2603336E57B271c5C0b26F421741e481"; // Uniswap V3 Router on Base
  const V3_FACTORY = "0x33128a8fC17869897dcE68Ed026d694621f6FDfD"; // Uniswap V3 Factory on Base
  
  // Get the deployer account
  const [deployer] = await ethers.getSigners();
  console.log("Using account:", deployer.address);
  
  // Check balance
  const balance = await deployer.getBalance();
  console.log("Account balance:", ethers.utils.formatEther(balance), "ETH");
  
  if (balance.lt(ethers.utils.parseEther("0.1"))) {
    throw new Error("Insufficient ETH balance for gas fees and liquidity");
  }
  
  // Get contract instances
  const token0 = await ethers.getContractAt("IERC20", TOKEN0);
  const weth = await ethers.getContractAt("IERC20", WETH);
  const router = await ethers.getContractAt("ISwapRouter", V3_ROUTER);
  const factory = await ethers.getContractAt("IUniswapV3Factory", V3_FACTORY);
  
  // Check token balances
  const token0Balance = await token0.balanceOf(deployer.address);
  const wethBalance = await weth.balanceOf(deployer.address);
  
  console.log("IDIOT Token balance:", ethers.utils.formatEther(token0Balance));
  console.log("WETH balance:", ethers.utils.formatEther(wethBalance));
  
  // Calculate liquidity amounts (adjust these values as needed)
  const token0Amount = token0Balance.div(2); // Use half of available tokens
  const wethAmount = wethBalance.div(2); // Use half of available WETH
  
  console.log("Adding liquidity amounts:");
  console.log("IDIOT Token:", ethers.utils.formatEther(token0Amount));
  console.log("WETH:", ethers.utils.formatEther(wethAmount));
  
  // Check if pool exists, create if not
  let poolAddress = await factory.getPool(TOKEN0, WETH, 3000); // 0.3% fee tier
  
  if (poolAddress === "0x0000000000000000000000000000000000000000") {
    console.log("Creating new V3 pool...");
    const createPoolTx = await factory.createPool(TOKEN0, WETH, 3000);
    await createPoolTx.wait();
    poolAddress = await factory.getPool(TOKEN0, WETH, 3000);
    console.log("✅ Pool created:", poolAddress);
  } else {
    console.log("Pool exists:", poolAddress);
  }
  
  // Get pool contract
  const pool = await ethers.getContractAt("IUniswapV3Pool", poolAddress);
  
  // Initialize pool if needed
  const slot0 = await pool.slot0();
  if (slot0.sqrtPriceX96.eq(0)) {
    console.log("Initializing pool...");
    // Calculate initial price (1 IDIOT = 0.0001 WETH as example)
    const price = ethers.utils.parseEther("0.0001");
    const sqrtPriceX96 = await calculateSqrtPriceX96(price);
    
    const initializeTx = await pool.initialize(sqrtPriceX96);
    await initializeTx.wait();
    console.log("✅ Pool initialized");
  }
  
  // Approve tokens
  console.log("Approving tokens...");
  const approveToken0Tx = await token0.approve(V3_ROUTER, token0Amount);
  const approveWethTx = await weth.approve(V3_ROUTER, wethAmount);
  
  await Promise.all([approveToken0Tx.wait(), approveWethTx.wait()]);
  console.log("✅ Tokens approved");
  
  // Calculate tick range (full range for simplicity)
  const tickLower = -887272;
  const tickUpper = 887272;
  
  // Add liquidity
  console.log("Adding V3 liquidity...");
  const deadline = Math.floor(Date.now() / 1000) + 60 * 20; // 20 minutes
  
  const addLiquidityTx = await router.exactInputSingle({
    tokenIn: TOKEN0,
    tokenOut: WETH,
    fee: 3000,
    recipient: deployer.address,
    deadline: deadline,
    amountIn: token0Amount,
    amountOutMinimum: 0, // No slippage protection for simplicity
    sqrtPriceLimitX96: 0
  });
  
  console.log("Transaction hash:", addLiquidityTx.hash);
  const receipt = await addLiquidityTx.wait();
  console.log("✅ V3 liquidity added successfully!");
  console.log("Gas used:", receipt.gasUsed.toString());
  
  // Check final balances
  const finalToken0Balance = await token0.balanceOf(deployer.address);
  const finalWethBalance = await weth.balanceOf(deployer.address);
  
  console.log("Final IDIOT Token balance:", ethers.utils.formatEther(finalToken0Balance));
  console.log("Final WETH balance:", ethers.utils.formatEther(finalWethBalance));
  
  console.log("🎉 V3 Liquidity addition completed!");
  console.log("Pool address:", poolAddress);
  console.log("Check on GeckoTerminal: https://www.geckoterminal.com/base/pools");
}

// Helper function to calculate sqrtPriceX96
async function calculateSqrtPriceX96(price) {
  const Q96 = ethers.BigNumber.from(2).pow(96);
  const sqrtPrice = ethers.BigNumber.from(Math.floor(Math.sqrt(Number(price)) * Math.pow(2, 48)));
  return sqrtPrice.mul(Q96).div(ethers.BigNumber.from(2).pow(48));
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error("❌ Error:", error);
    process.exit(1);
  });
