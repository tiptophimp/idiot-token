# GitHub Actions Workflows

This repository uses a hardened CI/CD pipeline with least privilege permissions and proper secret management.

## Workflow Overview

### 1. CI Workflow (`ci.yml`)
**Purpose:** Continuous Integration for all pushes and pull requests

**Triggers:**
- Push to `main` branch
- Pull requests
- Manual dispatch

**Features:**
- Build and test on every change
- Contract verification on main branch
- Timeout protection (25 minutes)
- Concurrency control (cancels in-progress runs)
- Least privilege permissions

**Environment Variables:**
```yaml
env:
  ETHERSCAN_API_KEY: ${{ secrets.BASESCAN_API_KEY }}
  RPC_URL_PRIMARY:  ${{ secrets.RPC_URL_PRIMARY }}
  RPC_URL_ALCHEMY:  ${{ secrets.RPC_URL_ALCHEMY }}
  RPC_URL_INFURA:   ${{ secrets.RPC_URL_INFURA }}
```

### 2. Release Workflow (`release.yml`)
**Purpose:** Automated releases when tags are pushed

**Triggers:**
- Push tags matching `v*` pattern

**Features:**
- Creates GitHub releases
- Packages audit artifacts
- Minimal permissions (contents: write only)

### 3. Audit Verification (`verify_audit.yml`)
**Purpose:** Comprehensive contract verification and audit generation

**Triggers:**
- Push to `main` branch
- Manual dispatch

**Features:**
- Contract verification on BaseScan
- Audit log generation
- IPFS upload (optional)
- GitHub release creation
- Discord/Slack notifications
- Full audit trail

## Security Features

### Least Privilege Permissions
- **CI:** `contents: read`, `pull-requests: read`
- **Release:** `contents: write` (only when needed)
- **Audit:** `contents: write`, `actions: write`, `pull-requests: write`

### Secret Management
- All secrets properly mapped
- No hardcoded credentials
- Environment-specific configuration
- Backup RPC endpoints for reliability

### Concurrency Control
- Prevents multiple runs of same workflow
- Cancels in-progress runs on new pushes
- Resource optimization

## Required Secrets

### Essential
- `BASESCAN_API_KEY` - BaseScan API key
- `RPC_URL_PRIMARY` - Primary Base RPC endpoint
- `RPC_URL_ALCHEMY` - Alchemy RPC (backup)
- `RPC_URL_INFURA` - Infura RPC (backup)

### Optional
- `IPFS_PROJECT_ID` - For decentralized storage
- `IPFS_PROJECT_SECRET` - IPFS authentication
- `DISCORD_WEBHOOK_URL` - Notifications
- `SLACK_WEBHOOK_URL` - Notifications

## Workflow Dependencies

### Foundry Installation
All workflows install Foundry for `cast` commands:
```yaml
- name: Install Foundry
  run: |
    curl -L https://foundry.paradigm.xyz | bash
    echo "$HOME/.foundry/bin" >> $GITHUB_PATH
    foundryup
    cast --version
```

### Node.js Setup
- Node.js 20 with npm caching
- Consistent across all workflows
- Optimized for performance

## Monitoring and Alerts

### Success Indicators
- ✅ All tests pass
- ✅ Contracts verified on BaseScan
- ✅ Audit logs generated
- ✅ Releases created (if applicable)

### Failure Handling
- Timeout protection (25 minutes)
- Graceful degradation for optional features
- Comprehensive error logging
- Notification alerts (if configured)

## Best Practices

### Security
- Use environment-specific secrets
- Rotate API keys regularly
- Monitor usage and rate limits
- Never commit secrets to repository

### Performance
- Use npm caching for faster builds
- Parallel job execution where possible
- Timeout protection prevents hanging
- Concurrency control optimizes resources

### Reliability
- Multiple RPC endpoints for redundancy
- Graceful handling of optional features
- Comprehensive error reporting
- Audit trail for all operations

## Troubleshooting

### Common Issues
1. **API Key Errors:** Check secret configuration
2. **RPC Timeouts:** Verify endpoint availability
3. **Foundry Issues:** Ensure proper installation
4. **Permission Errors:** Verify workflow permissions

### Debug Steps
1. Check workflow logs for specific errors
2. Verify all required secrets are set
3. Test API endpoints manually
4. Review permission configurations

---

*This hardened CI/CD pipeline ensures reliable, secure, and efficient deployment of the IDIOT token ecosystem.*
