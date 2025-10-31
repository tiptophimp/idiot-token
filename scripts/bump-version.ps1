# Bump Version Script
# Automatically increments version number in index.html footer
# Format: v5.0 -> v5.1 (patch), v5.9 -> v6.0 (minor), etc.

$ErrorActionPreference = "Stop"

$indexFile = "index.html"

if (-not (Test-Path $indexFile)) {
    Write-Host "[ERROR] index.html not found" -ForegroundColor Red
    exit 1
}

# Read current version
$content = Get-Content $indexFile -Raw
$versionPattern = 'v(\d+)\.(\d+)'
$match = [regex]::Match($content, $versionPattern)

if (-not $match.Success) {
    Write-Host "[ERROR] Version pattern not found in index.html" -ForegroundColor Red
    Write-Host "Looking for pattern: v5.0" -ForegroundColor Yellow
    exit 1
}

$majorVersion = [int]$match.Groups[1].Value
$minorVersion = [int]$match.Groups[2].Value
$currentVersion = "v$majorVersion.$minorVersion"

# Increment patch version (5.0 -> 5.1, 5.1 -> 5.2, etc.)
$minorVersion++
$newVersion = "v$majorVersion.$minorVersion"

# Replace version in file
$updatedContent = $content -replace [regex]::Escape($currentVersion), $newVersion
Set-Content -Path $indexFile -Value $updatedContent -NoNewline

Write-Host "[OK] Version updated: $currentVersion -> $newVersion" -ForegroundColor Green

# Return new version for use in commit message
Write-Output $newVersion

