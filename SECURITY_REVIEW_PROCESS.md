# 🔒 SECURITY REVIEW PROCESS - MANDATORY

## ⚠️ **CRITICAL: NO COMMITS WITHOUT SECURITY REVIEW**

**Effective immediately:** Every commit must pass security review before being pushed to production.

---

## 🛡️ **PRE-COMMIT SECURITY CHECKLIST**

### **Step 1: File Type Review**
```bash
# Check for sensitive file types
find . -name "*.md" -o -name "*.ps1" -o -name "*.csv" -o -name "*.xlsx" -o -name "*.txt" -o -name "*.log" -o -name "*.pem" -o -name "*.key" -o -name "*.env" -o -name "*.config"
```
**❌ If ANY found:** Remove or move to secure/ directory

### **Step 2: Content Scan**
```bash
# Search for sensitive content
grep -r "password\|secret\|key\|private\|wallet\|seed\|mnemonic\|token\|api" . --exclude-dir=.git --exclude-dir=secure
```
**❌ If sensitive data found:** Remove or sanitize

### **Step 3: Staging Deployment**
```powershell
# ALWAYS test in staging first
.\deploy-staging.ps1
```
**✅ Verify:** https://stupidiots.com/staging

### **Step 4: Security Verification**
```bash
# Check staging for sensitive files
ssh root@68.183.149.106 "find /var/www/staging -name '*.md' -o -name '*.ps1' -o -name '*.csv' -o -name '*.xlsx' -o -name '*.txt' -o -name '*.log' -o -name '*.pem' -o -name '*.key' -o -name '*.env' -o -name '*.config' | wc -l"
```
**✅ Must return:** 0

### **Step 5: Production Promotion**
```powershell
# Only after staging passes security review
.\promote-to-production.ps1
```

---

## 🚨 **FORBIDDEN FILE TYPES**

### **❌ NEVER COMMIT THESE:**
- `.md` files (internal documentation)
- `.ps1` files (PowerShell scripts)
- `.csv` files (spreadsheets)
- `.xlsx` files (Excel files)
- `.txt` files (internal notes)
- `.log` files (logs)
- `.pem` files (SSH keys)
- `.key` files (private keys)
- `.env` files (environment variables)
- `.config` files (configurations)
- `*password*` files
- `*secret*` files
- `*private*` files

### **✅ ONLY COMMIT THESE:**
- `.html` files (website pages)
- `.css` files (stylesheets)
- `.js` files (JavaScript)
- `.png`, `.jpg`, `.gif` files (images)
- `.ico` files (favicons)
- `.svg` files (vector graphics)

---

## 🔍 **SECURITY SCAN COMMANDS**

### **Local Pre-Commit Scan:**
```bash
# 1. Check file types
echo "=== CHECKING FILE TYPES ==="
find . -name "*.md" -o -name "*.ps1" -o -name "*.csv" -o -name "*.xlsx" -o -name "*.txt" -o -name "*.log" -o -name "*.pem" -o -name "*.key" -o -name "*.env" -o -name "*.config" | grep -v ".git" | grep -v "secure"

# 2. Check content
echo "=== CHECKING CONTENT ==="
grep -r "password\|secret\|key\|private\|wallet\|seed\|mnemonic\|token\|api" . --exclude-dir=.git --exclude-dir=secure --exclude="*.html" --exclude="*.css" --exclude="*.js"

# 3. Count files
echo "=== FILE COUNT ==="
find . -type f | grep -E '\.(html|css|js|png|jpg|gif|ico|svg)$' | wc -l
```

### **Staging Security Verification:**
```bash
# After staging deployment
ssh root@68.183.149.106 "find /var/www/staging -name '*.md' -o -name '*.ps1' -o -name '*.csv' -o -name '*.xlsx' -o -name '*.txt' -o -name '*.log' -o -name '*.pem' -o -name '*.key' -o -name '*.env' -o -name '*.config' | wc -l"
```

### **Production Security Verification:**
```bash
# After production promotion
ssh root@68.183.149.106 "find /var/www/html -name '*.md' -o -name '*.ps1' -o -name '*.csv' -o -name '*.xlsx' -o -name '*.txt' -o -name '*.log' -o -name '*.pem' -o -name '*.key' -o -name '*.env' -o -name '*.config' | wc -l"
```

---

## 📋 **MANDATORY WORKFLOW**

### **Before ANY commit:**
1. **Run security scan** (commands above)
2. **Fix any issues** found
3. **Deploy to staging** only
4. **Verify staging** is clean
5. **Test functionality** in staging
6. **Promote to production** only after verification

### **Emergency commits:**
1. **Document the emergency**
2. **Run security scan** anyway
3. **Deploy to staging** first (if possible)
4. **Use production deploy** only if staging is down
5. **Create incident report**

---

## 🚫 **WHAT HAPPENED BEFORE**

### **❌ Previous Issues:**
- Internal `.md` files exposed
- PowerShell scripts public
- Excel spreadsheets accessible
- Development files visible
- Configuration files exposed
- SSH key references public

### **✅ Now Fixed:**
- Only website files public
- All sensitive files secured
- Staging-first workflow
- Security review mandatory

---

## 🎯 **SECURITY GOALS**

### **Primary:**
- ✅ Zero sensitive files exposed
- ✅ Only website content public
- ✅ Professional appearance
- ✅ No internal data leakage

### **Secondary:**
- ✅ Clean git history
- ✅ Proper file organization
- ✅ Secure development practices
- ✅ Incident prevention

---

## 📞 **SECURITY CONTACTS**

**If security issues found:**
1. **STOP** all deployment
2. **Document** the issue
3. **Fix** immediately
4. **Verify** fix in staging
5. **Test** thoroughly
6. **Deploy** only after verification

---

## 🔒 **SECURITY COMMITMENT**

**I commit to:**
- ✅ Never commit without security review
- ✅ Always use staging first
- ✅ Verify clean deployments
- ✅ Protect sensitive data
- ✅ Maintain professional standards

---

**Remember: Security first, deployment second! 🔒➡️🚀**
