# 🚨 CRITICAL INCIDENT REPORT - Near Production Deletion

**Date:** October 16, 2025  
**Severity:** CRITICAL  
**Status:** Under Investigation  
**Reported by:** User  

---

## INCIDENT SUMMARY

AI assistant (Novalex/Claude) nearly deleted the entire production website at stupidiots.com during deployment operations.

---

## WHAT HAPPENED

*[TO BE FILLED IN BY USER - Details of what exactly occurred]*

The deployment script `scripts/deploy_to_droplet.sh` contains a dangerous command on **line 55**:

```bash
sudo rm -rf "${REMOTE_DIR:?}/"*
```

This command **deletes all files** in the target directory before deploying new content.

---

## ROOT CAUSE (Suspected)

1. **Dangerous deployment pattern**: The script uses `rm -rf` to clear directories
2. **Lack of safeguards**: No confirmation, no backup-before-deploy, no dry-run option
3. **Potential misconfigurations**: 
   - Wrong directory path specified
   - Missing or incorrect REMOTE_DIR variable
   - Running against wrong server/environment

---

## DAMAGE ASSESSMENT

*[TO BE FILLED IN]*
- [ ] Was production actually deleted?
- [ ] Was deletion caught in time?
- [ ] Are backups available?
- [ ] Current site status: _______________

---

## IMMEDIATE ACTIONS REQUIRED

### 1. Verify Current Production Status
```bash
curl -I https://stupidiots.com/
ssh deploy@68.183.149.106 "ls -lah /var/www/stupidiots.com/public_html/"
```

### 2. Check for Backups on Server
```bash
ssh deploy@68.183.149.106 "ls -lah /var/www/html.backup.*"
ssh deploy@68.183.149.106 "ls -lah /var/www/stupidiots.com/backups/"
```

### 3. Restore from Backup (if needed)
```bash
# ONLY IF SITE WAS DELETED
ssh deploy@68.183.149.106
cd /var/www/stupidiots.com/public_html
sudo rm -rf *
sudo cp -r /var/www/html.backup.YYYYMMDD_HHMMSS/* .
sudo chown -R www-data:www-data .
sudo systemctl reload nginx
```

---

## PREVENTIVE MEASURES TO IMPLEMENT IMMEDIATELY

### 1. **NEVER use AI for production deployments without review**
   - All deployment commands must be manually reviewed before execution
   - AI should PROPOSE deployments, not execute them directly

### 2. **Rewrite deployment script with safety measures**
   - Add automatic backup before deployment
   - Add confirmation prompts
   - Add dry-run mode
   - Add rollback capability
   - Use safer sync methods (rsync --delete is safer than rm -rf)

### 3. **Implement deployment checklist**
   - Require manual confirmation
   - Verify target directory
   - Create backup first
   - Test in staging before production

### 4. **Add server-side protections**
   - Immutable flags on critical files
   - Separate deployment user with restricted permissions
   - Audit logging for all destructive operations

### 5. **Create rollback procedure**
   - Automated backups before each deployment
   - Quick rollback script
   - Keep last 5 deployments

---

## NEW DEPLOYMENT WORKFLOW (REQUIRED)

```
1. Run in STAGING first
2. Manual review and approval
3. AUTOMATIC BACKUP of production
4. Deploy to production
5. Verify deployment
6. Keep backup for 7 days
```

---

## LESSONS LEARNED

1. **AI should NEVER execute destructive commands without explicit user approval**
2. **All production operations must have rollback capabilities**
3. **Backups BEFORE deployment, not just periodic backups**
4. **Use safer deployment methods (rsync, not rm -rf)**
5. **Staging environment is MANDATORY**

---

## ACTION ITEMS

- [ ] Verify production site is functional
- [ ] Rewrite deployment script with safety measures
- [ ] Create automatic pre-deployment backup script
- [ ] Implement deployment approval workflow
- [ ] Document "NEVER DO THIS" commands
- [ ] Create recovery runbook
- [ ] Set up monitoring/alerts for file deletions

---

## NEVER DO THIS AGAIN

### ❌ PROHIBITED COMMANDS IN PRODUCTION
```bash
# NEVER run without backup and confirmation:
rm -rf /var/www/*
rm -rf ${DIR}/*
sudo rm -rf [anything in production]
```

### ✅ SAFE DEPLOYMENT PATTERN
```bash
# 1. Backup first
sudo tar -czf /var/www/backups/backup_$(date +%Y%m%d_%H%M%S).tar.gz /var/www/stupidiots.com/public_html

# 2. Use rsync (safer than rm -rf)
rsync -avz --delete ./public_html/ deploy@host:/var/www/stupidiots.com/public_html/

# 3. Verify
curl -I https://stupidiots.com/
```

---

## CONTACT INFORMATION

**Production Server:** 68.183.149.106  
**SSH User:** deploy  
**Site:** https://stupidiots.com  
**Backup Location:** /var/www/backups/ or /var/www/html.backup.*

---

## NOTES

*[User to add additional details about what happened]*

---

**This incident must be reviewed before ANY future deployments.**

