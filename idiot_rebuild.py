import discord
from discord.ext import commands

# ==== CONFIGURATION ====
import os
from dotenv import load_dotenv

load_dotenv()
TOKEN = os.getenv("DISCORD_BOT_TOKEN")
GUILD_ID = int(os.getenv("GUILD_ID", "1081226161507536946"))
# ========================

intents = discord.Intents.all()
bot = commands.Bot(command_prefix="!", intents=intents)

roles_to_create = [
    ("Founder", discord.Permissions(administrator=True)),
    ("Admin", discord.Permissions(manage_roles=True, manage_channels=True)),
    ("Moderator", discord.Permissions(kick_members=True, ban_members=True, manage_messages=True)),
    ("OG Idiot", discord.Permissions(send_messages=True, read_messages=True)),
    ("Holder", discord.Permissions(send_messages=True, read_messages=True)),
    ("Whale", discord.Permissions(send_messages=True, read_messages=True)),
    ("Gamer", discord.Permissions(connect=True, speak=True, read_messages=True)),
    ("Newbie", discord.Permissions(read_messages=True, send_messages=True)),
    ("Bot", discord.Permissions(manage_messages=True, embed_links=True, read_messages=True))
]

categories = {
    "🪙 IDIOT TOKEN HUB": ["announcements", "roadmap", "how-to-buy", "price-feed", "holder-chat", "memes", "giveaways"],
    "💬 COMMUNITY": ["general-chat", "introductions", "ideas", "support", "off-topic"],
    "🎮 GAMING LOUNGE": ["matchmaking", "clips", "token-tournaments", "Voice:lobby-voice"],
    "🎓 ENTRY ZONE": ["welcome", "rules", "meme-to-earn-access"],
    "⚙️ TEAM ZONE": ["dev-updates", "marketing", "mod-chat", "backup-log"]
}

@bot.event
async def on_ready():
    print(f"Logged in as {bot.user}")
    guild = bot.get_guild(GUILD_ID)
    if not guild:
        print("Guild not found. Check GUILD_ID.")
        await bot.close()
        return

    # Delete existing channels
    print("Deleting existing channels...")
    for ch in guild.channels:
        try:
            await ch.delete()
        except:
            pass

    # Delete existing roles (except @everyone)
    print("Deleting old roles...")
    for role in guild.roles:
        if role.name != "@everyone":
            try:
                await role.delete()
            except:
                pass

    # Create roles
    print("Creating new roles...")
    created_roles = {}
    for name, perms in roles_to_create:
        role = await guild.create_role(name=name, permissions=perms)
        created_roles[name] = role

    # Assign OG Idiot to all existing members
    print("Assigning OG Idiot role to existing members...")
    og_role = created_roles.get("OG Idiot")
    for member in guild.members:
        if not member.bot:
            await member.add_roles(og_role)

    # Set @Newbie as default
    newbie_role = created_roles.get("Newbie")
    await guild.edit(default_notifications=discord.NotificationLevel.all_messages)
    everyone_role = guild.default_role
    await everyone_role.edit(permissions=discord.Permissions.none())

    # Create categories and channels
    print("Creating categories and channels...")
    for cat_name, chans in categories.items():
        category = await guild.create_category(cat_name)
        for ch_name in chans:
            if ch_name.startswith("Voice:"):
                await category.create_voice_channel(ch_name.replace("Voice:", ""))
            else:
                await category.create_text_channel(ch_name)

    print("Rebuild complete. Idiot Token structure applied.")
    await bot.close()

bot.run(TOKEN)
