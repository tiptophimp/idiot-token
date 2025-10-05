const fs = require('fs');
const path = require('path');
const { MerkleTree } = require('merkletreejs');
const keccak256 = require('keccak256');

// Configuration
const CONFIG = {
  token: '0x03a520b32C04BF3bEEf7BEb72E919cf822Ed34f1',
  chainId: 8453,
  snapshot: '2025-10-15T20:00:00Z',
  total: '250000000',
  decimals: 18
};

// Pool allocations
const POOLS = {
  early_buyers: { percentage: 40, tokens: '100000000' },
  liquidity_providers: { percentage: 15, tokens: '37500000' },
  community: { percentage: 25, tokens: '62500000' },
  meme_bounties: { percentage: 10, tokens: '25000000' },
  partners: { percentage: 10, tokens: '25000000' }
};

function parseCSV(csvPath) {
  const csv = fs.readFileSync(csvPath, 'utf8');
  const lines = csv.trim().split('\n');
  const headers = lines[0].split(',');
  
  return lines.slice(1).map(line => {
    const values = line.split(',');
    const row = {};
    headers.forEach((header, index) => {
      row[header.trim()] = values[index]?.trim() || '';
    });
    return row;
  });
}

function generateMerkleTree(claims) {
  const leaves = claims.map(claim => 
    keccak256(ethers.utils.solidityPack(['address', 'uint256'], [claim.address, claim.amount]))
  );
  
  const tree = new MerkleTree(leaves, keccak256, { sortPairs: true });
  const root = tree.getHexRoot();
  
  // Generate proofs for each claim
  const claimsWithProofs = claims.map((claim, index) => {
    const leaf = leaves[index];
    const proof = tree.getHexProof(leaf);
    
    return {
      address: claim.address,
      amount: claim.amount,
      proof: proof,
      pool: claim.pool
    };
  });
  
  return { root, claimsWithProofs };
}

function generateManifest(claims, merkleRoot) {
  const manifest = {
    name: "Idiocracy Airdrop #1",
    token: CONFIG.token,
    chainId: CONFIG.chainId,
    snapshot: CONFIG.snapshot,
    claimStart: "TBD",
    claimEnd: "TBD",
    merkleRoot: merkleRoot,
    total: CONFIG.total,
    decimals: CONFIG.decimals,
    pools: POOLS,
    claims: {},
    rules: {
      one_wallet_per_human: true,
      base_network_only: true,
      anti_sybil_screening: true,
      community_onchain_action_required: true,
      claim_window_days: 30,
      unclaimed_to_treasury: true,
      dispute_window_hours: 48
    },
    notes: "Generated from allowlist CSV. Amounts in whole tokens for UI display."
  };
  
  // Add claims to manifest
  claims.forEach(claim => {
    manifest.claims[claim.address.toLowerCase()] = {
      amount: claim.amount,
      proof: claim.proof,
      pool: claim.pool
    };
  });
  
  return manifest;
}

function main() {
  const csvPath = process.argv[2] || 'templates/allowlist-template.csv';
  
  if (!fs.existsSync(csvPath)) {
    console.error(`❌ CSV file not found: ${csvPath}`);
    console.log('Usage: node generate-merkle.js [path-to-csv]');
    process.exit(1);
  }
  
  console.log('🌳 Generating Merkle Tree...');
  
  // Parse CSV
  const csvData = parseCSV(csvPath);
  console.log(`📊 Loaded ${csvData.length} claims from CSV`);
  
  // Convert amounts to wei (18 decimals)
  const claims = csvData.map(row => ({
    address: row.address,
    amount: ethers.utils.parseUnits(row.amount, CONFIG.decimals).toString(),
    pool: row.pool
  }));
  
  // Generate Merkle tree
  const { root, claimsWithProofs } = generateMerkleTree(claims);
  console.log(`🔑 Merkle Root: ${root}`);
  
  // Generate manifest
  const manifest = generateManifest(claimsWithProofs, root);
  
  // Save files
  const outputDir = 'airdrop';
  if (!fs.existsSync(outputDir)) {
    fs.mkdirSync(outputDir, { recursive: true });
  }
  
  // Save JSON manifest
  const manifestPath = path.join(outputDir, 'idiocracy-1.json');
  fs.writeFileSync(manifestPath, JSON.stringify(manifest, null, 2));
  console.log(`💾 Saved manifest: ${manifestPath}`);
  
  // Save claims with proofs
  const claimsPath = path.join(outputDir, 'claims-with-proofs.json');
  fs.writeFileSync(claimsPath, JSON.stringify(claimsWithProofs, null, 2));
  console.log(`💾 Saved claims: ${claimsPath}`);
  
  // Generate deployment script
  const deployScript = `// Deploy MerkleDistributor
const MerkleDistributor = await ethers.getContractFactory("MerkleDistributor");
const distributor = await MerkleDistributor.deploy("${CONFIG.token}");
await distributor.deployed();

console.log("MerkleDistributor deployed to:", distributor.address);

// Set merkle root
await distributor.setMerkleRoot("${root}");
console.log("Merkle root set");

// Set claim window (example: 7 days from now)
const startTime = Math.floor(Date.now() / 1000) + 3600; // 1 hour from now
const endTime = startTime + (7 * 24 * 3600); // 7 days
await distributor.setClaimWindow(startTime, endTime);
console.log("Claim window set:", new Date(startTime * 1000), "to", new Date(endTime * 1000));

// Transfer tokens to distributor
const token = await ethers.getContractAt("IERC20", "${CONFIG.token}");
const totalAmount = ethers.utils.parseUnits("${CONFIG.total}", ${CONFIG.decimals});
await token.transfer(distributor.address, totalAmount);
console.log("Tokens transferred to distributor");
`;
  
  const deployPath = path.join(outputDir, 'deploy.js');
  fs.writeFileSync(deployPath, deployScript);
  console.log(`💾 Saved deployment script: ${deployPath}`);
  
  console.log('\n✅ Merkle tree generation complete!');
  console.log('\n📋 Next steps:');
  console.log('1. Deploy MerkleDistributor contract');
  console.log('2. Transfer 250M IDIOT tokens to distributor');
  console.log('3. Set merkle root and claim window');
  console.log('4. Update airdrop portal with contract address');
  console.log('5. Launch claim portal!');
}

// Add ethers for wei conversion (you'll need to install: npm install ethers)
const ethers = require('ethers');

main();
