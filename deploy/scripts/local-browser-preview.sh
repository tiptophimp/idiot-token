#!/usr/bin/env bash
# OPEN LOCAL FILES IN BROWSER FOR REVIEW
# Opens dev files directly in browser (no cache issues)

set -euo pipefail

# Configuration
DEV_DIR="${DEV_DIR:-C:/idiot-project/website/dev}"
INDEX_FILE="${INDEX_FILE:-index.html}"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}═══════════════════════════════════════════════${NC}"
echo -e "${BLUE}       LOCAL BROWSER PREVIEW${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════${NC}"
echo ""

# Check if dev directory exists
if [ ! -d "$DEV_DIR" ]; then
    echo -e "${RED}✗ Dev directory not found: $DEV_DIR${NC}"
    exit 1
fi

# Check if index file exists
FULL_PATH="$DEV_DIR/$INDEX_FILE"
if [ ! -f "$FULL_PATH" ]; then
    echo -e "${YELLOW}⚠ Index file not found: $INDEX_FILE${NC}"
    echo ""
    echo "Available files:"
    ls -1 "$DEV_DIR"/*.html 2>/dev/null || echo "  No HTML files found"
    exit 1
fi

echo -e "${GREEN}✓ Opening in browser:${NC}"
echo "  File: $INDEX_FILE"
echo "  Path: $FULL_PATH"
echo ""

# Open in default browser (Windows)
if [ -n "${WINDIR:-}" ]; then
    # Convert Unix path to Windows path for native commands
    WIN_PATH=$(echo "$FULL_PATH" | sed 's|^/c/|C:/|')
    start "$WIN_PATH"
    echo -e "${GREEN}✓ Browser opened${NC}"
else
    # Linux/Mac
    if command -v xdg-open &> /dev/null; then
        xdg-open "$FULL_PATH"
    elif command -v open &> /dev/null; then
        open "$FULL_PATH"
    else
        echo -e "${YELLOW}⚠ Could not auto-open browser${NC}"
        echo "  Manually open: $FULL_PATH"
    fi
fi

echo ""
echo -e "${YELLOW}📋 Review Checklist:${NC}"
echo "  [ ] All text displays correctly"
echo "  [ ] All images load"
echo "  [ ] All links work"
echo "  [ ] Layout looks good"
echo "  [ ] Mobile responsive (resize window)"
echo "  [ ] No console errors (F12)"
echo ""
echo -e "${GREEN}When satisfied, proceed to staging deployment.${NC}"
echo ""

