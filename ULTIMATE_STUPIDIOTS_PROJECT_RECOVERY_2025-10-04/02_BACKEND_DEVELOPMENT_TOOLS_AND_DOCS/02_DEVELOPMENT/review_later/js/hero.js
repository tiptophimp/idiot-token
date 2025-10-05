// hero.js — rotating hero slogans
const slogans = [
  "Buy the dip, embrace the chaos 🚀",
  "Powered by Base, fueled by stupidity 🔥",
  "If you hold IDIOT, you're already winning 💎",
  "The meme coin for true degens 🧨",
  "Smarter than Doge? Nope. Funnier? Absolutely 🤡"
];

let index = 0;
const heroSlogan = document.getElementById("heroSlogan");

function rotateSlogan() {
  index = (index + 1) % slogans.length;
  heroSlogan.textContent = slogans[index];
}

// Rotate every 5 seconds
setInterval(rotateSlogan, 5000);
