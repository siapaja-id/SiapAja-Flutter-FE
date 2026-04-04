import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app_theme.dart';
import '../../../shared/widgets/user_avatar.dart';
import '../../../shared/widgets/glass_header.dart';
import '../../../shared/widgets/karma_badge.dart';
import '../widgets/feed_composer.dart';
import '../widgets/feed_item_card.dart';
import '../providers.dart';

/// Mixin that manages a 2-tab [TabController] lifecycle for ConsumerStatefulWidgets.
///
/// Subclasses provide [initialTabIndex], [targetTabIndex], and [onTabIndexChanged].
/// The mixin handles creation, listening, sync on didUpdateWidget, and disposal.
mixin ManagedTabController<T extends ConsumerStatefulWidget>
    on SingleTickerProviderStateMixin<T>, ConsumerState<T> {
  late TabController tabController;

  /// Tab index used when the controller is first created in [initState].
  int get initialTabIndex;

  /// Tab index the controller should sync to in [didUpdateWidget].
  int get targetTabIndex;

  /// Called when the user finishes swiping to a new tab (indexIsChanging is false).
  void onTabIndexChanged(int index);

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: initialTabIndex,
    );
    tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (!tabController.indexIsChanging) {
      onTabIndexChanged(tabController.index);
    }
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (tabController.index != targetTabIndex &&
        !tabController.indexIsChanging) {
      tabController.index = targetTabIndex;
    }
  }

  @override
  void dispose() {
    tabController.removeListener(_handleTabChange);
    tabController.dispose();
    super.dispose();
  }
}

/// Shared feed header layout: GlassHeader > Row > [left, tabBar, right]
class _FeedHeaderContent extends StatelessWidget {
  final Widget left;
  final Widget right;
  final Widget tabBar;

  const _FeedHeaderContent({
    required this.left,
    required this.right,
    required this.tabBar,
  });

  @override
  Widget build(BuildContext context) {
    return GlassHeader(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          left,
          Flexible(child: tabBar),
          right,
        ],
      ),
    );
  }
}

/// Feed page with header, composer, and feed list
class FeedPage extends ConsumerStatefulWidget {
  final String tab;
  final String? columnId;

  const FeedPage({super.key, this.tab = 'for-you', this.columnId});

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
    // In kanban mode, don't toggle bars — each column scrolls independently
    if (widget.columnId != null) return;

    final offset = _scrollController.offset;
    final delta = offset - _lastScrollOffset;

    if (offset <= 0) {
      _lastScrollOffset = offset;
      return;
    }

    if (delta > _scrollThreshold) {
      ref
          .read(uiStateProvider.notifier)
          .setBarsVisible(header: false, bottomNav: false);
    } else if (delta < -_scrollThreshold) {
      ref
          .read(uiStateProvider.notifier)
          .setBarsVisible(header: true, bottomNav: true);
    }

    _lastScrollOffset = offset;
  }

  Future<void> _handleRefresh() async {
    ref.read(feedNotifierProvider.notifier).refreshFeed();
    await Future.delayed(const Duration(milliseconds: 500));
  }

  /// Shared RefreshIndicator + ListView.builder used by both kanban and mobile.
  Widget _buildFeedList({
    required int itemCount,
    required EdgeInsetsGeometry padding,
    required Widget Function(BuildContext context, int index) itemBuilder,
  }) {
    return RefreshIndicator(
      color: AppColors.primary,
      backgroundColor: AppColors.surfaceContainerHigh,
      onRefresh: _handleRefresh,
      child: ListView.builder(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        padding: padding,
        itemCount: itemCount,
        itemBuilder: itemBuilder,
      ),
    );
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
    final isKanban = widget.columnId != null;
    final headerVisible = ref.watch(
      uiStateProvider.select((s) => s.headerVisible),
    );

    // In kanban mode: header is inline in the ListView
    if (isKanban) {
      final activeTab = ref.watch(
        kanbanProvider.select((s) {
          for (final c in s.columns) {
            if (c.id == widget.columnId) return c.activeTab ?? 0;
          }
          return 0;
        }),
      );

      return _buildFeedList(
        itemCount: feedState.feedItems.length + 2,
        padding: const EdgeInsets.only(bottom: 24),
        itemBuilder: (context, index) {
          if (index == 0) {
            return _KanbanFeedHeader(
              columnId: widget.columnId!,
              activeTab: activeTab,
            );
          }
          if (index == 1) return const FeedComposer();
          return FeedItemCard(item: feedState.feedItems[index - 2]);
        },
      );
    }

    // Mobile mode: existing floating header behavior
    return Stack(
      children: [
        Positioned.fill(
          child: _buildFeedList(
            itemCount: feedState.feedItems.length + 1,
            padding: const EdgeInsets.only(top: 64, bottom: 24),
            itemBuilder: (context, index) {
              if (index == 0) return const FeedComposer();
              return FeedItemCard(item: feedState.feedItems[index - 1]);
            },
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          child: AnimatedSlide(
            offset: headerVisible ? Offset.zero : const Offset(0, -1),
            duration: AppTheme.animNormal,
            curve: AppTheme.curveOut,
            child: const FeedHeader(),
          ),
        ),
      ],
    );
  }
}

/// Inline feed header for kanban columns — matches React HomePage header
class _KanbanFeedHeader extends ConsumerStatefulWidget {
  final String columnId;
  final int activeTab;

  const _KanbanFeedHeader({required this.columnId, required this.activeTab});

  @override
  ConsumerState<_KanbanFeedHeader> createState() => _KanbanFeedHeaderState();
}

class _KanbanFeedHeaderState extends ConsumerState<_KanbanFeedHeader>
    with SingleTickerProviderStateMixin, ManagedTabController<_KanbanFeedHeader> {
  @override
  int get initialTabIndex => widget.activeTab;

  @override
  int get targetTabIndex => widget.activeTab;

  @override
  void onTabIndexChanged(int index) {
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref
            .read(kanbanProvider.notifier)
            .setColumnActiveTab(widget.columnId, index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.read(uiStateProvider).currentUser;
    final karma = currentUser?.karma ?? 98;

    final avatar = UserAvatar(
      src: currentUser?.avatar ?? 'https://picsum.photos/seed/user/100/100',
      size: AvatarSize.md,
      isOnline: true,
    );

    final profileRouteState = {
      'user': {
        'name': currentUser?.name ?? 'You',
        'handle': currentUser?.handle ?? 'currentuser',
        'avatar': currentUser?.avatar ?? 'https://picsum.photos/seed/currentuser/100/100',
        'karma': karma,
        'isOnline': currentUser?.isOnline ?? true,
      },
    };

    final openProfile = () => ref
        .read(kanbanProvider.notifier)
        .openColumn('/profile', sourceId: widget.columnId, routeState: profileRouteState);

    return _FeedHeaderContent(
      left: GestureDetector(onTap: openProfile, child: avatar),
      tabBar: _TabBar(
        activeIndex: widget.activeTab,
        onIndexChanged: (i) => tabController.animateTo(i),
      ),
      right: GestureDetector(onTap: openProfile, child: KarmaBadge(karma: karma)),
    );
  }
}

/// Feed header widget (sticky header) with TabBar — mobile only
class FeedHeader extends ConsumerStatefulWidget {
  const FeedHeader({super.key});

  @override
  ConsumerState<FeedHeader> createState() => _FeedHeaderState();
}

class _FeedHeaderState extends ConsumerState<FeedHeader>
    with SingleTickerProviderStateMixin, ManagedTabController<FeedHeader> {
  @override
  int get initialTabIndex => ref.read(uiStateProvider).activeTab;

  @override
  int get targetTabIndex => ref.read(uiStateProvider).activeTab;

  @override
  void onTabIndexChanged(int index) {
    ref.read(uiStateProvider.notifier).setActiveTab(index);
  }

  @override
  Widget build(BuildContext context) {
    final activeTab = ref.watch(uiStateProvider.select((s) => s.activeTab));
    final karma = ref.watch(
      uiStateProvider.select((s) => s.currentUser?.karma),
    );

    return _FeedHeaderContent(
      left: GestureDetector(
        onTap: () {},
        child: const UserAvatar(
          src: 'https://picsum.photos/seed/user/100/100',
          size: AvatarSize.md,
          isOnline: true,
        ),
      ),
      tabBar: _TabBar(
        activeIndex: activeTab,
        onIndexChanged: (i) => tabController.animateTo(i),
      ),
      right: KarmaBadge(karma: karma ?? 98),
    );
  }
}

/// Animated tab bar with sliding underline indicator
class _TabBar extends StatefulWidget {
  final int activeIndex;
  final ValueChanged<int> onIndexChanged;
  const _TabBar({required this.activeIndex, required this.onIndexChanged});

  @override
  State<_TabBar> createState() => _TabBarState();
}

class _TabBarState extends State<_TabBar> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<GlobalKey> _tabKeys = [GlobalKey(), GlobalKey()];
  final List<double> _tabWidths = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppTheme.animNormal,
      vsync: this,
    );
    if (widget.activeIndex == 1) {
      _controller.value = 1.0;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureTabWidths());
  }

  @override
  void didUpdateWidget(_TabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.activeIndex != oldWidget.activeIndex) {
      _controller.animateTo(
        widget.activeIndex.toDouble(),
        curve: AppTheme.curveOut,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _measureTabWidths() {
    if (!mounted) return;
    _tabWidths.clear();
    for (final key in _tabKeys) {
      final box = key.currentContext?.findRenderObject() as RenderBox?;
      if (box != null && box.hasSize) {
        _tabWidths.add(box.size.width);
      }
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    const tabs = ['For You', 'Around You'];
    return SizedBox(
      height: 32,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(tabs.length, (i) {
              final isActive = widget.activeIndex == i;
              return GestureDetector(
                key: _tabKeys[i],
                onTap: () => widget.onIndexChanged(i),
                behavior: HitTestBehavior.opaque,
                child: AnimatedDefaultTextStyle(
                  duration: AppTheme.animFast,
                  curve: AppTheme.curveOutQuart,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: isActive
                        ? AppColors.onSurface
                        : AppColors.onSurfaceVariant,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 6,
                    ),
                    child: Text(tabs[i]),
                  ),
                ),
              );
            }),
          ),
          if (_tabWidths.length >= 2)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  final totalOffset = List.generate(
                    _tabWidths.length,
                    (i) => _tabWidths.sublist(0, i + 1).reduce((a, b) => a + b),
                  );
                  final index = _controller.value.round().clamp(
                    0,
                    _tabWidths.length - 1,
                  );
                  final width = _tabWidths[index];
                  final cumBefore = index > 0 ? totalOffset[index - 1] : 0.0;
                  final nextWidth = index < _tabWidths.length - 1
                      ? _tabWidths[index + 1]
                      : _tabWidths[index];
                  final cumNext = totalOffset[index];
                  final t = _controller.value - index;
                  final offset = cumBefore + t * (cumNext - cumBefore);
                  final w = width + t * (nextWidth - width);
                  return Transform.translate(
                    offset: Offset(offset, 0),
                    child: Container(
                      height: 2,
                      width: w,
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
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
