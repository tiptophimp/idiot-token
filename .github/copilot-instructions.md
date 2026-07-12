# Copilot instructions

Follow `AGENTS.md` at the repo root and `E:\Dev\_shared\configs\AGENT_RULES.md`.
Also see `E:\Dev\_shared\configs\COPILOT.md` and `FLEET_AGENT_ROSTER.md`.

- Feature branches: `agent/copilot/<task-id>-<slug>` only. Never push directly to main/master.
- When required CI checks are green, squash-merge your own PR (`gh pr merge --squash` / `--auto`).
- Never force-push, never `gh pr merge --admin`, never echo credentials.
- Hard Stops (Ernest): secrets, money/licenses, prod SSH, durable deletions, product ambiguity.
