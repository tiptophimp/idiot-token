# Quick Deploy Script - Always Bumps Version
# Use this for quick deployments that automatically bump version

$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Quick Deploy (Auto Version Bump)" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Bump version
Write-Host "[1/3] Bumping version..." -ForegroundColor Yellow
$versionScript = Join-Path $PSScriptRoot "bump-version.ps1"
if (-not (Test-Path $versionScript)) {
    Write-Host "[ERROR] Version bump script not found" -ForegroundColor Red
    exit 1
}

$newVersion = & powershell -ExecutionPolicy Bypass -File $versionScript
if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Version bump failed!" -ForegroundColor Red
    exit 1
}

Write-Host "[OK] Version bumped to: $newVersion" -ForegroundColor Green

# Step 2: Create backup
Write-Host ""
Write-Host "[2/3] Creating backup..." -ForegroundColor Yellow
$backupScript = Join-Path $PSScriptRoot "create-rolling-backup.ps1"
if (Test-Path $backupScript) {
    & powershell -ExecutionPolicy Bypass -File $backupScript | Out-Null
}

# Step 3: Commit and push
Write-Host ""
Write-Host "[3/3] Committing and pushing..." -ForegroundColor Yellow

# Check current branch
$currentBranch = git rev-parse --abbrev-ref HEAD
if ($currentBranch -ne "gh-pages") {
    Write-Host "Switching to gh-pages branch..." -ForegroundColor Yellow
    git checkout gh-pages
}

# Add all changes
git add -A

# Commit with version in message
$commitMsg = "$newVersion Release: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
git commit -m $commitMsg

# Push to production
git push origin gh-pages

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Deployment Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Version: $newVersion" -ForegroundColor Cyan
Write-Host "URL: https://www.stupidiots.com" -ForegroundColor White
Write-Host ""

