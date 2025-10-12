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
LOG_FILE = "payout_history.csv"

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
    """Optional: clear points after payout (keep running totals)."""
    c = sqlite3.connect(DB_PATH)
    c.execute("UPDATE points SET weekly = 0")
    c.execute("UPDATE points SET monthly = 0")
    c.commit()
    c.close()


### ---------- TRANSACTION LOGGING ---------- ###
def log_transaction(user_id, wallet, tokens, tx_hash):
    """Log payout to CSV for audit trail."""
    file_exists = os.path.isfile(LOG_FILE)
    with open(LOG_FILE, 'a', newline='') as f:
        writer = csv.writer(f)
        if not file_exists:
            writer.writerow(['Timestamp', 'User ID', 'Wallet', 'Tokens', 'TX Hash'])
        writer.writerow([datetime.now().isoformat(), user_id, wallet, str(tokens), tx_hash])


### ---------- PAYOUT ENGINE ---------- ###
def main():
    if not acct or not token:
        print("❌ Missing PAYOUT_PRIVATE_KEY or TOKEN_ADDRESS in environment")
        return
        
    print("🔄 Starting IDIOT token payouts...")
    rows = fetch_snapshot()
    nonce = w3.eth.get_transaction_count(acct.address)
    sent = 0

    for uid, total_pts, wallet in rows:
        if not wallet or not wallet.startswith("0x") or len(wallet) != 42:
            print(f"⚠️  Skipping {uid}: no valid wallet registered.")
            continue

        tokens = (Decimal(total_pts) / POINTS_PER_TOKEN).quantize(Decimal("1.000000"))
        if tokens < MIN_PAYOUT:
            continue

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
                "chainId": 8453,  # Base network chain ID
            })

            signed = acct.sign_transaction(tx)
            txh = w3.eth.send_raw_transaction(signed.rawTransaction)
            tx_hash = txh.hex()
            
            print(f"✅ Sent {tokens} IDIOT → {wallet} | TX: {tx_hash}")
            log_transaction(uid, wallet, tokens, tx_hash)
            
            nonce += 1
            sent += 1
        except Exception as e:
            print(f"❌ Failed to send to {wallet}: {e}")

    print(f"🎯 Completed {sent} total payouts.")
    if sent > 0:
        reset_after_payout()


if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        print("❌ Error during payout:", e)
