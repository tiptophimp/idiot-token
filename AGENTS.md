# AGENTS.md - idiot-token

<!-- ==== SHARED RULES - GENERATED, DO NOT EDIT INSIDE THIS BLOCK ==== -->
<!-- shared-sha: 6d2b5e7ed1f7 -->
<!-- Source:     E:\Dev\_shared\configs\AGENT_RULES.md
     Regenerate: python E:\Dev\_shared\configs\apply_agent_docs.py --apply
     Verify:     python E:\Dev\_shared\configs\apply_agent_docs.py --check
     `_shared` is a workspace-level folder, not part of this repo.
     Do not hand-edit inside this block. -->

# Agent rules

## Start here — orientation for a session with no memory

You are reading this because it is embedded in a repo's `AGENTS.md`. Everything below is
the shared rulebook. These are the other things you need, and **nobody is going to tell you
they exist**, so they are listed here.

**Run these before touching anything.** Each is ten seconds and reports live state, not
what a document claims:

```
python E:\Dev\email-accounts-management\scripts\check_access.py    API access, credentials, domain expiry
python E:\Dev\email-accounts-management\scripts\backup_zones.py --check   DNS vs last known-good snapshot
python E:\Dev\email-accounts-management\scripts\check_repos.py     work that is finished but not landed
python E:\Dev\_shared\configs\apply_agent_docs.py --check          instruction drift across every repo
powershell -File E:\Dev\_shared\configs\fleet-runners.ps1          all 16 CI runners, GitHub vs local
```

**If a PR is `BLOCKED` with nothing red, check the runners before you touch the PR.**
A required check on an offline self-hosted runner sits `queued` forever and is
indistinguishable from a slow one. On 2026-09-03 this had silently stalled every
soundboard PR, including two HIGH security advisories.

**Read these when the task calls for it:**

| File | What it is |
|---|---|
| `E:\Dev\_shared\configs\OPEN_ITEMS.md` | **What is outstanding right now.** Read before asking Ernest what to do. |
| `E:\Dev\_shared\configs\WORKSPACE_FACTS.md` | Settled infrastructure facts — hosts, IPs, DNS, deploy paths |
| `E:\Dev\_shared\configs\AGENT_RULES_DECISIONS.md` | Ernest's rulings and the reasoning behind these rules |
| `E:\Dev\_shared\configs\AGENT_DOC_AUDIT.md` | The 2026-09-02 audit that produced this rulebook |
| `E:\Dev\_shared\configs\FLEET.md` | The 16 CI runners — which machine, how each starts, what is broken |
| `E:\Dev\.secrets_vault\agent-credentials.md` | The only credential store. Read silently, never echo. |

`_shared` is a workspace-level folder, not part of any repo. It is version-controlled at
`github.com/tiptophimp/dev-shared`.

**Ernest will not remember to point you at these.** That is the point of listing them where
every agent is already looking.

---

**Canonical. This is the only `AGENT_RULES.md` in the workspace.** Five other copies
existed until 2026-09-02 and disagreed with each other on who merges, what `Review` means,
and whether agents have tiers. Do not create a second copy. Do not fork it "temporarily".

Every repo carries this text verbatim inside a marked block in its own `AGENTS.md`. That
block is generated — edit this file, regenerate. Repo-specific rules go **below** the block,
where nothing overwrites them.

---

## Rule 0 — Verify. Never assume, never guess.

**Configuration is not behaviour.** A file saying a thing is on is not evidence it is on. A
permission written in a vault is not evidence the token holds it. A cron expression reading
`*/30` is not evidence anything ran.

1. **State the state only after observing it.** Read the file, call the API, run the query,
   `Test-Path` it. Reporting a config value as a system state is a violation.
2. **Success is not confirmation.** An API returning `200` with an empty body may mean "no
   permission", not "nothing there". Distinguish these explicitly before reporting either.
3. **Show the check, not just the conclusion.** Name the command and what came back, so the
   next agent can see how the claim was established instead of inheriting it on faith.
4. **"I don't know" is a required answer**, not a failure. An unverified claim stated
   confidently costs more than an admitted gap.
5. **Re-verify second-hand claims** — from another agent, a previous session, Ernest, or
   this file. Not distrust: the source may simply be out of date.
6. **When a check contradicts a document, the check wins** — and the document gets fixed in
   the same session. Never leave the contradiction for the next agent.
7. **Verify the effect, not the acknowledgement.** A `200` means the request was accepted,
   not that the thing happened. Confirm the change at the destination — re-read the record,
   re-query the resource, re-run the check — never from the response you got back.
8. **Then verify again after a pause.** Many APIs are asynchronous and answer
   `{"message": "Request accepted"}` while the work is still queued. A single immediate
   re-check can show the *old* state and look like a failure. If the first verification
   contradicts a success response, wait and check once more before concluding either way.

9. **Match the error mode to the risk.** In a shell script, a "keep going on error"
   setting is right for a read-only sweep — one repo failing should not blind you to the
   other 44. It is wrong for anything destructive, because a failed step lets the next step
   run on a false premise. In PowerShell:

   ```
   $ErrorActionPreference = 'Continue'   # read-only sweeps, surveys, reporting
   $ErrorActionPreference = 'Stop'       # delete, push, write, rename, rebase, merge
   ```

   The same applies anywhere else: `set -e` in bash for destructive work, checked return
   codes rather than fire-and-forget. On 2026-09-02/03 an agent used `Continue` on commands
   that deleted branches, removed files and pushed to remotes. Nothing went wrong — but
   only because each was verified afterwards. Verification caught it; the setting would not
   have.

> Both of those cost a wrong answer on 2026-09-02. Six Hostinger nameserver updates
> returned `200`; the first verification showed the old values and the conclusion drawn was
> "the 200 lied". It had not — the endpoint is async, and the change landed moments later.
> The opposite error happened the same hour: Cloudflare zone creation returned success and
> was *assumed* to inherit the account's nameserver pair. It does not; pairs are assigned
> per zone, so six domains had to be repointed at the registrar afterwards. One error was
> concluding failure too early, the other concluding success without looking. The same
> discipline prevents both.

> Four failures on 2026-09-02, all the same shape: a token's permissions reported from
> intent rather than probed (it had 3 of 7); `200 + empty array` scored as a capability pass
> for a token with zero account access; "~2,000 wasted cron runs" from a cron expression on
> two `enabled: false` tasks; and a stale-file deletion "verified" against an instruction
> that had been misread as a completion report.

## Rule 1 — Fix the cause. No temporary patches.

A workaround that hides a symptom while leaving the cause is not a fix. It is a deferred
failure with interest.

1. **Diagnose before you patch.** Name the cause. If you cannot name it, you have not found
   it — say so rather than treating the symptom.
2. **Suppression is not resolution.** Do not silence a failing test, widen a type to `any`,
   add a blanket try/except, bump a timeout, or pin around a broken dependency and call it
   done.
3. **No commented-out code as a fix**, and no `TODO` standing in for in-scope work.
4. **If the real fix is out of scope, that is an escalation, not a licence to patch.** Stop,
   state the cause, state the proper fix, put it to Ernest.
5. **Fix it where it lives.** Correcting a call site while the broken function stays broken
   guarantees the next caller hits it.
6. **A retry is a fix only for a genuinely transient failure** — and you must have
   established that, not assumed it.

> `L:` failed to map twelve consecutive times with error 1219. The band-aid was to retry or
> use another letter. The cause was passing `/user:omniserver` while `O:` already held a
> session to that host — Windows refuses a second credential set to one server. Reusing the
> existing session fixed it permanently on the first attempt.

---

## Work

### No roles, no tiers

Every agent operates under identical rules. There is no advisor tier, no
implementer tier, no model-based capability split. What an agent may do is governed by
Rule 0, Rule 1, and the Major Changes list — never by which model is running.

### The task ledger is GitHub Issues

One issue per unit of work, in the repo the work lands in. Work that spans repos, or is
infrastructure with no repo of its own, goes in `tiptophimp/dev-shared`. Find current work
with `gh issue list --repo tiptophimp/<repo>` — never carry task context between repos or
from a previous session, and never keep a task list in a file.

**ClickUp is retired (2026-09-04).** Its 579 tasks are exported, with comments, to
`E:\Dev\_shared\configs\clickup-export-2026-09-04.json`; nothing in it is live. Do not
read it for current work and do not create anything there. `TASK_LEDGER.md` and
`TASKS_MIRROR.md` were retired 2026-09-02 for the same reason: a second ledger only adds a
place for state to rot. Work lands in GitHub, so the ledger lives in GitHub.

Labels carry the state; there are no status columns to forget to move:

| Label | Meaning |
|---|---|
| `agent-ready` | Fully specified — acceptance criteria and a verification command in the body. The night shift may pick it up unattended. |
| `agent:claude` / `agent:gemini` / `agent:cursor` / `agent:copilot` / `agent:devin` | Which runner the night shift dispatches it to. Without one, `agent:claude`. |
| `in-progress` | A branch or PR exists. The night shift skips it. |
| `blocked` | Waiting on another issue or an external dependency — link it in the body. |
| `needs-ernest` | Only Ernest can move it: a decision, a secret, a purchase, an account action, or a Major Change (below). This is what `Review` used to mean. |

**An issue is closed by the PR that ships it** — `Closes #N` in the PR body, so the merge
closes it. Never close an issue by hand while its PR is open, and never open a PR without
an issue for anything larger than a typo. This is the single rule that keeps the ledger
true: the previous ledger drifted within days because agents planned in one place and
shipped in another.

The overnight dispatcher is `E:\Dev\_shared\scripts\night-shift.ps1`; the morning
report is `E:\Dev\_shared\scripts\morning-report.ps1`. Both read the repos, nothing
else. Neither is scheduled until Ernest says so.

### Branches

```
<type>/<issue#>-<short-slug>       feature/41-media-library
                                   fix/17-verified-id-traps
                                   chore/2026-09-02-cf-token-single-source
```

`type` is `feature`, `fix`, `chore` or `docs`. Use the issue number when one exists, a date
slug when not. **One branch per unit of work, named for what it does.** The agent's own name is
not in the branch — it encoded the retired tier system and made identical work look
different when two agents touched one task.

### You own your PR through to merge

Open the PR. If checks are red, that is your problem, not a handoff — fix, push, re-run,
repeat. When every required check is green, **squash-merge your own PR and delete the
branch**:

```
gh pr merge --squash --auto --delete-branch
```

**Never park a red PR for a human. Never park a green PR for a human either.** A human
re-running the same checks adds a queue and no information.

Do not merge another agent's PR unless asked. Never direct-push `main`. Never bypass branch
protection, and never use an admin merge.

**Check before you push.** 32 of 45 repos have branch protection, and every one is set
`enforce_admins: false` — so an admin push succeeds and GitHub merely *reports*
`Bypassed rule violations` afterwards. The protection does not stop you; it records that you
went around it. A push that is technically permitted is still a bypass.

If Ernest grants a one-time exception to push directly, say explicitly that it means
bypassing protection on the repos that have it, and name them. He can only weigh the
exception if he knows what it actually costs.

```
gh api repos/tiptophimp/<repo>/branches/main/protection
```

Read the response, do not read the status code alone. A 404 here means "no protection
found **for that branch name, with this token**" — it is equally consistent with a
mistyped branch, a repo whose default is `master`, or a token without admin scope on the
repo. Confirm the branch name and that the token can see the repo before concluding
anything. Treating 404 as "unprotected" is the same "cannot see" versus "not there"
confusion Rule 0 exists to prevent.

### Leave the repo on its default branch

**Check out a branch, and you own returning the repo to `main` (or `master`) when you are
done with it** — after your PR merges, or the moment you stop working in that repo. Delete
your local branch once its PR has landed.

**Before you commit anything, confirm which branch you are on.** `git status` takes a
second. A commit does not ask; it lands wherever HEAD happens to point.

> On 2026-09-02 an agent left `E:\Dev\OmniLedgr` checked out on `docs/2026-09-02-rule0-verify-effect`.
> Ernest then made an unrelated infrastructure change — GPU reservations in
> `docker-compose.yml` — and committed it. It went onto the agent's docs branch, and would
> have shipped inside a documentation PR. Nothing warned him: the commit succeeded, the
> hooks passed, the output looked entirely normal.

This is not a git rule, it is a shared-state rule. **A working directory is shared state,
and so is anything else an agent changes and walks away from** — a checked-out branch, a
stash, an applied filter, a modified config, a running process, an env var. The person who
touches it next inherits it without being told, and inherits it silently.

So: put back what you moved. If you cannot put it back, say so explicitly rather than
leaving it for someone to discover.

### `needs-ernest` means exactly one thing: Ernest must look at this

It is not a CI waiting room. A green PR never gets it. If an issue carries `needs-ernest`,
a human is blocking, and the body says what he has to decide.

### Major changes — stop and wait for Ernest

Hard stop regardless of CI status. Post what you found and what you propose, then wait.

| Category | Examples |
|---|---|
| Destructive | dropping or truncating tables, destructive migrations, deleting a repo, branch, bucket or volume, force-push to a shared branch |
| Money | payments, Stripe, billing, pricing, anything that charges a customer |
| Live DNS | any production DNS record change |
| Secrets | creating, rotating, or committing a credential |
| Customer data | schema or handling changes to real user data; anything that exports it |
| Architecture | swapping a framework, database, hosting model, or auth provider |
| Outbound comms | any email, message or post sent to a real third party |

---

## Credentials

**Never echo a credential to chat, logs, or console output.** Asked "are you connected?",
answer with the API's identity ("auth OK as tiptophimp via gh"), never the
token. When debugging credential files, parse silently — never `cat`, `sed`, `grep` or
`Get-Content` the values. A violation forces rotation across every integration.

**The vault is `E:\Dev\.secrets_vault\agent-credentials.md` and nothing else.** One value per
credential, in that file only. Other files may reference it; none may duplicate it. Scripts
read via a shared helper, never their own regex.

> Until 2026-09-02 a second live Cloudflare token sat in
> `omniledgr-credentials-ledger.md`, read by four scripts with four regexes, while that same
> file told readers not to duplicate the GitHub PAT three lines above it.

Run `python E:\Dev\email-accounts-management\scripts\check_access.py` before work that
touches Cloudflare or Google. Ten seconds; it probes every capability live and prints what
is missing.

---

## Infrastructure

```
Internet → Cloudflare (DNS + proxy)
        → either: Cloudflare Tunnel → cloudflared on GMKtec → container   [target]
        → or:     router port-forward 80/443 → 192.168.50.60 → NPM → container   [legacy]
```

**Cloudflare Tunnel is permitted and is the target architecture** (decided 2026-09-02).
`omniledgr.com` and `api.saasound.com` already run on tunnels; 19 domains remain on the
port-forward. New hostnames go on tunnels; existing ones migrate opportunistically. Ports
80/443 close only after the last domain moves.

> The previous ban ("Cloudflare Tunnel, ngrok, Tailscale Funnel remain OUT") was written
> before those two migrated and was never updated. An agent enforcing it against
> `omniledgr.com`'s CNAME would have taken the site down. ngrok and Tailscale Funnel remain
> out.

**Never delete a `Cloudflare Tunnel API Token for <domain>` token** — `cloudflared` owns
those and they serve live hostnames.

Machines are referred to by their actual hostname. Nicknames are not used; if a label
disagrees with what the machine reports, the machine is right.

Deploy documentation lives in the repo it describes, not in a central folder.

**If you edit anything on GMKtec you must `git commit && git push` immediately.** The deploy
runs `git reset --hard origin/main` and will erase un-pushed server-side edits.

---

## Repo-specific rules

Below the generated block in each repo's `AGENTS.md`. That section is yours; the generator
never touches it. Anything that is true for every repo belongs here in the canonical file
instead — added once, regenerated everywhere.

<!-- ==== END SHARED RULES ==== -->

## Repo-specific

> Preserved from this repo's previous AGENTS.md on 2026-09-02. Rules here
> that duplicate the shared block above can be deleted; rules that are
> genuinely specific to this repo should stay.

**Single entry point.** Do not add workflow rules in this file.

## Scope

**This repo = idiot-token project.**

**Cross-repo:** OmniLedgr → [OmniLedgr](https://github.com/tiptophimp/OmniLedgr). Fleet ops → [gmktec-fleet-ops](https://github.com/tiptophimp/gmktec-fleet-ops).

## Git workflow

- **`main` is protected:** PR required, no force-push, no branch deletion.
- Work on `feature/…` or `fix/…` branches; open a PR; when required checks are green, squash-merge your own PR (`gh pr merge --squash`)
