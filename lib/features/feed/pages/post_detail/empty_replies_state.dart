import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../app_theme.dart';
import '../../../../models/feed_item.dart';
import '../../../../shared/settings_provider.dart';

class EmptyRepliesState extends ConsumerWidget {
  final FeedItem item;
  final bool isCreator;
  final VoidCallback? onBidClick;
  final VoidCallback? onFocusReply;

  const EmptyRepliesState({
    super.key,
    required this.item,
    required this.isCreator,
    this.onBidClick,
    this.onFocusReply,
  });

  bool get _isTask => item is TaskData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textSize = ref.watch(settingsProvider.select((s) => s.textSize));
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
      child: Column(
        children: [
          SizedBox(
            width: 96,
            height: 96,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 256,
                  height: 256,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withOpacity(0.05),
                  ),
                ),
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainer,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      _isTask
                          ? PhosphorIconsFill.sparkle
                          : PhosphorIconsRegular.chatTeardropDots,
                      size: 36,
                      color: _isTask ? AppColors.emerald : AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            _isTask ? 'No bids yet' : 'Quiet in here...',
            style: AppTheme.scaled(
              textSize: textSize,
              multiplier: AppTheme.m3xl,
              weight: FontWeight.w900,
              color: AppColors.onSurface,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _isTask
                ? isCreator
                      ? 'Your task is live! Check back soon for bids from interested workers.'
                      : 'This task is waiting for a hero. Submit your bid and secure this opportunity!'
                : 'Be the first to share your thoughts and start the conversation.',
            textAlign: TextAlign.center,
            style: AppTheme.scaled(
              textSize: textSize,
              multiplier: AppTheme.mbase,
              weight: FontWeight.w500,
              color: AppColors.onSurfaceVariant,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          if (!isCreator && _isTask)
            OutlinedButton.icon(
              onPressed: onBidClick,
              icon: const Icon(
                PhosphorIconsFill.sparkle,
                size: 14,
                color: AppColors.emerald,
              ),
              label: Text(
                'PLACE FIRST BID',
                style: AppTheme.scaled(
                  textSize: textSize,
                  multiplier: AppTheme.mxs,
                  weight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.emerald,
                side: BorderSide(color: AppColors.emerald.withOpacity(0.2)),
                backgroundColor: AppColors.emerald.withOpacity(0.1),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            )
          else if (!_isTask)
            OutlinedButton.icon(
              onPressed: onFocusReply,
              icon: const Icon(
                PhosphorIconsRegular.chatTeardropDots,
                size: 14,
                color: AppColors.primary,
              ),
              label: Text(
                'WRITE A REPLY',
                style: AppTheme.scaled(
                  textSize: textSize,
                  multiplier: AppTheme.mxs,
                  weight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: BorderSide(color: AppColors.primary.withOpacity(0.2)),
                backgroundColor: AppColors.primary.withOpacity(0.1),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
