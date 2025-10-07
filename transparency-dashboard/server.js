const express = require('express');
const axios = require('axios');
const { ethers } = require('ethers');
const cors = require('cors');
const helmet = require('helmet');
const compression = require('compression');
const cron = require('node-cron');
const { nowUtcMs, isoNow, unixNow, syncTime, getChainTime, getStatus } = require('../scripts/utils/time.js');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(helmet());
app.use(compression());
app.use(cors());
app.use(express.json());
app.use(express.static('public'));

// Configuration
const RPC_URL = 'https://mainnet.base.org';
const BASESCAN_API_URL = 'https://api.basescan.org/api';
const IDIOT_TOKEN_ADDRESS = '0xC29EF04CFFe38012dcfc1E96a2B368443f298dE1';

// Vesting wallet configuration
const VESTING_WALLETS = [
  {
    name: 'Reserve',
    address: '0x6AD03686ab6c3bA2c77992995E4879c62dE88996',
    safe: 'TR-SAFE',
    start: 1770076800, // 2026-04-01
    duration: 94608000, // 3 years
    expectedBalance: '100000000000000000000000000'
  },
  {
    name: 'Treasury',
    address: '0x5817dccb35cd3a67520e5bda1ebc413cf097a8ee',
    safe: 'TR-SAFE',
    start: 1770076800,
    duration: 63072000, // 2 years
    expectedBalance: '50643000000000000000000000'
  },
  {
    name: 'Team',
    address: '0x5817dccb35cd3a67520e5bda1ebc413cf097a8ee',
    safe: 'TR-SAFE',
    start: 1793481600, // 2026-10-01
    duration: 94608000,
    expectedBalance: '50643000000000000000000000'
  },
  {
    name: 'Community',
    address: '0x9d466e39799fec7204f40133ecc0beb115813c13',
    safe: 'OPS-SAFE',
    start: 1759795200, // 2025-10-07
    duration: 63072000,
    expectedBalance: '200000000000000000000000000'
  }
];

// Initialize provider
const provider = new ethers.JsonRpcProvider(RPC_URL);
const tokenContract = new ethers.Contract(
  IDIOT_TOKEN_ADDRESS,
  [
    'function balanceOf(address) view returns (uint256)',
    'function totalSupply() view returns (uint256)',
    'function name() view returns (string)',
    'function symbol() view returns (string)',
    'function decimals() view returns (uint8)'
  ],
  provider
);

// Cache for real-time data
let dashboardData = {
  tokenInfo: {},
  vestingWallets: [],
  lastUpdated: null,
  verificationStatus: {}
};

// Fetch token information
async function fetchTokenInfo() {
  try {
    const [name, symbol, decimals, totalSupply] = await Promise.all([
      tokenContract.name(),
      tokenContract.symbol(),
      tokenContract.decimals(),
      tokenContract.totalSupply()
    ]);

    return {
      name,
      symbol,
      decimals: decimals.toString(),
      totalSupply: ethers.formatEther(totalSupply),
      contractAddress: IDIOT_TOKEN_ADDRESS,
      explorerUrl: `https://basescan.org/address/${IDIOT_TOKEN_ADDRESS}`
    };
  } catch (error) {
    console.error('Error fetching token info:', error);
    return null;
  }
}

// Fetch vesting wallet balances
async function fetchVestingWallets() {
  const wallets = [];
  
  for (const wallet of VESTING_WALLETS) {
    try {
      const balance = await tokenContract.balanceOf(wallet.address);
      const balanceFormatted = ethers.formatEther(balance);
      const expectedFormatted = ethers.formatEther(wallet.expectedBalance);
      
      wallets.push({
        ...wallet,
        balance: balance.toString(),
        balanceFormatted,
        expectedFormatted,
        verified: balance.toString() === wallet.expectedBalance,
        explorerUrl: `https://basescan.org/address/${wallet.address}`,
        vestingProgress: calculateVestingProgress(wallet.start, wallet.duration)
      });
    } catch (error) {
      console.error(`Error fetching balance for ${wallet.name}:`, error);
      wallets.push({
        ...wallet,
        balance: '0',
        balanceFormatted: '0',
        expectedFormatted: ethers.formatEther(wallet.expectedBalance),
        verified: false,
        error: error.message
      });
    }
  }
  
  return wallets;
}

// Calculate vesting progress using chain time for accuracy
async function calculateVestingProgress(startTimestamp, durationSeconds, provider) {
  try {
    // Use chain time for protocol logic accuracy
    const chainTime = await getChainTime(provider);
    const now = Math.floor(chainTime / 1000); // Convert to seconds
    const elapsed = Math.max(0, now - startTimestamp);
    const progress = Math.min(100, (elapsed / durationSeconds) * 100);
    const remaining = Math.max(0, durationSeconds - elapsed);
    
    return {
      progress: Math.round(progress * 100) / 100,
      elapsed: {
        total: elapsed,
        days: Math.floor(elapsed / 86400),
        hours: Math.floor((elapsed % 86400) / 3600),
        minutes: Math.floor((elapsed % 3600) / 60),
        seconds: elapsed % 60,
        formatted: `${Math.floor(elapsed / 86400)}d ${Math.floor((elapsed % 86400) / 3600)}h ${Math.floor((elapsed % 3600) / 60)}m`
      },
      remaining: {
        total: remaining,
        days: Math.floor(remaining / 86400),
        hours: Math.floor((remaining % 86400) / 3600),
        minutes: Math.floor((remaining % 3600) / 60),
        seconds: remaining % 60,
        formatted: `${Math.floor(remaining / 86400)}d ${Math.floor((remaining % 86400) / 3600)}h ${Math.floor((remaining % 3600) / 60)}m`
      },
      startDate: new Date(startTimestamp * 1000).toISOString(),
      endDate: new Date((startTimestamp + durationSeconds) * 1000).toISOString(),
      isActive: now >= startTimestamp && now < (startTimestamp + durationSeconds),
      isCompleted: now >= (startTimestamp + durationSeconds),
      isPending: now < startTimestamp,
      chainTime: chainTime,
      wallClockTime: nowUtcMs()
    };
  } catch (error) {
    console.error('Error calculating vesting progress:', error);
    // Fallback to wall clock time
    const now = unixNow();
    const elapsed = Math.max(0, now - startTimestamp);
    const progress = Math.min(100, (elapsed / durationSeconds) * 100);
    const remaining = Math.max(0, durationSeconds - elapsed);
    
    return {
      progress: Math.round(progress * 100) / 100,
      elapsed: { total: elapsed, days: Math.floor(elapsed / 86400), hours: Math.floor((elapsed % 86400) / 3600), minutes: Math.floor((elapsed % 3600) / 60), seconds: elapsed % 60, formatted: `${Math.floor(elapsed / 86400)}d ${Math.floor((elapsed % 86400) / 3600)}h ${Math.floor((elapsed % 3600) / 60)}m` },
      remaining: { total: remaining, days: Math.floor(remaining / 86400), hours: Math.floor((remaining % 86400) / 3600), minutes: Math.floor((remaining % 3600) / 60), seconds: remaining % 60, formatted: `${Math.floor(remaining / 86400)}d ${Math.floor((remaining % 86400) / 3600)}h ${Math.floor((remaining % 3600) / 60)}m` },
      startDate: new Date(startTimestamp * 1000).toISOString(),
      endDate: new Date((startTimestamp + durationSeconds) * 1000).toISOString(),
      isActive: now >= startTimestamp && now < (startTimestamp + durationSeconds),
      isCompleted: now >= (startTimestamp + durationSeconds),
      isPending: now < startTimestamp,
      chainTime: nowUtcMs(),
      wallClockTime: nowUtcMs()
    };
  }
}

// Check contract verification status on BaseScan
async function checkVerificationStatus(address) {
  try {
    const response = await axios.get(`${BASESCAN_API_URL}`, {
      params: {
        module: 'contract',
        action: 'getsourcecode',
        address: address,
        apikey: process.env.BASESCAN_API_KEY || process.env.ETHERSCAN_API_KEY
      }
    });

    const result = response.data.result[0];
    return {
      verified: result.ABI !== 'Contract source code not verified',
      sourceCode: result.SourceCode,
      abi: result.ABI,
      compilerVersion: result.CompilerVersion,
      optimizationUsed: result.OptimizationUsed,
      runs: result.Runs
    };
  } catch (error) {
    console.error(`Error checking verification for ${address}:`, error);
    return { verified: false, error: error.message };
  }
}

// Update dashboard data
async function updateDashboardData() {
  console.log('Updating dashboard data...');
  
  try {
    const [tokenInfo, vestingWallets] = await Promise.all([
      fetchTokenInfo(),
      fetchVestingWallets()
    ]);

    // Check verification status for token contract
    const tokenVerification = await checkVerificationStatus(IDIOT_TOKEN_ADDRESS);

    dashboardData = {
      tokenInfo: tokenInfo || {},
      vestingWallets,
      lastUpdated: isoNow(),
      verificationStatus: {
        tokenContract: tokenVerification
      }
    };

    console.log('Dashboard data updated successfully');
  } catch (error) {
    console.error('Error updating dashboard data:', error);
  }
}

// API Routes
app.get('/api/dashboard', (req, res) => {
  res.json(dashboardData);
});

app.get('/api/token-info', (req, res) => {
  res.json(dashboardData.tokenInfo);
});

app.get('/api/vesting-wallets', (req, res) => {
  res.json(dashboardData.vestingWallets);
});

app.get('/api/verification-status', (req, res) => {
  res.json(dashboardData.verificationStatus);
});

// Pool information endpoint
app.get('/api/pool', async (req, res) => {
  try {
    const poolAddress = '0x763c9aB550dC0DAbd32F40131481Bf4BA4d8c1ea';
    const wethUsdcPool = '0x4c6A554D69A8bC4C2B765A30b27e8a569B9e4D27'; // WETH/USDC 0.3%
    
    const poolContract = new ethers.Contract(
      poolAddress,
      [
        "function slot0() view returns (uint160,int24,uint16,uint16,uint16,uint8,bool)",
        "function liquidity() view returns (uint128)",
        "function token0() view returns (address)",
        "function token1() view returns (address)",
        "function fee() view returns (uint24)"
      ],
      provider
    );

    const wethUsdcContract = new ethers.Contract(
      wethUsdcPool,
      ["function slot0() view returns (uint160,int24,uint16,uint16,uint16,uint8,bool)"],
      provider
    );
    
    const [sqrt, tick, observationIndex, observationCardinality, observationCardinalityNext, feeProtocol, unlocked] = await poolContract.slot0();
    const liq = await poolContract.liquidity();
    const t0 = await poolContract.token0();
    const t1 = await poolContract.token1();
    const fee = await poolContract.fee();
    
    // Get WETH/USDC price for IDIOT/USD calculation
    const [wethUsdcSqrt] = await wethUsdcContract.slot0();
    const wethUsdcPrice = (Number(wethUsdcSqrt) / 2**96) ** 2;
    
    // Calculate IDIOT/WETH price
    const idiotWethPrice = (Number(sqrt) / 2**96) ** 2;
    
    // Calculate IDIOT/USD price
    const idiotUsdPrice = idiotWethPrice * wethUsdcPrice;
    
    // Calculate token reserves from liquidity and price
    const sqrtPrice = Number(sqrt);
    const liquidity = Number(liq);
    
    // For Uniswap V3, we need to calculate reserves based on current tick
    // This is a simplified calculation - in production you'd want to use a quoter
    const price = sqrtPrice / (2**96);
    const priceSquared = price * price;
    
    // Approximate reserves (this is simplified - real calculation requires tick math)
    const token0Reserve = liquidity / Math.sqrt(priceSquared);
    const token1Reserve = liquidity * Math.sqrt(priceSquared);
    
    // Calculate TVL in USD
    const token0ValueUsd = token0Reserve * wethUsdcPrice; // WETH value in USD
    const token1ValueUsd = token1Reserve * idiotUsdPrice; // IDIOT value in USD
    const tvl = token0ValueUsd + token1ValueUsd;
    
    res.json({
      pool: poolAddress,
      sqrtPriceX96: sqrt.toString(),
      tick: Number(tick),
      liquidity: liq.toString(),
      token0: t0,
      token1: t1,
      fee: Number(fee),
      price: idiotWethPrice.toString(),
      priceUsd: idiotUsdPrice.toString(),
      wethUsdPrice: wethUsdcPrice.toString(),
      token0Reserve: Math.floor(token0Reserve).toString(),
      token1Reserve: Math.floor(token1Reserve).toString(),
      tvl: tvl.toFixed(2),
      unlocked,
      observationIndex: Number(observationIndex),
      observationCardinality: Number(observationCardinality),
      observationCardinalityNext: Number(observationCardinalityNext),
      feeProtocol: Number(feeProtocol)
    });
  } catch (error) {
    console.error('Error fetching pool data:', error);
    res.status(500).json({ error: error.message });
  }
});

// Comprehensive health check endpoint for monitoring
app.get('/api/health', async (req, res) => {
  try {
    const health = {
      status: 'healthy',
      timestamp: isoNow(),
      uptime: process.uptime(),
      checks: {}
    };

    // Check RPC connectivity
    try {
      const block = await provider.getBlock('latest');
      health.checks.rpc = {
        status: 'healthy',
        blockNumber: block.number,
        timestamp: block.timestamp
      };
    } catch (error) {
      health.checks.rpc = {
        status: 'unhealthy',
        error: error.message
      };
      health.status = 'degraded';
    }

    // Check pool liquidity
    if (dashboardData.poolInfo && dashboardData.poolInfo.liquidity) {
      const liquidity = BigInt(dashboardData.poolInfo.liquidity);
      health.checks.liquidity = {
        status: liquidity > 0n ? 'healthy' : 'critical',
        value: dashboardData.poolInfo.liquidity,
        alert: liquidity === 0n ? 'Liquidity is zero!' : null
      };
      if (liquidity === 0n) health.status = 'critical';
    }

    // Check tick drift
    if (dashboardData.poolInfo && dashboardData.poolInfo.tick) {
      const tick = dashboardData.poolInfo.tick;
      const tickDrift = Math.abs(tick);
      health.checks.tickDrift = {
        status: tickDrift < 600 ? 'healthy' : 'warning',
        value: tick,
        drift: tickDrift,
        alert: tickDrift > 600 ? `Tick drift ${tickDrift} > 600` : null
      };
      if (tickDrift > 600) health.status = 'degraded';
    }

    // Check time sync
    const timeStatus = getStatus();
    health.checks.timeSync = {
      status: timeStatus.circuitBreakerOpen ? 'unhealthy' : 'healthy',
      offsetMs: timeStatus.offsetMs,
      driftAlerts: timeStatus.driftAlerts,
      failureRate: timeStatus.failureRate
    };
    if (timeStatus.circuitBreakerOpen) health.status = 'degraded';

    // Check vesting wallet balances
    if (dashboardData.vestingWallets && dashboardData.vestingWallets.length > 0) {
      const verifiedWallets = dashboardData.vestingWallets.filter(w => w.status === 'Verified').length;
      health.checks.vestingWallets = {
        status: verifiedWallets === dashboardData.vestingWallets.length ? 'healthy' : 'warning',
        verified: verifiedWallets,
        total: dashboardData.vestingWallets.length,
        alert: verifiedWallets < dashboardData.vestingWallets.length ? 'Some vesting wallets not verified' : null
      };
    }

    res.status(health.status === 'critical' ? 503 : health.status === 'degraded' ? 200 : 200).json(health);
  } catch (error) {
    res.status(500).json({
      status: 'unhealthy',
      timestamp: isoNow(),
      error: error.message
    });
  }
});

// Serve main dashboard
app.get('/', (req, res) => {
  res.sendFile(__dirname + '/public/index.html');
});

// Schedule data updates every 5 minutes
cron.schedule('*/5 * * * *', () => {
  updateDashboardData();
});

// Initial data load
updateDashboardData();

// Start time synchronization
syncTime().then(() => {
  console.log(`⏰ Time sync completed`);
}).catch(error => {
  console.warn(`⏰ Time sync failed: ${error.message}`);
});

// Start server
app.listen(PORT, () => {
  console.log(`🚀 IDIOT Transparency Dashboard running on port ${PORT}`);
  console.log(`📊 Dashboard: http://localhost:${PORT}`);
  console.log(`🔗 API: http://localhost:${PORT}/api/dashboard`);
  console.log(`⏰ Started: ${isoNow()}`);
  
  // Show time sync status
  const timeStatus = getStatus();
  console.log(`⏰ Time Sync: ${timeStatus.circuitBreakerOpen ? '⚠️ Circuit breaker open' : '✅ Active'}`);
  console.log(`📊 Offset: ${timeStatus.offsetMs}ms, Drift alerts: ${timeStatus.driftAlerts}`);
});

module.exports = app;
