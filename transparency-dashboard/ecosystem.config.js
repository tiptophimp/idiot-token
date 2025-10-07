module.exports = {
  apps: [{
    name: 'idiot-transparency-dashboard',
    script: 'server.js',
    cwd: process.cwd(),
    instances: 1,
    autorestart: true,
    watch: false,
    max_memory_restart: '1G',
    env: {
      NODE_ENV: 'development',
      PORT: 3000,
      PERSIST_DIR: process.env.PERSIST_DIR || './data',
      RPC_URL_PRIMARY: 'https://mainnet.base.org'
    },
    env_production: {
      NODE_ENV: 'production',
      PORT: 3000,
      PERSIST_DIR: '/var/lib/stupidiots',
      RPC_URL_PRIMARY: 'https://mainnet.base.org'
    },
    error_file: './logs/err.log',
    out_file: './logs/out.log',
    log_file: './logs/combined.log',
    time: true
  }]
};
