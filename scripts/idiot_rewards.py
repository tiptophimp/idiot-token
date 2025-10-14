import os
import sys
import sqlite3
import time
import discord
from discord import app_commands
from discord.ext import commands, tasks
from dotenv import load_dotenv

load_dotenv()
TOKEN = os.getenv("DISCORD_BOT_TOKEN")
_guild_env = os.getenv("GUILD_ID", "").strip()
try:
    GUILD_ID = int(_guild_env) if _guild_env else 0
except ValueError:
    print("Invalid GUILD_ID; expected integer. Skipping run.")
    sys.exit(0)

if not TOKEN or not GUILD_ID:
    print("Missing DISCORD_BOT_TOKEN or GUILD_ID; skipping automation run.")
    sys.exit(0)
DB = "idiot_points.db"

intents = discord.Intents.default()
intents.members = True
intents.message_content = True
intents.guilds = True
intents.reactions = True
bot = commands.Bot(command_prefix="!", intents=intents)

### ---------- DATABASE SETUP ---------- ###
def db():
    c = sqlite3.connect(DB)
    c.execute("""
    CREATE TABLE IF NOT EXISTS points (
        user_id TEXT PRIMARY KEY,
        total INTEGER DEFAULT 0,
        weekly INTEGER DEFAULT 0,
        monthly INTEGER DEFAULT 0,
        yearly INTEGER DEFAULT 0
    )
    """)
    c.execute("""
    CREATE TABLE IF NOT EXISTS actions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id TEXT,
        kind TEXT,
        pts INTEGER,
        ts INTEGER
    )
    """)
    c.execute("""
    CREATE TABLE IF NOT EXISTS wallets (
        user_id TEXT PRIMARY KEY,
        wallet TEXT
    )
    """)
    return c


### ---------- POINT MANAGEMENT ---------- ###
def add_points(uid, pts, kind):
    c = db()
    c.execute("INSERT INTO actions(user_id, kind, pts, ts) VALUES(?,?,?,?)", (uid, kind, pts, int(time.time())))
    c.execute("""
    INSERT INTO points(user_id, total, weekly, monthly, yearly)
    VALUES(?,?,?,?,?)
    ON CONFLICT(user_id) DO UPDATE SET
        total=total+excluded.total,
        weekly=weekly+excluded.weekly,
        monthly=monthly+excluded.monthly,
        yearly=yearly+excluded.yearly
    """, (uid, pts, pts, pts, pts))
    c.commit()
    c.close()


def top(scope, n=10):
    c = db()
    cur = c.execute(f"SELECT user_id, {scope} FROM points ORDER BY {scope} DESC LIMIT ?", (n,))
    rows = cur.fetchall()
    c.close()
    return rows


### ---------- WALLET MANAGEMENT ---------- ###
def set_wallet(user_id, wallet):
    c = db()
    c.execute("INSERT INTO wallets(user_id, wallet) VALUES(?,?) ON CONFLICT(user_id) DO UPDATE SET wallet=excluded.wallet", (user_id, wallet))
    c.commit()
    c.close()

def get_wallet(user_id):
    c = db()
    cur = c.execute("SELECT wallet FROM wallets WHERE user_id=?", (user_id,))
    row = cur.fetchone()
    c.close()
    return row[0] if row else None


### ---------- EVENTS ---------- ###
@bot.event
async def on_ready():
    print(f"✅ Connected as {bot.user}")
    try:
        synced = await bot.tree.sync(guild=discord.Object(id=GUILD_ID))
        print(f"Synced {len(synced)} slash commands.")
    except Exception as e:
        print("Sync error:", e)

    weekly_reset.start()
    monthly_reset.start()
    yearly_reset.start()


@bot.event
async def on_message(msg):
    if msg.author.bot:
        return
    if msg.channel.name == "memes":
        add_points(str(msg.author.id), 5, "meme_post")
    if len(msg.content) > 10:
        add_points(str(msg.author.id), 2, "message_activity")
    await bot.process_commands(msg)


@bot.event
async def on_reaction_add(reaction, user):
    if reaction.count == 5:
        add_points(str(reaction.message.author.id), 10, "popular_post")


### ---------- COMMANDS ---------- ###
@bot.tree.command(name="leaderboard", description="Show leaderboard for weekly, monthly, yearly, or total points.")
@app_commands.describe(scope="Choose ranking scope")
@app_commands.choices(scope=[
    app_commands.Choice(name="weekly", value="weekly"),
    app_commands.Choice(name="monthly", value="monthly"),
    app_commands.Choice(name="yearly", value="yearly"),
    app_commands.Choice(name="total", value="total"),
])
async def leaderboard(interaction: discord.Interaction, scope: app_commands.Choice[str]):
    rows = top(scope.value)
    lines = []
    for i, (uid, pts) in enumerate(rows, 1):
        member = interaction.guild.get_member(int(uid))
        name = member.display_name if member else uid
        lines.append(f"{i}. {name} — {pts}")
    await interaction.response.send_message(f"🏆 **{scope.value.title()} Leaderboard**\n" + "\n".join(lines))


@bot.tree.command(name="wallet", description="Set or check your wallet address.")
@app_commands.describe(action="Choose set or view", address="Your wallet address (if setting)")
@app_commands.choices(action=[
    app_commands.Choice(name="set", value="set"),
    app_commands.Choice(name="view", value="view"),
])
async def wallet(interaction: discord.Interaction, action: app_commands.Choice[str], address: str = None):
    uid = str(interaction.user.id)
    if action.value == "set":
        if not address or not address.startswith("0x") or len(address) != 42:
            await interaction.response.send_message("❌ Invalid wallet address. Must start with 0x and be 42 chars long.")
            return
        set_wallet(uid, address)
        await interaction.response.send_message(f"✅ Wallet address saved: `{address}`")
    elif action.value == "view":
        wallet = get_wallet(uid)
        if wallet:
            await interaction.response.send_message(f"💼 Your registered wallet: `{wallet}`")
        else:
            await interaction.response.send_message("❌ No wallet found. Use `/wallet set <address>` to register.")


### ---------- AUTOMATED RESETS ---------- ###
@tasks.loop(hours=24)
async def weekly_reset():
    if time.gmtime().tm_wday == 6:  # Sunday
        c = db()
        c.execute("UPDATE points SET weekly=0")
        c.commit()
        c.close()


@tasks.loop(hours=24)
async def monthly_reset():
    if time.gmtime().tm_mday == 1:
        c = db()
        c.execute("UPDATE points SET monthly=0")
        c.commit()
        c.close()


@tasks.loop(hours=24)
async def yearly_reset():
    if time.gmtime().tm_yday == 1:
        c = db()
        c.execute("UPDATE points SET yearly=0")
        c.commit()
        c.close()


bot.run(TOKEN)
