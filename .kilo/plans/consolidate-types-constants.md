# Plan: Consolidate Types, Constants, and Eliminate Dynamic Types in Flutter

## Overview

This plan mirrors the React commit `7306585` ("refactor: consolidate types, constants, and eliminate any types") applied to the Flutter project. The goal is to improve type safety, reduce code duplication, and centralize shared definitions without any UI/UX regressions.

## Changes

### 1. Create `lib/shared/types/` Directory

#### 1a. `lib/shared/types/route_state.dart` — Typed Route State Model
**Problem**: `KanbanColumn.routeState` and `KanbanColumnContext.routeState` use `Map<String, dynamic>?`, and user profile data is constructed inline with string keys in 3 places (feed_page.dart x2, floating_sidebar.dart).

**Solution**: Create a typed `ProfileRouteState` model:
```dart
class ProfileRouteState {
  final String name;
  final String handle;
  final String avatar;
  final int karma;
  final bool isOnline;
  const ProfileRouteState({required this.name, required this.handle, required this.avatar, required this.karma, required this.isOnline});
}
```

#### 1b. `lib/shared/types/feed_item_context_type.dart` — FeedItem Context Type
**Problem**: The `isMain`, `isParent`, `isQuote`, `hasLineBelow` booleans are passed individually to `BaseFeedCard` but represent a cohesive context concept (matching React's `FeedItemContextType`).

**Solution**: Extract a class to group these:
```dart
class FeedItemContextType {
  final bool isMain;
  final bool isParent;
  final bool isQuote;
  final bool hasLineBelow;
  const FeedItemContextType({required this.isMain, required this.isParent, required this.isQuote, required this.hasLineBelow});
}
```

### 2. Enhance `lib/shared/constants/` Directory

#### 2a. `lib/shared/constants/app_constants.dart` — Centralized Constants
**Problem**: Storage keys are scattered and private (`_keyZoom` in zoom_provider.dart, `_keyThemeColor`/`_keyTextSize` in settings_provider.dart). `_navItems` is duplicated in main_shell.dart and floating_sidebar.dart.

**Solution**: Create shared constants file:
```dart
// Storage keys
const String kStorageKeyZoom = 'siapaja-zoom';
const String kStorageKeyThemeColor = 'siapaja-theme-color';
const String kStorageKeyTextSize = 'siapaja-text-size';

// Validation arrays (matching React's VALID_* arrays)
const List<ThemeColor> kValidThemeColors = [ThemeColor.red, ThemeColor.blue, ThemeColor.emerald, ThemeColor.violet, ThemeColor.amber];
const List<TextSize> kValidTextSizes = [TextSize.sm, TextSize.md, TextSize.lg];
const List<double> kValidZoomLevels = [0.9, 1.0, 1.1, 1.2];

// Navigation items (shared between MainShell and FloatingSidebar)
const List<NavItem> kNavItems = [...];
```

#### 2b. Update consumers to use shared constants
- `settings_provider.dart`: Use `kStorageKeyThemeColor`, `kStorageKeyTextSize`
- `zoom_provider.dart`: Use `kStorageKeyZoom`
- `main_shell.dart`: Use `kNavItems`
- `floating_sidebar.dart`: Use `kNavItems` (remove duplicate)

### 3. Move `KanbanColumnContext` to `lib/shared/contexts/`

#### 3a. Create `lib/shared/contexts/kanban_column_context.dart`
**Problem**: `KanbanColumnContext` is defined inside `kanban_column_widget.dart` (a feature-level widget), but it's consumed by `post_detail_page.dart` and `base_feed_card.dart` across features.

**Solution**: Move to shared contexts:
```dart
class KanbanColumnContext extends InheritedWidget {
  final String columnId;
  final String path;
  final ProfileRouteState? routeState;  // Typed instead of Map<String, dynamic>
  // ... same static of() and updateShouldNotify
}
```

#### 3b. Update imports in:
- `lib/features/feed/widgets/kanban_column_widget.dart` — import from shared/contexts
- `lib/features/feed/pages/post_detail_page.dart` — import from shared/contexts
- `lib/features/feed/widgets/base_feed_card.dart` — import from shared/contexts

### 4. Replace `Map<String, dynamic>` with Typed Models

#### 4a. Update `lib/models/kanban_column.dart`
Change `routeState` from `Map<String, dynamic>?` to `ProfileRouteState?`:
```dart
@freezed
abstract class KanbanColumn with _$KanbanColumn {
  const factory KanbanColumn({
    required String id,
    required String path,
    @Default(420) double width,
    ProfileRouteState? routeState,  // Was Map<String, dynamic>?
    int? activeTab,
  }) = _KanbanColumn;
}
```

#### 4b. Update `lib/features/feed/viewmodels/kanban_viewmodel.dart`
Change `openColumn` signature:
```dart
void openColumn(String path, {String? sourceId, ProfileRouteState? routeState}) {
  // ...
}
```

#### 4c. Update routeState construction sites
- `lib/features/feed/pages/feed_page.dart` (lines 233-243, 265-275): Replace inline map with `ProfileRouteState(...)`
- `lib/features/feed/widgets/floating_sidebar.dart` (lines 136-146): Replace inline map with `ProfileRouteState(...)`

#### 4d. Update routeState consumption sites
- `lib/features/feed/widgets/kanban_column_widget.dart` (line 60): Change `routeState?['user']?['name'] as String?` to `routeState?.name`
- `lib/features/feed/widgets/kanban_column_widget.dart` (line 272-274): Same change in _ColumnHeader

### 5. Fix `dynamic` Usages

#### 5a. `lib/features/feed/pages/post_detail_page.dart` line 414
**Problem**: `_buildBottomBar(FeedItem item, bool isCreator, currentUser)` — `currentUser` has no type annotation (implicit `dynamic`).

**Solution**: Add explicit type:
```dart
Widget _buildBottomBar(FeedItem item, bool isCreator, Author? currentUser) {
```

### 6. Run Build Runner and Verify

After all changes:
```bash
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
```

## File Change Summary

| File | Change |
|------|--------|
| `lib/shared/types/route_state.dart` | **NEW** — ProfileRouteState model |
| `lib/shared/types/feed_item_context_type.dart` | **NEW** — FeedItemContextType class |
| `lib/shared/constants/app_constants.dart` | **NEW** — Storage keys, validation arrays, shared nav items |
| `lib/shared/contexts/kanban_column_context.dart` | **NEW** — Moved from kanban_column_widget.dart |
| `lib/models/kanban_column.dart` | **MODIFY** — routeState: Map<String,dynamic>? → ProfileRouteState? |
| `lib/features/feed/viewmodels/kanban_viewmodel.dart` | **MODIFY** — openColumn param type |
| `lib/features/feed/widgets/kanban_column_widget.dart` | **MODIFY** — Import context from shared, use typed routeState |
| `lib/features/feed/widgets/base_feed_card.dart` | **MODIFY** — Import context from shared |
| `lib/features/feed/pages/post_detail_page.dart` | **MODIFY** — Import context from shared, fix dynamic param |
| `lib/features/feed/pages/feed_page.dart` | **MODIFY** — Use ProfileRouteState instead of inline maps |
| `lib/features/feed/widgets/floating_sidebar.dart` | **MODIFY** — Use ProfileRouteState, shared nav items |
| `lib/features/feed/pages/main_shell.dart` | **MODIFY** — Use shared nav items |
| `lib/shared/settings_provider.dart` | **MODIFY** — Use shared storage key constants |
| `lib/shared/zoom_provider.dart` | **MODIFY** — Use shared storage key constant |

## No UI/UX Changes

All changes are purely structural refactoring — no visual or behavioral changes. The same widgets, colors, animations, and interactions remain intact.
