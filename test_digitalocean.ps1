# DigitalOcean Deployment Test Script
# Tests if the migration to DigitalOcean was successful

Write-Host "🚀 Testing DigitalOcean Migration..." -ForegroundColor Green

$dropletIP = "31.97.13.9"
$domain = "stupidiots.com"

Write-Host "`n📡 Testing Droplet Connectivity..." -ForegroundColor Yellow
try {
    $pingResult = Test-Connection -ComputerName $dropletIP -Count 4 -Quiet
    if ($pingResult) {
        Write-Host "✅ Droplet is reachable at $dropletIP" -ForegroundColor Green
    } else {
        Write-Host "❌ Droplet is not reachable at $dropletIP" -ForegroundColor Red
    }
} catch {
    Write-Host "❌ Ping test failed: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n🌐 Testing Web Service..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://$dropletIP" -Method Head -TimeoutSec 10
    if ($response.StatusCode -eq 200) {
        Write-Host "✅ Web service is running on DigitalOcean" -ForegroundColor Green
        Write-Host "   Status Code: $($response.StatusCode)" -ForegroundColor Gray
    } else {
        Write-Host "❌ Web service returned status: $($response.StatusCode)" -ForegroundColor Red
    }
} catch {
    Write-Host "❌ Web service test failed: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n🔗 Testing Current Domain..." -ForegroundColor Yellow
try {
    $domainResponse = Invoke-WebRequest -Uri "https://$domain" -Method Head -TimeoutSec 10
    if ($domainResponse.StatusCode -eq 200) {
        Write-Host "✅ Domain is still active (Hostinger)" -ForegroundColor Green
        Write-Host "   Status Code: $($domainResponse.StatusCode)" -ForegroundColor Gray
    } else {
        Write-Host "❌ Domain returned status: $($domainResponse.StatusCode)" -ForegroundColor Red
    }
} catch {
    Write-Host "❌ Domain test failed: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n📋 Summary:" -ForegroundColor Cyan
Write-Host "• DigitalOcean IP: $dropletIP" -ForegroundColor Gray
Write-Host "• Current Domain: $domain (Hostinger)" -ForegroundColor Gray
Write-Host "• Migration Status: Check GitHub Actions for deployment progress" -ForegroundColor Gray

Write-Host "`n🔍 Next Steps:" -ForegroundColor Cyan
Write-Host "1. Check GitHub Actions: https://github.com/tiptophimp/idiot-token/actions" -ForegroundColor White
Write-Host "2. If DigitalOcean is working, migrate DNS to point to $dropletIP" -ForegroundColor White
Write-Host "3. Update SSL certificates after DNS migration" -ForegroundColor White
