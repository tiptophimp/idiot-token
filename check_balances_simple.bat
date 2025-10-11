@echo off
echo =====================================
echo CHECKING LIVE IDIOT TOKEN BALANCES
echo =====================================
echo.

set RPC=https://mainnet.base.org
set TOKEN=0xC29EF04CFFe38012dcfc1E96a2B368443f298dE1

echo WALLETS:
echo ========================================
echo.

echo Ledger Cold 1 (0xf123...2a5e):
cast call %TOKEN% "balanceOf(address)(uint256)" 0xf123f1269Fcb1d0c6F1DCFc3EF1F68dEDDf52a5e --rpc-url %RPC% 2>nul
echo.

echo OPS-HOT (0x721d...2EA6):
cast call %TOKEN% "balanceOf(address)(uint256)" 0x721d2adcCf634f4185edE152ee98cA836CF22EA6 --rpc-url %RPC% 2>nul
echo.

echo LP-HOT (0xAC95...6374):
cast call %TOKEN% "balanceOf(address)(uint256)" 0xAC95d0B5603C7212a690bd089BAD472473496374 --rpc-url %RPC% 2>nul
echo.

echo Ledger Cold 2 (0xB4EB...5389):
cast call %TOKEN% "balanceOf(address)(uint256)" 0xB4EB7C7040c887d576a2e0Cdf60901A3087f5389 --rpc-url %RPC% 2>nul
echo.

echo.
echo MULTISIG CONTRACTS:
echo ========================================
echo.

echo Multisig 1 - Community (0x9D46...3c13):
cast call %TOKEN% "balanceOf(address)(uint256)" 0x9D466E39799FeC7204f40133EcC0BeB115813c13 --rpc-url %RPC% 2>nul
echo.

echo Multisig 2 - Treasury (0x5817...A8eE):
cast call %TOKEN% "balanceOf(address)(uint256)" 0x5817DcCb35cd3A67520E5BDa1Ebc413cf097A8eE --rpc-url %RPC% 2>nul
echo.

echo Multisig 3 - Reserve (0x0B33...Db4b):
cast call %TOKEN% "balanceOf(address)(uint256)" 0x0B333e3bf4435D9DD622c5E037Cd50fB1ACBDb4b --rpc-url %RPC% 2>nul
echo.

echo Multisig 4 - Team (0x6AD0...8996):
cast call %TOKEN% "balanceOf(address)(uint256)" 0x6AD03686ab6c3bA2c77992995E4879c62dE88996 --rpc-url %RPC% 2>nul
echo.

echo.
echo =====================================
echo.
echo Review IDIOT_Token_Movement_Plan.md for next steps
echo.
pause

