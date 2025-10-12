import os
import sqlite3
import csv
from datetime import datetime
from web3 import Web3
from decimal import Decimal
from dotenv import load_dotenv

load_dotenv()

RPC = os.getenv("BASE_RPC", "https://mainnet.base.org")
PRIVATE_KEY = os.getenv("PAYOUT_PRIVATE_KEY")
TOKEN_ADDR = os.getenv("TOKEN_ADDRESS")
POINTS_PER_TOKEN = Decimal(os.getenv("POINTS_PER_TOKEN", "2.5"))
MIN_PAYOUT = Decimal(os.getenv("MIN_PAYOUT", "5"))
GAS_LIMIT = int(os.getenv("GAS_LIMIT", "120000"))
DB_PATH = "idiot_points.db"
LOG_FILE = "payout_transactions.csv"

ERC20_ABI = [
    {
        "constant": False,
        "inputs": [
            {"name": "to", "type": "address"},
            {"name": "value", "type": "uint256"}
        ],
        "name": "transfer",
        "outputs": [{"name": "", "type": "bool"}],
        "type": "function",
    }
]

w3 = Web3(Web3.HTTPProvider(RPC))
acct = w3.eth.account.from_key(PRIVATE_KEY) if PRIVATE_KEY else None
token = w3.eth.contract(address=Web3.to_checksum_address(TOKEN_ADDR), abi=ERC20_ABI) if TOKEN_ADDR else None

### ---------- DATABASE HELPERS ---------- ###
def fetch_snapshot():
    """Return all users with total points and mapped wallet addresses."""
    c = sqlite3.connect(DB_PATH)
    cur = c.execute("""
        SELECT p.user_id, p.total, w.wallet
        FROM points p
        LEFT JOIN wallets w ON p.user_id = w.user_id
    """)
    rows = cur.fetchall()
    c.close()
    return rows


def reset_after_payout():
    """Reset weekly/monthly counters after successful payout."""
    c = sqlite3.connect(DB_PATH)
    c.execute("UPDATE points SET weekly = 0")
    c.execute("UPDATE points SET monthly = 0")
    c.commit()
    c.close()
    print("🔄 Points counters reset")


### ---------- CSV LOGGING ---------- ###
def init_csv_log():
    """Initialize CSV log file with headers if it doesn't exist."""
    try:
        with open(LOG_FILE, 'x', newline='') as f:
            writer = csv.writer(f)
            writer.writerow(['timestamp', 'discord_id', 'wallet_address', 'tokens_sent', 'points_used', 'tx_hash', 'status'])
    except FileExistsError:
        pass  # File already exists


def log_transaction(discord_id, wallet, tokens, points, tx_hash, status='success'):
    """Append transaction to CSV log."""
    with open(LOG_FILE, 'a', newline='') as f:
        writer = csv.writer(f)
        writer.writerow([
            datetime.now().isoformat(),
            discord_id,
            wallet,
            str(tokens),
            points,
            tx_hash,
            status
        ])


### ---------- PAYOUT ENGINE ---------- ###
def main():
    if not acct or not token:
        print("❌ Missing PAYOUT_PRIVATE_KEY or TOKEN_ADDRESS in environment")
        return
        
    print("🔄 Starting IDIOT token payouts...")
    print(f"📊 Conversion rate: {POINTS_PER_TOKEN} points per token")
    print(f"💰 Minimum payout: {MIN_PAYOUT} tokens\n")
    
    init_csv_log()
    rows = fetch_snapshot()
    nonce = w3.eth.get_transaction_count(acct.address)
    sent = 0
    skipped = 0
    failed = 0

    for uid, total_pts, wallet in rows:
        # Validate wallet
        if not wallet or not wallet.startswith("0x") or len(wallet) != 42:
            print(f"⚠️  Skipping {uid}: no valid wallet registered")
            log_transaction(uid, wallet or "N/A", 0, total_pts, "N/A", "no_wallet")
            skipped += 1
            continue

        # Calculate tokens
        tokens = (Decimal(total_pts) / POINTS_PER_TOKEN).quantize(Decimal("1.000000"))
        if tokens < MIN_PAYOUT:
            print(f"⚠️  Skipping {uid}: {tokens} tokens < minimum {MIN_PAYOUT}")
            log_transaction(uid, wallet, tokens, total_pts, "N/A", "below_minimum")
            skipped += 1
            continue

        # Execute transaction
        try:
            tx = token.functions.transfer(
                Web3.to_checksum_address(wallet), 
                int(tokens * (10**18))
            ).build_transaction({
                "from": acct.address,
                "nonce": nonce,
                "gas": GAS_LIMIT,
                "maxFeePerGas": w3.to_wei("0.2", "gwei"),
                "maxPriorityFeePerGas": w3.to_wei("0.05", "gwei"),
                "chainId": 8453,  # Base network
            })

            signed = acct.sign_transaction(tx)
            txh = w3.eth.send_raw_transaction(signed.rawTransaction)
            tx_hash = txh.hex()
            
            print(f"✅ Sent {tokens} IDIOT → {wallet} | TX: {tx_hash}")
            log_transaction(uid, wallet, tokens, total_pts, tx_hash, "success")
            
            nonce += 1
            sent += 1
            
        except Exception as e:
            print(f"❌ Failed to send to {wallet}: {e}")
            log_transaction(uid, wallet, tokens, total_pts, "N/A", f"error: {str(e)[:50]}")
            failed += 1

    # Summary
    print(f"\n{'='*60}")
    print(f"📊 PAYOUT SUMMARY")
    print(f"{'='*60}")
    print(f"✅ Successful: {sent}")
    print(f"⚠️  Skipped: {skipped}")
    print(f"❌ Failed: {failed}")
    print(f"📁 Log saved to: {LOG_FILE}")
    print(f"{'='*60}\n")
    
    if sent > 0:
        reset_after_payout()


if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        print(f"❌ Critical error during payout: {e}")
        import traceback
        traceback.print_exc()
