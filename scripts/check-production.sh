#!/bin/bash
# Quick production health check script
# Use this during hourly updates

echo "🔍 Checking Production Health..."
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📍 Main Site: https://stupidiots.com"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Check main site
START_TIME=$(date +%s%N)
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" https://stupidiots.com 2>&1)
END_TIME=$(date +%s%N)
ELAPSED=$((($END_TIME - $START_TIME) / 1000000))  # Convert to milliseconds

if [ "$RESPONSE" = "200" ]; then
    echo "✅ Status: UP (HTTP $RESPONSE)"
    echo "⏱️  Response Time: ${ELAPSED}ms"
else
    echo "❌ Status: ISSUE (HTTP $RESPONSE)"
    echo "⏱️  Response Time: ${ELAPSED}ms"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📍 Airdrop Page: https://stupidiots.com/airdrop/"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Check airdrop page
START_TIME=$(date +%s%N)
AIRDROP_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" https://stupidiots.com/airdrop/ 2>&1)
END_TIME=$(date +%s%N)
AIRDROP_ELAPSED=$((($END_TIME - $START_TIME) / 1000000))

if [ "$AIRDROP_RESPONSE" = "200" ]; then
    echo "✅ Status: UP (HTTP $AIRDROP_RESPONSE)"
    echo "⏱️  Response Time: ${AIRDROP_ELAPSED}ms"
else
    echo "❌ Status: ISSUE (HTTP $AIRDROP_RESPONSE)"
    echo "⏱️  Response Time: ${AIRDROP_ELAPSED}ms"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 Summary"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Checked at: $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

# Overall status
if [ "$RESPONSE" = "200" ] && [ "$AIRDROP_RESPONSE" = "200" ]; then
    echo "✅ Overall: ALL SYSTEMS OPERATIONAL"
    echo ""
    echo "📝 Add to SESSION_HANDOFF.md:"
    echo "Production: ✅ Verified up at $(date '+%H:%M') - All pages OK - Avg ${ELAPSED}ms"
else
    echo "⚠️  Overall: ISSUES DETECTED"
    echo ""
    echo "📝 Add to SESSION_HANDOFF.md:"
    echo "Production: ⚠️ Issues detected at $(date '+%H:%M') - See details"
fi

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

