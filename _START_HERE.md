# ⚠️ START HERE - READ THIS FIRST ⚠️

## 🚨 MANDATORY FIRST STEP FOR EVERY SESSION

**Before doing ANYTHING else:**

### 1. **AI Assistant: Read the handoff file**
```
Read file: SESSION_HANDOFF.md
```
This contains ALL the context you need to continue work.

### 2. **Human: Always start with this prompt**
```
Read SESSION_HANDOFF.md and tell me what we're working on
```

### 3. **Note the start time** (for 60-minute updates)
- Write down current time
- Set reminder for 60 minutes from now

---

## ⏰ MANDATORY: UPDATE EVERY 60 MINUTES

**Every 60 minutes during active work:**

### 1. **Check production status**
```bash
bash scripts/check-production.sh
```
Or manually: Visit https://stupidiots.com and verify it's working

### 2. **Quick update to SESSION_HANDOFF.md**
- Add hourly update note with timestamp
- Update production status
- Note progress made this hour
- What you're working on next

### 3. **Quick commit**
```bash
git add SESSION_HANDOFF.md
git commit -m "Hourly update: [brief status]"
```

**Why every 60 minutes?**
- ✅ Tracks production health continuously
- ✅ Prevents losing progress if session crashes
- ✅ Creates detailed audit trail
- ✅ Forces regular verification of live site

**Use this prompt every hour:**
```
See .cursor/prompts/hourly-update.md for instructions
```

---

## 📋 MANDATORY LAST STEP FOR EVERY SESSION

**Before ending the session:**

### 1. **AI Assistant: Final update to handoff file**
- Update SESSION_HANDOFF.md with:
  - What was completed this session
  - What's in progress
  - What's blocking
  - Latest production status
  - Current state of all systems
  - Any new discoveries

### 2. **Commit the updated file**
```bash
git add SESSION_HANDOFF.md
git commit -m "Session handoff update: [brief description]"
```

### 3. **Human: Check the checklist**
Open SESSION_HANDOFF.md and verify the "HANDOFF CHECKLIST" section is complete.

---

## ⚠️ NEVER SKIP THIS

**Every session MUST:**
- ✅ Start by reading SESSION_HANDOFF.md
- ✅ End by updating SESSION_HANDOFF.md
- ✅ Commit the updated file

**If you don't do this, the next session will be blind and waste time.**

---

**This file exists at:**
- `C:\idiot-project\_START_HERE.md` ← You're here
- Every folder in the project has a copy (coming soon)


