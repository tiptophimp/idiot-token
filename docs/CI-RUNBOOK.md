# CI Runbook — Self-Hosted Windows Runner

## Overview

GitHub Actions workflows in this repository target a **self-hosted** runner (`runs-on: self-hosted`), expected to be a Windows machine with the project toolchain preinstalled.

## Runner expectations

- GitHub Actions runner registered and online with the `self-hosted` label
- Node.js / npm (or project-specific runtime) available on `PATH`
- Network access to required remotes, registries, and deploy targets
- Secrets configured in the GitHub repository settings (not on the runner disk unless required)

## Workflow conventions

- Prefer PowerShell-native steps on Windows (`pwsh` / `shell: pwsh`)
- Avoid Linux-only package managers and display helpers (`apt-get`, `sudo`, `xvfb-run`)
- Avoid destructive host cleanup in CI (`docker system prune`) unless explicitly intended for that runner
- Keep deploy jobs idempotent and fail closed on missing secrets

## Local verification

1. Confirm the runner shows **Idle** in GitHub → Settings → Actions → Runners
2. Push a branch or use **Act** / workflow_dispatch to trigger the target workflow
3. Inspect job logs for PATH, auth, and shell errors before promoting

## Troubleshooting

| Symptom | Likely cause | Action |
| --- | --- | --- |
| Queued forever | Runner offline or label mismatch | Restart runner service; confirm `self-hosted` label |
| Command not found | Tool missing on runner | Install runtime matching local/dev docs |
| Permission / path errors | Linux paths or POSIX assumptions | Convert steps to Windows paths and PowerShell |
| Auth failures | Missing repo secrets | Add secrets in GitHub settings; re-run job |

## Change policy

When adding workflows, set `runs-on: self-hosted` and validate on the Windows runner before merging.
