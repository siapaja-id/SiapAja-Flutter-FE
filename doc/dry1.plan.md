```yaml
plan:
  uuid: 'a7f3e1d2-4b5c-4d6e-8f9a-1b2c3d4e5f6a'
  status: 'done'
  title: 'Radical DRY: Aggressive Code Deduplication Without UI Regression'
  introduction: |
    This plan surgically removes ~500 LOC of boilerplate by extracting repeated patterns into shared primitives. The codebase has massive duplication: identical `Colors.white.withOpacity(0.X)` calls number in the hundreds, three sheet widgets share 90% identical scaffolding, icon mappings are copy-pasted across files, and the same `BackdropFilter+Container` glass pattern is inlined 20+ times.

    Every extraction is a net LOC reduction. No new abstractions that aren't immediately used 3+ times. The visual output remains pixel-identical—we're just changing how the pixels are expressed.
  parts:
    - uuid: 'b8c4d5e6-7f8a-4b9c-9d0e-1f2a3b4c5d6e'
      status: 'done'
      name: 'Part 1: Color Opacity Extensions'
      reason: |
        The single highest-impact change. Scanning the codebase reveals 200+ instances of `Colors.white.withOpacity(0.05)`, `Colors.white.withOpacity(0.1)`, `AppColors.primary.withOpacity(0.2)`, etc. These 40+ char expressions can become 4-char extensions.
      steps:
        - uuid: 'c9d5e6f7-8a9b-4c0d-1e2f-3a4b5c6d7e8f'
          status: 'done'
          name: 'Create Color Extensions'
          reason: 'Eliminates ~800 chars of repeated opacity syntax'
          files:
            - lib/shared/utils/color_extensions.dart
          operations:
            - 'Create `lib/shared/utils/color_extensions.dart`'
            - 'Add `extension ColorX on Color` with getters: `w05`, `w10`, `w20`, `w30`, `w50`, `w60`, `w80` for white opacity variants'
            - 'Add `p10`, `p20`, `p30`, `p50` for primary opacity variants'
            - 'Add `e10`, `e15`, `e20`, `e50` for emerald opacity variants'
            - 'Add `i03`, `i10` for indigo opacity variants'
            - 'Add `r10`, `r20` for red opacity variants'
            - 'Add `black20`, `black30`, `black40`, `black50`, `black54`, `black87` for black opacity variants'
        - uuid: 'd0e6f7a8-9b0c-4d1e-2f3a-4b5c6d7e8f9a'
          status: 'done'
          name: 'Apply Color Extensions Across Codebase'
          reason: 'Realize the LOC reduction'
          files:
            - lib/features/feed/pages/radar_page.dart
            - lib/features/feed/pages/main_shell.dart
            - lib/features/feed/pages/task_main_content.dart
            - lib/features/feed/widgets/floating_sidebar.dart
            - lib/features/feed/widgets/task_card.dart
            - lib/features/feed/widgets/social_post_card.dart
            - lib/features/feed/widgets/base_feed_card.dart
            - lib/features/feed/widgets/feed_composer.dart
            - lib/features/feed/widgets/reply_input.dart
            - lib/features/feed/widgets/kanban_column_widget.dart
            - lib/features/feed/pages/post_detail/bid_sheet.dart
            - lib/features/feed/pages/post_detail/empty_replies_state.dart
            - lib/features/feed/pages/post_detail/task_action_footer.dart
            - lib/features/feed/pages/post_detail/task_sliver_app_bar.dart
            - lib/shared/widgets/glass_card.dart
            - lib/shared/widgets/glass_header.dart
            - lib/shared/widgets/karma_badge.dart
            - lib/shared/widgets/map_preview.dart
            - lib/shared/widgets/media_carousel.dart
            - lib/shared/widgets/tag_pill.dart
            - lib/shared/widgets/view_stats_badge.dart
            - lib/shared/widgets/voice_note_player.dart
            - lib/shared/widgets/bottom_sheet_container.dart
            - lib/shared/widgets/post_actions.dart
          operations:
            - 'Replace all `Colors.white.withOpacity(0.05)` with `Colors.white.w05`'
            - 'Replace all `Colors.white.withOpacity(0.1)` with `Colors.white.w10`'
            - 'Replace all `Colors.white.withOpacity(0.2)` with `Colors.white.w20`'
            - 'Replace all `Colors.white.withOpacity(0.3)` with `Colors.white.w30`'
            - 'Replace all `Colors.white.withOpacity(0.5)` with `Colors.white.w50`'
            - 'Replace all `Colors.black.withOpacity(0.X)` with `Colors.black.XX` pattern'
            - 'Replace all `AppColors.primary.withOpacity(X)` with `AppColors.primary.pXX` pattern'
            - 'Replace all `AppColors.emerald.withOpacity(X)` with `AppColors.emerald.eXX` pattern'
            - 'Add `import ''../../../shared/utils/color_extensions.dart''` (or appropriate relative path) to each modified file'
      context_files:
        compact:
          - lib/shared/utils/color_extensions.dart
        medium:
          - lib/shared/utils/color_extensions.dart
          - lib/features/feed/pages/radar_page.dart
        extended:
          - lib/shared/utils/color_extensions.dart
          - lib/features/feed/pages/radar_page.dart
          - lib/features/feed/widgets/base_feed_card.dart
    - uuid: 'e1f7a8b9-0c1d-4e2f-3a4b-5c6d7e8f9a0b'
      status: 'done'
      name: 'Part 2: Decoration Presets'
      reason: |
        BoxDecoration is instantiated with identical patterns everywhere: `borderRadius: 24`, `border: Border.all(color: Colors.white.w10)`, `color: surfaceContainerHigh`. These 3-5 line blocks become single function calls.
      steps:
        - uuid: 'f2a8b9c0-1d2e-4f3a-4b5c-6d7e8f9a0b1c'
          status: 'done'
          name: 'Create Decoration Helpers'
          reason: 'Collapse repeated decoration patterns'
          files:
            - lib/shared/utils/decorations.dart
          operations:
            - 'Create `lib/shared/utils/decorations.dart`'
            - 'Add `BoxDecoration surfaceDecor({double radius = 16, Color? tint})` returning standard surface container decoration'
            - 'Add `BoxDecoration glassDecor({double radius = 32})` returning glass border decoration'
            - 'Add `BoxDecoration subtleBorder({double radius = 16})` returning white.w10 border only'
            - 'Add `Border roundedBorder({double radius = 16, Color color = Colors.white, double width = 1})` helper'
            - 'Add `BoxShadow shadowBlack({double blur = 20, double offset = 8})` helper'
            - 'Add `BoxShadow shadowGlow({Color color, double blur = 20})` helper'
        - uuid: 'a3b9c0d1-2e3f-4a4b-5c6d-7e8f9a0b1c2d'
          status: 'done'
          name: 'Apply Decoration Presets'
          reason: 'Replace ~100 inline BoxDecoration creations'
          files:
            - lib/features/feed/pages/radar_page.dart
            - lib/features/feed/pages/task_main_content.dart
            - lib/features/feed/widgets/floating_sidebar.dart
            - lib/features/feed/widgets/task_card.dart
            - lib/features/feed/widgets/social_post_card.dart
            - lib/features/feed/widgets/feed_composer.dart
            - lib/features/feed/pages/post_detail/bid_sheet.dart
            - lib/features/feed/pages/post_detail/completion_sheet.dart
            - lib/features/feed/pages/post_detail/review_sheet.dart
            - lib/features/feed/pages/post_detail/task_action_footer.dart
            - lib/shared/widgets/media_carousel.dart
            - lib/shared/widgets/voice_note_player.dart
          operations:
            - 'Replace repeated `BoxDecoration(color: surfaceContainerHigh, borderRadius: 32, border: Border.all(...))` with `surfaceDecor(radius: 32)`'
            - 'Replace repeated shadow patterns with `shadowBlack()` or `shadowGlow()`'
            - 'Use `subtleBorder()` where only border is needed'
      context_files:
        compact:
          - lib/shared/utils/decorations.dart
        medium:
          - lib/shared/utils/decorations.dart
          - lib/features/feed/pages/radar_page.dart
        extended:
          - lib/shared/utils/decorations.dart
          - lib/features/feed/pages/radar_page.dart
          - lib/features/feed/pages/post_detail/bid_sheet.dart
    - uuid: 'b4c0d1e2-3f4a-4b5c-6d7e-8f9a0b1c2d3e'
      status: 'done'
      name: 'Part 3: BaseSheet Abstraction'
      reason: |
        bid_sheet.dart, completion_sheet.dart, review_sheet.dart each have ~40 lines of identical scaffold code: container padding, decoration, title row, close button. BaseSheet eliminates this duplication.
      steps:
        - uuid: 'c5d1e2f3-4a5b-4c6d-7e8f-9a0b1c2d3e4f'
          status: 'done'
          name: 'Create BaseSheet Widget'
          reason: 'Single source of truth for sheet chrome'
          files:
            - lib/shared/widgets/base_sheet.dart
          operations:
            - 'Create `BaseSheet` StatelessWidget with `title`, `child`, `onClose` parameters'
            - 'Include standard `Container` with `padding: EdgeInsets.fromLTRB(24, 24, 24, 48)`'
            - 'Include standard `surfaceDecor(radius: 32)` decoration'
            - 'Include title row with close `IconButton`'
            - 'Add static `Future<T?> show<T>({required BuildContext, required String title, required WidgetBuilder})` method'
            - 'Handle `isScrollControlled: true, backgroundColor: transparent`'
        - uuid: 'd6e2f3a4-5b6c-4d7e-8f9a-0b1c2d3e4f5a'
          status: 'done'
          name: 'Refactor Sheet Widgets to Use BaseSheet'
          reason: 'Remove ~120 lines total from 3 files'
          files:
            - lib/features/feed/pages/post_detail/bid_sheet.dart
            - lib/features/feed/pages/post_detail/completion_sheet.dart
            - lib/features/feed/pages/post_detail/review_sheet.dart
          operations:
            - 'In bid_sheet.dart: wrap content in `BaseSheet(title: "Submit Your Bid", child: ...)`, remove duplicated scaffold'
            - 'In completion_sheet.dart: wrap content in `BaseSheet(title: "Complete Task", child: ...)`, remove duplicated scaffold'
            - 'In review_sheet.dart: wrap content in `BaseSheet(title: "Review Work", child: ...)`, remove duplicated scaffold'
            - 'Update `show()` static methods to delegate to `BaseSheet.show()`'
      context_files:
        compact:
          - lib/shared/widgets/base_sheet.dart
        medium:
          - lib/shared/widgets/base_sheet.dart
          - lib/features/feed/pages/post_detail/bid_sheet.dart
          - lib/features/feed/pages/post_detail/completion_sheet.dart
          - lib/features/feed/pages/post_detail/review_sheet.dart
        extended:
          - lib/shared/widgets/base_sheet.dart
          - lib/features/feed/pages/post_detail/bid_sheet.dart
          - lib/features/feed/pages/post_detail/completion_sheet.dart
          - lib/features/feed/pages/post_detail/review_sheet.dart
          - lib/shared/widgets/bottom_sheet_container.dart
    - uuid: 'e7f3a4b5-6c7d-4e8f-9a0b-1c2d3e4f5a6b'
      status: 'done'
      name: 'Part 4: Icon & Status Centralization'
      reason: |
        `_getIconForTaskType` is defined in task_card.dart, duplicated in radar_page.dart (twice!), and exists properly in shared/task_icons.dart. Status text mapping is also scattered across task_card.dart and task_action_footer.dart.
      steps:
        - uuid: 'f8a4b5c6-7d8e-4f9a-0b1c-2d3e4f5a6b7c'
          status: 'done'
          name: 'Extend Shared Task Icons'
          reason: 'Make shared file the single source of truth'
          files:
            - lib/shared/utils/task_icons.dart
          operations:
            - 'Add `String getStatusText(TaskStatus status)` function returning uppercase status labels'
            - 'Add `Color getStatusColor(TaskStatus status)` function for status indicator colors'
            - 'Verify existing `getIconForTaskType()` covers all TaskIconType cases'
        - uuid: 'a9b5c6d7-8e9f-4a0b-1c2d-3e4f5a6b7c8d'
          status: 'done'
          name: 'Remove Duplicate Icon Functions'
          reason: 'Eliminate ~40 LOC of duplicated switch statements'
          files:
            - lib/features/feed/widgets/task_card.dart
            - lib/features/feed/pages/radar_page.dart
          operations:
            - 'Delete local `_getIconForTaskType` from task_card.dart, replace calls with `getIconForTaskType`'
            - 'Delete local `_getIconForTaskType` from `_GigCard` in radar_page.dart, replace with import'
            - 'Delete local `_getIconForTaskType` from `MatchSuccessSheet` in radar_page.dart, replace with import'
            - 'Add `import ''../../../shared/utils/task_icons.dart''` to affected files'
        - uuid: 'b0c6d7e8-9f0a-4b1c-2d3e-4f5a6b7c8d9e'
          status: 'done'
          name: 'Centralize Status Text'
          reason: 'Remove duplicate status label mapping'
          files:
            - lib/features/feed/widgets/task_card.dart
            - lib/features/feed/pages/post_detail/task_action_footer.dart
          operations:
            - 'In task_card.dart: replace `_getStatusText()` switch with call to `getStatusText()`'
            - 'Verify task_action_footer.dart uses inline status checks (keep as-is if no duplication)'
      context_files:
        compact:
          - lib/shared/utils/task_icons.dart
        medium:
          - lib/shared/utils/task_icons.dart
          - lib/features/feed/widgets/task_card.dart
        extended:
          - lib/shared/utils/task_icons.dart
          - lib/features/feed/widgets/task_card.dart
          - lib/features/feed/pages/radar_page.dart
          - lib/features/feed/pages/post_detail/task_action_footer.dart
    - uuid: 'c1d7e8f9-0a1b-4c2d-3e4f-5a6b7c8d9e0f'
      status: 'done'
      name: 'Part 5: Glass Widget Consolidation'
      reason: |
        `BackdropFilter + Container` with glass tint/border is inlined in main_shell.dart, floating_sidebar.dart, reply_input.dart, feed_composer.dart, and kanban_column_widget.dart. GlassCard only covers card variant.
      steps:
        - uuid: 'd2e8f9a0-1b2c-4d3e-4f5a-6b7c8d9e0f1a'
          status: 'done'
          name: 'Add Glass Widget Variants'
          reason: 'Cover all glass usage patterns with named constructors'
          files:
            - lib/shared/widgets/glass_card.dart
          operations:
            - 'Add `GlassCard.bar({required Widget child, double height = 64})` named constructor for horizontal bars (headers, footers)'
            - 'Add `GlassCard.slab({required Widget child, EdgeInsets? padding})` named constructor for full-width panels without border-radius'
            - 'Both constructors use `BackdropFilter` + `AppColors.glassTint` + `AppColors.glassBorder` pattern'
        - uuid: 'e3f9a0b1-2c3d-4e4f-5a6b-7c8d9e0f1a2b'
          status: 'done'
          name: 'Replace Inline Glass Patterns'
          reason: 'Replace ~15 inline BackdropFilter usages with GlassCard variants'
          files:
            - lib/features/feed/pages/main_shell.dart
            - lib/features/feed/widgets/floating_sidebar.dart
            - lib/features/feed/widgets/reply_input.dart
            - lib/features/feed/widgets/feed_composer.dart
            - lib/features/feed/widgets/kanban_column_widget.dart
          operations:
            - 'In main_shell.dart: replace BackdropFilter wrapping NavigationBar with `GlassCard.bar(child: NavigationBar(...))`'
            - 'In floating_sidebar.dart: replace BackdropFilter+Container with `GlassCard.slab(child: ...)`'
            - 'In reply_input.dart: replace BackdropFilter+Container with `GlassCard.slab(child: ...)`'
            - 'In feed_composer.dart: replace BackdropFilter+ClipRRect with `GlassCard(child: ...)` variant'
            - 'In kanban_column_widget.dart: replace BackdropFilter with appropriate GlassCard variant'
      context_files:
        compact:
          - lib/shared/widgets/glass_card.dart
        medium:
          - lib/shared/widgets/glass_card.dart
          - lib/features/feed/pages/main_shell.dart
        extended:
          - lib/shared/widgets/glass_card.dart
          - lib/features/feed/pages/main_shell.dart
          - lib/features/feed/widgets/floating_sidebar.dart
          - lib/features/feed/widgets/reply_input.dart
    - uuid: 'f4a0b1c2-3d4e-4f5a-6b7c-8d9e0f1a2b3c'
      status: 'done'
      name: 'Part 6: Radar Page Micro-Extractions'
      reason: |
        radar_page.dart is 700+ LOC. `_RadarRingAnimation` and `_MatchRadarRing` are nearly identical (only color/size differ). `_Particles` and `_Particle` are reusable.
      steps:
        - uuid: 'a5b1c2d3-4e5f-4a6b-7c8d-9e0f1a2b3c4d'
          status: 'done'
          name: 'Extract Ring and Particles Widgets'
          reason: 'Remove ~80 LOC from radar_page.dart'
          files:
            - lib/shared/widgets/ring_animation.dart
          operations:
            - 'Create `lib/shared/widgets/ring_animation.dart`'
            - 'Create `PulsingRing` widget with `color`, `initialSize`, `endScale`, `duration`, `delay` parameters'
            - 'Create `FloatingParticles` widget with `color`, `count`, `areaWidth`, `areaHeight` parameters'
        - uuid: 'b6c2d3e4-5f6a-4b7c-8d9e-0f1a2b3c4d5e'
          status: 'done'
          name: 'Refactor Radar Page to Use Extracted Widgets'
          reason: 'Apply the extractions'
          files:
            - lib/features/feed/pages/radar_page.dart
          operations:
            - 'Replace `_RadarRingAnimation` with `PulsingRing(color: AppColors.primary, ...)`'
            - 'Replace `_MatchRadarRing` with `PulsingRing(color: Color(0xFF34D399), ...)`'
            - 'Replace `_Particles` + `_ParticleData` + `_Particle` with single `FloatingParticles(color: Color(0xFF10B981))` call'
            - 'Delete ~80 lines of now-unused private widget classes'
      context_files:
        compact:
          - lib/shared/widgets/ring_animation.dart
        medium:
          - lib/shared/widgets/ring_animation.dart
          - lib/features/feed/pages/radar_page.dart
        extended:
          - lib/shared/widgets/ring_animation.dart
          - lib/features/feed/pages/radar_page.dart
  conclusion: |
    This plan removes an estimated 450-550 LOC through six targeted extractions. The color extensions alone save ~200 lines of verbose opacity syntax. BaseSheet eliminates ~120 lines from three files. Icon centralization removes ~40 lines of duplicated switch statements. Glass consolidation removes ~60 lines of repeated BackdropFilter patterns.

    The key principle: every new abstraction must be used 3+ times immediately. No speculative generality. The resulting code is denser but equally readable—`Colors.white.w10` is more scannable than `Colors.white.withOpacity(0.1)`.
  context_files:
    compact:
      - lib/shared/utils/color_extensions.dart
      - lib/shared/utils/decorations.dart
      - lib/shared/widgets/base_sheet.dart
      - lib/shared/utils/task_icons.dart
      - lib/shared/widgets/glass_card.dart
      - lib/shared/widgets/ring_animation.dart
    medium:
      - lib/shared/utils/color_extensions.dart
      - lib/shared/utils/decorations.dart
      - lib/shared/widgets/base_sheet.dart
      - lib/shared/utils/task_icons.dart
      - lib/shared/widgets/glass_card.dart
      - lib/shared/widgets/ring_animation.dart
      - lib/features/feed/pages/post_detail/bid_sheet.dart
      - lib/features/feed/pages/radar_page.dart
    extended:
      - lib/shared/utils/color_extensions.dart
      - lib/shared/utils/decorations.dart
      - lib/shared/widgets/base_sheet.dart
      - lib/shared/utils/task_icons.dart
      - lib/shared/widgets/glass_card.dart
      - lib/shared/widgets/ring_animation.dart
      - lib/features/feed/pages/post_detail/bid_sheet.dart
      - lib/features/feed/pages/post_detail/completion_sheet.dart
      - lib/features/feed/pages/post_detail/review_sheet.dart
      - lib/features/feed/pages/radar_page.dart
      - lib/features/feed/widgets/task_card.dart
      - lib/features/feed/pages/main_shell.dart
      - lib/features/feed/widgets/floating_sidebar.dart
      - lib/features/feed/widgets/reply_input.dart
```
