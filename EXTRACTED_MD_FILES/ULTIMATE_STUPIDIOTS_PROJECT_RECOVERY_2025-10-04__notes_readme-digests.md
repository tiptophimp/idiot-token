# README Digests - Stupidiots Project

*Generated: 2025-01-01*
*Branch: staging-local*

## Project Structure Overview

### 01_LIVE_SITE/
- **Purpose:** Production-ready files for stupidiots.com currently live on server
- **Contents:** 
  - main_site/ - Main website files ready for upload
  - main_site_FIXED.zip - Fixed version of main site
  - main_site_IMAGES_UPDATED/ - Version with updated images
  - main_site_ready_for_upload/ - Final version ready for server upload
- **Key Constraint:** Contains all versions including backups and iterations

### 02_DEVELOPMENT/
- **Purpose:** Development workspace for all website iterations and experiments
- **Contents:**
  - review_later/ - Main working directory with current development files
  - site/ - Alternative site versions
  - live-site/ - Development versions of live site
  - stupidiots-live-site/ - Another live site iteration
- **Key Constraint:** All work stored here before going live

### 03_DOCUMENTS/
- **Purpose:** Centralized storage for project documentation and official materials
- **Contents:**
  - docs/ - Official project documentation
  - stupidots_hot_all_files/ - Hot files and latest versions
  - Vector files and design assets
- **Key Constraint:** Single source of truth for documentation

### 04_ASSETS/
- **Purpose:** Storage for all visual assets, media files, and design resources
- **Contents:**
  - assets/ - Main assets directory
  - img/ - Image files (logos, icons, graphics)
  - IDIOT-Logos.zip - Logo package
  - Community.lnk - Community links
- **Key Constraint:** All media files must be properly organized here

### 05_ARCHIVES/
- **Purpose:** Long-term storage for old versions, backups, and archived project files
- **Contents:**
  - Various zip files with different versions of the site
  - Backup files and compressed archives
  - Historical versions of the website
- **Key Constraint:** Reference only - do not modify archived files

### 06_SCRIPTS/
- **Purpose:** Development tools, automation scripts, and utilities
- **Contents:**
  - make-index.bat/sh - Scripts to generate index files
  - merkle-tool/ - Airdrop merkle tree generation tools
  - scripts/ - Various utility scripts
- **Key Constraint:** Automation tools for building and maintaining project

### 07_CONTRACTS/
- **Purpose:** Storage for blockchain-related files, smart contracts, and crypto documentation
- **Contents:**
  - contracts/ - Smart contract source code
  - MerkleDistributor.sol - Airdrop distribution contract
  - IDIOT_Project_Key_Addresses.docx - Key contract addresses
- **Key Constraint:** Critical blockchain files - verify before changes

### 08_JUNK/
- **Purpose:** Storage for files confirmed to be unnecessary or outdated
- **Contents:**
  - Files that are definitely no longer needed
  - Duplicate files that can be safely deleted
  - Outdated versions that have been superseded
  - Temporary files and test files
- **Key Constraint:** Safe to delete when cleaning up project

### 09_LIVE_SITE/
- **Purpose:** Files ready to be uploaded to web server as live website
- **Contents:**
  - index.html - Main website file ready for upload to server
  - airdrop/ - Airdrop portal and related files
  - assets/ - Images, icons, and media files for live site
- **Key Constraint:** Production-ready files only

### 11_REVIEW_BEFORE_DISCARD/
- **Purpose:** Temporary storage for files that might still be needed
- **Contents:**
  - Files that may be outdated or redundant
  - Backup copies of previous versions
  - Files that need user approval before removal
- **Key Constraint:** Review before final deletion

## Critical Constraints Summary

1. **NO SERVER EDITS** - Work only under C:\stupidiots_project until Packet 6
2. **BRANCH WORKFLOW** - Use staging-local for development, release-ready for final review
3. **ASSET ORGANIZATION** - All media files must be in 04_ASSETS/
4. **DOCUMENTATION** - Keep 03_DOCUMENTS/ as single source of truth
5. **CONTRACT SAFETY** - 07_CONTRACTS/ contains critical blockchain files
6. **ARCHIVE INTEGRITY** - 05_ARCHIVES/ is reference only, do not modify
7. **JUNK CLEANUP** - 08_JUNK/ can be safely deleted during cleanup

## Development Workflow

- **Active Development:** staging-local branch
- **Final Review:** release-ready branch  
- **Production Deploy:** Only after Packet 6 completion
- **Asset Updates:** Always through 04_ASSETS/ first
- **Documentation:** Update 03_DOCUMENTS/ for any content changes
