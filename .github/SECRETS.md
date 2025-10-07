# GitHub Secrets Configuration

This repository requires the following secrets to be configured in GitHub Actions:

## Required Secrets

### 1. ETHERSCAN_API_KEY (or BASESCAN_API_KEY)
- **Description:** BaseScan API key for contract verification
- **How to get:** Visit https://basescan.org/apis and create an account
- **Usage:** Used for verifying smart contracts on Base network
- **Mapping:** `ETHERSCAN_API_KEY: ${{ secrets.BASESCAN_API_KEY }}`
- **Example:** `ABC123DEF456...`

### 2. RPC_URL_PRIMARY
- **Description:** Primary RPC endpoint for Base network
- **How to get:** Use Base official RPC or get from Alchemy/Infura
- **Usage:** Primary blockchain connection for verification
- **Example:** `https://mainnet.base.org`

### 3. RPC_URL_ALCHEMY
- **Description:** Alchemy RPC endpoint for Base network (backup)
- **How to get:** Create project at https://alchemy.com
- **Usage:** Backup RPC endpoint for reliability
- **Example:** `https://base-mainnet.g.alchemy.com/v2/YOUR_KEY`

### 4. RPC_URL_INFURA
- **Description:** Infura RPC endpoint for Base network (backup)
- **How to get:** Create project at https://infura.io
- **Usage:** Backup RPC endpoint for reliability
- **Example:** `https://base-mainnet.infura.io/v3/YOUR_KEY`

## Optional Secrets

### 5. IPFS_PROJECT_ID (Optional)
- **Description:** Infura IPFS project ID for decentralized storage
- **How to get:** Visit https://infura.io and create an IPFS project
- **Usage:** Used for uploading audit logs to IPFS
- **Example:** `2ABC123DEF456...`

### 6. IPFS_PROJECT_SECRET (Optional)
- **Description:** Infura IPFS project secret
- **How to get:** Generated when creating IPFS project on Infura
- **Usage:** Authentication for IPFS uploads
- **Example:** `xyz789abc123...`

### 7. DISCORD_WEBHOOK_URL (Optional)
- **Description:** Discord webhook URL for notifications
- **How to get:** Create webhook in Discord server settings
- **Usage:** Sends audit completion notifications
- **Example:** `https://discord.com/api/webhooks/123456789/...`

### 8. SLACK_WEBHOOK_URL (Optional)
- **Description:** Slack webhook URL for notifications
- **How to get:** Create incoming webhook in Slack app settings
- **Usage:** Sends audit completion notifications
- **Example:** `https://hooks.slack.com/services/...`

## How to Add Secrets

1. Go to your GitHub repository
2. Click on "Settings" tab
3. Click on "Secrets and variables" → "Actions"
4. Click "New repository secret"
5. Enter the secret name and value
6. Click "Add secret"

## Testing Secrets

The workflow includes a test step that validates the API key:

```yaml
- name: 🧪 Test API Key
  env:
    BASESCAN_API_KEY: ${{ secrets.BASESCAN_API_KEY }}
  run: |
    node scripts/test-github-api.js
```

## Security Notes

- Never commit API keys to the repository
- Use GitHub Secrets for all sensitive data
- Rotate API keys regularly
- Monitor API usage and rate limits

## Troubleshooting

### API Key Issues
- Verify the key is correct and active
- Check rate limits on BaseScan
- Ensure the key has proper permissions

### IPFS Issues
- Verify project ID and secret are correct
- Check Infura account status
- Ensure sufficient credits for uploads

### Webhook Issues
- Test webhook URLs manually
- Check Discord/Slack app permissions
- Verify webhook is not disabled
