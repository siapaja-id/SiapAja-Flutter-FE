# Radical DRY Refactor Plan

**Goal:** Reduce ~8,500 LOC codebase by 20-30% (~1,500-2,500 LOC) by eliminating all 20 duplication patterns.

**Approach:** Extract shared widgets/utils, introduce `freezed` for models, consolidate repeated UI patterns.

---

## Phase 1: Dependencies & Model Code Generation (~500 LOC saved)

### 1.1 Add freezed dependencies to `pubspec.yaml`
```yaml
dependencies:
  freezed_annotation: ^2.4.4

dev_dependencies:
  freezed: ^2.5.7
  build_runner: ^2.4.13
  json_serializable: ^6.9.3  # if models need JSON (check first)
```

### 1.2 Convert models to freezed

Files to modify:
- `lib/models/author.dart` (36 → ~15 LOC)
- `lib/models/feed_item.dart` (279 → ~80 LOC) — `SocialPostData`, `TaskData`, `EditorialData`
- `lib/models/kanban_column.dart` (45 → ~18 LOC)

State classes in viewmodels (use freezed or keep manual — these are small):
- `lib/features/feed/viewmodels/feed_viewmodel.dart` — `FeedState`
- `lib/features/feed/viewmodels/kanban_viewmodel.dart` — `KanbanState`
- `lib/features/feed/viewmodels/app_viewmodel.dart` — `UiState`

Run: `dart run build_runner build --delete-conflicting-outputs`

---

## Phase 2: Shared Utility Functions (~200 LOC saved)

### 2.1 Create `lib/shared/utils/task_icons.dart`
- Move `_getIconForTaskType` (currently triplicated in `task_card.dart:19`, `post_detail_page.dart:1254`, `task_main_content.dart:1346`)
- Delete all 3 copies, import shared version

### 2.2 Create `lib/shared/utils/scroll_helpers.dart`
- Extract `scrollToEnd(ScrollController)` helper (currently duplicated 4× in `post_detail_page.dart` lines 149-157, 205-213, 244-252, `create_reply_page.dart:53-61`)

### 2.3 Create `lib/shared/widgets/pulsing_dot.dart`
- Move `_PulsingDot` from `task_main_content.dart:1358-1373` to shared location
- Use in `FirstItemBadge` and `task_main_content.dart` (currently private copy in each)

### 2.4 Create `lib/shared/models/nav_item.dart`
- Merge duplicate `_NavItem` from `main_shell.dart:15-20` and `floating_sidebar.dart:10-23`
- Single shared class with optional `isPrimary`/`action` fields

---

## Phase 3: Shared UI Widgets (~800 LOC saved)

### 3.1 `lib/shared/widgets/glass_header.dart` — GlassHeader widget
Replaces **4 duplicate implementations**:
- `feed_page.dart:224-333` (`_KanbanFeedHeader`)
- `feed_page.dart:389-466` (`FeedHeader`)
- `main_shell.dart:96-122` (bottom nav)
- `create_reply_page.dart:194-253` (`_buildHeader`)

Shared params: `height`, `child`, `gradient` (optional), `border` (bottom by default)

### 3.2 `lib/shared/widgets/karma_badge.dart` — KarmaBadge widget
Replaces **2 duplicate implementations** in `feed_page.dart:294-327` and `feed_page.dart:424-458`

### 3.3 `lib/shared/widgets/view_stats_badge.dart` — ViewStatsBadge widget
Replaces **2 duplicate implementations** in `post_detail_page.dart:1178-1252` and `post_detail_page.dart:1859-1923`

### 3.4 `lib/shared/widgets/bottom_sheet_container.dart` — BottomSheetContainer widget
Replaces **4 duplicate bottom sheet containers**:
- `post_detail_page.dart:282-583` (`_showBidSheet`)
- `post_detail_page.dart:586-726` (`_showCompleteSheet`)
- `post_detail_page.dart:728-844` (`_showReviewSheet`)
- `feed_composer.dart:443-707` (`_FullscreenComposerSheet`)

Shared params: `title`, `child`, `onClose`

### 3.5 `lib/shared/widgets/primary_action_button.dart` — PrimaryActionButton widget
Replaces **4 duplicate button styles** in `post_detail_page.dart` lines 540-574, 694-720, 810-836, 1694-1751

Shared params: `label`, `onTap`, `backgroundColor` (default emerald), `enabled`

### 3.6 `lib/shared/widgets/reply_composer.dart` — ReplyComposer widget
Replaces **3 duplicate text field + send button patterns**:
- `reply_input.dart:141-237`
- `post_detail_page.dart:1438-1517`
- `create_reply_page.dart:256-303,533-561`

Shared params: `hintText`, `controller`, `onSend`, `sendEnabled`

### 3.7 `lib/shared/widgets/tag_pill.dart` — TagPill widget
Replaces **5+ duplicate pill/badge patterns**:
- `post_detail_page.dart:921-942`
- `task_main_content.dart:94-103,223-243,1279-1303`
- `task_card.dart:87-105`

Shared params: `label`, `color`, `borderRadius`, `fontSize`

### 3.8 `lib/shared/widgets/voice_note_player.dart` — VoiceNotePlayer widget
Replaces **2 duplicate voice note UIs**:
- `social_post_card.dart:183-257`
- `task_main_content.dart:954-1066`

### 3.9 `lib/shared/widgets/map_preview.dart` — MapPreview widget
Replaces **2 duplicate map previews**:
- `task_card.dart:229-315`
- `task_main_content.dart:1068-1251`

---

## Phase 4: Structural Cleanup (~200 LOC saved)

### 4.1 Background gradient constant
Extract from `main_shell.dart:70-85` and `desktop_kanban_layout.dart:57-75` into `AppColors` or `AppTheme` as a static const.

### 4.2 Simplify PostActions signature
Change `PostActions` to accept `FeedItem` directly instead of 5 fields (`id, votes, replies, reposts, shares`). Update call sites in `base_feed_card.dart:397-403` and `task_main_content.dart:1335-1341`.

### 4.3 Remove `FirstItemBadge` duplication
Replace manual reimplementation in `task_main_content.dart:245-301` with the existing `FirstItemBadge` widget from `base_feed_card.dart:507-553`.

---

## Execution Order

1. Phase 1 first (freezed) — foundation change, all models regenerate
2. Phase 2 (utilities) — simple extractions, no dependency
3. Phase 3 (shared widgets) — largest impact, sequential per-widget
4. Phase 4 (cleanup) — final polish

**Verification after each phase:** `flutter analyze` + `dart run build_runner build` (after Phase 1)

---

## Files Created (new)
- `lib/shared/utils/task_icons.dart`
- `lib/shared/utils/scroll_helpers.dart`
- `lib/shared/widgets/pulsing_dot.dart`
- `lib/shared/widgets/glass_header.dart`
- `lib/shared/widgets/karma_badge.dart`
- `lib/shared/widgets/view_stats_badge.dart`
- `lib/shared/widgets/bottom_sheet_container.dart`
- `lib/shared/widgets/primary_action_button.dart`
- `lib/shared/widgets/reply_composer.dart`
- `lib/shared/widgets/tag_pill.dart`
- `lib/shared/widgets/voice_note_player.dart`
- `lib/shared/widgets/map_preview.dart`
- `lib/shared/models/nav_item.dart`

## Files Modified (existing)
- `pubspec.yaml` — add freezed deps
- `lib/models/author.dart` — freezed
- `lib/models/feed_item.dart` — freezed
- `lib/models/kanban_column.dart` — freezed
- `lib/features/feed/viewmodels/feed_viewmodel.dart` — freezed FeedState
- `lib/features/feed/viewmodels/kanban_viewmodel.dart` — freezed KanbanState
- `lib/features/feed/viewmodels/app_viewmodel.dart` — freezed UiState
- `lib/features/feed/widgets/task_card.dart` — use shared task_icons
- `lib/features/feed/pages/post_detail_page.dart` — use shared widgets (largest savings)
- `lib/features/feed/pages/task_main_content.dart` — use shared widgets
- `lib/features/feed/pages/feed_page.dart` — use GlassHeader, KarmaBadge
- `lib/features/feed/pages/main_shell.dart` — use GlassHeader, shared NavItem, bg gradient
- `lib/features/feed/pages/create_reply_page.dart` — use GlassHeader, ReplyComposer
- `lib/features/feed/widgets/reply_input.dart` — use ReplyComposer
- `lib/features/feed/widgets/floating_sidebar.dart` — use shared NavItem
- `lib/features/feed/widgets/social_post_card.dart` — use VoiceNotePlayer
- `lib/features/feed/widgets/kanban_column_widget.dart` — bg gradient
- `lib/features/feed/widgets/feed_composer.dart` — use BottomSheetContainer
- `lib/app_theme.dart` — add bg gradient const
