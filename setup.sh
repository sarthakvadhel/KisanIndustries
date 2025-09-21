#!/bin/bash

# KisanIndustries Local Setup Helper Script
# This script automates the common setup tasks for local development

set -e

echo "🌾 KisanIndustries Local Development Setup Helper"
echo "================================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running from correct directory
if [ ! -f "README.md" ] || [ ! -d "config" ]; then
    print_error "Please run this script from the repository root directory"
    exit 1
fi

print_status "Starting KisanIndustries local setup..."

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check prerequisites
check_prerequisites() {
    print_status "Checking prerequisites..."
    
    local missing_deps=()
    
    if ! command_exists mysql; then
        missing_deps+=("MySQL")
    fi
    
    if ! command_exists php; then
        missing_deps+=("PHP")
    fi
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        print_error "Missing dependencies: ${missing_deps[*]}"
        print_warning "Please install the missing dependencies and run this script again"
        exit 1
    fi
    
    print_status "All prerequisites found!"
}

# Setup database
setup_database() {
    print_status "Setting up database..."
    
    read -p "Enter MySQL root password: " -s mysql_root_password
    echo
    
    read -p "Enter database name [kisanindustries_local]: " db_name
    db_name=${db_name:-kisanindustries_local}
    
    read -p "Enter database user [kisanindustries]: " db_user
    db_user=${db_user:-kisanindustries}
    
    read -p "Enter database password: " -s db_password
    echo
    
    # Create database and user
    mysql -u root -p"$mysql_root_password" -e "
        CREATE DATABASE IF NOT EXISTS $db_name CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
        CREATE USER IF NOT EXISTS '$db_user'@'localhost' IDENTIFIED BY '$db_password';
        GRANT ALL PRIVILEGES ON $db_name.* TO '$db_user'@'localhost';
        FLUSH PRIVILEGES;
    " 2>/dev/null
    
    if [ $? -eq 0 ]; then
        print_status "Database setup completed successfully!"
        
        # Update wp-config.php if it exists
        if [ -f "wp-config.php" ]; then
            print_status "Updating wp-config.php with database credentials..."
            sed -i.bak "s/define( 'DB_NAME', '.*' );/define( 'DB_NAME', '$db_name' );/" wp-config.php
            sed -i.bak "s/define( 'DB_USER', '.*' );/define( 'DB_USER', '$db_user' );/" wp-config.php
            sed -i.bak "s/define( 'DB_PASSWORD', '.*' );/define( 'DB_PASSWORD', '$db_password' );/" wp-config.php
        fi
    else
        print_error "Failed to create database. Please check your MySQL root password."
        exit 1
    fi
}

# Setup WordPress config
setup_wordpress_config() {
    print_status "Setting up WordPress configuration..."
    
    if [ ! -f "wp-config.php" ]; then
        if [ -f "config/wp-config-local.php" ]; then
            cp config/wp-config-local.php wp-config.php
            print_status "WordPress config file created from template"
        else
            print_warning "wp-config-local.php template not found in config directory"
            return 1
        fi
    else
        print_warning "wp-config.php already exists, skipping..."
    fi
    
    # Generate salts
    print_status "Generating WordPress security keys..."
    local salts
    salts=$(curl -s https://api.wordpress.org/secret-key/1.1/salt/)
    
    if [ -n "$salts" ]; then
        # Create a temporary file with the salts
        echo "$salts" > /tmp/wp-salts.txt
        
        # Replace the placeholder salts in wp-config.php
        sed -i.bak '/put your unique phrase here/d' wp-config.php
        sed -i.bak '/AUTH_KEY/r /tmp/wp-salts.txt' wp-config.php
        
        rm /tmp/wp-salts.txt
        print_status "Security keys generated and added to wp-config.php"
    else
        print_warning "Could not fetch security keys from WordPress.org"
    fi
}

# Set permissions
set_permissions() {
    print_status "Setting file permissions..."
    
    # Standard WordPress permissions
    find . -type d -exec chmod 755 {} \;
    find . -type f -exec chmod 644 {} \;
    
    # Special permissions for wp-config.php
    if [ -f "wp-config.php" ]; then
        chmod 600 wp-config.php
    fi
    
    # Make uploads directory writable
    if [ -d "wp-content/uploads" ]; then
        chmod -R 755 wp-content/uploads
    fi
    
    print_status "File permissions set successfully!"
}

# Import database if SQL file exists
import_database() {
    if [ -f "database/kisanindustries_initial.sql" ]; then
        print_status "Found database SQL file. Do you want to import it? (y/N)"
        read -r import_choice
        
        if [[ $import_choice =~ ^[Yy]$ ]]; then
            read -p "Enter database name: " db_name
            read -p "Enter database user: " db_user
            read -p "Enter database password: " -s db_password
            echo
            
            mysql -u "$db_user" -p"$db_password" "$db_name" < database/kisanindustries_initial.sql
            
            if [ $? -eq 0 ]; then
                print_status "Database imported successfully!"
            else
                print_error "Failed to import database"
            fi
        fi
    fi
}

# Main setup function
main() {
    check_prerequisites
    
    echo
    print_status "What would you like to do?"
    echo "1) Full setup (database + WordPress config)"
    echo "2) Database setup only"
    echo "3) WordPress config only"
    echo "4) Set file permissions only"
    echo "5) Import database only"
    echo "0) Exit"
    
    read -p "Choose an option [1]: " choice
    choice=${choice:-1}
    
    case $choice in
        1)
            setup_database
            setup_wordpress_config
            set_permissions
            import_database
            ;;
        2)
            setup_database
            ;;
        3)
            setup_wordpress_config
            ;;
        4)
            set_permissions
            ;;
        5)
            import_database
            ;;
        0)
            print_status "Exiting..."
            exit 0
            ;;
        *)
            print_error "Invalid option"
            exit 1
            ;;
    esac
    
    echo
    print_status "Setup completed! 🎉"
    print_status "Next steps:"
    echo "1. Start your web server (Apache/Nginx)"
    echo "2. Visit http://localhost/kisanindustries in your browser"
    echo "3. Complete WordPress installation or import your backup"
    echo "4. Install required plugins (Elementor, All-in-One WP Migration)"
}

# Run main function
main "$@"