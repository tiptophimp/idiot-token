# IDIOT Token Website - Local Deployment Script
# PowerShell script for Windows

Write-Host "🚀 Starting IDIOT Token Website Deployment..." -ForegroundColor Green

# Configuration
$SERVER_IP = "68.183.149.106"
$SERVER_USER = "root"
$SERVER_PATH = "/var/www/html"
$LOCAL_PATH = "."

# Check if we're in a git repository
if (-not (Test-Path ".git")) {
    Write-Host "❌ Error: Not in a git repository" -ForegroundColor Red
    exit 1
}

# Get the latest commit hash
$COMMIT_HASH = git rev-parse HEAD
Write-Host "📝 Deploying commit: $COMMIT_HASH" -ForegroundColor Yellow

# Create deployment package
Write-Host "📦 Creating deployment package..." -ForegroundColor Yellow
Compress-Archive -Path @("*.md", "*.csv", "*.txt", "*.xlsx", "*.json", "*.zip", "*.docx", "*.pem", "*.sh") -DestinationPath "deployment.zip" -Force

# Upload to server using SCP
Write-Host "📤 Uploading to server..." -ForegroundColor Yellow
scp -i "idiot-token-automation.2025-10-09.private-key.pem" deployment.zip ${SERVER_USER}@${SERVER_IP}:/tmp/

# Deploy on server
Write-Host "🔧 Deploying on server..." -ForegroundColor Yellow
ssh -i "idiot-token-automation.2025-10-09.private-key.pem" ${SERVER_USER}@${SERVER_IP} @"
    # Backup current website
    if [ -d '$SERVER_PATH' ]; then
        cp -r $SERVER_PATH $SERVER_PATH.backup.$(date +%Y%m%d_%H%M%S)
    fi
    
    # Extract new files
    cd $SERVER_PATH
    unzip -o /tmp/deployment.zip
    
    # Set proper permissions
    chmod -R 755 $SERVER_PATH
    chmod 644 $SERVER_PATH/assets/img/* 2>/dev/null || true
    chmod 644 $SERVER_PATH/assets/docs/* 2>/dev/null || true
    chmod 644 $SERVER_PATH/docs/* 2>/dev/null || true
    
    # Clean up
    rm /tmp/deployment.zip
    
    echo '✅ Deployment completed successfully!'
"@

# Clean up local files
Remove-Item deployment.zip

Write-Host "✅ Deployment completed successfully!" -ForegroundColor Green
Write-Host "🌐 Website: https://stupidiots.com" -ForegroundColor Green
Write-Host "📝 Deployed commit: $COMMIT_HASH" -ForegroundColor Yellow
