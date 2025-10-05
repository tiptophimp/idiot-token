@echo off
echo Updating stupidiots.com site...

REM Copy development file to live site
copy "C:\stupidiots_project\02_DEVELOPMENT\review_later\stupidiots_one_page_static_site_index.html" "C:\stupidiots_project\01_LIVE_SITE\main_site\index.html"

REM Copy airdrop files
xcopy "C:\stupidiots_project\02_DEVELOPMENT\review_later\airdrop\*" "C:\stupidiots_project\01_LIVE_SITE\main_site\airdrop\" /Y

REM Copy assets
xcopy "C:\stupidiots_project\02_DEVELOPMENT\review_later\assets\*" "C:\stupidiots_project\01_LIVE_SITE\main_site\assets\" /Y /E

echo Site updated successfully!
echo Ready for upload to server.
pause
