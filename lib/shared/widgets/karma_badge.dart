import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../app_theme.dart';

class KarmaBadge extends StatelessWidget {
  final int karma;
  final VoidCallback? onTap;

  const KarmaBadge({super.key, required this.karma, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF34D399),
                  ),
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
    );
  }
}
