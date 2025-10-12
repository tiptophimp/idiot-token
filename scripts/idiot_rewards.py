import os
import sqlite3
import time
import discord
from discord.ext import commands, tasks
from dotenv import load_dotenv

load_dotenv()
TOKEN = os.getenv("DISCORD_BOT_TOKEN")
GUILD_ID = int(os.getenv("GUILD_ID", "0"))

DB = "idiot_points.db"
intents = discord.Intents.default()
intents.members = True
intents.message_content = True
intents.guilds = True
intents.reactions = True
bot = commands.Bot(command_prefix="!", intents=intents)

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
    return c

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

@bot.event
async def on_ready():
    print(f"Connected as {bot.user}")
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

@bot.command()
async def leaderboard(ctx, scope="weekly"):
    if scope not in ("weekly", "monthly", "yearly", "total"):
        await ctx.reply("Use: !leaderboard weekly|monthly|yearly|total")
        return
    rows = top(scope)
    lines = []
    for i, (uid, pts) in enumerate(rows, 1):
        member = ctx.guild.get_member(int(uid))
        name = member.display_name if member else uid
        lines.append(f"{i}. {name} — {pts}")
    await ctx.reply(f"🏆 **{scope.title()} Leaderboard**\n" + "\n".join(lines))

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

