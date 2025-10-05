// app.js — live token data and market information
const CONTRACT_ADDRESS = "0xC29EF04CFFe38012dcfc1E96a2B368443f298dE1";
const POOL_ADDRESS = "0x763c9ab550dc0dabd32f40131481bf4ba4d8c1ea";
const RPC_URL = "https://mainnet.base.org";

const ERC20_ABI = [
  "function name() view returns (string)",
  "function symbol() view returns (string)",
  "function decimals() view returns (uint8)",
  "function totalSupply() view returns (uint256)"
];

async function loadTokenData() {
  try {
    const provider = new ethers.providers.JsonRpcProvider(RPC_URL);
    const token = new ethers.Contract(CONTRACT_ADDRESS, ERC20_ABI, provider);

    const [name, symbol, decimals, supply] = await Promise.all([
      token.name(),
      token.symbol(),
      token.decimals(),
      token.totalSupply()
    ]);

    document.getElementById("tokenName").innerText = name;
    document.getElementById("tokenSymbol").innerText = symbol;
    document.getElementById("tokenSupply").innerText =
      ethers.utils.formatUnits(supply, decimals);

    // DexScreener API for price & liquidity
    const url = `https://api.dexscreener.com/latest/dex/pairs/base/${POOL_ADDRESS}`;
    const response = await fetch(url);
    const data = await response.json();

    if (data && data.pair) {
      const priceUsd = data.pair.priceUsd || "N/A";
      const liquidityUsd = data.pair.liquidity?.usd || "N/A";
      const volume24h = data.pair.volume?.h24 || "N/A";

      document.getElementById("tokenPriceUsd").innerText = `$${Number(priceUsd).toFixed(6)}`;
      document.getElementById("poolLiquidityUsd").innerText = `$${Number(liquidityUsd).toLocaleString()}`;
      document.getElementById("volume24h").innerText = `$${Number(volume24h).toLocaleString()}`;
    }

    // Update timestamp
    const now = new Date();
    document.getElementById("lastUpdated").innerText = now.toLocaleTimeString();

  } catch (err) {
    console.error("Error loading data:", err);
    // Show error state
    document.getElementById("tokenName").innerText = "Error";
    document.getElementById("tokenSymbol").innerText = "Error";
    document.getElementById("tokenPriceUsd").innerText = "Error";
    document.getElementById("tokenSupply").innerText = "Error";
    document.getElementById("poolLiquidityUsd").innerText = "Error";
    document.getElementById("volume24h").innerText = "Error";
    document.getElementById("lastUpdated").innerText = "Failed to load";
  }
}

// Load on page load + auto-refresh every 30 seconds
window.addEventListener("load", () => {
  loadTokenData();
  setInterval(loadTokenData, 30000);
});
