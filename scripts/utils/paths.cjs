// scripts/utils/paths.js
const fs = require("node:fs");
const path = require("node:path");

const ROOT = process.env.PERSIST_DIR || process.cwd();

function ensure(p) { 
  fs.mkdirSync(p, { recursive: true }); 
  return p; 
}

const AUDIT_DIR = ensure(path.join(ROOT, "audit"));
const LOG_DIR = ensure(path.join(ROOT, "logs"));
const DATA_DIR = ensure(path.join(ROOT, "data"));

module.exports = {
  auditPath: (...p) => path.join(AUDIT_DIR, ...p),
  logPath: (...p) => path.join(LOG_DIR, ...p),
  dataPath: (...p) => path.join(DATA_DIR, ...p),
  ROOT,
  AUDIT_DIR,
  LOG_DIR,
  DATA_DIR
};
