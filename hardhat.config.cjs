require("dotenv").config();
require("@nomicfoundation/hardhat-toolbox");
require("@nomicfoundation/hardhat-ledger");
require("@nomicfoundation/hardhat-verify");

module.exports = {
  solidity: {
    version: "0.8.20",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  networks: {
    base: {
      url: process.env.RPC_URL_PRIMARY || "https://mainnet.base.org",
      ledgerAccounts: process.env.LEDGER_ADDRESS ? [process.env.LEDGER_ADDRESS] : [],
      chainId: 8453,
    },
    baseSepolia: {
      url: process.env.RPC_URL_SEPOLIA || "https://sepolia.base.org",
      ledgerAccounts: process.env.LEDGER_ADDRESS ? [process.env.LEDGER_ADDRESS] : [],
      chainId: 84532,
    },
  },
  etherscan: {
    // Single V2 key covers all chains
    apiKey: process.env.ETHERSCAN_API_KEY,
    customChains: [
      {
        network: "base",
        chainId: 8453,
        urls: {
          apiURL: "https://api.etherscan.io/v2/api",
          browserURL: "https://basescan.org",
        },
      },
      {
        network: "baseSepolia",
        chainId: 84532,
        urls: {
          apiURL: "https://api.etherscan.io/v2/api",
          browserURL: "https://sepolia.basescan.org",
        },
      },
    ],
  },
};
