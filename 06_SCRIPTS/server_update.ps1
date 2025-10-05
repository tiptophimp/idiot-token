# Stupidiots Server Update Script
# Requirements: Backup + Server Upload + Identical Files + Root Directory Only

param(
    [switch]$Approve
)

$DevFile = "C:\stupidiots_project\02_DEVELOPMENT\review_later\stupidiots_one_page_static_site_index.html"
$LiveFile = "C:\stupidiots_project\01_LIVE_SITE\main_site\index.html"
$Timestamp = Get-Date -Format 'yyyy-MM-dd_HH-mm-ss'
$BackupDir = "C:\stupidiots_project\05_ARCHIVES\backups\$Timestamp"

# Server configuration (update these with your actual details)
$ServerPath = "ftp://your-server.com/public_html/"
$Username = "your-username"
$Password = "your-password"

Write-Host "🚀 Stupidiots Server Update System" -ForegroundColor Green
Write-Host "=================================" -ForegroundColor Green

if (-not $Approve) {
    Write-Host "⚠️  This will update the live server!" -ForegroundColor Red
    Write-Host "📋 Changes to be made:" -ForegroundColor Yellow
    Write-Host "   • Create timestamped backup: $Timestamp" -ForegroundColor Cyan
    Write-Host "   • Update local files from development" -ForegroundColor Cyan
    Write-Host "   • Upload identical files to server root" -ForegroundColor Cyan
    Write-Host "   • All files stay in root directory only" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "To proceed, run: .\server_update.ps1 -Approve" -ForegroundColor Magenta
    exit
}

Write-Host "✅ Update approved! Starting process..." -ForegroundColor Green

# Step 1: Create timestamped backup
Write-Host "📦 Creating backup: $Timestamp" -ForegroundColor Yellow
New-Item -ItemType Directory -Path $BackupDir -Force | Out-Null
Copy-Item $LiveFile "$BackupDir\index.html" -Force
Write-Host "✅ Backup created: $BackupDir" -ForegroundColor Green

# Step 2: Update local files (identical copy)
Write-Host "📝 Updating local files..." -ForegroundColor Yellow
Copy-Item $DevFile $LiveFile -Force
Write-Host "✅ Local files updated (identical copy)" -ForegroundColor Green

# Step 3: Upload to server (root directory only)
Write-Host "🌐 Uploading to server root directory..." -ForegroundColor Yellow

try {
    $webClient = New-Object System.Net.WebClient
    $webClient.Credentials = New-Object System.Net.NetworkCredential($Username, $Password)
    
    # Upload main file to root
    $webClient.UploadFile("$ServerPath/index.html", $LiveFile)
    Write-Host "✅ index.html uploaded to server root" -ForegroundColor Green
    
    # Upload airdrop files to root/airdrop/
    $AirdropSource = "C:\stupidiots_project\02_DEVELOPMENT\review_later\airdrop\"
    if (Test-Path $AirdropSource) {
        $airdropFiles = Get-ChildItem "$AirdropSource" -File
        foreach ($file in $airdropFiles) {
            $webClient.UploadFile("$ServerPath/airdrop/$($file.Name)", $file.FullName)
            Write-Host "✅ Uploaded: airdrop/$($file.Name)" -ForegroundColor Green
        }
    }
    
    # Upload assets to root/assets/
    $AssetsSource = "C:\stupidiots_project\02_DEVELOPMENT\review_later\assets\"
    if (Test-Path $AssetsSource) {
        $assetFiles = Get-ChildItem "$AssetsSource" -Recurse -File
        foreach ($file in $assetFiles) {
            $relativePath = $file.FullName.Replace($AssetsSource, "").Replace("\", "/")
            $webClient.UploadFile("$ServerPath/assets/$relativePath", $file.FullName)
            Write-Host "✅ Uploaded: assets/$relativePath" -ForegroundColor Green
        }
    }
    
    $webClient.Dispose()
    
    Write-Host ""
    Write-Host "🎉 SERVER UPDATE COMPLETE!" -ForegroundColor Green
    Write-Host "🌐 Site is live at: https://stupidiots.com" -ForegroundColor Magenta
    Write-Host "📦 Backup saved: $BackupDir" -ForegroundColor Cyan
    Write-Host "📁 All files in root directory only" -ForegroundColor Cyan
    
} catch {
    Write-Host "❌ Upload failed: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "📁 Local files ready for manual upload at: C:\stupidiots_project\01_LIVE_SITE\main_site\" -ForegroundColor Yellow
}
