import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../shared/utils/color_extensions.dart';
import '../../../shared/utils/decorations.dart';
import '../../../shared/utils/task_icons.dart';
import '../../../app_theme.dart';
import '../../../models/feed_item.dart';
import '../../../shared/widgets/user_avatar.dart';
import '../../../shared/widgets/expandable_text.dart';
import '../../../shared/widgets/media_carousel.dart';
import 'base_feed_card.dart';
import 'glass_card.dart';

class TaskCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
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
                color: AppColors.surfaceContainerHigh.withValues(alpha: 0.9),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.border),
              ),
              child: Center(
                child: Icon(
                  getIconForTaskType(data.iconType),
                  size: 12,
                  color: AppColors.primary,
                ),
              ),
            )
          : null,
      headerMeta: data.status != TaskStatus.open && !isParent
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: tintedDecor(color: AppColors.primary, radius: 4),
              child: Text(
                getStatusText(data.status),
                style: AppTheme.sectionLabel.copyWith(color: AppColors.primary, fontWeight: FontWeight.w800, letterSpacing: 1),
              ),
            )
          : null,
      children: [
        const SizedBox(height: 8),
        if (isParent)
          Text(
            data.title,
            style: AppTheme.bodyCard,
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
                      style: AppTheme.sectionLabel.copyWith(color: AppColors.onSurfaceVariant),
                    ),
                    Text(
                      data.price,
                      style: AppTheme.meta.copyWith(color: AppColors.primary),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  data.title,
                  style: AppTheme.bodyBold,
                ),
                const SizedBox(height: 4),
                ExpandableText(
                  text: data.description,
                  limit: 100,
                  style: AppTheme.bodyMeta,
                  buttonStyle: AppTheme.smallLabel.copyWith(color: AppColors.onSurfaceVariant),
                ),
                const SizedBox(height: 4),
                if (data.mapUrl != null) ...[
                  const SizedBox(height: 8),
                  _buildMapPreview(),
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
                        style: AppTheme.caption.copyWith(fontWeight: FontWeight.w500),
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
                        data.category == 'Repair Needed' ? 'Bid' : 'Claim',
                        style: AppTheme.meta,
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

  Widget _buildMapPreview() => ClipRRect(
    borderRadius: BorderRadius.circular(12),
    child: SizedBox(
      height: 96,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: data.mapUrl!,
            fit: BoxFit.cover,
            color: Colors.grey.withValues(alpha: 0.2),
            colorBlendMode: BlendMode.saturation,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  AppColors.background.withValues(alpha: 0.9),
                  AppColors.background.withValues(alpha: 0.2),
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
                    color: Colors.black.black60,
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
                        style: AppTheme.sectionLabel.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.w800, letterSpacing: 1),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 24,
                  height: 24,
                  decoration: tintedDecor(color: AppColors.primary, radius: 12),
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

}
