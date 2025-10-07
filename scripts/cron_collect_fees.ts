import pkg from "hardhat";
const { ethers } = pkg;

const NFPM = process.env.NFPM ?? "0x03a520b32C04BF3bEEf7BEb72E919cf822Ed34f1";
const SAFE_RECIPIENT = process.env.SAFE_RECIPIENT!;       // required
const POSITION_IDS = (process.env.POSITION_IDS ?? "").split(",").map(s=>s.trim()).filter(Boolean);

const ABI = [
  "function collect((uint256 tokenId,address recipient,uint128 amount0Max,uint128 amount1Max)) returns (uint256,uint256)"
];

async function main() {
  if (!SAFE_RECIPIENT || POSITION_IDS.length===0) throw new Error("Set SAFE_RECIPIENT and POSITION_IDS=comma,separated,ids");
  const [signer] = await ethers.getSigners();
  const nfpm = new ethers.Contract(NFPM, ABI, signer);

  for (const idStr of POSITION_IDS) {
    const id = BigInt(idStr);
    try {
      const tx = await nfpm.collect({
        tokenId: id,
        recipient: SAFE_RECIPIENT,
        amount0Max: (2n**128n - 1n),
        amount1Max: (2n**128n - 1n)
      });
      const r = await tx.wait();
      console.log(`Collected fees for #${id} tx=${r?.hash}`);
    } catch (e:any) {
      console.error(`#${id} failed:`, e.message ?? e);
    }
  }
}

main().catch((e)=>{ console.error(e); process.exit(1); });
