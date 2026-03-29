import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../app_theme.dart';
import '../../../models/feed_item.dart';
import '../../../shared/widgets/user_avatar.dart';
import '../../../shared/widgets/expandable_text.dart';
import '../../../shared/widgets/media_carousel.dart';
import '../../../shared/widgets/post_actions.dart';
import '../providers.dart';
import 'feed_item_card.dart';

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

    return _BaseFeedCard(
      data: data,
      isMain: isMain,
      isParent: isParent,
      isQuote: isQuote,
      hasLineBelow: hasLineBelow,
      onClick: onClick,
      avatarContent: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          UserAvatar(
            src: data.author.avatar,
            size: isParent || isQuote
                ? AvatarSize.sm
                : isMain
                ? AvatarSize.lg
                : AvatarSize.md,
            isOnline: data.author.isOnline,
          ),
          if (data.replyAvatars != null &&
              data.replyAvatars!.isNotEmpty &&
              !isThreadContext &&
              !isQuote) ...[
            Container(
              width: 1.5,
              height: 24,
              margin: const EdgeInsets.only(top: 6, bottom: 4),
              decoration: BoxDecoration(
                color: const Color(0x1AFFFFFF),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
            SizedBox(
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
            ),
          ],
        ],
      ),
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
                          color: const Color(0x1AFFFFFF), // bg-white/10
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
                color: Color(0xFF34D399), // emerald-400
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

// ---------------------------------------------------------------------------
// _HoverWrapper — adds hover background (matches React hover:bg-white/[0.02])
// ---------------------------------------------------------------------------

class _HoverWrapper extends StatefulWidget {
  final Widget child;
  final Color hoverColor;
  const _HoverWrapper({required this.child, required this.hoverColor});
  @override
  State<_HoverWrapper> createState() => _HoverWrapperState();
}

class _HoverWrapperState extends State<_HoverWrapper> {
  bool _isHovering = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        color: _isHovering ? widget.hoverColor : Colors.transparent,
        child: widget.child,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _BaseFeedCard — shared wrapper (matches React BaseFeedCard)
// ---------------------------------------------------------------------------

class _BaseFeedCard extends ConsumerWidget {
  final FeedItem data;
  final bool isMain, isParent, isQuote, hasLineBelow;
  final VoidCallback? onClick;
  final Widget? avatarContent, headerMeta;
  final List<Widget> children;

  const _BaseFeedCard({
    required this.data,
    required this.isMain,
    required this.isParent,
    required this.isQuote,
    required this.hasLineBelow,
    this.onClick,
    this.avatarContent,
    this.headerMeta,
    required this.children,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appNotifierProvider);
    final currentUser = appState.currentUser;
    final isAuthor = currentUser?.handle == data.author.handle;
    final isThreadContext = isMain || isParent || hasLineBelow;
    final isClickable = !isQuote && !isParent;
    final hoverColor = isQuote
        ? const Color(0x0AFFFFFF)
        : isThreadContext
        ? const Color(0x05FFFFFF)
        : const Color(0x66121212);

    return _HoverWrapper(
      hoverColor: hoverColor,
      child: GestureDetector(
        onTap: () {
          if (onClick != null) {
            onClick!();
            return;
          }
          if (!isClickable) return;
          if (data is TaskData) {
            context.go('/task/${data.id}');
          } else {
            context.go('/post/${data.id}');
          }
        },
        child: Container(
          padding: EdgeInsets.only(
            top: isQuote
                ? 12
                : isMain
                ? 8
                : isParent
                ? 16
                : 8,
            bottom: isQuote
                ? 12
                : isMain
                ? 8
                : isParent
                ? 16
                : 0,
            left: 16,
            right: 16,
          ),
          decoration: BoxDecoration(
            color: isQuote ? const Color(0x05FFFFFF) : null,
            borderRadius: isQuote ? BorderRadius.circular(16) : null,
            border: isQuote ? Border.all(color: const Color(0x1AFFFFFF)) : null,
          ),
          child: Column(
            children: [
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        avatarContent ??
                            UserAvatar(
                              src: data.author.avatar,
                              size: isQuote || isParent
                                  ? AvatarSize.sm
                                  : isMain
                                  ? AvatarSize.lg
                                  : AvatarSize.md,
                              isOnline: data.author.isOnline,
                            ),
                        if (hasLineBelow && !isQuote)
                          Expanded(
                            child: Container(
                              width: 1.5,
                              margin: const EdgeInsets.only(
                                top: 8,
                                bottom: -16,
                              ),
                              constraints: BoxConstraints(
                                minHeight: isParent ? 20 : 40,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0x1AFFFFFF),
                                borderRadius: BorderRadius.circular(1),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Wrap(
                                  spacing: 6,
                                  runSpacing: 4,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Text(
                                      isThreadContext || isQuote
                                          ? data.author.name
                                          : data.author.handle,
                                      style: TextStyle(
                                        color: AppColors.onSurface,
                                        fontSize: isParent || isQuote
                                            ? 12
                                            : isMain
                                            ? 15
                                            : 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    if (data.author.verified)
                                      Icon(
                                        PhosphorIconsRegular.sealCheck,
                                        size: isParent || isQuote ? 12 : 14,
                                        color: AppColors.primary,
                                      ),
                                    if ((isThreadContext || isQuote) &&
                                        !isParent)
                                      Text(
                                        '@${data.author.handle}',
                                        style: const TextStyle(
                                          color: AppColors.onSurfaceVariant,
                                          fontSize: 12,
                                        ),
                                      ),
                                    if (isAuthor && !isParent && !isQuote)
                                      Container(
                                        margin: const EdgeInsets.only(left: 4),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary.withOpacity(
                                            0.2,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                          border: Border.all(
                                            color: AppColors.primary
                                                .withOpacity(0.2),
                                          ),
                                        ),
                                        child: const Text(
                                          'You',
                                          style: TextStyle(
                                            color: AppColors.primary,
                                            fontSize: 8,
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: 2,
                                          ),
                                        ),
                                      ),
                                    if (headerMeta != null) headerMeta!,
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  if (isMain &&
                                      !isAuthor &&
                                      !isParent &&
                                      !isQuote)
                                    _FollowButton(handle: data.author.handle),
                                  Text(
                                    data.timestamp,
                                    style: TextStyle(
                                      color: AppColors.onSurfaceVariant
                                          .withOpacity(0.6),
                                      fontSize: 12,
                                    ),
                                  ),
                                  if (!isParent && !isQuote)
                                    const IconButton(
                                      icon: Icon(
                                        PhosphorIconsRegular.dotsThree,
                                        size: 18,
                                      ),
                                      onPressed: null,
                                      padding: EdgeInsets.zero,
                                      constraints: BoxConstraints(),
                                    ),
                                ],
                              ),
                            ],
                          ),
                          if (data is SocialPostData &&
                              (data as SocialPostData).isFirstPost == true &&
                              !isQuote &&
                              !isParent)
                            _FirstPostBadge(),
                          if (data is TaskData &&
                              (data as TaskData).isFirstTask == true &&
                              !isQuote &&
                              !isParent)
                            _FirstTaskBadge(),
                          ...children,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (!isParent && !isQuote) ...[
                const SizedBox(height: 8),
                PostActions(
                  id: data.id,
                  votes: data.votes,
                  replies: data.replies,
                  reposts: data.reposts,
                  shares: data.shares,
                ),
                if (isThreadContext && data.replies > 0 && !isMain)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      children: [
                        Icon(
                          PhosphorIconsRegular.chatCircle,
                          size: 12,
                          color: AppColors.primary.withOpacity(0.8),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${data.replies} ${data.replies == 1 ? "reply" : "replies"}',
                          style: TextStyle(
                            color: AppColors.primary.withOpacity(0.8),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
              if (!isQuote && !isParent && !isMain)
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  height: 0.5,
                  color: const Color(0x0DFFFFFF),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _FollowButton
// ---------------------------------------------------------------------------

class _FollowButton extends ConsumerWidget {
  final String handle;
  const _FollowButton({required this.handle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFollowing = ref
        .watch(appNotifierProvider)
        .followedHandles
        .contains(handle);
    return GestureDetector(
      onTap: () => ref.read(appNotifierProvider.notifier).toggleFollow(handle),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: isFollowing
              ? Colors.white.withOpacity(0.1)
              : AppColors.primary,
          borderRadius: BorderRadius.circular(20),
          border: isFollowing
              ? Border.all(color: const Color(0x1AFFFFFF))
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isFollowing
                  ? PhosphorIconsRegular.userCheck
                  : PhosphorIconsRegular.userPlus,
              size: 12,
              color: isFollowing
                  ? AppColors.onSurfaceVariant
                  : AppColors.primaryForeground,
            ),
            const SizedBox(width: 4),
            Text(
              isFollowing ? 'Following' : 'Follow',
              style: TextStyle(
                color: isFollowing
                    ? AppColors.onSurfaceVariant
                    : AppColors.primaryForeground,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _FirstPostBadge
// ---------------------------------------------------------------------------

class _FirstPostBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(top: 4, bottom: 4),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    decoration: BoxDecoration(
      color: const Color(0xFF10B981),
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF10B981).withOpacity(0.5),
          blurRadius: 15,
        ),
      ],
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        const Text(
          'First Post',
          style: TextStyle(
            color: Colors.black,
            fontSize: 9,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
      ],
    ),
  );
}

// ---------------------------------------------------------------------------
// _FirstTaskBadge
// ---------------------------------------------------------------------------

class _FirstTaskBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(top: 4, bottom: 4),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    decoration: BoxDecoration(
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(color: AppColors.primary.withOpacity(0.5), blurRadius: 15),
      ],
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            color: AppColors.primaryForeground,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        const Text(
          'First Task',
          style: TextStyle(
            color: AppColors.primaryForeground,
            fontSize: 9,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
      ],
    ),
  );
}
