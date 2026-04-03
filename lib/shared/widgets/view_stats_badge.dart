import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../app_theme.dart';
import '../utils/string_extensions.dart';
import 'glass_pill.dart';
import 'pulsing_dot.dart';

class ViewStatsBadge extends StatelessWidget {
  final int viewCount;
  final int? viewingNow;

  const ViewStatsBadge({super.key, required this.viewCount, this.viewingNow});

  @override
  Widget build(BuildContext context) {
    return GlassPill(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            PhosphorIconsRegular.eye,
            size: 14,
            color: AppColors.onSurfaceVariant,
          ),
          const SizedBox(width: 6),
          Text(
            viewCount.formatCompact(),
            style: AppTheme.scaled(
              multiplier: AppTheme.m1sm,
              weight: FontWeight.w700,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          if (viewingNow != null && viewingNow! > 0) ...[
            const SizedBox(width: 8),
            Container(
              width: 4,
              height: 4,
              decoration: const BoxDecoration(
                color: AppColors.onSurfaceVariant,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            const PulsingDot(color: AppColors.emerald, size: 6),
            const SizedBox(width: 6),
            Text(
              '$viewingNow viewing',
              style: AppTheme.scaled(
                multiplier: AppTheme.m1sm,
                weight: FontWeight.w700,
                color: AppColors.emerald,
              ),
            ),
          ],
        ],
      ),
    );
  }

}
