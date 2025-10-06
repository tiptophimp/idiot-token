# IDIOT Token Verification System - Maintenance Guide

## 🔄 Daily Operations

### ✅ **Primary Workflow**
1. **Run Verification**: `Ctrl + Shift + P` → Tasks → "Verify + Audit + Notify"
2. **Review Logs**: Check Cursor terminal output
3. **Confirm External Proof**:
   - BaseScan: Visit each contract address → "Contract" → "Code"
   - Discord/Slack: Check for confirmation message
   - IPFS: Note the immutable CID printed at end of run

### 🔁 **IPFS Integrity Check**
- **Run**: `Ctrl + Shift + P` → Tasks → "Revalidate Audit on IPFS"
- **Purpose**: Verify audit file hasn't changed since last IPFS upload
- **Output**: Current CID, integrity status, accessibility check

### 🛠️ **If Network Drops**
1. `Ctrl + Shift + P` → "Developer: Reload Window"
2. Re-run "Verify + Audit + Notify" task
3. Automatic retry logic will resume verification

## 🧩 **Maintenance Tasks**

### 📦 **Dependency Updates**
**Monthly** - Keep packages current:
```bash
# Via Cursor Task
Ctrl + Shift + P → Tasks → "Update Dependencies"

# Or manually
npm update @nomicfoundation/hardhat-verify dotenv node-fetch ipfs-http-client
```

**Check for major updates**:
```bash
npm outdated
npm audit
```

### 🔑 **Security Rotation**
**Quarterly** - Rotate sensitive credentials:

1. **BaseScan API Key**:
   - Visit https://basescan.org/apis
   - Generate new API key
   - Update `.env` file
   - Test with verification task

2. **Webhook URLs**:
   - Update Discord/Slack webhook URLs
   - Test notifications
   - Update `.env` file

3. **Private Key** (if needed):
   - Generate new deployer key
   - Update `.env` file
   - Ensure key has proper permissions

### 💾 **Backup Strategy**
**Weekly** - Snapshot audit data:

```bash
# Create timestamped backup
tar -czf "audit_backup_$(date +%Y%m%d).tar.gz" audit/

# Or copy to external storage
cp -r audit/ /path/to/external/backup/
```

**Monthly** - Full project backup:
```bash
# Backup entire project
tar -czf "idiot_verification_$(date +%Y%m%d).tar.gz" \
  --exclude=node_modules \
  --exclude=.git \
  .
```

### 🔍 **Health Checks**

#### **Weekly Verification**
- Run main verification task
- Check all 4 contracts are verified on BaseScan
- Verify webhook notifications are working
- Confirm IPFS uploads are accessible

#### **Monthly Deep Check**
- Review audit logs for any anomalies
- Test IPFS integrity verification
- Check dependency security updates
- Verify all environment variables are current

#### **Quarterly Security Review**
- Rotate all API keys and webhooks
- Review contract addresses for any changes
- Update documentation if needed
- Test disaster recovery procedures

## 🚨 **Troubleshooting**

### **Common Issues & Solutions**

#### **"Contract verification failed"**
```bash
# Check network connection
ping mainnet.base.org

# Verify API key
echo $BASESCAN_API_KEY

# Try manual verification
npx hardhat verify --network base <ADDRESS> <ARGS>
```

#### **"IPFS upload failed"**
```bash
# Check IPFS gateway
curl -s https://ipfs.infura.io:5001/api/v0/version

# Try alternative gateway
# Update script to use different IPFS endpoint
```

#### **"Webhook notification failed"**
```bash
# Test webhook manually
curl -X POST -H "Content-Type: application/json" \
  -d '{"content":"Test message"}' \
  $DISCORD_WEBHOOK_URL
```

#### **"Cast command not found"**
```bash
# Reinstall Foundry
npm install --global foundryup
foundryup

# Verify installation
cast --version
```

### **Emergency Procedures**

#### **If Verification System Fails Completely**
1. **Manual Verification**:
   ```bash
   npx hardhat verify --network base 0x6AD03686ab6c3bA2c77992995E4879c62dE88996 0xTR_SAFE 1770076800 94608000
   ```

2. **Manual Audit Log**:
   - Create `audit/vesting_verification_log.md` manually
   - Include all contract details and verification status
   - Upload to IPFS manually if needed

3. **Notification**:
   - Send manual notification to team
   - Document the issue and resolution

## 📊 **Monitoring & Alerts**

### **Automated Monitoring** (Optional)
Set up monitoring for:
- Contract verification status changes
- IPFS availability
- Webhook delivery failures
- API key expiration

### **Log Analysis**
Review logs for:
- Repeated verification failures
- Network timeout patterns
- IPFS upload inconsistencies
- Webhook delivery issues

## 🔧 **System Optimization**

### **Performance Tuning**
- **Parallel Verification**: Modify script to verify contracts in parallel
- **Caching**: Cache contract ABIs and owner addresses
- **Rate Limiting**: Add delays between API calls if needed

### **Reliability Improvements**
- **Multiple IPFS Gateways**: Add fallback IPFS endpoints
- **Retry Logic**: Enhance retry mechanisms for different error types
- **Health Checks**: Add pre-flight checks before verification

## 📋 **Maintenance Checklist**

### **Daily** ✅
- [ ] Run verification task
- [ ] Check all contracts verified on BaseScan
- [ ] Confirm webhook notifications received
- [ ] Note IPFS CID for audit log

### **Weekly** ✅
- [ ] Review audit logs
- [ ] Test IPFS integrity verification
- [ ] Check for dependency updates
- [ ] Backup audit directory

### **Monthly** ✅
- [ ] Update dependencies
- [ ] Review security settings
- [ ] Test disaster recovery
- [ ] Full project backup

### **Quarterly** ✅
- [ ] Rotate API keys and webhooks
- [ ] Security review
- [ ] Update documentation
- [ ] Test all system components

---

## 🎯 **Success Metrics**

Track these KPIs to ensure system health:
- **Verification Success Rate**: >99%
- **IPFS Upload Success**: >95%
- **Webhook Delivery**: >98%
- **System Uptime**: >99.5%
- **Audit Log Integrity**: 100%

*This maintenance guide ensures your IDIOT token verification system remains reliable, secure, and up-to-date.*
