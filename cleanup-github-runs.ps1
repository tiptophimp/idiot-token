# Delete all failed GitHub Actions runs
Write-Host "Cleaning up failed GitHub Actions runs..." -ForegroundColor Cyan
Write-Host ""

# Check if GitHub CLI is installed
$ghInstalled = Get-Command gh -ErrorAction SilentlyContinue

if (-not $ghInstalled) {
    Write-Host "GitHub CLI (gh) is not installed." -ForegroundColor Red
    Write-Host ""
    Write-Host "To delete failed runs, install GitHub CLI:" -ForegroundColor Yellow
    Write-Host "Visit: https://cli.github.com/" -ForegroundColor Cyan
    Write-Host ""
    pause
    exit
}

Write-Host "GitHub CLI found!" -ForegroundColor Green
Write-Host ""

# Authenticate if needed
Write-Host "Checking GitHub authentication..." -ForegroundColor Yellow
gh auth status 2>&1 | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Host "Please authenticate with GitHub..." -ForegroundColor Yellow
    gh auth login
}

Write-Host "Authenticated!" -ForegroundColor Green
Write-Host ""

# Get all workflow runs
Write-Host "Fetching all workflow runs..." -ForegroundColor Yellow
$runs = gh run list --repo tiptophimp/idiot-token --status failure --limit 500 --json databaseId,conclusion | ConvertFrom-Json

if ($runs.Count -eq 0) {
    Write-Host "No failed runs found! All clean!" -ForegroundColor Green
    pause
    exit
}

Write-Host "Found $($runs.Count) failed runs" -ForegroundColor Cyan
Write-Host ""

$confirm = Read-Host "Delete all $($runs.Count) failed runs? (y/n)"

if ($confirm -ne "y") {
    Write-Host "Cancelled" -ForegroundColor Red
    exit
}

Write-Host ""
Write-Host "Deleting failed runs..." -ForegroundColor Yellow

$deleted = 0
foreach ($run in $runs) {
    try {
        gh run delete $run.databaseId --repo tiptophimp/idiot-token --yes 2>&1 | Out-Null
        $deleted++
        Write-Progress -Activity "Deleting failed runs" -Status "$deleted of $($runs.Count)" -PercentComplete (($deleted / $runs.Count) * 100)
    } catch {
        Write-Host "Could not delete run $($run.databaseId)" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "CLEANUP COMPLETE!" -ForegroundColor Green
Write-Host "Deleted: $deleted failed runs" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
pause
