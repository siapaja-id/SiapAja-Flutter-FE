import 'package:flutter/material.dart';

import '../../../app_theme.dart';
import '../../../models/feed_item.dart';
import 'base_feed_card.dart';
import 'glass_card.dart';

// ---------------------------------------------------------------------------
// EditorialCard
// ---------------------------------------------------------------------------

class EditorialCard extends StatelessWidget {
  final EditorialData data;
  final bool isMain;
  final bool isParent;
  final bool isQuote;
  final bool hasLineBelow;
  final VoidCallback? onClick;

  const EditorialCard({
    super.key,
    required this.data,
    this.isMain = false,
    this.isParent = false,
    this.isQuote = false,
    this.hasLineBelow = false,
    this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return BaseFeedCard(
      data: data,
      isMain: isMain,
      isParent: isParent,
      isQuote: isQuote,
      hasLineBelow: hasLineBelow,
      onClick: onClick,
      avatarContent: isParent || isMain || isQuote
          ? null
          : Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh.withOpacity(0.9),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: const Center(
                child: Text(
                  'DS',
                  style: TextStyle(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
      children: [
        if (isParent)
          Text(
            data.title,
            style: const TextStyle(
              color: AppColors.onSurface,
              fontSize: 13,
              height: 1.5,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )
        else
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.tag,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.08,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  data.title,
                  style: TextStyle(
                    color: AppColors.onSurface,
                    fontSize: isMain ? 18 : 14,
                    fontWeight: FontWeight.bold,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  data.excerpt,
                  style: const TextStyle(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 12,
                    height: 1.5,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
