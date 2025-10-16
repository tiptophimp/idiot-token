#!/bin/bash
# Hourly reminder script for session updates
# Run this in background at session start: bash scripts/hourly-reminder.sh &

echo "⏰ Hourly update reminder started..."
echo "Will remind every 60 minutes to update SESSION_HANDOFF.md"
echo ""

while true; do
    sleep 3600  # 60 minutes = 3600 seconds
    
    echo ""
    echo "════════════════════════════════════════════════════════════"
    echo "⏰ 60 MINUTES ELAPSED - TIME FOR HOURLY UPDATE!"
    echo "════════════════════════════════════════════════════════════"
    echo ""
    echo "📋 DO THIS NOW:"
    echo "  1. Check production: curl -I https://stupidiots.com"
    echo "  2. Update SESSION_HANDOFF.md with:"
    echo "     - Progress made this hour"
    echo "     - Production status"
    echo "     - Current timestamp"
    echo "  3. Commit: git add SESSION_HANDOFF.md && git commit -m 'Hourly update'"
    echo ""
    echo "Use prompt: See .cursor/prompts/hourly-update.md"
    echo "════════════════════════════════════════════════════════════"
    echo ""
done

