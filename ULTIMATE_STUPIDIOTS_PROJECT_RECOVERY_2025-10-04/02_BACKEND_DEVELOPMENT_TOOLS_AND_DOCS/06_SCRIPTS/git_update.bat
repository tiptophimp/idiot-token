@echo off
echo Git-based site update...

REM Navigate to project directory
cd /d "C:\stupidiots_project"

REM Add all changes
git add .

REM Commit with timestamp
git commit -m "Site update - %date% %time%"

REM Push to repository
git push

echo Git update complete!
pause
