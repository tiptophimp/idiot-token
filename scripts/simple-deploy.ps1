# Simple SCP-based deployment to stupidiots.com

$ErrorActionPreference = "Continue"

$HOST_IP = "68.183.149.106"
$USER = "deploy"
$KEY = "deploy\ssh-keys\deploy_key"
$SRC_DIR = "public_html"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Deploying to stupidiots.com via SCP" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Uploading files to server..." -ForegroundColor Yellow
Write-Host "(This may take a few minutes)" -ForegroundColor Gray
Write-Host ""

# Use scp to recursively copy all files
& "C:\Program Files\Git\usr\bin\scp.exe" -i $KEY -r "$SRC_DIR\*" "${USER}@${HOST_IP}:/var/www/stupidiots.com/public_html/"

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "  Deployment Complete!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Site: https://stupidiots.com/" -ForegroundColor White
    Write-Host "Please hard refresh your browser (Ctrl+Shift+R)" -ForegroundColor Yellow
    Write-Host ""
} else {
    Write-Host ""
    Write-Host "[ERROR] Deployment failed" -ForegroundColor Red
    Write-Host "Exit code: $LASTEXITCODE" -ForegroundColor Red
    Write-Host ""
}

