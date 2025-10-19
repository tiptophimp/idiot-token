### GitHub Actions CI Deployment (stupidiots.com)

This deploys the contents of `public_html/` to the droplet via GitHub Actions.

#### 1) Required repo secrets
Set these in GitHub → Settings → Secrets and variables → Actions → New repository secret:

- `SSH_PRIVATE_KEY` — private key with access to the droplet user (no passphrase or use an encrypted key + agent)
- `SSH_USER` — e.g., `deploy` (or `root` if you prefer)
- `SSH_HOST` — `68.183.149.106`
- `REMOTE_DIR` — `/var/www/stupidiots.com/public_html` (used by production workflow)

#### 2) Workflows
- Production (main): `.github/workflows/deploy.yml`
  - Triggers on push to `main`
  - Syncs `public_html/` → `/var/www/stupidiots.com/public_html`
  - Reloads Nginx

- Staging (staging): `.github/workflows/deploy-staging.yml`
  - Triggers on push to `staging`
  - Syncs `public_html/` → `/var/www/staging`
  - Reloads Nginx

#### 3) Usage
- Preview changes:
  1. Create or update the `staging` branch
  2. Push to `staging` → staging deploy runs automatically
  3. Review at `https://stupidiots.com/staging`

- Go live:
  1. Merge `staging` → `main`
  2. Production deploy runs automatically
  3. Verify at `https://stupidiots.com/`

#### 4) Notes
- Both workflows use rsync with `--delete` to keep server directories in sync with `public_html/`
- Keep the exact required file names/paths; the workflows deploy them as-is
- Ensure `deploy` user can write to `/var/www/staging` and `/var/www/stupidiots.com/public_html` and can reload Nginx (NOPASSWD configured)


