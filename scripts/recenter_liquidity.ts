import pkg from "hardhat";
const { ethers } = pkg;

const NFPM = process.env.NFPM ?? "0x03a520b32C04BF3bEEf7BEb72E919cf822Ed34f1";
const POOL = process.env.POOL ?? "0x763c9aB550dC0DAbd32F40131481Bf4BA4d8c1ea";
const TICK_WIDTH = Number(process.env.TICK_WIDTH ?? "600");   // ±ticks around current
const SLIPPAGE_BPS = BigInt(process.env.SLIPPAGE_BPS ?? "300");
const POSITION_ID = process.env.POSITION_ID ? BigInt(process.env.POSITION_ID) : 0n;         // required
const SAFE_RECIPIENT = process.env.SAFE_RECIPIENT!;           // required

const POOL_ABI = [
  "function slot0() view returns (uint160,int24,uint16,uint16,uint16,uint8,bool)",
];
const NFPM_ABI = [
  "function positions(uint256) view returns (uint96,address,address,address,uint24,int24,int24,uint128,uint256,uint256,uint128,uint128)",
  "function decreaseLiquidity((uint256 tokenId,uint128 liquidity,uint256 amount0Min,uint256 amount1Min,uint256 deadline)) returns (uint256,uint256)",
  "function collect((uint256 tokenId,address recipient,uint128 amount0Max,uint128 amount1Max)) returns (uint256,uint256)",
  "function mint((address token0,address token1,uint24 fee,int24 tickLower,int24 tickUpper,uint256 amount0Desired,uint256 amount1Desired,uint256 amount0Min,uint256 amount1Min,address recipient,uint256 deadline)) returns (uint256,uint128,uint256,uint256)",
  "function safeTransferFrom(address from,address to,uint256 tokenId)"
];
const ERC20_ABI = [
  "function balanceOf(address) view returns (uint256)",
  "function approve(address,uint256) returns (bool)",
  "function allowance(address,address) view returns (uint256)"
];

function nearestUsableTick(tick: number, spacing: number) {
  return Math.floor(tick / spacing) * spacing;
}

async function main() {
  if (!SAFE_RECIPIENT || !POSITION_ID) throw new Error("Set SAFE_RECIPIENT and POSITION_ID");

  const [signer] = await ethers.getSigners();
  const me = await signer.getAddress();

  const nfpm = new ethers.Contract(NFPM, NFPM_ABI, signer);
  const pool = new ethers.Contract(POOL, POOL_ABI, signer);

  // read current position
  const pos = await nfpm.positions(POSITION_ID);
  const token0: string = pos[2];
  const token1: string = pos[3];
  const fee: number = Number(pos[4]);
  const tickLower: number = Number(pos[5]);
  const tickUpper: number = Number(pos[6]);
  const liq: bigint = pos[7];

  console.log("Current position:", { token0, token1, fee, tickLower, tickUpper, liquidity: liq.toString() });

  // 1) remove all liquidity
  if (liq > 0n) {
    const decParams = {
      tokenId: POSITION_ID,
      liquidity: liq,
      amount0Min: 0,
      amount1Min: 0,
      deadline: Math.floor(Date.now()/1000) + 900
    };
    const tx1 = await nfpm.decreaseLiquidity(decParams);
    await tx1.wait();
    // 2) collect to signer (we'll mint new and send NFT to Safe)
    const tx2 = await nfpm.collect({
      tokenId: POSITION_ID,
      recipient: me,
      amount0Max: (2n**128n - 1n),
      amount1Max: (2n**128n - 1n)
    });
    await tx2.wait();
  }

  // 3) compute new range around current tick
  const slot0 = await pool.slot0();
  const curTick = Number(slot0[1]);
  const lower = nearestUsableTick(curTick - TICK_WIDTH, 60); // fee 3000 → spacing 60
  const upper = nearestUsableTick(curTick + TICK_WIDTH, 60);

  // 4) use current balances as desired amounts
  const erc20_0 = new ethers.Contract(token0, ERC20_ABI, signer);
  const erc20_1 = new ethers.Contract(token1, ERC20_ABI, signer);
  const bal0: bigint = await erc20_0.balanceOf(me);
  const bal1: bigint = await erc20_1.balanceOf(me);
  if (bal0 === 0n && bal1 === 0n) throw new Error("No balances to provide after collect");

  // approvals
  if ((await erc20_0.allowance(me, NFPM)) < bal0) await (await erc20_0.approve(NFPM, bal0)).wait();
  if ((await erc20_1.allowance(me, NFPM)) < bal1) await (await erc20_1.approve(NFPM, bal1)).wait();

  const amount0Min = (bal0 * (10000n - SLIPPAGE_BPS)) / 10000n;
  const amount1Min = (bal1 * (10000n - SLIPPAGE_BPS)) / 10000n;

  // 5) mint new position directly to Safe
  const mintParams = {
    token0,
    token1,
    fee,
    tickLower: lower,
    tickUpper: upper,
    amount0Desired: bal0,
    amount1Desired: bal1,
    amount0Min,
    amount1Min,
    recipient: SAFE_RECIPIENT,
    deadline: Math.floor(Date.now()/1000) + 900
  };
  const tx3 = await nfpm.mint(mintParams);
  const r3 = await tx3.wait();
  console.log("Recentered. Mint tx:", r3?.hash);
}

main().catch((e)=>{ console.error(e); process.exit(1); });
