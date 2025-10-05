@echo off
echo Setting up GitHub for Stupidiots Project...

REM Navigate to project directory
cd /d "C:\stupidiots_project"

REM Initialize git repository
git init

REM Add all files
git add .

REM Initial commit
git commit -m "Initial commit - Stupidiots project setup"

echo.
echo GitHub setup complete!
echo.
echo Next steps:
echo 1. Create a repository on GitHub.com
echo 2. Add remote: git remote add origin https://github.com/yourusername/stupidiots.git
echo 3. Push: git push -u origin main
echo.
echo Then you can use: github_update.ps1 -Approve
pause
