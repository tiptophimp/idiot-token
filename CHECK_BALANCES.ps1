# IDIOT Token Balance Checker
# Network: Base Mainnet
# Token: 0xC29EF04CFFe38012dcfc1E96a2B368443f298dE1

$RPC = "https://mainnet.base.org"
$TOKEN = "0xC29EF04CFFe38012dcfc1E96a2B368443f298dE1"

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "🔍 CHECKING LIVE IDIOT TOKEN BALANCES" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# Function to check balance
function Get-TokenBalance {
    param(
        [string]$Address,
        [string]$Label
    )
    
    try {
        Write-Host "📍 $Label ($Address):" -ForegroundColor Yellow
        $result = cast call $TOKEN "balanceOf(address)(uint256)" $Address --rpc-url $RPC 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            $wei = $result.Trim()
            # Convert to decimal (divide by 10^18)
            $tokens = [decimal]$wei / 1000000000000000000
            $formatted = "{0:N0}" -f $tokens
            Write-Host "   Balance: $formatted IDIOT" -ForegroundColor Green
            return $tokens
        } else {
            Write-Host "   Error: $result" -ForegroundColor Red
            return 0
        }
    } catch {
        Write-Host "   Error: $_" -ForegroundColor Red
        return 0
    }
    Write-Host ""
}

# Check if cast is installed
try {
    $castVersion = cast --version 2>&1
    Write-Host "Foundry (cast) is installed: $castVersion" -ForegroundColor Green
    Write-Host ""
} catch {
    Write-Host "ERROR: Foundry (cast) is not installed!" -ForegroundColor Red
    Write-Host ""
    Write-Host "To install Foundry on Windows:" -ForegroundColor Yellow
    Write-Host "  1. Open PowerShell as Administrator" -ForegroundColor White
    Write-Host "  2. Run: curl -L https://foundry.paradigm.xyz | bash" -ForegroundColor White
    Write-Host "  3. Run: foundryup" -ForegroundColor White
    Write-Host ""
    exit 1
}

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "WALLETS" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan

$ledgerCold1 = Get-TokenBalance -Address "0xf123f1269Fcb1d0c6F1DCFc3EF1F68dEDDf52a5e" -Label "Ledger Cold 1"
$opsHot = Get-TokenBalance -Address "0x721d2adcCf634f4185edE152ee98cA836CF22EA6" -Label "OPS-HOT"
$lpHot = Get-TokenBalance -Address "0xAC95d0B5603C7212a690bd089BAD472473496374" -Label "LP-HOT"
$ledgerCold2 = Get-TokenBalance -Address "0xB4EB7C7040c887d576a2e0Cdf60901A3087f5389" -Label "Ledger Cold 2"

Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "MULTISIG CONTRACTS" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan

$multisig1 = Get-TokenBalance -Address "0x9D466E39799FeC7204f40133EcC0BeB115813c13" -Label "Multisig 1 (Community)"
$multisig2 = Get-TokenBalance -Address "0x5817DcCb35cd3A67520E5BDa1Ebc413cf097A8eE" -Label "Multisig 2 (Treasury)"
$multisig3 = Get-TokenBalance -Address "0x0B333e3bf4435D9DD622c5E037Cd50fB1ACBDb4b" -Label "Multisig 3 (Reserve)"
$multisig4 = Get-TokenBalance -Address "0x6AD03686ab6c3bA2c77992995E4879c62dE88996" -Label "Multisig 4 (Team)"

Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "SUMMARY" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan

$totalWallets = $ledgerCold1 + $opsHot + $lpHot + $ledgerCold2
$totalMultisigs = $multisig1 + $multisig2 + $multisig3 + $multisig4
$grandTotal = $totalWallets + $totalMultisigs

Write-Host "Total in Wallets:    " -NoNewline
Write-Host ("{0:N0}" -f $totalWallets) -ForegroundColor Green -NoNewline
Write-Host " IDIOT"

Write-Host "Total in Multisigs:  " -NoNewline
Write-Host ("{0:N0}" -f $totalMultisigs) -ForegroundColor Green -NoNewline
Write-Host " IDIOT"

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "GRAND TOTAL:         " -NoNewline
Write-Host ("{0:N0}" -f $grandTotal) -ForegroundColor Yellow -NoNewline
Write-Host " IDIOT"

Write-Host "Expected Supply:     " -NoNewline
Write-Host "1,000,000,000" -ForegroundColor Yellow -NoNewline
Write-Host " IDIOT"

$difference = 1000000000 - $grandTotal
if ([Math]::Abs($difference) -lt 1000) {
    Write-Host "Status:              BALANCED!" -ForegroundColor Green
} else {
    Write-Host "Difference:          " -NoNewline
    Write-Host ("{0:N0}" -f $difference) -ForegroundColor Red -NoNewline
    Write-Host " IDIOT"
    Write-Host "Status:              MISMATCH" -ForegroundColor Red
    Write-Host ""
    Write-Host "Note: LP position #3887185 holds ~374K IDIOT in the pool" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "NEXT STEPS" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Review IDIOT_Token_Movement_Plan.md for transfer instructions" -ForegroundColor White
Write-Host "Run TRANSFER_COMMANDS.sh (on Mac/Linux) for step-by-step transfers" -ForegroundColor White
Write-Host ""

# Export to CSV
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$csvPath = "IDIOT_Balances_$timestamp.csv"

$balances = @(
    [PSCustomObject]@{Type="Wallet"; Label="Ledger Cold 1"; Address="0xf123f1269Fcb1d0c6F1DCFc3EF1F68dEDDf52a5e"; Balance=$ledgerCold1}
    [PSCustomObject]@{Type="Wallet"; Label="OPS-HOT"; Address="0x721d2adcCf634f4185edE152ee98cA836CF22EA6"; Balance=$opsHot}
    [PSCustomObject]@{Type="Wallet"; Label="LP-HOT"; Address="0xAC95d0B5603C7212a690bd089BAD472473496374"; Balance=$lpHot}
    [PSCustomObject]@{Type="Wallet"; Label="Ledger Cold 2"; Address="0xB4EB7C7040c887d576a2e0Cdf60901A3087f5389"; Balance=$ledgerCold2}
    [PSCustomObject]@{Type="Multisig"; Label="Community Fund"; Address="0x9D466E39799FeC7204f40133EcC0BeB115813c13"; Balance=$multisig1}
    [PSCustomObject]@{Type="Multisig"; Label="Treasury"; Address="0x5817DcCb35cd3A67520E5BDa1Ebc413cf097A8eE"; Balance=$multisig2}
    [PSCustomObject]@{Type="Multisig"; Label="Reserve"; Address="0x0B333e3bf4435D9DD622c5E037Cd50fB1ACBDb4b"; Balance=$multisig3}
    [PSCustomObject]@{Type="Multisig"; Label="Team"; Address="0x6AD03686ab6c3bA2c77992995E4879c62dE88996"; Balance=$multisig4}
)

$balances | Export-Csv -Path $csvPath -NoTypeInformation
Write-Host "📄 Balance report saved to: $csvPath" -ForegroundColor Green
Write-Host ""

