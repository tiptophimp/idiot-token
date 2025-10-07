# IDIOT Token Ecosystem - Rollback Playbook

## Emergency Procedures

### 1. Recenter Transaction Failure

**Scenario:** `recenter_liquidity.ts` fails mid-flight, leaving position in inconsistent state.

**Symptoms:**
- Transaction reverted or failed
- Position may have partial liquidity removed
- Fees may be stuck in position

**Recovery Steps:**

1. **Immediate Assessment**
   ```bash
   # Check position status
   npx hardhat run scripts/uniswapV3_poolInfo.ts --network base
   
   # Check position details
   POSITION_ID=123 npx hardhat run scripts/check_position.ts --network base
   ```

2. **Collect Stuck Fees**
   ```bash
   POSITION_ID=123 \
   SAFE_RECIPIENT=0xYourTreasurySafe \
   npx hardhat run scripts/cron_collect_fees.ts --network base
   ```

3. **Verify Balances**
   ```bash
   # Check token balances
   cast call 0x4200000000000000000000000000000000000006 "balanceOf(address)(uint256)" <OWNER> --rpc-url https://mainnet.base.org
   cast call 0xC29EF04CFFe38012dcfc1E96a2B368443f298dE1 "balanceOf(address)(uint256)" <OWNER> --rpc-url https://mainnet.base.org
   ```

4. **Re-mint with Previous Ticks**
   ```bash
   # Use previous tick range from audit log
   TICK_LOWER=previous_lower \
   TICK_UPPER=previous_upper \
   SAFE_RECIPIENT=0xYourTreasurySafe \
   npx hardhat run scripts/uniswapV3_addLiquidity.ts --network base
   ```

5. **Transfer NFT to Safe**
   ```bash
   # After getting new position ID
   npx hardhat run scripts/transfer_position.ts --network base
   ```

### 2. Dashboard Failure

**Scenario:** Transparency dashboard becomes unresponsive or shows incorrect data.

**Symptoms:**
- Dashboard not loading
- Incorrect price data
- API endpoints failing

**Recovery Steps:**

1. **Disable Cron Jobs**
   ```bash
   # Stop PM2 processes
   pm2 stop idiot-fee-collector
   pm2 stop idiot-dashboard
   
   # Or disable cron
   pm2 set pm2:cron:idiot-fee-collector "disabled"
   ```

2. **Redeploy Last Tagged Release**
   ```bash
   # Check available tags
   git tag --list | grep "v1.0-lp-"
   
   # Rollback to last known good
   git checkout v1.0-lp-YYYYMMDD
   
   # Redeploy
   npm install
   pm2 restart idiot-dashboard
   ```

3. **Verify Functionality**
   ```bash
   # Test API endpoints
   curl http://localhost:3000/api/health
   curl http://localhost:3000/api/pool
   curl http://localhost:3000/api/verification-status
   ```

4. **Re-enable Services**
   ```bash
   # Restart cron jobs
   pm2 set pm2:cron:idiot-fee-collector "0 13 * * 1"
   pm2 save
   ```

### 3. Position Compromise

**Scenario:** Position NFT or Safe multisig compromised.

**Symptoms:**
- Unauthorized position changes
- Unexpected fee collections
- Safe transaction alerts

**Recovery Steps:**

1. **Immediate Response**
   ```bash
   # Stop all automated processes
   pm2 stop all
   
   # Check position ownership
   TREASURY_SAFE=0xYourTreasurySafe \
   POSITION_IDS=123,124 \
   npx hardhat run scripts/verify_custody.ts --network base
   ```

2. **Emergency Position Removal**
   ```bash
   # Remove all liquidity immediately
   POSITION_ID=123 \
   npx hardhat run scripts/emergency_remove_liquidity.ts --network base
   ```

3. **Safe Multisig Actions**
   - Review all pending transactions
   - Revoke any unauthorized approvals
   - Update Safe signers if needed

4. **Recreate Position**
   ```bash
   # After securing Safe
   npx hardhat run scripts/uniswapV3_addLiquidity.ts --network base
   ```

### 4. RPC/Network Issues

**Scenario:** Base network RPC issues or high gas prices.

**Symptoms:**
- Transaction timeouts
- High gas price warnings
- RPC connection errors

**Recovery Steps:**

1. **Switch RPC Endpoint**
   ```bash
   # Update .env with backup RPC
   echo "RPC_URL=https://base-mainnet.g.alchemy.com/v2/YOUR_KEY" >> .env
   ```

2. **Retry with Higher Gas**
   ```bash
   # Set higher gas price
   export GAS_PRICE=2000000000  # 2 gwei
   npx hardhat run scripts/cron_collect_fees.ts --network base
   ```

3. **Manual Override**
   ```bash
   # Use cast for direct interaction
   cast send 0x03a520b32C04BF3bEEf7BEb72E919cf822Ed34f1 \
     "collect((uint256,address,uint128,uint128))" \
     "(123,0xYourTreasurySafe,340282366920938463463374607431768211455,340282366920938463463374607431768211455)" \
     --rpc-url https://mainnet.base.org \
     --gas-price 2000000000
   ```

## Prevention Measures

### 1. Monitoring Setup
- Set up alerts for position changes
- Monitor gas prices
- Track RPC health

### 2. Backup Procedures
- Regular position snapshots
- Safe transaction logs
- RPC endpoint rotation

### 3. Testing
- Test rollback procedures on Base Sepolia
- Verify emergency scripts work
- Document all recovery steps

## Emergency Contacts

- **Technical Lead:** [Contact Info]
- **Safe Multisig:** [Safe Address]
- **Emergency Wallet:** [Ledger Address]

## Recovery Verification

After any rollback, verify:
- [ ] Position ownership correct
- [ ] Liquidity levels appropriate
- [ ] Fee collection working
- [ ] Dashboard functional
- [ ] All services running
- [ ] Audit logs updated

---

*This playbook ensures rapid recovery from any operational issues in the IDIOT token ecosystem.*
