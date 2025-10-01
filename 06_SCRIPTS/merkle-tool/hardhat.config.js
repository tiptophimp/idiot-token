require('@nomicfoundation/hardhat-toolbox');
require('dotenv').config();

const { RPC_URL, PRIVATE_KEY } = process.env;

module.exports = {
  solidity: '0.8.24',
  networks: {
    base: {
      url: RPC_URL || 'https://mainnet.base.org',
      accounts: PRIVATE_KEY ? [PRIVATE_KEY] : []
    }
  }
};
