<?php
/**
 * KisanIndustries Local Development Configuration
 * 
 * This file contains configuration settings for local WordPress development.
 * Copy this to your WordPress root as wp-config.php and modify as needed.
 */

// ** MySQL settings ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'kisanindustries_local' );

/** MySQL database username */
define( 'DB_USER', 'kisanindustries' );

/** MySQL database password */
define( 'DB_PASSWORD', 'your_password_here' );

/** MySQL hostname */
define( 'DB_HOST', 'localhost' );

/** Database Charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8mb4' );

/** The Database Collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**
 * Authentication Unique Keys and Salts.
 * 
 * Change these to different unique phrases! You can generate these using
 * the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 */
define( 'AUTH_KEY',         'put your unique phrase here' );
define( 'SECURE_AUTH_KEY',  'put your unique phrase here' );
define( 'LOGGED_IN_KEY',    'put your unique phrase here' );
define( 'NONCE_KEY',        'put your unique phrase here' );
define( 'AUTH_SALT',        'put your unique phrase here' );
define( 'SECURE_AUTH_SALT', 'put your unique phrase here' );
define( 'LOGGED_IN_SALT',   'put your unique phrase here' );
define( 'NONCE_SALT',       'put your unique phrase here' );

/**
 * WordPress Database Table prefix.
 */
$table_prefix = 'wp_';

/**
 * WordPress Localized Language
 */
define( 'WPLANG', '' );

/**
 * Local Development Settings
 */
define( 'WP_DEBUG', true );
define( 'WP_DEBUG_LOG', true );
define( 'WP_DEBUG_DISPLAY', true );
define( 'SCRIPT_DEBUG', true );

/**
 * Local URLs - Update these to match your local setup
 */
define( 'WP_HOME', 'http://localhost/kisanindustries' );
define( 'WP_SITEURL', 'http://localhost/kisanindustries' );

/**
 * Increase memory limit for Elementor
 */
define( 'WP_MEMORY_LIMIT', '512M' );

/**
 * File permissions
 */
define( 'FS_METHOD', 'direct' );

/**
 * Automatic updates - disable for local development
 */
define( 'AUTOMATIC_UPDATER_DISABLED', true );
define( 'WP_AUTO_UPDATE_CORE', false );

/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
    define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';