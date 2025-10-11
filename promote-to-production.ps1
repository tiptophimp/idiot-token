# IDIOT Token - Promote Staging to Production
Write-Host "🚀 Promoting STAGING to PRODUCTION..." -ForegroundColor Magenta
Write-Host ""

# Confirm with user
Write-Host "⚠️  This will replace the LIVE website with staging content!" -ForegroundColor Red
Write-Host ""
$confirmation = Read-Host "Type 'YES' to continue"

if ($confirmation -ne "YES") {
    Write-Host "❌ Promotion cancelled" -ForegroundColor Yellow
    exit 0
}

Write-Host ""
Write-Host "📦 Promoting to production..." -ForegroundColor Cyan

# Promote on server
ssh -i "$HOME\.ssh\idiot_deploy_key" -o StrictHostKeyChecking=no root@68.183.149.106 "BACKUP_DIR=/var/www/html.backup.\$(date +%Y%m%d_%H%M%S); cp -r /var/www/html \$BACKUP_DIR; echo 'Backup created: '\$BACKUP_DIR; cd /var/www/html; rm -rf *; cp -r /var/www/staging/* /var/www/html/; chown -R www-data:www-data /var/www/html; chmod -R 755 /var/www/html; find /var/www/html -type f -exec chmod 644 {} \; ; echo 'Production updated from staging'"

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Promotion failed" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "✅ PRODUCTION updated successfully!" -ForegroundColor Green
Write-Host "🌐 Live site: https://stupidiots.com" -ForegroundColor Cyan
Write-Host ""
Write-Host "💡 Clear browser cache (Ctrl+F5) to see changes" -ForegroundColor Yellow
Write-Host ""

# Get current git branch and commit
$gitBranch = git rev-parse --abbrev-ref HEAD
$gitCommit = git rev-parse --short HEAD

Write-Host "📝 Deployed: $gitBranch @ $gitCommit" -ForegroundColor Gray
Write-Host ""

