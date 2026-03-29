import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../app_theme.dart';
import '../../../shared/widgets/user_avatar.dart';
import '../widgets/feed_composer.dart';
import '../widgets/feed_item_card.dart';
import '../providers.dart';

/// Feed page with header, composer, and feed list
class FeedPage extends ConsumerStatefulWidget {
  final String tab;

  const FeedPage({super.key, this.tab = 'for-you'});

  @override
  ConsumerState<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends ConsumerState<FeedPage> {
  late ScrollController _scrollController;
  double _lastScrollOffset = 0;
  static const double _scrollThreshold = 8;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final offset = _scrollController.offset;
    final delta = offset - _lastScrollOffset;

    // Don't toggle if at the very top
    if (offset <= 0) {
      _lastScrollOffset = offset;
      return;
    }

    if (delta > _scrollThreshold) {
      // Scrolling down - hide bars
      ref
          .read(uiStateProvider.notifier)
          .setBarsVisible(header: false, bottomNav: false);
    } else if (delta < -_scrollThreshold) {
      // Scrolling up - show bars
      ref
          .read(uiStateProvider.notifier)
          .setBarsVisible(header: true, bottomNav: true);
    }

    _lastScrollOffset = offset;
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final feedState = ref.watch(feedNotifierProvider);
    final headerVisible = ref.watch(
      uiStateProvider.select((s) => s.headerVisible),
    );

    return Stack(
      children: [
        // Feed content fills the full area so it scrolls behind the header
        Positioned.fill(
          child: RefreshIndicator(
            color: AppColors.primary,
            backgroundColor: AppColors.surfaceContainerHigh,
            onRefresh: () async {
              ref.read(feedNotifierProvider.notifier).refreshFeed();
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: ListView.builder(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              padding: const EdgeInsets.only(top: 64, bottom: 24),
              itemCount: feedState.feedItems.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return const FeedComposer();
                }
                final item = feedState.feedItems[index - 1];
                return FeedItemCard(item: item);
              },
            ),
          ),
        ),
        // Glassmorphism header floats over the feed content
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          child: AnimatedSlide(
            offset: headerVisible ? Offset.zero : const Offset(0, -1),
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            child: const FeedHeader(),
          ),
        ),
      ],
    );
  }
}

/// Feed header widget (sticky header) with TabBar
class FeedHeader extends ConsumerStatefulWidget {
  const FeedHeader({super.key});

  @override
  ConsumerState<FeedHeader> createState() => _FeedHeaderState();
}

class _FeedHeaderState extends ConsumerState<FeedHeader>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    final activeTab = ref.read(uiStateProvider).activeTab;
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: activeTab,
    );
    _tabController.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) {
      ref.read(uiStateProvider.notifier).setActiveTab(_tabController.index);
    }
  }

  @override
  void didUpdateWidget(FeedHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    final activeTab = ref.read(uiStateProvider).activeTab;
    if (_tabController.index != activeTab) {
      _tabController.index = activeTab;
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeTab = ref.watch(uiStateProvider.select((s) => s.activeTab));
    final karma = ref.watch(
      uiStateProvider.select((s) => s.currentUser?.karma),
    );

    return SizedBox(
      height: 64,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.glassTint,
              border: const Border(
                bottom: BorderSide(color: AppColors.glassBorder),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.glassGlow, AppColors.glassTint],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: const UserAvatar(
                    src: 'https://picsum.photos/seed/user/100/100',
                    size: AvatarSize.md,
                    isOnline: true,
                  ),
                ),
                _TabRow(
                  controller: _tabController,
                  activeTab: activeTab,
                  onTabChanged: (i) => _tabController.animateTo(i),
                ),
                GestureDetector(
                  onTap: () {},
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.glassTint,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.glassBorder),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${karma ?? 98}',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(color: const Color(0xFF34D399)),
                            ),
                            const SizedBox(width: 2),
                            const Icon(
                              PhosphorIconsRegular.caretUp,
                              size: 14,
                              color: Color(0xFF34D399),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Animated tab row with sliding underline
class _TabRow extends StatelessWidget {
  final TabController controller;
  final int activeTab;
  final ValueChanged<int> onTabChanged;
  const _TabRow({
    required this.controller,
    required this.activeTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _TabItem(
                label: 'For You',
                isActive: activeTab == 0,
                onTap: () => onTabChanged(0),
              ),
              const SizedBox(width: 24),
              _TabItem(
                label: 'Around You',
                isActive: activeTab == 1,
                onTap: () => onTabChanged(1),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 2,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              alignment: activeTab == 0
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: FractionallySizedBox(
                widthFactor: 0.5,
                alignment: Alignment.center,
                child: Container(
                  height: 2,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(2),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.4),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  const _TabItem({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
          color: isActive ? AppColors.onSurface : AppColors.onSurfaceVariant,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Text(label),
        ),
      ),
    );
  }
}
