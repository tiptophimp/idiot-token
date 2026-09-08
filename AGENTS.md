# AGENTS.md - idiot-token

<!-- ==== SHARED RULES - GENERATED, DO NOT EDIT INSIDE THIS BLOCK ==== -->
<!-- shared-sha: 57cb4bf081e1 -->
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
| `E:\Dev\_shared\configs\OPEN_ITEMS.md` | **What is outstanding right now.** Read before asking Ernest what to do. Ernest edits this file directly from a Desktop shortcut and does not commit; **if it has uncommitted changes when you start, commit them first** (`chore: Ernest's OPEN_ITEMS edits`) so his notes are never lost to a `git pull`. |
| `E:\Dev\_shared\configs\WORKSPACE_FACTS.md` | Settled infrastructure facts — hosts, IPs, DNS, deploy paths |
| `E:\Dev\_shared\configs\AGENT_RULES_DECISIONS.md` | Ernest's rulings and the reasoning behind these rules |
| `E:\Dev\_shared\configs\AGENT_DOC_AUDIT.md` | The 2026-09-02 audit that produced this rulebook |
| `E:\Dev\_shared\configs\FLEET.md` | The 16 CI runners — which machine, how each starts, what is broken |
| `E:\Dev\.secrets_vault\agent-credentials.md` | The only credential store. Read silently, never echo. |
| `E:\Dev\.secrets_vault\SERVICES.md` | **Every account and service — URL, login, where its secret is.** Add a row the day you create or cancel anything. |
| `E:\Dev\.secrets_vault\crypto\README.md` | Every wallet, key location and contract found on the drives. Nothing crypto gets deleted; it gets listed here. |

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

10. **Never read a value out of a stream that also carries commentary, and
    never parse output by column position.** Both cost a wrong answer on
    2026-09-08, in the same tool, hours apart.

    A helper returned `stdout + stderr` combined. `git hash-object` writes the
    blob SHA to stdout and a CRLF warning to stderr, so the "SHA" arrived as
    two lines and the commit could not be built. The same helper `.strip()`ed
    its output, which ate the leading space of `git status --porcelain`'s
    two-column status field, so a fixed-width `line[3:]` slice turned
    `" M AGENTS.md"` into `"GENTS.md"`. That silently reported **nothing to
    land in every dirty repo** — and it is invisible for `?? path` and
    `MM path`, which have no leading space, so casual testing passes.

    So: capture stdout separately from stderr whenever the output is a value
    rather than a log. Ask a tool for the shape you want to consume —
    `git diff --name-only` and `git ls-files` emit bare paths that no amount
    of trimming can corrupt — instead of parsing a display format. And
    validate: a Git object name is 40 hex characters, so check that it is.

10. **`??` is not `M`. Being dirty is not permission to overwrite.** Before
    writing over any file you were not asked to create, ask git what it is:

    ```
    git status --porcelain -- <path>
    ```

    `M ` means tracked and modified — git holds the previous bytes and
    `git restore` undoes your write. `??` means **untracked: there is exactly
    one copy in existence and you are about to replace it.** Commit it on a
    scratch branch first, or copy it aside, or leave it alone. Overwriting an
    untracked file is destruction, not modification, and no amount of
    verification afterwards can undo it.

    > On 2026-09-08 I rewrote `personal-ai-chatbot/scripts/agent-status.ps1`
    > while fixing a real breakage in it. It was untracked, so the original is
    > unrecoverable — `git cat-file` cannot find the blob and
    > `git log --all` for the path is empty. My own baseline had recorded that
    > file under "MUST NOT CHANGE" one hour earlier. What was lost happened to
    > be worthless (the script was a hard error on every run), but that was
    > luck, not care. See `docs/INCIDENT-2026-09-08-untracked-file-overwritten.md`.

    The same applies to any single-copy state: an untracked file, a stash, an
    un-exported database row, a file open in an editor with unsaved changes.

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

> And on 2026-09-08, `gh pr merge --squash --auto` exited `0` having armed
> nothing. The tool reported the change as landed; the PR's `autoMergeRequest`
> was `null` and it would have sat open forever. An exit code says the command
> was accepted. Re-read the object — here, the PR's own merge state — before
> claiming the effect.
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

**ClickUp is gone.** Retired 2026-09-04, subscription cancelled 2026-09-05,
and on 2026-09-08 Ernest deleted the workspace outright: *"deleted entirely,
terminated entirely and the subscription totally canceled. That's gone. And
won't be coming back either."*

There is nothing to log in to and nothing to restore. Its 579 tasks and their
comments survive only as
`E:\Dev\_shared\configs\clickup-export-2026-09-04.json`, which is therefore
an **irreplaceable archive, not a stale mirror — do not delete it**. Nothing in
it is live: do not read it for current work, do not treat a task ID in it as
actionable, and do not create anything there.

Historical ClickUp task IDs in code comments and commit messages are
provenance and stay as they are. What must not remain is anything that *calls*
ClickUp or tells an agent to use it.

> Found 2026-09-08 while auditing this: `scripts/agent-status.ps1` in
> `Verndex`, `fps-deploy`, `personal-ai-chatbot` and `stair-app` still
> forwarded `-SkipClickUp` to the shared engine, which dropped that parameter
> on 2026-09-05. Because both are `[CmdletBinding()]`, the call is a hard
> `NamedParameterNotFound` error — those four status scripts were completely
> broken, with the flag or without it, and nothing reported it. **Removing an
> integration means removing every caller, not just the implementation.** `TASK_LEDGER.md` and
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

### You own your PR through to merge — and through to production

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

**Merge is not done.** Landing on GitHub `main` is not the same as shipping to users.
On 2026-09-04 → 09-06, sixteen soundboard commits sat on `main` while production stayed
on an older SHA because agents merged and walked away. That must not happen again.

If the repo has a production deploy path, **you own that deploy in the same session as
the merge** — or you say explicitly that deploy is blocked and why (host down, secret
missing, Ernest gate). Do not report the task complete, and do not move on to the next
issue, while production is still behind `origin/main` for the surfaces you changed.

| Surface | "Done" means |
|---|---|
| Backend / API | Deployed SHA on the server matches `origin/main` (or you documented why not) |
| Frontend / web | Deployed web SHA matches `origin/main` when the web app's source changed. **Find that directory in the repo** — it is `frontend/` in some, `apps/web/` in OmniLedgr, `desktop/` in soundboard. "`frontend/` is untouched" is not evidence that no deploy is needed |
| Desktop / installer | Customers get a published release — **say so**. Merge alone is not production |
| Docs / CI-only | No production deploy required; say "docs/CI only, no deploy" |

Verify with a **read of the live marker or health endpoint**, not with "the workflow was
triggered." A failed load probe after a successful switch still counts as deployed if
the server marker matches; a green CI job that never ran the deploy does not.

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

### Do not use `git stash`

**A stash is invisible work.** It does not show in `git status`, no check
watches it, it is never pushed, and it is bound to the one machine that holds
it. It is the one place work can sit where nothing at all will surface it.

> Measured 2026-09-08: **95 stashes across 35 of 47 clones.** Not one was
> mentioned in any handoff, and the rulebook had never named them. Some
> predate every branch in their repo.

Whatever the stash was for, there is a better move:

| Instead of stashing | Do this |
|---|---|
| "I need a clean tree to switch branches" | Commit to your branch and push. A work-in-progress commit is not a sin; a lost one is |
| "This is scratch work I might want" | Commit it on a throwaway branch and push it. Branches are free |
| "I only need to check something else quickly" | `git worktree add` a second directory, or read the other branch with `git show <branch>:<path>` — neither disturbs your tree |
| "I want to discard this" | Then discard it: `git restore`. Say so, do not park it |

**Amnesty for the 95 that already exist.** They were created under a rulebook
that never mentioned them, so they are nobody's fault. Do not mass-drop them —
some may hold the only copy of real work. When you are next in a repo that has
one, inspect it (`git stash list`, `git stash show -p`), then either land it or
drop it deliberately, and say in the session which you did and why. Clearing a
stash you have not read is destroying work you have not seen.

### Abandoned work may be picked up - after a threshold, and without rewriting history

The problem here is not that work goes wrong. It is that work **stops and nobody notices**.
A session ends mid-task - Ernest gets called away, a machine reboots, an agent runs out of
context - and the branch, the issue and the half-finished tree sit there until someone
stumbles on them months later.

> Measured on 2026-09-06: **seven** local clones were parked on non-default branches, six of
> them 2026-09-05 `clickup-retirement` chores that never landed, and **seven** had
> uncommitted work. None of it appeared in any check, because every check watched pull
> requests and this work had not reached one.

**So idle work is fair game. Silence means abandoned - agents do not take holidays.** Three
conditions, because "not actively working" without a threshold is a licence for two agents
to collide on the same task:

1. **Wait out the threshold, measured in hours.** A green PR is abandoned after **1 hour** -
   merging is one command. A branch ahead of its default with no PR, or an issue labelled
   `in-progress` with no branch, is abandoned after **4 hours** - one working session. Below
   the threshold, leave it and assume someone is mid-thought.

   > These were 3 days until 2026-09-06. That was wrong and Ernest said so: at 150 commits
   > in three days, a three-day threshold makes abandoned work untouchable for longer than
   > the project cycle. **The standard is not "eventually someone notices" - it is "open a
   > branch, finish it in that session, or say in the issue why you could not."**

2. **Never rewrite someone else's history.** Branch *from* their work, or open a fresh
   branch and cherry-pick. No force-push and no rebase of a branch you did not create. Their
   commits must survive the takeover, because you cannot tell from outside which choices
   were deliberate.

3. **`needs-ernest` and `blocked` are never taken over.** Idleness there is the expected
   state, not neglect. Report them, do not grab them.

`python E:\Dev\email-accounts-management\scripts\check_repos.py` reports all four shapes:
claimed-and-abandoned issues, orphan branches with no PR, local clones parked off their
default branch, and dirty working trees. Run it at the start of a session. **Picking up
abandoned work is not scope creep - it is the job.**

### Push every increment, not every session

**A commit that exists only on your machine is one crash from gone.** Commit saves it
locally; push is what makes it survive.

This is not a general nicety, it is specific to this estate:

- `ohio-tax-reform/.github/workflows/deploy.yml` runs `git fetch origin && git reset --hard
  origin/main` on the GMKtec runner. Anything on that server not pushed to GitHub is
  **erased** on the next deploy.
- `refresh-data.yml` runs `0 6 * * *` UTC, commits and pushes when fingerprints change, and
  therefore triggers that deploy **daily**, with no human involved.

So:

1. **Push as soon as something works** - not when the task is finished. A working increment
   is a pushable increment. Ten small pushes beat one big one, and cost nothing.
2. **Nothing is left unpushed at the end of a session.** Not a commit, not a stash, not a
   dirty file. If you cannot push it, say so explicitly and say why.
3. **On GMKtec, `git commit && git push` immediately.** There is no safe interval there.
4. **Before significant work, know what is at risk:** `git status` and
   `git log origin/<branch>..HEAD`. If the second prints anything, that work exists in one
   place only.

> Read the graph in any IDE the same way: `main` above `origin/main` means those commits are
> on this machine and nowhere else. Same row means synced.

### Editing this rulebook obliges you to propagate it

Every repo carries this text verbatim inside a marked block in its own `AGENTS.md`. **If you
edit `AGENT_RULES.md`, run the propagation in the same session:**

```
python E:\Dev\_shared\configs\apply_agent_docs.py --land
```

`--land` writes the file **and** commits, pushes, opens the PR and arms
auto-merge. Use it, not `--apply`. `--apply` writes and stops, which leaves
every repo it touched holding an uncommitted change.

**This is the general rule, not a detail about one script: a tool that writes
files and stops has not run.** Finish the transaction it started, in the same
invocation.

> On 2026-09-08 `--check` reported "all repos current" while **43 of 47 repos**
> held a correct-but-uncommitted `AGENTS.md`. The propagation tool wrote files
> and stopped, so every sweep manufactured the fleet-wide dirt that the next
> sweep had to wade through — and the check that was supposed to catch drift
> read the working tree, so it saw the right content and said everything was
> fine. **The tool meant to prevent the mess was its largest single source.**

Two companions:

```
python E:\Dev\_shared\configs\apply_agent_docs.py --tidy   reconcile what a previous run left mid-merge
python E:\Dev\_shared\configs\rules_sync_report.py         read-only: every repo in one bucket, with a reason
```

`--tidy` runs first inside every `--land`, because cleanup cannot happen at
the end of a land — auto-merge is usually still in flight when the tool
finishes. `rules_sync_report.py` exits non-zero **only** when a repo needs a
human, and runs on a schedule every weekday morning.

**Repos archived on GitHub are read-only and out of scope.** They accept
fetches and refuse every write with a `403`; that is permanent, not a flaky
network. `service-scheduler` is the one on this estate. Do not retry it, and
do not count it as fleet dirt.

**This is an agent obligation, not Ernest's.** He edits the rulebook directly and will not
remember a follow-up command - and a reminder that depends on him remembering is not a
mechanism, it is a hope. `apply_agent_docs.py --check` is check 4 of the start-of-session
sweep, so drift gets caught eventually; causing it and relying on the catch is worse than
not causing it.

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
