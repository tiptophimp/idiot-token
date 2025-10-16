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
- All critical context needed

### 2. Summarize the Current State
Tell the user:
- What we're currently working on
- What the blockers are
- What the next steps should be

**DO NOT skip this step. Without it, you'll waste time asking questions that are already answered.**

---

## ⚠️ CRITICAL: MANDATORY LAST ACTION

**BEFORE ending the session, you MUST:**

### 1. Update SESSION_HANDOFF.md
Update these sections:
- **Current Status** → What's done, in progress, blocking
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
4. **DOCUMENT:** Update SESSION_HANDOFF.md as you go
5. **COMMIT:** Save updated handoff before ending

---

## 🚨 CRITICAL SAFETY RULES

### NEVER:
- ❌ Run deployment scripts without auditing them first
- ❌ Execute commands that delete files without confirmation
- ❌ Push to production without staging test
- ❌ Make commits without user approval (except handoff updates)
- ❌ Skip reading SESSION_HANDOFF.md at start
- ❌ Skip updating SESSION_HANDOFF.md at end

### ALWAYS:
- ✅ Read SESSION_HANDOFF.md first thing
- ✅ Ask user before destructive operations
- ✅ Test in staging before production
- ✅ Create backups before deployments
- ✅ Update SESSION_HANDOFF.md at end
- ✅ Commit the updated handoff file

---

## 📁 Key Files You Should Know About

| File | Purpose | When to Read | When to Update |
|------|---------|--------------|----------------|
| `SESSION_HANDOFF.md` | Complete current state | **START of session** | **END of session** |
| `SESSION_HANDOFF_TEMPLATE.md` | Template for updates | When updating handoff | Never (it's a template) |
| `_STATUS.md` | Quick status | If handoff is unclear | When major status changes |
| `_START_HERE.md` | Session instructions | If confused about process | Rarely |
| `README.md` | Project overview | For general context | When structure changes |
| `docs/WORKFLOW.md` | Deployment workflow | Before any deployment | When workflow changes |

---

## 🎯 Priority System

When multiple tasks are pending, prioritize:

1. **CRITICAL (Do First):**
   - Safety issues (audit dangerous scripts)
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
4. Update handoff as you work

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
- Current TODO list
- Completed tasks
- Blocked tasks
- New discoveries

---

## 🔄 Handoff Quality Checklist

Before ending session, verify SESSION_HANDOFF.md has:

- [ ] Current date/time in header
- [ ] "What We're Working On" is accurate
- [ ] "What's Blocking Us" is complete
- [ ] "What Just Got Completed" includes this session's work
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
2. **Update Often:** Update the handoff file as you work, not just at the end
3. **Be Specific:** "Audited 3 of 5 scripts" is better than "Made progress"
4. **Document Decisions:** Capture WHY decisions were made
5. **Note Blockers:** If stuck, document what's blocking and why
6. **Commit Frequently:** Save progress to git often
7. **Test Assumptions:** Verify file paths, server access, etc.
8. **Ask When Unsure:** Better to ask than to make wrong assumptions

---

## 🚀 First Session Checklist

If this is your first time working on this project:

1. [ ] Read SESSION_HANDOFF.md completely
2. [ ] Read _START_HERE.md
3. [ ] Read README.md for project overview
4. [ ] Review docs/WORKFLOW.md for deployment process
5. [ ] Check git status
6. [ ] Understand what's in progress
7. [ ] Understand what's blocking
8. [ ] Ask user if anything is unclear
9. [ ] Continue highest priority task

---

**Remember:** The quality of your handoff determines the efficiency of the next session. Take the time to do it right.

---

**Version:** 1.0  
**Created:** 2025-10-16  
**For:** All AI assistants working on the IDIOT Token project

