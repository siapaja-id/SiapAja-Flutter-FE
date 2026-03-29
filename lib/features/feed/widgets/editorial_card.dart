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
    return _BaseFeedCard(
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
                border: Border.all(color: const Color(0x1AFFFFFF)),
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
          _GlassCard(
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

// ---------------------------------------------------------------------------
// _GlassCard
// ---------------------------------------------------------------------------

class _GlassCard extends StatelessWidget {
  final Widget child;
  const _GlassCard({required this.child});

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(16),
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x1AFFFFFF)),
      ),
      child: child,
    ),
  );
}

// ---------------------------------------------------------------------------
// _BaseFeedCard — shared wrapper (matches social_post_card.dart version)
// ---------------------------------------------------------------------------

class _BaseFeedCard extends ConsumerWidget {
  final FeedItem data;
  final bool isMain, isParent, isQuote, hasLineBelow;
  final VoidCallback? onClick;
  final Widget? avatarContent, headerMeta, bottomWidget;
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
    this.bottomWidget,
    required this.children,
  });

  bool get _isThreadContext => isMain || isParent || hasLineBelow;

  Widget _buildAvatarColumn(Widget avatar) {
    final showThreadLine = (hasLineBelow && !isQuote) || bottomWidget != null;
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
// _HoverWrapper
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
// _FollowButton
// ---------------------------------------------------------------------------

class _FollowButton extends ConsumerWidget {
  final String handle;
  const _FollowButton({required this.handle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appNotifierProvider);
    final isFollowing = appState.followedHandles.contains(handle);
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
