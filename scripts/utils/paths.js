// scripts/utils/paths.js
import fs from "node:fs";
import path from "node:path";

const ROOT = process.env.PERSIST_DIR || process.cwd();

function ensure(p) { 
  fs.mkdirSync(p, { recursive: true }); 
  return p; 
}

const AUDIT_DIR = ensure(path.join(ROOT, "audit"));
const LOGS_DIR = ensure(path.join(ROOT, "logs"));
const DATA_DIR = ensure(path.join(ROOT, "data"));

// Export path helpers
export const auditPath = (...p) => path.join(AUDIT_DIR, ...p);
export const logsPath = (...p) => path.join(LOGS_DIR, ...p);
export const dataPath = (...p) => path.join(DATA_DIR, ...p);

// Export directories for reference
export { AUDIT_DIR, LOGS_DIR, DATA_DIR, ROOT };

// Helper to ensure directory exists before writing
export const ensureDir = (filePath) => {
  const dir = path.dirname(filePath);
  ensure(dir);
  return filePath;
};

// Helper to write file with directory creation
export const writeFileSync = (filePath, data, options = {}) => {
  const fullPath = ensureDir(filePath);
  fs.writeFileSync(fullPath, data, options);
  return fullPath;
};

// Helper to append to file with directory creation
export const appendFileSync = (filePath, data, options = {}) => {
  const fullPath = ensureDir(filePath);
  fs.appendFileSync(fullPath, data, options);
  return fullPath;
};

console.log(`[PATHS] ROOT: ${ROOT}`);
console.log(`[PATHS] AUDIT_DIR: ${AUDIT_DIR}`);
console.log(`[PATHS] LOGS_DIR: ${LOGS_DIR}`);
console.log(`[PATHS] DATA_DIR: ${DATA_DIR}`);
