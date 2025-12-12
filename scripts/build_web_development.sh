#!/bin/bash

# Build script for development flavor
echo "Building Flutter web app for development..."

flutter build web \
  --dart-define=API_BASE_URL=https://digift-erp-backend-5.onrender.com \
  --release

echo "Build complete! Output: build/web"
