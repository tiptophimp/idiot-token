### Deployment Troubleshooting (stupidiots.com)

#### DNS issues
- Verify records:
  - A: `stupidiots.com` → Droplet IPv4
  - CNAME: `www` → `stupidiots.com`
  - (Optional) AAAA for IPv6
- Run: `bash scripts/dns_check_stupidiots.sh -d stupidiots.com -e <DROPLET_IP>`
- If A is wrong/missing: update at your DNS provider and wait 5–30 minutes.

#### Nginx not serving
- Test config: `sudo nginx -t`
- Reload: `sudo systemctl reload nginx`
- Logs: `/var/log/nginx/stupidiots.access.log`, `/var/log/nginx/stupidiots.error.log`
- Confirm web root: `/var/www/stupidiots.com/public_html`

#### TLS/HTTPS problems
- Ensure DNS is pointing before running Certbot
- Re-run issuance: `sudo certbot --nginx -d stupidiots.com -d www.stupidiots.com --redirect -n -m admin@stupidiots.com --agree-tos`
- Check renewal timer: `systemctl list-timers | grep certbot`

#### Content missing / 404
- Verify files exist exactly as referenced:
  - `index.html` at web root
  - Hero background: `ChatGPT Image Sep 28, 2025, 04_50_50 PM.png` at web root
  - Airdrop files under `/airdrop/`
  - Images under `assets/img/`
- Re-deploy: `bash scripts/deploy_to_droplet.sh -h <DROPLET_IP> -k ~/.ssh/id_rsa -s ./public_html`

#### Firewall / reachability
- `sudo ufw status` should allow OpenSSH and Nginx Full
- From local: `curl -sI http://<DROPLET_IP> -H "Host: stupidiots.com"`


