#!/bin/bash

# IDIOT Token Website - Automated Deployment Script
# This script automatically deploys changes to your server

# Configuration
SERVER_IP="68.183.149.106"
SERVER_USER="root"  # Change this to your server username
SERVER_PATH="/var/www/html"  # Change this to your website directory
LOCAL_PATH="."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Starting IDIOT Token Website Deployment...${NC}"

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo -e "${RED}❌ Error: Not in a git repository${NC}"
    exit 1
fi

# Get the latest commit hash
COMMIT_HASH=$(git rev-parse HEAD)
echo -e "${YELLOW}📝 Deploying commit: ${COMMIT_HASH}${NC}"

# Create deployment package
echo -e "${YELLOW}📦 Creating deployment package...${NC}"
tar -czf deployment.tar.gz --exclude='.git' --exclude='*.log' --exclude='node_modules' .

# Upload to server
echo -e "${YELLOW}📤 Uploading to server...${NC}"
scp -i "idiot-token-automation.2025-10-09.private-key.pem" deployment.tar.gz ${SERVER_USER}@${SERVER_IP}:/tmp/

# Deploy on server
echo -e "${YELLOW}🔧 Deploying on server...${NC}"
ssh -i "idiot-token-automation.2025-10-09.private-key.pem" ${SERVER_USER}@${SERVER_IP} << EOF
    # Backup current website
    if [ -d "${SERVER_PATH}" ]; then
        cp -r ${SERVER_PATH} ${SERVER_PATH}.backup.$(date +%Y%m%d_%H%M%S)
    fi
    
    # Extract new files
    cd ${SERVER_PATH}
    tar -xzf /tmp/deployment.tar.gz
    
    # Set proper permissions
    chmod -R 755 ${SERVER_PATH}
    chmod 644 ${SERVER_PATH}/assets/img/*
    chmod 644 ${SERVER_PATH}/assets/docs/*
    chmod 644 ${SERVER_PATH}/docs/*
    
    # Clean up
    rm /tmp/deployment.tar.gz
    
    echo "✅ Deployment completed successfully!"
EOF

# Clean up local files
rm deployment.tar.gz

echo -e "${GREEN}✅ Deployment completed successfully!${NC}"
echo -e "${GREEN}🌐 Website: https://stupidiots.com${NC}"
echo -e "${YELLOW}📝 Deployed commit: ${COMMIT_HASH}${NC}"
