@echo off
cd /d "%~dp0"
powershell -ExecutionPolicy Bypass -File scripts/check-production.ps1
pause

