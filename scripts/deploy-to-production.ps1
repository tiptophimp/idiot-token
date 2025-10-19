# Deploy to stupidiots.com Production Server
# PowerShell version for Windows

$ErrorActionPreference = "Stop"

$HOST_IP = "68.183.149.106"
$USER = "deploy"
$KEY = "deploy\ssh-keys\deploy_key"
$SRC_DIR = "public_html"
$REMOTE_DIR = "/var/www/stupidiots.com/public_html"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Deploying to stupidiots.com" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if source directory exists
if (-not (Test-Path $SRC_DIR)) {
    Write-Host "[ERROR] Source directory not found: $SRC_DIR" -ForegroundColor Red
    exit 1
}

# Check if SSH key exists
if (-not (Test-Path $KEY)) {
    Write-Host "[ERROR] SSH key not found: $KEY" -ForegroundColor Red
    exit 1
}

# Create archive
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$archive = "site_upload_$timestamp.tar.gz"

Write-Host "[1/4] Creating archive..." -ForegroundColor Yellow
& "C:\Program Files\Git\usr\bin\tar.exe" -czf $archive -C $SRC_DIR .
Write-Host "[OK] Archive created: $archive" -ForegroundColor Green

# Upload archive
Write-Host "[2/4] Uploading to server..." -ForegroundColor Yellow
& "C:\Program Files\Git\usr\bin\scp.exe" -i $KEY $archive "${USER}@${HOST_IP}:/tmp/$archive"
Write-Host "[OK] Upload complete" -ForegroundColor Green

# Deploy on server (without sudo - assumes deploy user has write access)
Write-Host "[3/4] Deploying on server..." -ForegroundColor Yellow
$deployScript = @"
set -e
mkdir -p $REMOTE_DIR
rm -rf ${REMOTE_DIR}/*
tar -xzf /tmp/$archive -C $REMOTE_DIR
chmod -R 755 $REMOTE_DIR
rm -f /tmp/$archive
echo 'Deployment complete!'
"@

& "C:\Program Files\Git\usr\bin\ssh.exe" -i $KEY "${USER}@${HOST_IP}" $deployScript
Write-Host "[OK] Deployment complete" -ForegroundColor Green

# Cleanup
Write-Host "[4/4] Cleaning up..." -ForegroundColor Yellow
Remove-Item $archive -Force
Write-Host "[OK] Cleanup complete" -ForegroundColor Green

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Deployment Successful!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Site URL: https://stupidiots.com/" -ForegroundColor White
Write-Host "Please verify the deployment in your browser" -ForegroundColor White
Write-Host ""

