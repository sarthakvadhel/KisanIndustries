# Scripts

This folder contains helper scripts for setting up and managing the KisanIndustries local development environment.

## Available Scripts

### `crawl-assets.sh`
Website assets crawler that helps collect GIFs and other media files from the live website.

**Usage:**
```bash
./scripts/crawl-assets.sh [OPTIONS]
```

**Options:**
- `-u, --url URL` - Website URL (default: https://kisanindustries.info)
- `-o, --output DIR` - Output directory (default: assets)
- `-h, --help` - Show help message

**Examples:**
```bash
# Basic usage - crawl default website
./scripts/crawl-assets.sh

# Crawl specific URL
./scripts/crawl-assets.sh -u https://example.com

# Save to custom directory
./scripts/crawl-assets.sh -o my-assets
```

**What it does:**
- Downloads all GIF files from the website
- Organizes assets into appropriate folders
- Creates a summary report
- Provides fallback instructions for manual collection

## Setup Scripts in Root Directory

### `setup.sh`
Main setup script for WordPress local development environment.

**Features:**
- Database creation and configuration
- WordPress configuration file setup
- File permissions management
- Security key generation
- Database import assistance

**Usage:**
```bash
./setup.sh
```

The script provides an interactive menu with options:
1. Full setup (database + WordPress config)
2. Database setup only
3. WordPress config only
4. Set file permissions only
5. Import database only

## Manual Alternative Methods

If the automated scripts don't work, you can:

### For Asset Collection:
1. Use browser developer tools to download assets manually
2. Use browser extensions for bulk downloading
3. Access the WordPress media library after backup import
4. Use wget/curl commands manually

### For WordPress Setup:
1. Follow the comprehensive instructions in the main README.md
2. Use phpMyAdmin for database management
3. Configure files manually using the templates in the config/ directory

## Prerequisites

Make sure you have these tools installed:
- `bash` (for running scripts)
- `wget` or `curl` (for downloading)
- `mysql` (for database operations)
- `php` (for WordPress)

## Troubleshooting

If scripts fail:
1. Check file permissions: `chmod +x scripts/*.sh`
2. Verify prerequisites are installed
3. Check network connectivity for downloads
4. Review error messages for specific issues

For detailed troubleshooting, see the main README.md file.