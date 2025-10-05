# Manual Deployment Script for Stupidiots.com
# Run this locally to deploy to Hostinger

param(
    [switch]$CreatePackage,
    [switch]$Upload
)

$ErrorActionPreference = "Stop"

# Configuration
$SourceDir = "cleaned_deployment"
$PackageName = "stupidiots_deploy_$(Get-Date -Format 'yyyyMMdd_HHmmss').zip"
$PackagePath = ".\$PackageName"

Write-Host "🚀 Stupidiots Manual Deployment Script" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Green

if ($CreatePackage) {
    Write-Host "📦 Creating deployment package..." -ForegroundColor Yellow
    
    if (-not (Test-Path $SourceDir)) {
        Write-Host "❌ Source directory '$SourceDir' not found!" -ForegroundColor Red
        exit 1
    }
    
    # Create ZIP package
    Compress-Archive -Path "$SourceDir\*" -DestinationPath $PackageName -Force
    
    Write-Host "✅ Package created: $PackageName" -ForegroundColor Green
    Write-Host "📊 Package size: $((Get-Item $PackageName).Length / 1MB) MB" -ForegroundColor Cyan
}

if ($Upload) {
    Write-Host "🌐 Upload Instructions:" -ForegroundColor Yellow
    Write-Host "1. Go to Hostinger File Manager: https://hpanel.hostinger.com/file-manager" -ForegroundColor White
    Write-Host "2. Navigate to: /public_html/" -ForegroundColor White
    Write-Host "3. Upload: $PackageName" -ForegroundColor White
    Write-Host "4. Extract the ZIP file" -ForegroundColor White
    Write-Host "5. Move contents to /public_html/ root" -ForegroundColor White
    Write-Host "6. Delete the ZIP file" -ForegroundColor White
    Write-Host ""
    Write-Host "🌐 Your site will be live at: https://stupidiots.com" -ForegroundColor Green
}

if (-not $CreatePackage -and -not $Upload) {
    Write-Host "Usage:" -ForegroundColor Yellow
    Write-Host "  .\deploy_manual.ps1 -CreatePackage    # Create deployment package"
    Write-Host "  .\deploy_manual.ps1 -Upload          # Show upload instructions"
    Write-Host "  .\deploy_manual.ps1 -CreatePackage -Upload  # Both"
}
