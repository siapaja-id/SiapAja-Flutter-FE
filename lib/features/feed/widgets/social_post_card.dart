import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../shared/utils/color_extensions.dart';
import '../../../shared/utils/decorations.dart';
import '../../../app_theme.dart';
import '../../../models/feed_item.dart';
import '../../../shared/widgets/user_avatar.dart';
import '../../../shared/widgets/expandable_text.dart';
import '../../../shared/widgets/media_carousel.dart';
import '../../../shared/widgets/voice_note_player.dart';
import 'feed_item_card.dart';
import 'base_feed_card.dart';
// SocialPostCard
// ---------------------------------------------------------------------------

class SocialPostCard extends StatelessWidget {
  final SocialPostData data;
  final bool isMain, isParent, isQuote, hasLineBelow;
  final VoidCallback? onClick;

  const SocialPostCard({
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
    final isThreadContext = isMain || isParent || hasLineBelow;

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
      bottomWidget:
          data.replyAvatars != null &&
              data.replyAvatars!.isNotEmpty &&
              !isThreadContext &&
              !isQuote
          ? SizedBox(
              width: 20,
              height: 20,
              child: Stack(
                children: data.replyAvatars!.asMap().entries.map((entry) {
                  final i = entry.key;
                  final av = entry.value;
                  const positions = [
                    {'left': 0.0, 'top': 0.0, 'size': 12.0},
                    {'right': 0.0, 'top': 2.0, 'size': 8.0},
                    {'left': 2.0, 'bottom': 0.0, 'size': 6.0},
                  ];
                  final pos = i < positions.length ? positions[i] : {};
                  return Positioned(
                    left: pos['left'] as double?,
                    right: pos['right'] as double?,
                    top: pos['top'] as double?,
                    bottom: pos['bottom'] as double?,
                    child: Container(
                      width: pos['size'] as double? ?? 8,
                      height: pos['size'] as double? ?? 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.background,
                          width: 1,
                        ),
                      ),
                      child: ClipOval(
                        child: Image.network(av, fit: BoxFit.cover),
                      ),
                    ),
                  );
                }).toList(),
              ),
            )
          : null,
      children: [
        if (data.isBid == true) _BidCard(data: data),
        if (isParent)
          Text(
            data.content,
            style: AppTheme.bodyCardWhite,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )
        else
          ExpandableText(
            text: data.content,
            limit: isMain ? 280 : 160,
            style: isMain
                ? AppTheme.subtitle.copyWith(color: AppColors.onSurface.withOpacity(0.9))
                : AppTheme.bodyCardWhite.copyWith(color: AppColors.onSurface.withOpacity(0.9)),
            suffix: data.threadCount != null && data.threadCount! > 1
                ? Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: tintedDecorHalf(
                      color: AppColors.primary,
                      radius: 6,
                    ),
                    child: Text(
                      '${data.threadIndex}/${data.threadCount}',
                      style: AppTheme.sectionLabel.copyWith(color: AppColors.primary),
                    ),
                  )
                : null,
          ),
        if (!isParent && data.images != null && data.images!.isNotEmpty) ...[
          const SizedBox(height: 8),
          MediaCarousel(images: data.images!, aspect: isMain ? '3/4' : '16/9'),
        ],
        if (!isParent && data.video != null) ...[
          const SizedBox(height: 8),
          Container(
            height: 320,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    PhosphorIconsRegular.playCircle,
                    size: 48,
                    color: AppColors.onSurfaceVariant,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Video Player',
                    style: TextStyle(color: AppColors.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ),
        ],
        if (!isParent && data.voiceNote != null) ...[
          const SizedBox(height: 8),
          VoiceNotePlayer(duration: data.voiceNote!),
        ],
        if (!isParent && data.quote != null) ...[
          const SizedBox(height: 8),
          FeedItemCard(item: data.quote!, isQuote: true),
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// _BidCard
// ---------------------------------------------------------------------------

class _BidCard extends StatelessWidget {
  final SocialPostData data;
  const _BidCard({required this.data});

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: tintedDecorHalf(
      color: const Color(0xFF10B981),
      radius: 16,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Icon(
                  PhosphorIconsRegular.sealCheck,
                  color: Color(0xFF10B981),
                  size: 12,
                ),
                SizedBox(width: 6),
                Text(
                  'PROPOSED BID',
                  style: TextStyle(
                    color: Color(0xFF10B981),
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
            Text(
              data.bidAmount ?? '',
              style: const TextStyle(
                color: Color(0xFF34D399),
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: data.bidStatus == BidStatus.accepted
                    ? const Color(0xFF10B981)
                    : Colors.white.w10,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                data.bidStatus == BidStatus.accepted ? 'Accepted' : 'Pending',
                style: TextStyle(
                  color: data.bidStatus == BidStatus.accepted
                      ? Colors.black
                      : Colors.white54,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
