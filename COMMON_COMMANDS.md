# 💻 Common Commands for This System

**Operating System:** Windows 10  
**Shell:** PowerShell (primary) / Git Bash (secondary)  
**Last Updated:** 2025-10-16

---

## ⚠️ CRITICAL: Command Translation

### ❌ NEVER USE THESE (Linux/Mac only):
```bash
bash script.sh          # Won't work - bash not in PATH
chmod +x file           # Won't work - Windows doesn't use chmod
ls -la                  # Won't work in PowerShell
rm -rf directory        # Dangerous and won't work
cp file1 file2          # Won't work in PowerShell
cat file.txt            # Won't work in PowerShell
grep pattern file       # Won't work in PowerShell
```

### ✅ USE THESE INSTEAD (Windows PowerShell):

| Task | ❌ DON'T Use | ✅ DO Use (PowerShell) |
|------|-------------|----------------------|
| List files | `ls -la` | `dir` or `Get-ChildItem` or `ls` (alias) |
| Copy file | `cp file1 file2` | `Copy-Item file1 file2` |
| Move file | `mv file1 file2` | `Move-Item file1 file2` |
| Delete file | `rm file` | `Remove-Item file` or `del file` |
| View file | `cat file.txt` | `Get-Content file.txt` or `type file.txt` |
| Current dir | `pwd` | `pwd` (works) or `Get-Location` |
| Change dir | `cd path` | `cd path` (works) |
| Search text | `grep pattern file` | `Select-String pattern file` |
| Run script | `bash script.sh` | `powershell script.ps1` or `.\script.bat` |
| Make executable | `chmod +x file` | Not needed on Windows |
| Environment vars | `export VAR=value` | `$env:VAR = "value"` |

---

## 🎯 Correct Commands for Common Tasks

### File Operations
```powershell
# List all files including hidden
Get-ChildItem -Force

# Copy file
Copy-Item source.txt destination.txt

# Copy directory recursively
Copy-Item -Recurse source-dir destination-dir

# Delete file
Remove-Item file.txt

# Delete directory (careful!)
Remove-Item -Recurse directory-name
```

### Git Operations (These work fine)
```bash
git status
git add .
git commit -m "message"
git log --oneline
git diff
```

### Running Scripts
```powershell
# PowerShell script
powershell -ExecutionPolicy Bypass -File script.ps1

# Batch file
.\script.bat
# or just
script.bat

# If Git Bash is available (check first)
# Can use bash commands through Git Bash
```

### Production Checks
```powershell
# Our custom production checker
powershell -ExecutionPolicy Bypass -File scripts/check-production.ps1

# Or double-click
check-production.bat

# Manual web request
Invoke-WebRequest -Uri "https://stupidiots.com" -Method Head
```

### Opening Files/Folders
```powershell
# Open file in default editor
notepad file.txt

# Open folder in Explorer
explorer .
explorer C:\idiot-project

# Open file in Cursor/VS Code (if in PATH)
code file.txt
```

---

## 🔍 How to Check What's Available

### Check if a command exists:
```powershell
# Check for command
Get-Command bash
Get-Command git
Get-Command powershell

# If it exists, shows path
# If not, shows error
```

### Check environment:
```powershell
# Show OS version
$PSVersionTable

# Show current shell
$PSVersionTable.PSVersion

# Show user
$env:USERNAME

# Show home directory
$env:USERPROFILE
```

---

## 📋 Quick Reference Card

**When you need to:**

| Action | Command |
|--------|---------|
| List directory | `dir` or `ls` |
| Show file contents | `Get-Content file.txt` or `type file.txt` |
| Find text in file | `Select-String "pattern" file.txt` |
| Copy file | `Copy-Item source dest` |
| Run PowerShell script | `powershell -ExecutionPolicy Bypass -File script.ps1` |
| Run batch file | `.\script.bat` |
| Open Explorer | `explorer .` |
| Check production | `powershell -ExecutionPolicy Bypass -File scripts/check-production.ps1` |
| Git commands | Same as Linux (git works everywhere) |

---

## ⚠️ Special Notes for This Project

### Path Separators
- Windows uses backslash: `C:\idiot-project\file.txt`
- But forward slash usually works too: `C:/idiot-project/file.txt`
- Git uses forward slash: `.git/config`
- **Safest:** Use forward slash `/` - works in most contexts

### Script Files
- **Do NOT create** `.sh` files (won't run)
- **Create** `.ps1` (PowerShell) or `.bat` (batch) files
- **Existing** `.sh` files in `deploy/scripts/` are for the SERVER (Linux), not local use

### SSH / Server Access
- Server (68.183.149.106) is Linux
- Use PowerShell SSH client or PuTTY
- Syntax on server will be Linux commands

---

## 🚨 Common Mistakes to Avoid

### ❌ Wrong:
```bash
bash deploy/scripts/deploy.sh        # bash not in PATH
chmod +x file.sh                     # chmod doesn't exist
ls -la                               # -la flags don't work in PowerShell
rm -rf directory                     # rm not available
cat file.txt | grep pattern          # neither command works
```

### ✅ Right:
```powershell
# Don't run .sh files locally - they're for the server
powershell -ExecutionPolicy Bypass -File script.ps1
Get-ChildItem -Force                 # Instead of ls -la
Remove-Item -Recurse directory       # Instead of rm -rf (but be careful!)
Get-Content file.txt | Select-String "pattern"  # Instead of cat | grep
```

---

## 💡 Pro Tips

1. **Always check SESSION_HANDOFF.md** first - it has OS info
2. **When in doubt**, use full PowerShell cmdlet names (more reliable)
3. **Test commands** before putting them in scripts
4. **Git commands** work the same on all OS
5. **For server commands**, you'll use Linux syntax (via SSH)
6. **Keep this file updated** if you discover new command issues

---

**Last Updated:** 2025-10-16  
**System:** Windows 10 Build 26100  
**Shell:** PowerShell with Git Bash available

