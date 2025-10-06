const { ethers } = require("hardhat");

async function main() {
  console.log("🔄 Starting V2 Liquidity Removal...");
  
  // Contract addresses
  const TOKEN0 = "0xC29EF04CFFe38012dcfc1E96a2B368443f298dE1"; // IDIOT Token
  const WETH = "0x4200000000000000000000000000000000000006"; // WETH on Base
  const V2_ROUTER = "0x4752ba5dbc23f44d87826276bf6fd6b1f372465"; // Uniswap V2 Router on Base
  
  // Get the deployer account
  const [deployer] = await ethers.getSigners();
  console.log("Using account:", deployer.address);
  
  // Check balance
  const balance = await deployer.getBalance();
  console.log("Account balance:", ethers.utils.formatEther(balance), "ETH");
  
  if (balance.lt(ethers.utils.parseEther("0.01"))) {
    throw new Error("Insufficient ETH balance for gas fees");
  }
  
  // Get contract instances
  const token0 = await ethers.getContractAt("IERC20", TOKEN0);
  const weth = await ethers.getContractAt("IERC20", WETH);
  const router = await ethers.getContractAt("IUniswapV2Router02", V2_ROUTER);
  
  // Check token balances
  const token0Balance = await token0.balanceOf(deployer.address);
  const wethBalance = await weth.balanceOf(deployer.address);
  
  console.log("IDIOT Token balance:", ethers.utils.formatEther(token0Balance));
  console.log("WETH balance:", ethers.utils.formatEther(wethBalance));
  
  if (token0Balance.eq(0) || wethBalance.eq(0)) {
    console.log("⚠️  No liquidity to remove or tokens not found");
    return;
  }
  
  // Get LP token address
  const factory = await ethers.getContractAt("IUniswapV2Factory", await router.factory());
  const pairAddress = await factory.getPair(TOKEN0, WETH);
  
  if (pairAddress === "0x0000000000000000000000000000000000000000") {
    console.log("❌ No V2 pair found for IDIOT/WETH");
    return;
  }
  
  console.log("LP Pair address:", pairAddress);
  
  // Get LP token contract
  const lpToken = await ethers.getContractAt("IERC20", pairAddress);
  const lpBalance = await lpToken.balanceOf(deployer.address);
  
  console.log("LP Token balance:", ethers.utils.formatEther(lpBalance));
  
  if (lpBalance.eq(0)) {
    console.log("❌ No LP tokens to remove");
    return;
  }
  
  // Approve router to spend LP tokens
  console.log("Approving router to spend LP tokens...");
  const approveTx = await lpToken.approve(V2_ROUTER, lpBalance);
  await approveTx.wait();
  console.log("✅ LP tokens approved");
  
  // Remove liquidity
  console.log("Removing V2 liquidity...");
  const deadline = Math.floor(Date.now() / 1000) + 60 * 20; // 20 minutes
  
  const removeLiquidityTx = await router.removeLiquidity(
    TOKEN0,
    WETH,
    lpBalance,
    0, // amount0Min (slippage tolerance)
    0, // amount1Min (slippage tolerance)
    deployer.address,
    deadline
  );
  
  console.log("Transaction hash:", removeLiquidityTx.hash);
  const receipt = await removeLiquidityTx.wait();
  console.log("✅ V2 liquidity removed successfully!");
  console.log("Gas used:", receipt.gasUsed.toString());
  
  // Check final balances
  const finalToken0Balance = await token0.balanceOf(deployer.address);
  const finalWethBalance = await weth.balanceOf(deployer.address);
  
  console.log("Final IDIOT Token balance:", ethers.utils.formatEther(finalToken0Balance));
  console.log("Final WETH balance:", ethers.utils.formatEther(finalWethBalance));
  
  console.log("🎉 V2 Liquidity removal completed!");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error("❌ Error:", error);
    process.exit(1);
  });
