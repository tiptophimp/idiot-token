@echo off
echo ========================================
echo    Push to GitHub
echo ========================================
echo.
echo This script will push your local repository to GitHub.
echo Make sure you've created the GitHub repository first!
echo.
set /p REPO_URL="Enter your GitHub repository URL (e.g., https://github.com/username/stupidiots.git): "

if "%REPO_URL%"=="" (
    echo Error: No repository URL provided!
    pause
    exit /b 1
)

echo.
echo Connecting to GitHub repository...
git remote add origin %REPO_URL%
git branch -M main
git push -u origin main

echo.
echo ========================================
echo    GitHub Setup Complete!
echo ========================================
echo.
echo Your repository is now connected to GitHub.
echo You can now use: github_update.ps1 -Approve
echo.
pause
