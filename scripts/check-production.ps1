# Quick production health check script (PowerShell)
# Use this during hourly updates - NO USER INPUT REQUIRED

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Production Health Check" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check main site
Write-Host "Checking Main Site..." -ForegroundColor Yellow
Write-Host "URL: https://stupidiots.com" -ForegroundColor Gray

$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
try {
    $response = Invoke-WebRequest -Uri "https://stupidiots.com" -Method Head -TimeoutSec 10 -ErrorAction Stop
    $stopwatch.Stop()
    $status = $response.StatusCode
    $elapsed = $stopwatch.ElapsedMilliseconds
    
    if ($status -eq 200) {
        Write-Host "[OK] Status: UP (HTTP $status)" -ForegroundColor Green
        Write-Host "     Response Time: ${elapsed}ms" -ForegroundColor Green
    } else {
        Write-Host "[WARN] Status: ISSUE (HTTP $status)" -ForegroundColor Yellow
        Write-Host "       Response Time: ${elapsed}ms" -ForegroundColor Yellow
    }
    $mainOk = $true
} catch {
    $stopwatch.Stop()
    Write-Host "[ERROR] Status: DOWN" -ForegroundColor Red
    Write-Host "        Response Time: $($stopwatch.ElapsedMilliseconds)ms" -ForegroundColor Red
    Write-Host "        Error: $($_.Exception.Message)" -ForegroundColor Red
    $mainOk = $false
    $status = 0
    $elapsed = $stopwatch.ElapsedMilliseconds
}

Write-Host ""

# Check airdrop page
Write-Host "Checking Airdrop Page..." -ForegroundColor Yellow
Write-Host "URL: https://stupidiots.com/airdrop/" -ForegroundColor Gray

$stopwatch2 = [System.Diagnostics.Stopwatch]::StartNew()
try {
    $airdropResponse = Invoke-WebRequest -Uri "https://stupidiots.com/airdrop/" -Method Head -TimeoutSec 10 -ErrorAction Stop
    $stopwatch2.Stop()
    $airdropStatus = $airdropResponse.StatusCode
    $airdropElapsed = $stopwatch2.ElapsedMilliseconds
    
    if ($airdropStatus -eq 200) {
        Write-Host "[OK] Status: UP (HTTP $airdropStatus)" -ForegroundColor Green
        Write-Host "     Response Time: ${airdropElapsed}ms" -ForegroundColor Green
    } else {
        Write-Host "[WARN] Status: ISSUE (HTTP $airdropStatus)" -ForegroundColor Yellow
        Write-Host "       Response Time: ${airdropElapsed}ms" -ForegroundColor Yellow
    }
    $airdropOk = $true
} catch {
    $stopwatch2.Stop()
    Write-Host "[ERROR] Status: DOWN" -ForegroundColor Red
    Write-Host "        Response Time: $($stopwatch2.ElapsedMilliseconds)ms" -ForegroundColor Red
    Write-Host "        Error: $($_.Exception.Message)" -ForegroundColor Red
    $airdropOk = $false
    $airdropStatus = 0
    $airdropElapsed = $stopwatch2.ElapsedMilliseconds
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Summary" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Checked at: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Gray
Write-Host ""

# Overall status
if ($mainOk -and $airdropOk) {
    Write-Host "[OK] ALL SYSTEMS OPERATIONAL" -ForegroundColor Green
    Write-Host ""
    Write-Host "Copy this to SESSION_HANDOFF.md:" -ForegroundColor Cyan
    Write-Host "----------------------------------------" -ForegroundColor Gray
    $avgTime = [math]::Round(($elapsed + $airdropElapsed) / 2)
    $timestamp = Get-Date -Format 'HH:mm'
    Write-Host "Production: [OK] Verified up at $timestamp - All pages OK - Avg ${avgTime}ms" -ForegroundColor White
} else {
    Write-Host "[WARN] ISSUES DETECTED" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Copy this to SESSION_HANDOFF.md:" -ForegroundColor Cyan
    Write-Host "----------------------------------------" -ForegroundColor Gray
    $timestamp = Get-Date -Format 'HH:mm'
    Write-Host "Production: [WARN] Issues detected at $timestamp - See details" -ForegroundColor White
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
