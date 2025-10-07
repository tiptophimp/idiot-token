# 🧠 IDIOT Token Transparency Dashboard

A real-time transparency dashboard that displays IDIOT token balances, vesting wallet status, and contract verification information directly from Base mainnet.

## ✨ Features

- **Real-time Data**: Live token balances and vesting progress from Base mainnet
- **Contract Verification**: Automatic verification status checking via BaseScan API
- **Vesting Progress**: Visual progress bars showing vesting completion percentages
- **Responsive Design**: Mobile-friendly interface with Tailwind CSS
- **Auto-refresh**: Updates every 5 minutes with manual refresh capability
- **Security**: Helmet.js security headers and CORS protection

## 🚀 Quick Start

### 1. Install Dependencies
```bash
cd transparency-dashboard
npm install
```

### 2. Configure Environment
```bash
cp env.example .env
# Edit .env with your BaseScan API key
```

### 3. Start Dashboard
```bash
# Development
npm run dev

# Production
npm start
```

### 4. Access Dashboard
- **Dashboard**: http://localhost:3000
- **API**: http://localhost:3000/api/dashboard

## 📊 API Endpoints

| Endpoint | Description |
|----------|-------------|
| `GET /api/dashboard` | Complete dashboard data |
| `GET /api/token-info` | Token contract information |
| `GET /api/vesting-wallets` | Vesting wallet balances and status |
| `GET /api/verification-status` | Contract verification status |
| `GET /api/health` | Health check endpoint |

## 🔧 Configuration

### Environment Variables

```bash
# Server
PORT=3000

# Blockchain
RPC_URL=https://mainnet.base.org
IDIOT_TOKEN_ADDRESS=0xC29EF04CFFe38012dcfc1E96a2B368443f298dE1

# APIs
BASESCAN_API_KEY=your_key_here
ETHERSCAN_API_KEY=your_key_here

# Updates
UPDATE_SCHEDULE=*/5 * * * *  # Every 5 minutes
```

### Vesting Wallet Configuration

Edit `server.js` to modify vesting wallet addresses and parameters:

```javascript
const VESTING_WALLETS = [
  {
    name: 'Reserve',
    address: '0x6AD03686ab6c3bA2c77992995E4879c62dE88996',
    safe: 'TR-SAFE',
    start: 1770076800, // Unix timestamp
    duration: 94608000, // Seconds
    expectedBalance: '100000000000000000000000000' // Wei
  },
  // ... more wallets
];
```

## 🎨 Customization

### Styling
- Modify `public/index.html` for UI changes
- Uses Tailwind CSS for styling
- Custom CSS in `<style>` section

### Data Sources
- Update `RPC_URL` for different networks
- Modify `VESTING_WALLETS` array for different addresses
- Add new API endpoints in `server.js`

## 🔒 Security Features

- **Helmet.js**: Security headers
- **CORS**: Cross-origin request protection
- **Rate Limiting**: Built-in Express rate limiting
- **Input Validation**: Sanitized API inputs
- **Error Handling**: Graceful error responses

## 📈 Monitoring

### Health Check
```bash
curl http://localhost:3000/api/health
```

### Metrics
- Uptime tracking
- Last update timestamp
- Error logging
- Performance monitoring

## 🚀 Deployment

### PM2 (Recommended)
```bash
npm install -g pm2
pm2 start server.js --name "idiot-dashboard"
pm2 save
pm2 startup
```

### Docker
```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install --production
COPY . .
EXPOSE 3000
CMD ["npm", "start"]
```

### Nginx Reverse Proxy
```nginx
server {
    listen 80;
    server_name your-domain.com;
    
    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

## 🔄 Data Updates

- **Automatic**: Every 5 minutes via cron job
- **Manual**: Refresh browser or call API
- **Real-time**: WebSocket support (future enhancement)

## 🛠️ Development

### Scripts
```bash
npm run dev      # Development with nodemon
npm start        # Production start
npm run build    # Install dependencies
```

### Adding New Features
1. Add API endpoint in `server.js`
2. Update frontend in `public/index.html`
3. Test with `npm run dev`
4. Deploy with `npm start`

## 📝 License

MIT License - see LICENSE file for details

## 🤝 Contributing

1. Fork the repository
2. Create feature branch
3. Make changes
4. Test thoroughly
5. Submit pull request

---

**Built with transparency and security in mind** 🛡️
