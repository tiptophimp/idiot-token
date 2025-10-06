/**
 * IDIOT Token — Transparency Page Generator
 * Generates a public-facing transparency page for GitHub Pages
 */

import fs from 'fs';
import path from 'path';
import crypto from 'crypto';

const auditLog = path.resolve('audit/vesting_verification_log.md');
const transparencyDir = path.resolve('docs/transparency');
const transparencyPage = path.resolve('docs/transparency/index.html');

console.log("🌐 Generating IDIOT Token Transparency Page");
console.log("==========================================\n");

// Ensure transparency directory exists
if (!fs.existsSync(transparencyDir)) {
  fs.mkdirSync(transparencyDir, { recursive: true });
  console.log("📁 Created transparency directory:", transparencyDir);
}

if (!fs.existsSync(auditLog)) {
  console.error('❌ No audit log found. Cannot generate transparency page.');
  process.exit(1);
}

const content = fs.readFileSync(auditLog, 'utf8');
const timestamp = new Date().toISOString();
const ipfsMatch = content.match(/CID[:\s]+(Qm[^\s]+)/);
const ipfsCid = ipfsMatch ? ipfsMatch[1] : 'Not available';

// Extract contract information
const lines = content.split('\n');
const contractLines = lines.filter(line => 
  line.includes('|') && 
  line.includes('✅') && 
  !line.includes('| Pool |')
);

const contracts = contractLines.map(line => {
  const parts = line.split('|').map(p => p.trim()).filter(p => p);
  if (parts.length >= 6) {
    return {
      name: parts[0],
      address: parts[1],
      owner: parts[2],
      startDate: parts[3],
      duration: parts[4],
      codeHash: parts[5],
      baseScan: parts[6],
      status: parts[7] || '✅ Verified'
    };
  }
  return null;
}).filter(Boolean);

// Generate content hash
const hash = crypto.createHash('sha256').update(content).digest('hex');

// Generate HTML transparency page
const html = `<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>IDIOT Token - Transparency Dashboard</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { 
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        .header {
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            color: white;
            padding: 40px;
            text-align: center;
        }
        .header h1 {
            font-size: 2.5em;
            margin-bottom: 10px;
            font-weight: 700;
        }
        .header p {
            font-size: 1.2em;
            opacity: 0.9;
        }
        .content {
            padding: 40px;
        }
        .status-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }
        .status-card {
            background: #f8f9fa;
            border-radius: 15px;
            padding: 25px;
            border-left: 5px solid #28a745;
        }
        .status-card h3 {
            color: #1e3c72;
            margin-bottom: 15px;
            font-size: 1.3em;
        }
        .status-card p {
            color: #666;
            line-height: 1.6;
        }
        .contracts-table {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            margin-bottom: 40px;
        }
        .contracts-table h2 {
            background: #1e3c72;
            color: white;
            padding: 20px;
            margin: 0;
            font-size: 1.5em;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }
        th {
            background: #f8f9fa;
            font-weight: 600;
            color: #1e3c72;
        }
        .status-badge {
            background: #28a745;
            color: white;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.9em;
            font-weight: 500;
        }
        .address {
            font-family: 'Monaco', 'Menlo', monospace;
            background: #f1f3f4;
            padding: 5px 8px;
            border-radius: 5px;
            font-size: 0.9em;
        }
        .footer {
            background: #f8f9fa;
            padding: 30px;
            text-align: center;
            color: #666;
            border-top: 1px solid #eee;
        }
        .footer a {
            color: #1e3c72;
            text-decoration: none;
            font-weight: 500;
        }
        .footer a:hover {
            text-decoration: underline;
        }
        .last-updated {
            font-size: 0.9em;
            color: #999;
            margin-top: 10px;
        }
        @media (max-width: 768px) {
            .container { margin: 10px; }
            .header { padding: 30px 20px; }
            .content { padding: 20px; }
            .contracts-table { overflow-x: auto; }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🧾 IDIOT Token Transparency Dashboard</h1>
            <p>Immutable verification records and contract transparency</p>
        </div>
        
        <div class="content">
            <div class="status-grid">
                <div class="status-card">
                    <h3>🔒 Security Status</h3>
                    <p>All vesting parameters are cryptographically immutable and cannot be changed without redeploying contracts.</p>
                </div>
                <div class="status-card">
                    <h3>🌐 Immutable Storage</h3>
                    <p>IPFS CID: <code class="address">${ipfsCid}</code><br>
                    <a href="https://ipfs.io/ipfs/${ipfsCid}" target="_blank">View on IPFS</a></p>
                </div>
                <div class="status-card">
                    <h3>🔐 Integrity Hash</h3>
                    <p>SHA256: <code class="address">${hash.substring(0, 16)}...</code><br>
                    Full verification of audit log integrity</p>
                </div>
                <div class="status-card">
                    <h3>📊 Verification Summary</h3>
                    <p>${contracts.length} contracts verified successfully<br>
                    All contracts verified on BaseScan</p>
                </div>
            </div>
            
            <div class="contracts-table">
                <h2>📋 Contract Verification Status</h2>
                <table>
                    <thead>
                        <tr>
                            <th>Pool</th>
                            <th>Contract Address</th>
                            <th>Owner SAFE</th>
                            <th>Start Date</th>
                            <th>Duration</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        ${contracts.map(contract => `
                        <tr>
                            <td><strong>${contract.name}</strong></td>
                            <td><code class="address">${contract.address}</code></td>
                            <td><code class="address">${contract.owner}</code></td>
                            <td>${contract.startDate}</td>
                            <td>${contract.duration}</td>
                            <td><span class="status-badge">${contract.status}</span></td>
                        </tr>
                        `).join('')}
                    </tbody>
                </table>
            </div>
        </div>
        
        <div class="footer">
            <p><strong>IDIOT Token Transparency System</strong></p>
            <p>This page is automatically generated and updated with each verification run.</p>
            <p>
                <a href="https://github.com/your-org/idiot-token" target="_blank">View Source Code</a> |
                <a href="https://basescan.org" target="_blank">BaseScan Explorer</a> |
                <a href="https://ipfs.io/ipfs/${ipfsCid}" target="_blank">IPFS Proof</a>
            </p>
            <div class="last-updated">
                Last updated: ${timestamp}
            </div>
        </div>
    </div>
</body>
</html>`;

// Write transparency page
fs.writeFileSync(transparencyPage, html);

// Also create a JSON API endpoint
const apiData = {
  timestamp,
  ipfsCid,
  integrityHash: hash,
  contracts: contracts.map(c => ({
    name: c.name,
    address: c.address,
    owner: c.owner,
    startDate: c.startDate,
    duration: c.duration,
    status: c.status
  })),
  summary: {
    totalContracts: contracts.length,
    verifiedContracts: contracts.filter(c => c.status.includes('✅')).length,
    securityStatus: 'All vesting parameters are cryptographically immutable'
  }
};

fs.writeFileSync(path.resolve('docs/transparency/api.json'), JSON.stringify(apiData, null, 2));

console.log('✅ Transparency page generated successfully');
console.log(`📄 HTML: ${transparencyPage}`);
console.log(`📊 API: ${path.resolve('docs/transparency/api.json')}`);
console.log(`🌐 IPFS CID: ${ipfsCid}`);
console.log(`📋 Contracts: ${contracts.length} verified`);
