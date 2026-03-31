import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../app_theme.dart';
import '../../../shared/widgets/user_avatar.dart';
import '../providers.dart';

class _NavItem {
  final IconData icon;
  final String label;
  final String route;
  final bool isPrimary;
  final VoidCallback? action;
  const _NavItem({
    required this.icon,
    required this.label,
    required this.route,
    this.isPrimary = false,
    this.action,
  });
}

class FloatingSidebar extends ConsumerStatefulWidget {
  const FloatingSidebar({super.key});

  @override
  ConsumerState<FloatingSidebar> createState() => _FloatingSidebarState();
}

class _FloatingSidebarState extends ConsumerState<FloatingSidebar> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.read(uiStateProvider).currentUser;

    final navItems = [
      const _NavItem(
        icon: PhosphorIconsRegular.house,
        label: 'Home',
        route: '/',
      ),
      const _NavItem(
        icon: PhosphorIconsRegular.magnifyingGlass,
        label: 'Explore',
        route: '/explore',
      ),
      _NavItem(
        icon: PhosphorIconsRegular.plus,
        label: 'Create',
        route: 'create',
        isPrimary: true,
        action: () {
          // TODO: open create modal
        },
      ),
      const _NavItem(
        icon: PhosphorIconsRegular.chatCircle,
        label: 'Messages',
        route: '/messages',
      ),
      const _NavItem(
        icon: PhosphorIconsRegular.clipboardText,
        label: 'Orders',
        route: '/orders',
      ),
      const _NavItem(
        icon: PhosphorIconsRegular.user,
        label: 'Profile',
        route: '/profile',
      ),
    ];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      width: _expanded ? 240 : 80,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.glassTint,
              border: const Border(
                right: BorderSide(color: AppColors.glassBorder),
              ),
              boxShadow: const [
                BoxShadow(color: Colors.black54, blurRadius: 40),
              ],
            ),
            child: Column(
              children: [
                const SizedBox(height: 24),
                // Toggle button
                GestureDetector(
                  onTap: () => setState(() => _expanded = !_expanded),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: _expanded ? 16 : 0,
                    ),
                    child: Align(
                      alignment: _expanded
                          ? Alignment.centerRight
                          : Alignment.center,
                      child: Icon(
                        _expanded
                            ? PhosphorIconsRegular.sidebarSimple
                            : PhosphorIconsRegular.sidebar,
                        size: 24,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                // Nav items
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: navItems.map((item) {
                      return _NavButton(
                        item: item,
                        expanded: _expanded,
                        onTap: () {
                          if (item.action != null) {
                            item.action!();
                          } else {
                            ref
                                .read(kanbanProvider.notifier)
                                .openColumn(item.route);
                          }
                        },
                      );
                    }).toList(),
                  ),
                ),
                const Spacer(),
                // User card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GestureDetector(
                    onTap: () => ref
                        .read(kanbanProvider.notifier)
                        .openColumn(
                          '/profile',
                          routeState: {
                            'user': {
                              'name': currentUser?.name ?? 'You',
                              'handle': currentUser?.handle ?? 'currentuser',
                              'avatar':
                                  currentUser?.avatar ??
                                  'https://picsum.photos/seed/currentuser/100/100',
                              'karma': currentUser?.karma ?? 98,
                              'isOnline': currentUser?.isOnline ?? true,
                            },
                          },
                        ),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        mainAxisAlignment: _expanded
                            ? MainAxisAlignment.start
                            : MainAxisAlignment.center,
                        children: [
                          UserAvatar(
                            src:
                                currentUser?.avatar ??
                                'https://picsum.photos/seed/currentuser/100/100',
                            size: AvatarSize.sm,
                            isOnline: true,
                          ),
                          if (_expanded) ...[
                            const SizedBox(width: 8),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    currentUser?.name ?? 'You',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.onSurface,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    '${currentUser?.karma ?? 98} karma',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF34D399),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final _NavItem item;
  final bool expanded;
  final VoidCallback onTap;

  const _NavButton({
    required this.item,
    required this.expanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: expanded ? 12 : 0,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: item.isPrimary ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                boxShadow: item.isPrimary
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.2),
                          blurRadius: 20,
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisAlignment: expanded
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.center,
                children: [
                  Icon(
                    item.icon,
                    size: 24,
                    color: item.isPrimary
                        ? AppColors.primaryForeground
                        : AppColors.onSurfaceVariant,
                    weight: item.isPrimary ? 3 : 2,
                  ),
                  if (expanded) ...[
                    const SizedBox(width: 12),
                    AnimatedOpacity(
                      opacity: expanded ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                          color: item.isPrimary
                              ? AppColors.primaryForeground
                              : AppColors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
