// Discord Bot Commands for IDIOT Community
// Add these to your Discord bot for community engagement

const { SlashCommandBuilder, EmbedBuilder } = require('discord.js');

// Command: /confess
const confessCommand = new SlashCommandBuilder()
  .setName('confess')
  .setDescription('Share your IDIOT moment with the community')
  .addStringOption(option =>
    option.setName('confession')
      .setDescription('Your dumbest financial move or trading mistake')
      .setRequired(true)
  )
  .addStringOption(option =>
    option.setName('loss')
      .setDescription('How much you lost (optional)')
      .setRequired(false)
  );

async function handleConfess(interaction) {
  const confession = interaction.options.getString('confession');
  const loss = interaction.options.getString('loss') || 'Unknown';
  
  const embed = new EmbedBuilder()
    .setTitle('🎭 IDIOT Confession')
    .setDescription(`**${interaction.user.username}** confesses:\n\n"${confession}"`)
    .addFields(
      { name: 'Loss Amount', value: loss, inline: true },
      { name: 'Confession ID', value: `#${Date.now().toString().slice(-6)}`, inline: true }
    )
    .setColor(0x00ff00)
    .setTimestamp();

  await interaction.reply({ embeds: [embed] });
  
  // Add reaction for community engagement
  const message = await interaction.fetchReply();
  await message.react('🎭');
  await message.react('😂');
  await message.react('💀');
}

// Command: /idiotstats
const statsCommand = new SlashCommandBuilder()
  .setName('idiotstats')
  .setDescription('Show community IDIOT statistics');

async function handleStats(interaction) {
  // This would connect to your database
  const totalConfessions = 247; // Replace with actual count
  const totalLoss = 1250000; // Replace with actual total
  const avgLoss = Math.round(totalLoss / totalConfessions);
  
  const embed = new EmbedBuilder()
    .setTitle('📊 IDIOT Community Stats')
    .setDescription('How much idiocy have we collectively achieved?')
    .addFields(
      { name: 'Total Confessions', value: totalConfessions.toString(), inline: true },
      { name: 'Collective Loss', value: `$${totalLoss.toLocaleString()}`, inline: true },
      { name: 'Average Loss', value: `$${avgLoss.toLocaleString()}`, inline: true },
      { name: 'Most Common Mistake', value: 'FOMO buying at ATH', inline: true },
      { name: 'Biggest Loss', value: '$50,000 (100x leverage)', inline: true },
      { name: 'Community Level', value: 'Maximum IDIOT', inline: true }
    )
    .setColor(0xffd700)
    .setTimestamp();

  await interaction.reply({ embeds: [embed] });
}

// Command: /idiotquote
const quoteCommand = new SlashCommandBuilder()
  .setName('idiotquote')
  .setDescription('Get a random IDIOT quote or wisdom');

async function handleQuote(interaction) {
  const quotes = [
    "ROMO over FOMO - Rational Over Meme Over FOMO",
    "Buy on the peak. Sell on the dip. Do it the IDIOT way.",
    "We're not here to make money. We're here to make memories.",
    "Diamond hands? More like paper hands with commitment issues.",
    "This time it's different... said every IDIOT ever.",
    "I'm not a financial advisor. I'm not even a good financial decision maker.",
    "HODL? More like HODL until I panic sell at the bottom.",
    "FOMO is not a strategy. It's a lifestyle.",
    "We're all idiots. The difference is we admit it.",
    "Buy high, sell low. It's not just a strategy, it's a way of life."
  ];
  
  const randomQuote = quotes[Math.floor(Math.random() * quotes.length)];
  
  const embed = new EmbedBuilder()
    .setTitle('🎭 IDIOT Wisdom')
    .setDescription(`"${randomQuote}"`)
    .setColor(0x00ff00)
    .setFooter({ text: 'IDIOT Token - Embracing the Chaos' });

  await interaction.reply({ embeds: [embed] });
}

// Command: /idiotchallenge
const challengeCommand = new SlashCommandBuilder()
  .setName('idiotchallenge')
  .setDescription('Start a community IDIOT challenge')
  .addStringOption(option =>
    option.setName('theme')
      .setDescription('Challenge theme')
      .setRequired(true)
      .addChoices(
        { name: 'Worst FOMO Buy', value: 'fomo' },
        { name: 'Biggest Loss', value: 'loss' },
        { name: 'Most Creative Excuse', value: 'excuse' },
        { name: 'Best Comeback Story', value: 'comeback' }
      )
  );

async function handleChallenge(interaction) {
  const theme = interaction.options.getString('theme');
  const themes = {
    fomo: 'Worst FOMO Buy',
    loss: 'Biggest Loss',
    excuse: 'Most Creative Excuse',
    comeback: 'Best Comeback Story'
  };
  
  const embed = new EmbedBuilder()
    .setTitle('🎯 IDIOT Challenge')
    .setDescription(`**Theme: ${themes[theme]}**\n\nShare your story in this channel!\n\nRules:\n- Must be 100% true\n- Must be funny/relatable\n- Tag 3 friends\n- Use #IDIOTChallenge\n\nWinner gets 1000 IDIOT tokens!`)
    .setColor(0xff6b6b)
    .setTimestamp();

  await interaction.reply({ embeds: [embed] });
}

// Command: /idiothelp
const helpCommand = new SlashCommandBuilder()
  .setName('idiothelp')
  .setDescription('Show all available IDIOT commands');

async function handleHelp(interaction) {
  const embed = new EmbedBuilder()
    .setTitle('🎭 IDIOT Bot Commands')
    .setDescription('Here are all the commands you can use:')
    .addFields(
      { name: '/confess', value: 'Share your IDIOT moment with the community', inline: false },
      { name: '/idiotstats', value: 'Show community statistics', inline: false },
      { name: '/idiotquote', value: 'Get a random IDIOT quote', inline: false },
      { name: '/idiotchallenge', value: 'Start a community challenge', inline: false },
      { name: '/idiothelp', value: 'Show this help message', inline: false }
    )
    .setColor(0x00ff00)
    .setFooter({ text: 'IDIOT Token - Where Idiots Unite' });

  await interaction.reply({ embeds: [embed] });
}

// Export commands for bot setup
module.exports = {
  confessCommand,
  handleConfess,
  statsCommand,
  handleStats,
  quoteCommand,
  handleQuote,
  challengeCommand,
  handleChallenge,
  helpCommand,
  handleHelp
};

// Auto-responses for common phrases
const autoResponses = {
  'fomo': 'ROMO over FOMO! 🎭',
  'diamond hands': 'More like paper hands with commitment issues! 😂',
  'this time it\'s different': 'Said every IDIOT ever! 💀',
  'buy the dip': 'Buy on the peak. Sell on the dip. Do it the IDIOT way! 🚀',
  'hodl': 'HODL until I panic sell at the bottom! 📉',
  'moon': 'We\'re not going to the moon. We\'re going to the IDIOT! 🎭'
};

// Function to check for auto-responses
function checkAutoResponse(message) {
  const lowerMessage = message.toLowerCase();
  for (const [trigger, response] of Object.entries(autoResponses)) {
    if (lowerMessage.includes(trigger)) {
      return response;
    }
  }
  return null;
}
