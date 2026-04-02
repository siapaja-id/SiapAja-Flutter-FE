# Plan: Port Settings Page & UI Improvements from React Commit 95d9f54

## Context

The React SiapAja project (commit `95d9f54`) added a **Settings page** with theme color, text size, and display zoom preferences, plus widespread UI improvements. This Flutter project currently has NO settings page, no dynamic theming, and no text scaling. The Flutter project already has Ctrl+scroll zoom via `ZoomWrapper`/`ZoomProvider`, but the zoom value is not persisted. We port all three settings sections: **theme color**, **text size**, and **zoom level**.

## Previous Work (Already Completed)

Steps 1–10 were already implemented:
- `pubspec.yaml` — `shared_preferences` added
- `lib/shared/settings_provider.dart` — ThemeColor/TextSize enums, SharedPreferences persistence
- `lib/shared/zoom_provider.dart` — SharedPreferences persistence for zoom
- `lib/app_theme.dart` — Dynamic `ThemeData` accepting ThemeColor/TextSize params
- `lib/features/settings/pages/settings_page.dart` — Settings UI with 3 sections
- `lib/app_router.dart` — `/settings` route
- `lib/features/feed/widgets/kanban_column_widget.dart` — `/settings` kanban routing
- `lib/features/feed/widgets/floating_sidebar.dart` — Settings nav item
- `lib/main.dart` — ConsumerWidget, dynamic theme, async init

## Remaining Work: 3 Regression Fixes

### Fix 1: Settings Color Labels
**Issue**: Flutter uses raw enum names (`red`, `blue`, `violet`) vs React's human-readable labels (`Crimson`, `Ocean`, `Amethyst`, `Emerald`, `Amber`).
**File**: `lib/features/settings/pages/settings_page.dart`
**Change**: Replace `entry.key.name` with a label map mapping enum → display name.

### Fix 2: Text Size Propagation (126 occurrences, 25 files)
**Issue**: The dynamic `TextTheme` in `app_theme.dart` is correctly defined but 126 hardcoded `fontSize:` values across 25 files won't respond when the user changes text size in settings. The React commit systematically replaced hardcoded pixel values with proportional CSS classes. Flutter needs the same treatment.

**Approach**:
1. Convert all 25 widget files to `ConsumerWidget` (or `ConsumerStatefulWidget` if already one). Each widget gets `textSize` via `ref.watch(settingsProvider.select((s) => s.textSize))`.
2. Add `AppTheme.scaled({TextSize textSize, double multiplier, FontWeight? weight, ...})` static method to `app_theme.dart`
3. Define named multiplier constants for all 15 distinct font sizes
4. Replace every `TextStyle(fontSize: X, ...)` with `AppTheme.scaled(textSize: textSize, multiplier: AppTheme.mXX, ...)`
5. For dynamic ternary expressions like `fontSize: isMain ? 16 : 13`, use ternary with `AppTheme.scaled(...)` on both branches

**ConsumerWidget conversion pattern** (per file):
```dart
// BEFORE:
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) { ... }
}

// AFTER:
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textSize = ref.watch(settingsProvider.select((s) => s.textSize));
    ...
  }
}
```

### Fix 3: Profile Settings Button (Cannot Fix)
The Flutter project has no profile page — only a `ScaffoldPageStub`. The React settings gear button on the profile cover area cannot be ported until a profile page is implemented. This is a known limitation, not a regression we can address.

---

## Detailed File Changes

### `lib/app_theme.dart` — Add scaled helper + multiplier constants

Add static constants and method:
```dart
static const double m3xs = 0.571;   // ~8
static const double m2xs = 0.643;   // ~9
static const double m2sm = 0.714;   // ~10
static const double m1sm = 0.786;   // ~11
static const double mxs = 0.857;    // ~12
static const double m13 = 0.929;    // ~13
static const double mbase = 1.0;    // ~14
static const double m15 = 1.071;    // ~15
static const double mlg = 1.143;    // ~16
static const double mxl = 1.286;    // ~18
static const double m2xl = 1.429;   // ~20
static const double m22 = 1.571;    // ~22
static const double m3xl = 1.714;   // ~24
static const double m26 = 1.857;    // ~26
static const double m28 = 2.0;      // ~28

static TextStyle scaled({
  TextSize textSize = TextSize.md,
  required double multiplier,
  FontWeight? weight,
  Color? color,
  double? letterSpacing,
  double? height,
  TextDecoration? decoration,
}) {
  return TextStyle(
    fontSize: _baseFontSize(textSize) * multiplier,
    fontWeight: weight,
    color: color,
    letterSpacing: letterSpacing,
    height: height,
    decoration: decoration,
  );
}
```

Each widget reads `textSize` from `ref.watch(settingsProvider.select((s) => s.textSize))`.

**Fix color labels**: Add a display name map to `AppColors`:
```dart
static const Map<ThemeColor, String> themeColorLabels = {
  ThemeColor.red: 'Crimson',
  ThemeColor.blue: 'Ocean',
  ThemeColor.emerald: 'Emerald',
  ThemeColor.violet: 'Amethyst',
  ThemeColor.amber: 'Amber',
};
```

---

### File-by-file replacement plan (25 files, 126 occurrences)

Each entry lists: **file → replacements** (current fontSize → multiplier, with any style adjustments)

#### `lib/features/settings/pages/settings_page.dart` (9 occurrences)
| Line | Current | Replace with |
|------|---------|-------------|
| 41 | `fontSize: 15, fontWeight: bold` | `AppTheme.scaled(textSize: textSize, multiplier: AppTheme.m15, weight: FontWeight.bold)` |
| 49 | `fontSize: 11` | `AppTheme.scaled(textSize: textSize, multiplier: AppTheme.m1sm)` |
| 135, 278, 360 | `fontSize: 16, fontWeight: w900` | `AppTheme.scaled(textSize: textSize, multiplier: AppTheme.mlg, weight: FontWeight.w900)` |
| 144, 287, 369 | `fontSize: 12, fontWeight: w500` | `AppTheme.scaled(textSize: textSize, multiplier: AppTheme.mxs, weight: FontWeight.w500)` |
| 432 | `fontSize: 14, fontWeight: bold` | `AppTheme.scaled(textSize: textSize, multiplier: AppTheme.mbase, weight: FontWeight.bold)` |

Also add: read `settingsProvider` to get `textSize` for the `scaled()` calls.

#### `lib/features/feed/widgets/floating_sidebar.dart` (3 occurrences)
| Line | Current | Replace with |
|------|---------|-------------|
| 180 | `fontSize: 12, fontWeight: bold` | `AppTheme.scaled(textSize: textSize, multiplier: AppTheme.mxs, weight: FontWeight.bold)` |
| 189 | `fontSize: 10, fontWeight: w900` | `AppTheme.scaled(textSize: textSize, multiplier: AppTheme.m2sm, weight: FontWeight.w900)` |
| 277 | `fontSize: 14, fontWeight: bold` | `AppTheme.scaled(textSize: textSize, multiplier: AppTheme.mbase, weight: FontWeight.bold)` |

#### `lib/features/feed/widgets/kanban_column_widget.dart` (2 occurrences)
| Line | Current | Replace with |
|------|---------|-------------|
| 389 | `fontSize: 11, fontWeight: w700` | `AppTheme.scaled(textSize: textSize, multiplier: AppTheme.m1sm, weight: FontWeight.w700)` |
| 417 | `fontSize: 9, fontWeight: w800` | `AppTheme.scaled(textSize: textSize, multiplier: AppTheme.m2xs, weight: FontWeight.w800)` |

#### `lib/features/feed/widgets/base_feed_card.dart` (6 occurrences)
| Line | Current | Replace with |
|------|---------|-------------|
| 288–292 | `fontSize: isParent ? 12 : isMain ? 15 : 13` | Ternary with `AppTheme.scaled(...)` |
| 308 | `fontSize: 12` | `AppTheme.scaled(textSize: textSize, multiplier: AppTheme.mxs)` |
| 333 | `fontSize: 8, fontWeight: w900` | `AppTheme.scaled(textSize: textSize, multiplier: AppTheme.m3xs, weight: FontWeight.w900)` |
| 355 | `fontSize: 12` | `AppTheme.scaled(textSize: textSize, multiplier: AppTheme.mxs)` |
| 419 | `fontSize: 11, fontWeight: bold` | `AppTheme.scaled(textSize: textSize, multiplier: AppTheme.m1sm, weight: FontWeight.bold)` |
| 528 | `fontSize: 9, fontWeight: w900` | `AppTheme.scaled(textSize: textSize, multiplier: AppTheme.m2xs, weight: FontWeight.w900)` |

#### `lib/features/feed/widgets/social_post_card.dart` (9 occurrences)
| Line | Current | Replace with |
|------|---------|-------------|
| 110 | `fontSize: 13` | `AppTheme.scaled(textSize: textSize, multiplier: AppTheme.m13)` |
| 122 | `fontSize: isMain ? 16 : 13` | Ternary with `AppTheme.scaled(...)` |
| 143 | `fontSize: 9, fontWeight: w800` | `AppTheme.scaled(textSize: textSize, multiplier: AppTheme.m2xs, weight: FontWeight.w800)` |
| 237, 246 | `fontSize: 10, fontWeight: w500` | `AppTheme.scaled(textSize: textSize, multiplier: AppTheme.m2sm, weight: FontWeight.w500)` |
| 319, 353, 382 | `fontSize: 10, fontWeight: w800` | `AppTheme.scaled(textSize: textSize, multiplier: AppTheme.m2sm, weight: FontWeight.w800)` |
| 329 | `fontSize: 20, fontWeight: w800` | `AppTheme.scaled(textSize: textSize, multiplier: AppTheme.m2xl, weight: FontWeight.w800)` |

#### `lib/features/feed/pages/task_main_content.dart` (20 occurrences)
| Line | Current | Replace with |
|------|---------|-------------|
| 114, 669, 713, 739 | `fontSize: 9, fontWeight: w900, letterSpacing` | `AppTheme.scaled(textSize: textSize, multiplier: AppTheme.m2xs, weight: FontWeight.w900, letterSpacing: X)` |
| 165 | `fontSize: 16, fontWeight: w900` | `AppTheme.scaled(textSize: textSize, multiplier: AppTheme.mlg, weight: FontWeight.w900)` |
| 188 | `fontSize: 13, fontWeight: w500` | `AppTheme.scaled(textSize: textSize, multiplier: AppTheme.m13, weight: FontWeight.w500)` |
| 211 | `fontSize: 28, fontWeight: w900` | `AppTheme.scaled(textSize: textSize, multiplier: AppTheme.m28, weight: FontWeight.w900)` |
| 277, 419, 474 | `fontSize: 10, fontWeight: w900, letterSpacing` | `AppTheme.scaled(textSize: textSize, multiplier: AppTheme.m2sm, weight: FontWeight.w900, letterSpacing: X)` |
| 308, 449, 909 | `fontSize: 11, fontWeight: w700` | `AppTheme.scaled(textSize: textSize, multiplier: AppTheme.m1sm, weight: FontWeight.w700)` |
| 323 | `fontSize: 26, fontWeight: w900` | `AppTheme.scaled(textSize: textSize, multiplier: AppTheme.m26, weight: FontWeight.w900)` |
| 437 | `fontSize: 18, fontWeight: w900` | `AppTheme.scaled(textSize: textSize, multiplier: AppTheme.mxl, weight: FontWeight.w900)` |
| 493, 723 | `fontSize: 14, fontWeight: w900/w700` | `AppTheme.scaled(textSize: textSize, multiplier: AppTheme.mbase, weight: FontWeight.w900/w700)` |
| 749 | `fontSize: 18, fontWeight: w900` | `AppTheme.scaled(textSize: textSize, multiplier: AppTheme.mxl, weight: FontWeight.w900)` |
| 779 | `fontSize: 14` | `AppTheme.scaled(textSize: textSize, multiplier: AppTheme.mbase)` |
| 803 | `fontSize: 10, fontWeight: w900` | `AppTheme.scaled(textSize: textSize, multiplier: AppTheme.m2sm, weight: FontWeight.w900)` |

#### `lib/features/feed/widgets/editorial_card.dart` (4 occurrences)
| Line | Current | Replace with |
|------|---------|-------------|
| (to audit) | `fontSize: 9, 12, 13` | Map to `m2xs`, `mxs`, `m13` |

#### `lib/features/feed/pages/create_reply_page.dart` (14 occurrences)
| Line | Current | Replace with |
|------|---------|-------------|
| (to audit) | `fontSize: 8, 10, 12, 14, 16, 18` | Map to `m3xs`, `m2sm`, `mxs`, `mbase`, `mlg`, `mxl` |

#### `lib/features/feed/widgets/task_card.dart` (10 occurrences)
| Line | Current | Replace with |
|------|---------|-------------|
| (to audit) | `fontSize: 9, 10, 11, 12, 13` | Map to `m2xs`, `m2sm`, `m1sm`, `mxs`, `m13` |

#### `lib/features/feed/pages/post_detail/bid_sheet.dart` (8 occurrences)
| Line | Current | Replace with |
|------|---------|-------------|
| (to audit) | `fontSize: 10, 12, 14, 20, 24, 48` | Map to `m2sm`, `mxs`, `mbase`, `m2xl`, `m3xl`, custom multiplier `3.429` |

#### `lib/features/feed/pages/post_detail/task_action_footer.dart` (6 occurrences)
| Line | Current | Replace with |
|------|---------|-------------|
| (to audit) | `fontSize: 11, 12, 13, 14` | Map to `m1sm`, `mxs`, `m13`, `mbase` |

#### `lib/features/feed/pages/post_detail/task_sliver_app_bar.dart` (5 occurrences)
| Line | Current | Replace with |
|------|---------|-------------|
| (to audit) | `fontSize: 9, 15, 20, 22` | Map to `m2xs`, `m15`, `m2xl`, `m22` |

#### `lib/features/feed/pages/post_detail/empty_replies_state.dart` (4 occurrences)
| Line | Current | Replace with |
|------|---------|-------------|
| (to audit) | `fontSize: 12, 14, 24` | Map to `mxs`, `mbase`, `m3xl` |

#### `lib/features/feed/pages/post_detail/completion_sheet.dart` (3 occurrences)
| Line | Current | Replace with |
|------|---------|-------------|
| (to audit) | `fontSize: 12, 14, 20` | Map to `mxs`, `mbase`, `m2xl` |

#### `lib/features/feed/pages/post_detail/review_sheet.dart` (2 occurrences)
| Line | Current | Replace with |
|------|---------|-------------|
| (to audit) | `fontSize: 14, 20` | Map to `mbase`, `m2xl` |

#### `lib/features/feed/pages/post_detail_page.dart` (4 occurrences)
| Line | Current | Replace with |
|------|---------|-------------|
| (to audit) | `fontSize: 9, 11, 15` | Map to `m2xs`, `m1sm`, `m15` |

#### `lib/features/feed/widgets/reply_input.dart` (3 occurrences)
| Line | Current | Replace with |
|------|---------|-------------|
| (to audit) | `fontSize: 12, 14` | Map to `mxs`, `mbase` |

#### `lib/features/feed/widgets/feed_composer.dart` (2 occurrences)
| Line | Current | Replace with |
|------|---------|-------------|
| (to audit) | `fontSize: 20` | Map to `m2xl` |

#### `lib/shared/widgets/map_preview.dart` (4 occurrences)
| Line | Current | Replace with |
|------|---------|-------------|
| (to audit) | `fontSize: 9, 13, 14` | Map to `m2xs`, `m13`, `mbase` |

#### `lib/shared/widgets/voice_note_player.dart` (2 occurrences)
| Line | Current | Replace with |
|------|---------|-------------|
| (to audit) | `fontSize: 10` | Map to `m2sm` |

#### `lib/shared/widgets/view_stats_badge.dart` (2 occurrences)
| Line | Current | Replace with |
|------|---------|-------------|
| (to audit) | `fontSize: 11` | Map to `m1sm` |

#### `lib/shared/widgets/rich_text_widget.dart` (1 occurrence)
| Line | Current | Replace with |
|------|---------|-------------|
| (to audit) | `fontSize: 12` | Map to `mxs` |

#### `lib/shared/widgets/primary_action_button.dart` (1 occurrence)
| Line | Current | Replace with |
|------|---------|-------------|
| (to audit) | `fontSize: 14` | Map to `mbase` |

#### `lib/shared/widgets/bottom_sheet_container.dart` (1 occurrence)
| Line | Current | Replace with |
|------|---------|-------------|
| (to audit) | `fontSize: 20` | Map to `m2xl` |

---

## Key Pattern for Replacement

Every file needs two changes:

### A. Convert to ConsumerWidget + import settings_provider
```dart
// Add import:
import '...settings_provider.dart';

// Change class:
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textSize = ref.watch(settingsProvider.select((s) => s.textSize));
    ...
  }
}
```

### B. Replace hardcoded TextStyle with AppTheme.scaled()
```dart
// BEFORE:
Text('Hello', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.onSurface))

// AFTER:
Text('Hello', style: AppTheme.scaled(textSize: textSize, multiplier: AppTheme.mxs, weight: FontWeight.w500, color: AppColors.onSurface))
```

For dynamic ternary fontSize:
```dart
// BEFORE:
fontSize: isMain ? 16 : 13

// AFTER:
style: isMain
    ? AppTheme.scaled(textSize: textSize, multiplier: AppTheme.mlg, ...)
    : AppTheme.scaled(textSize: textSize, multiplier: AppTheme.m13, ...)
```

---

## Files to Modify (25 + 1 theme = 26 total)

Each feature/shared file also needs: import `settings_provider.dart`, convert to `ConsumerWidget`, add `final textSize = ref.watch(settingsProvider.select((s) => s.textSize));` to build().

1. `lib/app_theme.dart` — Add `scaled()` method, multiplier constants, color label map
2. `lib/features/settings/pages/settings_page.dart` — Fix color labels (1 edit) + font sizes (9 edits)
3. `lib/features/feed/widgets/floating_sidebar.dart` (ConsumerStatefulWidget already — just add watch) (3 font size edits)
4. `lib/features/feed/widgets/kanban_column_widget.dart` (ConsumerStatefulWidget already — just add watch) (2 font size edits)
5. `lib/features/feed/widgets/base_feed_card.dart` (6 font size edits + ConsumerWidget conversion)
6. `lib/features/feed/widgets/social_post_card.dart` (9 font size edits + ConsumerWidget conversion)
7. `lib/features/feed/pages/task_main_content.dart` (20 font size edits + ConsumerWidget conversion)
8. `lib/features/feed/widgets/editorial_card.dart` (4 font size edits + ConsumerWidget conversion)
9. `lib/features/feed/pages/create_reply_page.dart` (14 font size edits + ConsumerWidget conversion)
10. `lib/features/feed/widgets/task_card.dart` (10 font size edits + ConsumerWidget conversion)
11. `lib/features/feed/pages/post_detail/bid_sheet.dart` (8 font size edits + ConsumerWidget conversion)
12. `lib/features/feed/pages/post_detail/task_action_footer.dart` (6 font size edits + ConsumerWidget conversion)
13. `lib/features/feed/pages/post_detail/task_sliver_app_bar.dart` (5 font size edits + ConsumerWidget conversion)
14. `lib/features/feed/pages/post_detail/empty_replies_state.dart` (4 font size edits + ConsumerWidget conversion)
15. `lib/features/feed/pages/post_detail/completion_sheet.dart` (3 font size edits + ConsumerWidget conversion)
16. `lib/features/feed/pages/post_detail/review_sheet.dart` (2 font size edits + ConsumerWidget conversion)
17. `lib/features/feed/pages/post_detail_page.dart` (4 font size edits + ConsumerWidget conversion)
18. `lib/features/feed/widgets/reply_input.dart` (3 font size edits + ConsumerWidget conversion)
19. `lib/features/feed/widgets/feed_composer.dart` (2 font size edits + ConsumerWidget conversion)
20. `lib/shared/widgets/map_preview.dart` (4 font size edits + ConsumerWidget conversion)
21. `lib/shared/widgets/voice_note_player.dart` (2 font size edits + ConsumerWidget conversion)
22. `lib/shared/widgets/view_stats_badge.dart` (2 font size edits + ConsumerWidget conversion)
23. `lib/shared/widgets/rich_text_widget.dart` (1 font size edit + ConsumerWidget conversion)
24. `lib/shared/widgets/primary_action_button.dart` (1 font size edit + ConsumerWidget conversion)
25. `lib/shared/widgets/bottom_sheet_container.dart` (1 font size edit + ConsumerWidget conversion)

## Verification
1. `flutter analyze` — 0 errors
2. Change text size in settings → all text in the app scales proportionally
3. Change theme color → accent color updates everywhere
4. Settings page color labels show "Crimson", "Ocean", etc. instead of "red", "blue"
