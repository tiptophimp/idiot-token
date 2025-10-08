# IDIOT Token Website - Railway Deployment Guide

## 🚀 **Quick Start**

### **Step 1: Deploy to Railway**

1. **Go to Railway.app**
   - Visit: https://railway.app
   - Sign up with GitHub account

2. **Create New Project**
   - Click "New Project"
   - Select "Deploy from GitHub repo"
   - Choose your `idiot-token` repository

3. **Configure Deployment**
   - **Root Directory:** `/` (root of repository)
   - **Build Command:** `npm install`
   - **Start Command:** `npm start`
   - **Port:** 3000 (auto-detected)

4. **Set Environment Variables**
   ```
   NODE_ENV=production
   PORT=3000
   ```

5. **Deploy**
   - Click "Deploy"
   - Wait for build to complete
   - Get your Railway URL (e.g., `https://idiot-website-production.up.railway.app`)

### **Step 2: Configure Custom Domain**

1. **Add Custom Domain**
   - Go to project settings
   - Click "Domains"
   - Add `www.stupidiots.com`
   - Add `stupidiots.com` (apex domain)

2. **Update DNS**
   - Add CNAME record: `www` → `your-railway-url.up.railway.app`
   - Add A record: `@` → Railway's IP (if supported)

## 🎯 **What This Migration Gives You**

### ✅ **Performance Benefits**
- **Global CDN** - Faster loading worldwide
- **Automatic HTTPS** - SSL certificates managed automatically
- **HTTP/2 Support** - Better performance than traditional hosting
- **Compression** - Gzip compression for all assets
- **Caching** - Smart caching headers for optimal performance

### ✅ **Reliability Benefits**
- **99.9% Uptime** - Enterprise-grade infrastructure
- **Auto-scaling** - Handles traffic spikes automatically
- **Health Monitoring** - Built-in health checks and auto-restart
- **Zero-downtime Deployments** - Updates without service interruption

### ✅ **Developer Benefits**
- **Git-based Deployments** - Push to deploy
- **Real-time Logs** - Monitor your app in real-time
- **Environment Variables** - Easy configuration management
- **Rollback Support** - Quick rollback to previous versions

## 🔧 **Technical Configuration**

### **Server Setup**
- **Framework:** Express.js
- **Static Files:** Served from `public_html/` directory
- **API Endpoints:** `/api/health`, `/api/contract`, `/api/tokenomics`
- **Security:** Helmet.js for security headers
- **Compression:** Gzip compression enabled

### **File Structure**
```
/
├── server.js              # Express server
├── package.json           # Dependencies
├── railway.json          # Railway configuration
├── public_html/          # Website files
│   ├── index.html        # Main website
│   ├── assets/           # Images, CSS, JS
│   ├── airdrop/          # Airdrop portal
│   └── docs/             # Documentation
└── scripts/              # Utility scripts
```

## 📊 **API Endpoints**

### **Health Check**
```bash
GET /api/health
```
Returns server status and uptime information.

### **Contract Information**
```bash
GET /api/contract
```
Returns IDIOT token contract details.

### **Tokenomics**
```bash
GET /api/tokenomics
```
Returns token allocation and distribution information.

## 💰 **Cost Comparison**

### **Current Hosting vs Railway**

| Feature | Current Hosting | Railway |
|---------|----------------|---------|
| **Cost** | ~$10-20/month | $5/month (Hobby) |
| **Performance** | Basic | Enterprise-grade |
| **SSL** | Manual setup | Automatic |
| **CDN** | None | Global CDN |
| **Scaling** | Manual | Automatic |
| **Monitoring** | Basic | Advanced |
| **Deployments** | Manual upload | Git-based |

### **Railway Pricing**
- **Hobby Plan:** $5/month
  - 512MB RAM
  - 1GB storage
  - Custom domains
  - Perfect for your website

- **Pro Plan:** $20/month
  - 8GB RAM
  - 100GB storage
  - Higher limits
  - Priority support

## 🚨 **Migration Checklist**

### **Pre-Migration**
- [ ] Backup current website files
- [ ] Test website locally with new server
- [ ] Verify all links and functionality
- [ ] Update any hardcoded URLs

### **During Migration**
- [ ] Deploy to Railway
- [ ] Configure custom domain
- [ ] Update DNS records
- [ ] Test all endpoints

### **Post-Migration**
- [ ] Verify website loads correctly
- [ ] Test all features (trading links, airdrop, etc.)
- [ ] Monitor performance and logs
- [ ] Update documentation

## 🔄 **Deployment Process**

### **Automatic Deployments**
1. Push changes to GitHub
2. Railway automatically detects changes
3. Builds and deploys new version
4. Health checks ensure deployment success

### **Manual Deployments**
```bash
# Install Railway CLI
npm install -g @railway/cli

# Login to Railway
railway login

# Deploy
railway up
```

## 📈 **Monitoring & Analytics**

### **Railway Dashboard**
- Real-time logs
- Performance metrics
- Error tracking
- Resource usage

### **Health Monitoring**
- Built-in health checks
- Automatic restarts on failure
- Uptime monitoring

## 🛠️ **Troubleshooting**

### **Common Issues**

1. **Build Fails**
   - Check `package.json` dependencies
   - Verify Node.js version compatibility
   - Check build logs in Railway dashboard

2. **App Crashes**
   - Check logs for error messages
   - Verify environment variables
   - Ensure all dependencies are installed

3. **Domain Not Working**
   - Verify DNS settings
   - Check domain configuration in Railway
   - Wait for DNS propagation (up to 24 hours)

### **Debug Commands**
```bash
# Check app status
railway status

# View logs
railway logs

# Connect to app
railway shell
```

## ✅ **Success Metrics**

After migration, you should see:
- **Faster Load Times** - 50%+ improvement
- **Better Uptime** - 99.9% availability
- **Easier Deployments** - Push to deploy
- **Better Security** - Automatic SSL and security headers
- **Cost Savings** - 50%+ reduction in hosting costs

## 🎉 **Ready to Deploy!**

Your IDIOT Token website is now ready for Railway deployment! The configuration is optimized for:
- ✅ Performance
- ✅ Security
- ✅ Reliability
- ✅ Scalability
- ✅ Cost-effectiveness

**Next Step:** Deploy to Railway and enjoy enterprise-grade hosting! 🚀
