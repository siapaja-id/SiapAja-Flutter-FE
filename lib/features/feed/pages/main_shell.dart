import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../app_theme.dart';

/// Main shell with bottom navigation bar
class MainShell extends ConsumerStatefulWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned.fill(child: widget.child),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _BottomNavBar(currentPath: location),
          ),
        ],
      ),
    );
  }
}

class _BottomNavBar extends ConsumerWidget {
  final String currentPath;

  const _BottomNavBar({required this.currentPath});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerHigh.withOpacity(0.95),
            border: const Border(
              top: BorderSide(color: Color(0x0DFFFFFF)),
            ), // border-white/5
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavButton(
                icon: PhosphorIconsRegular.house,
                label: 'Home',
                isActive: currentPath == '/' || currentPath == '/feed',
                onTap: () => context.go('/'),
              ),
              _NavButton(
                icon: PhosphorIconsRegular.magnifyingGlass,
                label: 'Explore',
                isActive: currentPath == '/explore',
                onTap: () => context.go('/explore'),
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    PhosphorIconsRegular.plus,
                    color: AppColors.primaryForeground,
                    size: 20,
                  ),
                ),
              ),
              _NavButton(
                icon: PhosphorIconsRegular.chatCircle,
                label: 'Messages',
                isActive: currentPath == '/messages',
                onTap: () => context.go('/messages'),
              ),
              _NavButton(
                icon: PhosphorIconsRegular.clipboardText,
                label: 'Orders',
                isActive: currentPath == '/orders',
                onTap: () => context.go('/orders'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavButton({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.primary : AppColors.onSurfaceVariant;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTheme.labelTiny.copyWith(
              color: color,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
