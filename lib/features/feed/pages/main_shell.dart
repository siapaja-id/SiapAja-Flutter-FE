import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../app_theme.dart';
import '../../../shared/models/nav_item.dart';
import '../providers.dart';

const _navItems = [
  NavItem(icon: PhosphorIconsRegular.house, label: 'Home', route: '/'),
  NavItem(
    icon: PhosphorIconsRegular.magnifyingGlass,
    label: 'Explore',
    route: '/explore',
  ),
  NavItem(
    icon: PhosphorIconsRegular.chatCircle,
    label: 'Messages',
    route: '/messages',
  ),
  NavItem(
    icon: PhosphorIconsRegular.clipboardText,
    label: 'Orders',
    route: '/orders',
  ),
];

// ---------------------------------------------------------------------------
// MainShell
// ---------------------------------------------------------------------------

class MainShell extends ConsumerStatefulWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  int _getSelectedIndex(String path) {
    if (path == '/' ||
        path.startsWith('/feed') ||
        path.startsWith('/post') ||
        path.startsWith('/task'))
      return 0;
    for (var i = 1; i < _navItems.length; i++) {
      if (path == _navItems[i].route) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final selectedIndex = _getSelectedIndex(location);
    final bottomNavVisible = ref.watch(
      uiStateProvider.select((s) => s.bottomNavVisible),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: AppTheme.backgroundGradient,
                ),
              ),
            ),
          ),
          widget.child,
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedSlide(
              offset: bottomNavVisible ? Offset.zero : const Offset(0, 1),
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: NavigationBar(
                    selectedIndex: selectedIndex,
                    onDestinationSelected: (i) =>
                        context.go(_navItems[i].route),
                    backgroundColor: AppColors.glassTint,
                    indicatorColor: AppColors.primary.withOpacity(0.2),
                    height: 64,
                    labelBehavior:
                        NavigationDestinationLabelBehavior.alwaysShow,
                    destinations: [
                      for (final item in _navItems)
                        NavigationDestination(
                          icon: Icon(item.icon, size: 22),
                          selectedIcon: Icon(
                            item.icon,
                            size: 22,
                            color: AppColors.primary,
                          ),
                          label: item.label,
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
