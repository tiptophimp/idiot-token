#!/usr/bin/env node

/**
 * Official Time Update Script
 * Updates config/official_time.json with current UTC timestamp
 */

const fs = require('fs');
const path = require('path');

const configDir = path.join(__dirname, '..', 'config');
const timeFile = path.join(configDir, 'official_time.json');

// Ensure config directory exists
if (!fs.existsSync(configDir)) {
  fs.mkdirSync(configDir, { recursive: true });
}

// Get current UTC time
const now = new Date();
const utcTime = now.toISOString();
const humanReadable = now.toUTCString();

// Create time object
const timeData = {
  lastVerifiedAt: utcTime,
  lastVerifiedHumanReadable: humanReadable,
  note: "Source: container system clock (UTC). Refresh with `node scripts/update_official_time.cjs`."
};

// Write to file
try {
  fs.writeFileSync(timeFile, JSON.stringify(timeData, null, 2) + '\n');
  console.log(`✅ Official time updated: ${humanReadable}`);
  console.log(`📁 Written to: ${timeFile}`);
} catch (error) {
  console.error('❌ Failed to update official time:', error.message);
  process.exit(1);
}
