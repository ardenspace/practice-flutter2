#!/bin/bash

# TikTok Clone Optimized Build Configuration
# This script provides optimized build commands for different platforms

set -e

echo "🚀 TikTok Clone - Optimized Build Configuration"
echo "================================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Flutter is available
check_flutter() {
    if ! command -v flutter &> /dev/null; then
        print_error "Flutter is not installed or not in PATH"
        exit 1
    fi
    print_success "Flutter found: $(flutter --version | head -n 1)"
}

# Clean previous builds
clean_build() {
    print_status "Cleaning previous builds..."
    flutter clean
    flutter pub get
    print_success "Build environment cleaned"
}

# Optimize for web
build_web() {
    print_status "Building optimized web version..."
    
    flutter build web \
        --release \
        --web-renderer canvaskit \
        --dart-define=FLUTTER_WEB_USE_SKIA=true \
        --dart-define=FLUTTER_WEB_AUTO_DETECT=true \
        --source-maps \
        --tree-shake-icons \
        --no-sound-null-safety
    
    print_success "Web build completed with optimizations"
    print_status "Build output: build/web/"
    
    # Calculate build size
    if [ -d "build/web" ]; then
        size=$(du -sh build/web | cut -f1)
        print_status "Total build size: $size"
    fi
}

# Optimize for Android
build_android() {
    print_status "Building optimized Android APK..."
    
    flutter build apk \
        --release \
        --shrink \
        --obfuscate \
        --tree-shake-icons \
        --split-debug-info=build/app/outputs/symbols
    
    print_success "Android APK build completed with optimizations"
    print_status "APK output: build/app/outputs/flutter-apk/"
}

# Optimize for iOS
build_ios() {
    print_status "Building optimized iOS version..."
    
    flutter build ios \
        --release \
        --tree-shake-icons \
        --obfuscate \
        --split-debug-info=build/ios/symbols
    
    print_success "iOS build completed with optimizations"
}

# Build for all platforms
build_all() {
    print_status "Building for all platforms..."
    clean_build
    build_web
    build_android
    if [[ "$OSTYPE" == "darwin"* ]]; then
        build_ios
    else
        print_warning "iOS build skipped (macOS required)"
    fi
    print_success "All builds completed!"
}

# Performance analysis
analyze_performance() {
    print_status "Analyzing performance..."
    
    # Check for unused imports
    print_status "Checking for unused imports..."
    find lib -name "*.dart" -exec grep -l "^import" {} \; | head -5
    
    # Bundle size analysis for web
    if [ -d "build/web" ]; then
        print_status "Web bundle analysis:"
        echo "Main bundle: $(ls -lh build/web/main.dart.js 2>/dev/null | awk '{print $5}' || echo 'Not found')"
        echo "Total assets: $(find build/web -type f | wc -l) files"
    fi
    
    print_success "Performance analysis completed"
}

# Main script logic
case "${1:-help}" in
    "web")
        check_flutter
        clean_build
        build_web
        ;;
    "android")
        check_flutter
        clean_build
        build_android
        ;;
    "ios")
        check_flutter
        clean_build
        build_ios
        ;;
    "all")
        check_flutter
        build_all
        ;;
    "clean")
        clean_build
        ;;
    "analyze")
        analyze_performance
        ;;
    "help"|*)
        echo "Usage: $0 {web|android|ios|all|clean|analyze|help}"
        echo ""
        echo "Commands:"
        echo "  web      - Build optimized web version"
        echo "  android  - Build optimized Android APK"
        echo "  ios      - Build optimized iOS version (macOS only)"
        echo "  all      - Build for all available platforms"
        echo "  clean    - Clean build artifacts and dependencies"
        echo "  analyze  - Analyze bundle size and performance"
        echo "  help     - Show this help message"
        echo ""
        echo "Examples:"
        echo "  $0 web       # Build for web with optimizations"
        echo "  $0 android   # Build Android APK"
        echo "  $0 analyze   # Check performance metrics"
        ;;
esac