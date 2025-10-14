### Continue Working On This Project From Another PC (Windows)

This guide shows two reliable ways to move and keep working. The Git method is recommended.

---

### Option A (Recommended): Use Git + Remote Repository

1) Initialize Git in the project (current PC)

```bash
cd "C:/Important website files!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
git init
git add -A
git commit -m "Initial commit: project snapshot"
```

2) Create a remote repository (e.g., GitHub, GitLab)

- Create a new, empty repo in your Git host.
- Copy the repo URL (SSH or HTTPS).

3) Connect and push

```bash
# Replace with your repo URL
git remote add origin <REPO_URL>
git branch -M main
git push -u origin main
```

4) On the new PC

```bash
# Install requirements first: Git, Cursor, Python (if needed)
git clone <REPO_URL>
cd <repo-folder>
```

5) (If Python tools are used)

```bash
python -m venv .venv
. .venv/Scripts/activate
pip install -r requirements.txt
```

6) Open in Cursor and continue working

```bash
cursor .
```

Notes:
- Prefer SSH for convenience or use a Personal Access Token for HTTPS.
- Add a `.gitignore` to avoid committing secrets and bulky archives. Example entries:

```bash
# archives / backups
*.zip
*.tar.gz

# secrets
secure/
*.env
discord.env
discord.env.example # keep if you want to share the template

# venv
.venv/
```

---

### Option B: Zip and Transfer (USB/Cloud)

1) From the current PC, compress the project folder:

```bash
cd "C:/"
tar -czf stupidiots-website-backup-$(date +%Y%m%d_%H%M%S).tar.gz "Important website files!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
# or use File Explorer: Right-click folder → Send to → Compressed (zipped) folder
```

2) Move the archive to the new PC (USB, cloud drive).

3) Extract, then open in Cursor. If Python tools are used, recreate the venv and run:

```bash
pip install -r requirements.txt
```

---

### Environment Setup (New PC)

- Install Git: `https://git-scm.com/download/win`
- Install Cursor: `https://www.cursor.com/`
- Install Python (if needed): `https://www.python.org/downloads/`
- Optional: Node.js if you add tooling later: `https://nodejs.org/`

---

### Project-Specific Notes (Do Not Change)

- Keep the single-file structure for the main static page.
- Maintain these exact paths and names:
  - Working file: `stupidiots_one_page_static_site_index.html`
  - Upload as: `index.html` (root of `public_html/`)
  - Hero background: `ChatGPT Image Sep 28, 2025, 04_50_50 PM.png`
  - Airdrop structure:
    - Rules page: `/airdrop/idiocracy`
    - Proofs file: `/airdrop/idiocracy-1.json`
    - Claim portal: `/airdrop/index.html`
  - Existing image paths:
    - Logo: `assets/img/logo.png`
    - Coin: `assets/img/coin-1.png`
    - Social icons: `assets/img/idiot-logo-icon_64.png`
    - OG image: `assets/img/og-image.png`
    - Favicon: `assets/img/favicon.ico`
  - Critical CSS references:
    - Hero background: `url('ChatGPT Image Sep 28, 2025, 04_50_50 PM.png')`
    - Logo preload: `assets/img/logo.png?v=20250119`
    - Coin preload: `assets/img/coin-1.png`

Do not rename or relocate these assets or paths; deployments rely on them.

---

### Quick Validation After Moving

1) Open `index.html` locally in a browser.
2) Confirm the hero background and images render correctly.
3) Verify airdrop links:
   - `/airdrop/idiocracy`
   - `/airdrop/idiocracy-1.json`
   - `/airdrop/`

If using Git, run a test change and push/pull to confirm sync between PCs.


