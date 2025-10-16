#!/usr/bin/env bash
# ROLLBACK PRODUCTION TO PREVIOUS BACKUP
# Interactive script to restore from rolling backups

set -euo pipefail

# Configuration
BACKUP_DIR="${BACKUP_DIR:-C:/idiot-project/website/backups}"
REMOTE_HOST="${REMOTE_HOST:-68.183.149.106}"
REMOTE_USER="${REMOTE_USER:-deploy}"
REMOTE_DIR="${REMOTE_DIR:-/var/www/stupidiots.com/public_html}"
SSH_KEY="${SSH_KEY:-C:/idiot-project/deploy/ssh-keys/deploy_key}"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${RED}═══════════════════════════════════════════════${NC}"
echo -e "${RED}     🚨 PRODUCTION ROLLBACK UTILITY 🚨${NC}"
echo -e "${RED}═══════════════════════════════════════════════${NC}"
echo ""

# Check for backups
if [ ! -d "$BACKUP_DIR" ]; then
    echo -e "${RED}✗ Backup directory not found: $BACKUP_DIR${NC}"
    exit 1
fi

BACKUPS=($(ls -1t "$BACKUP_DIR"/backup_*.tar.gz 2>/dev/null))
BACKUP_COUNT=${#BACKUPS[@]}

if [ $BACKUP_COUNT -eq 0 ]; then
    echo -e "${RED}✗ No backups found!${NC}"
    exit 1
fi

echo -e "${YELLOW}Available backups (newest first):${NC}"
echo ""

# List backups with numbers
for i in "${!BACKUPS[@]}"; do
    BACKUP="${BACKUPS[$i]}"
    BACKUP_NAME=$(basename "$BACKUP")
    BACKUP_DATE=$(echo "$BACKUP_NAME" | grep -oP '\d{8}_\d{6}')
    BACKUP_SIZE=$(du -h "$BACKUP" | cut -f1)
    FORMATTED_DATE=$(echo "$BACKUP_DATE" | sed 's/\([0-9]\{4\}\)\([0-9]\{2\}\)\([0-9]\{2\}\)_\([0-9]\{2\}\)\([0-9]\{2\}\)\([0-9]\{2\}\)/\1-\2-\3 \4:\5:\6/')
    
    echo -e "  ${GREEN}[$((i+1))]${NC} $FORMATTED_DATE ($BACKUP_SIZE)"
done

echo ""
echo -e "${YELLOW}Enter backup number to restore (1-$BACKUP_COUNT), or 'q' to quit:${NC}"
read -p "> " CHOICE

if [ "$CHOICE" = "q" ] || [ "$CHOICE" = "Q" ]; then
    echo "Rollback cancelled."
    exit 0
fi

# Validate choice
if ! [[ "$CHOICE" =~ ^[0-9]+$ ]] || [ "$CHOICE" -lt 1 ] || [ "$CHOICE" -gt $BACKUP_COUNT ]; then
    echo -e "${RED}✗ Invalid choice${NC}"
    exit 1
fi

SELECTED_BACKUP="${BACKUPS[$((CHOICE-1))]}"
SELECTED_NAME=$(basename "$SELECTED_BACKUP")

echo ""
echo -e "${RED}⚠️  WARNING ⚠️${NC}"
echo "You are about to restore production from:"
echo "  $SELECTED_NAME"
echo ""
echo "This will REPLACE the current production site!"
echo ""
read -p "Type 'CONFIRM' to proceed: " CONFIRM

if [ "$CONFIRM" != "CONFIRM" ]; then
    echo "Rollback cancelled."
    exit 0
fi

# Build SSH options
SSH_OPTS="-o StrictHostKeyChecking=no"
if [ -f "$SSH_KEY" ]; then
    SSH_OPTS="$SSH_OPTS -i $SSH_KEY"
fi

echo ""
echo -e "${GREEN}[1/4]${NC} Uploading backup to server..."
scp $SSH_OPTS "$SELECTED_BACKUP" "$REMOTE_USER@$REMOTE_HOST:/tmp/rollback.tar.gz"
echo -e "      ${GREEN}✓ Upload complete${NC}"

echo ""
echo -e "${GREEN}[2/4]${NC} Creating safety backup of current production..."
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
ssh $SSH_OPTS "$REMOTE_USER@$REMOTE_HOST" "sudo tar -czf /var/www/backups/pre_rollback_${TIMESTAMP}.tar.gz -C $REMOTE_DIR . 2>/dev/null || true"
echo -e "      ${GREEN}✓ Safety backup created${NC}"

echo ""
echo -e "${GREEN}[3/4]${NC} Restoring from backup..."
ssh $SSH_OPTS "$REMOTE_USER@$REMOTE_HOST" bash -s <<EOF
set -euo pipefail

# Clear current files
sudo rm -rf "$REMOTE_DIR"/*

# Extract backup
sudo tar -xzf /tmp/rollback.tar.gz -C "$REMOTE_DIR"

# Set permissions
sudo chown -R www-data:www-data "$REMOTE_DIR"
sudo chmod -R 755 "$REMOTE_DIR"

# Clean up
rm -f /tmp/rollback.tar.gz

# Reload nginx
sudo nginx -t && sudo systemctl reload nginx
EOF

echo -e "      ${GREEN}✓ Restoration complete${NC}"

echo ""
echo -e "${GREEN}[4/4]${NC} Verifying production..."
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" https://stupidiots.com/ || echo "000")

if [ "$HTTP_CODE" = "200" ]; then
    echo -e "      ${GREEN}✓ Site is online (HTTP $HTTP_CODE)${NC}"
else
    echo -e "      ${RED}⚠ Site returned HTTP $HTTP_CODE${NC}"
fi

echo ""
echo -e "${GREEN}═══════════════════════════════════════════════${NC}"
echo -e "${GREEN}   ✓ ROLLBACK COMPLETE${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════${NC}"
echo ""
echo "Restored from: $SELECTED_NAME"
echo "Check site: https://stupidiots.com"
echo ""

