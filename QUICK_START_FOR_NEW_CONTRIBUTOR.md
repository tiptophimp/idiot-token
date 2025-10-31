# Quick Start for New Contributor

## Read First (order matters)
1. `SESSION_HANDOFF.md` (current state, tasks, blockers)
2. `_STATUS.md` (live/staging URLs, current phase)
3. `docs/WORKFLOW.md` (mandatory 5-step deploy)
4. `PROJECT_SUMMARY_2025-10-30.md` (you are here)

## Working Rules
- Follow 5-step workflow without deviation
- Verify every push immediately on live URL
- Keep 4 rolling backups
- Never change file structure or critical paths (airdrop, assets, hero image name)

## Critical Paths (must remain exact)
- Airdrop: `/airdrop/`, `/airdrop/idiocracy`, `/airdrop/idiocracy-1.json`
- Hero background: `ChatGPT Image Sep 28, 2025, 04_50_50 PM.png`
- Key assets: `assets/img/logo.png`, `assets/img/coin-1.png`, `assets/img/og-image.png`, `assets/img/favicon.ico`

## Repos & URLs
- Production: https://www.stupidiots.com
- Staging: https://tiptophimp.github.io/idiot-token-staging/
- Repo: https://github.com/tiptophimp/idiot-token (branch: `gh-pages`)

## Tasks Often Needed
- Update roadmap on `index.html`
- Publish transparency (addresses, proofs, LP lock)
- Routine link checks and visual QA

## Deployment (summary)
1) Local dev and review in browser
2) Push to staging and verify live
3) Merge to `gh-pages`
4) Wait 1–3 minutes, then verify production

## Post-Deploy Sanity
- Footer shows v5.0
- Spinning coins visible (left/right)
- Airdrop pages open; social links valid (Discord invite ok)

## Key References
- Contract: `0xC29EF04CFFe38012dcfc1E96a2B368443f298dE1`
- Pool: `0x763c9aB550dC0DAbd32F40131481Bf4BA4d8c1ea`

## Open Security Items
- Lock LP-NFT ID 3887185 for 24 months and publish proof
- Move 977,932 IDIOT stray to Treasury Timelock

— Maintained by Novalex


