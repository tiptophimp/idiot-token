# IDIOT Token - Deploy to STAGING
Write-Host "🧪 Deploying to STAGING environment..." -ForegroundColor Yellow
Write-Host ""

# Create clean package with ONLY website files
Write-Host "📦 Creating deployment package..." -ForegroundColor Cyan
tar -czf deployment-staging.tar.gz index.html whitepaper.html tokenomics-interactive.html vesting-schedule.html community.html about.html assets/ airdrop/ careers/ docs/ explorer/ governance/ handbook/ jobs/ legal/ media/ meme-contest/ meme-generator/ merch/ news/ partnerships/ staking/ swap/ tools/

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to create deployment package" -ForegroundColor Red
    exit 1
}

# Upload to server
Write-Host "📤 Uploading to server..." -ForegroundColor Cyan
scp -i "$HOME\.ssh\idiot_deploy_key" -o StrictHostKeyChecking=no deployment-staging.tar.gz root@68.183.149.106:/tmp/

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Upload failed" -ForegroundColor Red
    rm deployment-staging.tar.gz
    exit 1
}

# Deploy to STAGING
Write-Host "🔧 Deploying to staging..." -ForegroundColor Cyan
ssh -i "$HOME\.ssh\idiot_deploy_key" -o StrictHostKeyChecking=no root@68.183.149.106 "cd /var/www/staging; rm -rf *; tar -xzf /tmp/deployment-staging.tar.gz; chown -R www-data:www-data /var/www/staging; chmod -R 755 /var/www/staging; find /var/www/staging -type f -exec chmod 644 {} \; ; rm /tmp/deployment-staging.tar.gz; echo 'Staging deployment complete'"

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Deployment failed" -ForegroundColor Red
    rm deployment-staging.tar.gz
    exit 1
}

# Cleanup local files
rm deployment-staging.tar.gz

Write-Host ""
Write-Host "✅ STAGING deployment successful!" -ForegroundColor Green
Write-Host ""
Write-Host "🧪 Test at: https://stupidiots.com/staging" -ForegroundColor Yellow
Write-Host ""
Write-Host "📝 After testing, promote to production with:" -ForegroundColor Cyan
Write-Host "   .\promote-to-production.ps1" -ForegroundColor White
Write-Host ""