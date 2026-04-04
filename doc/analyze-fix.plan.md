```yaml
plan:
  uuid: 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d'
  status: 'in-progress'
  title: 'Flutter Analyze Fix: Resolve All 253 Issues (33 Errors, 16 Warnings, ~204 Infos)'
  introduction: |
    Running `flutter analyze` on the `main` branch produces 253 issues:
    - 33 errors (compilation blockers)
    - 16 warnings (unused imports, dead code, unused fields, naming)
    - ~204 infos (mostly `withOpacity` deprecation, a few style lints)

    This plan addresses every single issue in a prioritized order:
    Part 1 — Fix all ERROR-level issues (blocking compilation).
    Part 2 — Fix all WARNING-level issues (unused imports, dead code, naming).
    Part 3 — Fix all INFO-level issues (`withOpacity` → `withValues`, `background` → `surface`).

    Every fix preserves existing visual output and behaviour — these are purely
    mechanical / correctness changes with zero functional impact.

  parts:
    - uuid: 'b2c3d4e5-f6a7-4b8c-9d0e-1f2a3b4c5d6e'
      status: 'pending'
      name: 'Part 1: Fix ERROR-level Issues (33 errors)'
      reason: |
        These 33 errors prevent compilation. They fall into distinct categories:
        (A) Conflicting generic interfaces in ManagedTabController mixin,
        (B) Corrupted duplicate imports in task_main_content.dart,
        (C) Missing imports (color_extensions, ImageFilter, TrustCard, StatusTracker),
        (D) Wrong import paths (app_theme.dart in shared/utils/),
        (E) Ambiguous CloseButton imports (material.dart vs custom widget),
        (F) Border.none undefined in glass_card.dart and kanban_column_widget.dart,
        (G) Syntax errors (missing parens, invocation of const as function),
        (H) Undefined getter p20 (missing color_extensions import).
      steps:
        - uuid: 'c3d4e5f6-a7b8-4c9d-0e1f-2a3b4c5d6e7f'
          status: 'pending'
          name: '1A: Fix ManagedTabController conflicting generic interfaces'
          reason: |
            feed_page.dart:16 — `mixin ManagedTabController<T extends ConsumerStatefulWidget>
            on SingleTickerProviderStateMixin, ConsumerState<T>` causes
            `conflicting_generic_interfaces` because `SingleTickerProviderStateMixin`
            defaults to `State<StatefulWidget>`, clashing with `ConsumerState<T>`.
          files:
            - lib/features/feed/pages/feed_page.dart
          operations:
            - 'Line 17: Change `on SingleTickerProviderStateMixin, ConsumerState<T>` to `on SingleTickerProviderStateMixin<T>, ConsumerState<T>`'

        - uuid: 'd4e5f6a7-b8c9-4d0e-1f2a-3b4c5d6e7f8a'
          status: 'pending'
          name: '1B: Fix corrupted duplicate imports in task_main_content.dart'
          reason: |
            Lines 19-36 are a corrupted duplicate of lines 1-18. The file has
            `.dart\';` at line 19 (mid-string remnant) followed by full duplicate
            imports, causing ~30 cascading directive_after_declaration and
            duplicate_import errors.
          files:
            - lib/features/feed/pages/task_main_content.dart
          operations:
            - 'Delete lines 19-36 entirely (the duplicate import block)'

        - uuid: 'e5f6a7b8-c9d0-4e1f-2a3b-4c5d6e7f8a9b'
          status: 'pending'
          name: '1C: Add missing imports for TrustCard and StatusTracker'
          reason: |
            task_main_content.dart:86 calls `TrustCard(...)` and line 88 calls
            `StatusTracker(...)` but neither is imported.
          files:
            - lib/features/feed/pages/task_main_content.dart
          operations:
            - 'Add `import ../widgets/trust_card.dart;` and `import ../widgets/status_tracker.dart;` after the existing widget imports'

        - uuid: 'f6a7b8c9-d0e1-4f2a-3b4c-5d6e7f8a9b0c'
          status: 'pending'
          name: '1D: Fix wrong import paths in shared/utils/'
          reason: |
            app_buttons.dart:3 and decorations.dart:3 import `'../app_theme.dart'`
            which resolves to `lib/shared/app_theme.dart`, but app_theme.dart is at
            `lib/app_theme.dart`.
          files:
            - lib/shared/utils/app_buttons.dart
            - lib/shared/utils/decorations.dart
          operations:
            - "app_buttons.dart line 3: Change `'../app_theme.dart'` to `'../../app_theme.dart'`"
            - "decorations.dart line 3: Change `'../app_theme.dart'` to `'../../app_theme.dart'`"

        - uuid: 'a7b8c9d0-e1f2-4a3b-4c5d-6e7f8a9b0c1d'
          status: 'pending'
          name: '1E: Fix ambiguous CloseButton imports'
          reason: |
            radar_page.dart:539 and base_sheet.dart:73 — Flutter material.dart
            defines `CloseButton` as a widget, and our custom
            `shared/widgets/close_button.dart` also defines `CloseButton`. This
            creates an ambiguous_import error.
          files:
            - lib/features/feed/pages/radar_page.dart
            - lib/shared/widgets/base_sheet.dart
          operations:
            - "radar_page.dart line 7: Change `import 'package:flutter/material.dart';` to `import 'package:flutter/material.dart' hide CloseButton;`"
            - "base_sheet.dart line 1: Change `import 'package:flutter/material.dart';` to `import 'package:flutter/material.dart' hide CloseButton;`"

        - uuid: 'b8c9d0e1-f2a3-4b4c-5d6e-7f8a9b0c1d2e'
          status: 'pending'
          name: '1F: Fix Border.none undefined in glass_card.dart and kanban_column_widget.dart'
          reason: |
            `Border.none` is not available in the current Flutter SDK version.
            Use `const Border()` instead which is equivalent.
          files:
            - lib/features/feed/widgets/glass_card.dart
            - lib/features/feed/widgets/kanban_column_widget.dart
          operations:
            - "glass_card.dart line 42: Change `border = Border.none,` to `border = const Border(),`"
            - "kanban_column_widget.dart line 266: Change `border: Border.none,` to `border: const Border(),`"

        - uuid: 'c9d0e1f2-a3b4-4c5d-6e7f-8a9b0c1d2e3f'
          status: 'pending'
          name: '1G: Fix syntax errors in feed_composer.dart and floating_sidebar.dart'
          reason: |
            feed_composer.dart:306 — `borderlessInput()` invokes a const as a
            function. `borderlessInput` is a `const InputDecoration`, not a function.
            floating_sidebar.dart:177 — `.copyWith(color: Color(0xFF34D399),` is
            missing a closing parenthesis.
          files:
            - lib/features/feed/widgets/feed_composer.dart
            - lib/features/feed/widgets/floating_sidebar.dart
          operations:
            - "feed_composer.dart line 306: Change `decoration: borderlessInput(),` to `decoration: borderlessInput,`"
            - "floating_sidebar.dart line 175: Change `.copyWith(color: Color(0xFF34D399),` to `.copyWith(color: Color(0xFF34D399)),`"

        - uuid: 'd0e1f2a3-b4c5-4d6e-7f8a-9b0c1d2e3f4a'
          status: 'pending'
          name: '1H: Fix missing ImageFilter import in karma_badge.dart'
          reason: |
            karma_badge.dart:19 uses `ImageFilter.blur(...)` but `dart:ui` is
            not imported. `ImageFilter` is defined in `dart:ui`.
          files:
            - lib/shared/widgets/karma_badge.dart
          operations:
            - "Add `import 'dart:ui';` at the top of karma_badge.dart"

        - uuid: 'e1f2a3b4-c5d6-4e7f-8a9b-0c1d2e3f4a5b'
          status: 'pending'
          name: '1I: Fix missing color_extensions import in main_shell.dart'
          reason: |
            main_shell.dart:87 uses `AppColors.primary.p20` but
            `color_extensions.dart` (which defines the `p20` getter) is not imported.
          files:
            - lib/features/feed/pages/main_shell.dart
          operations:
            - "Add `import '../../../shared/utils/color_extensions.dart';` at the top of main_shell.dart"

    - uuid: 'f2a3b4c5-d6e7-4f8a-9b0c-1d2e3f4a5b6c'
      status: 'pending'
      name: 'Part 2: Fix WARNING-level Issues (16 warnings)'
      reason: |
        Warnings are non-blocking but should be cleaned up:
        - Unused imports (6 occurrences across 6 files)
        - Dead code from `parsePrice() ?? 50` (parsePrice returns `int`, never null)
        - Unused fields `_replyText` and `_exitOpacity`
        - Constant naming convention `GIGS` → `gigs`
      steps:
        - uuid: 'a3b4c5d6-e7f8-4a9b-0c1d-2e3f4a5b6c7d'
          status: 'pending'
          name: '2A: Remove unused imports'
          reason: 'Six files import modules they never use.'
          files:
            - lib/features/feed/pages/desktop_kanban_layout.dart
            - lib/features/feed/pages/main_shell.dart
            - lib/features/feed/pages/post_detail/bid_sheet.dart
            - lib/features/feed/widgets/status_tracker.dart
            - lib/shared/widgets/empty_state.dart
          operations:
            - "desktop_kanban_layout.dart line 6: Remove `import '../../../shared/settings_provider.dart';`"
            - "main_shell.dart line 8: Remove `import '../../../shared/settings_provider.dart';`"
            - "bid_sheet.dart line 3: Remove `import '../../../../app_theme.dart';`"
            - "status_tracker.dart line 4: Remove `import 'package:phosphor_flutter/phosphor_flutter.dart';`"
            - "empty_state.dart line 3: Remove `import 'package:phosphor_flutter/phosphor_flutter.dart';`"

        - uuid: 'b4c5d6e7-f8a9-4b0c-1d2e-3f4a5b6c7d8e'
          status: 'pending'
          name: '2B: Fix dead code from non-nullable parsePrice()'
          reason: |
            `parsePrice()` returns `int` (never null), so `parsePrice(x) ?? 50`
            has dead code after `??`. Occurs in radar_page.dart:78, radar_page.dart:476,
            and post_detail_page.dart:84.
          files:
            - lib/features/feed/pages/radar_page.dart
            - lib/features/feed/pages/post_detail_page.dart
          operations:
            - "radar_page.dart line 78: Change `parsePrice(currentGig.price) ?? 50` to `parsePrice(currentGig.price)`"
            - "radar_page.dart line 476: Change `parsePrice(gig.price) ?? 50` to `parsePrice(gig.price)`"
            - "post_detail_page.dart line 84: Change `parsed ?? 50` to `parsed`"

        - uuid: 'c5d6e7f8-a9b0-4c1d-2e3f-4a5b6c7d8e9f'
          status: 'pending'
          name: '2C: Fix unused fields'
          reason: |
            `_replyText` in radar_page.dart:37 and `_exitOpacity` in
            match_success_sheet.dart:35 are declared but never read.
          files:
            - lib/features/feed/pages/radar_page.dart
            - lib/features/feed/widgets/match_success_sheet.dart
          operations:
            - "radar_page.dart line 37: Remove `String _replyText = '';`"
            - "match_success_sheet.dart line 35: Remove the unused `_exitOpacity` field declaration"

        - uuid: 'd6e7f8a9-b0c1-4d2e-3f4a-5b6c7d8e9f0a'
          status: 'pending'
          name: '2D: Fix constant naming convention'
          reason: |
            mock_gigs.dart:4 — `const GIGS = [...]` uses SCREAMING_CASE which
            violates Dart's `constant_identifier_names` lint (lowerCamelCase).
          files:
            - lib/shared/constants/mock_gigs.dart
          operations:
            - "Rename `const GIGS` to `const gigs` and update all references across the codebase"

    - uuid: 'e7f8a9b0-c1d2-4e3f-4a5b-6c7d8e9f0a1b'
      status: 'pending'
      name: 'Part 3: Fix INFO-level Issues (~204 infos)'
      reason: |
        The vast majority (~170+) of info issues are `withOpacity` deprecation
        warnings. Flutter 3.18+ deprecated `Color.withOpacity()` in favour of
        `Color.withValues(alpha: ...)` to avoid precision loss. There is also
        one `background` deprecation in app_theme.dart (use `surface` instead),
        a few style lints, and some null-aware syntax suggestions.
      steps:
        - uuid: 'f8a9b0c1-d2e3-4f4a-5b6c-7d8e9f0a1b2c'
          status: 'pending'
          name: '3A: Replace withOpacity with withValues in color_extensions.dart'
          reason: |
            This single file contains ~80 `withOpacity()` calls that power all
            extension getters (w10, p20, e50, etc.). Fixing this file eliminates
            the majority of withOpacity warnings across the entire codebase since
            most call-sites go through these getters.
          files:
            - lib/shared/utils/color_extensions.dart
          operations:
            - 'Replace all `withOpacity(0.XX)` calls with `withValues(alpha: 0.XX)` throughout the file'

        - uuid: 'a9b0c1d2-e3f4-4a5b-6c7d-8e9f0a1b2c3d'
          status: 'pending'
          name: '3B: Replace withOpacity with withValues in direct call sites'
          reason: |
            Several files call `.withOpacity()` directly (not through extension
            getters). These must be updated individually.
          files:
            - lib/app_theme.dart
            - lib/features/feed/pages/create_reply_page.dart
            - lib/features/feed/pages/desktop_kanban_layout.dart
            - lib/features/feed/pages/feed_page.dart
            - lib/features/feed/pages/main_shell.dart
            - lib/features/feed/pages/post_detail/completion_sheet.dart
            - lib/features/feed/pages/post_detail/task_action_footer.dart
            - lib/features/feed/pages/post_detail_page.dart
            - lib/features/feed/pages/radar_page.dart
            - lib/features/feed/pages/task_main_content.dart
            - lib/features/feed/widgets/base_feed_card.dart
            - lib/features/feed/widgets/editorial_card.dart
            - lib/features/feed/widgets/feed_composer.dart
            - lib/features/feed/widgets/floating_sidebar.dart
            - lib/features/feed/widgets/glass_card.dart
            - lib/features/feed/widgets/match_success_sheet.dart
            - lib/features/feed/widgets/reply_input.dart
            - lib/features/feed/widgets/social_post_card.dart
            - lib/features/feed/widgets/status_tracker.dart
            - lib/features/feed/widgets/task_card.dart
            - lib/features/feed/widgets/trust_card.dart
            - lib/features/settings/pages/settings_page.dart
            - lib/shared/utils/decorations.dart
            - lib/shared/widgets/bid_controls.dart
            - lib/shared/widgets/gradient_divider.dart
            - lib/shared/widgets/map_preview.dart
            - lib/shared/widgets/post_actions.dart
            - lib/shared/widgets/primary_action_button.dart
            - lib/shared/widgets/rich_text_widget.dart
            - lib/shared/widgets/section_label.dart
            - lib/shared/widgets/tag_pill.dart
            - lib/shared/widgets/user_avatar.dart
          operations:
            - 'Replace all `.withOpacity(X)` calls with `.withValues(alpha: X)` in each file'

        - uuid: 'b0c1d2e3-f4a5-4b6c-7d8e-9f0a1b2c3d4e'
          status: 'pending'
          name: '3C: Fix background deprecation in app_theme.dart'
          reason: |
            app_theme.dart:114 — `background:` is deprecated in ColorScheme.dark()
            constructor (after v3.18.0). Use `surface:` instead.
          files:
            - lib/app_theme.dart
          operations:
            - "Line 114: Change `background: AppColors.background,` to `surface: AppColors.background,`"

        - uuid: 'c1d2e3f4-a5b6-4c7d-8e9f-0a1b2c3d4e5f'
          status: 'pending'
          name: '3D: Fix remaining style lints'
          reason: |
            Minor style issues: use_null_aware_elements in base_feed_card.dart,
            prefer_function_declarations_over_variables in feed_page.dart:289,
            curly_braces_in_flow_control_structures in main_shell.dart:51,
            no_leading_underscores_for_local_identifiers in radar_page.dart:478.
          files:
            - lib/features/feed/widgets/base_feed_card.dart
            - lib/features/feed/pages/feed_page.dart
            - lib/features/feed/pages/main_shell.dart
            - lib/features/feed/pages/radar_page.dart
          operations:
            - "base_feed_card.dart:185 and :322 — Replace if-null patterns with null-aware `?` syntax"
            - "feed_page.dart:289 — Convert variable function to function declaration"
            - "main_shell.dart:51 — Add curly braces around if body"
            - "radar_page.dart:478 — Rename `_closeBidSheet` to `closeBidSheet` (remove leading underscore from local variable)"
```
