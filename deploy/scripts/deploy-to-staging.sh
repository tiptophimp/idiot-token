#!/usr/bin/env bash
# DEPLOY TO STAGING SERVER
# Creates backup, deploys to https://stupidiots.com/staging

set -euo pipefail

# Configuration
SOURCE_DIR="${SOURCE_DIR:-C:/idiot-project/website/staging-ready}"
REMOTE_HOST="${REMOTE_HOST:-68.183.149.106}"
REMOTE_USER="${REMOTE_USER:-deploy}"
REMOTE_DIR="${REMOTE_DIR:-/var/www/staging}"
SSH_KEY="${SSH_KEY:-C:/idiot-project/deploy/ssh-keys/deploy_key}"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}═══════════════════════════════════════════════${NC}"
echo -e "${BLUE}       DEPLOY TO STAGING SERVER${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════${NC}"
echo ""

# Step 1: Verify source exists
echo -e "${GREEN}[1/5]${NC} Verifying source directory..."
if [ ! -d "$SOURCE_DIR" ] || [ -z "$(ls -A $SOURCE_DIR)" ]; then
    echo -e "${RED}✗ Source directory empty or doesn't exist: $SOURCE_DIR${NC}"
    exit 1
fi
FILE_COUNT=$(find "$SOURCE_DIR" -type f | wc -l)
echo -e "      ${GREEN}✓ Found $FILE_COUNT files ready to deploy${NC}"

# Step 2: Create backup
echo ""
echo -e "${GREEN}[2/5]${NC} Creating backup before deployment..."
bash "$(dirname "$0")/backup-rotation.sh"
if [ $? -ne 0 ]; then
    echo -e "${RED}✗ Backup failed! Aborting deployment.${NC}"
    exit 1
fi

# Step 3: Create deployment archive
echo ""
echo -e "${GREEN}[3/5]${NC} Creating deployment package..."
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
ARCHIVE="staging_deploy_${TIMESTAMP}.tar.gz"
tar -czf "/tmp/$ARCHIVE" -C "$SOURCE_DIR" . 2>/dev/null
ARCHIVE_SIZE=$(du -h "/tmp/$ARCHIVE" | cut -f1)
echo -e "      ${GREEN}✓ Archive created ($ARCHIVE_SIZE)${NC}"

# Step 4: Upload and deploy
echo ""
echo -e "${GREEN}[4/5]${NC} Uploading to staging server..."
echo "      Host: $REMOTE_USER@$REMOTE_HOST"
echo "      Path: $REMOTE_DIR"

# Build SSH options
SSH_OPTS="-o StrictHostKeyChecking=no"
if [ -f "$SSH_KEY" ]; then
    SSH_OPTS="$SSH_OPTS -i $SSH_KEY"
fi

# Upload archive
scp $SSH_OPTS "/tmp/$ARCHIVE" "$REMOTE_USER@$REMOTE_HOST:/tmp/$ARCHIVE" 2>/dev/null
echo -e "      ${GREEN}✓ Upload complete${NC}"

# Deploy on server
echo ""
echo -e "${GREEN}[5/5]${NC} Deploying on staging server..."
ssh $SSH_OPTS "$REMOTE_USER@$REMOTE_HOST" bash -s <<EOF
set -euo pipefail

# Create backup of current staging (just in case)
if [ -d "$REMOTE_DIR" ]; then
    sudo tar -czf "/var/www/backups/staging_backup_${TIMESTAMP}.tar.gz" -C "$REMOTE_DIR" . 2>/dev/null || true
fi

# Create directory if it doesn't exist
sudo mkdir -p "$REMOTE_DIR"

# Clear old files (SAFE VERSION)
if [ -d "$REMOTE_DIR" ]; then
    echo "Clearing old files in $REMOTE_DIR..."
    # Validate path contains expected content before clearing
    if [ -f "$REMOTE_DIR/index.html" ] || [ -d "$REMOTE_DIR/assets" ]; then
        echo "Found website files, proceeding with safe cleanup..."
        # Only remove files, not the directory itself
        sudo find "$REMOTE_DIR" -mindepth 1 -maxdepth 1 -exec rm -rf {} \;
    else
        echo "WARNING: Directory doesn't contain expected website files, skipping cleanup"
        echo "Contents: $(ls -la "$REMOTE_DIR")"
        read -p "Continue anyway? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            sudo find "$REMOTE_DIR" -mindepth 1 -maxdepth 1 -exec rm -rf {} \;
        else
            echo "Aborted for safety"
            exit 1
        fi
    fi
else
    echo "Directory $REMOTE_DIR does not exist, skipping cleanup"
fi

# Extract new files
sudo tar -xzf "/tmp/$ARCHIVE" -C "$REMOTE_DIR"

# Set permissions
sudo chown -R www-data:www-data "$REMOTE_DIR"
sudo chmod -R 755 "$REMOTE_DIR"

# Clean up
rm -f "/tmp/$ARCHIVE"

# Test nginx config and reload
sudo nginx -t && sudo systemctl reload nginx || true

echo "Deployment complete!"
EOF

# Cleanup local archive
rm -f "/tmp/$ARCHIVE"

echo ""
echo -e "${GREEN}═══════════════════════════════════════════════${NC}"
echo -e "${GREEN}   ✓ STAGING DEPLOYMENT COMPLETE${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════${NC}"
echo ""
echo -e "${YELLOW}🌐 View your changes:${NC}"
echo -e "   https://stupidiots.com/staging"
echo ""
echo -e "${YELLOW}📋 Next steps:${NC}"
echo "   1. Test thoroughly on staging"
echo "   2. Check all links and functionality"
echo "   3. If approved, proceed to production deployment"
echo ""

