#!/bin/bash

# Build script for localhost flavor
echo "Building Flutter web app for localhost..."

flutter build web \
  --dart-define=API_BASE_URL=http://localhost:3000 \
  --release

echo "Build complete! Output: build/web"

