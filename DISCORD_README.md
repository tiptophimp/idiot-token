# 🎮 Discord Automation - Complete Guide

## ✅ **Features Overview:**

Your Discord bot now includes:
- **Role Management** - Auto-create and organize roles
- **Point Tracking** - Reward user activity
- **Leaderboards** - Weekly, monthly, yearly, all-time
- **Wallet Registration** - Users register their own wallets
- **Auto Payouts** - Convert points to IDIOT tokens
- **Transaction Logging** - CSV audit trail

---

## 🚀 **Quick Setup (5 minutes)**

### **1. Create Discord Bot**

1. Go to: https://discord.com/developers/applications
2. Click **"New Application"** → Name it "IDIOT Bot"
3. Go to **"Bot"** section:
   - Click **"Reset Token"** → Copy the token
   - Enable **Privileged Gateway Intents:**
     - ✅ Presence Intent
     - ✅ Server Members Intent
     - ✅ Message Content Intent
4. Go to **"OAuth2"** → **"URL Generator"**:
   - Scopes: Select `bot` and `applications.commands`
   - Permissions: Select `Administrator`
   - Copy generated URL and invite bot to your server

### **2. Configure Environment**

```bash
cp discord.env.example .env
nano .env   # Or edit in Cursor
```

Fill in your values:
```env
DISCORD_BOT_TOKEN=your_actual_bot_token_from_step_1
GUILD_ID=your_discord_server_id
TOP_ROLE_NAME=Founder

# For payouts
BASE_RPC=https://mainnet.base.org
PAYOUT_PRIVATE_KEY=your_wallet_private_key
TOKEN_ADDRESS=0xC29EF04CFFe38012dcfc1E96a2B368443f298dE1
POINTS_PER_TOKEN=2.5
MIN_PAYOUT=5
GAS_LIMIT=120000
```

**Get your GUILD_ID:**
- Enable Developer Mode in Discord (Settings → Advanced)
- Right-click your server → Copy Server ID

### **3. Install Dependencies**

```bash
pip install -r requirements.txt
```

### **4. Run the Bots**

**Setup Roles (run once):**
```bash
python scripts/idiot_roles.py
```
Then in Discord type: `!bootstrap`

**Start Reward Tracker (run 24/7):**
```bash
# Foreground (testing)
python scripts/idiot_rewards.py

# Background (production on VPS)
nohup python scripts/idiot_rewards.py > discord.log 2>&1 &
```

---

## 🎯 **Point System**

### **How Users Earn Points:**
- **5 points** - Post meme in #memes channel
- **2 points** - Message activity (>10 chars)
- **10 points** - Author of popular post (5+ reactions)

### **Automatic Resets:**
- **Weekly:** Every Sunday at midnight UTC
- **Monthly:** 1st of each month
- **Yearly:** January 1st

---

## 💬 **Discord Commands**

### **Slash Commands (for users):**

| Command | Description | Example |
|---------|-------------|---------|
| `/leaderboard` | Show weekly leaderboard | `/leaderboard weekly` |
| `/leaderboard monthly` | Show monthly rankings | `/leaderboard monthly` |
| `/leaderboard yearly` | Show yearly rankings | `/leaderboard yearly` |
| `/leaderboard total` | Show all-time rankings | `/leaderboard total` |
| `/wallet set` | Register your wallet | `/wallet set 0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb1` |
| `/wallet view` | Check your wallet | `/wallet view` |

### **Admin Commands (prefix !):**

| Command | Description |
|---------|-------------|
| `!bootstrap` | Create/update all roles |

---

## 💰 **Token Payouts**

### **How It Works:**
1. Users register wallets: `/wallet set <address>`
2. Users earn points through activity
3. Script runs (weekly or manual)
4. Points converted to tokens at configured rate
5. Tokens sent to registered wallets
6. Transaction logged to `payout_history.csv`

### **Conversion:**
- Default: **2.5 points = 1 IDIOT token**
- Minimum payout: **5 tokens**
- Both configurable in `.env`

### **Run Payouts:**

**Manual:**
```bash
python scripts/idiot_payouts.py
```

**Automated (GitHub Actions):**
- Runs every Sunday at 00:15 UTC
- Configured in `.github/workflows/discord_automation.yml`

---

## 📊 **Database Structure**

SQLite database `idiot_points.db`:

### **Tables:**

**points:**
```sql
user_id TEXT PRIMARY KEY
total INTEGER       -- All-time points
weekly INTEGER      -- Current week
monthly INTEGER     -- Current month
yearly INTEGER      -- Current year
```

**actions:**
```sql
id INTEGER PRIMARY KEY
user_id TEXT
kind TEXT          -- 'meme_post', 'message_activity', 'popular_post'
pts INTEGER        -- Points awarded
ts INTEGER         -- Unix timestamp
```

**wallets:**
```sql
user_id TEXT PRIMARY KEY
wallet TEXT        -- Ethereum address (0x...)
```

---

## ☁️ **GitHub Automation**

### **Add GitHub Secrets:**

Go to: https://github.com/tiptophimp/idiot-token/settings/secrets/actions

Required secrets:
- `DISCORD_BOT_TOKEN` - Your bot token
- `GUILD_ID` - Your server ID
- `BASE_RPC` - https://mainnet.base.org
- `PAYOUT_PRIVATE_KEY` - Wallet private key (for payouts)
- `TOKEN_ADDRESS` - 0xC29EF04CFFe38012dcfc1E96a2B368443f298dE1

### **Automation Schedule:**
- **Every push:** Bot validation
- **Every Sunday 00:15 UTC:** Automatic payouts
- **Manual trigger:** Available in Actions tab

---

## 🔒 **Security**

- ✅ `.env` file is git-ignored (never committed)
- ✅ Database files are git-ignored
- ✅ Payout history CSV is git-ignored
- ✅ Use GitHub Secrets for automation
- ✅ Never share your bot token or private key
- ✅ Wallet addresses validated (42 chars, starts with 0x)

---

## 🛠️ **Common Commands**

```bash
# Check bot is running
ps aux | grep idiot_rewards

# Stop bot
pkill -f idiot_rewards.py

# View logs
tail -f discord.log

# View database
sqlite3 idiot_points.db "SELECT * FROM points LIMIT 10;"
sqlite3 idiot_points.db "SELECT * FROM wallets;"

# View payout history
cat payout_history.csv | column -t -s,

# Test payout (dry run - will show what would happen)
python scripts/idiot_payouts.py
```

---

## 📈 **Transaction Logging**

All payouts are logged to `payout_history.csv`:

```csv
Timestamp,User ID,Wallet,Tokens,TX Hash
2025-10-12T19:30:00,123456789,0x742d35Cc...,25.5,0xabcdef...
```

This provides:
- Complete audit trail
- Easy reconciliation
- Transaction verification on BaseScan

---

## 🎓 **User Guide (For Your Community)**

Share this with your Discord members:

### **How to Earn IDIOT Tokens:**

1. **Be Active:**
   - Post memes in #memes (5 pts)
   - Participate in discussions (2 pts per message)
   - Create popular content (10 pts for 5+ reactions)

2. **Register Your Wallet:**
   ```
   /wallet set 0xYourWalletAddressHere
   ```

3. **Check Your Progress:**
   ```
   /leaderboard total
   ```

4. **Get Paid:**
   - Tokens automatically sent every Sunday
   - Check `payout_history.csv` for confirmation
   - Verify on BaseScan: https://basescan.org

---

## 🐛 **Troubleshooting**

### **Bot Not Responding:**
- Check bot token is correct in `.env`
- Verify bot has Administrator permission
- Ensure bot is online (`python scripts/idiot_rewards.py`)
- Check slash commands synced (shown on bot startup)

### **Points Not Tracking:**
- Check `idiot_points.db` exists
- Verify Message Content Intent is enabled
- Check bot can read messages in channels

### **Wallet Command Not Working:**
- Ensure GUILD_ID is set correctly
- Wait a few minutes for slash commands to sync
- Restart bot if commands don't appear

### **Payouts Failing:**
- Verify `PAYOUT_PRIVATE_KEY` is correct
- Check wallet has ETH for gas on Base network
- Ensure users have registered wallets
- Check RPC endpoint is responding

---

## 📞 **Support**

- **Repository:** https://github.com/tiptophimp/idiot-token
- **Token Contract:** 0xC29EF04CFFe38012dcfc1E96a2B368443f298dE1
- **Network:** Base (Chain ID: 8453)
- **Explorer:** https://basescan.org

---

**Status:** ✅ Ready for production  
**Version:** 2.0.0 (with wallet registration)  
**Last Updated:** October 12, 2025
