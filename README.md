# IDIOT Token Website

This repository contains the website files for the IDIOT token project.

## Structure

- `public_html/` - Main website files
  - `index.html` - Homepage
  - `learn.html` - Learning page
  - `community_rewards.html` - Community rewards page
  - `assets/` - Images, CSS, and JavaScript files
  - `airdrop/` - Airdrop-related pages
  - `docs/` - Documentation files
  - `legacy/` - Legacy pages
  - `QA/` - Quality assurance files

## Deployment

This website is deployed to Hostinger via Git auto-deployment.

## DigitalOcean Deployment (new)

If hosting on a DigitalOcean Droplet, a GitHub Actions workflow `.github/workflows/deploy-digitalocean.yml` deploys the contents of `public_html/` via rsync over SSH.

Set the following repository secrets:
- `DO_SSH_HOST` – Droplet IP or hostname
- `DO_SSH_USER` – SSH user (e.g., `root` or `deploy`)
- `DO_SSH_KEY` – Private SSH key (PEM format)
- `DO_TARGET_DIR` – Target directory on the server (default: `/var/www/stupidiots.com/public_html`)

On push to `main`, the workflow syncs `public_html/` to `DO_TARGET_DIR` with `--delete` to remove files not in the repo.

## License

See LICENSE file for details.
# Test deployment trigger
