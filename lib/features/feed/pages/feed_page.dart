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

      return RefreshIndicator(
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
          padding: const EdgeInsets.only(bottom: 24),
          itemCount: feedState.feedItems.length + 2,
          itemBuilder: (context, index) {
            if (index == 0) {
              return _KanbanFeedHeader(
                columnId: widget.columnId!,
                activeTab: activeTab,
              );
            }
            if (index == 1) {
              return const FeedComposer();
            }
            final item = feedState.feedItems[index - 2];
            return FeedItemCard(item: item);
          },
        ),
      );
    }

    // Mobile mode: existing floating header behavior
    return Stack(
      children: [
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

/// Inline feed header for kanban columns — matches React HomePage header
class _KanbanFeedHeader extends ConsumerStatefulWidget {
  final String columnId;
  final int activeTab;

  const _KanbanFeedHeader({required this.columnId, required this.activeTab});

  @override
  ConsumerState<_KanbanFeedHeader> createState() => _KanbanFeedHeaderState();
}

class _KanbanFeedHeaderState extends ConsumerState<_KanbanFeedHeader>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.activeTab,
    );
    _tabController.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging && mounted) {
      final index = _tabController.index;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ref
              .read(kanbanProvider.notifier)
              .setColumnActiveTab(widget.columnId, index);
        }
      });
    }
  }

  @override
  void didUpdateWidget(_KanbanFeedHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.activeTab != widget.activeTab &&
        _tabController.index != widget.activeTab &&
        !_tabController.indexIsChanging) {
      _tabController.index = widget.activeTab;
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
    final currentUser = ref.read(uiStateProvider).currentUser;
    final karma = currentUser?.karma ?? 98;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          height: 64,
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
                onTap: () => ref
                    .read(kanbanProvider.notifier)
                    .openColumn(
                      '/profile',
                      sourceId: widget.columnId,
                      routeState: {
                        'user': {
                          'name': currentUser?.name ?? 'You',
                          'handle': currentUser?.handle ?? 'currentuser',
                          'avatar':
                              currentUser?.avatar ??
                              'https://picsum.photos/seed/currentuser/100/100',
                          'karma': karma,
                          'isOnline': currentUser?.isOnline ?? true,
                        },
                      },
                    ),
                child: UserAvatar(
                  src:
                      currentUser?.avatar ??
                      'https://picsum.photos/seed/user/100/100',
                  size: AvatarSize.md,
                  isOnline: true,
                ),
              ),
              _TabBar(
                activeIndex: widget.activeTab,
                onIndexChanged: (i) => _tabController.animateTo(i),
              ),
              GestureDetector(
                onTap: () => ref
                    .read(kanbanProvider.notifier)
                    .openColumn(
                      '/profile',
                      sourceId: widget.columnId,
                      routeState: {
                        'user': {
                          'name': currentUser?.name ?? 'You',
                          'handle': currentUser?.handle ?? 'currentuser',
                          'avatar':
                              currentUser?.avatar ??
                              'https://picsum.photos/seed/currentuser/100/100',
                          'karma': karma,
                          'isOnline': currentUser?.isOnline ?? true,
                        },
                      },
                    ),
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
                            '$karma',
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
                _TabBar(
                  activeIndex: activeTab,
                  onIndexChanged: (i) => _tabController.animateTo(i),
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
      duration: const Duration(milliseconds: 250),
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
        curve: Curves.easeOutCubic,
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
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
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
