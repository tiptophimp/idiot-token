# IDIOT Token Ecosystem - Operational Runbook

## 🚀 **Production Deployment Checklist**

### Pre-Deployment
- [ ] Ledger device connected and unlocked
- [ ] Base network configured in Hardhat
- [ ] Environment variables set (.env file)
- [ ] All scripts tested on Base Sepolia
- [ ] Safe multisig addresses confirmed

### Initial Setup
1. **Deploy Initial Position**
   ```bash
   npx hardhat run scripts/uniswapV3_addLiquidity.ts --network base
   ```

2. **Transfer NFT to Safe**
   ```bash
   POSITION_ID=<new_position_id> \
   SAFE_RECIPIENT=0xYourTreasurySafe \
   npx hardhat run scripts/transfer_position.ts --network base
   ```

3. **Lock Approvals**
   ```bash
   npx hardhat run scripts/lock_approvals.ts --network base
   ```

4. **Verify Custody**
   ```bash
   TREASURY_SAFE=0xYourTreasurySafe \
   POSITION_IDS=<position_id> \
   npx hardhat run scripts/verify_custody.ts --network base
   ```

### Daily Operations

#### Morning Checklist
- [ ] Check dashboard health: `curl http://localhost:3000/api/health`
- [ ] Verify position status: `npx hardhat run scripts/uniswapV3_poolInfo.ts --network base`
- [ ] Check range deviation: `npx hardhat run scripts/range_monitor.ts --network base`

#### Weekly Operations
- [ ] Collect fees: `SAFE_RECIPIENT=0xYourTreasurySafe POSITION_IDS=123,124 npx hardhat run scripts/cron_collect_fees.ts --network base`
- [ ] Review audit logs: `cat audit/LP_actions.md`
- [ ] Update monitoring if needed

#### As-Needed Operations
- [ ] Re-center position when SLO violated
- [ ] Update position parameters
- [ ] Emergency procedures if needed

## 🔧 **Automation Setup**

### PM2 (Recommended)
```bash
# Install PM2
npm install -g pm2

# Start dashboard
pm2 start transparency-dashboard/server.js --name idiot-dashboard

# Start fee collector
pm2 start npx --name idiot-fee-collector --interpreter bash -- \
  hardhat run scripts/cron_collect_fees.ts --network base

# Set weekly schedule
pm2 set pm2:cron:idiot-fee-collector "0 13 * * 1"

# Save configuration
pm2 save
pm2 startup
```

### Docker (Alternative)
```bash
# Build image
docker build -t idiot-ecosystem .

# Run dashboard
docker run -d --name idiot-dashboard -p 3000:3000 idiot-ecosystem

# Run fee collector (cron)
docker run -d --name idiot-fee-collector --restart unless-stopped \
  -e RPC_URL=https://mainnet.base.org \
  -e SAFE_RECIPIENT=0xYourTreasurySafe \
  -e POSITION_IDS=123,124 \
  idiot-ecosystem npx hardhat run scripts/cron_collect_fees.ts --network base
```

## 📊 **Monitoring & Alerting**

### Health Checks
- **Dashboard:** `GET /api/health`
- **Pool Data:** `GET /api/pool`
- **Verification:** `GET /api/verification-status`

### Key Metrics
- Position liquidity levels
- Tick range deviation
- Fee accumulation
- Price volatility
- RPC response times

### Alert Conditions
- Tick deviation > 600
- Liquidity = 0
- Dashboard unresponsive
- RPC errors
- Safe transaction alerts

## 🔒 **Security Procedures**

### Access Control
- Ledger device required for all transactions
- Safe multisig for position management
- No private keys in environment
- Regular security audits

### Approval Management
- Lock ERC20 approvals after operations
- Monitor allowance levels
- Revoke unnecessary permissions

### Emergency Response
- Stop all automation immediately
- Assess position status
- Follow rollback playbook
- Notify stakeholders

## 📈 **Performance Optimization**

### Gas Management
- Monitor gas prices
- Use optimal gas settings
- Batch operations when possible
- Schedule during low-cost periods

### RPC Optimization
- Use reliable RPC endpoints
- Implement retry logic
- Monitor response times
- Have backup providers

### Position Management
- Regular re-centering
- Optimal tick ranges
- Fee collection frequency
- Liquidity adjustments

## 🚨 **Emergency Procedures**

### Immediate Response
1. Stop all automation: `pm2 stop all`
2. Assess situation: Check position status
3. Follow rollback playbook
4. Notify team

### Recovery Steps
1. Restore from last known good state
2. Verify position integrity
3. Test all functions
4. Re-enable automation

### Post-Incident
1. Document incident
2. Update procedures
3. Improve monitoring
4. Conduct review

## 📋 **Maintenance Schedule**

### Daily
- Health check dashboard
- Verify position status
- Check range deviation

### Weekly
- Collect accumulated fees
- Review audit logs
- Update monitoring

### Monthly
- Security review
- Performance analysis
- Procedure updates

### Quarterly
- Full system audit
- Disaster recovery test
- Documentation review

## 🔄 **Change Management**

### Before Changes
1. Test on Base Sepolia
2. Document changes
3. Get approval
4. Schedule maintenance window

### During Changes
1. Stop automation
2. Execute changes
3. Verify functionality
4. Update documentation

### After Changes
1. Monitor closely
2. Test all functions
3. Re-enable automation
4. Document results

## 📞 **Support Contacts**

- **Technical Lead:** [Contact Info]
- **Safe Multisig:** [Safe Address]
- **Emergency Wallet:** [Ledger Address]
- **Hosting Provider:** [Support Contact]

## 📚 **Documentation**

- **Setup Guide:** README.md
- **API Reference:** /api/health
- **Scripts:** scripts/README_*.md
- **Rollback:** scripts/rollback_playbook.md
- **Audit Logs:** audit/

---

*This runbook ensures reliable operation of the IDIOT token ecosystem with proper monitoring, security, and maintenance procedures.*
