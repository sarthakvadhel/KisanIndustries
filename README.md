# KisanIndustries - Local Development Setup

This repository contains everything needed to set up the KisanIndustries WordPress website locally for development and testing. The live site uses WordPress with Elementor page builder and can be fully replicated locally using the provided backup and configuration files.

## 🚀 Quick Start

1. [Install Prerequisites](#prerequisites)
2. [Set Up WordPress](#wordpress-installation)
3. [Configure Database](#database-setup)
4. [Import Site Backup](#importing-the-backup)
5. [Configure Elementor](#elementor-setup)
6. [Update URLs and Settings](#post-import-configuration)

## Prerequisites

Before you begin, ensure you have the following installed:

### Required Software
- **Web Server**: Apache or Nginx
- **PHP**: Version 7.4 or higher (8.0+ recommended)
- **MySQL**: Version 5.7 or higher (8.0+ recommended)
- **WordPress**: Latest version

### Recommended Development Environment
Choose one of these local development environments:

#### XAMPP (Cross-platform)
```bash
# Download from https://www.apachefriends.org/
# Install and start Apache + MySQL services
```

#### WAMP (Windows)
```bash
# Download from https://www.wampserver.com/
# Install and start all services
```

#### MAMP (macOS)
```bash
# Download from https://www.mamp.info/
# Install and configure ports
```

#### Docker (Advanced)
```bash
# Use WordPress official Docker image
docker run --name kisanindustries-wp -p 8080:80 -d wordpress
```

## WordPress Installation

### Method 1: Fresh WordPress Installation

1. **Download WordPress:**
   ```bash
   wget https://wordpress.org/latest.tar.gz
   tar -xzf latest.tar.gz
   mv wordpress kisanindustries
   ```

2. **Set up in your web server directory:**
   ```bash
   # For XAMPP
   mv kisanindustries /opt/lampp/htdocs/
   
   # For WAMP
   mv kisanindustries C:/wamp64/www/
   
   # For MAMP
   mv kisanindustries /Applications/MAMP/htdocs/
   ```

3. **Set proper permissions:**
   ```bash
   chmod -R 755 kisanindustries/
   chown -R www-data:www-data kisanindustries/
   ```

### Method 2: Using WP-CLI (Recommended)

```bash
# Install WP-CLI if not already installed
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp

# Create WordPress installation
wp core download --path=kisanindustries
cd kisanindustries
```

## Database Setup

### 1. Create Database

**Using MySQL Command Line:**
```sql
mysql -u root -p
CREATE DATABASE kisanindustries_local CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'kisanindustries'@'localhost' IDENTIFIED BY 'secure_password';
GRANT ALL PRIVILEGES ON kisanindustries_local.* TO 'kisanindustries'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

**Using phpMyAdmin:**
1. Open phpMyAdmin (usually at `http://localhost/phpmyadmin`)
2. Click "New" to create a database
3. Name it `kisanindustries_local`
4. Set collation to `utf8mb4_unicode_ci`
5. Click "Create"

### 2. Configure WordPress Database Connection

1. **Copy the configuration file:**
   ```bash
   cp config/wp-config-local.php wp-config.php
   ```

2. **Update database credentials in `wp-config.php`:**
   ```php
   define( 'DB_NAME', 'kisanindustries_local' );
   define( 'DB_USER', 'kisanindustries' );
   define( 'DB_PASSWORD', 'secure_password' );
   define( 'DB_HOST', 'localhost' );
   ```

3. **Update site URLs:**
   ```php
   define( 'WP_HOME', 'http://localhost/kisanindustries' );
   define( 'WP_SITEURL', 'http://localhost/kisanindustries' );
   ```

4. **Generate security keys:**
   - Visit https://api.wordpress.org/secret-key/1.1/salt/
   - Replace the placeholder keys in `wp-config.php`

## Installing Required Plugins

Before importing the backup, install these essential plugins:

### 1. All-in-One WP Migration (Required)

**Via WordPress Admin:**
1. Go to `Plugins` → `Add New`
2. Search for "All-in-One WP Migration"
3. Install and activate the plugin

**Via WP-CLI:**
```bash
wp plugin install all-in-one-wp-migration --activate
```

### 2. Elementor (Required)

**Via WordPress Admin:**
1. Go to `Plugins` → `Add New`
2. Search for "Elementor"
3. Install and activate the plugin

**Via WP-CLI:**
```bash
wp plugin install elementor --activate
```

### 3. Increase Upload Limits

Add to your `wp-config.php`:
```php
@ini_set( 'upload_max_filesize' , '512M' );
@ini_set( 'post_max_size', '512M');
@ini_set( 'memory_limit', '512M' );
@ini_set( 'max_execution_time', '300' );
@ini_set( 'max_input_vars', '3000' );
```

## Importing the Backup

### 1. Prepare the Backup File

1. **Obtain the backup file:**
   - Get the `kisanindustries-backup.wpress` file from the live site
   - Place it in the `backup/` folder of this repository

2. **Create the backup file (if you have access to the live site):**
   ```bash
   # On the live site, using All-in-One WP Migration
   # Go to All-in-One WP Migration → Export
   # Click "Export To" → "File"
   # Download the .wpress file
   ```

### 2. Import the Backup

1. **Access your local WordPress admin:**
   - Go to `http://localhost/kisanindustries/wp-admin`
   - Login with temporary admin credentials (if fresh install)

2. **Use All-in-One WP Migration:**
   - Go to `All-in-One WP Migration` → `Import`
   - Click `Import From` → `File`
   - Select your `kisanindustries-backup.wpress` file
   - Click `Proceed`
   - Wait for the import to complete (this may take several minutes)

3. **Alternative: Command Line Import:**
   ```bash
   # If you have WP-CLI and the Pro version
   wp ai1wm import backup/kisanindustries-backup.wpress
   ```

## Elementor Setup

### 1. Verify Elementor Installation

After importing the backup:

1. **Check Elementor status:**
   - Go to `Elementor` → `System Info`
   - Verify all requirements are met
   - Check for any warnings or errors

2. **Regenerate CSS:**
   - Go to `Elementor` → `Tools`
   - Click `Regenerate CSS`
   - Clear cache if using any caching plugins

### 2. Common Elementor Issues and Fixes

**Missing Fonts:**
```bash
# If custom fonts are missing
wp elementor flush_css
```

**Widget Errors:**
- Go to `Elementor` → `Tools` → `Replace URL`
- Update old URLs to your local URLs

**Performance Optimization:**
```php
// Add to wp-config.php for better Elementor performance
define( 'WP_MEMORY_LIMIT', '512M' );
define( 'SCRIPT_DEBUG', true );
```

## Post-Import Configuration

### 1. Update Site URLs

**Method 1: Using WordPress Admin**
1. Go to `Settings` → `General`
2. Update `WordPress Address (URL)` and `Site Address (URL)`
3. Save changes

**Method 2: Using WP-CLI**
```bash
wp search-replace 'https://kisanindustries.info' 'http://localhost/kisanindustries'
wp option update home 'http://localhost/kisanindustries'
wp option update siteurl 'http://localhost/kisanindustries'
```

**Method 3: Direct Database Update**
```sql
USE kisanindustries_local;
UPDATE wp_options SET option_value = 'http://localhost/kisanindustries' WHERE option_name = 'home';
UPDATE wp_options SET option_value = 'http://localhost/kisanindustries' WHERE option_name = 'siteurl';
```

### 2. Update File Permissions

```bash
# Set correct permissions
find kisanindustries/ -type d -exec chmod 755 {} \;
find kisanindustries/ -type f -exec chmod 644 {} \;
chmod 600 kisanindustries/wp-config.php
```

### 3. Clear Caches

```bash
# Clear WordPress caches
wp cache flush

# Clear Elementor cache
wp elementor flush_css

# If using object cache
wp cache flush
```

### 4. Update Permalinks

1. Go to `Settings` → `Permalinks`
2. Click `Save Changes` (even without making changes)
3. This regenerates the `.htaccess` file

## Troubleshooting

### Common Issues

#### 1. Database Connection Error
```
Error establishing a database connection
```
**Solution:**
- Check database credentials in `wp-config.php`
- Verify MySQL service is running
- Test database connection:
  ```bash
  mysql -u kisanindustries -p kisanindustries_local
  ```

#### 2. Memory Limit Errors
```
Fatal error: Allowed memory size exhausted
```
**Solution:**
- Increase memory limit in `wp-config.php`:
  ```php
  define( 'WP_MEMORY_LIMIT', '512M' );
  ```
- Update PHP settings in `php.ini`:
  ```ini
  memory_limit = 512M
  ```

#### 3. File Upload Errors
```
The uploaded file exceeds the upload_max_filesize directive
```
**Solution:**
- Update PHP settings:
  ```ini
  upload_max_filesize = 512M
  post_max_size = 512M
  max_execution_time = 300
  ```

#### 4. Elementor Editor Not Loading
**Solution:**
1. Check browser console for JavaScript errors
2. Disable other plugins temporarily
3. Regenerate Elementor CSS
4. Increase PHP memory limit

#### 5. Missing Images After Import
**Solution:**
- Check `wp-content/uploads/` directory permissions
- Regenerate thumbnails:
  ```bash
  wp media regenerate
  ```

### Debug Mode

Enable WordPress debug mode by adding to `wp-config.php`:
```php
define( 'WP_DEBUG', true );
define( 'WP_DEBUG_LOG', true );
define( 'WP_DEBUG_DISPLAY', true );
```

Check debug logs at `wp-content/debug.log`

## Development Workflow

### 1. Making Changes

1. **Always backup before major changes:**
   ```bash
   wp db export backup/before-changes-$(date +%Y%m%d).sql
   ```

2. **Use staging/development practices:**
   - Make changes on local copy first
   - Test thoroughly before deploying
   - Keep backups of working versions

### 2. Updating the Live Site

1. **Export changes:**
   ```bash
   # Create new backup
   wp ai1wm export --path=backup/updated-$(date +%Y%m%d).wpress
   ```

2. **Deploy to live site:**
   - Upload new backup to live site
   - Import using All-in-One WP Migration
   - Update URLs back to live domain

## Repository Structure

```
kisanindustries/
├── README.md                 # This file
├── .gitignore               # Git ignore rules
├── backup/
│   ├── README.md            # Backup instructions
│   └── kisanindustries-backup.wpress  # Site backup file
├── database/
│   ├── README.md            # Database setup instructions
│   └── kisanindustries_initial.sql    # Database export
├── config/
│   ├── README.md            # Configuration files info
│   └── wp-config-local.php  # WordPress config template
└── assets/
    ├── README.md            # Assets information
    ├── gifs/                # Animated GIFs from site
    ├── images/              # Static images
    └── videos/              # Video files
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly on local setup
5. Submit a pull request

## Support

For issues with this setup:

1. Check the [Troubleshooting](#troubleshooting) section
2. Verify all prerequisites are met
3. Check WordPress and plugin documentation
4. Create an issue in this repository

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Additional Resources

- [WordPress Documentation](https://wordpress.org/support/)
- [Elementor Documentation](https://elementor.com/help/)
- [All-in-One WP Migration Documentation](https://help.servmask.com/)
- [WP-CLI Documentation](https://wp-cli.org/)
- [Local Development Best Practices](https://developer.wordpress.org/advanced-administration/before-install/howto-install/)