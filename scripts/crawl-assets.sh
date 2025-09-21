#!/bin/bash

# Website Assets Crawler for KisanIndustries
# This script helps collect GIFs and other assets from the live website

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Default values
WEBSITE_URL="https://kisanindustries.info"
OUTPUT_DIR="assets"
USER_AGENT="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check prerequisites
check_prerequisites() {
    print_status "Checking prerequisites..."
    
    if ! command_exists wget && ! command_exists curl; then
        print_error "Neither wget nor curl found. Please install one of them."
        exit 1
    fi
    
    if command_exists wget; then
        DOWNLOAD_CMD="wget"
        print_status "Using wget for downloads"
    else
        DOWNLOAD_CMD="curl"
        print_status "Using curl for downloads"
    fi
}

# Create directory structure
setup_directories() {
    print_status "Setting up directory structure..."
    
    mkdir -p "$OUTPUT_DIR/gifs"
    mkdir -p "$OUTPUT_DIR/images"
    mkdir -p "$OUTPUT_DIR/videos"
    mkdir -p "$OUTPUT_DIR/css"
    mkdir -p "$OUTPUT_DIR/js"
    
    print_status "Directories created successfully!"
}

# Download GIFs using wget
download_gifs_wget() {
    print_status "Downloading GIFs using wget..."
    
    wget \
        --recursive \
        --no-parent \
        --no-host-directories \
        --cut-dirs=1 \
        --accept=gif \
        --directory-prefix="$OUTPUT_DIR/gifs" \
        --user-agent="$USER_AGENT" \
        --wait=1 \
        --random-wait \
        --no-check-certificate \
        "$WEBSITE_URL"
}

# Download GIFs using curl and find
download_gifs_curl() {
    print_status "Downloading page content to find GIFs..."
    
    # Download the main page
    local main_page=$(curl -s -L -A "$USER_AGENT" "$WEBSITE_URL" || echo "")
    
    if [ -z "$main_page" ]; then
        print_error "Failed to download main page content"
        return 1
    fi
    
    # Extract GIF URLs using grep and sed
    local gif_urls
    gif_urls=$(echo "$main_page" | grep -o 'https\?://[^"]*\.gif[^"]*' | sort | uniq)
    
    if [ -z "$gif_urls" ]; then
        print_warning "No GIF URLs found on the main page"
        return 1
    fi
    
    print_status "Found $(echo "$gif_urls" | wc -l) GIF URLs"
    
    # Download each GIF
    while IFS= read -r gif_url; do
        if [ -n "$gif_url" ]; then
            local filename
            filename=$(basename "$gif_url" | sed 's/[?&].*//')
            
            print_status "Downloading: $filename"
            curl -s -L -A "$USER_AGENT" -o "$OUTPUT_DIR/gifs/$filename" "$gif_url"
            
            if [ $? -eq 0 ]; then
                print_status "✓ Downloaded: $filename"
            else
                print_warning "✗ Failed to download: $filename"
            fi
            
            # Be nice to the server
            sleep 1
        fi
    done <<< "$gif_urls"
}

# Download other assets
download_other_assets() {
    print_status "Downloading other assets..."
    
    if [ "$DOWNLOAD_CMD" = "wget" ]; then
        # Download images (jpg, png, svg)
        wget \
            --recursive \
            --no-parent \
            --no-host-directories \
            --cut-dirs=1 \
            --accept=jpg,jpeg,png,svg \
            --directory-prefix="$OUTPUT_DIR/images" \
            --user-agent="$USER_AGENT" \
            --wait=1 \
            --random-wait \
            --no-check-certificate \
            --level=2 \
            "$WEBSITE_URL" 2>/dev/null || true
            
        # Download videos (mp4, webm)
        wget \
            --recursive \
            --no-parent \
            --no-host-directories \
            --cut-dirs=1 \
            --accept=mp4,webm,avi,mov \
            --directory-prefix="$OUTPUT_DIR/videos" \
            --user-agent="$USER_AGENT" \
            --wait=1 \
            --random-wait \
            --no-check-certificate \
            --level=2 \
            "$WEBSITE_URL" 2>/dev/null || true
    else
        print_warning "Advanced asset downloading requires wget. Install wget for full functionality."
    fi
}

# Clean up and organize files
cleanup_and_organize() {
    print_status "Cleaning up and organizing files..."
    
    # Remove empty files
    find "$OUTPUT_DIR" -type f -empty -delete
    
    # Remove files that are clearly not what we want
    find "$OUTPUT_DIR" -name "*.html" -delete 2>/dev/null || true
    find "$OUTPUT_DIR" -name "*.php" -delete 2>/dev/null || true
    find "$OUTPUT_DIR" -name "robots.txt" -delete 2>/dev/null || true
    
    # Create a summary
    local gif_count
    local image_count
    local video_count
    
    gif_count=$(find "$OUTPUT_DIR/gifs" -type f 2>/dev/null | wc -l)
    image_count=$(find "$OUTPUT_DIR/images" -type f 2>/dev/null | wc -l)
    video_count=$(find "$OUTPUT_DIR/videos" -type f 2>/dev/null | wc -l)
    
    print_status "Download summary:"
    echo "  - GIFs: $gif_count files"
    echo "  - Images: $image_count files"
    echo "  - Videos: $video_count files"
    
    # Create index file
    cat > "$OUTPUT_DIR/download-summary.txt" << EOF
KisanIndustries Assets Download Summary
Generated on: $(date)
Website: $WEBSITE_URL

Files downloaded:
- GIFs: $gif_count files
- Images: $image_count files  
- Videos: $video_count files

GIF files:
$(find "$OUTPUT_DIR/gifs" -type f -exec basename {} \; 2>/dev/null | sort)

Image files:
$(find "$OUTPUT_DIR/images" -type f -exec basename {} \; 2>/dev/null | sort)

Video files:
$(find "$OUTPUT_DIR/videos" -type f -exec basename {} \; 2>/dev/null | sort)
EOF
}

# Alternative method using browser automation
suggest_browser_method() {
    print_status "Alternative: Manual browser method"
    echo
    echo "If automated downloading doesn't work, try this manual approach:"
    echo
    echo "1. Open the website in your browser: $WEBSITE_URL"
    echo "2. Open Developer Tools (F12)"
    echo "3. Go to the Network tab"
    echo "4. Reload the page and browse around"
    echo "5. Filter by 'Images' or search for '.gif'"
    echo "6. Right-click on GIF files and save them"
    echo "7. Save files to the assets/gifs/ directory"
    echo
    echo "You can also use browser extensions like:"
    echo "- Image Downloader"
    echo "- DownThemAll"
    echo "- Bulk Image Downloader"
}

# Main function
main() {
    echo "🌾 KisanIndustries Website Assets Crawler"
    echo "========================================"
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -u|--url)
                WEBSITE_URL="$2"
                shift 2
                ;;
            -o|--output)
                OUTPUT_DIR="$2"
                shift 2
                ;;
            -h|--help)
                echo "Usage: $0 [OPTIONS]"
                echo "Options:"
                echo "  -u, --url URL     Website URL (default: https://kisanindustries.info)"
                echo "  -o, --output DIR  Output directory (default: assets)"
                echo "  -h, --help        Show this help message"
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                exit 1
                ;;
        esac
    done
    
    check_prerequisites
    setup_directories
    
    print_status "Starting download from: $WEBSITE_URL"
    print_status "Output directory: $OUTPUT_DIR"
    
    # Try to download GIFs
    if [ "$DOWNLOAD_CMD" = "wget" ]; then
        download_gifs_wget || {
            print_warning "wget method failed, trying curl method..."
            download_gifs_curl
        }
        download_other_assets
    else
        download_gifs_curl
    fi
    
    cleanup_and_organize
    
    echo
    print_status "Download completed! 🎉"
    print_status "Check the $OUTPUT_DIR directory for downloaded files"
    
    if [ -f "$OUTPUT_DIR/download-summary.txt" ]; then
        print_status "See $OUTPUT_DIR/download-summary.txt for details"
    fi
    
    suggest_browser_method
}

# Run main function with all arguments
main "$@"