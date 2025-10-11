# IDIOT Token - Clean Deployment Script
Write-Host "🚀 Deploying IDIOT Token website (CLEAN)..." -ForegroundColor Cyan

# Create clean package with ONLY website files
Write-Host "📦 Creating clean deployment package..." -ForegroundColor Yellow
tar -czf deployment-clean.tar.gz `
    index.html `
    whitepaper.html `
    tokenomics-interactive.html `
    vesting-schedule.html `
    community.html `
    about.html `
    assets/ `
    airdrop/ `
    careers/ `
    docs/ `
    explorer/ `
    governance/ `
    handbook/ `
    jobs/ `
    legal/ `
    media/ `
    meme-contest/ `
    meme-generator/ `
    merch/ `
    news/ `
    partnerships/ `
    staking/ `
    swap/ `
    tools/

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to create deployment package" -ForegroundColor Red
    exit 1
}

# Upload to server
Write-Host "📤 Uploading to server..." -ForegroundColor Yellow
scp -i "$HOME\.ssh\idiot_deploy_key" -o StrictHostKeyChecking=no deployment-clean.tar.gz root@68.183.149.106:/tmp/

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Upload failed" -ForegroundColor Red
    rm deployment-clean.tar.gz
    exit 1
}

# Deploy on server
Write-Host "🔧 Extracting and setting permissions..." -ForegroundColor Yellow
ssh -i "$HOME\.ssh\idiot_deploy_key" -o StrictHostKeyChecking=no root@68.183.149.106 @"
cd /var/www/html && \
tar -xzf /tmp/deployment-clean.tar.gz && \
chown -R www-data:www-data /var/www/html && \
chmod -R 755 /var/www/html && \
find /var/www/html -type f -exec chmod 644 {} \; && \
rm /tmp/deployment-clean.tar.gz && \
echo '✅ Files deployed successfully'
"@

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Deployment failed" -ForegroundColor Red
    rm deployment-clean.tar.gz
    exit 1
}

# Cleanup local files
rm deployment-clean.tar.gz

Write-Host ""
Write-Host "✅ Deployment successful!" -ForegroundColor Green
Write-Host "🌐 Website: https://stupidiots.com" -ForegroundColor Cyan
Write-Host "📝 Version: v2.0" -ForegroundColor Cyan
Write-Host ""
Write-Host "💡 Clear browser cache (Ctrl+F5) to see latest version" -ForegroundColor Yellow
