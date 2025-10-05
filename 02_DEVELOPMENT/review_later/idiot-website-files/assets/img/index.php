<?php /* Idiot Token (IDIOT) — Lime/Yellow Theme with Logos */ ?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />

  <title>Idiot Token (IDIOT) — Base</title>
  <meta name="description" content="Idiot Token (IDIOT) on Base. Pure meme coin. No value, no utility, no promises. Everybody's an idiot sometimes." />

  <!-- OG/Twitter -->
  <meta property="og:title" content="Idiot Token (IDIOT) — Base" />
  <meta property="og:description" content="Pure meme coin. No value, no utility, no promises. Everybody's an idiot sometimes." />
  <meta property="og:type" content="website" />
  <meta property="og:url" content="https://www.stupidiots.com/" />
  <meta property="og:image" content="https://www.stupidiots.com/hero-1600x900.png" />
  <meta name="twitter:card" content="summary_large_image" />
  <meta name="twitter:title" content="Idiot Token (IDIOT) — Base" />
  <meta name="twitter:description" content="Pure meme coin. No value, no utility, no promises. Everybody's an idiot sometimes." />
  <meta name="twitter:image" content="https://www.stupidiots.com/hero-1600x900.png" />

  <link rel="icon" type="image/png" href="/site-icon-512.png" />
  <link rel="apple-touch-icon" href="/site-icon-512.png" />

  <!-- Tailwind -->
  <script src="https://cdn.tailwindcss.com"></script>
  <script>
    tailwind.config = {
      theme: {
        extend: {
          colors: {
            bg: '#061003',
            card: '#0b1305',
            ink: '#f4ffe6',
            mute: '#cceab0',
            lime: '#a3e635',
            amber: '#facc15',
            limeDeep: '#365314'
          }
        }
      }
    }
  </script>
  <style>
    html, body { background:#061003; color:#f4ffe6; font-family: Inter, system-ui, -apple-system, Segoe UI, Roboto, Helvetica, Arial, sans-serif; }
    .card { background:#0b1305; border:1px solid rgba(255,255,255,0.08); border-radius:14px; }
    .badge { background:rgba(255,255,255,0.06); border:1px solid rgba(255,255,255,0.14); padding:2px 8px; border-radius:999px; font-size:12px; color:#cceab0; }
    .btn { transition: transform .08s ease, opacity .2s ease; }
    .btn:active { transform:translateY(1px); }
    .btn-soft { background:rgba(255,255,255,0.08); border:1px solid rgba(255,255,255,0.14); }
    .mono { font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, 'Liberation Mono', 'Courier New', monospace; }
    .grid-main { display:grid; grid-template-columns:1fr; gap:20px; }
    @media (min-width:1024px) { .grid-main { grid-template-columns:2fr 1fr; } }
    .input { background:rgba(255,255,255,.05); border:1px solid rgba(255,255,255,.12); border-radius:10px; padding:10px 12px; color:#f4ffe6; width:100%; }
    .hero-bg { background-image:url('hero-1600x900.png'); background-size:cover; background-position:center; border-bottom:1px solid rgba(255,255,255,0.08); }
    .overlay { background:linear-gradient(90deg, rgba(6,16,3,.9) 0%, rgba(6,16,3,.6) 55%, rgba(6,16,3,.25) 100%); }
    .title-shadow { text-shadow: 0 2px 0 #000, 0 8px 30px rgba(0,0,0,.55); }
    .logo-hero { max-height:72px; width:auto; object-fit:contain; }
    .logo-small { max-height:56px; width:auto; object-fit:contain; }
    .accent-lime { background:#a3e635; color:#061003; font-weight:700; }
    .accent-amber { background:#facc15; color:#061003; font-weight:700; }
  </style>
</head>
<body>
<?php
  $CONTRACT = "0xC29EF04CFFe38012dcfc1E96a2B368443f298dE1";
  $SUPPLY = "1,000,000,000";
  $DECIMALS = 18;
  $DISCORD = "https://discord.gg/zpfnkHHE";
  $FACEBOOK = "https://www.facebook.com/profile.php?id=61580473892697";
?>

  <!-- HERO with banner + logo -->
  <section class="hero-bg">
    <div class="overlay">
      <div class="max-w-7xl mx-auto px-4 py-8 lg:py-10 flex items-center justify-between">
        <div class="flex items-center gap-4">
          <picture>
            <source srcset="/idiot-logo-lockup_512.webp" type="image/webp" />
            <img src="/idiot-logo-lockup_512.png" alt="IDIOT logo" class="logo-hero" onerror="this.onerror=null; this.src='/idiot-logo-lockup_256.png';" />
          </picture>
          <div>
            <div class="text-xs md:text-sm text-mute">Ticker: IDIOT · Network: Base</div>
            <h1 class="text-3xl lg:text-5xl font-extrabold title-shadow">Idiot Token</h1>
            <div class="text-base md:text-xl font-semibold text-ink/95 title-shadow">Putting the Cart Before the Horse</div>
          </div>
        </div>
        <div class="hidden md:flex items-center gap-2">
          <a href="<?php echo 'https://app.uniswap.org/swap?chain=base&inputCurrency=ETH&outputCurrency='.$CONTRACT; ?>" target="_blank" class="btn px-3 py-2 rounded-lg accent-lime">Buy $IDIOT</a>
          <button id="btn-chart-top" class="btn px-3 py-2 rounded-lg btn-soft">Chart</button>
          <a href="<?php echo 'https://basescan.org/token/'.$CONTRACT; ?>" target="_blank" class="btn px-3 py-2 rounded-lg btn-soft">BaseScan</a>
        </div>
      </div>
    </div>
  </section>

  <!-- MAIN -->
  <main class="max-w-7xl mx-auto px-4 py-6">
    <div class="grid-main">

      <!-- LEFT -->
      <section class="card p-6">
        <div class="flex items-start justify-between gap-3">
          <h2 class="text-2xl font-extrabold">Overview</h2>
          <img src="/site-icon-512.png" class="logo-small" alt="IDIOT icon" onerror="this.style.display='none';" />
        </div>
        <p class="mt-2 text-mute">Meme coin. No value. No utility. No promises. Pure stupidity for fun.</p>

        <div class="mt-4 flex items-start gap-2 text-sm">
          <span class="inline-flex items-center gap-2 badge">
            <span class="h-2 w-2 rounded-full" style="background:#facc15"></span>
            Pre‑launch: Liquidity not added yet. Create the pool, then set the <span class="font-semibold">Pair Address</span> below.
          </span>
        </div>

        <!-- CONTRACT -->
        <div class="mt-6 flex flex-col lg:flex-row lg:items-center gap-3">
          <span class="text-sm text-mute">Contract</span>
          <input id="contract" readonly class="input mono lg:flex-1" value="<?php echo $CONTRACT; ?>" />
          <button id="btn-copy" class="btn px-3 py-2 rounded-lg btn-soft">Copy</button>
          <button id="btn-watch" class="btn px-3 py-2 rounded-lg accent-lime">Add to Wallet</button>
        </div>

        <!-- ACTIONS -->
        <div class="mt-4 flex flex-wrap gap-3">
          <a href="<?php echo 'https://app.uniswap.org/swap?chain=base&inputCurrency=ETH&outputCurrency='.$CONTRACT; ?>" target="_blank" class="btn px-3 py-2 rounded-lg accent-lime">Buy on Uniswap</a>
          <button id="btn-open-chart" class="btn px-3 py-2 rounded-lg btn-soft">Open Chart</button>
          <a href="<?php echo 'https://basescan.org/token/'.$CONTRACT; ?>" target="_blank" class="btn px-3 py-2 rounded-lg btn-soft">View on BaseScan</a>
        </div>

        <!-- PAIR -->
        <div class="mt-6">
          <h3 class="font-semibold text-lg">Set Pair Address</h3>
          <p class="text-sm text-mute">After the Uniswap v3 IDIOT/WETH pool exists, paste the pair here to light up the chart.</p>
          <div class="mt-3 flex flex-col md:flex-row gap-3">
            <input id="pair" class="input mono md:flex-1" placeholder="0xPAIRADDRESS..." />
            <button id="btn-save-pair" class="btn px-3 py-2 rounded-lg accent-amber">Save Pair</button>
            <button id="btn-clear-pair" class="btn px-3 py-2 rounded-lg btn-soft">Clear</button>
          </div>
          <p class="text-xs text-mute mt-2">Stored locally in your browser (no server).</p>
        </div>
      </section>

      <!-- RIGHT -->
      <aside class="card p-6">
        <h2 class="text-2xl font-bold">How to Buy</h2>
        <ol class="mt-3 list-decimal list-inside space-y-2 text-mute">
          <li>Unlock MetaMask and switch to <span class="font-semibold">Base</span>.</li>
          <li>Hold ETH on Base for gas.</li>
          <li>Open Uniswap and import by contract if prompted.</li>
          <li>Swap ETH → IDIOT. If a trade fails, try 1–2% slippage.</li>
        </ol>
        <div class="mt-4 flex flex-wrap gap-2">
          <span class="badge">Supply: <?php echo $SUPPLY; ?></span>
          <span class="badge">Decimals: <?php echo $DECIMALS; ?></span>
          <span class="badge">Tax: 0%</span>
        </div>
      </aside>

    </div>

    <!-- TOKEN INFO -->
    <section class="card p-6 mt-6">
      <h2 class="text-2xl font-bold mb-4">Token Info</h2>
      <div class="overflow-x-auto">
        <table class="w-full text-left text-sm">
          <thead class="text-mute"><tr><th class="py-2 pr-4">Item</th><th class="py-2">Value</th></tr></thead>
          <tbody class="divide-y divide-white/10">
            <tr><td class="py-2 pr-4">Total Supply</td><td class="py-2"><?php echo $SUPPLY; ?> IDIOT</td></tr>
            <tr><td class="py-2 pr-4">Buy/Sell Tax</td><td class="py-2">0%</td></tr>
            <tr><td class="py-2 pr-4">Ownership</td><td class="py-2">No owner functions / no admin toggles</td></tr>
          </tbody>
        </table>
      </div>
    </section>

    <!-- CHART -->
    <section id="chart-wrap" class="card p-2 mt-6 hidden">
      <div class="p-4 flex items-center justify-between">
        <h2 class="text-2xl font-bold">Chart</h2>
        <div class="text-sm text-mute">Pair: <span id="pair-label" class="mono"></span></div>
      </div>
      <iframe id="chart-frame" src="" width="100%" height="560" style="border:0;border-radius:12px;"></iframe>
    </section>

    <!-- COMMUNITY -->
    <section class="card p-6 mt-6">
      <h2 class="text-2xl font-bold mb-3">Community</h2>
      <div class="flex flex-wrap gap-3">
        <a href="<?php echo $DISCORD; ?>" target="_blank" class="btn px-4 py-2 rounded-lg accent-lime">Discord</a>
        <a href="<?php echo $FACEBOOK; ?>" target="_blank" class="btn px-4 py-2 rounded-lg accent-amber">Facebook</a>
        <a href="https://t.me/yourgroup" target="_blank" class="btn px-4 py-2 rounded-lg btn-soft">Telegram (soon)</a>
        <a href="https://twitter.com/yourhandle" target="_blank" class="btn px-4 py-2 rounded-lg btn-soft">X (soon)</a>
      </div>
    </section>

    <!-- ROADMAP IMAGE (Optional visual block) -->
    <section class="card p-4 mt-6">
      <img src="/roadmap_poster_1400x900.png" alt="Roadmap (No Promises)" class="w-full rounded-lg" onerror="this.style.display='none';" />
    </section>

    <!-- TOKENOMICS IMAGE (Optional visual block) -->
    <section class="card p-4 mt-6">
      <img src="/tokenomics_poster_1400x900.png" alt="Tokenomics" class="w-full rounded-lg" onerror="this.style.display='none';" />
    </section>

    <!-- FOOTER -->
    <footer class="text-xs text-mute text-center py-10">
      <div>© <?php echo date('Y'); ?> Idiot Token. All rights reserved.</div>
      <div class="mt-2">Disclaimer: IDIOT is a meme token with no intrinsic value or expectation of profit. Not financial advice. DYOR.</div>
    </footer>
  </main>

  <script>
    const CONTRACT = "<?php echo $CONTRACT; ?>";
    const DECIMALS = <?php echo $DECIMALS; ?>;
    const STORAGE_KEY = "idiot_pair_address";
    const $ = (sel) => document.querySelector(sel);

    function updateChartFromStorage() {
      const pair = localStorage.getItem(STORAGE_KEY);
      const wrap = $("#chart-wrap");
      const frame = $("#chart-frame");
      const label = $("#pair-label");
      const chartBtnTop = $("#btn-chart-top");
      const chartBtnMain = $("#btn-open-chart");

      if (pair && /^0x[a-fA-F0-9]{40}$/.test(pair)) {
        wrap.classList.remove("hidden");
        const url = `https://dexscreener.com/base/${pair}`;
        frame.src = url;
        label.textContent = pair;
        if (chartBtnTop) { chartBtnTop.onclick = () => window.open(url, "_blank"); chartBtnTop.classList.remove("btn-disabled"); }
        if (chartBtnMain) { chartBtnMain.onclick = () => window.open(url, "_blank"); chartBtnMain.classList.remove("btn-disabled"); }
      } else {
        wrap.classList.add("hidden");
        label.textContent = "";
        frame.src = "";
        if (chartBtnTop) { chartBtnTop.onclick = () => alert("Save the Uniswap pair address first."); chartBtnTop.classList.add("btn-disabled"); }
        if (chartBtnMain) { chartBtnMain.onclick = () => alert("Save the Uniswap pair address first."); chartBtnMain.classList.add("btn-disabled"); }
      }
    }

    // Copy contract
    $("#btn-copy")?.addEventListener("click", () => {
      const input = $("#contract");
      input.select();
      input.setSelectionRange(0, 99999);
      document.execCommand("copy");
      alert("Contract copied.");
    });

    // Watch token
    $("#btn-watch")?.addEventListener("click", async () => {
      try {
        if (!window.ethereum) return alert("No wallet detected.");
        await window.ethereum.request({ method: 'wallet_watchAsset', params: {
          type: 'ERC20',
          options: { address: CONTRACT, symbol: 'IDIOT', decimals: DECIMALS, image: 'https://www.stupidiots.com/site-icon-512.png' }
        } });
      } catch(e) {
        console.error(e);
        alert("Could not add token to wallet.");
      }
    });

    // Save/Clear pair
    $("#btn-save-pair")?.addEventListener("click", () => {
      const v = $("#pair").value.trim();
      if (!/^0x[a-fA-F0-9]{40}$/.test(v)) return alert("Invalid pair address.");
      localStorage.setItem(STORAGE_KEY, v);
      updateChartFromStorage();
    });
    $("#btn-clear-pair")?.addEventListener("click", () => {
      localStorage.removeItem(STORAGE_KEY);
      $("#pair").value = "";
      updateChartFromStorage();
    });

    document.addEventListener("DOMContentLoaded", () => {
      const existing = localStorage.getItem(STORAGE_KEY);
      if (existing) $("#pair").value = existing;
      updateChartFromStorage();
    });
  </script>
</body>
</html>
