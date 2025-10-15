### Update Summary — stupidiots.com — 2025-10-14

Prepared by: Novalex

---

### Current Status
- Production (`https://stupidiots.com`) is live on DigitalOcean droplet `68.183.149.106`.
- DNS A record now resolves to `68.183.149.106` globally; `www` points to root.
- HTTPS is valid via Let’s Encrypt (CN: stupidiots.com). HTTP redirects to HTTPS.
- Staging is active at `https://stupidiots.com/staging` serving from `/var/www/staging`.
- Nginx server block present for stupidiots.com; reloads succeed.
- GitHub Actions CI added to deploy `public_html/` to production on push to `main`.

---

### Changes Made Today
- Added deploy tooling and docs:
  - `scripts/dns_check_stupidiots.sh` — DNS propagation/health checks
  - `scripts/deploy_to_droplet.sh` — rsync deploy of `public_html` to droplet
  - `deploy/nginx/stupidiots.com.conf` — Nginx site config (HTTP, TLS via certbot)
  - `docs/deploy/DNS_VERIFICATION.md`, `docs/deploy/TROUBLESHOOTING.md`, `docs/deploy/CI_SETUP.md`
  - GitHub Actions workflow: `.github/workflows/deploy.yml`
- Server: ensured SSH access; configured `deploy` user with limited sudo for Nginx reloads.
- Verified staging directory and endpoint; confirmed cache-control headers (no-cache) on staging.
- Confirmed certificate issuance and site returning 200 over HTTPS.

---

### Critical Project Constraints (Do Not Change)
- File structure is a single HTML-based site; keep exact paths:
  - Working file: `stupidiots_one_page_static_site_index.html`
  - Upload/live: `index.html` (root of `public_html/`)
  - Hero background: `ChatGPT Image Sep 28, 2025, 04_50_50 PM.png` (exact name)
  - Airdrop paths:
    - Rules: `/airdrop/idiocracy`
    - Proofs: `/airdrop/idiocracy-1.json`
    - Claim portal: `/airdrop/index.html`
  - Images:
    - `assets/img/logo.png`, `assets/img/coin-1.png`, `assets/img/idiot-logo-icon_64.png`, `assets/img/og-image.png`, `assets/img/favicon.ico`
  - CSS refs to hero and preload parameters must remain intact.

---

### Next Actions
- Add GitHub repo secrets for CI (if not already):
  - `SSH_PRIVATE_KEY`, `SSH_USER=deploy`, `SSH_HOST=68.183.149.106`, `REMOTE_DIR=/var/www/stupidiots.com/public_html`
- Optional: Create staging CI to deploy `staging` branch to `/var/www/staging`.
- Monitoring: set up uptime checks and certificate expiry alerts.
- Backups: enable DigitalOcean snapshots and/or tarball backups before large changes.

---

### Quick Commands
- DNS check:
  - `bash scripts/dns_check_stupidiots.sh -d stupidiots.com -e 68.183.149.106`
- Deploy to production:
  - `bash scripts/deploy_to_droplet.sh -h 68.183.149.106 -u deploy -k ~/.ssh/id_rsa -s ./public_html`
- Issue/renew TLS via Nginx (on droplet):
  - `sudo certbot --nginx -d stupidiots.com -d www.stupidiots.com --redirect -n -m admin@stupidiots.com --agree-tos`
- Staging deploy (Windows PowerShell):
  - `.	rupidiots-website-clean\secure\internal-files\deploy-staging.ps1`
  - Promote to production: `.	rupidiots-website-clean\secure\internal-files\promote-to-production.ps1`

---

### Rollback Plan
- Production backups live on droplet as `/var/www/html.backup.YYYYMMDD_HHMMSS`.
- To restore (on droplet):
```
cd /var/www/html
sudo rm -rf *
sudo cp -r /var/www/html.backup.YYYYMMDD_HHMMSS/* .
sudo chown -R www-data:www-data /var/www/html
sudo systemctl reload nginx
```

---

### Verification Checklist
- `curl -I https://stupidiots.com/` → 200
- `curl -I https://stupidiots.com/assets/img/logo.png` → 200
- `curl -I https://stupidiots.com/airdrop/idiocracy-1.json` → 200
- `curl -I https://stupidiots.com/staging/` → 200, with `Cache-Control: no-store`

---

### Notes
- If any SSL/browser issues persist, clear DNS/browser caches and ensure no mixed-content (all assets should load over HTTPS or relative URLs).


