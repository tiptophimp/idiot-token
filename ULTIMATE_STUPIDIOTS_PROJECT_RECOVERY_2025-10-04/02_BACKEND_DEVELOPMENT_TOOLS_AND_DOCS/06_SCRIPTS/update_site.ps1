# Stupidiots Site Update Script
param(
    [switch]$Backup,
    [switch]$Upload
)

$DevFile = "C:\stupidiots_project\02_DEVELOPMENT\review_later\stupidiots_one_page_static_site_index.html"
$LiveFile = "C:\stupidiots_project\01_LIVE_SITE\main_site\index.html"
$BackupDir = "C:\stupidiots_project\05_ARCHIVES\backups\$(Get-Date -Format 'yyyy-MM-dd_HH-mm-ss')"

Write-Host "🚀 Updating Stupidiots Site..." -ForegroundColor Green

# Create backup if requested
if ($Backup) {
    Write-Host "📦 Creating backup..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $BackupDir -Force | Out-Null
    Copy-Item $LiveFile "$BackupDir\index.html" -Force
    Write-Host "✅ Backup created: $BackupDir" -ForegroundColor Green
}

# Update main file
Write-Host "📝 Updating main site file..." -ForegroundColor Yellow
Copy-Item $DevFile $LiveFile -Force

# Update airdrop files
Write-Host "🎁 Updating airdrop files..." -ForegroundColor Yellow
$AirdropSource = "C:\stupidiots_project\02_DEVELOPMENT\review_later\airdrop\"
$AirdropDest = "C:\stupidiots_project\01_LIVE_SITE\main_site\airdrop\"
if (Test-Path $AirdropSource) {
    Copy-Item "$AirdropSource\*" $AirdropDest -Recurse -Force
}

# Update assets
Write-Host "🖼️ Updating assets..." -ForegroundColor Yellow
$AssetsSource = "C:\stupidiots_project\02_DEVELOPMENT\review_later\assets\"
$AssetsDest = "C:\stupidiots_project\01_LIVE_SITE\main_site\assets\"
if (Test-Path $AssetsSource) {
    Copy-Item "$AssetsSource\*" $AssetsDest -Recurse -Force
}

Write-Host "✅ Site update complete!" -ForegroundColor Green
Write-Host "📍 Live files ready at: C:\stupidiots_project\01_LIVE_SITE\main_site\" -ForegroundColor Cyan

if ($Upload) {
    Write-Host "🌐 Ready for server upload!" -ForegroundColor Magenta
}
