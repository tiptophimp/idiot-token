# Local deployment script for stupidiots.com
# Uses WinSCP command line for reliable SFTP upload

param(
    [switch]$Approve,
    [string]$CommitMessage = "deploy: local update"
)

$ErrorActionPreference = "Stop"

# Configuration
$DevFile = "C:\stupidiots_project\02_DEVELOPMENT\review_later\stupidiots_one_page_static_site_index.html"
$LiveFile = "C:\stupidiots_project\01_LIVE_SITE\main_site\index.html"
$BackupDir = "C:\stupidiots_project\05_ARCHIVES\backups"

# Server config
$SftpHost = "stupidiots.com"
$SftpUser = "u939125353"
$SftpPass = "sttZvydfnEmx7gH"  # Your SFTP password
$RemoteDir = "/home/u939125353/domains/stupidiots.com/public_html"

Write-Host "=== Stupidiots Local Deploy ===" -ForegroundColor Green

# Create backup
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$backupFile = "$BackupDir\backup_$timestamp.zip"
New-Item -ItemType Directory -Force -Path $BackupDir | Out-Null

Write-Host "Creating backup..." -ForegroundColor Yellow
Compress-Archive -Path "C:\stupidiots_project\01_LIVE_SITE\main_site\*" -DestinationPath $backupFile
Write-Host "Backup created: $backupFile" -ForegroundColor Green

# Update local files
Write-Host "Updating local files..." -ForegroundColor Yellow
Copy-Item $DevFile $LiveFile -Force

# Copy airdrop files
$airdropSource = "C:\stupidiots_project\02_DEVELOPMENT\review_later\airdrop"
$airdropDest = "C:\stupidiots_project\01_LIVE_SITE\main_site\airdrop"
if (Test-Path $airdropSource) {
    Copy-Item "$airdropSource\*" $airdropDest -Recurse -Force
}

# Copy assets
$assetsSource = "C:\stupidiots_project\02_DEVELOPMENT\review_later\assets"
$assetsDest = "C:\stupidiots_project\01_LIVE_SITE\main_site\assets"
if (Test-Path $assetsSource) {
    Copy-Item "$assetsSource\*" $assetsDest -Recurse -Force
}

Write-Host "Local files updated!" -ForegroundColor Green

# Git operations
Write-Host "Committing to Git..." -ForegroundColor Yellow
Set-Location "C:\stupidiots_project"
git add .
git commit -m $CommitMessage
git push

Write-Host "Git operations complete!" -ForegroundColor Green

# SFTP upload using WinSCP
Write-Host "Uploading to server via SFTP..." -ForegroundColor Yellow

$winscpScript = @"
option batch on
option confirm off
open sftp://$SftpUser`:$SftpPass@$SftpHost
cd $RemoteDir
put "C:\stupidiots_project\01_LIVE_SITE\main_site\index.html" index.html
mkdir airdrop
put "C:\stupidiots_project\01_LIVE_SITE\main_site\airdrop\*" airdrop/
mkdir assets
put "C:\stupidiots_project\01_LIVE_SITE\main_site\assets\*" assets/
exit
"@

$scriptFile = "$env:TEMP\winscp_deploy.txt"
$winscpScript | Set-Content $scriptFile -Encoding ASCII

try {
    # Try WinSCP first
    $winscpPath = Get-Command winscp.com -ErrorAction SilentlyContinue
    if ($winscpPath) {
        & winscp.com /ini=nul /script="$scriptFile"
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Upload successful via WinSCP!" -ForegroundColor Green
        } else {
            throw "WinSCP failed with exit code $LASTEXITCODE"
        }
    } else {
        # Fallback to native sftp
        Write-Host "WinSCP not found, trying native SFTP..." -ForegroundColor Yellow
        
        $sftpBatch = @"
cd $RemoteDir
put "C:\stupidiots_project\01_LIVE_SITE\main_site\index.html" index.html
mkdir airdrop
put "C:\stupidiots_project\01_LIVE_SITE\main_site\airdrop\*" airdrop/
mkdir assets  
put "C:\stupidiots_project\01_LIVE_SITE\main_site\assets\*" assets/
quit
"@
        
        $batchFile = "$env:TEMP\sftp_batch.txt"
        $sftpBatch | Set-Content $batchFile -Encoding ASCII
        
        & sftp -b "$batchFile" -oBatchMode=no -o StrictHostKeyChecking=no -P 22 "$SftpUser@$SftpHost"
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Upload successful via native SFTP!" -ForegroundColor Green
        } else {
            throw "Native SFTP failed with exit code $LASTEXITCODE"
        }
    }
} catch {
    Write-Host "Upload failed: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Files are ready locally. You can manually upload them via FTP client." -ForegroundColor Yellow
}

# Cleanup
Remove-Item $scriptFile -ErrorAction SilentlyContinue
Remove-Item "$env:TEMP\sftp_batch.txt" -ErrorAction SilentlyContinue

Write-Host "=== Deploy Complete ===" -ForegroundColor Green
Write-Host "Test your site at: https://stupidiots.com" -ForegroundColor Cyan
