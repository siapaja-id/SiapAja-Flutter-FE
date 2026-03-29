import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../app_theme.dart';
import '../../../models/feed_item.dart';
import '../../../shared/widgets/user_avatar.dart';
import '../../../shared/widgets/expandable_text.dart';
import '../../../shared/widgets/media_carousel.dart';
import '../providers.dart';
import 'feed_item_card.dart';
import 'base_feed_card.dart';

// ---------------------------------------------------------------------------
// SocialPostCard
// ---------------------------------------------------------------------------

class SocialPostCard extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appNotifierProvider);
    final isAuthor = appState.currentUser?.handle == data.author.handle;
    final isThreadContext = isMain || isParent || hasLineBelow;
    final canAcceptBid =
        data.isBid == true && data.bidStatus != BidStatus.accepted && !isAuthor;

    return BaseFeedCard(
      data: data,
      isMain: isMain,
      isParent: isParent,
      isQuote: isQuote,
      hasLineBelow: hasLineBelow,
      onClick: onClick,
      avatarContent: UserAvatar(
        src: data.author.avatar,
        size: isParent || isQuote
            ? AvatarSize.sm
            : isMain
            ? AvatarSize.lg
            : AvatarSize.md,
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
        if (data.isBid == true)
          _BidCard(data: data, canAcceptBid: canAcceptBid),
        if (isParent)
          Text(
            data.content,
            style: const TextStyle(
              color: AppColors.onSurface,
              fontSize: 13,
              height: 1.5,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )
        else
          ExpandableText(
            text: data.content,
            limit: isMain ? 280 : 160,
            style: TextStyle(
              color: AppColors.onSurface.withOpacity(0.9),
              fontSize: isMain ? 16 : 13,
              height: 1.5,
            ),
            suffix: data.threadCount != null && data.threadCount! > 1
                ? Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.2),
                      ),
                    ),
                    child: Text(
                      '${data.threadIndex}/${data.threadCount}',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2,
                      ),
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
              border: Border.all(color: const Color(0x1AFFFFFF)),
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
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0x1AFFFFFF)),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    PhosphorIconsRegular.play,
                    color: AppColors.primaryForeground,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: const Color(0x1AFFFFFF),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: const FractionallySizedBox(
                          widthFactor: 0.33,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(3),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '0:12',
                            style: TextStyle(
                              color: AppColors.onSurfaceVariant,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            data.voiceNote!,
                            style: const TextStyle(
                              color: AppColors.onSurfaceVariant,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
  final bool canAcceptBid;
  const _BidCard({required this.data, required this.canAcceptBid});

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xFF10B981).withOpacity(0.1),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: const Color(0xFF10B981).withOpacity(0.2)),
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
                    : Colors.white.withOpacity(0.1),
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
            if (canAcceptBid)
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF10B981).withOpacity(0.3),
                        blurRadius: 15,
                      ),
                    ],
                  ),
                  child: const Text(
                    'Accept Bid',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    ),
  );
}
