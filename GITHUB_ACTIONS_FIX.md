# GitHub Actions RPC Fix Guide

**Issue:** `Internal transport error: Connection refused (os error 111)` during RPC health check  
**Root Cause:** `RPC_URL_PRIMARY` secret is either missing or contains invalid/unreachable endpoint  
**Status:** ❌ Blocking all GitHub Actions workflows

## 🔧 **Immediate Fix Steps**

### 1. **Check Current Secrets**
Go to your repository: `Settings > Secrets and variables > Actions`

**Required Secrets:**
- ✅ `ETHERSCAN_API_KEY` - Your Etherscan V2 API key
- ❌ `RPC_URL_PRIMARY` - **MISSING OR INVALID**
- ❌ `RPC_URL_ALCHEMY` - Optional backup
- ❌ `RPC_URL_INFURA` - Optional backup

### 2. **Set Valid RPC URLs**

**Primary RPC (Required):**
```
Name: RPC_URL_PRIMARY
Value: https://mainnet.base.org
```

**Backup RPCs (Recommended):**
```
Name: RPC_URL_ALCHEMY
Value: https://base-mainnet.g.alchemy.com/v2/YOUR_ALCHEMY_KEY

Name: RPC_URL_INFURA
Value: https://base-mainnet.infura.io/v3/YOUR_INFURA_KEY
```

### 3. **Test RPC Endpoints Locally**

```bash
# Test primary RPC
curl -X POST https://mainnet.base.org \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}'

# Expected response: {"jsonrpc":"2.0","id":1,"result":"0x22d8a8c"}

# Test Alchemy RPC (if you have a key)
curl -X POST https://base-mainnet.g.alchemy.com/v2/YOUR_KEY \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}'
```

### 4. **Alternative RPC Providers**

If the default Base RPC is unreliable, use these alternatives:

**Alchemy (Recommended):**
1. Sign up at https://alchemy.com
2. Create new app for "Base Mainnet"
3. Copy the HTTP URL
4. Set as `RPC_URL_PRIMARY`

**Infura:**
1. Sign up at https://infura.io
2. Create new project
3. Select "Base" network
4. Copy the endpoint URL
5. Set as `RPC_URL_PRIMARY`

**QuickNode:**
1. Sign up at https://quicknode.com
2. Create endpoint for "Base Mainnet"
3. Copy the HTTP URL
4. Set as `RPC_URL_PRIMARY`

## 🧪 **Test the Fix**

### 1. **Test Locally First**
```bash
# Set environment variable
export RPC_URL_PRIMARY="https://mainnet.base.org"

# Test the health check
curl -s http://localhost:3000/api/health | jq '.checks.rpc'
```

### 2. **Test GitHub Actions**
1. Go to `Actions` tab in your repository
2. Click on the failed workflow
3. Click "Re-run jobs" or "Re-run all jobs"
4. Monitor the RPC health check step

### 3. **Verify Success**
The workflow should show:
```
✅ RPC health check passed
✅ Block number: 36541588
✅ All verification steps completed
```

## 🔍 **Troubleshooting**

### If RPC Still Fails:

**Check Network Access:**
```bash
# Test from GitHub Actions runner (if you have access)
curl -v https://mainnet.base.org

# Check DNS resolution
nslookup mainnet.base.org
```

**Use Different RPC:**
```bash
# Try Alchemy instead
export RPC_URL_PRIMARY="https://base-mainnet.g.alchemy.com/v2/YOUR_KEY"

# Try Infura instead  
export RPC_URL_PRIMARY="https://base-mainnet.infura.io/v3/YOUR_KEY"
```

**Check Rate Limits:**
- Some RPC providers have rate limits
- Use paid tiers for production
- Consider multiple RPC endpoints for failover

## 📋 **Complete Secret Configuration**

Set these secrets in your repository:

```
ETHERSCAN_API_KEY=your_etherscan_v2_key_here
RPC_URL_PRIMARY=https://mainnet.base.org
RPC_URL_ALCHEMY=https://base-mainnet.g.alchemy.com/v2/YOUR_KEY
RPC_URL_INFURA=https://base-mainnet.infura.io/v3/YOUR_KEY
```

## ✅ **Verification Checklist**

- [ ] `RPC_URL_PRIMARY` secret is set
- [ ] RPC endpoint is accessible from internet
- [ ] RPC returns valid JSON-RPC responses
- [ ] GitHub Actions workflow passes RPC health check
- [ ] All verification steps complete successfully
- [ ] Audit log is generated correctly

## 🚀 **After Fix**

Once the RPC issue is resolved:
1. All GitHub Actions workflows will work
2. Automated verification will run on every push
3. Audit logs will be generated automatically
4. Production deployment will be fully automated

---

**Next Steps:** Set the `RPC_URL_PRIMARY` secret and re-run the failed workflow to verify the fix.
