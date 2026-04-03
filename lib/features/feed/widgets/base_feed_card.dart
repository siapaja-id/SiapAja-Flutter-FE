import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../shared/utils/color_extensions.dart';
import '../../../app_theme.dart';
import '../../../models/feed_item.dart';
import '../../../shared/widgets/user_avatar.dart';
import '../../../shared/widgets/post_actions.dart';
import '../providers.dart';
import 'kanban_column_widget.dart';

// ---------------------------------------------------------------------------
// InteractiveFeedCard — multi-input hover / press effects
// ---------------------------------------------------------------------------

class InteractiveFeedCard extends StatefulWidget {
  final Widget child;
  final Color hoverColor;
  final VoidCallback? onTap;
  const InteractiveFeedCard({
    super.key,
    required this.child,
    required this.hoverColor,
    this.onTap,
  });
  @override
  State<InteractiveFeedCard> createState() => _InteractiveFeedCardState();
}

class _InteractiveFeedCardState extends State<InteractiveFeedCard> {
  bool _isHovering = false;
  bool _isPressed = false;

  void _setHovering(bool v) {
    if (_isHovering == v) return;
    setState(() => _isHovering = v);
  }

  void _setPressed(bool v) {
    if (_isPressed == v) return;
    setState(() => _isPressed = v);
  }

  @override
  Widget build(BuildContext context) {
    final active = _isHovering || _isPressed;
    final scale = _isPressed ? 0.985 : (_isHovering ? 1.008 : 1.0);

    final glowColor = _isPressed
        ? AppColors.primary.p06
        : AppColors.primary.p03;
    final glowColorEnd = _isPressed
        ? AppColors.primary.p02
        : Colors.transparent;

    return MouseRegion(
      onEnter: (_) => _setHovering(true),
      onExit: (_) {
        _setHovering(false);
        _setPressed(false);
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _setPressed(true),
        onTapCancel: () => _setPressed(false),
        onTapUp: (_) {
          _setPressed(false);
          widget.onTap?.call();
        },
        child: AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 180),
          curve: AppTheme.curveOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: AppTheme.curveOut,
            decoration: BoxDecoration(
              color: active ? widget.hoverColor : Colors.transparent,
              border: active
                  ? Border(
                      left: BorderSide(
                        color: AppColors.primary.p50,
                        width: 2,
                      ),
                    )
                  : const Border(
                      left: BorderSide(color: Colors.transparent, width: 2),
                    ),
              gradient: active
                  ? LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [glowColor, glowColorEnd],
                    )
                  : null,
            ),
            child: Stack(
              children: [
                if (active)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Colors.transparent,
                            AppColors.primary.p60,
                            AppColors.primary.withOpacity(0.0),
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                      ),
                    ),
                  ),
                widget.child,
              ],
            ),
          ),
        ),
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
                color: AppColors.border,
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
    final currentUserHandle = ref.watch(
      uiStateProvider.select((s) => s.currentUser?.handle),
    );
    final isAuthor = currentUserHandle == data.author.handle;
    final isClickable = !isQuote && !isParent;
    final hoverColor = isQuote
        ? AppColors.borderHover
        : _isThreadContext
        ? AppColors.borderQuote
        : AppColors.overlayDark;

    return InteractiveFeedCard(
      hoverColor: hoverColor,
      onTap: () {
        if (onClick != null) {
          onClick!();
          return;
        }
        if (!isClickable) return;
        final kanbanCtx = KanbanColumnContext.of(context);
        if (kanbanCtx != null) {
          final path = data is TaskData
              ? '/task/${data.id}'
              : '/post/${data.id}';
          ref
              .read(kanbanProvider.notifier)
              .openColumn(path, sourceId: kanbanCtx.columnId);
        } else {
          if (data is TaskData) {
            context.push('/task/${data.id}');
          } else {
            context.push('/post/${data.id}');
          }
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
          color: isQuote ? AppColors.borderQuote : null,
          borderRadius: isQuote ? BorderRadius.circular(16) : null,
          border: isQuote ? Border.all(color: AppColors.border) : null,
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
                          size: AvatarSize.forCard(
                            isMain: isMain,
                            isParent: isParent,
                            isQuote: isQuote,
                          ),
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
                                    style: TextStyle(fontSize: 14 * (isParent || isQuote ? AppTheme.mxs : isMain ? AppTheme.m15 : AppTheme.m13), fontWeight: FontWeight.w600, color: AppColors.onSurface),
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
                                      style: TextStyle(fontSize: 14 * AppTheme.mxs, color: AppColors.onSurfaceVariant),
                                    ),
                                  if (isAuthor && !isParent && !isQuote)
                                    Container(
                                      margin: const EdgeInsets.only(left: 4),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.p20,
                                      
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(
                                          color: AppColors.primary.p20,
                                        
                                        ),
                                      ),
                                      child: Text(
                                        'You',
                                        style: AppTheme.sectionLabel.copyWith(fontSize: 14 * AppTheme.m3xs, color: AppColors.primary),
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
                                  style: TextStyle(fontSize: 14 * AppTheme.mxs, color: AppColors.onSurfaceVariant.withOpacity(0.6)),
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
                          FirstItemBadge(
                            label: 'First Post',
                            bgColor: Color(0xFF10B981),
                            fgColor: Colors.black,
                            dotColor: Colors.black,
                          ),
                        if (data is TaskData &&
                            (data as TaskData).isFirstTask == true &&
                            !isQuote &&
                            !isParent)
                          FirstItemBadge(
                            label: 'First Task',
                            bgColor: AppColors.primary,
                            fgColor: AppColors.primaryForeground,
                            dotColor: AppColors.primaryForeground,
                          ),
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
                                    color: AppColors.primary.p80,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${data.replies} ${data.replies == 1 ? "reply" : "replies"}',
                                    style: AppTheme.caption.copyWith(color: AppColors.primary.p80),
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
                color: AppColors.borderSubtle,
              ),
          ],
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
    final isFollowing = ref.watch(
      followedHandlesProvider.select((s) => s.contains(handle)),
    );
    return GestureDetector(
      onTap: () => ref.read(followedHandlesProvider.notifier).toggle(handle),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: isFollowing
              ? Colors.white.w10
              : AppColors.primary,
          borderRadius: BorderRadius.circular(20),
          border: isFollowing ? Border.all(color: AppColors.border) : null,
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
              style: AppTheme.smallLabel.copyWith(color: isFollowing
                    ? AppColors.onSurfaceVariant
                    : AppColors.primaryForeground),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// FirstItemBadge — unified badge for "First Post" / "First Task" etc.
// ---------------------------------------------------------------------------

class FirstItemBadge extends StatelessWidget {
  final String label;
  final Color bgColor;
  final Color fgColor;
  final Color dotColor;

  const FirstItemBadge({
    super.key,
    required this.label,
    required this.bgColor,
    required this.fgColor,
    required this.dotColor,
  });

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(top: 4, bottom: 4),
    child: Badge(
      backgroundColor: bgColor,
      textColor: fgColor,
      textStyle: AppTheme.sectionLabel,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      largeSize: 18,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 6,
            height: 6,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
    ),
  );
}
