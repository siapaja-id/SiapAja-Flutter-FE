# Plan: Replace Manual Kanban Implementations with Official Flutter Widgets

## Context
The desktop kanban feature has numerous manual implementations of interactions and animations that duplicate functionality already provided by Flutter's widget library. This increases code complexity, maintenance burden, and risk of bugs. The scope covers all untracked kanban files and modified files visible in `git status`.

## Changes

### 1. Column Resizer: `Listener` → `GestureDetector` (`kanban_column_widget.dart`)
**Current:** Raw `Listener` with `onPointerDown`, `onPointerMove`, `onPointerUp` tracking `_resizeStartX` and `_resizeStartWidth` manually (lines 95-117, 202-219).

**Replace with:** `GestureDetector(onHorizontalDragStart: ..., onHorizontalDragUpdate: ..., onHorizontalDragEnd: ...)`. Remove manual `_resizeStartX`/`_resizeStartWidth` tracking — `GestureDetector` provides `DragUpdateDetails.delta` directly.

### 2. Column Enter Animation: Manual `AnimationController` → `AnimatedSwitcher` (`desktop_kanban_layout.dart`)
**Current:** `_AnimatedColumn` with `AnimationController`, `AnimatedBuilder`, `Opacity`, `Transform.translate`, `Transform.scale` — 60+ lines (lines 134-214).

**Replace with:** `AnimatedSwitcher` with a `CustomTransitionBuilder` that combines `FadeTransition` + `SlideTransition` + `ScaleTransition`. Alternatively, use a simple `_EnterTransition` widget wrapping `FadeTransition` + `SlideTransition` (the scale is barely noticeable at 0.95→1.0). This eliminates the manual controller and callback pattern.

### 3. Card Hover Glow: Manual `AnimationController` → Simplify (`base_feed_card.dart`)
**Current:** `InteractiveFeedCard` with `_glowCtrl` (`AnimationController` that `repeat()`s on hover), manual `_isHovering`/`_isPressed` state, `AnimatedBuilder` driving a shimmer gradient (lines 17-157).

**Replace with:** Remove the glow `AnimationController` and shimmer entirely. Use a simpler pattern: `MouseRegion` + `GestureDetector` + `AnimatedContainer` driven by `_isHovering`/`_isPressed` booleans. The animated gradient border + scale effect is preserved; only the moving shimmer line is removed. This eliminates ~50 lines and the `SingleTickerProviderStateMixin`.

### 4. Tab Row: Custom `_TabRow`/`_TabItem` → Flutter `TabBar` (`feed_page.dart`)
**Current:** Custom `_TabRow` with `Stack` + manual `AnimatedContainer` sliding underline + `_TabItem` with `AnimatedDefaultTextStyle` (lines 459-557).

**Replace with:** Use `TabBar` with `TabBarTheme` for custom styling (transparent indicator, custom label style). The `TabController` is already used — only the visual `TabBar` widget replaces the custom tab row. Remove `_TabRow` and `_TabItem` classes entirely.

### 5. Close Button: Over-complicated → `IconButton` (`kanban_column_widget.dart`)
**Current:** `GestureDetector` → `AnimatedScale` → `Container` → `MouseRegion` → `Icon` (lines 322-345).

**Replace with:** `MouseRegion(cursor: SystemMouseCursors.click, child: IconButton(...))`. Remove the wrapping `GestureDetector`, `AnimatedScale` (scale is always 1.0 so it does nothing), and extra `Container`.

### 6. Nav Buttons: `MouseRegion`+`GestureDetector`+`AnimatedContainer` → `InkWell` (`floating_sidebar.dart`)
**Current:** `_NavButton` uses `MouseRegion(cursor)` + `GestureDetector(onTap)` + `AnimatedContainer` (lines 222-298).

**Replace with:** `InkWell(onTap: ..., borderRadius: ..., child: ...)` which provides cursor, tap feedback, and hover automatically. Keep `AnimatedContainer` for width/expand animation. Remove explicit `MouseRegion` + `GestureDetector`.

### 7. Add Column Button: Manual hover → `InkWell` (`desktop_kanban_layout.dart`)
**Current:** `_AddColumnButton` with `MouseRegion` + `GestureDetector` + `AnimatedContainer` + `AnimatedRotation` (lines 217-267).

**Replace with:** `InkWell` with `onTap` and `onHover` for cursor feedback, simplify to `AnimatedContainer` + `AnimatedRotation` driven by hover state. Remove explicit `MouseRegion` + `GestureDetector`.

### 8. Horizontal Scroll: Add `Scrollbar` (`desktop_kanban_layout.dart`)
**Current:** `SingleChildScrollView` with no visual scroll indicator.

**Replace with:** Wrap `SingleChildScrollView` with `Scrollbar(controller: _scrollController)` to show a horizontal scrollbar for desktop users.

### 9. Column Navigation: If/else chain → Map lookup (`kanban_column_widget.dart`)
**Current:** `_buildPageForRoute()` uses sequential `if/else` with path checks (lines 373-407).

**Replace with:** `final _routeBuilders = <String, Widget Function(String)>{...}` map with `path.startsWith` entries handled separately. Clean up the method to use map lookup.

## Files Modified
- `lib/features/feed/widgets/kanban_column_widget.dart` (items 1, 5, 9)
- `lib/features/feed/pages/desktop_kanban_layout.dart` (items 2, 7, 8)
- `lib/features/feed/widgets/base_feed_card.dart` (item 3)
- `lib/features/feed/pages/feed_page.dart` (item 4)
- `lib/features/feed/widgets/floating_sidebar.dart` (item 6)

## Verification
1. Run `flutter analyze` to check for errors
2. Visual test: Resize columns, open/close columns, hover cards, switch tabs
3. Ensure column enter animation still appears (slide+fade)
4. Ensure scrollbar appears on desktop scroll area
