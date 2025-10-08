const express = require('express');
const path = require('path');
const compression = require('compression');
const helmet = require('helmet');
const cors = require('cors');

const app = express();
const PORT = process.env.PORT || 3000;

// Security middleware
app.use(helmet({
  contentSecurityPolicy: {
    directives: {
      defaultSrc: ["'self'"],
      styleSrc: ["'self'", "'unsafe-inline'", "https://fonts.googleapis.com"],
      fontSrc: ["'self'", "https://fonts.gstatic.com"],
      imgSrc: ["'self'", "data:", "https:", "blob:"],
      scriptSrc: ["'self'", "'unsafe-inline'", "https://cdn.ethers.io", "https://www.googletagmanager.com"],
      connectSrc: ["'self'", "https://api.dexscreener.com", "https://mainnet.base.org"],
      frameSrc: ["'self'", "https://app.uniswap.org", "https://dexscreener.com"]
    }
  },
  crossOriginEmbedderPolicy: false
}));

// CORS configuration
app.use(cors({
  origin: process.env.NODE_ENV === 'production' 
    ? ['https://stupidiots.com', 'https://www.stupidiots.com'] 
    : true,
  credentials: true
}));

// Compression middleware
app.use(compression());

// Serve static files from public_html
app.use(express.static(path.join(__dirname, 'public_html'), {
  maxAge: process.env.NODE_ENV === 'production' ? '1d' : '0',
  etag: true,
  lastModified: true
}));

// Health check endpoint
app.get('/api/health', (req, res) => {
  res.json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    version: process.env.npm_package_version || '1.0.0'
  });
});

// API endpoint for contract info
app.get('/api/contract', (req, res) => {
  res.json({
    address: '0xC29EF04CFFe38012dcfc1E96a2B368443f298dE1',
    network: 'Base',
    chainId: 8453,
    symbol: 'IDIOT',
    decimals: 18,
    totalSupply: '1000000000000000000000000000'
  });
});

// API endpoint for tokenomics
app.get('/api/tokenomics', (req, res) => {
  res.json({
    totalSupply: 1000000000,
    allocations: {
      reserve: { percentage: 47, amount: 470000000, description: 'Cold Treasury' },
      community: { percentage: 25, amount: 250000000, description: 'Community & Airdrops' },
      liquidity: { percentage: 15, amount: 150000000, description: 'Liquidity Pool' },
      team: { percentage: 10, amount: 100000000, description: 'Team (Locked & Vested)' },
      treasury: { percentage: 3, amount: 30000000, description: 'Treasury / Ops' }
    },
    tax: { buy: 0, sell: 0 }
  });
});

// Catch-all handler: send back React's index.html file for client-side routing
app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, 'public_html', 'index.html'));
});

// Error handling middleware
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ 
    error: 'Something went wrong!',
    message: process.env.NODE_ENV === 'production' ? 'Internal server error' : err.message
  });
});

// Start server
app.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 IDIOT Token Website running on port ${PORT}`);
  console.log(`📱 Environment: ${process.env.NODE_ENV || 'development'}`);
  console.log(`🌐 Health check: http://localhost:${PORT}/api/health`);
});

// Graceful shutdown
process.on('SIGTERM', () => {
  console.log('SIGTERM received, shutting down gracefully');
  process.exit(0);
});

process.on('SIGINT', () => {
  console.log('SIGINT received, shutting down gracefully');
  process.exit(0);
});
