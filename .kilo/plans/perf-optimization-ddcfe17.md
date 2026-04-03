# Performance Optimization Plan — Fix lag introduced in ddcfe17

## Problem
Commit `ddcfe17` introduced significant lag. 30 widgets now watch `settingsProvider` for `textSize`, every `TextStyle` lost `const`, and `ThemeData` is rebuilt on every settings change.

## Root Causes
1. **30 `ref.watch(settingsProvider.select((s) => s.textSize))` calls** — every card/widget rebuilds when textSize changes
2. **Lost `const` constructors** — `AppTheme.scaled()` returns non-const TextStyle, breaking Flutter widget caching
3. **`SiapAjaApp` watches full `settingsProvider`** — `AppTheme.darkTheme()` recreates entire ThemeData on any settings change
4. **`zoomProvider._persist()` writes to disk on every zoom step** — Ctrl+scroll fires SharedPreferences I/O each step
5. **`async main()` blocks startup** — two `await` calls before `runApp()`

## Solution

### Fix 1: Replace per-widget textSize with global `MediaQuery` textScaler
**Impact: Highest** — eliminates 30 provider watches, restores const constructors

- In `SiapAjaApp.build()`, wrap child with `MediaQuery` that applies `TextScaler.linear(textSize scaleFactor)`
- Remove `ref.watch(settingsProvider.select((s) => s.textSize))` from ALL 30 widget locations
- Replace `AppTheme.scaled(textSize: textSize, multiplier: X, ...)` with standard `TextStyle(fontSize: X * 14)` or restore `const TextStyle(fontSize: N)` where applicable
- Keep `AppTheme.scaled()` only as a static helper that takes `multiplier` without `textSize` param (uses fixed base 14)
- Update `settingsProvider` — `setTextSize()` only changes state, triggering MediaQuery update in SiapAjaApp (no widget tree rebuild)

TextSize → scaleFactor mapping:
- `TextSize.sm` → 12/14 = 0.857
- `TextSize.md` → 1.0 (default)
- `TextSize.lg` → 16/14 = 1.143

### Fix 2: Cache ThemeData in SiapAjaApp
**Impact: Medium** — prevents full ThemeData recreation on unrelated settings changes

- Cache `ThemeData` in `SiapAjaApp.build()` keyed by `themeColor`
- Only rebuild ThemeData when `themeColor` actually changes
- textSize changes only affect MediaQuery, not ThemeData

### Fix 3: Debounce zoom persist
**Impact: Low-Medium** — removes disk I/O from zoom hot path

- Add `Timer? _persistTimer` to `ZoomNotifier`
- In `_persist()`, cancel previous timer and start a 500ms debounce
- Write to SharedPreferences only after user stops zooming

### Fix 4: Lazy init settings/zoom
**Impact: Low** — faster app startup

- Remove `await` calls from `main()`
- Initialize settings/zoom asynchronously after `runApp()` via `addPostFrameCallback`
- App starts with defaults immediately, settings applied when ready

### Fix 5: Simplify AppTheme.darkTheme()
- Change from method to getter+parameter pattern or memoize
- textSize no longer needs to be a parameter (handled by MediaQuery)

## Files to modify

### Core
- `lib/main.dart` — Add MediaQuery textScaler wrapper, cache ThemeData, lazy init
- `lib/app_theme.dart` — Remove textSize from scaled(), simplify darkTheme()
- `lib/shared/settings_provider.dart` — Keep as-is (settings state is fine)
- `lib/shared/zoom_provider.dart` — Add debounce timer

### Widgets (remove textSize watch, restore const TextStyle)
- `lib/features/feed/widgets/base_feed_card.dart`
- `lib/features/feed/widgets/social_post_card.dart`
- `lib/features/feed/widgets/task_card.dart`
- `lib/features/feed/widgets/editorial_card.dart`
- `lib/features/feed/widgets/feed_composer.dart`
- `lib/features/feed/widgets/floating_sidebar.dart`
- `lib/features/feed/widgets/kanban_column_widget.dart`
- `lib/features/feed/widgets/reply_input.dart`

### Pages (remove textSize watch)
- `lib/features/feed/pages/post_detail_page.dart`
- `lib/features/feed/pages/task_main_content.dart`
- `lib/features/feed/pages/create_reply_page.dart`
- `lib/features/feed/pages/post_detail/bid_sheet.dart`
- `lib/features/feed/pages/post_detail/completion_sheet.dart`
- `lib/features/feed/pages/post_detail/empty_replies_state.dart`
- `lib/features/feed/pages/post_detail/review_sheet.dart`
- `lib/features/feed/pages/post_detail/task_action_footer.dart`
- `lib/features/feed/pages/post_detail/task_sliver_app_bar.dart`

### Shared widgets (remove textSize watch)
- `lib/shared/widgets/bottom_sheet_container.dart`
- `lib/shared/widgets/map_preview.dart`
- `lib/shared/widgets/primary_action_button.dart`
- `lib/shared/widgets/rich_text_widget.dart`
- `lib/shared/widgets/view_stats_badge.dart`
- `lib/shared/widgets/voice_note_player.dart`

### Other
- `lib/features/feed/pages/main_shell.dart` — Keep themeColor watch (for gradient)
- `lib/features/feed/pages/desktop_kanban_layout.dart` — Keep themeColor watch (for gradient)
- `lib/features/settings/pages/settings_page.dart` — Keep full settings watch (it's the settings page)
- `lib/app_router.dart` — No changes needed

## Verification
- `flutter analyze` — no lint errors
- `flutter build linux` — builds successfully
- Manual: Ctrl+scroll zoom should feel smooth (debounced persist)
- Manual: Text size change in settings should update all text without full rebuild
- Manual: Theme color change should update colors smoothly
