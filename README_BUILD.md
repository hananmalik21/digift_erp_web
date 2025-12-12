# Build Flavors for Web

This project supports two build flavors for web:

## Flavors

1. **localhost** - For local development (API: `http://localhost:3000`)
2. **development** - For development server (API: `https://digift-erp-backend-5.onrender.com`)

## Building

### Using npm scripts (if you have Node.js installed):

```bash
# Build for localhost
npm run build:web:localhost

# Build for development
npm run build:web:development

# Build for localhost (debug mode)
npm run build:web:localhost:debug

# Build for development (debug mode)
npm run build:web:development:debug
```

### Using shell scripts:

```bash
# Build for localhost
./scripts/build_web_localhost.sh

# Build for development
./scripts/build_web_development.sh
```

### Using Flutter commands directly:

```bash
# Build for localhost
flutter build web --dart-define=API_BASE_URL=http://localhost:3000 --release

# Build for development
flutter build web --dart-define=API_BASE_URL=https://digift-erp-backend-5.onrender.com --release
```

## Running in Development

For development, you can run with different flavors:

```bash
# Run with localhost API
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:3000

# Run with development API
flutter run -d chrome --dart-define=API_BASE_URL=https://digift-erp-backend-5.onrender.com
```

## Configuration

The API base URL is configured in `lib/core/network/api_config.dart` and reads from the `API_BASE_URL` environment variable passed via `--dart-define`.

If no `API_BASE_URL` is provided, it defaults to `http://localhost:3000`.

