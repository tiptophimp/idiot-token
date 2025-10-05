# Manual deployment script for stupidiots.com
# This creates a deployment package you can upload manually

param(
    [switch]$CreatePackage
)

$ErrorActionPreference = "Stop"

$SourceDir = "C:\stupidiots_project\01_LIVE_SITE\main_site"
$PackageDir = "C:\stupidiots_project\06_SCRIPTS\deploy_packages"
$PackageName = "stupidiots_deploy_$(Get-Date -Format 'yyyyMMdd_HHmmss').zip"

Write-Host "=== Manual Deploy Package Creator ===" -ForegroundColor Green

# Create package directory
New-Item -ItemType Directory -Force -Path $PackageDir | Out-Null

# Create deployment package
Write-Host "Creating deployment package..." -ForegroundColor Yellow
Set-Location $SourceDir
Compress-Archive -Path "*" -DestinationPath "$PackageDir\$PackageName" -Force

Write-Host "Package created: $PackageDir\$PackageName" -ForegroundColor Green
Write-Host "Package size: $((Get-Item "$PackageDir\$PackageName").Length / 1MB) MB" -ForegroundColor Cyan

Write-Host "`n=== Upload Instructions ===" -ForegroundColor Yellow
Write-Host "1. Go to your Hostinger File Manager" -ForegroundColor White
Write-Host "2. Navigate to: /home/u939125353/domains/stupidiots.com/public_html/" -ForegroundColor White
Write-Host "3. Upload the package: $PackageName" -ForegroundColor White
Write-Host "4. Extract the ZIP file in the public_html directory" -ForegroundColor White
Write-Host "5. Delete the ZIP file after extraction" -ForegroundColor White

Write-Host "`n=== Alternative: Use FTP Client ===" -ForegroundColor Yellow
Write-Host "Upload all files from: $SourceDir" -ForegroundColor White
Write-Host "To: /home/u939125353/domains/stupidiots.com/public_html/" -ForegroundColor White

Write-Host "`nPackage ready for upload!" -ForegroundColor Green
