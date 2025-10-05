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

# Server configuration (read from server_config.txt)
$ConfigPath = "C:\stupidiots_project\06_SCRIPTS\server_config.txt"
$ServerPath = "ftp://stupidiots.com/public_html/"
$Username = "u939125353.srv855356hstgrcloud"
$Password = "r!dZuXG3ohvr2F2D"
$UseExplicitTLS = $false
# Extended config
$Protocol = 'FTP'
$SftpHost = 'stupidiots.com'
$Port = 21
$RemoteBase = '/public_html/'
if (Test-Path $ConfigPath) {
    $config = Get-Content $ConfigPath | Where-Object { $_ -match '=' -and -not ($_.Trim().StartsWith('#')) }
    foreach ($line in $config) {
        $parts = $line -split '=', 2
        if ($parts.Length -eq 2) {
            $key = $parts[0].Trim()
            $val = $parts[1].Trim()
            switch -Regex ($key) {
                '^ServerPath$' { $ServerPath = $val }
                '^Username$'   { $Username = $val }
                '^Password$'   { $Password = $val }
                '^UseExplicitTLS$' { $UseExplicitTLS = ($val -eq 'true' -or $val -eq 'True') }
                '^Protocol$'   { $Protocol = $val }
                '^Host$'       { $SftpHost = $val }
                '^Port$'       { $Port = [int]$val }
                '^RemoteBase$' { $RemoteBase = $val }
            }
        }
    }
}

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

# Step 4: Upload to server (SFTP preferred)
if ($Protocol -eq 'SFTP') {
    Write-Host "Uploading to server via SFTP..." -ForegroundColor Yellow

    # Build sftp batch script
    $batchFile = "$env:TEMP\sftp_batch.txt"
    $RemoteBaseNormalized = $RemoteBase
    if (-not $RemoteBaseNormalized.EndsWith('/')) { $RemoteBaseNormalized += '/' }

    # Create batch with remote base and main file upload
    Set-Content -Path $batchFile -Value ("cd " + $RemoteBaseNormalized)
    $mainPut = "put ``"$LiveFile``" index.html"
    Add-Content -Path $batchFile -Value $mainPut

    $AirdropSource = "C:\stupidiots_project\02_DEVELOPMENT\review_later\airdrop\"
    if (Test-Path $AirdropSource) {
        Get-ChildItem $AirdropSource -File | ForEach-Object {
            Add-Content -Path $batchFile -Value "-mkdir airdrop"
            $line = "put ``"$($_.FullName)``" airdrop/$($_.Name)"
            Add-Content -Path $batchFile -Value $line
        }
    }

    $AssetsSource = "C:\stupidiots_project\02_DEVELOPMENT\review_later\assets\"
    if (Test-Path $AssetsSource) {
        Get-ChildItem $AssetsSource -Recurse -File | ForEach-Object {
            $relative = $_.FullName.Substring($AssetsSource.Length).Replace('\\','/')
            $remoteDir = Split-Path ("assets/" + $relative) -Parent
            if ($remoteDir -and $remoteDir -ne '.') {
                $parts = $remoteDir.Split('/')
                $path = ''
                foreach ($p in $parts) {
                    if ($p) { $path = ($path + $p + '/') ; Add-Content -Path $batchFile -Value ("-mkdir " + ($path.TrimEnd('/'))) }
                }
            }
            $putLine = "put ``"$($_.FullName)``" assets/$relative"
            Add-Content -Path $batchFile -Value $putLine
        }
    }

    # Run sftp with password auth (uses -o options)
    $scpCmd = "sftp -oBatchMode=no -o StrictHostKeyChecking=no -P $Port $Username@$SftpHost -b ``"$batchFile``""
    # Provide password via 'echo password | sftp' using plink-like approach is not native; recommend Pageant/keys.
    # For now, prompt-less may fail; fall back to interactive prompt where you paste password.
    Write-Host "Executing SFTP. You may be prompted for password for $Username@$SftpHost." -ForegroundColor Yellow
    & cmd /c $scpCmd
}
else {
    Write-Host "Uploading to server via FTP..." -ForegroundColor Yellow

function Invoke-CurlUpload($localPath, $remoteUrl, $user, $pass) {
    $escapedLocal = '"' + $localPath + '"'
    $escapedUrl = '"' + $remoteUrl + '"'
    $tlsFlag = ""
    if ($UseExplicitTLS) {
        $tlsFlag = "--ftp-ssl --ssl-reqd"
    }
    $cmd = "curl --ftp-create-dirs -T $escapedLocal $escapedUrl --user $user`:$pass --silent --show-error $tlsFlag"
    $result = & cmd /c $cmd
    if ($LASTEXITCODE -ne 0) { throw "curl failed: $result" }
}

try {
    if (-not $ServerPath -or -not $Username -or -not $Password) { throw "Missing FTP configuration in server_config.txt" }

    # Ensure ServerPath ends with slash
    if ($ServerPath[-1] -ne '/') { $ServerPath += '/' }

    # Upload main file
    Invoke-CurlUpload -localPath $LiveFile -remoteUrl ($ServerPath + 'index.html') -user $Username -pass $Password
    Write-Host "Uploaded index.html" -ForegroundColor Green

    # Upload airdrop files in root/airdrop/
    $AirdropSource = "C:\stupidiots_project\02_DEVELOPMENT\review_later\airdrop\"
    if (Test-Path $AirdropSource) {
        Get-ChildItem $AirdropSource -File | ForEach-Object {
            Invoke-CurlUpload -localPath $_.FullName -remoteUrl ($ServerPath + 'airdrop/' + $_.Name) -user $Username -pass $Password
            Write-Host ("Uploaded airdrop/" + $_.Name) -ForegroundColor Green
        }
    }

    # Upload assets recursively to root/assets/
    $AssetsSource = "C:\stupidiots_project\02_DEVELOPMENT\review_later\assets\"
    if (Test-Path $AssetsSource) {
        Get-ChildItem $AssetsSource -Recurse -File | ForEach-Object {
            $relative = $_.FullName.Substring($AssetsSource.Length).Replace('\','/')
            Invoke-CurlUpload -localPath $_.FullName -remoteUrl ($ServerPath + 'assets/' + $relative) -user $Username -pass $Password
            Write-Host ("Uploaded assets/" + $relative) -ForegroundColor Green
        }
    }

    Write-Host "Server upload complete!" -ForegroundColor Green
} catch {
    Write-Host ("Server upload failed: " + $_.Exception.Message) -ForegroundColor Red
}

}

Write-Host "" 
Write-Host "GITHUB + SERVER UPDATE COMPLETE!" -ForegroundColor Green
Write-Host "GitHub: Updated with commit" -ForegroundColor Cyan
Write-Host "Server: Live at https://stupidiots.com" -ForegroundColor Magenta
Write-Host "Backup saved at: $BackupDir" -ForegroundColor Cyan
