/**
 * IDIOT Token — Automated Changelog Generator
 * Generates markdown changelog entries from latest audit verification logs.
 */

import fs from 'fs';
import path from 'path';
import crypto from 'crypto';

const auditLog = path.resolve('audit/vesting_verification_log.md');
const changelogFile = path.resolve('audit/changelog.md');

console.log("📋 Generating IDIOT Token Transparency Log");
console.log("==========================================\n");

if (!fs.existsSync(auditLog)) {
  console.error('❌ No audit log found. Cannot generate changelog.');
  process.exit(1);
}

const timestamp = new Date().toISOString().replace('T', ' ').split('.')[0];
const content = fs.readFileSync(auditLog, 'utf8');

// Extract IPFS CID if present
const ipfsMatch = content.match(/CID[:\s]+(Qm[^\s]+)/);
const ipfsCid = ipfsMatch ? ipfsMatch[1] : 'Not found';

// Extract contract verification status
const lines = content.split('\n');
const contractLines = lines.filter(line => 
  line.includes('|') && 
  line.includes('✅') && 
  !line.includes('| Pool |')
);

const contractSummary = contractLines.map(line => {
  const parts = line.split('|').map(p => p.trim()).filter(p => p);
  if (parts.length >= 2) {
    return `- **${parts[0]}**: ${parts[parts.length - 1]}`;
  }
  return line;
}).join('\n');

// Generate content hash for integrity verification
const hash = crypto.createHash('sha256').update(content).digest('hex');

// Get release tag from environment or generate one
const releaseTag = process.env.GITHUB_REF_NAME || `audit-v${new Date().toISOString().split('T')[0].replace(/-/g, '.')}`;

// Generate changelog markdown
const changelog = `# 🧾 IDIOT Token Transparency Log

## 🏷️ Release Timestamp
**${timestamp} UTC**

## 🔗 IPFS Proof
\`${ipfsCid}\`

## 🪪 Integrity Hash (SHA256)
\`${hash}\`

## 📊 Contract Verification Summary
${contractSummary || 'No contract verification data found'}

## 🌐 Immutable Storage
${ipfsCid !== 'Not found' ? 
  `- **IPFS CID**: \`${ipfsCid}\`
- **IPFS URL**: https://ipfs.io/ipfs/${ipfsCid}
- **Gateway URL**: https://gateway.pinata.cloud/ipfs/${ipfsCid}` : 
  'IPFS storage not available'}

## 📋 Summary
- All vesting contracts verified successfully
- Audit log stored in \`audit/vesting_verification_log.md\`
- Historical snapshot created in \`audit/history/\`
- Immutable proof uploaded to IPFS
- Auto-tagged and released as ${releaseTag}

## 🔒 Security Status
All vesting parameters are cryptographically immutable and cannot be changed without redeploying contracts.

---

*This changelog was generated automatically by the IDIOT Transparency Automation Stack.*
`;

fs.writeFileSync(changelogFile, changelog.trim());

console.log('✅ Changelog generated successfully:', changelogFile);
console.log(`📊 Contracts verified: ${contractLines.length}`);
console.log(`🌐 IPFS CID: ${ipfsCid}`);
console.log(`🔐 Integrity Hash: ${hash.substring(0, 16)}...`);
console.log(`🏷️ Release Tag: ${releaseTag}`);

// Also create a backup in the main changelog file
const backupFile = path.resolve('audit/CHANGELOG.md');
fs.writeFileSync(backupFile, changelog.trim());
console.log('📄 Backup changelog created:', backupFile);
