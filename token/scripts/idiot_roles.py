import os
import asyncio
import discord
from discord.ext import commands
from dotenv import load_dotenv

load_dotenv()
TOKEN = os.getenv("DISCORD_BOT_TOKEN")
TOP_ROLE_NAME = os.getenv("TOP_ROLE_NAME", "Founder")

intents = discord.Intents.default()
intents.members = True
bot = commands.Bot(command_prefix="!", intents=intents)

ROLE_SPECS = [
    ("Dyno", discord.Permissions(manage_roles=True, manage_messages=True, kick_members=True, ban_members=True, view_channel=True, read_message_history=True, send_messages=True)),
    ("Admin", discord.Permissions(administrator=True)),
    ("Moderator", discord.Permissions(kick_members=True, ban_members=True, manage_messages=True, view_channel=True, read_message_history=True, send_messages=True)),
    ("Holder", discord.Permissions(view_channel=True, read_message_history=True, send_messages=True)),
    ("Whale", discord.Permissions(view_channel=True, read_message_history=True, send_messages=True)),
    ("Gamer", discord.Permissions(view_channel=True, read_message_history=True, send_messages=True, connect=True, speak=True)),
    ("OG Idiot", discord.Permissions(view_channel=True, read_message_history=True, send_messages=True)),
    ("Newbie", discord.Permissions(view_channel=True, read_message_history=True, send_messages=True)),
]

async def ensure_role(guild: discord.Guild, name: str, perms: discord.Permissions):
    role = discord.utils.get(guild.roles, name=name)
    if role:
        await role.edit(permissions=perms, reason="Standardize permissions")
        return role
    return await guild.create_role(name=name, permissions=perms, reason="Auto-created by idiot_roles.py")

@bot.command()
@commands.has_permissions(administrator=True)
async def bootstrap(ctx):
    g = ctx.guild
    top_role = discord.utils.get(g.roles, name=TOP_ROLE_NAME)
    if not top_role:
        await ctx.reply(f"Top role '{TOP_ROLE_NAME}' not found.")
        return

    for name, perms in ROLE_SPECS:
        await ensure_role(g, name, perms)

    desired_order = [TOP_ROLE_NAME, "Dyno", "Admin", "Moderator", "Holder", "Whale", "Gamer", "OG Idiot", "Newbie"]
    role_map = {r.name: r for r in g.roles}
    anchor_pos = top_role.position
    next_pos = anchor_pos - 1

    for name in desired_order[1:]:
        role = role_map.get(name)
        if role:
            await role.edit(position=next_pos, reason="Reordering roles")
            next_pos -= 1

    await ctx.reply("✅ Roles created and ordered successfully.")

bot.run(TOKEN)
