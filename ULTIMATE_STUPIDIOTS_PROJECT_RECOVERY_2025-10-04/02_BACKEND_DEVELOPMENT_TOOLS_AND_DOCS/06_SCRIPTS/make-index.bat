@echo off
setlocal enabledelayedexpansion

set SRC=stupidiots_one_page_static_site_index.html
set DST=index.html

if not exist "%SRC%" (
  echo Source file not found: %SRC%
  exit /b 1
)

copy /Y "%SRC%" "%DST%" >nul
echo Wrote %DST% from %SRC%

endlocal

