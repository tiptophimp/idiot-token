#!/bin/bash
# IDIOT Token Transfer Commands
# Network: Base Mainnet
# Token: 0xC29EF04CFFe38012dcfc1E96a2B368443f298dE1

# Set RPC endpoint
export RPC="https://mainnet.base.org"
export TOKEN="0xC29EF04CFFe38012dcfc1E96a2B368443f298dE1"

echo "🔍 STEP 1: VERIFY CURRENT BALANCES"
echo "=================================="

# Ledger Cold 1
echo "📍 Ledger Cold 1 (0xf123...2a5e):"
cast call $TOKEN "balanceOf(address)(uint256)" 0xf123f1269Fcb1d0c6F1DCFc3EF1F68dEDDf52a5e --rpc-url $RPC | cast --to-unit ether

# OPS-HOT
echo "📍 OPS-HOT (0x721d...2EA6):"
cast call $TOKEN "balanceOf(address)(uint256)" 0x721d2adcCf634f4185edE152ee98cA836CF22EA6 --rpc-url $RPC | cast --to-unit ether

# LP-HOT
echo "📍 LP-HOT (0xAC95...6374):"
cast call $TOKEN "balanceOf(address)(uint256)" 0xAC95d0B5603C7212a690bd089BAD472473496374 --rpc-url $RPC | cast --to-unit ether

# Multisig 1 (Community)
echo "📍 Multisig 1 - Community (0x9D46...3c13):"
cast call $TOKEN "balanceOf(address)(uint256)" 0x9D466E39799FeC7204f40133EcC0BeB115813c13 --rpc-url $RPC | cast --to-unit ether

# Multisig 2 (Treasury)
echo "📍 Multisig 2 - Treasury (0x5817...A8eE):"
cast call $TOKEN "balanceOf(address)(uint256)" 0x5817DcCb35cd3A67520E5BDa1Ebc413cf097A8eE --rpc-url $RPC | cast --to-unit ether

# Multisig 3 (Reserve - Empty)
echo "📍 Multisig 3 - Reserve (0x0B33...Db4b):"
cast call $TOKEN "balanceOf(address)(uint256)" 0x0B333e3bf4435D9DD622c5E037Cd50fB1ACBDb4b --rpc-url $RPC | cast --to-unit ether

# Multisig 4 (Team)
echo "📍 Multisig 4 - Team (0x6AD0...8996):"
cast call $TOKEN "balanceOf(address)(uint256)" 0x6AD03686ab6c3bA2c77992995E4879c62dE88996 --rpc-url $RPC | cast --to-unit ether

echo ""
echo "🚀 STEP 2: TEST TRANSFER (RECOMMENDED)"
echo "=================================="
echo "Send 1000 IDIOT from Ledger Cold 1 to Reserve Multisig (test):"
echo ""
echo "cast send $TOKEN \\"
echo "  'transfer(address,uint256)' \\"
echo "  0x0B333e3bf4435D9DD622c5E037Cd50fB1ACBDb4b \\"
echo "  1000000000000000000000 \\"
echo "  --rpc-url $RPC \\"
echo "  --ledger"
echo ""
echo "⚠️  APPROVE ON YOUR LEDGER DEVICE!"
echo ""

echo ""
echo "💰 STEP 3: MAIN TRANSFER #1"
echo "=================================="
echo "Move ~248M IDIOT from Ledger Cold 1 → Reserve Multisig"
echo ""
echo "# WARNING: This is a LARGE transfer! Verify address carefully!"
echo "# From: 0xf123f1269Fcb1d0c6F1DCFc3EF1F68dEDDf52a5e"
echo "# To:   0x0B333e3bf4435D9DD622c5E037Cd50fB1ACBDb4b"
echo ""
echo "cast send $TOKEN \\"
echo "  'transfer(address,uint256)' \\"
echo "  0x0B333e3bf4435D9DD622c5E037Cd50fB1ACBDb4b \\"
echo "  248396494000000000000000000 \\"
echo "  --rpc-url $RPC \\"
echo "  --ledger"
echo ""

echo ""
echo "💰 STEP 4: MAIN TRANSFER #2"
echo "=================================="
echo "Move 200M IDIOT from OPS-HOT → Community Multisig"
echo ""
echo "# WARNING: This is a LARGE transfer! Verify address carefully!"
echo "# From: 0x721d2adcCf634f4185edE152ee98cA836CF22EA6"
echo "# To:   0x9D466E39799FeC7204f40133EcC0BeB115813c13"
echo ""
echo "# ⚠️  YOU NEED THE PRIVATE KEY FOR OPS-HOT WALLET!"
echo "# Option 1: Use Ledger/hardware wallet"
echo "# Option 2: Use MetaMask/web wallet"
echo "# Option 3: Use private key (LEAST SECURE)"
echo ""
echo "cast send $TOKEN \\"
echo "  'transfer(address,uint256)' \\"
echo "  0x9D466E39799FeC7204f40133EcC0BeB115813c13 \\"
echo "  200000000000000000000000000 \\"
echo "  --rpc-url $RPC \\"
echo "  --interactive"
echo ""

echo ""
echo "✅ STEP 5: VERIFY FINAL BALANCES"
echo "=================================="
echo "# Re-run Step 1 to verify all transfers completed successfully"
echo ""
echo "Expected final state:"
echo "  Reserve Multisig:    ~448,396,494 IDIOT (44.8%)"
echo "  Community Multisig:   200,000,000 IDIOT (20.0%)"
echo "  Team Multisig:        100,000,000 IDIOT (10.0%)"
echo "  Treasury Multisig:     50,643,000 IDIOT (5.1%)"
echo "  LP-HOT:               150,000,000 IDIOT (15.0%)"
echo "  OPS-HOT:               49,970,000 IDIOT (5.0%)"
echo "  LP Position:              ~374,323 IDIOT (0.04%)"
echo ""
echo "  TOTAL:            ~1,000,000,000 IDIOT ✅"
echo ""

echo ""
echo "📝 STEP 6: SAVE TRANSACTION HASHES"
echo "=================================="
echo "After each transfer, save the transaction hash:"
echo "  1. Test transfer: https://basescan.org/tx/[HASH]"
echo "  2. Ledger → Reserve: https://basescan.org/tx/[HASH]"
echo "  3. OPS-HOT → Community: https://basescan.org/tx/[HASH]"
echo ""

echo ""
echo "🎯 READY TO START?"
echo "=================================="
echo "1. ✅ Ensure Ledger is connected and unlocked"
echo "2. ✅ Ensure you have ~0.01 ETH on Base for gas"
echo "3. ✅ Double-check all addresses above"
echo "4. ✅ Run each command ONE AT A TIME"
echo "5. ✅ Verify on BaseScan after each transfer"
echo ""
echo "⚠️  IMPORTANT: Crypto transactions are IRREVERSIBLE!"
echo "⚠️  Always send a small test amount first!"
echo ""

