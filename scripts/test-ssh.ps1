# SSH Connection Test Script
# Tests connection to stupidiots.com server

$SERVER = "68.183.149.106"
$USER = "deploy"
$KEY_PATH = "C:\idiot-project\deploy\ssh-keys\deploy_key"
$ALT_KEY_PATH = "$env:USERPROFILE\.ssh\deploy_key"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  SSH Connection Test" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Check if SSH command exists
Write-Host "[1/5] Checking SSH availability..." -ForegroundColor Yellow
try {
    $sshVersion = ssh -V 2>&1
    Write-Host "[OK] SSH is installed: $sshVersion" -ForegroundColor Green
} catch {
    Write-Host "[ERROR] SSH command not found!" -ForegroundColor Red
    Write-Host "Install OpenSSH from Windows Settings > Apps > Optional Features" -ForegroundColor Yellow
    exit 1
}

Write-Host ""

# Step 2: Check for SSH key
Write-Host "[2/5] Checking for SSH key..." -ForegroundColor Yellow
$keyFound = $false
$useKey = ""

if (Test-Path $KEY_PATH) {
    Write-Host "[OK] Found key: $KEY_PATH" -ForegroundColor Green
    $keyFound = $true
    $useKey = $KEY_PATH
} elseif (Test-Path $ALT_KEY_PATH) {
    Write-Host "[OK] Found key: $ALT_KEY_PATH" -ForegroundColor Green
    $keyFound = $true
    $useKey = $ALT_KEY_PATH
} else {
    Write-Host "[WARN] No SSH key found at:" -ForegroundColor Yellow
    Write-Host "  - $KEY_PATH" -ForegroundColor Gray
    Write-Host "  - $ALT_KEY_PATH" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Will try connection without key (password or default key)" -ForegroundColor Yellow
}

Write-Host ""

# Step 3: Test network connectivity
Write-Host "[3/5] Testing network connectivity..." -ForegroundColor Yellow
try {
    $testConnection = Test-NetConnection -ComputerName $SERVER -Port 22 -WarningAction SilentlyContinue
    if ($testConnection.TcpTestSucceeded) {
        Write-Host "[OK] Server is reachable on port 22" -ForegroundColor Green
    } else {
        Write-Host "[ERROR] Cannot reach server on port 22" -ForegroundColor Red
        Write-Host "Server may be down or firewall is blocking" -ForegroundColor Yellow
        exit 1
    }
} catch {
    Write-Host "[WARN] Could not test connection (Test-NetConnection failed)" -ForegroundColor Yellow
}

Write-Host ""

# Step 4: Test SSH authentication
Write-Host "[4/5] Testing SSH authentication..." -ForegroundColor Yellow

$sshCommand = if ($keyFound) {
    "ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -i `"$useKey`" $USER@$SERVER `"echo 'SSH_TEST_SUCCESS'`""
} else {
    "ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 $USER@$SERVER `"echo 'SSH_TEST_SUCCESS'`""
}

try {
    $result = Invoke-Expression $sshCommand 2>&1
    if ($result -match "SSH_TEST_SUCCESS") {
        Write-Host "[OK] SSH authentication successful!" -ForegroundColor Green
        $sshWorks = $true
    } else {
        Write-Host "[ERROR] SSH authentication failed" -ForegroundColor Red
        Write-Host "Output: $result" -ForegroundColor Gray
        Write-Host ""
        Write-Host "Possible issues:" -ForegroundColor Yellow
        Write-Host "  - Public key not on server" -ForegroundColor Yellow
        Write-Host "  - Wrong key file" -ForegroundColor Yellow
        Write-Host "  - Need password (not configured)" -ForegroundColor Yellow
        $sshWorks = $false
    }
} catch {
    Write-Host "[ERROR] SSH connection failed" -ForegroundColor Red
    Write-Host "Error: $_" -ForegroundColor Gray
    $sshWorks = $false
}

Write-Host ""

if (-not $sshWorks) {
    Write-Host "========================================" -ForegroundColor Red
    Write-Host "  SSH Test Failed" -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Yellow
    Write-Host "1. Read docs/SSH_SETUP_GUIDE.md" -ForegroundColor White
    Write-Host "2. Generate SSH key if you don't have one" -ForegroundColor White
    Write-Host "3. Add public key to server" -ForegroundColor White
    Write-Host "4. Run this test again" -ForegroundColor White
    Write-Host ""
    exit 1
}

# Step 5: Get server information
Write-Host "[5/5] Getting server information..." -ForegroundColor Yellow

$sshInfoCommand = if ($keyFound) {
    "ssh -o StrictHostKeyChecking=no -i `"$useKey`" $USER@$SERVER"
} else {
    "ssh -o StrictHostKeyChecking=no $USER@$SERVER"
}

Write-Host ""
Write-Host "Server Details:" -ForegroundColor Cyan
Write-Host "----------------------------------------" -ForegroundColor Gray

# OS Version
Write-Host -NoNewline "OS: "
$osInfo = Invoke-Expression "$sshInfoCommand `"cat /etc/os-release | grep PRETTY_NAME`"" 2>&1
Write-Host ($osInfo -replace 'PRETTY_NAME=', '' -replace '"', '')

# Disk space
Write-Host -NoNewline "Disk Space: "
$diskInfo = Invoke-Expression "$sshInfoCommand `"df -h / | tail -1 | awk '{print `$4}' `"" 2>&1
Write-Host "$diskInfo free"

# Production directory
Write-Host -NoNewline "Production Dir: "
$prodCheck = Invoke-Expression "$sshInfoCommand `"[ -d /var/www/stupidiots.com/public_html ] && echo 'EXISTS' || echo 'NOT FOUND'`"" 2>&1
if ($prodCheck -match "EXISTS") {
    Write-Host "EXISTS" -ForegroundColor Green
    $fileCount = Invoke-Expression "$sshInfoCommand `"find /var/www/stupidiots.com/public_html -type f | wc -l`"" 2>&1
    Write-Host "              $fileCount files in production" -ForegroundColor Gray
} else {
    Write-Host "NOT FOUND" -ForegroundColor Red
}

# Nginx status
Write-Host -NoNewline "Nginx Status: "
$nginxStatus = Invoke-Expression "$sshInfoCommand `"sudo systemctl is-active nginx`"" 2>&1
if ($nginxStatus -match "active") {
    Write-Host "RUNNING" -ForegroundColor Green
} else {
    Write-Host "NOT RUNNING" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  SSH Test Successful!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "You can now:" -ForegroundColor Cyan
Write-Host "  - Deploy to staging" -ForegroundColor White
Write-Host "  - Check production files" -ForegroundColor White
Write-Host "  - Run deployment scripts" -ForegroundColor White
Write-Host ""
Write-Host "Key being used:" -ForegroundColor Gray
if ($keyFound) {
    Write-Host "  $useKey" -ForegroundColor White
} else {
    Write-Host "  Default key or password" -ForegroundColor White
}
Write-Host ""

