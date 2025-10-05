# Stupidiots GitHub + Server Update Script
# Integrates GitHub version control with server updates

param(
    [switch]$Approve,
    [string]$CommitMessage = "Site update - $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
)

$DevFile = "C:\stupidiots_project\02_DEVELOPMENT\review_later\stupidiots_one_page_static_site_index.html"
$LiveFile = "C:\stupidiots_project\01_LIVE_SITE\main_site\index.html"
$Timestamp = Get-Date -Format 'yyyy-MM-dd_HH-mm-ss'
$BackupDir = "C:\stupidiots_project\05_ARCHIVES\backups\$Timestamp"

# Server configuration
$ServerPath = "ftp://your-server.com/public_html/"
$Username = "your-username"
$Password = "your-password"

Write-Host "🚀 Stupidiots GitHub + Server Update" -ForegroundColor Green
Write-Host "====================================" -ForegroundColor Green

if (-not $Approve) {
    Write-Host "⚠️  This will update GitHub and the live server!" -ForegroundColor Red
    Write-Host "📋 Changes to be made:" -ForegroundColor Yellow
    Write-Host "   • Create timestamped backup: $Timestamp" -ForegroundColor Cyan
    Write-Host "   • Update local files from development" -ForegroundColor Cyan
    Write-Host "   • Commit changes to GitHub" -ForegroundColor Cyan
    Write-Host "   • Upload to server root" -ForegroundColor Cyan
    Write-Host "   • All files stay in root directory only" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "To proceed, run: .\github_update.ps1 -Approve" -ForegroundColor Magenta
    exit
}

Write-Host "✅ Update approved! Starting process..." -ForegroundColor Green

# Step 1: Create timestamped backup
Write-Host "📦 Creating backup: $Timestamp" -ForegroundColor Yellow
New-Item -ItemType Directory -Path $BackupDir -Force | Out-Null
Copy-Item $LiveFile "$BackupDir\index.html" -Force
Write-Host "✅ Backup created: $BackupDir" -ForegroundColor Green

# Step 2: Update local files
Write-Host "📝 Updating local files..." -ForegroundColor Yellow
Copy-Item $DevFile $LiveFile -Force
Write-Host "✅ Local files updated" -ForegroundColor Green

# Step 3: GitHub operations
Write-Host "🐙 Updating GitHub..." -ForegroundColor Yellow
try {
    # Navigate to project directory
    Set-Location "C:\stupidiots_project"
    
    # Add all changes
    git add .
    Write-Host "✅ Files staged for commit" -ForegroundColor Green
    
    # Commit with timestamp
    git commit -m $CommitMessage
    Write-Host "✅ Committed: $CommitMessage" -ForegroundColor Green
    
    # Push to GitHub
    git push
    Write-Host "✅ Pushed to GitHub" -ForegroundColor Green
    
} catch {
    Write-Host "❌ GitHub update failed: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "📁 Local files updated, but GitHub sync failed" -ForegroundColor Yellow
}

# Step 4: Upload to server
Write-Host "🌐 Uploading to server..." -ForegroundColor Yellow
try {
    $webClient = New-Object System.Net.WebClient
    $webClient.Credentials = New-Object System.Net.NetworkCredential($Username, $Password)
    
    # Upload main file
    $webClient.UploadFile("$ServerPath/index.html", $LiveFile)
    Write-Host "✅ index.html uploaded to server" -ForegroundColor Green
    
    # Upload airdrop files
    $AirdropSource = "C:\stupidiots_project\02_DEVELOPMENT\review_later\airdrop\"
    if (Test-Path $AirdropSource) {
        $airdropFiles = Get-ChildItem "$AirdropSource" -File
        foreach ($file in $airdropFiles) {
            $webClient.UploadFile("$ServerPath/airdrop/$($file.Name)", $file.FullName)
            Write-Host "✅ Uploaded: airdrop/$($file.Name)" -ForegroundColor Green
        }
    }
    
    # Upload assets
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
    Write-Host "✅ Server upload complete!" -ForegroundColor Green
    
} catch {
    Write-Host "❌ Server upload failed: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host "🎉 GITHUB + SERVER UPDATE COMPLETE!" -ForegroundColor Green
Write-Host "🐙 GitHub: Updated with commit" -ForegroundColor Cyan
Write-Host "🌐 Server: Live at https://stupidiots.com" -ForegroundColor Magenta
Write-Host "📦 Backup: $BackupDir" -ForegroundColor Cyan
