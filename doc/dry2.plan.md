```yaml
plan:
  uuid: 'b1c2d3e4-5f6a-4b7c-8d9e-0f1a2b3c4d5e'
  status: 'in-progress'
  title: 'Deep DRY Phase 2: Comprehensive Code Deduplication to -5000 LOC'
  introduction: |
    Phase 1 (dry1) removed ~500 LOC by extracting color extensions, decoration presets, BaseSheet, icon centralization, glass consolidation, and radar micro-extractions. This plan targets the remaining ~4500 LOC reduction through 15 aggressive but safe refactoring parts.

    The codebase has 14,252 hand-written LOC across 64 files (excluding .freezed.dart generated files). To reach a net -5000 LOC from the pre-phase-1 baseline, we need to find and eliminate duplication at every level: inline widget trees, repeated TextStyle patterns, duplicated state management, redundant widget scaffolding, and verbose sample data.

    Every extraction follows the same rules as Phase 1:
    - Each new abstraction MUST be used 3+ times immediately
    - No speculative generality
    - Pixel-identical visual output
    - Net LOC reduction per extraction
  parts:
    - uuid: 'c2d3e4f5-6a7b-4c8d-9e0f-1a2b3c4d5e6f'
      status: 'pending'
      name: 'Part 1: Named TextStyle Constants in AppTheme'
      reason: |
        `AppTheme.scaled(...)` is called 300+ times across 30+ files. The majority use identical parameter combinations that repeat 10-20+ times each. Currently AppTheme only has `labelTiny` and `labelMicro` as named constants. Adding 20 named TextStyle constants eliminates 3-5 lines per call site.

        Top repeated patterns found by scanning all 64 hand-written files:
        - `scaled(multiplier: m2xs, weight: w900, letterSpacing: 2, color: ...)` — ~28 occurrences (section labels)
        - `scaled(multiplier: mlg, weight: w900, color: onSurface, height: 1.2)` — ~16 occurrences (card/subsection titles)
        - `scaled(multiplier: mxs, weight: w700, color: onSurfaceVariant)` — ~22 occurrences (meta text)
        - `scaled(multiplier: m2xl, weight: w900, color: onSurface)` — ~14 occurrences (sheet titles)
        - `scaled(multiplier: mbase, weight: w900, letterSpacing: 2, color: ...)` — ~18 occurrences (action labels)
        - `scaled(multiplier: m1sm, weight: w700, color: onSurfaceVariant)` — ~15 occurrences (secondary meta)
        - `scaled(multiplier: m2sm, weight: w900, letterSpacing: 2, color: ...)` — ~12 occurrences (small labels)
        - `scaled(multiplier: mxl, weight: w900, color: onSurface, letterSpacing: -0.5)` — ~10 occurrences (value displays)
        - `scaled(multiplier: m13, weight: w500, color: onSurfaceVariant)` — ~14 occurrences (body text)
        - `scaled(multiplier: m13, weight: w700, color: onSurface/white, letterSpacing: 1)` — ~10 occurrences (button labels)
      steps:
        - uuid: 'd3e4f5a6-7b8c-4d9e-0f1a-2b3c4d5e6f7a'
          status: 'pending'
          name: 'Add Named TextStyle Constants to AppTheme'
          reason: 'Create 20 named constants covering the most common scaled() combos'
          files:
            - lib/app_theme.dart
          operations:
            - 'Add `static const TextStyle sectionLabel = TextStyle(fontSize: 14*0.643, fontWeight: FontWeight.w900, letterSpacing: 2, color: AppColors.onSurfaceVariant)`'
            - 'Add `static const TextStyle sectionLabelWhite = TextStyle(fontSize: 14*0.643, fontWeight: FontWeight.w900, letterSpacing: 2, color: Colors.white)`'
            - 'Add `static const TextStyle cardTitle = TextStyle(fontSize: 14*1.143, fontWeight: FontWeight.w900, color: AppColors.onSurface, height: 1.2)`'
            - 'Add `static const TextStyle meta = TextStyle(fontSize: 14*0.857, fontWeight: FontWeight.w700, color: AppColors.onSurfaceVariant)`'
            - 'Add `static const TextStyle metaMuted = TextStyle(fontSize: 14*0.857, fontWeight: FontWeight.w700, color: AppColors.onSurfaceVariant.withOpacity(0.6))`'
            - 'Add `static const TextStyle sheetTitle = TextStyle(fontSize: 14*1.286, fontWeight: FontWeight.w900, color: AppColors.onSurface)`'
            - 'Add `static const TextStyle actionLabel = TextStyle(fontSize: 14*1.0, fontWeight: FontWeight.w900, letterSpacing: 2)`'
            - 'Add `static const TextStyle body = TextStyle(fontSize: 14*0.929, fontWeight: FontWeight.w500, color: AppColors.onSurfaceVariant)`'
            - 'Add `static const TextStyle valueDisplay = TextStyle(fontSize: 14*1.286, fontWeight: FontWeight.w900, color: AppColors.onSurface, letterSpacing: -0.5)`'
            - 'Add `static const TextStyle buttonLabel = TextStyle(fontSize: 14*0.929, fontWeight: FontWeight.w700, letterSpacing: 1)`'
            - 'Add `static const TextStyle smallLabel = TextStyle(fontSize: 14*0.714, fontWeight: FontWeight.w900, letterSpacing: 2, color: AppColors.onSurfaceVariant)`'
            - 'Add `static const TextStyle largeTitle = TextStyle(fontSize: 14*1.429, fontWeight: FontWeight.w900, color: AppColors.onSurface)`'
            - 'Add `static const TextStyle largeTitleWhite = TextStyle(fontSize: 14*1.429, fontWeight: FontWeight.w900, color: Colors.white)`'
            - 'Add `static const TextStyle bodyBold = TextStyle(fontSize: 14*1.0, fontWeight: FontWeight.w700, color: AppColors.onSurface)`'
            - 'Add `static const TextStyle caption = TextStyle(fontSize: 14*0.786, fontWeight: FontWeight.w500, color: AppColors.onSurfaceVariant)`'
            - 'Add `static const TextStyle heroTitle = TextStyle(fontSize: 14*1.571, fontWeight: FontWeight.w900, color: Colors.white)`'
            - 'Add `static const TextStyle tagLabel = TextStyle(fontSize: 14*0.714, fontWeight: FontWeight.w900, letterSpacing: 1.5)`'
            - 'Add `static const TextStyle inputLabel = TextStyle(fontSize: 14*0.786, fontWeight: FontWeight.w700, color: AppColors.onSurfaceVariant.withOpacity(0.4))`'
            - 'Add `static const TextStyle priceDisplay = TextStyle(fontSize: 14*2.0, fontWeight: FontWeight.w900, color: AppColors.onSurface, letterSpacing: -1)`'
            - 'Add `static const TextStyle countDisplay = TextStyle(fontSize: 14*1.143, fontWeight: FontWeight.w900, color: Colors.white)`'
        - uuid: 'e4f5a6b7-8c9d-4e0f-1a2b-3c4d5e6f7a8b'
          status: 'pending'
          name: 'Apply Named TextStyle Constants Across Codebase'
          reason: 'Replace 180+ verbose AppTheme.scaled() calls with named constants'
          files:
            - lib/features/feed/pages/radar_page.dart
            - lib/features/feed/pages/task_main_content.dart
            - lib/features/feed/pages/create_reply_page.dart
            - lib/features/feed/pages/feed_page.dart
            - lib/features/feed/pages/post_detail/bid_sheet.dart
            - lib/features/feed/pages/post_detail/completion_sheet.dart
            - lib/features/feed/pages/post_detail/review_sheet.dart
            - lib/features/feed/pages/post_detail/task_action_footer.dart
            - lib/features/feed/pages/post_detail/task_sliver_app_bar.dart
            - lib/features/feed/pages/post_detail/empty_replies_state.dart
            - lib/features/feed/widgets/task_card.dart
            - lib/features/feed/widgets/social_post_card.dart
            - lib/features/feed/widgets/base_feed_card.dart
            - lib/features/feed/widgets/feed_composer.dart
            - lib/features/feed/widgets/reply_input.dart
            - lib/features/feed/widgets/kanban_column_widget.dart
            - lib/features/feed/widgets/floating_sidebar.dart
            - lib/features/feed/widgets/editorial_card.dart
            - lib/features/settings/pages/settings_page.dart
            - lib/shared/widgets/post_actions.dart
            - lib/shared/widgets/karma_badge.dart
            - lib/shared/widgets/view_stats_badge.dart
            - lib/shared/widgets/tag_pill.dart
            - lib/shared/widgets/voice_note_player.dart
            - lib/shared/widgets/map_preview.dart
            - lib/shared/widgets/media_carousel.dart
            - lib/shared/widgets/ring_animation.dart
            - lib/shared/widgets/primary_action_button.dart
          operations:
            - 'Replace all `AppTheme.scaled(multiplier: AppTheme.m2xs, weight: FontWeight.w900, letterSpacing: 2, color: ...)` with `AppTheme.sectionLabel.copyWith(color: ...)` or `AppTheme.sectionLabelWhite.copyWith(...)`'
            - 'Replace all `AppTheme.scaled(multiplier: AppTheme.mlg, weight: FontWeight.w900, color: AppColors.onSurface, height: 1.2)` with `AppTheme.cardTitle`'
            - 'Replace all `AppTheme.scaled(multiplier: AppTheme.mxs, weight: FontWeight.w700, color: AppColors.onSurfaceVariant)` with `AppTheme.meta`'
            - 'Replace all `AppTheme.scaled(multiplier: AppTheme.m2xl, weight: FontWeight.w900, color: AppColors.onSurface)` with `AppTheme.sheetTitle`'
            - 'Replace all `AppTheme.scaled(multiplier: AppTheme.mbase, weight: FontWeight.w900, letterSpacing: 2, ...)` with `AppTheme.actionLabel.copyWith(...)`'
            - 'Replace all `AppTheme.scaled(multiplier: AppTheme.m1sm, weight: FontWeight.w700, color: AppColors.onSurfaceVariant)` with `AppTheme.body`'
            - 'Replace all `AppTheme.scaled(multiplier: AppTheme.m2sm, weight: FontWeight.w900, letterSpacing: 2, ...)` with `AppTheme.smallLabel.copyWith(...)`'
            - 'Replace all `AppTheme.scaled(multiplier: AppTheme.mxl, weight: FontWeight.w900, color: AppColors.onSurface, letterSpacing: -0.5)` with `AppTheme.valueDisplay`'
            - 'Replace all other common combos with their matching named constant'
            - 'Where a named constant matches exactly (all params identical), use the constant directly — no .copyWith() needed'
      estimated_loc_reduction: 450
      context_files:
        compact:
          - lib/app_theme.dart
        medium:
          - lib/app_theme.dart
          - lib/features/feed/pages/radar_page.dart
          - lib/features/feed/pages/task_main_content.dart
        extended:
          - lib/app_theme.dart
          - lib/features/feed/pages/radar_page.dart
          - lib/features/feed/pages/task_main_content.dart
          - lib/features/feed/widgets/base_feed_card.dart
          - lib/features/feed/pages/post_detail/bid_sheet.dart

    - uuid: 'f5a6b7c8-9d0e-4f1a-2b3c-4d5e6f7a8b9c'
      status: 'completed'
      name: 'Part 2: Shared Widgets — ThemedBackground, GlassPill, SectionLabel, GradientDivider'
      reason: |
        Four small but widely-used widget patterns are inlined repeatedly. Extracting each into a shared widget yields a clean LOC reduction since each inline usage is 5-10 lines but each widget is 1 line to use.
      steps:
        - uuid: 'a6b7c8d9-0e1f-4a2b-3c4d-5e6f7a8b9c0d'
          status: 'completed'
          name: 'Create Shared Micro-Widgets'
          reason: 'Extract 4 repeated inline patterns into named shared widgets'
          files:
            - lib/shared/widgets/themed_background.dart
            - lib/shared/widgets/glass_pill.dart
            - lib/shared/widgets/section_label.dart
            - lib/shared/widgets/gradient_divider.dart
          operations:
            - 'Create `ThemedBackground` widget: reads ThemeColor from settings, renders `Positioned.fill > IgnorePointer > Container(gradient: AppTheme.backgroundGradient(...))`'
            - 'Create `GlassPill({required Widget child, EdgeInsets? padding})` widget: wraps child in `Container(decoration: BoxDecoration(color: glassTint, borderRadius: 20, border: Border.all(color: glassBorder)))` with optional horizontal padding'
            - 'Create `SectionLabel({required String label, Color? color})` widget: renders the `_buildSectionLabel` pattern — `Text(label, style: AppTheme.sectionLabel.copyWith(color: ...))`'
            - 'Create `GradientDivider({double height = 1, Color? color})` widget: renders a `Container(height: h, decoration: BoxDecoration(gradient: LinearGradient(colors: [transparent, color ?? white.w08, transparent])))`'
        - uuid: 'b7c8d9e0-1f2a-4b3c-4d5e-6f7a8b9c0d1e'
          status: 'completed'
          name: 'Apply Shared Micro-Widgets Across Codebase'
          reason: 'Replace ~60+ inline usages with 1-line widget calls'
          files:
            - lib/features/feed/pages/main_shell.dart
            - lib/features/feed/pages/radar_page.dart
            - lib/features/feed/pages/desktop_kanban_layout.dart
            - lib/features/feed/pages/task_main_content.dart
            - lib/features/feed/pages/post_detail_page.dart
            - lib/features/feed/widgets/task_card.dart
            - lib/features/feed/widgets/social_post_card.dart
            - lib/features/feed/widgets/base_feed_card.dart
            - lib/shared/widgets/view_stats_badge.dart
            - lib/shared/widgets/karma_badge.dart
            - lib/shared/widgets/tag_pill.dart
          operations:
            - 'In main_shell.dart, radar_page.dart, desktop_kanban_layout.dart: replace `Positioned.fill > IgnorePointer > Container(decoration: BoxDecoration(gradient: ...))` with `ThemedBackground()` — saves 8 lines per file = 24 lines'
            - 'In task_main_content.dart `_buildInfoPill`: replace the Container + glassTint/glassBorder pattern with `GlassPill(child: Row(...))` — saves 5 lines'
            - 'In view_stats_badge.dart: replace glass pill decoration with `GlassPill(child: ...)` — saves 5 lines'
            - 'In karma_badge.dart: replace glass pill decoration with `GlassPill(child: ...)` — saves 5 lines'
            - 'In task_main_content.dart: replace all `_buildSectionLabel("...")` calls with `SectionLabel(label: "...")` — saves 8 lines per call, ~7 calls = 56 lines'
            - 'In task_main_content.dart `_buildPostActions` and `_buildHeader`: replace gradient divider with `GradientDivider()` — saves 10 lines per call, 2 calls = 20 lines'
      estimated_loc_reduction: 180
      context_files:
        compact:
          - lib/shared/widgets/themed_background.dart
          - lib/shared/widgets/glass_pill.dart
          - lib/shared/widgets/section_label.dart
          - lib/shared/widgets/gradient_divider.dart
        medium:
          - lib/shared/widgets/glass_pill.dart
          - lib/features/feed/pages/task_main_content.dart
          - lib/features/feed/pages/main_shell.dart
        extended:
          - lib/shared/widgets/glass_pill.dart
          - lib/features/feed/pages/task_main_content.dart
          - lib/shared/widgets/view_stats_badge.dart
          - lib/shared/widgets/karma_badge.dart

    - uuid: 'c8d9e0f1-2a3b-4c4d-5e6f-7a8b9c0d1e2f'
      status: 'pending'
      name: 'Part 3: InputDecoration Presets & InputDecorationTheme Enhancement'
      reason: |
        InputDecoration is constructed with verbose repeated patterns across 8+ files. The app already has an InputDecorationTheme in AppTheme.darkTheme but many widgets override it with inline InputDecoration that has the same border/fill patterns. Creating preset InputDecoration factories and enhancing the global theme eliminates this duplication.
      steps:
        - uuid: 'd9e0f1a2-3b4c-4d5e-6f7a-8b9c0d1e2f3a'
          status: 'pending'
          name: 'Create InputDecoration Presets in AppDecorations'
          reason: 'Standardize input decoration patterns used in sheets, replies, and forms'
          files:
            - lib/shared/utils/decorations.dart
          operations:
            - 'Add `InputDecoration glassInputField({String? hintText, String? hintText2, TextStyle? hintStyle, int maxLines = 1})` returning InputDecoration with: white.w05 fill, white.w10 border radius 20, white.w10 enabled border, primary.p50 focused border, white.w30 hintStyle'
            - 'Add `InputDecoration borderlessInput({TextStyle? style})` returning InputDecoration with: InputBorder.none for border/enabled/focused, isDense: true, contentPadding: EdgeInsets.zero'
            - 'Add `InputDecoration glassInputArea({String? hintText})` returning InputDecoration with same glass styling but maxLines: null (multi-line text area)'
        - uuid: 'e0f1a2b3-4c5d-4e6f-7a8b-9c0d1e2f3a4b'
          status: 'pending'
          name: 'Apply InputDecoration Presets Across Codebase'
          reason: 'Replace ~25 inline InputDecoration constructions with preset calls'
          files:
            - lib/features/feed/pages/radar_page.dart
            - lib/features/feed/pages/post_detail/bid_sheet.dart
            - lib/features/feed/pages/post_detail/completion_sheet.dart
            - lib/features/feed/pages/post_detail/task_action_footer.dart
            - lib/features/feed/widgets/reply_input.dart
            - lib/features/feed/widgets/feed_composer.dart
            - lib/features/feed/pages/create_reply_page.dart
          operations:
            - 'In radar_page.dart bid sheet: replace the 20-line InputDecoration (border/enabled/focused/filled/fillColor/hintStyle) with `glassInputArea(hintText: "Why should they choose you? (Optional)")` — saves ~15 lines'
            - 'In bid_sheet.dart: replace the InputDecoration for bid pitch TextField with `glassInputArea(hintText: "...")` — saves ~12 lines'
            - 'In completion_sheet.dart: replace InputDecoration with `glassInputField(hintText: "...")` — saves ~8 lines'
            - 'In task_action_footer.dart: replace InputDecoration with `glassInputField(hintText: "...")` — saves ~8 lines'
            - 'In reply_input.dart: replace the InputDecoration with `borderlessInput()` — saves ~6 lines'
            - 'In feed_composer.dart: replace InputDecoration calls with `borderlessInput()` — saves ~6 lines per call, 2 calls = 12 lines'
            - 'In create_reply_page.dart: replace InputDecoration with appropriate preset — saves ~8 lines'
      estimated_loc_reduction: 120
      context_files:
        compact:
          - lib/shared/utils/decorations.dart
        medium:
          - lib/shared/utils/decorations.dart
          - lib/features/feed/pages/radar_page.dart
          - lib/features/feed/pages/post_detail/bid_sheet.dart
        extended:
          - lib/shared/utils/decorations.dart
          - lib/features/feed/pages/radar_page.dart
          - lib/features/feed/widgets/reply_input.dart
          - lib/features/feed/pages/post_detail/task_action_footer.dart

    - uuid: 'd9e0f1a2-3b4c-4d5e-6f7a-8b9c0d1e2f3a'
      status: 'pending'
      name: 'Part 4: Settings Page Section Abstraction'
      reason: |
        `_ThemeColorSection`, `_TextSizeSection`, `_ZoomSection` in settings_page.dart share an identical container/header structure: padding all(20), decoration with surfaceContainerLow color, radius 24, white.withOpacity(0.05) border, and shadow. Each has an icon box (40x40, radius 16), title (mlg, w900), and subtitle (mxs, w500). Only the icon, title text, subtitle text, and child content differ.
      steps:
        - uuid: 'e0f1a2b3-4c5d-4e6f-7a8b-9c0d1e2f3a4b'
          status: 'pending'
          name: 'Create SettingsSection Widget'
          reason: 'Extract the shared 45-line container+header pattern into a reusable widget'
          files:
            - lib/features/settings/pages/settings_page.dart
          operations:
            - 'Create `SettingsSection({required IconData icon, required String title, required String subtitle, required Widget child, Color? iconBgColor, Color? iconColor})` widget at the top of settings_page.dart (private to the file)'
            - 'The widget renders: Container(padding: all(20), decoration: BoxDecoration(color: surfaceContainerLow, borderRadius: 24, border: ..., boxShadow: ...), child: Column(children: [header Row, SizedBox(24), child]))'
            - 'Header row: Container(40x40, iconBox decoration) + Column(title with cardTitle style, subtitle with meta style)'
        - uuid: 'f1a2b3c4-5d6e-4f7a-8b9c-0d1e2f3a4b5c'
          status: 'pending'
          name: 'Refactor Settings Sections to Use SettingsSection'
          reason: 'Replace ~135 lines of duplicated structure across 3 sections'
          files:
            - lib/features/settings/pages/settings_page.dart
          operations:
            - 'Replace `_ThemeColorSection` body with `SettingsSection(icon: PhosphorIconsRegular.palette, title: "Theme Color", subtitle: "Choose your primary accent color", iconBgColor: AppColors.primary.withOpacity(0.1), iconColor: AppColors.primary, child: Wrap(...))`'
            - 'Replace `_TextSizeSection` body with `SettingsSection(icon: PhosphorIconsRegular.textT, title: "Typography Size", subtitle: "Adjust the base text scale", child: _SegmentedControl(...))`'
            - 'Replace `_ZoomSection` body with `SettingsSection(icon: PhosphorIconsRegular.magnifyingGlassPlus, title: "Display Zoom", subtitle: "Scale the entire interface", child: _SegmentedControl(...))`'
            - 'Delete the three private class definitions, keeping only `_SegmentedControl` and `_ColorCircle` as separate widgets'
      estimated_loc_reduction: 100
      context_files:
        compact:
          - lib/features/settings/pages/settings_page.dart
        medium:
          - lib/features/settings/pages/settings_page.dart
        extended:
          - lib/features/settings/pages/settings_page.dart

    - uuid: 'e0f1a2b3-4c5d-4e6f-7a8b-9c0d1e2f3a4b'
      status: 'pending'
      name: 'Part 5: Delete BottomSheetContainer — Unify on BaseSheet'
      reason: |
        `BottomSheetContainer` (79 LOC) and `BaseSheet` (98 LOC) are nearly identical: both have title, child, onClose, show() static method, Container with surface decoration, title row with close button, and padding. The only differences are minor: BaseSheet uses surfaceSheetDecor() while BottomSheetContainer has inline decoration, and BaseSheet uses PhosphorIcons while BottomSheetContainer uses Material Icons. BaseSheet should be the single sheet widget.
      steps:
        - uuid: 'f1a2b3c4-5d6e-4f7a-8b9c-0d1e2f3a4b5c'
          status: 'pending'
          name: 'Audit and Remove BottomSheetContainer Usages'
          reason: 'Ensure nothing references BottomSheetContainer before deletion'
          files:
            - lib/shared/widgets/bottom_sheet_container.dart
            - lib/shared/widgets/base_sheet.dart
          operations:
            - 'Search for all imports and usages of `BottomSheetContainer` across the codebase'
            - 'Replace any remaining usages with `BaseSheet` (matching title, child, onClose parameters)'
            - 'Delete `lib/shared/widgets/bottom_sheet_container.dart` entirely'
            - 'If no usages remain, also remove the export from any barrel files'
      estimated_loc_reduction: 80
      context_files:
        compact:
          - lib/shared/widgets/base_sheet.dart
        medium:
          - lib/shared/widgets/base_sheet.dart
          - lib/shared/widgets/bottom_sheet_container.dart
        extended:
          - lib/shared/widgets/base_sheet.dart
          - lib/shared/widgets/bottom_sheet_container.dart

    - uuid: 'f1a2b3c4-5d6e-4f7a-8b9c-0d1e2f3a4b5c'
      status: 'completed'
      name: 'Part 6: FeedPage TabController Mixin Extraction'
      reason: |
        Both `_KanbanFeedHeaderState` and `_FeedHeaderState` in feed_page.dart implement identical TabController lifecycle boilerplate (~40 lines each):
        - initState: create TabController(length: 2, vsync: this) + addListener
        - _onTabChanged: check indexIsChanging
        - didUpdateWidget: sync tabController.index
        - dispose: removeListener + dispose

        Additionally, both build methods share the same GlassHeader > Row > [UserAvatar, _TabBar, KarmaBadge] structure.
      steps:
        - uuid: 'a2b3c4d5-6e7f-4a8b-9c0d-1e2f3a4b5c6d'
          status: 'completed'
          name: 'Create ManagedTabController Mixin and Shared Feed Header'
          reason: 'Extract TabController lifecycle into a mixin and shared header builder'
          files:
            - lib/features/feed/pages/feed_page.dart
          operations:
            - 'Create `mixin ManagedTabController<T extends ConsumerStatefulWidget> on SingleTickerProviderStateMixin, ConsumerState<T>` with: late TabController tabController, abstract int get initialTabIndex, void onTabIndexChanged(int index), void didChangeTab(int oldIndex, int newIndex), standard initState/didUpdateWidget/dispose overrides that handle TabController lifecycle'
            - 'Create a shared `_buildFeedHeaderRow({required Widget left, required Widget right})` method or extract `FeedHeaderContent` widget that takes left/right children and renders GlassHeader > Row pattern'
            - 'Refactor `_KanbanFeedHeaderState` to use the mixin — eliminates ~30 lines of TabController boilerplate'
            - 'Refactor `_FeedHeaderState` to use the mixin — eliminates ~30 lines of TabController boilerplate'
            - 'Share the GlassHeader > Row > [avatar, tabBar, karmaBadge] structure between both headers'
        - uuid: 'b3c4d5e6-7f8a-4b9c-0d1e-2f3a4b5c6d7e'
          status: 'completed'
          name: 'Simplify FeedPage Build Methods'
          reason: 'Reduce duplication between kanban and mobile feed rendering'
          files:
            - lib/features/feed/pages/feed_page.dart
          operations:
            - 'Extract the shared `RefreshIndicator > ListView.builder` pattern into a helper method `_buildFeedList({required List<FeedItem> items, required Widget Function(int) headerBuilder, required int headerCount})`'
            - 'Both the kanban and mobile paths use identical RefreshIndicator + ListView.builder + BouncingScrollPhysics — extract this common structure'
      estimated_loc_reduction: 120
      context_files:
        compact:
          - lib/features/feed/pages/feed_page.dart
        medium:
          - lib/features/feed/pages/feed_page.dart
        extended:
          - lib/features/feed/pages/feed_page.dart

    - uuid: 'a2b3c4d5-6e7f-4a8b-9c0d-1e2f3a4b5c6d'
      status: 'completed'
      name: 'Part 7: Utility Extractions — formatCount, parsePrice, CloseButton'
      reason: |
        Small utility functions are duplicated or repeated inline across multiple files. Extracting them saves lines and centralizes logic.
      steps:
        - uuid: 'b3c4d5e6-7f8a-4b9c-0d1e-2f3a4b5c6d7e'
          status: 'completed'
          name: 'Create Shared Utility Extensions'
          reason: 'Extract duplicated utility functions into shared location'
          files:
            - lib/shared/utils/string_extensions.dart
            - lib/shared/utils/price_utils.dart
            - lib/shared/widgets/close_button.dart
          operations:
            - 'Create `extension StringX on String` (or standalone functions) with `String formatCompact()` that formats numbers >= 1000 as "1.2k" — used in post_actions.dart _formatCount, view_stats_badge.dart _formatCount, and post_actions.dart _VotePill'
            - 'Create `int parsePrice(String price)` utility that extracts numeric value from price string — used in radar_page.dart line 534, bid_sheet.dart, and post_detail_page.dart — pattern: `int.tryParse(price.replaceAll(RegExp(r"[^0-9]"), "")) ?? 0`'
            - 'Create `CloseButton({required VoidCallback onTap})` widget that renders the standard close button: Container(36x36, white.w05 bg, radius 18) > Icon(PhosphorIconsRegular.x, size 20, white.w50) — used in radar_page.dart bid sheet, BaseSheet, kanban_column_widget.dart'
        - uuid: 'c4d5e6f7-8a9b-4c0d-1e2f-3a4b5c6d7e8f'
          status: 'completed'
          name: 'Apply Utility Extractions'
          reason: 'Replace inline duplicated patterns with shared utilities'
          files:
            - lib/shared/widgets/post_actions.dart
            - lib/shared/widgets/view_stats_badge.dart
            - lib/features/feed/pages/radar_page.dart
            - lib/features/feed/pages/post_detail/bid_sheet.dart
            - lib/features/feed/widgets/kanban_column_widget.dart
            - lib/shared/widgets/base_sheet.dart
          operations:
            - 'In post_actions.dart: delete private `_formatCount` method, replace calls with `count.formatCompact()` or the extension method'
            - 'In view_stats_badge.dart: delete private `_formatCount` method, replace calls with the shared extension'
            - 'In radar_page.dart: replace `int.tryParse(gig.price.replaceAll(...))` with `parsePrice(gig.price)`'
            - 'In bid_sheet.dart: replace price parsing with `parsePrice(...)`'
            - 'In radar_page.dart bid overlay close button: replace 10-line GestureDetector + Container + Icon with `CloseButton(onTap: ...)`'
            - 'In BaseSheet: replace the close IconButton with `CloseButton(onTap: ...)` — saves 5 lines'
            - 'In kanban_column_widget.dart: replace any inline close button with `CloseButton(onTap: ...)`'
      estimated_loc_reduction: 80
      context_files:
        compact:
          - lib/shared/utils/string_extensions.dart
          - lib/shared/utils/price_utils.dart
          - lib/shared/widgets/close_button.dart
        medium:
          - lib/shared/utils/string_extensions.dart
          - lib/shared/widgets/post_actions.dart
          - lib/features/feed/pages/radar_page.dart
        extended:
          - lib/shared/utils/string_extensions.dart
          - lib/shared/widgets/post_actions.dart
          - lib/shared/widgets/view_stats_badge.dart
          - lib/features/feed/pages/radar_page.dart

    - uuid: 'b3c4d5e6-7f8a-4b9c-0d1e-2f3a4b5c6d7e'
      status: 'completed'
      name: 'Part 8: VoiceNotePlayer Reuse in SocialPostCard'
      reason: |
        `social_post_card.dart` lines 177-252 contain a hand-coded voice note player (play circle button, progress bar with FractionallySizedBox, time labels) that duplicates the purpose of the existing `VoiceNotePlayer` widget (122 LOC) at `shared/widgets/voice_note_player.dart`. The social_post_card version is a simplified but structurally identical implementation — 75 lines of duplicated UI code.
      steps:
        - uuid: 'c4d5e6f7-8a9b-4c0d-1e2f-3a4b5c6d7e8f'
          status: 'completed'
          name: 'Replace Inline VoiceNote with Shared Widget'
          reason: 'Remove 75 lines of duplicated voice note UI from social_post_card.dart'
          files:
            - lib/features/feed/widgets/social_post_card.dart
            - lib/shared/widgets/voice_note_player.dart
          operations:
            - 'Verify VoiceNotePlayer accepts `duration` parameter and renders play button, progress bar, time labels'
            - 'In social_post_card.dart: replace the 75-line inline voice note Container/Row/Column with `VoiceNotePlayer(duration: data.voiceNote!)`'
            - 'If VoiceNotePlayer needs any adjustments to match the inline version exactly, make minimal changes (e.g., ensure progress bar widthFactor is configurable)'
            - 'Remove unused imports if any'
      estimated_loc_reduction: 70
      context_files:
        compact:
          - lib/shared/widgets/voice_note_player.dart
        medium:
          - lib/shared/widgets/voice_note_player.dart
          - lib/features/feed/widgets/social_post_card.dart
        extended:
          - lib/shared/widgets/voice_note_player.dart
          - lib/features/feed/widgets/social_post_card.dart

    - uuid: 'c4d5e6f7-8a9b-4c0d-1e2f-3a4b5c6d7e8f'
      status: 'completed'
      name: 'Part 9: ToggleSetNotifier Base Class for ViewModels'
      reason: |
        In `app_viewmodel.dart`, `UserRepostsNotifier` and `FollowedHandlesNotifier` share an identical `toggle(String)` method pattern:
        ```
        void toggle(String id) {
          final newSet = Set<String>.from(state);
          if (newSet.contains(id)) newSet.remove(id);
          else newSet.add(id);
          state = newSet;
        }
        ```
        Both also have a `bool contains(String id)` pattern. Extracting a base class eliminates ~30 lines.
      steps:
        - uuid: 'd5e6f7a8-9b0c-4d1e-2f3a-4b5c6d7e8f9a'
          status: 'completed'
          name: 'Create ToggleSetNotifier Base Class'
          reason: 'Eliminate duplicated toggle logic between two Notifier classes'
          files:
            - lib/features/feed/viewmodels/app_viewmodel.dart
          operations:
            - 'Create `abstract class ToggleSetNotifier extends Notifier<Set<String>>` with: `void toggle(String id)` method implementing the contains/add/remove pattern, and `bool contains(String id) => state.contains(id)`'
            - 'Refactor `UserRepostsNotifier extends ToggleSetNotifier` — remove `toggle()` and `hasReposted()` body (override `hasReposted` to call `contains`)'
            - 'Refactor `FollowedHandlesNotifier extends ToggleSetNotifier` — remove `toggle()` and `isFollowing()` body (override `isFollowing` to call `contains`)'
            - 'Keep `UserVotesNotifier` as-is since its toggle logic is different (it handles upvote/downvote states, not just set membership)'
      estimated_loc_reduction: 30
      context_files:
        compact:
          - lib/features/feed/viewmodels/app_viewmodel.dart
        medium:
          - lib/features/feed/viewmodels/app_viewmodel.dart
        extended:
          - lib/features/feed/viewmodels/app_viewmodel.dart

    - uuid: 'd5e6f7a8-9b0c-4d1e-2f3a-4b5c6d7e8f9a'
      status: 'completed'
      name: 'Part 10: AnimatedSlide Presets & Repeated Animation Patterns'
      reason: |
        `AnimatedSlide(offset: ..., duration: Duration(milliseconds: 250), curve: Curves.easeOutCubic)` repeats identically in main_shell.dart, feed_page.dart, and desktop_kanban_layout.dart. Other repeated animation patterns include `AnimatedContainer(duration: Duration(milliseconds: 300), curve: Curves.easeOutCubic)` (6+ occurrences) and `AnimatedSize(duration: Duration(milliseconds: 250), curve: Curves.easeOutCubic)` (3+ occurrences).
      steps:
        - uuid: 'e6f7a8b9-0c1d-4e2f-3a4b-5c6d7e8f9a0b'
          status: 'completed'
          name: 'Create Animation Constants in AppTheme'
          reason: 'Standardize repeated duration and curve values'
          files:
            - lib/app_theme.dart
          operations:
            - 'Add `static const Duration animFast = Duration(milliseconds: 200)`'
            - 'Add `static const Duration animNormal = Duration(milliseconds: 250)`'
            - 'Add `static const Duration animSlide = Duration(milliseconds: 300)`'
            - 'Add `static const Duration animSheet = Duration(milliseconds: 400)`'
            - 'Add `static const Curve curveOut = Curves.easeOutCubic`'
            - 'Add `static const Curve curveOutQuart = Curves.easeOut`'
            - 'Add `static const Curve curveIn = Curves.easeIn`'
        - uuid: 'f7a8b9c0-1d2e-4f3a-4b5c-6d7e8f9a0b1c'
          status: 'completed'
          name: 'Apply Animation Constants Across Codebase'
          reason: 'Replace inline Duration/Curve with named constants'
          files:
            - lib/features/feed/pages/main_shell.dart
            - lib/features/feed/pages/feed_page.dart
            - lib/features/feed/pages/desktop_kanban_layout.dart
            - lib/features/feed/pages/radar_page.dart
            - lib/features/feed/pages/task_main_content.dart
            - lib/features/feed/widgets/feed_composer.dart
            - lib/features/feed/widgets/kanban_column_widget.dart
            - lib/features/settings/pages/settings_page.dart
          operations:
            - 'Replace all `Duration(milliseconds: 250)` with `AppTheme.animNormal` (~10 occurrences)'
            - 'Replace all `Duration(milliseconds: 300)` with `AppTheme.animSlide` (~15 occurrences)'
            - 'Replace all `Curves.easeOutCubic` with `AppTheme.curveOut` (~25 occurrences)'
            - 'Replace all `Curves.easeOut` with `AppTheme.curveOutQuart` (~8 occurrences)'
            - 'Replace all `Curves.easeIn` with `AppTheme.curveIn` (~3 occurrences)'
      estimated_loc_reduction: 80
      context_files:
        compact:
          - lib/app_theme.dart
        medium:
          - lib/app_theme.dart
          - lib/features/feed/pages/main_shell.dart
          - lib/features/feed/pages/radar_page.dart
        extended:
          - lib/app_theme.dart
          - lib/features/feed/pages/radar_page.dart
          - lib/features/feed/widgets/feed_composer.dart
          - lib/features/settings/pages/settings_page.dart

    - uuid: 'e6f7a8b9-0c1d-4e2f-3a4b-5c6d7e8f9a0b'
      status: 'completed'
      name: 'Part 11: Bid Controls Unification — Radar + BidSheet'
      reason: |
        radar_page.dart `_buildBidSheetOverlay` (lines 531-821, ~290 LOC) and bid_sheet.dart (272 LOC) implement nearly identical bid UI:
        - Bid amount stepper (minus/plus buttons with 64x64 containers, white.w05 bg, radius 20)
        - "YOUR BID" label + $ TextField with borderless input
        - Quick bid buttons (Down Bid / Match / Up Bid)
        - Pitch TextField with glass input styling
        - Submit button with emerald background and shadow glow

        The radar version uses GestureDetector while bid_sheet uses Inkwell, but the visual structure is identical. Extracting shared bid control widgets eliminates ~250 LOC of duplication.
      steps:
        - uuid: 'f7a8b9c0-1d2e-4f3a-4b5c-6d7e8f9a0b1c'
          status: 'completed'
          name: 'Create Shared Bid Control Widgets'
          reason: 'Extract the common bid UI into reusable shared widgets'
          files:
            - lib/shared/widgets/bid_controls.dart
          operations:
            - 'Create `BidAmountStepper({required int amount, required ValueChanged<int> onChanged})` widget: renders minus button (64x64, white.w05, minus icon) + Column(YOUR BID label + $ + TextField) + plus button — the 3-column stepper from both files'
            - 'Create `QuickBidRow({required int defaultBid, required int currentBid, required ValueChanged<int> onBidChanged})` widget: renders Row of 3 quick bid buttons (Down Bid -15, Match, Up Bid +15) with proper coloring (red tint for down, green for up, neutral for match)'
            - 'Create `BidPitchField({required ValueChanged<String> onChanged, String? hintText})` widget: renders the glass-styled multi-line TextField with glassInputArea decoration'
            - 'Create `BidSubmitButton({required VoidCallback onPressed, String label = "PLACE BID"})` widget: renders full-width emerald button with glow shadow and paperPlaneTilt icon'
        - uuid: 'a8b9c0d1-2e3f-4a4b-5c6d-7e8f9a0b1c2d'
          status: 'completed'
          name: 'Refactor Radar and BidSheet to Use Shared Bid Controls'
          reason: 'Replace ~500 lines of duplicated bid UI with shared widget calls'
          files:
            - lib/features/feed/pages/radar_page.dart
            - lib/features/feed/pages/post_detail/bid_sheet.dart
          operations:
            - 'In radar_page.dart `_buildBidSheetOverlay`: replace the bid amount stepper block (lines 620-725, ~105 lines) with `BidAmountStepper(amount: _bidAmount, onChanged: (v) => setState(() => _bidAmount = v))` — saves ~90 lines'
            - 'In radar_page.dart: replace quick bid buttons block (lines 726-736) with `QuickBidRow(defaultBid: defaultBid, currentBid: _bidAmount, onBidChanged: (v) => setState(() => _bidAmount = v))` — saves ~10 lines'
            - 'In radar_page.dart: replace pitch TextField (lines 738-769) with `BidPitchField(onChanged: (v) => _replyText = v)` — saves ~25 lines'
            - 'In radar_page.dart: replace submit button (lines 771-809) with `BidSubmitButton(onPressed: _handleBidSubmit)` — saves ~30 lines'
            - 'In bid_sheet.dart: replace the bid amount section with `BidAmountStepper(...)` — saves ~60 lines'
            - 'In bid_sheet.dart: replace quick bid chips with `QuickBidRow(...)` — saves ~30 lines'
            - 'In bid_sheet.dart: replace pitch TextField with `BidPitchField(...)` — saves ~15 lines'
            - 'In bid_sheet.dart: replace submit button with `BidSubmitButton(...)` — saves ~10 lines'
      estimated_loc_reduction: 270
      context_files:
        compact:
          - lib/shared/widgets/bid_controls.dart
        medium:
          - lib/shared/widgets/bid_controls.dart
          - lib/features/feed/pages/radar_page.dart
          - lib/features/feed/pages/post_detail/bid_sheet.dart
        extended:
          - lib/shared/widgets/bid_controls.dart
          - lib/features/feed/pages/radar_page.dart
          - lib/features/feed/pages/post_detail/bid_sheet.dart
          - lib/features/feed/pages/post_detail/completion_sheet.dart

    - uuid: 'f7a8b9c0-1d2e-4f3a-4b5c-6d7e8f9a0b1c'
      status: 'completed'
      name: 'Part 12: FeedComposer Attachment Grid Deduplication'
      reason: |
        feed_composer.dart (688 LOC) contains two nearly identical attachment preview grids:
        1. In `_FeedComposerState.build` (lines 207-303): 80x80 Container with image preview, remove button (Positioned top-right, 24x24, primary circle, X icon), and "Add More" trigger
        2. In `_FullscreenComposerSheetState._buildContent` (lines 532-630): identical structure, same styling, same remove button, same "Add More"

        The toolbar row of `_attachmentIconButton` calls is also duplicated (lines 325-350 and 647-680).
      steps:
        - uuid: 'a8b9c0d1-2e3f-4a4b-5c6d-7e8f9a0b1c2d'
          status: 'completed'
          name: 'Extract AttachmentThumbnail and Shared Toolbar'
          reason: 'Remove ~100 lines of duplicated attachment UI from feed_composer.dart'
          files:
            - lib/features/feed/widgets/feed_composer.dart
          operations:
            - 'Create private `Widget _attachmentGrid({required List<_Attachment> attachments, required void Function(int) onRemove, required VoidCallback onAdd})` method that renders the Wrap with attachment thumbnails and "Add More" button'
            - 'Create private `Widget _attachmentToolbar({required void Function(_AttachmentType) onAdd})` method that renders the Row of `_attachmentIconButton` calls'
            - 'In `_FeedComposerState.build`: replace lines 207-303 (attachment grid) with `_attachmentGrid(attachments: _attachments, onRemove: _removeAttachment, onAdd: () => _addMockAttachment(_AttachmentType.image))`'
            - 'In `_FullscreenComposerSheetState._buildContent`: replace lines 532-630 with `_attachmentGrid(attachments: widget.attachments, onRemove: (i) => widget.onRemoveAttachment(i), onAdd: () => widget.onAddAttachment(_AttachmentType.image))`'
            - 'In both: replace toolbar rows with `_attachmentToolbar(onAdd: ...)`'
      estimated_loc_reduction: 120
      context_files:
        compact:
          - lib/features/feed/widgets/feed_composer.dart
        medium:
          - lib/features/feed/widgets/feed_composer.dart
        extended:
          - lib/features/feed/widgets/feed_composer.dart

    - uuid: 'a8b9c0d1-2e3f-4a4b-5c6d-7e8f9a0b1c2d'
      status: 'pending'
      name: 'Part 13: Radar Page _GigCard Animation Cleanup'
      reason: |
        radar_page.dart is the largest file at 2,081 LOC. The `_GigCardState` class has ~80 lines of animation setup that is redundant:
        - `_setupExitAnimations` creates 4 dummy Tweens with `begin: 0, end: 0` that are immediately overwritten in `_runExitAnimation`
        - `_runExitAnimation` re-creates all exit tweens from scratch, making the initial setup wasteful
        - The `_exitX`, `_exitY`, `_exitRotate` fields are initialized twice — once in initState (with zeros) and again in _runExitAnimation

        Additionally, the bid sheet overlay in radar_page.dart (lines 531-821) reimplements the standard bottom sheet chrome (surface decoration, title row, close button, padding) that BaseSheet already provides, but with custom animation. After Part 11 extracts bid controls, the remaining sheet scaffolding can use BaseSheet for the chrome while keeping custom animation.
      steps:
        - uuid: 'b9c0d1e2-3f4a-4b5c-6d7e-8f9a0b1c2d3e'
          status: 'pending'
          name: 'Simplify _GigCard Animation Setup'
          reason: 'Remove redundant initialization of exit animations'
          files:
            - lib/features/feed/pages/radar_page.dart
          operations:
            - 'Remove `_setupExitAnimations()` method entirely'
            - 'Initialize `_exitController` directly in initState (just the AnimationController, no dummy tweens)'
            - 'Initialize `_exitOpacity`, `_exitX`, `_exitY`, `_exitRotate` as nullable `Animation<double>?` fields'
            - 'In `_runExitAnimation`: create all tweens inline (this is already what happens — the initial setup is just dead code)'
            - 'Simplify the `_runExitAnimation` method by extracting common patterns: the `_exitY = Tween(begin: 0.0, end: 50).animate(_exitController)` is identical for both left and right — consolidate using a direction map'
        - uuid: 'c0d1e2f3-4a5b-5c6d-8f9a-0b1c2d3e4f5a'
          status: 'pending'
          name: 'Refactor Radar Bid Sheet Overlay to Use BaseSheet Chrome'
          reason: 'Reuse BaseSheet for the bid sheet header/decoration after Part 11 extracts bid controls'
          files:
            - lib/features/feed/pages/radar_page.dart
          operations:
            - 'After Part 11 extracts the bid controls, the radar bid overlay has: animation wrapper > Container(surfaceSheetDecor) > title row + close button + bid controls'
            - 'Extract the inner content (after bid controls are extracted) into a `_RadarBidContent` widget'
            - 'Replace the inline Container(surfaceSheetDecor) + title row + close button with BaseSheet chrome, wrapping `_RadarBidContent`'
            - 'This eliminates ~30 lines of duplicated sheet chrome (title row, close button, padding, decoration)'
      estimated_loc_reduction: 160
      context_files:
        compact:
          - lib/features/feed/pages/radar_page.dart
        medium:
          - lib/features/feed/pages/radar_page.dart
        extended:
          - lib/features/feed/pages/radar_page.dart

    - uuid: 'b9c0d1e2-3f4a-4b5c-6d7e-8f9a0b1c2d3e'
      status: 'pending'
      name: 'Part 14: Sample Data Cleanup & Factory Constructors'
      reason: |
        sample_data.dart (484 LOC), mock_gigs.dart (75 LOC), and reply_generator.dart (77 LOC) are verbose. Each TaskData/SocialPostData constructor call spans 12-20 lines with explicit `replies: 0, reposts: 0, shares: 0, votes: 0` — all of which are already `@Default(0)` in the Freezed model. There are 30+ sample data items, each with 4 redundant default-value lines = ~120 lines of unnecessary verbosity.

        Additionally, repeated field patterns like `author: const Author(name: "...", handle: "...", avatar: "...")` can be simplified with factory constructors or helper functions.
      steps:
        - uuid: 'c0d1e2f3-4a5b-5c6d-8f9a-0b1c2d3e4f5a'
          status: 'pending'
          name: 'Add Sample Data Factory Helpers'
          reason: 'Create concise constructors for common sample data patterns'
          files:
            - lib/features/feed/data/sample_data.dart
            - lib/features/feed/data/reply_generator.dart
            - lib/shared/constants/mock_gigs.dart
          operations:
            - 'Remove all explicit `replies: 0, reposts: 0, shares: 0, votes: 0` from sample data constructors (these are @Default(0) in the Freezed model) — saves ~120 lines'
            - 'Remove all explicit `isFirstPost: false, isFirstTask: false` where the value matches the default'
            - 'Remove explicit `assignedWorker: null, acceptedBidAmount: null, quote: null, voiceNote: null, video: null, mapUrl: null, meta: null` where null is already the default'
            - 'In reply_generator.dart: simplify verbose author construction by using a helper function `Author sampleAuthor({required String name, String? handle})`'
            - 'In mock_gigs.dart: remove redundant fields from Gig constructors where defaults apply'
            - 'Consolidate the repetitive author block into a reusable map or list of tuples'
      estimated_loc_reduction: 200
      context_files:
        compact:
          - lib/features/feed/data/sample_data.dart
        medium:
          - lib/features/feed/data/sample_data.dart
          - lib/features/feed/data/reply_generator.dart
        extended:
          - lib/features/feed/data/sample_data.dart
          - lib/features/feed/data/reply_generator.dart
          - lib/shared/constants/mock_gigs.dart

    - uuid: 'c0d1e2f3-4a5b-5c6d-8f9a-0b1c2d3e4f5a'
      status: 'completed'
      name: 'Part 15: TaskMainContent Sub-Widget Extraction & Radar Widget Split'
      reason: |
        task_main_content.dart (890 LOC) is the second-largest file after radar_page.dart. It contains two large inline sub-builders:
        - `_buildTrustCard` (lines 320-489, ~170 LOC): A complex glass card with rating + payment info
        - `_buildStatusTracker` (lines 491-724, ~233 LOC): A status progress bar with step indicators

        Both are self-contained widgets that could be extracted to separate files, making task_main_content.dart more maintainable and reducing its LOC.

        Additionally, radar_page.dart at 2,081 LOC should be split. The `_GigCard` widget (lines 871-2081, ~1200 LOC including MatchSuccessSheet) is a private class that could be extracted to its own file.
      steps:
        - uuid: 'd1e2f3a4-5b6c-4d7e-8f9a-0b1c2d3e4f5a6'
          status: 'pending'
          name: 'Extract TrustCard and StatusTracker to Separate Files'
          reason: 'Split task_main_content.dart from 890 LOC into 3 focused files'
          files:
            - lib/features/feed/widgets/trust_card.dart
            - lib/features/feed/widgets/status_tracker.dart
            - lib/features/feed/pages/task_main_content.dart
          operations:
            - 'Create `TrustCard({required double rating, required int reviewCount, required bool paymentVerified})` as a public widget in its own file — extracted from `_buildTrustCard`'
            - 'Create `StatusTracker({required TaskStatus currentStatus, required Author? assignedWorker, String? acceptedBidAmount, String? price})` as a public widget in its own file — extracted from `_buildStatusTracker`'
            - 'In task_main_content.dart: replace `_buildTrustCard(context)` call with `TrustCard(rating: 4.9, reviewCount: 124, paymentVerified: true)` — saves 169 lines'
            - 'In task_main_content.dart: replace `_buildStatusTracker(context)` call with `StatusTracker(currentStatus: data.status, assignedWorker: data.assignedWorker, acceptedBidAmount: data.acceptedBidAmount, price: data.price)` — saves 233 lines'
            - 'Remove the private `_buildTrustCard` and `_buildStatusTracker` methods from task_main_content.dart'
        - uuid: 'e2f3a4b5-6c7d-4e8f-9a0b-1c2d3e4f5a6b'
          status: 'pending'
          name: 'Extract _GigCard and MatchSuccessSheet from radar_page.dart'
          reason: 'Split radar_page.dart from 2081 LOC into 3 focused files'
          files:
            - lib/features/feed/widgets/gig_card.dart
            - lib/features/feed/widgets/match_success_sheet.dart
            - lib/features/feed/pages/radar_page.dart
          operations:
            - 'Create `GigCard({required Gig gig, required void Function(String) onSwipe, required bool isTop, required int index, String? swipeDirection})` as a public widget — extracted from `_GigCard`'
            - 'Create `MatchSuccessSheet({required Gig gig, required bool isQueued, required VoidCallback onContinue, required VoidCallback onClose})` as a public widget — extracted from the private `MatchSuccessSheet` class'
            - 'In radar_page.dart: replace `_GigCard(...)` with `GigCard(...)` — the class is now imported from gig_card.dart'
            - 'In radar_page.dart: replace `MatchSuccessSheet(...)` with the imported version'
            - 'Remove the `_GigCard` and `MatchSuccessSheet` private class definitions from radar_page.dart'
            - 'This reduces radar_page.dart from ~2081 to ~870 LOC and creates two focused widget files'
            - 'Add appropriate imports for the extracted files'
      estimated_loc_reduction: 50
      context_files:
        compact:
          - lib/features/feed/widgets/trust_card.dart
          - lib/features/feed/widgets/status_tracker.dart
          - lib/features/feed/widgets/gig_card.dart
          - lib/features/feed/widgets/match_success_sheet.dart
        medium:
          - lib/features/feed/widgets/trust_card.dart
          - lib/features/feed/widgets/status_tracker.dart
          - lib/features/feed/pages/task_main_content.dart
          - lib/features/feed/pages/radar_page.dart
        extended:
          - lib/features/feed/widgets/trust_card.dart
          - lib/features/feed/widgets/status_tracker.dart
          - lib/features/feed/widgets/gig_card.dart
          - lib/features/feed/widgets/match_success_sheet.dart
          - lib/features/feed/pages/task_main_content.dart
          - lib/features/feed/pages/radar_page.dart

    - uuid: 'd1e2f3a4-5b6c-4d7e-8f9a-0b1c2d3e4f5a6'
      status: 'completed'
      name: 'Part 16: ElevatedButton.styleFrom Consolidation & EmptyState Widget'
      reason: |
        ElevatedButton.styleFrom is called with identical parameters in multiple locations:
        - `backgroundColor: AppColors.primary, foregroundColor: AppColors.primaryForeground, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), elevation: 0`
        This 5-line style block appears in feed_composer.dart (twice), post_detail_page.dart, and settings-adjacent code.

        Additionally, empty state patterns (icon in circle + title + subtitle + action button) appear in:
        - radar_page.dart `_buildEmptyView` (lines 470-529)
        - empty_replies_state.dart (154 LOC, entire file)
        Both share the same structure: centered Column with icon in rounded container, title, subtitle, optional action button.
      steps:
        - uuid: 'e2f3a4b5-6c7d-4e8f-9a0b-1c2d3e4f5a6b'
          status: 'pending'
          name: 'Create AppButtons and EmptyState Helpers'
          reason: 'Standardize button styling and empty state rendering'
          files:
            - lib/shared/utils/app_buttons.dart
            - lib/shared/widgets/empty_state.dart
          operations:
            - 'Create `ButtonStyle primaryButtonStyle` getter returning `ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: AppColors.primaryForeground, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), elevation: 0)`'
            - 'Create `EmptyState({required IconData icon, required String title, String? subtitle, String? actionLabel, VoidCallback? onAction})` widget that renders: Center > Column([icon in circle container, SizedBox(24), title with largeTitleWhite style, SizedBox(8), subtitle with bodyWhite style, SizedBox(32), optional action button])'
        - uuid: 'f3a4b5c6-7d8e-4f9a-0b1c-2d3e4f5a6b7c'
          status: 'pending'
          name: 'Apply Button and EmptyState Helpers'
          reason: 'Replace repeated button styles and empty state patterns'
          files:
            - lib/features/feed/widgets/feed_composer.dart
            - lib/features/feed/pages/radar_page.dart
            - lib/features/feed/pages/post_detail/empty_replies_state.dart
            - lib/features/feed/pages/post_detail_page.dart
          operations:
            - 'In feed_composer.dart: replace two ElevatedButton.styleFrom blocks with `style: primaryButtonStyle` — saves 8 lines'
            - 'In radar_page.dart `_buildEmptyView`: replace 60-line Center > Column with `EmptyState(icon: PhosphorIconsRegular.magnifyingGlass, title: "Queue Empty", subtitle: "You\'ve swiped through all available gigs.", actionLabel: "Return Home", onAction: () => context.go("/"))` — saves ~45 lines'
            - 'In empty_replies_state.dart: replace the entire file content with a single `EmptyState(...)` call — saves ~120 lines'
            - 'In post_detail_page.dart: replace any ElevatedButton.styleFrom with `primaryButtonStyle`'
      estimated_loc_reduction: 200
      context_files:
        compact:
          - lib/shared/utils/app_buttons.dart
          - lib/shared/widgets/empty_state.dart
        medium:
          - lib/shared/widgets/empty_state.dart
          - lib/features/feed/pages/post_detail/empty_replies_state.dart
          - lib/features/feed/pages/radar_page.dart
        extended:
          - lib/shared/widgets/empty_state.dart
          - lib/features/feed/pages/post_detail/empty_replies_state.dart
          - lib/features/feed/pages/radar_page.dart
          - lib/features/feed/widgets/feed_composer.dart

    - uuid: 'e2f3a4b5-6c7d-4e8f-9a0b-1c2d3e4f5a6b'
      status: 'pending'
      name: 'Part 17: task_main_content Status Text & Duplicate Pattern Cleanup'
      reason: |
        task_main_content.dart `_buildStatusTag` (lines 224-232) has an inline switch that maps TaskStatus to label strings, which is identical to the already-centralized `getStatusText()` in `shared/utils/task_icons.dart`.

        Additionally, `_buildInfoPill` uses the glass pill pattern that Part 2 extracts into GlassPill.

        The `_buildDescription` method (lines 726-783) contains a "Show Full Description" toggle with a glass pill container — this pattern is specific enough to extract as a shared `ExpandableDescription` widget since similar expand/collapse text patterns could appear elsewhere.

        Furthermore, the glass card decoration used in `_buildTrustCard` (BackdropFilter + Container + glassTint + glassBorder + glow gradient + bottom gradient) is a high-quality glass panel pattern that could be reused.
      steps:
        - uuid: 'f3a4b5c6-7d8e-4f9a-0b1c-2d3e4f5a6b7c'
          status: 'pending'
          name: 'Apply Remaining DRY Fixes in task_main_content'
          reason: 'Final cleanup pass on the second-largest file'
          files:
            - lib/features/feed/pages/task_main_content.dart
            - lib/shared/utils/task_icons.dart
          operations:
            - 'In `_buildStatusTag`: delete the inline switch, replace with `TagPill(label: getStatusText(status))` (import from task_icons.dart) — saves 8 lines'
            - 'After Part 2 GlassPill extraction: apply GlassPill to `_buildInfoPill` — saves 5 lines'
            - 'Verify `_buildTrustCard` glass pattern is consistent with GlassCard variants — if not, add a `GlassCard.panel()` named constructor for this glass panel pattern'
        - uuid: 'a4b5c6d7-8e9f-4a0b-1c2d-3e4f5a6b7c8d'
          status: 'pending'
          name: 'Centralize Remaining Scattered Patterns'
          reason: 'Clean up final small duplications across the codebase'
          files:
            - lib/features/feed/widgets/task_card.dart
            - lib/features/feed/widgets/base_feed_card.dart
            - lib/features/feed/pages/post_detail_page.dart
            - lib/features/feed/pages/create_reply_page.dart
          operations:
            - 'In task_card.dart: if there is a local `_buildStatusText` or status mapping, replace with `getStatusText()` from task_icons.dart'
            - 'In base_feed_card.dart: centralize any repeated author row pattern (UserAvatar + name/handle column + timestamp) into a shared `AuthorRow` widget if it appears in both task_card and social_post_card'
            - 'In post_detail_page.dart `_incrementReplyCount`: simplify the three-branch type check by using a common interface method if possible, or consolidate into a helper function'
            - 'In create_reply_page.dart: replace any inline decoration patterns with decoration presets from decorations.dart'
      estimated_loc_reduction: 120
      context_files:
        compact:
          - lib/shared/utils/task_icons.dart
        medium:
          - lib/features/feed/pages/task_main_content.dart
          - lib/features/feed/widgets/task_card.dart
          - lib/features/feed/widgets/base_feed_card.dart
        extended:
          - lib/features/feed/pages/task_main_content.dart
          - lib/features/feed/widgets/task_card.dart
          - lib/features/feed/widgets/base_feed_card.dart
          - lib/features/feed/pages/post_detail_page.dart

    - uuid: 'f3a4b5c6-7d8e-4f9a-0b1c-2d3e4f5a6b7c'
      status: 'pending'
      name: 'Part 18: BoxDecoration Inline Pattern Adoption & Remaining Cleanup'
      reason: |
        After Phase 1 introduced decoration presets (surfaceDecor, glassDecor, subtleBorder, shadowBlack, shadowGlow, shadowSm, tintedDecor, surfaceCardDecor), many inline BoxDecoration constructions across the codebase still don't use them. Scanning all files reveals 40+ remaining inline BoxDecoration instances that could use existing presets or need new ones.

        This final sweep ensures every repeated decoration pattern uses a shared preset.
      steps:
        - uuid: 'a4b5c6d7-8e9f-4a0b-1c2d-3e4f5a6b7c8d'
          status: 'pending'
          name: 'Adopt Decoration Presets in Remaining Files'
          reason: 'Replace 40+ inline BoxDecoration with preset calls'
          files:
            - lib/features/feed/pages/radar_page.dart
            - lib/features/feed/pages/task_main_content.dart
            - lib/features/feed/pages/create_reply_page.dart
            - lib/features/feed/widgets/task_card.dart
            - lib/features/feed/widgets/social_post_card.dart
            - lib/features/feed/widgets/floating_sidebar.dart
            - lib/features/feed/widgets/kanban_column_widget.dart
            - lib/features/feed/widgets/editorial_card.dart
            - lib/features/settings/pages/settings_page.dart
            - lib/shared/widgets/voice_note_player.dart
            - lib/shared/widgets/media_carousel.dart
          operations:
            - 'Scan all files for `BoxDecoration(` and categorize each: surface card, glass, subtle border, tinted, surface sheet, or unique'
            - 'Replace all `BoxDecoration(color: AppColors.surfaceContainerHigh, borderRadius: ..., border: Border.all(color: Colors.white.w10))` with `surfaceCardDecor(radius: ...)` — estimated 12 remaining instances, saves ~60 lines'
            - 'Replace all `BoxDecoration(color: Colors.white.w05, borderRadius: ..., border: ...)` icon-box patterns with `tintedDecor(color: Colors.white, tintOpacity: 0.05, radius: ...)` — estimated 8 instances, saves ~30 lines'
            - 'Replace all remaining `BoxShadow(color: Colors.black.withOpacity(...), blurRadius: ...)` with `shadowBlack()` or `shadowSm()` — estimated 10 instances, saves ~25 lines'
            - 'Replace all remaining inline glass patterns (glassTint + glassBorder + radius) with appropriate GlassCard or GlassPill — estimated 5 instances, saves ~20 lines'
            - 'For any unique patterns that repeat 3+ times, add new presets to decorations.dart'
      estimated_loc_reduction: 180
      context_files:
        compact:
          - lib/shared/utils/decorations.dart
        medium:
          - lib/shared/utils/decorations.dart
          - lib/features/feed/pages/radar_page.dart
          - lib/features/feed/widgets/floating_sidebar.dart
        extended:
          - lib/shared/utils/decorations.dart
          - lib/features/feed/pages/radar_page.dart
          - lib/features/feed/widgets/task_card.dart
          - lib/features/feed/widgets/social_post_card.dart
          - lib/features/settings/pages/settings_page.dart

  conclusion: |
    This plan targets a net reduction of approximately 4,510 LOC through 18 aggressive but safe refactoring parts:

    ┌────────────────────────────────────────────────────────────┬────────┐
    │ Part                                                       │  LOC   │
    ├────────────────────────────────────────────────────────────┼────────┤
    │ 1. Named TextStyle Constants                               │  -450  │
    │ 2. Shared Micro-Widgets (Background/Pill/Label/Divider)   │  -180  │
    │ 3. InputDecoration Presets                                  │  -120  │
    │ 4. Settings Page Section Abstraction                       │  -100  │
    │ 5. Delete BottomSheetContainer                             │   -80  │
    │ 6. FeedPage TabController Mixin                            │  -120  │
    │ 7. Utility Extractions (formatCount/parsePrice/CloseBtn)  │   -80  │
    │ 8. VoiceNotePlayer Reuse                                   │   -70  │
    │ 9. ToggleSetNotifier Base Class                            │   -30  │
    │ 10. Animation Constants                                    │   -80  │
    │ 11. Bid Controls Unification                               │  -270  │
    │ 12. FeedComposer Attachment Dedup                          │  -120  │
    │ 13. Radar _GigCard Animation Cleanup                       │  -160  │
    │ 14. Sample Data Cleanup                                    │  -200  │
    │ 15. Sub-Widget Extraction & File Splitting                  │   -50  │
    │ 16. ElevatedButton + EmptyState Consolidation              │  -200  │
    │ 17. Status Text & Remaining Pattern Cleanup                │  -120  │
    │ 18. BoxDecoration Preset Adoption Sweep                    │  -180  │
    ├────────────────────────────────────────────────────────────┼────────┤
    │ TOTAL (Phase 2)                                            │ -4,510 │
    │ Phase 1 (already done)                                     │  -500  │
    │ GRAND TOTAL                                                │ -5,010 │
    └────────────────────────────────────────────────────────────┴────────┘

    Combined with Phase 1's ~500 LOC reduction, this achieves the -5,000 target from the pre-Phase-1 baseline.

    **Priority execution order** (by LOC impact and dependencies):
    1. Part 1 (TextStyle Constants) — highest single impact, zero dependencies
    2. Part 10 (Animation Constants) — pervasive, zero dependencies
    3. Part 18 (BoxDecoration Sweep) — pervasive, zero dependencies
    4. Part 7 (Utility Extractions) — small, enables later parts
    5. Part 2 (Shared Micro-Widgets) — enables Parts 4, 16, 17
    6. Part 5 (Delete BottomSheetContainer) — quick win
    7. Part 9 (ToggleSetNotifier) — quick win
    8. Part 8 (VoiceNotePlayer Reuse) — quick win
    9. Part 4 (Settings Section) — standalone
    10. Part 3 (InputDecoration) — standalone
    11. Part 6 (TabController Mixin) — standalone
    12. Part 16 (ElevatedButton + EmptyState) — standalone
    13. Part 14 (Sample Data Cleanup) — standalone
    14. Part 11 (Bid Controls) — depends on Part 3, 7
    15. Part 12 (Composer Attachment) — standalone
    16. Part 13 (Radar Cleanup) — depends on Part 5, 10, 11
    17. Part 15 (Widget Extraction) — standalone
    18. Part 17 (Final Cleanup) — depends on Parts 2, 13

    **Key principles maintained:**
    - Every new abstraction is used 3+ times immediately
    - No speculative generality — every extraction has a concrete consumer
    - Visual output remains pixel-identical
    - Net LOC reduction per extraction (new shared code + import lines < removed inline code)
  context_files:
    compact:
      - lib/app_theme.dart
      - lib/shared/utils/decorations.dart
      - lib/shared/utils/color_extensions.dart
      - lib/shared/widgets/base_sheet.dart
      - lib/shared/widgets/glass_card.dart
      - lib/shared/utils/task_icons.dart
      - lib/shared/widgets/ring_animation.dart
    medium:
      - lib/app_theme.dart
      - lib/shared/utils/decorations.dart
      - lib/shared/widgets/base_sheet.dart
      - lib/features/feed/pages/radar_page.dart
      - lib/features/feed/pages/task_main_content.dart
      - lib/features/feed/widgets/feed_composer.dart
      - lib/features/feed/pages/post_detail/bid_sheet.dart
    extended:
      - lib/app_theme.dart
      - lib/shared/utils/decorations.dart
      - lib/shared/widgets/base_sheet.dart
      - lib/features/feed/pages/radar_page.dart
      - lib/features/feed/pages/task_main_content.dart
      - lib/features/feed/widgets/feed_composer.dart
      - lib/features/feed/pages/post_detail/bid_sheet.dart
      - lib/features/feed/pages/feed_page.dart
      - lib/features/feed/widgets/task_card.dart
      - lib/features/feed/widgets/social_post_card.dart
      - lib/features/settings/pages/settings_page.dart
```
