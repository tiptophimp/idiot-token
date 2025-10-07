# Etherscan V2 API Migration Guide

## Overview

Etherscan V2 API provides a unified interface for accessing multiple blockchain networks with a single API key. This migration consolidates all chain-specific APIs into one endpoint.

## Migration Benefits

- **Single API Key**: Use one Etherscan API key for all supported chains
- **Unified Endpoint**: All requests go through `https://api.etherscan.io/v2/api`
- **Chain-Specific**: Use `chainid` parameter to specify the target chain
- **Simplified Configuration**: Reduced complexity in multi-chain applications

## API Endpoint Format

### V1 (Legacy)
```
https://api.basescan.org/api
https://api.polygonscan.com/api
https://api.arbiscan.io/api
```

### V2 (New)
```
https://api.etherscan.io/v2/api?chainid=8453
https://api.etherscan.io/v2/api?chainid=137
https://api.etherscan.io/v2/api?chainid=42161
```

## Supported Chains

| Chain Name | Chain ID | Explorer URL |
|------------|----------|--------------|
| Ethereum | 1 | https://etherscan.io |
| Polygon | 137 | https://polygonscan.com |
| BSC | 56 | https://bscscan.com |
| Arbitrum | 42161 | https://arbiscan.io |
| Optimism | 10 | https://optimistic.etherscan.io |
| Base | 8453 | https://basescan.org |
| Base Sepolia | 84532 | https://sepolia.basescan.org |
| Avalanche | 43114 | https://snowtrace.io |

## Implementation Examples

### JavaScript/Node.js

```javascript
async function getBalance(address, chainId, apiKey) {
  const url = `https://api.etherscan.io/v2/api?chainid=${chainId}&module=account&action=balance&address=${address}&tag=latest&apikey=${apiKey}`;
  
  const response = await fetch(url);
  const data = await response.json();
  
  return data.result;
}

// Usage
const balance = await getBalance('0x...', 8453, 'YourApiKey');
```

### Hardhat Configuration

```javascript
// hardhat.config.js
module.exports = {
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY,
    customChains: [
      {
        network: "base",
        chainId: 8453,
        urls: {
          apiURL: "https://api.etherscan.io/v2/api?chainid=8453",
          browserURL: "https://basescan.org",
        },
      },
    ],
  },
};
```

### Python

```python
import requests

def get_balance(address, chain_id, api_key):
    url = f"https://api.etherscan.io/v2/api?chainid={chain_id}&module=account&action=balance&address={address}&tag=latest&apikey={api_key}"
    
    response = requests.get(url)
    data = response.json()
    
    return data['result']

# Usage
balance = get_balance('0x...', 8453, 'YourApiKey')
```

## Common API Modules

### Account Operations
- `balance` - Get account balance
- `txlist` - Get transaction list
- `txlistinternal` - Get internal transactions
- `tokentx` - Get token transfers

### Contract Operations
- `getabi` - Get contract ABI
- `getsourcecode` - Get contract source code
- `verify` - Verify contract source code

### Block Operations
- `getblocknobytime` - Get block number by timestamp
- `getblockcountdown` - Get block countdown

## Error Handling

```javascript
async function safeApiCall(url) {
  try {
    const response = await fetch(url);
    const data = await response.json();
    
    if (data.status === '1') {
      return { success: true, data: data.result };
    } else {
      return { success: false, error: data.message };
    }
  } catch (error) {
    return { success: false, error: error.message };
  }
}
```

## Rate Limits

- **Free Tier**: 5 calls/second, 100,000 calls/day
- **Pro Tier**: 20 calls/second, 1,000,000 calls/day
- **Enterprise**: Custom limits

## Migration Checklist

- [ ] Update API endpoints to V2 format
- [ ] Add `chainid` parameter to all requests
- [ ] Update Hardhat configuration
- [ ] Test all chain-specific operations
- [ ] Update error handling for new response format
- [ ] Verify rate limiting behavior
- [ ] Update documentation

## Testing

Use the provided test script to verify V2 API functionality:

```bash
node scripts/test_etherscan_v2.js
```

## Troubleshooting

### Common Issues

1. **Invalid API Key**: Ensure you're using a valid Etherscan API key
2. **Chain Not Supported**: Verify the chain ID is supported
3. **Rate Limiting**: Implement proper rate limiting and retry logic
4. **Network Issues**: Add timeout and retry mechanisms

### Debug Mode

Enable debug logging to troubleshoot API calls:

```javascript
const DEBUG = process.env.DEBUG_ETHERSCAN === 'true';

if (DEBUG) {
  console.log('API Call:', url);
  console.log('Response:', data);
}
```

## Resources

- [Etherscan API Documentation](https://docs.etherscan.io/)
- [V2 API Migration Guide](https://docs.etherscan.io/v2-api-migration)
- [Supported Networks](https://docs.etherscan.io/supported-networks)
- [Rate Limits](https://docs.etherscan.io/rate-limits)
