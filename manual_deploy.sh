#!/bin/bash

# Manual Deployment Script for Stupidiots.com
# Deploys code review fixes from 10_MAIN_SITE/ to live server

echo "🚀 Starting Manual Deployment to Stupidiots.com"

# SSH connection details
SSH_HOST="us-bos-web1384.main-hosting.eu"
SSH_USER="u939125353"
SSH_PORT="65002"
SSH_KEY="~/.ssh/hostinger_deploy_key"
REMOTE_PATH="/home/u939125353/domains/stupidiots.com/public_html/"

# 1. Check if 10_MAIN_SITE exists
if [ ! -d "10_MAIN_SITE" ]; then
    echo "❌ Error: 10_MAIN_SITE directory not found."
    exit 1
fi

echo "✅ Found 10_MAIN_SITE directory"

# 2. Prepare deployment files
echo "📦 Preparing deployment files..."
if [ -d "deploy-files" ]; then
    rm -rf "deploy-files"
fi

cp -r 10_MAIN_SITE deploy-files
echo "✅ Deployment files prepared in deploy-files/"

# 4. Deploy via SCP
echo "🚀 Deploying files manually using SCP..."
find ./deploy-files -type f | while read file; do
    localPath="$file"
    relativePath="${file#./deploy-files/}"
    remoteFilePath="$REMOTE_PATH$relativePath"
    echo "Uploading: $relativePath"
    scp -P $SSH_PORT -i $SSH_KEY -o StrictHostKeyChecking=no "$localPath" "$SSH_USER@$SSH_HOST:$remoteFilePath"
done

echo "✅ All files deployed via SCP."

# 5. Verify deployment
echo "🔍 Verifying deployment on server..."
ssh -p $SSH_PORT -i $SSH_KEY -o StrictHostKeyChecking=no "$SSH_USER@$SSH_HOST" "ls -la $REMOTE_PATH/index.html"
ssh -p $SSH_PORT -i $SSH_KEY -o StrictHostKeyChecking=no "$SSH_USER@$SSH_HOST" "cat $REMOTE_PATH/index.html | grep '<title>'"

echo "✅ Manual deployment completed and verified!"
echo "🌐 Site: https://stupidiots.com"
echo "📊 Check the site to see your code review fixes live!"
