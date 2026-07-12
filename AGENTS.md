# AGENTS.md

**Single entry point.** Do not add workflow rules in this file.

## Scope

**This repo = idiot-token project.**

**Cross-repo:** OmniLedgr → [OmniLedgr](https://github.com/tiptophimp/OmniLedgr). Fleet ops → [gmktec-fleet-ops](https://github.com/tiptophimp/gmktec-fleet-ops).

## Git workflow

- **`main` is protected:** PR required, no force-push, no branch deletion.
- Work on `feature/…` or `fix/…` branches; open a PR; when required checks are green, squash-merge your own PR (`gh pr merge --squash`)
