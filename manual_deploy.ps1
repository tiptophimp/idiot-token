# Manual Deployment Script for Stupidiots.com
# This script deploys files manually when GitHub Actions fails

Write-Host "🚀 Starting Manual Deployment to Stupidiots.com" -ForegroundColor Green

# Check if cleaned_deployment exists
if (-not (Test-Path "cleaned_deployment")) {
    Write-Host "❌ cleaned_deployment directory not found!" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Found cleaned_deployment directory" -ForegroundColor Green

# Create deployment package
Write-Host "📦 Creating deployment package..." -ForegroundColor Yellow
if (Test-Path "deploy-package.zip") {
    Remove-Item "deploy-package.zip"
}
Compress-Archive -Path "cleaned_deployment\*" -DestinationPath "deploy-package.zip"

Write-Host "✅ Deployment package created: deploy-package.zip" -ForegroundColor Green

# SSH connection details
$SSH_HOST = "us-bos-web1384.main-hosting.eu"
$SSH_USER = "u939125353"
$SSH_PORT = "65002"
$SSH_KEY = "hostinger_deploy_key"
$REMOTE_PATH = "/home/u939125353/domains/stupidiots.com/public_html/"

Write-Host "🔑 Testing SSH connection..." -ForegroundColor Yellow

# Test SSH connection
$sshTest = ssh -o StrictHostKeyChecking=no -p $SSH_PORT -i $SSH_KEY $SSH_USER@$SSH_HOST "echo 'SSH connection successful'"
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ SSH connection successful" -ForegroundColor Green
} else {
    Write-Host "❌ SSH connection failed!" -ForegroundColor Red
    exit 1
}

Write-Host "📤 Deploying files..." -ForegroundColor Yellow

# Deploy using SCP (Windows compatible)
$files = Get-ChildItem "cleaned_deployment" -Recurse -File
foreach ($file in $files) {
    $relativePath = $file.FullName.Replace((Get-Location).Path + "\cleaned_deployment\", "").Replace("\", "/")
    $remoteFile = $REMOTE_PATH + $relativePath
    
    Write-Host "Uploading: $relativePath" -ForegroundColor Cyan
    
    # Create directory if needed
    $remoteDir = Split-Path $remoteFile -Parent
    ssh -o StrictHostKeyChecking=no -p $SSH_PORT -i $SSH_KEY $SSH_USER@$SSH_HOST "mkdir -p '$remoteDir'"
    
    # Upload file
    scp -P $SSH_PORT -i $SSH_KEY -o StrictHostKeyChecking=no $file.FullName $SSH_USER@$SSH_HOST`:$remoteFile
}

Write-Host "✅ Deployment completed!" -ForegroundColor Green
Write-Host "🌐 Check your site at: https://stupidiots.com" -ForegroundColor Cyan

# Verify deployment
Write-Host "🔍 Verifying deployment..." -ForegroundColor Yellow
$verification = ssh -o StrictHostKeyChecking=no -p $SSH_PORT -i $SSH_KEY $SSH_USER@$SSH_HOST "ls -la $REMOTE_PATH/index.html"
Write-Host "Server file info: $verification" -ForegroundColor Cyan

Write-Host "🎉 Manual deployment completed successfully!" -ForegroundColor Green
