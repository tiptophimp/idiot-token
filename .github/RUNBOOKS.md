# Operational Runbooks

This document contains operational procedures for the IDIOT token ecosystem CI/CD pipeline.

## Quarterly Disaster Recovery (DR) Drill

### Objective
Simulate RPC outage and BaseScan rate-limit scenarios to verify workflows degrade gracefully.

### Pre-Drill Checklist
- [ ] Notify team of scheduled drill
- [ ] Document current system state
- [ ] Prepare rollback procedures
- [ ] Set up monitoring alerts

### Drill Scenarios

#### Scenario 1: RPC Outage Simulation
1. **Simulate Primary RPC Failure**
   ```bash
   # Temporarily modify RPC_URL_PRIMARY secret to invalid endpoint
   # Trigger workflow and observe behavior
   ```

2. **Expected Behavior**
   - Workflow should fail fast on RPC health check
   - Fallback to secondary RPC endpoints
   - Graceful error handling and logging
   - No data corruption or partial state

3. **Recovery Steps**
   - Restore primary RPC endpoint
   - Verify workflow success
   - Document lessons learned

#### Scenario 2: BaseScan Rate Limit Simulation
1. **Simulate API Rate Limiting**
   ```bash
   # Temporarily modify ETHERSCAN_API_KEY to trigger rate limit
   # Monitor workflow behavior
   ```

2. **Expected Behavior**
   - Workflow should handle rate limit gracefully
   - Retry logic should activate
   - Clear error messages in logs
   - No infinite retry loops

3. **Recovery Steps**
   - Restore valid API key
   - Verify contract verification success
   - Update rate limiting policies if needed

### Post-Drill Actions
- [ ] Document findings and improvements
- [ ] Update runbooks based on learnings
- [ ] Schedule next quarterly drill
- [ ] Share results with team

## Tag Policy and Release Management

### Audit Release Tags
- **Format**: `vYYYY.MM.DD-N`
- **Example**: `v2024.01.15-1`
- **Frequency**: After each successful audit verification

### Tag Creation Process
1. **Automatic Tagging** (via workflow)
   ```yaml
   TAG="audit-v$(date -u +'%Y.%m.%d-%H%M')"
   git tag -a "$TAG" -m "Automated audit verification release - $TAG"
   ```

2. **Manual Tagging** (for special releases)
   ```bash
   git tag -a v2024.01.15-1 -m "Emergency audit release - RPC outage recovery"
   git push origin v2024.01.15-1
   ```

### Release Artifacts
- **Audit Logs**: `audit/vesting_verification_log.md`
- **SBOM**: `sbom.json`
- **Transparency Dashboard**: `docs/transparency/`

## Emergency Response Procedures

### Critical Issues

#### 1. Workflow Failure
**Symptoms**: CI/CD pipeline failing consistently
**Response**:
1. Check GitHub Actions status
2. Review workflow logs for errors
3. Verify secret configuration
4. Test RPC endpoints manually
5. Rollback to last known good state if needed

#### 2. Security Breach
**Symptoms**: Unauthorized access or compromised secrets
**Response**:
1. Immediately revoke compromised secrets
2. Rotate all API keys
3. Review access logs
4. Notify security team
5. Update security policies

#### 3. RPC Outage
**Symptoms**: Blockchain connectivity issues
**Response**:
1. Switch to backup RPC endpoints
2. Monitor primary endpoint recovery
3. Update workflow configuration if needed
4. Document incident and lessons learned

### Escalation Matrix
- **Level 1**: Repository maintainers
- **Level 2**: Security team
- **Level 3**: Organization administrators
- **Level 4**: External security consultants

## Monitoring and Alerting

### Key Metrics
- **Workflow Success Rate**: Target >95%
- **RPC Response Time**: Target <5 seconds
- **API Rate Limit Usage**: Monitor daily
- **Secret Rotation Status**: Quarterly

### Alert Conditions
- Workflow failure rate >10%
- RPC response time >10 seconds
- API rate limit exceeded
- Security policy violations
- Unauthorized access attempts

### Notification Channels
- **Discord**: Real-time alerts
- **Slack**: Operational updates
- **Email**: Critical issues only
- **GitHub Issues**: Detailed incident reports

## Maintenance Procedures

### Daily
- [ ] Check workflow status
- [ ] Monitor RPC health
- [ ] Review security logs
- [ ] Verify secret status

### Weekly
- [ ] Review audit logs
- [ ] Check dependency updates
- [ ] Monitor API usage
- [ ] Update documentation

### Monthly
- [ ] Security audit
- [ ] Performance review
- [ ] Capacity planning
- [ ] Process improvement

### Quarterly
- [ ] Disaster recovery drill
- [ ] Security policy review
- [ ] Toolchain updates
- [ ] Compliance assessment

## Troubleshooting Guide

### Common Issues

#### Workflow Timeout
**Cause**: Long-running operations or resource constraints
**Solution**:
1. Increase timeout limits
2. Optimize workflow steps
3. Use parallel execution
4. Monitor resource usage

#### RPC Connection Issues
**Cause**: Network problems or endpoint unavailability
**Solution**:
1. Check endpoint status
2. Switch to backup endpoints
3. Verify network connectivity
4. Update endpoint configuration

#### Secret Access Denied
**Cause**: Incorrect secret configuration or permissions
**Solution**:
1. Verify secret names
2. Check repository permissions
3. Validate secret values
4. Update access policies

#### Build Failures
**Cause**: Dependency issues or configuration problems
**Solution**:
1. Check package versions
2. Verify Node.js version
3. Clear npm cache
4. Update dependencies

## Contact Information

### Team Contacts
- **Primary Maintainer**: @tiptophimp
- **Security Team**: [security@yourdomain.com]
- **Operations Team**: [ops@yourdomain.com]

### External Resources
- **GitHub Support**: [GitHub Support Portal]
- **BaseScan Support**: [BaseScan Documentation]
- **RPC Providers**: [Alchemy Support], [Infura Support]

---

*This runbook ensures reliable operation and quick response to issues in the IDIOT token ecosystem CI/CD pipeline.*
