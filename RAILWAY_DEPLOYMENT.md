# IDIOT Token Dashboard - Railway Deployment Guide

## 🚀 **Railway Deployment Steps**

### **Step 1: Prepare Repository**
1. Ensure all files are committed and pushed to GitHub
2. Verify `transparency-dashboard/package.json` has correct dependencies
3. Check that `Procfile` exists in transparency-dashboard directory

### **Step 2: Deploy to Railway**

1. **Go to Railway.app**
   - Visit: https://railway.app
   - Sign up with GitHub account

2. **Create New Project**
   - Click "New Project"
   - Select "Deploy from GitHub repo"
   - Choose your `idiot-token` repository

3. **Configure Deployment**
   - **Root Directory:** `transparency-dashboard`
   - **Build Command:** `npm install`
   - **Start Command:** `npm start`
   - **Port:** 3000 (auto-detected)

4. **Set Environment Variables**
   ```
   NODE_ENV=production
   PORT=3000
   RPC_URL=https://mainnet.base.org
   ETHERSCAN_API_KEY=your_etherscan_api_key
   ```

5. **Deploy**
   - Click "Deploy"
   - Wait for build to complete
   - Get your Railway URL (e.g., `https://idiot-dashboard-production.up.railway.app`)

### **Step 3: Configure Custom Domain**

1. **Add Custom Domain**
   - Go to project settings
   - Click "Domains"
   - Add `www.stupidiots.com`
   - Add `stupidiots.com` (apex domain)

2. **Update DNS**
   - Add CNAME record: `www` → `your-railway-url.up.railway.app`
   - Add A record: `@` → Railway's IP (if supported)

### **Step 4: Verify Deployment**

1. **Test Health Endpoint**
   ```bash
   curl https://www.stupidiots.com/api/health
   ```

2. **Test Main Dashboard**
   ```bash
   curl https://www.stupidiots.com
   ```

3. **Check All APIs**
   - Health: `/api/health`
   - Dashboard: `/api/dashboard`
   - Vesting: `/api/vesting-wallets`
   - Pool: `/api/pool`

## 🔧 **Railway Configuration**

### **Environment Variables**
```bash
NODE_ENV=production
PORT=3000
RPC_URL=https://mainnet.base.org
ETHERSCAN_API_KEY=your_key_here
```

### **Railway.json Configuration**
```json
{
  "$schema": "https://railway.app/railway.schema.json",
  "build": {
    "builder": "NIXPACKS"
  },
  "deploy": {
    "startCommand": "cd transparency-dashboard && npm install && node server.js",
    "healthcheckPath": "/api/health",
    "healthcheckTimeout": 100,
    "restartPolicyType": "ON_FAILURE",
    "restartPolicyMaxRetries": 10
  }
}
```

## 📊 **Monitoring & Maintenance**

### **Railway Dashboard**
- Monitor logs in real-time
- View metrics and performance
- Check deployment status
- Manage environment variables

### **Health Monitoring**
- Railway provides built-in health checks
- Custom health endpoint: `/api/health`
- Automatic restarts on failure

### **Scaling**
- Railway auto-scales based on traffic
- Upgrade plan for higher limits
- Add database if needed

## 💰 **Cost Breakdown**

### **Railway Pricing**
- **Hobby Plan:** $5/month
  - 512MB RAM
  - 1GB storage
  - Custom domains
  - Perfect for your dashboard

- **Pro Plan:** $20/month
  - 8GB RAM
  - 100GB storage
  - Higher limits
  - Priority support

## 🚨 **Troubleshooting**

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

## ✅ **Post-Deployment Checklist**

- [ ] App deployed successfully
- [ ] Health endpoint responding
- [ ] Custom domain configured
- [ ] SSL certificate active
- [ ] All APIs functional
- [ ] Monitoring set up
- [ ] Backup procedures in place

## 🔄 **Updates & Maintenance**

### **Deploy Updates**
1. Push changes to GitHub
2. Railway auto-deploys
3. Verify deployment in dashboard
4. Test all endpoints

### **Environment Changes**
1. Update variables in Railway dashboard
2. Redeploy if needed
3. Test configuration

---

**Railway is the perfect choice for your IDIOT Token Dashboard!** 🚀
