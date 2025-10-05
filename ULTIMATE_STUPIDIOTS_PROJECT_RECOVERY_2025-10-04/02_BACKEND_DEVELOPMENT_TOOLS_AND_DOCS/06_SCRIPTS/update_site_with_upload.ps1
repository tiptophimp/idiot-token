# Stupidiots Site Update + Server Upload Script
param(
    [switch]$Backup,
    [string]$ServerPath = "ftp://your-server.com/public_html/",
    [string]$Username = "your-username",
    [string]$Password = "your-password"
)

$DevFile = "C:\stupidiots_project\02_DEVELOPMENT\review_later\stupidiots_one_page_static_site_index.html"
$LiveFile = "C:\stupidiots_project\01_LIVE_SITE\main_site\index.html"
$BackupDir = "C:\stupidiots_project\05_ARCHIVES\backups\$(Get-Date -Format 'yyyy-MM-dd_HH-mm-ss')"

Write-Host "🚀 Updating Stupidiots Site + Uploading to Server..." -ForegroundColor Green

# Create backup if requested
if ($Backup) {
    Write-Host "📦 Creating backup..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $BackupDir -Force | Out-Null
    Copy-Item $LiveFile "$BackupDir\index.html" -Force
    Write-Host "✅ Backup created: $BackupDir" -ForegroundColor Green
}

# Update local files
Write-Host "📝 Updating local files..." -ForegroundColor Yellow
Copy-Item $DevFile $LiveFile -Force

# Update airdrop files
$AirdropSource = "C:\stupidiots_project\02_DEVELOPMENT\review_later\airdrop\"
$AirdropDest = "C:\stupidiots_project\01_LIVE_SITE\main_site\airdrop\"
if (Test-Path $AirdropSource) {
    Copy-Item "$AirdropSource\*" $AirdropDest -Recurse -Force
}

# Update assets
$AssetsSource = "C:\stupidiots_project\02_DEVELOPMENT\review_later\assets\"
$AssetsDest = "C:\stupidiots_project\01_LIVE_SITE\main_site\assets\"
if (Test-Path $AssetsSource) {
    Copy-Item "$AssetsSource\*" $AssetsDest -Recurse -Force
}

Write-Host "✅ Local files updated!" -ForegroundColor Green

# Upload to server
Write-Host "🌐 Uploading to server..." -ForegroundColor Yellow

try {
    # Upload main file
    $webClient = New-Object System.Net.WebClient
    $webClient.Credentials = New-Object System.Net.NetworkCredential($Username, $Password)
    $webClient.UploadFile("$ServerPath/index.html", $LiveFile)
    
    # Upload airdrop files
    $airdropFiles = Get-ChildItem "$AirdropDest" -Recurse -File
    foreach ($file in $airdropFiles) {
        $relativePath = $file.FullName.Replace($AirdropDest, "").Replace("\", "/")
        $serverPath = "$ServerPath/airdrop/$relativePath"
        $webClient.UploadFile($serverPath, $file.FullName)
    }
    
    # Upload assets
    $assetFiles = Get-ChildItem "$AssetsDest" -Recurse -File
    foreach ($file in $assetFiles) {
        $relativePath = $file.FullName.Replace($AssetsDest, "").Replace("\", "/")
        $serverPath = "$ServerPath/assets/$relativePath"
        $webClient.UploadFile($serverPath, $file.FullName)
    }
    
    $webClient.Dispose()
    Write-Host "✅ Server upload complete!" -ForegroundColor Green
    Write-Host "🌐 Site is now live at: https://stupidiots.com" -ForegroundColor Magenta
    
} catch {
    Write-Host "❌ Upload failed: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "📁 Local files are ready for manual upload at: C:\stupidiots_project\01_LIVE_SITE\main_site\" -ForegroundColor Yellow
}
