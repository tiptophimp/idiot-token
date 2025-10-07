// config/environment.js
const path = require("node:path");

// Environment configuration
const config = {
  // Persistence Directory
  PERSIST_DIR: process.env.PERSIST_DIR || path.join(process.cwd(), "data"),
  
  // RPC Configuration
  RPC_URL_PRIMARY: process.env.RPC_URL_PRIMARY || "https://mainnet.base.org",
  RPC_URL_ALCHEMY: process.env.RPC_URL_ALCHEMY || "https://base-mainnet.g.alchemy.com/v2/YOUR_KEY",
  RPC_URL_INFURA: process.env.RPC_URL_INFURA || "https://base-mainnet.infura.io/v3/YOUR_KEY",
  
  // API Keys
  ETHERSCAN_API_KEY: process.env.ETHERSCAN_API_KEY || "your_etherscan_api_key_here",
  
  // Application Configuration
  NODE_ENV: process.env.NODE_ENV || "development",
  PORT: process.env.PORT || 3000,
  
  // Monitoring
  HEALTH_CHECK_INTERVAL: parseInt(process.env.HEALTH_CHECK_INTERVAL) || 30000,
  DASHBOARD_UPDATE_INTERVAL: parseInt(process.env.DASHBOARD_UPDATE_INTERVAL) || 30000,
};

// Set PERSIST_DIR in environment if not already set
if (!process.env.PERSIST_DIR) {
  process.env.PERSIST_DIR = config.PERSIST_DIR;
}

module.exports = config;
