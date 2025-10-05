# FTP Upload Script for Hostinger
$ftpServer = "stupidiots.com"
$ftpUsername = "u939125353.srv855356hstgrcloud"
$ftpPassword = "r!dZuXG3ohvr2F2D"
$localFile = "stupidiots_deploy.zip"
$remoteFile = "/public_html/stupidiots_deploy.zip"

Write-Host "🌐 Connecting to Hostinger FTP..." -ForegroundColor Yellow

try {
    $ftp = [System.Net.FtpWebRequest]::Create("ftp://" + $ftpServer + $remoteFile)
    $ftp.Credentials = New-Object System.Net.NetworkCredential($ftpUsername, $ftpPassword)
    $ftp.Method = [System.Net.WebRequestMethods+Ftp]::UploadFile
    $ftp.UseBinary = $true
    
    $fileContent = [System.IO.File]::ReadAllBytes($localFile)
    $ftp.ContentLength = $fileContent.Length
    
    $requestStream = $ftp.GetRequestStream()
    $requestStream.Write($fileContent, 0, $fileContent.Length)
    $requestStream.Close()
    
    $response = $ftp.GetResponse()
    Write-Host "✅ Upload successful!" -ForegroundColor Green
    Write-Host "📦 File uploaded to: /public_html/stupidiots_deploy.zip" -ForegroundColor Cyan
    $response.Close()
} catch {
    Write-Host "❌ Upload failed:" $_.Exception.Message -ForegroundColor Red
    Write-Host "Try manual upload via Hostinger File Manager instead" -ForegroundColor Yellow
}
