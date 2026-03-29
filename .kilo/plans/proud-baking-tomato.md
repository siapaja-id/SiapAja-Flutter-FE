# Feed Page Refactoring Plan

## Overview
Refactor the feed page to reduce manual implementations by using official Flutter widgets, eliminate code duplication, and improve maintainability.

## Context
The feed page has ~2,500+ lines of code with significant duplication (`_BaseFeedCard`, `_HoverWrapper`, `_FollowButton`, `_GlassCard` are each duplicated 3 times). Custom tab and navigation implementations replace official Flutter widgets that provide built-in accessibility, animations, and theming.

---

## Phase 1: Extract Shared Widgets (Eliminate Duplication)

### Step 1.1: Create `lib/features/feed/widgets/base_feed_card.dart`
- Extract `_BaseFeedCard` from `social_post_card.dart`, `task_card.dart`, `editorial_card.dart` into a single public file
- Also extract `_HoverWrapper` and `_FollowButton` into this file
- Also extract `_FirstPostBadge` and `_FirstTaskBadge` into this file
- Export these as public classes (`BaseFeedCard`, `HoverWrapper`, `FollowButton`, `FirstPostBadge`, `FirstTaskBadge`)
- Use `VerticalDivider` instead of manual `Container(width: 1.5)` for thread lines

### Step 1.2: Create `lib/features/feed/widgets/glass_card.dart`
- Extract `_GlassCard` from `task_card.dart` and `editorial_card.dart` into a single shared file
- Use Flutter's `Card` widget with custom `shape` and `color` instead of `Container` + `BoxDecoration`

### Step 1.3: Update card files to import shared widgets
- `social_post_card.dart`: Remove `_BaseFeedCard`, `_HoverWrapper`, `_FollowButton`, `_FirstPostBadge` — import from shared
- `task_card.dart`: Remove `_BaseFeedCard`, `_HoverWrapper`, `_FollowButton`, `_FirstTaskBadge`, `_GlassCard` — import from shared
- `editorial_card.dart`: Remove `_BaseFeedCard`, `_HoverWrapper`, `_FollowButton`, `_GlassCard` — import from shared

---

## Phase 2: Replace Custom Bottom Navigation with `NavigationBar`

### Step 2.1: Update `main_shell.dart`
- Replace `_BottomNavBar` (manual `Row` + `_NavButton` + `BackdropFilter`) with Flutter's `NavigationBar` widget
- Remove `dart:ui` import (no longer needed for `ImageFilter`)
- Use `NavigationBar.destinations` with 5 items (Home, Explore, Create, Messages, Orders)
- Use `selectedIndex` derived from `currentPath`
- Use `onDestinationSelected` to navigate with `context.go()`
- Create action button for "Create" using `FloatingActionButton` or keep it as a nav destination with custom icon
- Remove `_NavButton` class entirely
- Remove `Stack`-based positioning — use standard `Scaffold` with `bottomNavigationBar`

---

## Phase 3: Replace Custom Tabs with `TabBar`

### Step 3.1: Update `feed_page.dart`
- Replace `_TabRow` and `_TabItem` classes with Flutter's `TabBar` + `TabController`
- Use `TabController` in a `StatefulWidget` or `TickerProviderStateMixin`
- Use `TabBar` with `Tab` widgets for "For You" and "Around You"
- Configure `TabBar` indicator color, weight, and shape to match current design (primary color, 2px height, rounded top corners)
- Keep glow/shadow effect on indicator via `indicatorShadow` or custom `BoxShadow` in `decoration`
- Remove `_TabRow` and `_TabItem` classes (~60 lines removed)

---

## Phase 4: Replace Composer Fullscreen with `showModalBottomSheet`

### Step 4.1: Update `feed_composer.dart`
- Replace the manual fullscreen expansion (`_isFullscreen`, `AnimatedContainer`, `AnimatedOpacity`, `IgnorePointer`, backdrop overlay) with `showModalBottomSheet`
- Use `showModalBottomSheet` with `isScrollControlled: true` and `backgroundColor: Colors.transparent` for custom styling
- The "expand" attachment button (`arrowsOutCardinal`) triggers `showModalBottomSheet` instead of setting `_isFullscreen`
- The bottom sheet contains the fullscreen composer content (header, text field, action bar)
- Remove `_isFullscreen` state variable, backdrop overlay `AnimatedOpacity`, and `IgnorePointer`
- Remove the `Stack` wrapper — the composer is always compact, fullscreen is in a sheet
- This eliminates ~50 lines of manual animation/overlay code

### Step 4.2: Replace `_AttachmentButton` with `IconButton`
- Replace `_AttachmentButton` (custom `GestureDetector` + `Container`) with Flutter's `IconButton`
- Use `IconButton.styleFrom` to customize `backgroundColor`, `padding`, `shape`
- Remove `_AttachmentButton` class (~30 lines)

---

## Phase 5: Add Pull-to-Refresh

### Step 5.1: Update `feed_page.dart`
- Wrap `ListView.builder` with `RefreshIndicator`
- Implement `onRefresh` callback that calls `ref.read(feedNotifierProvider.notifier).refresh()`
- Use `RefreshIndicator`'s built-in loading indicator styling

### Step 5.2: Update `feed_viewmodel.dart`
- Add `refresh()` method to `FeedNotifier` that simulates fetching new data
- Use the existing `isLoading` state that is currently unused

---

## Phase 6: Improve `post_actions.dart`

### Step 6.1: Replace `_VotePill` `GestureDetector` with `InkWell`
- The vote pill has a very custom design — `ToggleButtons` doesn't match well
- Better approach: Replace `GestureDetector` with `InkWell` for proper ripple effects
- Keep the custom visual design but gain Material interaction feedback

---

## Phase 7: Replace Badges with `Badge` (Material 3)

### Step 7.1: Update `FirstPostBadge` and `FirstTaskBadge` in `base_feed_card.dart`
- Replace manual `Container` with Flutter's `Badge` widget (Material 3)
- Configure `backgroundColor`, `textStyle`, `padding` to match current design

---

## Files to Modify

| File | Action |
|------|--------|
| `lib/features/feed/widgets/base_feed_card.dart` | **CREATE** — shared BaseFeedCard, HoverWrapper, FollowButton, FirstPostBadge, FirstTaskBadge |
| `lib/features/feed/widgets/glass_card.dart` | **CREATE** — shared GlassCard |
| `lib/features/feed/widgets/social_post_card.dart` | **MODIFY** — remove duplicated classes, import shared |
| `lib/features/feed/widgets/task_card.dart` | **MODIFY** — remove duplicated classes, import shared |
| `lib/features/feed/widgets/editorial_card.dart` | **MODIFY** — remove duplicated classes, import shared |
| `lib/features/feed/pages/feed_page.dart` | **MODIFY** — replace tabs with TabBar, add RefreshIndicator |
| `lib/features/feed/pages/main_shell.dart` | **MODIFY** — replace custom nav with NavigationBar |
| `lib/features/feed/widgets/feed_composer.dart` | **MODIFY** — replace fullscreen with showModalBottomSheet, replace _AttachmentButton with IconButton |
| `lib/features/feed/viewmodels/feed_viewmodel.dart` | **MODIFY** — add refresh() method |
| `lib/shared/widgets/post_actions.dart` | **MODIFY** — replace GestureDetector with InkWell in _VotePill |

## Files NOT Modified
- `lib/app_theme.dart` — no changes needed
- `lib/app_router.dart` — no changes needed
- `lib/models/feed_item.dart` — no changes needed
- `lib/shared/widgets/media_carousel.dart` — current implementation is acceptable; CarouselView requires Flutter 3.22+ which may not match SDK constraint

---

## Verification
1. Run `flutter analyze` to check for lint errors
2. Run `flutter build apk --debug` or `flutter run` to verify compilation
3. Visually verify:
   - Bottom navigation works with 5 destinations, highlights correct tab
   - Feed tabs ("For You", "Around You") animate with indicator
   - Pull-to-refresh shows loading indicator
   - Composer expand opens bottom sheet
   - Card hover effects still work
   - Follow button still toggles
   - Vote pill still upvotes/downvotes
   - Thread lines render correctly between posts
