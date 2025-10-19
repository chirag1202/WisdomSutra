#!/bin/bash
# PWA Validation Script for WisdomSutra
# This script validates that all PWA files and configurations are in place

echo "=============================================="
echo "  WisdomSutra PWA Validation Script"
echo "=============================================="
echo ""

ERRORS=0
WARNINGS=0

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to check if file exists
check_file() {
    if [ -f "$1" ]; then
        echo -e "${GREEN}✓${NC} $1 exists"
        return 0
    else
        echo -e "${RED}✗${NC} $1 is missing"
        ((ERRORS++))
        return 1
    fi
}

# Function to validate JSON
validate_json() {
    if python3 -m json.tool "$1" > /dev/null 2>&1; then
        echo -e "${GREEN}✓${NC} $1 is valid JSON"
        return 0
    else
        echo -e "${RED}✗${NC} $1 has invalid JSON syntax"
        ((ERRORS++))
        return 1
    fi
}

# Function to check file content
check_content() {
    if grep -q "$2" "$1"; then
        echo -e "${GREEN}✓${NC} $1 contains '$2'"
        return 0
    else
        echo -e "${YELLOW}⚠${NC} $1 missing '$2'"
        ((WARNINGS++))
        return 1
    fi
}

echo "1. Checking PWA Files..."
echo "-----------------------------------"
check_file "web/manifest.json"
check_file "web/index.html"
check_file "web/flutter_service_worker.js"
check_file "web/offline.html"
check_file "web/favicon.png"
echo ""

echo "2. Checking Icon Files..."
echo "-----------------------------------"
check_file "web/icons/Icon-192.png"
check_file "web/icons/Icon-512.png"
check_file "web/icons/Icon-maskable-192.png"
check_file "web/icons/Icon-maskable-512.png"
echo ""

echo "3. Validating manifest.json..."
echo "-----------------------------------"
if [ -f "web/manifest.json" ]; then
    validate_json "web/manifest.json"
    check_content "web/manifest.json" "WisdomSutra"
    check_content "web/manifest.json" "theme_color"
    check_content "web/manifest.json" "background_color"
    check_content "web/manifest.json" "display"
    check_content "web/manifest.json" "icons"
fi
echo ""

echo "4. Validating index.html..."
echo "-----------------------------------"
if [ -f "web/index.html" ]; then
    check_content "web/index.html" "manifest.json"
    check_content "web/index.html" "theme-color"
    check_content "web/index.html" "serviceWorker"
    check_content "web/index.html" "viewport"
fi
echo ""

echo "5. Validating Service Worker..."
echo "-----------------------------------"
if [ -f "web/flutter_service_worker.js" ]; then
    check_content "web/flutter_service_worker.js" "CACHE_NAME"
    check_content "web/flutter_service_worker.js" "addEventListener"
    check_content "web/flutter_service_worker.js" "install"
    check_content "web/flutter_service_worker.js" "activate"
    check_content "web/flutter_service_worker.js" "fetch"
fi
echo ""

echo "6. Checking Documentation..."
echo "-----------------------------------"
check_file "docs/PWA_IMPLEMENTATION.md"
echo ""

echo "=============================================="
echo "  Validation Summary"
echo "=============================================="
echo ""

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}✓ All PWA validations passed!${NC}"
    echo ""
    echo "Next steps:"
    echo "1. Build the web app: flutter build web"
    echo "2. Test locally: cd build/web && python3 -m http.server 8000"
    echo "3. Open pwa-test.html for comprehensive testing"
    exit 0
elif [ $ERRORS -eq 0 ]; then
    echo -e "${YELLOW}⚠ PWA validation completed with $WARNINGS warning(s)${NC}"
    echo "The PWA should still work, but consider reviewing the warnings."
    exit 0
else
    echo -e "${RED}✗ PWA validation failed with $ERRORS error(s) and $WARNINGS warning(s)${NC}"
    echo "Please fix the errors before deploying."
    exit 1
fi
