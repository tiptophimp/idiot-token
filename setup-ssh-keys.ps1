# IDIOT Token - SSH Key Setup Script
Write-Host "========================================" -ForegroundColor Cyan
Write-Host " IDIOT Token - SSH Key Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$SERVER_IP = "68.183.149.106"
$SERVER_USER = "root"
$SERVER_PASS = "fNKmw2u6FW9N!ji"
$KEY_PATH = "$HOME\.ssh\idiot_deploy_key"

# Step 1: Create .ssh directory if it doesn't exist
Write-Host "[1/5] Creating .ssh directory..." -ForegroundColor Yellow
if (-not (Test-Path "$HOME\.ssh")) {
    New-Item -ItemType Directory -Path "$HOME\.ssh" -Force | Out-Null
}
Write-Host "      ✓ Directory ready" -ForegroundColor Green
Write-Host ""

# Step 2: Generate SSH key (without passphrase)
Write-Host "[2/5] Generating SSH key pair..." -ForegroundColor Yellow
if (Test-Path $KEY_PATH) {
    Write-Host "      SSH key already exists at: $KEY_PATH" -ForegroundColor Yellow
    $overwrite = Read-Host "      Overwrite existing key? (y/n)"
    if ($overwrite -ne "y") {
        Write-Host "      Using existing key." -ForegroundColor Green
    } else {
        Remove-Item $KEY_PATH -Force
        Remove-Item "$KEY_PATH.pub" -Force -ErrorAction SilentlyContinue
        & ssh-keygen -t ed25519 -C "idiot-token-deployment" -f $KEY_PATH -N '""'
        Write-Host "      ✓ New key generated" -ForegroundColor Green
    }
} else {
    # Use empty passphrase by piping empty strings
    $process = Start-Process -FilePath "ssh-keygen" -ArgumentList "-t ed25519 -C idiot-token-deployment -f $KEY_PATH -N `"`"" -Wait -PassThru -NoNewWindow
    if ($process.ExitCode -eq 0) {
        Write-Host "      ✓ SSH key generated successfully" -ForegroundColor Green
    } else {
        Write-Host "      ✗ Failed to generate SSH key" -ForegroundColor Red
        exit 1
    }
}
Write-Host ""

# Step 3: Read public key
Write-Host "[3/5] Reading public key..." -ForegroundColor Yellow
$publicKey = Get-Content "$KEY_PATH.pub" -Raw
Write-Host "      ✓ Public key: $($publicKey.Substring(0, 50))..." -ForegroundColor Green
Write-Host ""

# Step 4: Copy public key to server
Write-Host "[4/5] Installing public key on server..." -ForegroundColor Yellow
Write-Host "      Server: $SERVER_USER@$SERVER_IP" -ForegroundColor Cyan
Write-Host "      Password: $SERVER_PASS" -ForegroundColor Cyan
Write-Host ""
Write-Host "      INSTRUCTIONS:" -ForegroundColor Yellow
Write-Host "      1. Copy this public key:" -ForegroundColor White
Write-Host ""
Write-Host $publicKey -ForegroundColor Green
Write-Host ""
Write-Host "      2. SSH into your server (password will be needed):" -ForegroundColor White
Write-Host "         ssh $SERVER_USER@$SERVER_IP" -ForegroundColor Cyan
Write-Host ""
Write-Host "      3. Run these commands on the server:" -ForegroundColor White
Write-Host "         mkdir -p ~/.ssh" -ForegroundColor Cyan
Write-Host "         echo `"$publicKey`" >> ~/.ssh/authorized_keys" -ForegroundColor Cyan
Write-Host "         chmod 700 ~/.ssh" -ForegroundColor Cyan
Write-Host "         chmod 600 ~/.ssh/authorized_keys" -ForegroundColor Cyan
Write-Host "         exit" -ForegroundColor Cyan
Write-Host ""

$continue = Read-Host "      Have you completed the above steps? (y/n)"
if ($continue -ne "y") {
    Write-Host "      Please complete the steps and run this script again." -ForegroundColor Yellow
    exit 0
}
Write-Host ""

# Step 5: Test SSH connection
Write-Host "[5/5] Testing SSH connection..." -ForegroundColor Yellow
$testResult = & ssh -i $KEY_PATH -o StrictHostKeyChecking=no -o UserKnownHostsFile=NUL $SERVER_USER@$SERVER_IP "echo 'SSH key authentication successful!'" 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "      ✓ SSH key authentication works!" -ForegroundColor Green
} else {
    Write-Host "      ✗ SSH key authentication failed" -ForegroundColor Red
    Write-Host "      Error: $testResult" -ForegroundColor Red
    exit 1
}
Write-Host ""

# Step 6: Display GitHub Secrets
Write-Host "========================================" -ForegroundColor Cyan
Write-Host " GitHub Secrets Configuration" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Go to: https://github.com/tiptophimp/idiot-token/settings/secrets/actions" -ForegroundColor Cyan
Write-Host ""
Write-Host "Add these 3 secrets:" -ForegroundColor Yellow
Write-Host ""

Write-Host "1. SECRET NAME: IDIOT_SSH_PRIVATE_KEY" -ForegroundColor Yellow
Write-Host "   VALUE:" -ForegroundColor White
Write-Host "   ----------------------------------------" -ForegroundColor Gray
$privateKey = Get-Content $KEY_PATH -Raw
Write-Host $privateKey -ForegroundColor Green
Write-Host "   ----------------------------------------" -ForegroundColor Gray
Write-Host ""

Write-Host "2. SECRET NAME: SERVER_IP" -ForegroundColor Yellow
Write-Host "   VALUE: $SERVER_IP" -ForegroundColor Green
Write-Host ""

Write-Host "3. SECRET NAME: SERVER_USER" -ForegroundColor Yellow
Write-Host "   VALUE: $SERVER_USER" -ForegroundColor Green
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host " Setup Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Add the 3 secrets to GitHub (see above)" -ForegroundColor White
Write-Host "2. Push any change to trigger auto-deployment" -ForegroundColor White
Write-Host "3. Check Actions tab to see deployment progress" -ForegroundColor White
Write-Host ""

# Save private key location to file for later use
$privateKey | Out-File -FilePath "github-secret-private-key.txt" -Encoding UTF8
Write-Host "📝 Private key saved to: github-secret-private-key.txt" -ForegroundColor Cyan
Write-Host "   You can copy from this file when adding to GitHub Secrets" -ForegroundColor Gray
Write-Host ""

pause

