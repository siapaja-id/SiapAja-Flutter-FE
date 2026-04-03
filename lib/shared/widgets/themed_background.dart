import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_theme.dart';
import '../../shared/settings_provider.dart';

/// Full-screen themed gradient background.
///
/// Replaces the repeated `Positioned.fill > IgnorePointer > Container(gradient: …)`
/// pattern found in [MainShell], [RadarPage], [DesktopKanbanLayout], etc.
class ThemedBackground extends ConsumerWidget {
  const ThemedBackground({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeColor = ref.watch(settingsProvider.select((s) => s.themeColor));

    return Positioned.fill(
      child: IgnorePointer(
        child: Container(
          decoration: BoxDecoration(
            gradient: AppTheme.backgroundGradient(themeColor),
          ),
        ),
      ),
    );
  }
}
