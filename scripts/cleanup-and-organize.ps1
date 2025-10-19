# Cleanup and Organization Script for IDIOT Project
# Last Updated: October 19, 2025 - 9:15 AM

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  IDIOT Project Cleanup & Organization" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$ErrorActionPreference = "Continue"
$readyForDelete = "C:\ready_for_delete"

# Ensure ready_for_delete exists
if (-not (Test-Path $readyForDelete)) {
    New-Item -ItemType Directory -Path $readyForDelete -Force | Out-Null
    Write-Host "[OK] Created $readyForDelete" -ForegroundColor Green
}

Write-Host "Phase 1: Moving duplicate/old files to ready_for_delete..." -ForegroundColor Yellow
Write-Host ""

# List of items to move
$itemsToMove = @(
    "website\backups",
    "website\production-ready",
    "website\staging-ready",
    "idiot-site-clean",
    "explorer",
    "governance",
    "handbook",
    "jobs",
    "media",
    "merch",
    "news",
    "swap",
    "tools",
    "reports",
    "commit.js",
    "test.txt"
)

$movedCount = 0
foreach ($item in $itemsToMove) {
    $sourcePath = Join-Path -Path "." -ChildPath $item
    if (Test-Path $sourcePath) {
        $itemName = Split-Path -Path $item -Leaf
        $destPath = Join-Path -Path $readyForDelete -ChildPath $itemName
        try {
            Move-Item -Path $sourcePath -Destination $destPath -Force
            Write-Host "[OK] Moved: $itemName" -ForegroundColor Gray
            $movedCount++
        } catch {
            Write-Host "[SKIP] Could not move: $itemName" -ForegroundColor DarkGray
        }
    }
}

Write-Host ""
Write-Host "Phase 2: Organizing structure..." -ForegroundColor Yellow
Write-Host ""

# Ensure directories exist
$requiredDirs = @(
    "website\dev\docs",
    "website\dev\legal"
)

foreach ($dir in $requiredDirs) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
        Write-Host "[OK] Created: $dir" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Cleanup Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Moved $movedCount items to: $readyForDelete" -ForegroundColor White
Write-Host ""
