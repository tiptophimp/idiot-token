# 🔐 GitHub Secrets Setup Guide

This guide will help you configure the required secrets for the IDIOT token verification workflow to run successfully.

## 📋 Required Secrets

You need to add these secrets to your GitHub repository:

### 1. **PRIVATE_KEY** (Required)
- **Purpose**: Deployer private key for contract verification
- **Format**: `0x...` (64 character hex string)
- **How to get**: Export from your wallet (MetaMask, etc.)
- **Security**: ⚠️ **CRITICAL** - Never share this key publicly

### 2. **BASESCAN_API_KEY** (Required)
- **Purpose**: API key for BaseScan contract verification
- **How to get**:
  1. Visit [https://basescan.org/apis](https://basescan.org/apis)
  2. Create an account or log in
  3. Generate a new API key
  4. Copy the key (starts with letters/numbers)
- **Format**: Alphanumeric string (e.g., `ABC123DEF456...`)

### 3. **DISCORD_WEBHOOK_URL** (Optional)
- **Purpose**: Send verification notifications to Discord
- **How to get**:
  1. Go to your Discord server settings
  2. Navigate to Integrations → Webhooks
  3. Create a new webhook
  4. Copy the webhook URL
- **Format**: `https://discord.com/api/webhooks/xxxxx/yyyyy`

### 4. **SLACK_WEBHOOK_URL** (Optional)
- **Purpose**: Send verification notifications to Slack
- **How to get**:
  1. Go to your Slack workspace
  2. Create a new app or use existing one
  3. Enable Incoming Webhooks
  4. Create a webhook URL
- **Format**: `https://hooks.slack.com/services/xxxxx/yyyyy`

### 5. **IPFS_PROJECT_ID** (Optional)
- **Purpose**: Infura IPFS project ID for immutable storage
- **How to get**:
  1. Visit [https://infura.io](https://infura.io)
  2. Create an account or log in
  3. Create a new IPFS project
  4. Copy the Project ID
- **Format**: UUID string (e.g., `2ABC123DEF456...`)

### 6. **IPFS_PROJECT_SECRET** (Optional)
- **Purpose**: Infura IPFS project secret for authentication
- **How to get**:
  1. Same as above - in your Infura IPFS project
  2. Copy the Project Secret
- **Format**: Long alphanumeric string

## 🚀 How to Add Secrets

1. **Go to your GitHub repository**
2. **Click on "Settings" tab**
3. **In the left sidebar, click "Secrets and variables" → "Actions"**
4. **Click "New repository secret"**
5. **Add each secret one by one:**
   - Name: `PRIVATE_KEY`
   - Value: `0x...` (your private key)
   - Click "Add secret"
6. **Repeat for all required secrets**

## ✅ Verification

After adding all secrets, the workflow will:
- ✅ Verify contracts on BaseScan
- ✅ Generate audit logs
- ✅ Upload to IPFS (if configured)
- ✅ Send notifications (if configured)
- ✅ Create GitHub releases
- ✅ Update transparency page

## 🔒 Security Notes

- **Never commit private keys to code**
- **Use GitHub Secrets for all sensitive data**
- **Rotate keys regularly**
- **Monitor secret usage in Actions logs**

## 🆘 Troubleshooting

### "API token not found" error
- Check that `BASESCAN_API_KEY` is correctly set
- Verify the API key is valid on BaseScan

### "Write access not granted" error
- The workflow now has proper permissions configured
- This should be resolved automatically

### "IPFS project id required" error
- Add `IPFS_PROJECT_ID` and `IPFS_PROJECT_SECRET` secrets
- Or remove IPFS upload step if not needed

### "Webhook failed" error
- Check webhook URLs are correct
- Test webhooks manually first

## 📞 Support

If you encounter issues:
1. Check the Actions tab for detailed error logs
2. Verify all secrets are correctly set
3. Test individual components locally first
4. Review this guide for missing steps

---

**Ready to deploy?** Once all secrets are configured, push to the main branch to trigger the verification workflow! 🚀