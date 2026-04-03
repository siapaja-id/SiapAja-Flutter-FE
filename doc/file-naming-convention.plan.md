# Strict File Naming Convention — Rename Plan

## Convention Suffixes

| Suffix | Purpose | Directory |
|--------|---------|-----------|
| `.model.dart` | Domain data classes (Freezed) | `lib/models/`, `lib/shared/models/` |
| `.state.dart` | State management (Notifier/StateNotifier + state classes) | `lib/shared/`, `lib/features/*/viewmodels/` |
| `.page.dart` | Full-screen page/screen widgets | `lib/features/*/pages/` |
| `.widget.dart` | Reusable UI components | `lib/shared/widgets/`, `lib/features/*/widgets/` |
| `.utils.dart` | Utility functions and helpers | `lib/shared/utils/` |
| `.data.dart` | Data sources, sample data, data generators | `lib/features/*/data/` |
| `.constants.dart` | Constants, design tokens (future use) | Wherever needed |
| `.types.dart` | Type definitions, enums (future use) | Wherever needed |

**Unchanged files:**
- `lib/main.dart` — app entry point
- `lib/app_router.dart` — route config
- `lib/app_theme.dart` — theme config
- `*.freezed.dart` — auto-generated, renamed by build_runner
- `lib/features/feed/providers.dart` — barrel re-export (exports updated, name kept)

---

## File Renames

### Models → `.model.dart` (4 files)

| Current | New |
|---|---|
| `lib/models/author.dart` | `lib/models/author.model.dart` |
| `lib/models/feed_item.dart` | `lib/models/feed_item.model.dart` |
| `lib/models/kanban_column.dart` | `lib/models/kanban_column.model.dart` |
| `lib/shared/models/nav_item.dart` | `lib/shared/models/nav_item.model.dart` |

### State → `.state.dart` (5 files)

| Current | New |
|---|---|
| `lib/shared/settings_provider.dart` | `lib/shared/settings_state.dart` |
| `lib/shared/zoom_provider.dart` | `lib/shared/zoom_state.dart` |
| `lib/features/feed/viewmodels/app_viewmodel.dart` | `lib/features/feed/viewmodels/app_state.dart` |
| `lib/features/feed/viewmodels/feed_viewmodel.dart` | `lib/features/feed/viewmodels/feed_state.dart` |
| `lib/features/feed/viewmodels/kanban_viewmodel.dart` | `lib/features/feed/viewmodels/kanban_state.dart` |

### Pages → `.page.dart` (13 files)

| Current | New |
|---|---|
| `lib/features/feed/pages/feed_page.dart` | `lib/features/feed/pages/feed.page.dart` |
| `lib/features/feed/pages/main_shell.dart` | `lib/features/feed/pages/main_shell.page.dart` |
| `lib/features/feed/pages/create_reply_page.dart` | `lib/features/feed/pages/create_reply.page.dart` |
| `lib/features/feed/pages/post_detail_page.dart` | `lib/features/feed/pages/post_detail.page.dart` |
| `lib/features/feed/pages/task_main_content.dart` | `lib/features/feed/pages/task_main_content.page.dart` |
| `lib/features/feed/pages/desktop_kanban_layout.dart` | `lib/features/feed/pages/desktop_kanban_layout.page.dart` |
| `lib/features/feed/pages/post_detail/bid_sheet.dart` | `lib/features/feed/pages/post_detail/bid_sheet.page.dart` |
| `lib/features/feed/pages/post_detail/completion_sheet.dart` | `lib/features/feed/pages/post_detail/completion_sheet.page.dart` |
| `lib/features/feed/pages/post_detail/empty_replies_state.dart` | `lib/features/feed/pages/post_detail/empty_replies_state.page.dart` |
| `lib/features/feed/pages/post_detail/review_sheet.dart` | `lib/features/feed/pages/post_detail/review_sheet.page.dart` |
| `lib/features/feed/pages/post_detail/task_action_footer.dart` | `lib/features/feed/pages/post_detail/task_action_footer.page.dart` |
| `lib/features/feed/pages/post_detail/task_sliver_app_bar.dart` | `lib/features/feed/pages/post_detail/task_sliver_app_bar.page.dart` |
| `lib/features/settings/pages/settings_page.dart` | `lib/features/settings/pages/settings.page.dart` |

### Widgets — Shared → `.widget.dart` (15 files)

| Current | New |
|---|---|
| `lib/shared/zoom_wrapper.dart` | `lib/shared/zoom_wrapper.widget.dart` |
| `lib/shared/widgets/bottom_sheet_container.dart` | `lib/shared/widgets/bottom_sheet_container.widget.dart` |
| `lib/shared/widgets/expandable_text.dart` | `lib/shared/widgets/expandable_text.widget.dart` |
| `lib/shared/widgets/glass_header.dart` | `lib/shared/widgets/glass_header.widget.dart` |
| `lib/shared/widgets/karma_badge.dart` | `lib/shared/widgets/karma_badge.widget.dart` |
| `lib/shared/widgets/map_preview.dart` | `lib/shared/widgets/map_preview.widget.dart` |
| `lib/shared/widgets/media_carousel.dart` | `lib/shared/widgets/media_carousel.widget.dart` |
| `lib/shared/widgets/post_actions.dart` | `lib/shared/widgets/post_actions.widget.dart` |
| `lib/shared/widgets/primary_action_button.dart` | `lib/shared/widgets/primary_action_button.widget.dart` |
| `lib/shared/widgets/pulsing_dot.dart` | `lib/shared/widgets/pulsing_dot.widget.dart` |
| `lib/shared/widgets/rich_text_widget.dart` | `lib/shared/widgets/rich_text.widget.dart` |
| `lib/shared/widgets/tag_pill.dart` | `lib/shared/widgets/tag_pill.widget.dart` |
| `lib/shared/widgets/user_avatar.dart` | `lib/shared/widgets/user_avatar.widget.dart` |
| `lib/shared/widgets/view_stats_badge.dart` | `lib/shared/widgets/view_stats_badge.widget.dart` |
| `lib/shared/widgets/voice_note_player.dart` | `lib/shared/widgets/voice_note_player.widget.dart` |

### Widgets — Feature-Scoped → `.widget.dart` (10 files)

| Current | New |
|---|---|
| `lib/features/feed/widgets/base_feed_card.dart` | `lib/features/feed/widgets/base_feed_card.widget.dart` |
| `lib/features/feed/widgets/editorial_card.dart` | `lib/features/feed/widgets/editorial_card.widget.dart` |
| `lib/features/feed/widgets/feed_composer.dart` | `lib/features/feed/widgets/feed_composer.widget.dart` |
| `lib/features/feed/widgets/feed_item_card.dart` | `lib/features/feed/widgets/feed_item_card.widget.dart` |
| `lib/features/feed/widgets/floating_sidebar.dart` | `lib/features/feed/widgets/floating_sidebar.widget.dart` |
| `lib/features/feed/widgets/glass_card.dart` | `lib/features/feed/widgets/glass_card.widget.dart` |
| `lib/features/feed/widgets/kanban_column_widget.dart` | `lib/features/feed/widgets/kanban_column.widget.dart` |
| `lib/features/feed/widgets/reply_input.dart` | `lib/features/feed/widgets/reply_input.widget.dart` |
| `lib/features/feed/widgets/social_post_card.dart` | `lib/features/feed/widgets/social_post_card.widget.dart` |
| `lib/features/feed/widgets/task_card.dart` | `lib/features/feed/widgets/task_card.widget.dart` |

### Utilities → `.utils.dart` (2 files)

| Current | New |
|---|---|
| `lib/shared/utils/scroll_helpers.dart` | `lib/shared/utils/scroll_helpers.utils.dart` |
| `lib/shared/utils/task_icons.dart` | `lib/shared/utils/task_icons.utils.dart` |

### Data → `.data.dart` (2 files)

| Current | New |
|---|---|
| `lib/features/feed/data/sample_data.dart` | `lib/features/feed/data/sample.data.dart` |
| `lib/features/feed/data/reply_generator.dart` | `lib/features/feed/data/reply_generator.data.dart` |

---

## Execution Steps

### Step 1: Rename all files via `git mv`

51 files total. `git mv` preserves history.

### Step 2: Update barrel file exports

`lib/features/feed/providers.dart`:
- `export 'viewmodels/app_viewmodel.dart'` → `export 'viewmodels/app_state.dart'`
- `export 'viewmodels/feed_viewmodel.dart'` → `export 'viewmodels/feed_state.dart'`
- `export 'viewmodels/kanban_viewmodel.dart'` → `export 'viewmodels/kanban_state.dart'`

### Step 3: Update all import statements

~80+ import lines across ~35 files. Highest-impact:
1. `settings_provider` → `settings_state` (28 files)
2. `feed_item` → `feed_item.model` (19 files)
3. `zoom_provider` → `zoom_state` (3 files)
4. `author` → `author.model` (2 files)
5. `kanban_column` → `kanban_column.model` (2 files)
6. `nav_item` → `nav_item.model` (2 files)
7. `scroll_helpers` → `scroll_helpers.utils` (1 file)
8. `task_icons` → `task_icons.utils` (2 files)
9. `sample_data` → `sample.data` (2 files)
10. `reply_generator` → `reply_generator.data` (1 file)
11. All widget and page imports updated

### Step 4: Verify

```bash
dart analyze lib/
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

---

## Summary

| Category | Files |
|---|---|
| Models | 4 |
| State | 5 |
| Pages | 13 |
| Widgets | 25 |
| Utils | 2 |
| Data | 2 |
| **Total** | **51** |
