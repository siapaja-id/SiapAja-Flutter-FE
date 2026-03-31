# Fix: FractionallySizedBox infinite-width crash + Offstage still mounting child

## Problem
Two remaining issues cause the app to crash on startup on desktop:

1. **`feed_page.dart:535` — `FractionallySizedBox` gets infinite width**
   - `_TabBar` uses `AnimatedPositioned(left: 0, bottom: 0)` inside a `Stack`
   - `AnimatedPositioned` with only `left`/`bottom` passes unconstrained width to its child
   - `FractionallySizedBox(widthFactor: 0.5)` computes `infinity * 0.5 = infinity`
   - Its child `Center` (RenderPositionedBox) receives `BoxConstraints(w=Infinity)` → assertion failure
   - This cascades into `debugFrameWasSentToEngine` and `!semantics.parentDataDirty`

2. **`main.dart` — `Offstage` still mounts child widget tree**
   - `Offstage(off: true)` still calls `child.layout(constraints)` — the entire child tree builds
   - GoRouter Navigator → MainShell → FeedPage → `_TabBar` all build on desktop
   - The crash from #1 fires during the warm-up frame before `sendFramesToEngine` can run

## Changes

### Change 1: Replace `FractionallySizedBox` with `Container(width: double.infinity)`
**File:** `lib/features/feed/pages/feed_page.dart` (line 535)

Replace:
```dart
child: FractionallySizedBox(
  widthFactor: 1 / tabs.length,
  child: Center(
    child: Container(
      height: 2,
      width: 40,
      ...
    ),
  ),
),
```

With:
```dart
child: Center(
  child: Container(
    height: 2,
    width: double.infinity,
    ...
  ),
),
```

`Center` + `Container(width: double.infinity)` fills the available tab width exactly — no fractional width factor needed. `Center` constrains the infinite width to its own constraints (from the tab position), which is the same visual result as `FractionallySizedBox(widthFactor: 0.5)`.

### Change 2: Remove `Offstage`/`SizedBox` wrapper, skip child on desktop
**File:** `lib/main.dart` (line 29)

Replace:
```dart
builder: (context, child) {
  return LayoutBuilder(
    builder: (context, constraints) {
      if (constraints.maxWidth >= 768) {
        return ZoomWrapper(
          child: Stack(
            children: [
              Offstage(child: SizedBox(child: child)),
              const DesktopKanbanLayout(),
            ],
          ),
        );
      }
      return ZoomWrapper(child: child!);
    },
  );
},
```

With:
```dart
builder: (context, child) {
  return LayoutBuilder(
    builder: (context, constraints) {
      if (constraints.maxWidth >= 768) {
        return const ZoomWrapper(
          child: DesktopKanbanLayout(),
        );
      }
      return ZoomWrapper(child: child!);
    },
  );
},
```

On desktop, the GoRouter Navigator child is never mounted — its widget tree never builds. The `DesktopKanbanLayout` has its own routing via `_ColumnBody` which creates per-column `Navigator` widgets. No child, no crash.

## Verification
1. `flutter run -d linux` — app should launch without errors
2. Open/close columns — no crash
3. Resize columns — smooth, no assertion errors
4. Switch tabs in column headers — no crash
5. Mobile layout (width < 768) — still works as before
