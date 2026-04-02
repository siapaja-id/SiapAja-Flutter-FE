import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_theme.dart';
import '../settings_provider.dart';

class BottomSheetContainer extends ConsumerWidget {
  final String title;
  final Widget child;
  final VoidCallback? onClose;

  const BottomSheetContainer({
    super.key,
    required this.title,
    required this.child,
    this.onClose,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required WidgetBuilder builder,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BottomSheetContainer(
        title: title,
        onClose: () => Navigator.pop(context),
        child: builder(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textSize = ref.watch(settingsProvider.select((s) => s.textSize));
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 48),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTheme.scaled(
                  textSize: textSize,
                  multiplier: AppTheme.m2xl,
                  weight: FontWeight.w900,
                  color: AppColors.onSurface,
                  letterSpacing: -0.5,
                ),
              ),
              IconButton(
                onPressed: onClose ?? () => Navigator.pop(context),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.05),
                ),
                icon: const Icon(
                  Icons.close,
                  size: 20,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
