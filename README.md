# Siapaja Flutter FE

A Flutter web application with WebAssembly (WASM) support.

## Prerequisites

- Flutter 3.41+ / Dart 3.11+
- Python 3 (for WASM serving with CORS headers)

## Getting Started

### Standard Web Build

```bash
# Run in debug mode
flutter run -d chrome

# Build for production
flutter build web
```

### WASM Build

```bash
# Build with WASM (generates both dart2wasm + dart2js fallback)
flutter build web --wasm --release
```

The WASM build produces two targets in `build/web/`:

| Target | Renderer | Browser Support |
|--------|----------|-----------------|
| `dart2wasm` | skwasm | Chromium 119+ |
| `dart2js` | canvaskit | All browsers (fallback) |

### Serve with CORS Headers

WASM threading requires specific HTTP headers. Use the included `serve_wasm.py`:

```bash
python3 serve_wasm.py
```

Then open **http://localhost:8080** in your browser.

The server sets these headers:

| Header | Value |
|--------|-------|
| `Cross-Origin-Embedder-Policy` | `credentialless` |
| `Cross-Origin-Opener-Policy` | `same-origin` |

## Browser Compatibility

| Browser | WASM | JS Fallback |
|---------|------|-------------|
| Chrome / Edge 119+ | Yes | Yes |
| Firefox / Zen | No (known bug) | Yes |
| Safari | No (known bug) | Yes |

Incompatible browsers automatically fall back to the JavaScript build.

## Project Structure

```
lib/
  main.dart          # App entry point
build/
  web/               # Build output
    main.dart.wasm   # WASM binary
    main.dart.js     # JavaScript fallback
serve_wasm.py        # HTTP server with CORS headers
```
