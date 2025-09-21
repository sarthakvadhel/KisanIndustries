# Configuration Files

This folder contains configuration files for local WordPress development.

## Files

### `wp-config-local.php`
A template WordPress configuration file optimized for local development. This file includes:

- Database connection settings
- Debug configuration
- Memory limits for Elementor
- Local URL definitions
- Development-specific settings

**Usage:**
1. Copy this file to your WordPress root directory
2. Rename it to `wp-config.php`
3. Update the database credentials and URLs to match your local setup

### `.htaccess-local`
Local Apache configuration for WordPress permalink structure and optimizations.

### `php.ini-recommendations`
Recommended PHP settings for optimal WordPress and Elementor performance.

## Setup Instructions

1. **Database Configuration:**
   ```php
   define( 'DB_NAME', 'your_local_database' );
   define( 'DB_USER', 'your_username' );
   define( 'DB_PASSWORD', 'your_password' );
   ```

2. **URL Configuration:**
   ```php
   define( 'WP_HOME', 'http://localhost/your-site-folder' );
   define( 'WP_SITEURL', 'http://localhost/your-site-folder' );
   ```

3. **Generate Security Keys:**
   Visit https://api.wordpress.org/secret-key/1.1/salt/ and replace the placeholder keys.

## Important Notes

- Never commit actual credentials to version control
- The debug settings are enabled for development - disable in production
- Memory limit is set to 512M for Elementor compatibility
- Automatic updates are disabled for local development