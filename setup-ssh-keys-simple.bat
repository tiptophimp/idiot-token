@echo off
echo ========================================
echo  IDIOT Token - SSH Key Setup
echo ========================================
echo.

SET SERVER_IP=68.183.149.106
SET SERVER_USER=root
SET KEY_PATH=%USERPROFILE%\.ssh\idiot_deploy_key

echo [1/6] Creating .ssh directory...
if not exist "%USERPROFILE%\.ssh" mkdir "%USERPROFILE%\.ssh"
echo      Done!
echo.

echo [2/6] Generating SSH key...
echo      Press ENTER twice (for no passphrase)
echo.
ssh-keygen -t ed25519 -C "idiot-token-deployment" -f "%KEY_PATH%"
IF %ERRORLEVEL% NEQ 0 (
    echo      Failed to generate key.
    pause
    exit /b 1
)
echo.
echo      SSH key generated successfully!
echo.

echo [3/6] Your PUBLIC key:
echo ========================================
type "%KEY_PATH%.pub"
echo ========================================
echo.

echo [4/6] Now we need to copy this key to your server.
echo.
echo      OPTION A - Automatic (if you have sshpass):
echo      sshpass -p 'fNKmw2u6FW9N!ji' ssh-copy-id -i "%KEY_PATH%.pub" %SERVER_USER%@%SERVER_IP%
echo.
echo      OPTION B - Manual (recommended):
echo      1. SSH into server: ssh %SERVER_USER%@%SERVER_IP%
echo         Password: fNKmw2u6FW9N!ji
echo      2. Run: mkdir -p ~/.ssh
echo      3. Run: echo "PASTE_PUBLIC_KEY_HERE" ^>^> ~/.ssh/authorized_keys
echo      4. Run: chmod 600 ~/.ssh/authorized_keys
echo      5. Type: exit
echo.
pause
echo.

echo [5/6] Testing SSH connection...
ssh -i "%KEY_PATH%" -o StrictHostKeyChecking=no %SERVER_USER%@%SERVER_IP% "echo 'SSH key works!'"
IF %ERRORLEVEL% EQU 0 (
    echo.
    echo      SSH key authentication SUCCESSFUL!
    echo.
) ELSE (
    echo.
    echo      SSH key authentication FAILED!
    echo      Make sure you completed step 4 correctly.
    pause
    exit /b 1
)

echo [6/6] Preparing GitHub Secrets...
echo.
echo ========================================
echo  GitHub Secrets to Add
echo ========================================
echo.
echo Go to: https://github.com/tiptophimp/idiot-token/settings/secrets/actions
echo.
echo Add these 3 secrets:
echo.
echo 1. Name: IDIOT_SSH_PRIVATE_KEY
echo    Value: (Copy from file below)
echo.
echo 2. Name: SERVER_IP
echo    Value: %SERVER_IP%
echo.
echo 3. Name: SERVER_USER
echo    Value: %SERVER_USER%
echo.
echo ========================================
echo.

echo Saving private key to file...
type "%KEY_PATH%" > github-secret-private-key.txt
echo.
echo Private key saved to: github-secret-private-key.txt
echo You can copy the entire content of this file for GitHub Secret #1
echo.
echo ========================================
echo  Setup Complete!
echo ========================================
echo.
echo Next steps:
echo 1. Open: github-secret-private-key.txt
echo 2. Copy ENTIRE content (including BEGIN/END lines)
echo 3. Add to GitHub as secret: IDIOT_SSH_PRIVATE_KEY
echo 4. Add SERVER_IP: %SERVER_IP%
echo 5. Add SERVER_USER: %SERVER_USER%
echo 6. Push any change to trigger auto-deployment!
echo.
pause

