# Text Scaling Awareness Plan

## Problem

The app has **81 inline `TextStyle(fontSize: ...)`** across 11 files, all hardcoded pixel values.
There is **zero usage** of `Theme.of(context).textTheme`, `MediaQuery`, `TextScaler`, or any accessibility handling.
The `TextTheme` in `app_theme.dart` is defined but **never consumed** by any widget.
Native system text scaling settings (Linux GNOME/GTK, web browser zoom, Android/iOS font size) are not properly handled.

## Approach

### Phase 1: Configure `MediaQuery` text scaling in `main.dart`

Add a `builder` to `MaterialApp.router` that wraps the app with explicit `MediaQuery` text scaling configuration:

- Respect system text scale factor (default Flutter behavior)
- Clamp scaling to a safe range (0.8x - 2.0x) to prevent layout breakage
- Works consistently across Linux desktop, web, and other platforms

```dart
// lib/main.dart — update MaterialApp.router:
MaterialApp.router(
  builder: (context, child) {
    final mediaQuery = MediaQuery.of(context);
    final constrainedScaler = mediaQuery.textScaler.clamp(
      minScaleFactor: 0.8,
      maxScaleFactor: 2.0,
    );
    return MediaQuery(
      data: mediaQuery.copyWith(textScaler: constrainedScaler),
      child: child!,
    );
  },
  // ... existing config
)
```

### Phase 2: Add missing TextTheme entries in `app_theme.dart`

The current `TextTheme` stops at `labelSmall` (11px). Several widgets use sizes 8-10px that have no theme mapping.
Add two custom TextTheme entries for small sizes:

| New style | Font size | Weight | Color |
|-----------|-----------|--------|-------|
| `labelTiny` | 10 | w500 | onSurfaceVariant |
| `labelMicro` | 8-9 | w800 | onSurface / primary |

### Phase 3: Migrate inline TextStyles to `Theme.of(context).textTheme`

Replace inline `TextStyle(fontSize: ...)` with `Theme.of(context).textTheme.*` across all 11 files.

**Size-to-style mapping:**

| Current inline size | Theme style |
|---|---|
| `fontSize: 32` | `displayLarge` |
| `fontSize: 28` | `displayMedium` |
| `fontSize: 24` | `displaySmall` |
| `fontSize: 20` | `headlineLarge` |
| `fontSize: 18` | `headlineMedium` |
| `fontSize: 16` (bold) | `headlineSmall` / `titleLarge` |
| `fontSize: 16` (regular) | `bodyLarge` |
| `fontSize: 14` (bold/w500) | `titleMedium` / `labelLarge` |
| `fontSize: 14` (regular) | `bodyMedium` |
| `fontSize: 13` | `bodyMedium` (approximate) |
| `fontSize: 12` (bold/w500) | `titleSmall` / `labelMedium` |
| `fontSize: 12` (regular) | `bodySmall` |
| `fontSize: 11` | `labelSmall` |
| `fontSize: 10` | `labelTiny` (new) |
| `fontSize: 9` | `labelMicro` (new) |
| `fontSize: 8` | `labelMicro` (new) |

**Migration pattern:**

Before:
```dart
Text(
  'Status',
  style: const TextStyle(
    color: AppColors.primary,
    fontSize: 9,
    fontWeight: FontWeight.w800,
    letterSpacing: 1,
  ),
),
```

After:
```dart
Text(
  'Status',
  style: Theme.of(context).textTheme.labelMicro?.copyWith(
    color: AppColors.primary,
    letterSpacing: 1,
  ),
),
```

### Phase 4: Fix `maxLines` overflow risks

Several widgets use `maxLines: 1` with `TextOverflow.ellipsis` inside potentially fixed-size containers.
Verify no `SizedBox` or `Container` with fixed `height` wraps text — those would clip when scaled up.

## Files to modify (in order)

1. **`lib/main.dart`** — Add `MediaQuery` text scaling configuration (1 change)
2. **`lib/app_theme.dart`** — Add `labelTiny` and `labelMicro` TextTheme entries (2 additions)
3. **`lib/features/feed/widgets/task_card.dart`** — 19 TextStyle migrations
4. **`lib/features/feed/widgets/social_post_card.dart`** — 17 TextStyle migrations
5. **`lib/features/feed/widgets/editorial_card.dart`** — 11 TextStyle migrations
6. **`lib/features/feed/widgets/feed_composer.dart`** — 7 TextStyle migrations
7. **`lib/shared/widgets/rich_text_widget.dart`** — 4 TextStyle migrations
8. **`lib/shared/widgets/post_actions.dart`** — 2 TextStyle migrations
9. **`lib/features/feed/pages/feed_page.dart`** — 2 TextStyle migrations
10. **`lib/shared/widgets/expandable_text.dart`** — 2 TextStyle migrations
11. **`lib/app_router.dart`** — 1 TextStyle migration
12. **`lib/features/feed/pages/main_shell.dart`** — 1 TextStyle migration

## Verification

- Run `flutter analyze` after each phase
- Test on web (`flutter run -d chrome`) with browser zoom at 125%, 150%, 200%
- Test on Linux desktop with system font scaling set to 1.25x, 1.5x
- Verify no text overflow or clipping at max scale factor (2.0x)
- Check `maxLines: 1` widgets still truncate gracefully with ellipsis

## Impact

- **81 inline TextStyles** migrated to theme-based styles
- **11 files** modified
- **2 new TextTheme entries** added (`labelTiny`, `labelMicro`)
- System text scaling fully respected across Linux, web, and all platforms
