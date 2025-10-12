# 🎮 Discord Automation - Quick Start

## ✅ **What's Been Created:**

Your repository now has **complete Discord automation** for the IDIOT Token community!

### 📦 **Files Created:**
- `scripts/idiot_roles.py` - Role management bot
- `scripts/idiot_rewards.py` - Point tracking & leaderboards  
- `scripts/idiot_payouts.py` - Token payout automation
- `.github/workflows/discord_automation.yml` - GitHub Actions workflow
- `requirements.txt` - Python dependencies
- `discord.env.example` - Environment template

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

TOKEN_ADDRESS=0xC29EF04CFFe38012dcfc1E96a2B368443f298dE1
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

## 🎯 **Features**

### **Role Management**
- Auto-creates Discord roles with proper permissions
- Command: `!bootstrap` (admin only)

### **Reward System**
- **5 points** - Post meme in #memes channel
- **2 points** - Message activity (>10 chars)
- **10 points** - Author of popular post (5+ reactions)

### **Leaderboards**
Commands:
- `!leaderboard` or `!leaderboard weekly`
- `!leaderboard monthly`
- `!leaderboard yearly`
- `!leaderboard total`

### **Token Payouts**
- Automatically converts points to IDIOT tokens
- Runs weekly via GitHub Actions
- Manual: `python scripts/idiot_payouts.py`

---

## ☁️ **GitHub Automation**

### **Add GitHub Secrets:**

Go to: https://github.com/tiptophimp/idiot-token/settings/secrets/actions

Add:
- `DISCORD_BOT_TOKEN` - Your bot token
- `GUILD_ID` - Your server ID  
- `BASE_RPC` - https://mainnet.base.org
- `PAYOUT_PRIVATE_KEY` - Wallet private key (for payouts)
- `TOKEN_ADDRESS` - 0xC29EF04CFFe38012dcfc1E96a2B368443f298dE1

### **Automation Schedule:**
- **Every push:** Reward tracker validation
- **Every Sunday 00:15 UTC:** Automatic payouts
- **Manual trigger:** Available in Actions tab

---

## 📊 **Database**

SQLite database `idiot_points.db` tracks:
- User points (weekly, monthly, yearly, total)
- Activity log (all point-earning actions)

---

## 🔒 **Security**

- ✅ `.env` file is git-ignored (never committed)
- ✅ Database files are git-ignored
- ✅ Use GitHub Secrets for automation
- ✅ Never share your bot token or private key

---

## 🛠️ **Common Commands**

```bash
# Check bot is running
ps aux | grep idiot_rewards

# Stop bot
pkill -f idiot_rewards.py

# View logs
tail -f discord.log

# Test database
sqlite3 idiot_points.db "SELECT * FROM points LIMIT 10;"
```

---

## 📈 **Next Steps**

1. ✅ **Implement wallet mapping** in `scripts/idiot_payouts.py`
   - Create command: `!linkwallet <address>`
   - Store Discord ID → Wallet address mapping

2. ✅ **Add more activities:**
   - Voice chat participation
   - Event attendance
   - Referrals

3. ✅ **Create dashboard:**
   - Web interface for stats
   - Admin panel

---

## 📞 **Support**

- **Discord Bot Issues:** Check bot has proper permissions
- **Point tracking:** Verify Message Content Intent is enabled
- **Payouts:** Implement wallet mapping function first

---

**Status:** ✅ Ready to deploy  
**Version:** 1.0.0  
**Created:** October 12, 2025

