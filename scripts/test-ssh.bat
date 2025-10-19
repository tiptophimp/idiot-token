@echo off
cd /d "%~dp0"
powershell -ExecutionPolicy Bypass -File scripts/test-ssh.ps1
pause

