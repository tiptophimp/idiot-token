# IDIOT Token Balance Checker (Web-based, no cast required)
# Network: Base Mainnet
# Token: 0xC29EF04CFFe38012dcfc1E96a2B368443f298dE1

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "CHECKING LIVE IDIOT TOKEN BALANCES" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

$TOKEN = "0xC29EF04CFFe38012dcfc1E96a2B368443f298dE1"
$API_BASE = "https://api.basescan.org/api"

function Get-TokenBalance {
    param(
        [string]$Address,
        [string]$Label
    )
    
    Write-Host "$Label" -ForegroundColor Yellow
    Write-Host "  Address: $Address" -ForegroundColor Gray
    Write-Host "  BaseScan: https://basescan.org/address/$Address" -ForegroundColor Gray
    Write-Host ""
}

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "WALLETS" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

Get-TokenBalance -Address "0xf123f1269Fcb1d0c6F1DCFc3EF1F68dEDDf52a5e" -Label "Ledger Cold 1"
Get-TokenBalance -Address "0x721d2adcCf634f4185edE152ee98cA836CF22EA6" -Label "OPS-HOT"
Get-TokenBalance -Address "0xAC95d0B5603C7212a690bd089BAD472473496374" -Label "LP-HOT"
Get-TokenBalance -Address "0xB4EB7C7040c887d576a2e0Cdf60901A3087f5389" -Label "Ledger Cold 2"

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "MULTISIG CONTRACTS" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

Get-TokenBalance -Address "0x9D466E39799FeC7204f40133EcC0BeB115813c13" -Label "Multisig 1 (Community)"
Get-TokenBalance -Address "0x5817DcCb35cd3A67520E5BDa1Ebc413cf097A8eE" -Label "Multisig 2 (Treasury)"
Get-TokenBalance -Address "0x0B333e3bf4435D9DD622c5E037Cd50fB1ACBDb4b" -Label "Multisig 3 (Reserve)"
Get-TokenBalance -Address "0x6AD03686ab6c3bA2c77992995E4879c62dE88996" -Label "Multisig 4 (Team)"

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "NEXT STEPS" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Visit the BaseScan links above to see current balances" -ForegroundColor White
Write-Host "2. Review IDIOT_Token_Movement_Plan.md for transfer instructions" -ForegroundColor White
Write-Host "3. Use your Ledger hardware wallet for all transfers" -ForegroundColor White
Write-Host ""
Write-Host "TOKEN CONTRACT:" -ForegroundColor Yellow
Write-Host "  $TOKEN" -ForegroundColor Green
Write-Host "  https://basescan.org/token/$TOKEN" -ForegroundColor Gray
Write-Host ""

