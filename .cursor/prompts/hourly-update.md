# Hourly Update Prompt (Use Every 60 Minutes)

```
It's been 60 minutes. Perform hourly update:

1. Check production status:
   - Verify https://stupidiots.com is up
   - Test key pages (/, /airdrop/)
   - Note response time and any issues

2. Update SESSION_HANDOFF.md:
   - Add hourly update note with timestamp
   - Update "Production Environment" section
   - Update "What We're Working On"
   - Update "Session Notes" with progress
   - Update "Last Updated" timestamp

3. Commit the update:
   git add SESSION_HANDOFF.md
   git commit -m "Hourly update: [brief status]"

4. Continue work and set reminder for next hour
```

## Quick Template

```markdown
## [HH:MM] Hourly Update
- **Progress:** [Completed this hour]
- **Production:** ✅ Verified up at [HH:MM] - [Status] - [Response time]
- **Current Task:** [Working on]
- **Next Hour:** [Plan]
- **Blockers:** [None/List]
```

