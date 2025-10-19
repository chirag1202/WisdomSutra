#!/bin/bash
# Update Service Worker Cache Version
# This script updates the cache version in the service worker for CI/CD automation

set -e

# Default cache name prefix
CACHE_PREFIX="wisdomsutra-cache"
SW_FILE="web/flutter_service_worker.js"

# Check if service worker file exists
if [ ! -f "$SW_FILE" ]; then
    echo "Error: Service worker file not found at $SW_FILE"
    exit 1
fi

# Generate new cache version
# Options: timestamp, commit hash, or custom version
if [ -n "$1" ]; then
    # Use provided version
    NEW_VERSION="$1"
elif [ -d ".git" ]; then
    # Use git commit hash if available
    NEW_VERSION=$(git rev-parse --short HEAD)
else
    # Fallback to timestamp
    NEW_VERSION=$(date +%Y%m%d%H%M%S)
fi

NEW_CACHE_NAME="${CACHE_PREFIX}-${NEW_VERSION}"

echo "Updating service worker cache version..."
echo "New cache name: $NEW_CACHE_NAME"

# Find current cache name pattern and replace it
# This looks for any cache name starting with the prefix
if grep -q "${CACHE_PREFIX}-" "$SW_FILE"; then
    # Replace existing versioned cache name
    sed -i.bak "s/${CACHE_PREFIX}-[a-zA-Z0-9_-]*/${NEW_CACHE_NAME}/g" "$SW_FILE"
    rm -f "${SW_FILE}.bak"
    echo "✓ Cache version updated successfully"
else
    echo "Error: Could not find cache name pattern '${CACHE_PREFIX}-*' in $SW_FILE"
    exit 1
fi

# Verify the change
if grep -q "$NEW_CACHE_NAME" "$SW_FILE"; then
    echo "✓ Verification successful"
    grep "CACHE_NAME" "$SW_FILE" | head -1
else
    echo "Error: Verification failed"
    exit 1
fi

echo ""
echo "Done! Remember to rebuild the Flutter web app:"
echo "  flutter build web --release --web-renderer html"
