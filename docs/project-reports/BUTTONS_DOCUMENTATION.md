# Site Buttons Documentation

## All Buttons on stupidiots.com

### Header Section

1. **Sticky Header Buy Now Button**
   - Link: `https://app.uniswap.org/explore/pools/base/0x763c9aB550dC0DAbd32F40131481Bf4BA4d8c1ea`
   - Class: `btn btn-primary`
   - Action: Opens Uniswap pool explorer

---

### Spinning Discord Tokens (2)

2. **Left Discord Token**
   - Link: `https://discord.gg/njtNfZRA`
   - Class: `discord-coin discord-coin-left`
   - Action: Opens Discord invite

3. **Right Discord Token**
   - Link: `https://discord.gg/njtNfZRA`
   - Class: `discord-coin discord-coin-right`
   - Action: Opens Discord invite

---

### Chatbot Widget

4. **Chatbot Toggle Button**
   - Type: `<button>`
   - Class: `chatbot-toggle`
   - Action: `toggleChatbot()`
   - Icon: 💬

5. **Chatbot Close Button**
   - Type: `<button>`
   - Class: `chatbot-close`
   - Action: `toggleChatbot()`
   - Text: ×

6. **Quick Reply: How to buy?**
   - Type: `<button>`
   - Class: `quick-reply-btn`
   - Action: `sendQuickReply('How to buy?')`
   - Text: 💰 How to buy?

7. **Quick Reply: Tokenomics?**
   - Type: `<button>`
   - Class: `quick-reply-btn`
   - Action: `sendQuickReply('Tokenomics?')`
   - Text: 📊 Tokenomics?

8. **Quick Reply: Airdrop info?**
   - Type: `<button>`
   - Class: `quick-reply-btn`
   - Action: `sendQuickReply('Airdrop info?')`
   - Text: 🎁 Airdrop?

9. **Quick Reply: Contract address?**
   - Type: `<button>`
   - Class: `quick-reply-btn`
   - Action: `sendQuickReply('Contract address?')`
   - Text: 📝 Contract?

10. **Chatbot Send Button**
    - Type: `<button>`
    - Class: `chatbot-send`
    - Action: `sendMessage()`
    - Text: ➤

---

### Hero Section - Main CTA Buttons

11. **View Chart**
    - Link: `#chart`
    - Class: `btn btn-gradient`
    - Action: Scrolls to chart section

12. **Buy on Uniswap**
    - Link: `https://app.uniswap.org/explore/pools/base/0x763c9aB550dC0DAbd32F40131481Bf4BA4d8c1ea`
    - Class: `btn btn-primary`
    - Action: Opens Uniswap pool

13. **🎁 Claim Airdrop**
    - Link: `/airdrop/`
    - Class: `btn btn-secondary`
    - Action: Opens airdrop portal

14. **💼 Jobs & Bounties**
    - Link: `/jobs/`
    - Class: `btn btn-secondary`
    - Action: Opens jobs page

15. **🏆 Meme Contest**
    - Link: `/meme-contest/`
    - Class: `btn btn-secondary`
    - Action: Opens meme contest page

16. **🎨 Create Meme**
    - Link: `/meme-generator/`
    - Class: `btn btn-secondary`
    - Action: Opens meme generator

17. **📄 Whitepaper**
    - Link: `/whitepaper.html`
    - Class: `btn btn-secondary`
    - Action: Opens whitepaper

18. **View Contract**
    - Link: `https://basescan.org/token/0xC29EF04CFFe38012dcfc1E96a2B368443f298dE1`
    - Class: `btn btn-secondary`
    - Action: Opens BaseScan

---

### Contract Section

19. **Copy Contract Button**
    - Type: `<button>`
    - Class: `copy-btn`
    - Action: `copyContract()`
    - Text: Copy
    - Copies: `0xC29EF04CFFe38012dcfc1E96a2B368443f298dE1`

---

### Chart Section

20. **DexScreener Tab**
    - Type: `<button>`
    - Class: `chart-tab active`
    - Action: `showChart('dexscreener')`
    - Text: DexScreener

21. **DEXTools Tab**
    - Type: `<button>`
    - Class: `chart-tab`
    - Action: `showChart('dextools')`
    - Text: DEXTools

---

### How to Buy Section

22. **Swap Now on Uniswap**
    - Link: `https://app.uniswap.org/swap?outputCurrency=0xC29EF04CFFe38012dcfc1E96a2B368443f298dE1&chain=base`
    - Class: `btn btn-primary`
    - Style: `background: white; color: var(--primary);`
    - Action: Opens Uniswap swap interface

---

### Airdrop Section

23. **Claim Portal**
    - Link: `/airdrop/`
    - Class: `btn btn-primary`
    - Style: `background: white; color: var(--primary);`
    - Action: Opens airdrop claim portal

24. **View Rules**
    - Link: `/airdrop/idiocracy`
    - Class: `btn btn-secondary`
    - Action: Opens airdrop rules page

25. **Proofs**
    - Link: `/airdrop/idiocracy-1.json`
    - Class: `btn btn-secondary`
    - Action: Opens proofs JSON file

---

### FAQ Section

26. **FAQ Toggle Buttons**
    - Type: `<button>`
    - Multiple buttons (one per FAQ item)
    - Action: Toggles FAQ answer visibility

---

### Footer Social Links

27. **Twitter**
    - Link: `https://twitter.com/idiottoken`
    - Class: `social-link`
    - Icon: 🐦

28. **Telegram**
    - Link: `https://t.me/idiottoken`
    - Class: `social-link`
    - Icon: ✈️

29. **Discord**
    - Link: `https://discord.gg/njtNfZRA`
    - Class: `social-link`
    - Icon: 💬

30. **GitHub**
    - Link: `https://github.com/tiptophimp/idiot-token`
    - Class: `social-link`
    - Icon: 🐙

---

## Button Classes Summary

### Primary Buttons
- `.btn.btn-primary` - Main action buttons (orange/primary color)
- Background: `var(--primary)` (#FF6B35)
- Used for: Buy, Swap, Main CTAs

### Secondary Buttons
- `.btn.btn-secondary` - Secondary action buttons
- Background: `var(--accent)` (#1A659E)
- Used for: Whitepaper, Meme Generator, Jobs, etc.

### Gradient Buttons
- `.btn.btn-gradient` - Special gradient buttons
- Background: Purple/pink gradient
- Used for: View Chart

### Special Buttons
- `.discord-coin` - Large spinning tokens (360px)
- `.chatbot-toggle` - Chatbot launcher
- `.copy-btn` - Copy contract address
- `.chart-tab` - Chart switcher tabs
- `.quick-reply-btn` - Chatbot quick replies
- `.social-link` - Footer social icons

---

## Total Count: 30+ buttons/links

**Last Updated:** October 19, 2025

