import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../app_theme.dart';
import '../../../models/feed_item.dart';
import '../../../shared/widgets/user_avatar.dart';
import '../../../shared/widgets/post_actions.dart';
import '../providers.dart';

// ---------------------------------------------------------------------------
// HoverWrapper — adds hover background
// ---------------------------------------------------------------------------

class HoverWrapper extends StatefulWidget {
  final Widget child;
  final Color hoverColor;
  const HoverWrapper({
    super.key,
    required this.child,
    required this.hoverColor,
  });
  @override
  State<HoverWrapper> createState() => _HoverWrapperState();
}

class _HoverWrapperState extends State<HoverWrapper> {
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
// BaseFeedCard — shared wrapper for all feed card types
// ---------------------------------------------------------------------------

class BaseFeedCard extends ConsumerWidget {
  final FeedItem data;
  final bool isMain, isParent, isQuote, hasLineBelow;
  final VoidCallback? onClick;
  final Widget? avatarContent, headerMeta, bottomWidget;
  final List<Widget> children;

  const BaseFeedCard({
    super.key,
    required this.data,
    required this.isMain,
    required this.isParent,
    required this.isQuote,
    required this.hasLineBelow,
    this.onClick,
    this.avatarContent,
    this.headerMeta,
    this.bottomWidget,
    required this.children,
  });

  bool get _hasReplyAvatars =>
      data is SocialPostData &&
      (data as SocialPostData).replyAvatars != null &&
      (data as SocialPostData).replyAvatars!.isNotEmpty;

  bool get _isThreadContext => isMain || isParent || hasLineBelow;

  Widget _buildAvatarColumn(Widget avatar) {
    final showThreadLine =
        (hasLineBelow && !isQuote) ||
        (_hasReplyAvatars && !_isThreadContext) ||
        bottomWidget != null;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        avatar,
        if (showThreadLine)
          Expanded(
            child: Container(
              width: 1.5,
              margin: const EdgeInsets.only(top: 8),
              constraints: BoxConstraints(minHeight: isParent ? 20 : 40),
              decoration: BoxDecoration(
                color: const Color(0x1AFFFFFF),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),
        if (bottomWidget != null) bottomWidget!,
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appNotifierProvider);
    final currentUser = appState.currentUser;
    final isAuthor = currentUser?.handle == data.author.handle;
    final isClickable = !isQuote && !isParent;
    final hoverColor = isQuote
        ? const Color(0x0AFFFFFF)
        : _isThreadContext
        ? const Color(0x05FFFFFF)
        : const Color(0x66121212);

    return HoverWrapper(
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
                ? 16
                : isMain
                ? 12
                : isParent
                ? 16
                : 12,
            bottom: isQuote
                ? 16
                : isMain
                ? 12
                : isParent
                ? 16
                : 0,
            left: 20,
            right: 20,
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
                    _buildAvatarColumn(
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
                    ),
                    const SizedBox(width: 14),
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
                                      _isThreadContext || isQuote
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
                                    if ((_isThreadContext || isQuote) &&
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
                                    FollowButton(handle: data.author.handle),
                                  Text(
                                    data.timestamp,
                                    style: TextStyle(
                                      color: AppColors.onSurfaceVariant
                                          .withOpacity(0.6),
                                      fontSize: 12,
                                    ),
                                  ),
                                  if (!isParent && !isQuote) ...[
                                    const SizedBox(width: 4),
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
                                ],
                              ),
                            ],
                          ),
                          if (data is SocialPostData &&
                              (data as SocialPostData).isFirstPost == true &&
                              !isQuote &&
                              !isParent)
                            const FirstPostBadge(),
                          if (data is TaskData &&
                              (data as TaskData).isFirstTask == true &&
                              !isQuote &&
                              !isParent)
                            const FirstTaskBadge(),
                          ...children,
                          if (!isParent && !isQuote) ...[
                            const SizedBox(height: 8),
                            PostActions(
                              id: data.id,
                              votes: data.votes,
                              replies: data.replies,
                              reposts: data.reposts,
                              shares: data.shares,
                            ),
                            if (_isThreadContext && data.replies > 0 && !isMain)
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
                                        color: AppColors.primary.withOpacity(
                                          0.8,
                                        ),
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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
// FollowButton
// ---------------------------------------------------------------------------

class FollowButton extends ConsumerWidget {
  final String handle;
  const FollowButton({super.key, required this.handle});

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
// FirstPostBadge
// ---------------------------------------------------------------------------

class FirstPostBadge extends StatelessWidget {
  const FirstPostBadge({super.key});
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(top: 4, bottom: 4),
    child: Badge(
      backgroundColor: const Color(0xFF10B981),
      textColor: Colors.black,
      textStyle: const TextStyle(
        fontSize: 9,
        fontWeight: FontWeight.w900,
        letterSpacing: 2,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      largeSize: 18,
      label: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 6,
            height: 6,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
            ),
          ),
          SizedBox(width: 6),
          Text('First Post'),
        ],
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// FirstTaskBadge
// ---------------------------------------------------------------------------

class FirstTaskBadge extends StatelessWidget {
  const FirstTaskBadge({super.key});
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(top: 4, bottom: 4),
    child: Badge(
      backgroundColor: AppColors.primary,
      textColor: AppColors.primaryForeground,
      textStyle: const TextStyle(
        fontSize: 9,
        fontWeight: FontWeight.w900,
        letterSpacing: 2,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      largeSize: 18,
      label: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 6,
            height: 6,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.primaryForeground,
                shape: BoxShape.circle,
              ),
            ),
          ),
          SizedBox(width: 6),
          Text('First Task'),
        ],
      ),
    ),
  );
}
