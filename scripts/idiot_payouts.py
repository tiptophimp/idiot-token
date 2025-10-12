import os
import sqlite3
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

def fetch_snapshot():
    c = sqlite3.connect("idiot_points.db")
    cur = c.execute("SELECT user_id, total FROM points")
    rows = cur.fetchall()
    c.close()
    return rows

def discord_id_to_wallet(uid: str) -> str:
    """Map Discord user_id to wallet address. Implement this mapping later."""
    # TODO: Implement wallet mapping system
    # Could use a database table or JSON file to map Discord IDs to wallet addresses
    return None

def main():
    if not acct or not token:
        print("❌ Missing PAYOUT_PRIVATE_KEY or TOKEN_ADDRESS in environment")
        return
        
    nonce = w3.eth.get_transaction_count(acct.address)
    rows = fetch_snapshot()
    sent = 0
    
    for uid, total_pts in rows:
        tokens = (Decimal(total_pts) / POINTS_PER_TOKEN).quantize(Decimal("1.000000"))
        if tokens < MIN_PAYOUT:
            continue
            
        to = discord_id_to_wallet(uid)
        if not to:
            continue
            
        try:
            tx = token.functions.transfer(
                Web3.to_checksum_address(to), 
                int(tokens * (10**18))
            ).build_transaction({
                "from": acct.address,
                "nonce": nonce,
                "gas": GAS_LIMIT,
                "maxFeePerGas": w3.to_wei("0.2", "gwei"),
                "maxPriorityFeePerGas": w3.to_wei("0.05", "gwei"),
                "chainId": 8453,
            })
            
            signed = acct.sign_transaction(tx)
            txh = w3.eth.send_raw_transaction(signed.rawTransaction)
            print(f"✅ Sent {tokens} IDIOT to {to} — TX: {txh.hex()}")
            nonce += 1
            sent += 1
        except Exception as e:
            print(f"❌ Failed to send to {to}: {e}")
            
    print(f"✅ Completed {sent} payouts")

if __name__ == "__main__":
    main()

