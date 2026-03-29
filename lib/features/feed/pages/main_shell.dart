import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../app_theme.dart';
import '../viewmodels/app_viewmodel.dart';

/// Main shell with bottom navigation bar
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
    if (path == '/explore') return 1;
    if (path == '/messages') return 2;
    if (path == '/orders') return 3;
    return 0;
  }

  void _onDestinationSelected(int index) {
    switch (index) {
      case 0:
        context.go('/');
      case 1:
        context.go('/explore');
      case 2:
        context.go('/messages');
      case 3:
        context.go('/orders');
    }
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final selectedIndex = _getSelectedIndex(location);
    final appState = ref.watch(appNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      body: Stack(
        children: [
          widget.child,
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedSlide(
              offset: appState.bottomNavVisible
                  ? Offset.zero
                  : const Offset(0, 1),
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              child: NavigationBar(
                selectedIndex: selectedIndex,
                onDestinationSelected: _onDestinationSelected,
                backgroundColor: AppColors.surfaceContainerHigh.withOpacity(
                  0.95,
                ),
                indicatorColor: AppColors.primary.withOpacity(0.2),
                height: 64,
                labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                destinations: const [
                  NavigationDestination(
                    icon: Icon(PhosphorIconsRegular.house, size: 22),
                    selectedIcon: Icon(
                      PhosphorIconsRegular.house,
                      size: 22,
                      color: AppColors.primary,
                    ),
                    label: 'Home',
                  ),
                  NavigationDestination(
                    icon: Icon(PhosphorIconsRegular.magnifyingGlass, size: 22),
                    selectedIcon: Icon(
                      PhosphorIconsRegular.magnifyingGlass,
                      size: 22,
                      color: AppColors.primary,
                    ),
                    label: 'Explore',
                  ),
                  NavigationDestination(
                    icon: Icon(PhosphorIconsRegular.chatCircle, size: 22),
                    selectedIcon: Icon(
                      PhosphorIconsRegular.chatCircle,
                      size: 22,
                      color: AppColors.primary,
                    ),
                    label: 'Messages',
                  ),
                  NavigationDestination(
                    icon: Icon(PhosphorIconsRegular.clipboardText, size: 22),
                    selectedIcon: Icon(
                      PhosphorIconsRegular.clipboardText,
                      size: 22,
                      color: AppColors.primary,
                    ),
                    label: 'Orders',
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
