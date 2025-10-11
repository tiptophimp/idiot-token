# IDIOT Token - Check All Holders
# This script queries BaseScan to get current holder information

$TOKEN = "0xC29EF04CFFe38012dcfc1E96a2B368443f298dE1"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "IDIOT TOKEN - HOLDER ANALYSIS" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Token Contract: $TOKEN" -ForegroundColor Yellow
Write-Host ""

Write-Host "🔍 To view all holders, visit:" -ForegroundColor Green
Write-Host "https://basescan.org/token/$TOKEN#balances" -ForegroundColor White
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "KNOWN PROJECT WALLETS" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$wallets = @(
    @{Name="Community Multisig"; Address="0x9D466E39799FeC7204f40133EcC0BeB115813c13"; Expected="400M"},
    @{Name="Reserve Multisig"; Address="0x0B333e3bf4435D9DD622c5E037Cd50fB1ACBDb4b"; Expected="248M"},
    @{Name="LP-HOT Wallet"; Address="0xAC95d0B5603C7212a690bd089BAD472473496374"; Expected="150M"},
    @{Name="Team Multisig"; Address="0x6AD03686ab6c3bA2c77992995E4879c62dE88996"; Expected="100M"},
    @{Name="Treasury Multisig"; Address="0x5817DcCb35cd3A67520E5BDa1Ebc413cf097A8eE"; Expected="50.6M"},
    @{Name="OPS-HOT Wallet"; Address="0x721d2adcCf634f4185edE152ee98cA836CF22EA6"; Expected="50M"},
    @{Name="Uniswap V3 Pool"; Address="0x763c9aB550dC0DAbd32F40131481Bf4BA4d8c1ea"; Expected="1.56M"},
    @{Name="Ledger Cold 1"; Address="0xf123f1269Fcb1d0c6F1DCFc3EF1F68dEDDf52a5e"; Expected="~0"},
    @{Name="Ledger Cold 2"; Address="0xB4EB7C7040c887d576a2e0Cdf60901A3087f5389"; Expected="0 (has LP NFT)"}
)

foreach ($wallet in $wallets) {
    Write-Host "$($wallet.Name)" -ForegroundColor Yellow
    Write-Host "  Address: $($wallet.Address)" -ForegroundColor Gray
    Write-Host "  Expected: $($wallet.Expected)" -ForegroundColor Gray
    Write-Host "  Check: https://basescan.org/token/$TOKEN`?a=$($wallet.Address)" -ForegroundColor Cyan
    Write-Host ""
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "TOTAL SUPPLY VERIFICATION" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Total Supply: 1,000,000,000 IDIOT" -ForegroundColor White
Write-Host ""
Write-Host "To verify:" -ForegroundColor Yellow
Write-Host "1. Visit: https://basescan.org/token/$TOKEN" -ForegroundColor White
Write-Host "2. Look for 'Max Total Supply'" -ForegroundColor White
Write-Host "3. Click 'Holders' tab to see distribution" -ForegroundColor White
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "EXTERNAL HOLDER CHECK" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "To find if there are ANY external holders:" -ForegroundColor Yellow
Write-Host "1. Go to Holders tab on BaseScan" -ForegroundColor White
Write-Host "2. Look for addresses NOT in the list above" -ForegroundColor White
Write-Host "3. Those would be community members or buyers" -ForegroundColor White
Write-Host ""

