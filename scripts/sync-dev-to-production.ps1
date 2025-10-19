# Sync Development Files to Production Root
# This script copies all files from website/dev/ to the root for GitHub Pages deployment

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Syncing Dev to Production Root" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$ErrorActionPreference = "Stop"

# Ensure we're on gh-pages branch
$currentBranch = git branch --show-current
if ($currentBranch -ne "gh-pages") {
    Write-Host "[ERROR] Must be on gh-pages branch. Current: $currentBranch" -ForegroundColor Red
    exit 1
}

Write-Host "[OK] On gh-pages branch" -ForegroundColor Green
Write-Host ""

# Sync main index.html
Write-Host "Syncing main index.html..." -ForegroundColor Yellow
Copy-Item -Path "website\dev\index.html" -Destination "index.html" -Force
Write-Host "[OK] index.html synced" -ForegroundColor Green

# Sync assets
Write-Host "Syncing assets..." -ForegroundColor Yellow
if (Test-Path "website\dev\assets\logo.png") {
    Copy-Item -Path "website\dev\assets\logo.png" -Destination "assets\logo.png" -Force
    Write-Host "[OK] logo.png synced" -ForegroundColor Green
}

# Sync staking page
Write-Host "Syncing staking page..." -ForegroundColor Yellow
if (Test-Path "website\dev\staking\index.html") {
    Copy-Item -Path "website\dev\staking\index.html" -Destination "staking\index.html" -Force
    Write-Host "[OK] staking/index.html synced" -ForegroundColor Green
}

# Sync partnerships page
Write-Host "Syncing partnerships page..." -ForegroundColor Yellow
if (Test-Path "website\dev\partnerships\index.html") {
    Copy-Item -Path "website\dev\partnerships\index.html" -Destination "partnerships\index.html" -Force
    Write-Host "[OK] partnerships/index.html synced" -ForegroundColor Green
}

# Sync educational guides
Write-Host "Syncing educational guides..." -ForegroundColor Yellow
if (Test-Path "website\dev\docs") {
    $htmlFiles = Get-ChildItem -Path "website\dev\docs\*.html"
    foreach ($file in $htmlFiles) {
        Copy-Item -Path $file.FullName -Destination "docs\$($file.Name)" -Force
        Write-Host "[OK] docs/$($file.Name) synced" -ForegroundColor Green
    }
}

# Sync legal pages
Write-Host "Syncing legal pages..." -ForegroundColor Yellow
if (Test-Path "website\dev\legal") {
    if (-not (Test-Path "legal")) {
        New-Item -ItemType Directory -Path "legal" -Force | Out-Null
    }
    Copy-Item -Path "website\dev\legal\*" -Destination "legal\" -Force
    Write-Host "[OK] legal pages synced" -ForegroundColor Green
}

# Sync other pages
$otherPages = @("whitepaper.html", "tokenomics-interactive.html", "vesting-schedule.html", "community.html", "about.html")
Write-Host "Syncing other pages..." -ForegroundColor Yellow
foreach ($page in $otherPages) {
    if (Test-Path "website\dev\$page") {
        Copy-Item -Path "website\dev\$page" -Destination $page -Force
        Write-Host "[OK] $page synced" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Sync Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Review changes: git status" -ForegroundColor White
Write-Host "2. Commit: git add -A && git commit -m 'Sync dev to production'" -ForegroundColor White
Write-Host "3. Push: git push origin gh-pages" -ForegroundColor White
Write-Host ""

