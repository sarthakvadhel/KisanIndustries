# GIFs from KisanIndustries Website

This folder contains animated GIFs extracted from the KisanIndustries website.

## How to Extract GIFs from the Website

Since the live website might not be directly accessible, you can extract GIFs in several ways:

### Method 1: From All-in-One WP Migration Backup
1. After importing the backup, check the Media Library in WordPress admin
2. Filter by file type "GIF" to find all animated GIFs
3. Download them manually or use the export feature

### Method 2: From WordPress Media Directory
After setting up the local site:
```bash
find wp-content/uploads -name "*.gif" -type f
```

### Method 3: Using Web Crawler (if site is accessible)
```bash
# Example using wget to download all GIFs
wget -r -A.gif https://kisanindustries.info/
```

### Method 4: From Browser Developer Tools
1. Visit the live website
2. Open Developer Tools (F12)
3. Go to Network tab
4. Filter by "Images"
5. Look for .gif files and save them

## Expected Content

GIFs from the website might include:
- Product showcase animations
- Process demonstrations
- Loading animations
- Interactive button effects
- Banner animations
- Background animations

## File Naming Convention

Use descriptive names:
- `product-showcase-animation.gif`
- `loading-spinner.gif`
- `banner-hero-animation.gif`
- `process-step-1.gif`

## Usage

These GIFs serve as:
- Reference for local development
- Backup copies of important animations
- Documentation of website visual elements
- Source files for optimization or modifications