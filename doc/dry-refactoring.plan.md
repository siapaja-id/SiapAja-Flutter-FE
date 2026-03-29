# DRY Refactoring Plan — SiapAja Flutter FE

## Context
The codebase has ~1,200 lines of duplicated code across the feed card widgets. Three card types (`SocialPostCard`, `TaskCard`, `EditorialCard`) each contain private copies of `_BaseFeedCard`, `_HoverWrapper`, `_FollowButton`, `_GlassCard`, and `_FirstTaskBadge`. Hardcoded color literals are scattered instead of using `AppColors` constants. Utility logic (`_formatCount`, set-toggle pattern) is also duplicated.

**Goal:** Extract all shared widgets to `lib/shared/widgets/`, consolidate color constants, deduplicate utility logic. Target: **~1,200 fewer lines**.

---

## Step 1: Add missing color constants to `AppColors`

**File:** `lib/app_theme.dart`

Add these constants (currently hardcoded as `Color()` literals throughout the codebase):

```dart
static const Color borderWhite10 = Color(0x1AFFFFFF);  // used 30+ times
static const Color borderWhite5  = Color(0x0DFFFFFF);  // divider color
static const Color hoverQuote   = Color(0x0AFFFFFF);   // quote hover
static const Color hoverThread  = Color(0x05FFFFFF);   // thread hover
static const Color hoverDefault = Color(0x66121212);   // default hover
static const Color quoteBg      = Color(0x05FFFFFF);   // quote background
static const Color emerald400   = Color(0xFF34D399);   // used in bid card
static const Color blue500      = Color(0xFF3B82F6);   // reply hover
static const Color purple500    = Color(0xFF8B5CF6);   // share hover
```

**Impact:** Eliminates 30+ hardcoded `Color()` literals across 6 files.

---

## Step 2: Create `lib/shared/widgets/feed_card_base.dart`

Extract 5 shared widgets into a single new file:

### 2a. `HoverWrapper` (public)
- Source: identical in all 3 card files
- Make it public (remove `_` prefix) so it's importable

### 2b. `FollowButton` (public)
- Source: identical in all 3 card files
- Make it public

### 2c. `GlassCard` (public)
- Source: identical in `task_card.dart` and `editorial_card.dart`
- Make it public

### 2d. `FirstTaskBadge` (public)
- Source: identical in `social_post_card.dart` and `task_card.dart`
- Make it public

### 2e. `BaseFeedCard` (public)
- Source: the ~270-line widget duplicated in all 3 card files
- Consolidate the minor differences:
  - `_FirstPostBadge` check (only in `social_post_card.dart`) → already handled via `data is SocialPostData`
  - `_FirstTaskBadge` check (in `social_post_card.dart` and `task_card.dart`) → already handled since `FirstTaskBadge` is now shared
- Replace all hardcoded colors with `AppColors.*` constants from Step 1

**File structure:**
```
lib/shared/widgets/feed_card_base.dart  (~300 lines, replaces ~1,200 duplicated lines)
```

---

## Step 3: Refactor the 3 card files to use shared widgets

### `social_post_card.dart` (837 → ~280 lines)
- Remove: `_BaseFeedCard`, `_HoverWrapper`, `_FollowButton`, `_FirstTaskBadge` classes
- Import: `feed_card_base.dart`
- Keep: `SocialPostCard`, `_BidCard`, `_FirstPostBadge` (unique to this file)
- Replace hardcoded colors with `AppColors.*`

### `task_card.dart` (795 → ~280 lines)
- Remove: `_BaseFeedCard`, `_HoverWrapper`, `_FollowButton`, `_GlassCard`, `_FirstTaskBadge` classes
- Import: `feed_card_base.dart`
- Keep: `TaskCard` (including `_buildMapPreview`, `_getStatusText`)
- Replace hardcoded colors with `AppColors.*`

### `editorial_card.dart` (491 → ~120 lines)
- Remove: `_BaseFeedCard`, `_HoverWrapper`, `_FollowButton`, `_GlassCard` classes
- Import: `feed_card_base.dart`
- Keep: `EditorialCard` only
- Replace hardcoded colors with `AppColors.*`

---

## Step 4: Deduplicate `_formatCount` in `post_actions.dart`

**File:** `lib/shared/widgets/post_actions.dart`

Extract to a top-level function in the same file:
```dart
String formatCount(int count) {
  if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}k';
  return count.toString();
}
```
- Remove the local `formatCount` in `PostActions.build()` (line 33-38)
- Remove `_ActionButton._formatCount()` (line 140-145)
- Replace inline formatting in `_VotePill.build()` (line 209-211)
- All 3 call sites use the single function

**Impact:** ~15 lines removed, single source of truth.

---

## Step 5: Deduplicate toggle logic in `app_viewmodel.dart`

**File:** `lib/features/feed/viewmodels/app_viewmodel.dart`

Extract a private helper:
```dart
Set<String> _toggleInSet(Set<String> set, String id) {
  final newSet = Set<String>.from(set);
  if (newSet.contains(id)) {
    newSet.remove(id);
  } else {
    newSet.add(id);
  }
  return newSet;
}
```

Simplify `toggleRepost` and `toggleFollow`:
```dart
void toggleRepost(String feedItemId) {
  state = state.copyWith(userReposts: _toggleInSet(state.userReposts, feedItemId));
}

void toggleFollow(String handle) {
  state = state.copyWith(followedHandles: _toggleInSet(state.followedHandles, handle));
}
```

**Impact:** ~10 lines removed, single toggle pattern.

---

## Step 6: Replace hardcoded colors in remaining shared widgets

**Files to update:**
- `lib/shared/widgets/user_avatar.dart` — replace `Color(0x1AFFFFFF)`, `Color(0xFF10B981)`
- `lib/shared/widgets/post_actions.dart` — replace `Color(0x1AFFFFFF)`, `Color(0x0DFFFFFF)`, `Color(0xFFF97316)`, `Color(0xFF6366F1)`, `Color(0xFF10B981)`, `Color(0xFF3B82F6)`, `Color(0xFF8B5CF6)`
- `lib/features/feed/widgets/feed_composer.dart` — replace `Color(0x1AFFFFFF)`, `Color(0xFFDC2626)`
- `lib/shared/widgets/rich_text_widget.dart` — replace `Color(0xFF34D399)`
- `lib/app_theme.dart` (CardThemeData) — replace `Color(0x1AFFFFFF)`

---

## Verification

1. Run `flutter analyze` — must pass with zero errors
2. Run `flutter build apk --debug` or `flutter run` — must compile successfully
3. Visual spot-check: feed cards render identically (hover, badges, follow button, actions)

---

## Summary of changes

| File | Before (lines) | After (lines) | Delta |
|---|---|---|---|
| `shared/widgets/feed_card_base.dart` | 0 (new) | ~300 | +300 |
| `social_post_card.dart` | 837 | ~280 | -557 |
| `task_card.dart` | 795 | ~280 | -515 |
| `editorial_card.dart` | 491 | ~120 | -371 |
| `post_actions.dart` | 251 | ~240 | -11 |
| `app_viewmodel.dart` | 115 | ~108 | -7 |
| `app_theme.dart` | 186 | ~196 | +10 |
| `user_avatar.dart` | ~90 | ~88 | -2 |
| `feed_composer.dart` | ~400 | ~396 | -4 |
| `rich_text_widget.dart` | ~180 | ~178 | -2 |
| **Net** | **~3,345** | **~2,086** | **~-1,259** |
