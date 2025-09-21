# Backup Files

This folder contains the All-in-One WP Migration backup files for KisanIndustries.

## Files

- `kisanindustries-backup.wpress` - Complete site backup created with All-in-One WP Migration
- `README.md` - This file with import instructions

## How to Create the Backup File

On your live WordPress site:

1. Install the **All-in-One WP Migration** plugin
2. Go to **All-in-One WP Migration** → **Export**
3. Click **Export To** → **File**
4. Download the generated `.wpress` file
5. Rename it to `kisanindustries-backup.wpress` and place it in this folder

## How to Import the Backup

1. Set up a fresh WordPress installation locally
2. Install the **All-in-One WP Migration** plugin
3. Go to **All-in-One WP Migration** → **Import**
4. Click **Import From** → **File**
5. Select the `kisanindustries-backup.wpress` file
6. Click **Proceed** and wait for the import to complete
7. Update your URLs and configurations as needed

## Important Notes

- The backup file contains the complete site including:
  - All pages and posts
  - Media files
  - Plugin configurations (including Elementor)
  - Theme files and customizations
  - Database content
- Make sure you have enough disk space for the import
- The backup file may be large depending on the amount of media content
- After import, you may need to update file permissions