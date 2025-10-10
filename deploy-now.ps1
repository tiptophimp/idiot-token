# IDIOT Token - One-Command Deploy
Write-Host "🚀 Deploying IDIOT Token website..." -ForegroundColor Cyan

# Create package
tar -czf deployment.tar.gz --exclude=".git" --exclude="secure" --exclude="*.pem" --exclude="*password*" --exclude="deployment.tar.gz" .

# Upload
scp -i "$env:USERPROFILE\.ssh\idiot_deploy_key" -o StrictHostKeyChecking=no deployment.tar.gz root@68.183.149.106:/tmp/

# Deploy
ssh -i "$env:USERPROFILE\.ssh\idiot_deploy_key" -o StrictHostKeyChecking=no root@68.183.149.106 "cd /var/www/html && tar -xzf /tmp/deployment.tar.gz && mkdir -p assets/docs && chown -R www-data:www-data /var/www/html && chmod -R 755 /var/www/html && find /var/www/html -type f -exec chmod 644 {} \; && rm /tmp/deployment.tar.gz"

# Cleanup
rm deployment.tar.gz

Write-Host ""
Write-Host "✅ Deployment successful!" -ForegroundColor Green
Write-Host "🌐 Website: https://stupidiots.com" -ForegroundColor Cyan

