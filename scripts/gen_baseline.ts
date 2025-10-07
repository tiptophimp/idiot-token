import { writeFileSync, mkdirSync } from "node:fs";
import { join } from "node:path";
import { auditPath } from "./utils/paths.js";
import pkg from "hardhat";
const { ethers } = pkg;

const NFPM = "0x03a520b32C04BF3bEEf7BEb72E919cf822Ed34f1"; // Base

const ERC20_ABI = [
  "function name() view returns (string)",
  "function symbol() view returns (string)",
  "function decimals() view returns (uint8)",
  "function totalSupply() view returns (uint256)",
  "function balanceOf(address) view returns (uint256)"
];

const POOL_ABI = [
  "function slot0() view returns (uint160,int24,uint16,uint16,uint16,uint8,bool)",
  "function liquidity() view returns (uint128)",
  "function token0() view returns (address)",
  "function token1() view returns (address)",
  "function fee() view returns (uint24)"
];

const NFPM_ABI = [
  "function positions(uint256) view returns (uint96,address,address,address,uint24,int24,int24,uint128,uint256,uint256,uint128,uint128)"
];

function pct(n: bigint, d: bigint): string {
  if (d === 0n) return "0.00%";
  return `${Number((n * 10000n) / d) / 100} %`;
}

function fmt(n: bigint, decimals = 18): string {
  return ethers.formatUnits(n, decimals);
}

async function main() {
  const SAFE = process.env.SAFE?.trim();
  const POSITION_IDS = (process.env.POSITION_IDS || "").split(",").map(s=>s.trim()).filter(Boolean);
  const TOKEN = process.env.TOKEN?.trim() || "0xC29EF04CFFe38012dcfc1E96a2B368443f298dE1"; // IDIOT
  const POOL  = process.env.POOL?.trim()  || "0x763c9aB550dC0DAbd32F40131481Bf4BA4d8c1ea"; // WETH/IDIOT 0.3%
  const VESTING = (process.env.VESTING_ADDRS || "")
    // "Reserve:0x...,Treasury:0x...,Team:0x...,Community:0x..."
    .split(",").map(x => x.trim()).filter(Boolean)
    .map(pair => {
      const [label, addr] = pair.split(":").map(s=>s.trim());
      return { label, addr };
    });

  if (!SAFE) throw new Error("Set SAFE=0xYourTreasurySafe");
  if (!POSITION_IDS.length) throw new Error("Set POSITION_IDS=comma,separated,ids");

  const [signer] = await ethers.getSigners();
  const provider = signer?.provider || ethers.provider;
  const { number: blockNumber, timestamp } = await provider.getBlock("latest");
  const net = await provider.getNetwork();

  // token summary
  const token = new ethers.Contract(TOKEN, ERC20_ABI, provider);
  const [name, symbol, decimals, totalSupply] = await Promise.all([
    token.name(), token.symbol(), token.decimals(), token.totalSupply()
  ]);

  // pool info
  const pool = new ethers.Contract(POOL, POOL_ABI, provider);
  const [[sqrtPriceX96, tick], liquidity, token0, token1, fee] = await Promise.all([
    pool.slot0(), pool.liquidity(), pool.token0(), pool.token1(), pool.fee()
  ]);

  // vesting balances
  const vestingLines: string[] = [];
  for (const v of VESTING) {
    const bal: bigint = await token.balanceOf(v.addr);
    vestingLines.push(`- ${v.label}: ${fmt(bal, decimals)} ${symbol} (${pct(bal, totalSupply)}) — ${v.addr}`);
  }

  // positions
  const nfpm = new ethers.Contract(NFPM, NFPM_ABI, provider);
  const posLines: string[] = [];
  for (const idStr of POSITION_IDS) {
    const id = BigInt(idStr);
    const p = await nfpm.positions(id);
    const _ownerNonce: bigint = p[0];
    const operator: string = p[1];
    const _token0: string = p[2];
    const _token1: string = p[3];
    const _fee: number = Number(p[4]);
    const tickLower: number = Number(p[5]);
    const tickUpper: number = Number(p[6]);
    const liq: bigint = p[7];
    posLines.push(
      `- #${id} | fee ${_fee} | ticks [${tickLower}, ${tickUpper}] | liq ${liq.toString()} | t0 ${_token0} | t1 ${_token1} | op ${operator}`
    );
  }

  const iso = new Date(timestamp * 1000).toISOString();

  const md = `# IDIOT Baseline Attestation

**Generated at:** ${new Date().toISOString()}  
**Chain:** ${net.chainId} (${net.name})  
**Block:** ${blockNumber} @ ${iso}

## Contracts
- **Token (IDIOT):** ${TOKEN}
- **Uniswap V3 Pool (WETH/IDIOT 0.3%):** ${POOL}
- **NFPositionManager:** ${NFPM}
- **Treasury Safe:** ${SAFE}

## Token Summary
- Name: ${name}
- Symbol: ${symbol}
- Decimals: ${decimals}
- Total Supply: ${fmt(totalSupply, decimals)} ${symbol}

## Vesting Wallets
${vestingLines.length ? vestingLines.join("\n") : "_none provided via VESTING_ADDRS env_"}

## Pool Snapshot
- token0: ${token0}
- token1: ${token1}
- fee: ${fee}
- liquidity: ${liquidity.toString()}
- slot0.sqrtPriceX96: ${sqrtPriceX96.toString()}
- slot0.tick: ${Number(tick)}

## LP Positions (NFPM)
${posLines.join("\n")}

## Notes
- All values pulled live from Base RPC.
- Rerun this generator after any LP change, vesting move, or token mint/burn.

`;

      const out = auditPath("BASELINE.md");
  writeFileSync(out, md);
  console.log(`Wrote ${out}`);
}

main().catch((e) => { console.error(e); process.exit(1); });
