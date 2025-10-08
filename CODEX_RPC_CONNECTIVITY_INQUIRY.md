# Codex RPC Connectivity Inquiry
**Prepared by:** Novalex  
**Date:** See `config/official_time.json` (last verified Wed, 08 Oct 2025 17:25 UTC)

---

## 📋 Critical Issue Summary
- GitHub Actions deployments to Base Mainnet are failing because RPC health checks time out before contract verification.
- Automatic promotion from staging to production is blocked while the workflow waits for an RPC heartbeat that never returns.
- Developers must manually re-run jobs, delaying hotfix rollouts and degrading deployment confidence.

## 🧪 Technical Details
- **Affected Workflows:** `deploy-base.yml`, `simulate-and-verify.yml`
- **Endpoints Observed:**
  - `https://mainnet.base.org`
  - `https://base-mainnet.g.alchemy.com/v2/${ALCHEMY_KEY}`
- **Error Patterns:**
  - `ECONNRESET` during initial JSON-RPC handshake
  - 504 gateway timeouts after ~45 seconds
  - Intermittent DNS resolution failures recorded in Actions logs

## 🛠️ Current Workaround
- RPC health checks inside `deploy-base.yml` are now non-blocking. Failed pings emit warnings but allow the deployment to proceed.
- Jobs record telemetry to the `artifacts/rpc-health` folder for offline review.
- On-call engineers manually test RPC connectivity using `scripts/check-rpc.js` before approving production promotion.

## 🔍 Investigation Requests for Codex
1. Validate that each configured RPC endpoint resolves and accepts standard `eth_chainId` requests.
2. Inspect GitHub Actions network egress restrictions applied to the `production-deploy` environment.
3. Confirm that stored secrets (`BASE_MAINNET_RPC`, `ALCHEMY_API_KEY`) are correctly formatted and decrypt without trailing whitespace.
4. Review Base network documentation for any newly required headers or rate-limit tokens introduced in January 2025.

## 💡 Proposed Solutions
### Immediate
- Introduce exponential backoff with jitter for RPC retries inside deployment scripts.
- Add a redundant provider (e.g., Infura or Blast) and fail over automatically when health checks fail.

### Long-Term
- Implement a scheduled canary job that exercises all RPC providers every 5 minutes and publishes metrics to the transparency dashboard.
- Migrate sensitive secrets into GitHub OIDC + cloud secret manager to reduce formatting drift.
- Coordinate with Base to enroll in their dedicated infrastructure program for higher rate limits.

## ✅ Success Criteria
- Deployment workflows complete without manual restarts for five consecutive runs.
- Average RPC handshake latency stays below 5 seconds, monitored via the canary job.
- No `ECONNRESET` or 504 errors observed in GitHub Actions logs for a 7-day rolling window.
- Secrets audit confirms consistent formatting and rotation schedule.

---
For background procedures see `OPERATIONAL_RUNBOOK.md` and cross-reference permanent guidance in `NOVALEX_CONFIG.md`.