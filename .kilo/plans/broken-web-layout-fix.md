# Fix: Web layout collapse on mobile feed path

## Problem
Web builds (JS and WASM) have never had proper height constraint rendering for leaf widgets on the mobile feed path (<768px). Desktop kanban mode (≥768px) reportedly works correctly on web. Linux desktop builds work for all paths.

## Root Cause Analysis

**Git history context:**
- **Pre-ddcfe17**: `main.dart` used `LayoutBuilder` for breakpoint. `ZoomWrapper` used `FittedBox` + `MediaQuery` override. Worked on Linux, never worked on web.
- **ddcfe17**: Changed `ZoomWrapper` to `Transform.scale` (no `MediaQuery` override). Still used `LayoutBuilder` for breakpoint.
- **0c3a68b / HEAD**: Reverted to `FittedBox` + `MediaQuery` override in `ZoomWrapper`. Changed breakpoint to `MediaQuery.sizeOf(context).width`.

**Two contributing factors:**

1. **Breakpoint check**: `MediaQuery.sizeOf(context)` reads from `WidgetsApp`'s internal `MediaQuery` (derived from JS `window.innerWidth`). On web initial frame, this can return 0/stale/unconverted CSS pixel values, causing wrong layout path selection or rebuild thrashing.

2. **MediaQuery override inside FittedBox**: The `MediaQuery.copyWith(size: ...)` inside `FittedBox`'s child creates a `MediaQuery` that reports `viewportWidth/zoom × viewportHeight/zoom`. On web, `WidgetsApp` may also create its own `MediaQuery` at a higher level. The interaction between these can cause child widgets to see inconsistent dimension information.

**Key evidence**: Desktop kanban path works on web with same `FittedBox` + `MediaQuery` structure, suggesting the issue is specifically about how the breakpoint triggers path selection and the resulting build/rebuild sequence.

## Fix — Two changes

### Change 1: `lib/main.dart` — Revert breakpoint to LayoutBuilder

Replace `MediaQuery.sizeOf(context).width >= 768` with `LayoutBuilder` + `constraints.maxWidth`:

```dart
builder: (context, child) {
  return LayoutBuilder(
    builder: (context, constraints) {
      if (constraints.maxWidth >= 768) {
        return const ZoomWrapper(
          child: HeroControllerScope.none(child: DesktopKanbanLayout()),
        );
      }
      return ZoomWrapper(child: child!);
    },
  );
},
```

### Change 2: `lib/shared/zoom_wrapper.dart` — Remove MediaQuery override

Remove the `MediaQuery` wrapper inside the `FittedBox` child. The child widgets (`Scaffold`, `Stack`, `Positioned.fill`) receive proper constraints from their parent `SizedBox` and don't need `MediaQuery` override for layout. The `FittedBox` handles visual scaling correctly.

Before:
```dart
child: FittedBox(
  fit: BoxFit.contain,
  child: SizedBox(
    width: childWidth,
    height: childHeight,
    child: MediaQuery(
      data: MediaQuery.of(context).copyWith(
        size: Size(childWidth, childHeight),
        textScaler: const TextScaler.linear(1.0),
      ),
      child: widget.child,
    ),
  ),
),
```

After:
```dart
child: FittedBox(
  fit: BoxFit.contain,
  child: SizedBox(
    width: childWidth,
    height: childHeight,
    child: widget.child,
  ),
),
```

### Why remove MediaQuery override?

The `MediaQuery` override is not needed for layout because:
- `Scaffold` receives bounded constraints from `SizedBox` and lays out children correctly via `Stack`/`Positioned.fill`/`Expanded`
- `SafeArea` (3 usages) is used inside bounded layout contexts
- `reply_input.dart` uses `MediaQuery.of(context).padding.bottom` for cosmetic spacing — original value is fine
- `feed_composer.dart` uses `MediaQuery.of(context).viewInsets.bottom` for keyboard — original value is correct

Removing it eliminates a potential source of conflict on web where `WidgetsApp`'s own `MediaQuery` and the override compete.

## Files to modify
- `lib/main.dart` — line 37-44: wrap builder body in `LayoutBuilder`, use `constraints.maxWidth`
- `lib/shared/zoom_wrapper.dart` — lines 72-84: remove `MediaQuery` wrapper, keep `FittedBox` → `SizedBox`

## Verification
1. `flutter build web --release`
2. `cd build/web && python3 -m http.server 8080`
3. Test mobile viewport (<768px): MainShell with feed, header, bottom nav — all have constrained height
4. Test desktop viewport (≥768px): kanban layout with columns
5. Test Ctrl+=/- zoom at both viewport sizes
