import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../app_theme.dart';
import '../../../models/feed_item.dart';
import '../../../shared/settings_provider.dart';
import '../../../shared/widgets/user_avatar.dart';
import '../../../shared/widgets/expandable_text.dart';
import '../../../shared/widgets/media_carousel.dart';
import '../providers.dart';
import 'base_feed_card.dart';
import 'glass_card.dart';

IconData _getIconForTaskType(TaskIconType type) => switch (type) {
  TaskIconType.palette => PhosphorIconsRegular.palette,
  TaskIconType.code => PhosphorIconsRegular.code,
  TaskIconType.car => PhosphorIconsRegular.car,
  TaskIconType.truck => PhosphorIconsRegular.truck,
  TaskIconType.writing => PhosphorIconsRegular.pencilSimple,
  TaskIconType.repair => PhosphorIconsRegular.wrench,
  TaskIconType.package => PhosphorIconsRegular.package,
  TaskIconType.location => PhosphorIconsRegular.mapPin,
};

class TaskCard extends ConsumerWidget {
  final TaskData data;
  final bool isMain, isParent, isQuote, hasLineBelow;
  final VoidCallback? onClick;

  const TaskCard({
    super.key,
    required this.data,
    this.isMain = false,
    this.isParent = false,
    this.isQuote = false,
    this.hasLineBelow = false,
    this.onClick,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textSize = ref.watch(settingsProvider.select((s) => s.textSize));
    final currentUserHandle = ref.watch(
      uiStateProvider.select((s) => s.currentUser?.handle),
    );
    final isAuthor = currentUserHandle == data.author.handle;
    final isThread = isMain || isParent || hasLineBelow;

    return BaseFeedCard(
      data: data,
      isMain: isMain,
      isParent: isParent,
      isQuote: isQuote,
      hasLineBelow: hasLineBelow,
      onClick: onClick,
      avatarContent: UserAvatar(
        src: data.author.avatar,
        size: AvatarSize.forCard(
          isMain: isMain,
          isParent: isParent,
          isQuote: isQuote,
        ),
        isOnline: data.author.isOnline,
      ),
      bottomWidget: !isThread && !isQuote
          ? Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh.withOpacity(0.9),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.border),
              ),
              child: Center(
                child: Icon(
                  _getIconForTaskType(data.iconType),
                  size: 12,
                  color: AppColors.primary,
                ),
              ),
            )
          : null,
      headerMeta: data.status != TaskStatus.open && !isParent
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: AppColors.primary.withOpacity(0.2)),
              ),
              child: Text(
                _getStatusText(data.status),
                style: AppTheme.scaled(
                  textSize: textSize,
                  multiplier: AppTheme.m2xs,
                  color: AppColors.primary,
                  weight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
            )
          : null,
      children: [
        const SizedBox(height: 8),
        if (isParent)
          Text(
            data.title,
            style: AppTheme.scaled(
              textSize: textSize,
              multiplier: AppTheme.m13,
              color: AppColors.onSurfaceVariant,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      data.category,
                      style: AppTheme.scaled(
                        textSize: textSize,
                        multiplier: AppTheme.m2xs,
                        color: AppColors.onSurfaceVariant,
                        weight: FontWeight.w700,
                        letterSpacing: 0.92,
                      ),
                    ),
                    Text(
                      data.price,
                      style: AppTheme.scaled(
                        textSize: textSize,
                        multiplier: AppTheme.mxs,
                        color: AppColors.primary,
                        weight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  data.title,
                  style: AppTheme.scaled(
                    textSize: textSize,
                    multiplier: AppTheme.m13,
                    color: AppColors.onSurface,
                    weight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                ExpandableText(
                  text: data.description,
                  limit: 100,
                  style: AppTheme.scaled(
                    textSize: textSize,
                    multiplier: AppTheme.mxs,
                    color: AppColors.onSurfaceVariant,
                    height: 1.5,
                  ),
                  buttonStyle: AppTheme.scaled(
                    textSize: textSize,
                    multiplier: AppTheme.m2sm,
                    color: AppColors.onSurfaceVariant,
                    weight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 4),
                if (data.mapUrl != null) ...[
                  const SizedBox(height: 8),
                  _buildMapPreview(textSize),
                ],
                if (data.images != null && data.images!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  MediaCarousel(images: data.images!, aspect: '21/9'),
                ],
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (data.meta != null)
                      Text(
                        data.meta!,
                        style: AppTheme.scaled(
                          textSize: textSize,
                          multiplier: AppTheme.m1sm,
                          color: AppColors.onSurfaceVariant,
                          weight: FontWeight.w500,
                        ),
                      )
                    else
                      const SizedBox.shrink(),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.onSurface,
                        foregroundColor: AppColors.background,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        elevation: 1,
                      ),
                      child: Text(
                        isAuthor
                            ? 'Manage'
                            : data.category == 'Repair Needed'
                            ? 'Bid'
                            : 'Claim',
                        style: AppTheme.scaled(
                          textSize: textSize,
                          multiplier: AppTheme.mxs,
                          weight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildMapPreview(TextSize textSize) => ClipRRect(
    borderRadius: BorderRadius.circular(12),
    child: SizedBox(
      height: 96,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: data.mapUrl!,
            fit: BoxFit.cover,
            color: Colors.grey.withOpacity(0.2),
            colorBlendMode: BlendMode.saturation,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  AppColors.background.withOpacity(0.9),
                  AppColors.background.withOpacity(0.2),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          Positioned(
            left: 8,
            right: 8,
            bottom: 8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(9999),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        PhosphorIconsRegular.mapPin,
                        size: 10,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Static Route',
                        style: AppTheme.scaled(
                          textSize: textSize,
                          multiplier: AppTheme.m2xs,
                          color: AppColors.onSurface,
                          weight: FontWeight.w800,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.2),
                    ),
                  ),
                  child: const Icon(
                    PhosphorIconsRegular.compass,
                    size: 10,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  String _getStatusText(TaskStatus s) => switch (s) {
    TaskStatus.open => 'OPEN',
    TaskStatus.assigned => 'ASSIGNED',
    TaskStatus.inProgress => 'IN PROGRESS',
    TaskStatus.completed => 'COMPLETED',
    TaskStatus.finished => 'FINISHED',
  };
}
