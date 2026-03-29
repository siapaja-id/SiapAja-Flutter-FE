# Plan: Implement Ctrl+/- Zoom for Flutter Ubuntu Linux Build

## Context
The app is a React-to-Flutter port with all dimensions hardcoded (no responsive utilities). The user wants browser-like Ctrl+Plus/Minus zoom that seamlessly scales all UI components on the Ubuntu Linux desktop build.

## Approach
Use `FittedBox` + `Transform.scale` wrapped around the app content, controlled by a Riverpod `StateNotifier`. This is the same mechanism browsers use: render at one resolution, then scale the output. Since ALL dimensions in this app are hardcoded, uniform scaling via FittedBox is the cleanest approach — it scales text, spacing, icons, images, everything uniformly.

Additionally override `MediaQueryData.size` so any widget that reads screen dimensions gets the zoom-adjusted values.

## Files to Create

### 1. `lib/shared/zoom_provider.dart` — Zoom state management
- `ZoomNotifier extends StateNotifier<double>` with initial state `1.0`
- Methods: `zoomIn()` (+0.1, max 3.0), `zoomOut()` (-0.1, min 0.5), `reset()` (→ 1.0)
- Provider: `zoomProvider = StateNotifierProvider<ZoomNotifier, double>`

### 2. `lib/shared/zoom_wrapper.dart` — Zoom wrapper widget
- `ZoomWrapper` wraps child in `LayoutBuilder` → `FittedBox` → `SizedBox(childSize / zoom)` → `Transform.scale(zoom)` → `MediaQuery(size: originalSize / zoom)` → child
- Keyboard shortcut handler using `Focus` + `onKeyEvent`:
  - `Ctrl+Equal` (Plus key without shift) → zoomIn
  - `Ctrl+Minus` → zoomOut
  - `Ctrl+Digit0` → reset
- `MouseRegion` + `Listener.onPointerSignal` for Ctrl+ScrollWheel zoom

## Files to Modify

### 3. `lib/main.dart` — Integrate zoom wrapper
- Import `zoom_wrapper.dart`
- Replace the current `builder` with `ZoomWrapper` wrapping `child`
- Keep existing text scaler clamping logic inside ZoomWrapper

## Implementation Details

### FittedBox scaling math
```
LayoutBuilder constraints = W x H (actual screen)
childSize = W/zoom x H/zoom
SizedBox(childSize) → child renders at scaled-down size
FittedBox + Transform.scale(zoom) → scales child back up to fill screen
```

### MediaQuery override
```
MediaQuery(size: originalSize / zoom)
```
This ensures widgets reading `MediaQuery.of(context).size` see zoom-adjusted values, so scrollable content, `SizedBox.fromSize`, etc. behave correctly.

### Text scaling
Keep existing `textScaler.clamp(min: 0.8, max: 2.0)` inside the ZoomWrapper, applied after the FittedBox's MediaQuery so text renders at the correct size within the scaled context.

## Verification
1. `flutter build linux` — must compile without errors
2. `flutter analyze` — must pass with no new warnings
3. Manual test: run on Ubuntu, press Ctrl+= / Ctrl+- / Ctrl+0 and verify all UI scales uniformly
