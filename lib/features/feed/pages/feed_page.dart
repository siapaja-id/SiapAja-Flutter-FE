import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../app_theme.dart';
import '../../../shared/widgets/user_avatar.dart';
import '../widgets/feed_composer.dart';
import '../widgets/feed_item_card.dart';
import '../providers.dart';

/// Feed page with header, composer, and feed list
class FeedPage extends ConsumerWidget {
  final String tab; // 'for-you' or 'around-you'

  const FeedPage({super.key, this.tab = 'for-you'});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedState = ref.watch(feedNotifierProvider);

    return Column(
      children: [
        // Sticky feed header (matches React App.tsx header)
        const FeedHeader(),
        // Scrollable area: composer + feed list
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            padding: const EdgeInsets.only(bottom: 16),
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
      ],
    );
  }
}

/// Feed header widget (sticky header) - matches React App.tsx header
class FeedHeader extends ConsumerWidget {
  const FeedHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appNotifierProvider);
    final activeTab = appState.activeTab;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 64,
      decoration: const BoxDecoration(
        color: Color(
          0xF21F1F1F,
        ), // surface-container-high/95 (matches React glass)
        border: Border(
          bottom: BorderSide(color: Color(0x0DFFFFFF)),
        ), // border-white/5
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // User avatar (left)
          GestureDetector(
            onTap: () {
              // Navigate to profile
            },
            child: const UserAvatar(
              src: 'https://picsum.photos/seed/user/100/100',
              size: AvatarSize.md,
              isOnline: true,
            ),
          ),
          // Tabs (center) — animated underline matches React layoutId="tab"
          _TabRow(
            activeTab: activeTab,
            onTabChanged: (i) =>
                ref.read(appNotifierProvider.notifier).setActiveTab(i),
          ),
          // Karma badge (right)
          GestureDetector(
            onTap: () {
              // Navigate to profile
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0x1AFFFFFF)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${appState.currentUser?.karma ?? 98}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: const Color(0xFF34D399),
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Icon(
                    PhosphorIconsRegular.caretUp,
                    size: 14,
                    color: Color(0xFF34D399), // emerald-400
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Animated tab row — single sliding underline matches React `layoutId="tab"`
class _TabRow extends StatelessWidget {
  final int activeTab;
  final ValueChanged<int> onTabChanged;
  const _TabRow({required this.activeTab, required this.onTabChanged});

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
          // Single sliding underline — AnimatedContainer interpolates
          // alignment between tab centres (like Framer Motion layoutId).
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
                        offset: const Offset(0, 0),
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
