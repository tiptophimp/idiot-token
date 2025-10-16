#!/usr/bin/env bash
# BACKUP ROTATION SYSTEM - Rolling 4 Backups
# Maintains exactly 4 most recent backups, deletes oldest

set -euo pipefail

# Configuration
BACKUP_DIR="${BACKUP_DIR:-C:/idiot-project/website/backups}"
SOURCE_DIR="${SOURCE_DIR:-C:/idiot-project/website/production-ready}"
MAX_BACKUPS=4

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}═══════════════════════════════════════════════${NC}"
echo -e "${YELLOW}    BACKUP ROTATION SYSTEM (Rolling 4)${NC}"
echo -e "${YELLOW}═══════════════════════════════════════════════${NC}"

# Ensure backup directory exists
mkdir -p "$BACKUP_DIR"

# Create timestamp for new backup
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_NAME="backup_${TIMESTAMP}.tar.gz"
BACKUP_PATH="${BACKUP_DIR}/${BACKUP_NAME}"

echo ""
echo -e "${GREEN}[1/4]${NC} Creating new backup..."
echo "      Source: $SOURCE_DIR"
echo "      Target: $BACKUP_PATH"

# Create backup
if [ -d "$SOURCE_DIR" ] && [ "$(ls -A $SOURCE_DIR)" ]; then
    tar -czf "$BACKUP_PATH" -C "$SOURCE_DIR" . 2>/dev/null
    BACKUP_SIZE=$(du -h "$BACKUP_PATH" | cut -f1)
    echo -e "      ${GREEN}✓ Backup created ($BACKUP_SIZE)${NC}"
else
    echo -e "      ${RED}✗ Source directory empty or doesn't exist${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}[2/4]${NC} Counting existing backups..."

# Count backups
BACKUP_COUNT=$(ls -1 "$BACKUP_DIR"/backup_*.tar.gz 2>/dev/null | wc -l)
echo "      Found: $BACKUP_COUNT backups"

echo ""
echo -e "${GREEN}[3/4]${NC} Managing backup rotation..."

if [ "$BACKUP_COUNT" -gt "$MAX_BACKUPS" ]; then
    EXCESS=$((BACKUP_COUNT - MAX_BACKUPS))
    echo "      Need to delete $EXCESS old backup(s)"
    
    # Delete oldest backups (keep newest 4)
    ls -1t "$BACKUP_DIR"/backup_*.tar.gz | tail -n +$((MAX_BACKUPS + 1)) | while read OLD_BACKUP; do
        echo "      Deleting: $(basename $OLD_BACKUP)"
        rm -f "$OLD_BACKUP"
    done
    echo -e "      ${GREEN}✓ Rotation complete${NC}"
else
    echo -e "      ${GREEN}✓ No rotation needed (${BACKUP_COUNT}/${MAX_BACKUPS} backups)${NC}"
fi

echo ""
echo -e "${GREEN}[4/4]${NC} Current backup inventory:"
echo ""
ls -lth "$BACKUP_DIR"/backup_*.tar.gz 2>/dev/null | awk '{printf "      %s  %s  %s\n", $6" "$7" "$8, $5, $9}' | head -n $MAX_BACKUPS

echo ""
echo -e "${GREEN}═══════════════════════════════════════════════${NC}"
echo -e "${GREEN}   ✓ BACKUP COMPLETE - ${BACKUP_COUNT} backups maintained${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════${NC}"
echo ""
echo "Latest backup: $BACKUP_NAME"
echo ""

