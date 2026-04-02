# Siapaja Flutter FE

A Flutter application targeting Linux desktop and Web (with WASM support).

## Prerequisites

- Flutter 3.41+ / Dart 3.11+
- Python 3 (for WASM serving with CORS headers)
- Linux desktop dependencies:
  ```bash
  sudo apt install clang cmake ninja-build pkg-config libgtk-3-dev libblkid-dev lld
  ```

## Getting Started

### Linux Desktop

```bash
# Run in debug mode
flutter run -d linux

# Build for production
flutter build linux
```

Output: `build/linux/x64/release/bundle/`

### Web Run (JS Mode — no WASM)

This mode compiles Dart to JavaScript (`main.dart.js`) and uses the CanvasKit renderer. It works in all browsers without special CORS headers.

#### Debug (hot-reload)

```bash
flutter run -d chrome
```

#### Release build

```bash
flutter build web --release
```

Output: `build/web/`

#### Serve the JS build

Any static file server works — no CORS headers are required for JS-only builds.

```bash
# Option A: Python
cd build/web && python3 -m http.server 8080

# Option B: Node (npx)
npx serve build/web -l 8080
```

Then open **http://localhost:8080**.

> **Tip:** If you later want WASM, switch to the WASM Build section below and use `serve_wasm.py` instead.

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
linux/               # Linux desktop platform files
build/
  linux/             # Linux desktop build output
  web/               # Web build output
    main.dart.wasm   # WASM binary
    main.dart.js     # JavaScript fallback
serve_wasm.py        # HTTP server with CORS headers
```
