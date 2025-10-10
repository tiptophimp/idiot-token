@echo off
echo ========================================
echo  IDIOT Token - Simple Deployment
echo ========================================
echo.

REM Configuration
set SERVER_IP=68.183.149.106
set SERVER_USER=root
set SSH_KEY=secure\idiot-token-automation.2025-10-09.private-key.pem

echo [1/3] Testing SSH connection...
ssh -i "%SSH_KEY%" %SERVER_USER%@%SERVER_IP% "echo 'Connection successful!'"
if errorlevel 1 (
    echo ERROR: SSH connection failed!
    pause
    exit /b 1
)

echo.
echo [2/3] Creating missing directories...
ssh -i "%SSH_KEY%" %SERVER_USER%@%SERVER_IP% "mkdir -p /var/www/html/assets/docs/"

echo.
echo [3/3] Copying whitepaper...
ssh -i "%SSH_KEY%" %SERVER_USER%@%SERVER_IP% "cp /var/www/html/docs/IDIOT_Whitepaper.pdf /var/www/html/assets/docs/IDIOT_Whitepaper_v11.pdf"

echo.
echo [4/4] Setting permissions...
ssh -i "%SSH_KEY%" %SERVER_USER%@%SERVER_IP% "chmod 644 /var/www/html/assets/docs/* && chmod 755 /var/www/html/assets/docs/"

echo.
echo ========================================
echo  Deployment Complete!
echo ========================================
echo  Website: https://stupidiots.com
echo ========================================
pause
