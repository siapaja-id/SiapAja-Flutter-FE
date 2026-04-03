import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../utils/color_extensions.dart';
import '../utils/decorations.dart';
import '../../app_theme.dart';

class VoiceNotePlayer extends StatelessWidget {
  final String duration;
  final double progress;

  const VoiceNotePlayer({
    super.key,
    required this.duration,
    this.progress = 0.33,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.surfaceContainerHigh, AppColors.surfaceContainer],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.w05),
        boxShadow: [
          shadowSm(),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              boxShadow: [
                shadowGlow(color: AppColors.primary),
              ],
            ),
            child: const Center(
              child: Icon(
                PhosphorIconsFill.play,
                size: 20,
                color: AppColors.primaryForeground,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              children: [
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.white.w10,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Stack(
                    children: [
                      FractionallySizedBox(
                        widthFactor: progress,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      Positioned(
                        right: -4,
                        top: -2,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(color: Colors.black26, blurRadius: 4),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '0:12',
                      style: AppTheme.smallLabel.copyWith(color: AppColors.onSurfaceVariant),
                    ),
                    Text(
                      duration,
                      style: AppTheme.smallLabel.copyWith(fontWeight: FontWeight.w700, letterSpacing: 1),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
