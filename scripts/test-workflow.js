// scripts/test-workflow.js - Test GitHub workflow configuration
import fs from "fs";
import yaml from "js-yaml";

console.log("🧪 Testing GitHub Workflow Configuration");
console.log("========================================\n");

// Test workflow file exists
function testWorkflowFile() {
  console.log("📄 Testing workflow file...");
  
  const workflowPath = ".github/workflows/verify_audit.yml";
  
  if (!fs.existsSync(workflowPath)) {
    console.log("❌ Workflow file not found:", workflowPath);
    return false;
  }
  
  try {
    const workflowContent = fs.readFileSync(workflowPath, 'utf8');
    const workflow = yaml.load(workflowContent);
    
    console.log("✅ Workflow file exists");
    console.log(`   Name: ${workflow.name}`);
    console.log(`   Triggers: ${Object.keys(workflow.on).join(', ')}`);
    console.log(`   Jobs: ${Object.keys(workflow.jobs).join(', ')}`);
    
    return true;
  } catch (error) {
    console.log("❌ Invalid YAML syntax:", error.message);
    return false;
  }
}

// Test required scripts exist
function testScripts() {
  console.log("\n📜 Testing required scripts...");
  
  const requiredScripts = [
    "scripts/verifyAuditNotify.js",
    "scripts/ci-setup.js", 
    "scripts/ipfsVerify.js",
    "scripts/healthCheck.js"
  ];
  
  let allExist = true;
  
  for (const script of requiredScripts) {
    if (fs.existsSync(script)) {
      console.log(`✅ ${script}`);
    } else {
      console.log(`❌ ${script} - Missing`);
      allExist = false;
    }
  }
  
  return allExist;
}

// Test environment template
function testEnvTemplate() {
  console.log("\n🔧 Testing environment template...");
  
  if (!fs.existsSync(".env.example")) {
    console.log("❌ .env.example not found");
    return false;
  }
  
  const envContent = fs.readFileSync(".env.example", 'utf8');
  const requiredVars = [
    "PRIVATE_KEY",
    "BASESCAN_API_KEY", 
    "DISCORD_WEBHOOK_URL",
    "SLACK_WEBHOOK_URL"
  ];
  
  let allPresent = true;
  
  for (const varName of requiredVars) {
    if (envContent.includes(varName)) {
      console.log(`✅ ${varName} - Present`);
    } else {
      console.log(`❌ ${varName} - Missing`);
      allPresent = false;
    }
  }
  
  return allPresent;
}

// Test package.json dependencies
function testDependencies() {
  console.log("\n📦 Testing package.json dependencies...");
  
  if (!fs.existsSync("package.json")) {
    console.log("❌ package.json not found");
    return false;
  }
  
  const packageJson = JSON.parse(fs.readFileSync("package.json", 'utf8'));
  const requiredDeps = [
    "hardhat",
    "@nomicfoundation/hardhat-verify",
    "dotenv",
    "ethers",
    "node-fetch",
    "ipfs-http-client"
  ];
  
  let allPresent = true;
  
  for (const dep of requiredDeps) {
    if (packageJson.dependencies?.[dep] || packageJson.devDependencies?.[dep]) {
      console.log(`✅ ${dep} - Present`);
    } else {
      console.log(`❌ ${dep} - Missing`);
      allPresent = false;
    }
  }
  
  return allPresent;
}

// Test audit directory
function testAuditDirectory() {
  console.log("\n📁 Testing audit directory...");
  
  if (!fs.existsSync("audit")) {
    console.log("⚠️  Audit directory not found - will be created by workflow");
    return true;
  }
  
  console.log("✅ Audit directory exists");
  return true;
}

// Main test function
async function main() {
  const tests = [
    { name: "Workflow File", fn: testWorkflowFile },
    { name: "Required Scripts", fn: testScripts },
    { name: "Environment Template", fn: testEnvTemplate },
    { name: "Dependencies", fn: testDependencies },
    { name: "Audit Directory", fn: testAuditDirectory }
  ];
  
  const results = {};
  
  for (const test of tests) {
    try {
      results[test.name] = await test.fn();
    } catch (error) {
      console.error(`❌ ${test.name} failed:`, error.message);
      results[test.name] = false;
    }
  }
  
  // Summary
  console.log("\n📊 Test Results Summary");
  console.log("=======================");
  
  const passed = Object.values(results).filter(Boolean).length;
  const total = Object.keys(results).length;
  
  for (const [name, passed] of Object.entries(results)) {
    console.log(`${passed ? '✅' : '❌'} ${name}: ${passed ? 'PASS' : 'FAIL'}`);
  }
  
  console.log(`\n🎯 Overall Status: ${passed}/${total} tests passed`);
  
  if (passed === total) {
    console.log("🎉 All tests passed! GitHub workflow is ready to deploy.");
    console.log("\n🚀 Next Steps:");
    console.log("1. Add GitHub secrets to your repository");
    console.log("2. Push to main branch to trigger workflow");
    console.log("3. Check Actions tab for workflow execution");
  } else {
    console.log("⚠️  Some tests failed. Review the output above.");
    process.exit(1);
  }
}

main().catch((error) => {
  console.error("❌ Test failed:", error);
  process.exit(1);
});
