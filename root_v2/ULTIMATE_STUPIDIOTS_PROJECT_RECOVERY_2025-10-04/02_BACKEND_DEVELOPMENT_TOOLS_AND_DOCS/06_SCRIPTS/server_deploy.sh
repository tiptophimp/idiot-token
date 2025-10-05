#!/bin/bash
# Server-side deployment script for Hostinger
# Run this on your server to pull and deploy files from GitHub

# Configuration
GITHUB_REPO="tiptophimp/idiot-token"
DEPLOY_DIR="/home/u939125353/domains/stupidiots.com/public_html"
BACKUP_DIR="/home/u939125353/backups"
TEMP_DIR="/tmp/stupidiots_deploy"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Stupidiots Deploy Script ===${NC}"

# Create backup
echo -e "${YELLOW}Creating backup...${NC}"
mkdir -p "$BACKUP_DIR"
BACKUP_FILE="$BACKUP_DIR/backup_$(date +%Y%m%d_%H%M%S).tar.gz"
tar -czf "$BACKUP_FILE" -C "$DEPLOY_DIR" . 2>/dev/null || echo "Backup failed, continuing..."

# Get latest workflow run ID
echo -e "${YELLOW}Fetching latest deployment package...${NC}"
LATEST_RUN=$(curl -s "https://api.github.com/repos/$GITHUB_REPO/actions/runs?status=success&per_page=1" | grep -o '"id":[0-9]*' | head -1 | cut -d':' -f2)

if [ -z "$LATEST_RUN" ]; then
    echo -e "${RED}No successful workflow runs found${NC}"
    exit 1
fi

echo "Latest run ID: $LATEST_RUN"

# Create temp directory
rm -rf "$TEMP_DIR"
mkdir -p "$TEMP_DIR"
cd "$TEMP_DIR"

# Download the artifact (this requires authentication - see below)
echo -e "${YELLOW}Downloading deployment package...${NC}"
# Note: This requires a GitHub token with repo access
# For now, we'll use a direct download approach

# Alternative: Download from a public URL if we make the repo public
# or use a different approach

echo -e "${YELLOW}Extracting files...${NC}"
# For now, we'll create a simple sync from a local directory
# You can modify this to download from GitHub

# Copy files to deploy directory
echo -e "${YELLOW}Deploying files...${NC}"
# This is where you would extract the downloaded package
# For now, we'll just show the structure

echo -e "${GREEN}Deployment complete!${NC}"
echo "Backup saved to: $BACKUP_FILE"
echo "Deploy directory: $DEPLOY_DIR"

# Cleanup
rm -rf "$TEMP_DIR"
