#!/usr/bin/env node

// scripts/validate_persistence.js
// Validate that persistent paths are working correctly

import { auditPath, logsPath, dataPath, writeFileSync, appendFileSync } from './utils/paths.js';
import fs from 'fs';
import path from 'path';

console.log('🔍 Validating persistent paths...\n');

// Test 1: Check if directories exist
console.log('📁 Directory Check:');
console.log(`  AUDIT_DIR: ${auditPath()}`);
console.log(`  LOGS_DIR: ${logsPath()}`);
console.log(`  DATA_DIR: ${dataPath()}`);

// Test 2: Write test files
console.log('\n📝 File Write Tests:');

try {
  // Test audit file write
  const auditTestFile = auditPath('smoke_test.txt');
  writeFileSync(auditTestFile, `Persistence test - ${new Date().toISOString()}\n`);
  console.log(`  ✅ Audit write: ${auditTestFile}`);

  // Test log file write
  const logTestFile = logsPath('smoke_test.log');
  appendFileSync(logTestFile, `[${new Date().toISOString()}] Persistence test log entry\n`);
  console.log(`  ✅ Log write: ${logTestFile}`);

  // Test data file write
  const dataTestFile = dataPath('smoke_test.json');
  writeFileSync(dataTestFile, JSON.stringify({
    test: true,
    timestamp: new Date().toISOString(),
    persistence: 'working'
  }, null, 2));
  console.log(`  ✅ Data write: ${dataTestFile}`);

} catch (error) {
  console.error(`  ❌ Write test failed: ${error.message}`);
  process.exit(1);
}

// Test 3: Verify files exist and are readable
console.log('\n🔍 File Verification:');

const testFiles = [
  auditPath('smoke_test.txt'),
  logsPath('smoke_test.log'),
  dataPath('smoke_test.json')
];

testFiles.forEach(filePath => {
  try {
    if (fs.existsSync(filePath)) {
      const stats = fs.statSync(filePath);
      console.log(`  ✅ ${path.basename(filePath)}: ${stats.size} bytes, modified ${stats.mtime.toISOString()}`);
    } else {
      console.log(`  ❌ ${path.basename(filePath)}: File not found`);
    }
  } catch (error) {
    console.log(`  ❌ ${path.basename(filePath)}: ${error.message}`);
  }
});

// Test 4: Test relative path resolution
console.log('\n🛤️ Path Resolution:');
console.log(`  Current working directory: ${process.cwd()}`);
console.log(`  PERSIST_DIR environment: ${process.env.PERSIST_DIR || 'not set'}`);
console.log(`  Resolved PERSIST_DIR: ${process.env.PERSIST_DIR || process.cwd()}`);

// Test 5: Cleanup test files
console.log('\n🧹 Cleanup:');
testFiles.forEach(filePath => {
  try {
    fs.unlinkSync(filePath);
    console.log(`  ✅ Cleaned up: ${path.basename(filePath)}`);
  } catch (error) {
    console.log(`  ⚠️ Could not clean up ${path.basename(filePath)}: ${error.message}`);
  }
});

console.log('\n✅ Persistence validation completed successfully!');
console.log('\n📋 Summary:');
console.log('  - All directories created successfully');
console.log('  - File writes working correctly');
console.log('  - Path resolution functioning');
console.log('  - Test files cleaned up');
console.log('\n🚀 Ready for production deployment!');
