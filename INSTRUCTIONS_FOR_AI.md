# 🤖 INSTRUCTIONS FOR AI ASSISTANTS

## ⚠️ CRITICAL: MANDATORY FIRST ACTION

**BEFORE responding to ANY user query, you MUST:**

### 1. Read the Session Handoff File
```
Read file: SESSION_HANDOFF.md
```

This file contains:
- Complete current project state
- What's in progress
- What's blocking
- What was completed last session
- **Operating System and command syntax to use**
- All critical context needed

### 2. Check the System Information Section
**CRITICAL:** Read the "SYSTEM INFORMATION" section to know:
- What OS this is (Windows/Mac/Linux)
- What commands work and what DON'T
- Correct path separators
- Available shells

**This prevents using wrong commands (like `bash` on Windows without Git Bash).**

### 3. Summarize the Current State
Tell the user:
- What we're currently working on
- What the blockers are
- What the next steps should be

**DO NOT skip this step. Without it, you'll waste time asking questions that are already answered or using wrong commands.**

---

## ⏰ CRITICAL: 60-MINUTE UPDATE REQUIREMENT

**EVERY 60 MINUTES of active work, you MUST:**

### Update SESSION_HANDOFF.md with:
1. **Progress made in last hour**
2. **Current task status**
3. **Any new blockers discovered**
4. **Production status** (if checked/verified)
5. **Updated timestamp**

### Quick 60-Minute Update Process:
1. Update "What We're Working On RIGHT NOW"
2. Add to "Session Notes" → "What Happened This Session"
3. Update "Last Updated" timestamp
4. Update "Changes Made" table if any files modified
5. Quick commit: `git add SESSION_HANDOFF.md && git commit -m "Hourly update: [brief status]"`

### Why Every 60 Minutes?
- ✅ Captures progress continuously
- ✅ **Includes production environment checks**
- ✅ Prevents losing context if session crashes
- ✅ Creates detailed audit trail
- ✅ Forces regular verification of live site
- ✅ Easy to resume from any point

### Set Reminders:
After each hourly update, note the time and set mental reminder for next hour.

**Example hourly commits:**
- "Hourly update: Audited 3/5 deployment scripts, production verified working"
- "Hourly update: Consolidated 4/8 folders, staging tested successfully"
- "Hourly update: Production deployment completed, backups verified"

---

## ⚠️ CRITICAL: MANDATORY LAST ACTION

**BEFORE ending the session, you MUST:**

### 1. Final Update to SESSION_HANDOFF.md
Update these sections:
- **Current Status** → What's done, in progress, blocking
- **Production Environment** → Latest verification status
- **What Just Got Completed** → This session's accomplishments
- **Session Notes** → What happened, problems encountered, changes made
- **Handoff Checklist** → Check off completed items
- **Last Updated** → Current date/time
- **Version History** → Add entry for this update

### 2. Commit the Updated File
```bash
git add SESSION_HANDOFF.md
git commit -m "Session handoff update: [brief description of session]"
```

### 3. Verify Commit Success
```bash
git log --oneline -1
git status
```

**DO NOT end the session without doing this. The next AI will be blind without it.**

---

## 📋 Session Workflow

### Every Session Should Follow This Pattern:

1. **START:** Read SESSION_HANDOFF.md
2. **UNDERSTAND:** Review current state and blockers
3. **WORK:** Execute highest priority tasks
4. **UPDATE (Every 60 min):** Quick progress update + production check
5. **DOCUMENT:** Update SESSION_HANDOFF.md as you go
6. **COMMIT:** Save updated handoff before ending

---

## 🔄 Hourly Production Verification

**Every 60-minute update MUST include production check:**

### Quick Production Health Check:
```bash
# 1. Check if site is up
curl -I https://stupidiots.com

# 2. Verify specific pages
curl -s https://stupidiots.com/ | grep -i "idiot token"
curl -I https://stupidiots.com/airdrop/

# 3. Update SESSION_HANDOFF.md with status
```

### Document in handoff:
- Site status (✅ up / ❌ down / ⚠️ issues)
- Timestamp of check
- Any errors or anomalies
- Response time (if slow)

### Example hourly update note:
```
## 14:30 Hourly Update
- Progress: Completed script audit (3/5 done)
- Production: ✅ Verified up at 14:28 - 200 OK - 450ms response
- Next: Continue with remaining 2 scripts
- Blockers: None
```

---

## 🚨 CRITICAL SAFETY RULES

### NEVER:
- ❌ Run deployment scripts without auditing them first
- ❌ Execute commands that delete files without confirmation
- ❌ Push to production without staging test
- ❌ Make commits without user approval (except handoff updates)
- ❌ Skip reading SESSION_HANDOFF.md at start
- ❌ Skip updating SESSION_HANDOFF.md at end
- ❌ Go more than 60 minutes without updating handoff
- ❌ Skip production verification during hourly updates

### ALWAYS:
- ✅ Read SESSION_HANDOFF.md first thing
- ✅ Update SESSION_HANDOFF.md every 60 minutes
- ✅ Verify production status during hourly updates
- ✅ Ask user before destructive operations
- ✅ Test in staging before production
- ✅ Create backups before deployments
- ✅ Update SESSION_HANDOFF.md at end
- ✅ Commit the updated handoff file

---

## 📁 Key Files You Should Know About

| File | Purpose | When to Read | When to Update |
|------|---------|--------------|----------------|
| `SESSION_HANDOFF.md` | Complete current state | **START of session** | **Every 60 min + END** |
| `SESSION_HANDOFF_TEMPLATE.md` | Template for updates | When updating handoff | Never (it's a template) |
| `_STATUS.md` | Quick status | If handoff is unclear | When major status changes |
| `_START_HERE.md` | Session instructions | If confused about process | Rarely |
| `README.md` | Project overview | For general context | When structure changes |
| `docs/WORKFLOW.md` | Deployment workflow | Before any deployment | When workflow changes |

---

## ⏱️ Time Management & Updates

### Typical Session Timeline:

```
00:00 - START: Read SESSION_HANDOFF.md
00:05 - BEGIN: Start work on highest priority task
01:00 - UPDATE: First hourly update + production check
02:00 - UPDATE: Second hourly update + production check
03:00 - UPDATE: Third hourly update + production check
[...]
END - FINAL UPDATE: Complete handoff update + commit
```

### What to Include in Each Hourly Update:

| Section | What to Update |
|---------|---------------|
| Production Environment | Latest check status, timestamp |
| What We're Working On | Current task progress |
| Session Notes | Work completed this hour |
| Changes Made | Any files modified |
| Last Updated | Current timestamp |

### Keep It Quick (5 minutes max per update):
- Don't overthink it
- Just capture current state
- Focus on: What's done, what's next, production OK?
- Commit and continue working

---

## 🎯 Priority System

When multiple tasks are pending, prioritize:

1. **CRITICAL (Do First):**
   - Safety issues (audit dangerous scripts)
   - Production down/errors
   - Blockers preventing other work
   - Production emergencies

2. **HIGH (Do Soon):**
   - Server access verification
   - File verification (prod vs local)
   - Consolidating scattered folders

3. **MEDIUM (Do When Possible):**
   - GitHub setup
   - CI/CD configuration
   - Documentation improvements

4. **LOW (Future):**
   - Nice-to-have features
   - Optimization
   - Cleanup tasks

---

## 🤝 Working With The User

### Communication Style:
- Be direct and concise
- Don't make excuses for failures
- Ask clear questions
- Provide specific actionable steps

### When User Says "Proceed":
1. Check SESSION_HANDOFF.md for context
2. Continue the highest priority pending task
3. If unclear which task, ask specifically
4. Update handoff every 60 minutes as you work

### When You Don't Know Something:
1. Check SESSION_HANDOFF.md first
2. If not there, ask the user
3. Document the answer in SESSION_HANDOFF.md
4. Don't guess or assume

---

## 📊 Progress Tracking

### Use the TODO System:
- Create TODOs for multi-step tasks
- Update status as you progress
- Mark complete when done
- Don't leave stale TODOs

### Update These in SESSION_HANDOFF.md:
- Current TODO list (every update)
- Completed tasks (as they happen)
- Blocked tasks (as discovered)
- New discoveries (immediately)

---

## 🔄 Handoff Quality Checklist

### For Hourly Updates (Quick):
- [ ] "What We're Working On" is current
- [ ] Production status checked and documented
- [ ] Timestamp updated
- [ ] Progress note added to Session Notes
- [ ] Committed to git

### For Final Session Update (Complete):
- [ ] Current date/time in header
- [ ] "What We're Working On" is accurate
- [ ] "What's Blocking Us" is complete
- [ ] "What Just Got Completed" includes this session's work
- [ ] Production Environment section is current
- [ ] All file paths are accurate
- [ ] All statuses (✅/❌/❓) are current
- [ ] Session Notes section updated
- [ ] Changes Made table updated
- [ ] Handoff Checklist reviewed
- [ ] Version History has new entry
- [ ] File is committed to git

---

## 💡 Tips for Success

1. **Read First, Act Second:** Always read SESSION_HANDOFF.md before doing anything
2. **Update Often:** Every 60 minutes without fail
3. **Check Production:** Include health check in every hourly update
4. **Be Specific:** "Audited 3 of 5 scripts" is better than "Made progress"
5. **Document Decisions:** Capture WHY decisions were made
6. **Note Blockers:** If stuck, document what's blocking and why
7. **Commit Frequently:** Hourly updates create natural checkpoints
8. **Test Assumptions:** Verify file paths, server access, etc.
9. **Ask When Unsure:** Better to ask than to make wrong assumptions
10. **Set Timer:** Actually track 60 minutes (use system clock)

---

## 🚀 First Session Checklist

If this is your first time working on this project:

1. [ ] Read SESSION_HANDOFF.md completely
2. [ ] Read _START_HERE.md
3. [ ] Read README.md for project overview
4. [ ] Review docs/WORKFLOW.md for deployment process
5. [ ] Check git status
6. [ ] Verify production is up (first check!)
7. [ ] Understand what's in progress
8. [ ] Understand what's blocking
9. [ ] Note start time for first 60-min update
10. [ ] Ask user if anything is unclear
11. [ ] Continue highest priority task

---

## ⏰ Hourly Update Template

Copy this into SESSION_HANDOFF.md every hour:

```markdown
## [TIME] Hourly Update
- **Progress:** [What was accomplished this hour]
- **Production:** [✅/❌/⚠️ + verification time + status]
- **Current Task:** [What you're working on now]
- **Next Hour:** [What you'll work on next]
- **Blockers:** [None / List any]
- **Timestamp:** [YYYY-MM-DD HH:MM]
```

---

**Remember:** 
- The quality of your handoff determines the efficiency of the next session
- Hourly updates prevent losing context and track production health
- Production verification every hour catches issues early
- Take the time to do it right

---

**Version:** 2.0 (with 60-minute updates)  
**Created:** 2025-10-16  
**Updated:** 2025-10-16 (added hourly update requirement)  
**For:** All AI assistants working on the IDIOT Token project
