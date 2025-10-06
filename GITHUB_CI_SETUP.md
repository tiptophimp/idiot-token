# GitHub CI Integration Setup

Complete autonomous verification pipeline that runs every time code changes or deployments occur.

## 🧠 Goal

Automate the same process you trigger manually in Cursor:
- ✅ Verify vesting contracts
- ✅ Create and store audit logs  
- ✅ Post to Discord/Slack
- ✅ Upload immutable proof to IPFS

Everything happens automatically via GitHub Actions.

## 🗂️ Repository Structure

```
idiot-token/
├── .github/
│   └── workflows/
│       └── verify_audit.yml          # Main CI workflow
├── scripts/
│   ├── verifyAuditNotify.js          # Enhanced verification script
│   ├── ci-setup.js                   # CI setup and validation
│   ├── ipfsVerify.js                 # IPFS integrity check
│   └── healthCheck.js                # System health diagnostics
├── audit/                            # Generated audit logs
├── .env.example                      # Environment template
└── README_CURSOR_INTEGRATION.md      # Cursor integration docs
```

## ⚙️ GitHub Action: verify_audit.yml

The workflow automatically:
- **Triggers**: On push to main, pull requests, or manual dispatch
- **Runs**: Contract verification on multiple Node.js versions (18, 20)
- **Verifies**: All 4 vesting contracts on BaseScan
- **Creates**: Comprehensive audit logs
- **Uploads**: Audit logs as GitHub artifacts
- **Stores**: Immutable proof on IPFS
- **Notifies**: Discord/Slack on success/failure
- **Comments**: PR with verification results

### Key Features:
- **Matrix Strategy**: Tests on Node.js 18 and 20
- **Manual Dispatch**: Run with custom network selection
- **Force Verify**: Option to re-verify already verified contracts
- **Artifact Storage**: 30-day retention of audit logs
- **PR Comments**: Automatic status updates on pull requests
- **Failure Notifications**: Webhook alerts on errors

## 🔐 GitHub Secrets Setup

### Required Secrets

In your GitHub repository:
1. Go to **Settings** → **Secrets and variables** → **Actions**
2. Click **New repository secret**
3. Add these secrets:

| Secret Name | Description | Example |
|-------------|-------------|---------|
| `PRIVATE_KEY` | Deployer private key | `0x1234...` |
| `BASESCAN_API_KEY` | BaseScan API key | `ABC123...` |
| `DISCORD_WEBHOOK_URL` | Discord webhook URL | `https://discord.com/api/webhooks/...` |
| `SLACK_WEBHOOK_URL` | Slack webhook URL | `https://hooks.slack.com/services/...` |

### Getting API Keys

**BaseScan API Key:**
1. Visit https://basescan.org/apis
2. Create account and generate API key
3. Add as `BASESCAN_API_KEY` secret

**Discord Webhook:**
1. Go to Discord server settings
2. Integrations → Webhooks → New Webhook
3. Copy webhook URL
4. Add as `DISCORD_WEBHOOK_URL` secret

**Slack Webhook:**
1. Go to Slack app settings
2. Incoming Webhooks → Add to Slack
3. Copy webhook URL
4. Add as `SLACK_WEBHOOK_URL` secret

## 🧾 Workflow Triggers

### Automatic Triggers
- **Push to main**: Runs on every commit to main branch
- **Pull Requests**: Runs on PRs targeting main branch

### Manual Triggers
- **Workflow Dispatch**: Run manually from GitHub Actions tab
- **Network Selection**: Choose between `base` and `baseSepolia`
- **Force Verify**: Option to re-verify already verified contracts

## 🪣 Workflow Outputs

### After Each Run:

#### **GitHub Artifacts**
- **Location**: Actions → [Workflow Run] → Artifacts
- **Files**: `audit-log-[run-number]-[node-version]`
- **Contents**: 
  - `vesting_verification_log.md` - Complete audit log
  - `last_ipfs_cid.txt` - IPFS content identifier
- **Retention**: 30 days

#### **Discord/Slack Notifications**
- **Success**: Contract verification status with IPFS links
- **Failure**: Error details with workflow information
- **PR Updates**: Verification results posted as PR comments

#### **BaseScan Verification**
- **Automatic**: All contracts verified if changed
- **Status**: "Contract Source Code Verified" on BaseScan
- **Links**: Direct links to verified contracts

#### **IPFS Storage**
- **Automatic**: Audit logs uploaded to IPFS
- **CID**: Content identifier printed in workflow logs
- **URLs**: Public IPFS gateway links available

## 🧰 Enhanced Features

### **Multi-Node Testing**
- Tests on Node.js 18 and 20
- Ensures compatibility across versions
- Parallel execution for faster results

### **Smart Verification**
- Skips already verified contracts (unless forced)
- Handles network timeouts gracefully
- Automatic retry logic for failed verifications

### **Comprehensive Logging**
- Detailed step-by-step progress
- Error handling with context
- Performance metrics and timing

### **PR Integration**
- Automatic comments with verification results
- Status badges and summaries
- Direct links to artifacts and IPFS

## ✅ Verification Checklist

### **After Setting Up GitHub Actions:**

1. **Check Workflow File**
   - [ ] `.github/workflows/verify_audit.yml` exists
   - [ ] Workflow syntax is valid
   - [ ] All required steps are present

2. **Verify Secrets**
   - [ ] All 4 secrets added to repository
   - [ ] Secrets have correct values
   - [ ] No placeholder values remain

3. **Test Workflow**
   - [ ] Go to Actions tab in GitHub
   - [ ] Trigger manual workflow run
   - [ ] Watch workflow execute successfully

4. **Confirm Outputs**
   - [ ] Audit artifacts are created
   - [ ] Discord/Slack receives notification
   - [ ] BaseScan shows verified contracts
   - [ ] IPFS CID is generated

5. **Test PR Integration**
   - [ ] Create test pull request
   - [ ] Verify workflow runs on PR
   - [ ] Check PR comment is posted

## 🚀 Usage Examples

### **Manual Workflow Run**
1. Go to **Actions** tab in GitHub
2. Select **IDIOT Contract Verification**
3. Click **Run workflow**
4. Choose network (`base` or `baseSepolia`)
5. Optionally enable **Force verify**
6. Click **Run workflow**

### **Automatic Runs**
- **Push to main**: Workflow runs automatically
- **Pull Request**: Workflow runs and comments on PR
- **Scheduled**: Can be extended with cron triggers

### **Monitoring**
- **Workflow Status**: Check Actions tab for run status
- **Notifications**: Monitor Discord/Slack for alerts
- **Artifacts**: Download audit logs from Actions
- **IPFS**: Verify immutable storage via CID

## 🔧 Troubleshooting

### **Common Issues**

#### **"Secrets not found"**
- Verify secrets are added to repository settings
- Check secret names match exactly (case-sensitive)
- Ensure secrets don't contain extra spaces

#### **"Contract verification failed"**
- Check BaseScan API key is valid
- Verify private key has correct permissions
- Ensure network connectivity

#### **"IPFS upload failed"**
- Check IPFS gateway availability
- Verify network connectivity
- Review IPFS client configuration

#### **"Webhook notification failed"**
- Verify webhook URLs are correct
- Test webhooks manually
- Check Discord/Slack app permissions

### **Debug Steps**

1. **Check Workflow Logs**
   - Go to Actions → Failed workflow
   - Review step-by-step logs
   - Look for error messages

2. **Test Locally**
   - Run `node scripts/ci-setup.js`
   - Verify environment variables
   - Test individual components

3. **Validate Secrets**
   - Test API keys manually
   - Verify webhook URLs
   - Check private key format

## 📊 Success Metrics

Track these KPIs for CI/CD health:
- **Workflow Success Rate**: >95%
- **Verification Success**: >99%
- **IPFS Upload Success**: >90%
- **Webhook Delivery**: >98%
- **Average Run Time**: <5 minutes

## 🎯 Next Steps

### **Immediate Actions**
1. Add GitHub secrets to your repository
2. Push the workflow file to main branch
3. Test manual workflow run
4. Verify all outputs are working

### **Optional Enhancements**
- **Scheduled Runs**: Add cron triggers for regular verification
- **Matrix Expansion**: Test on additional Node.js versions
- **Slack Integration**: Add Slack app for richer notifications
- **Monitoring**: Set up alerts for workflow failures

---

## 🎉 Result

You now have:

- **Cursor**: One-click manual control
- **GitHub Actions**: Continuous verification and immutable audit pipeline
- **Shared Scripts**: No duplicated logic between systems
- **Full Automation**: Verification runs on every code change
- **Immutable Proof**: IPFS storage for compliance
- **Team Notifications**: Discord/Slack integration

The system provides complete automation while maintaining the flexibility of manual execution through Cursor!