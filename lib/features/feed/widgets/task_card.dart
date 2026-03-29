import 'package:cached_network_image/cached_network_image.dart';
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

// ---------------------------------------------------------------------------
// TaskCard
// ---------------------------------------------------------------------------

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
    final appState = ref.watch(appNotifierProvider);
    final isAuthor = appState.currentUser?.handle == data.author.handle;
    final isThread = isMain || isParent || hasLineBelow;

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
            size: isQuote || isParent
                ? AvatarSize.sm
                : isMain
                ? AvatarSize.lg
                : AvatarSize.md,
            isOnline: data.author.isOnline,
          ),
          if (!isThread && !isQuote) ...[
            Container(
              width: 1.5,
              height: 24,
              margin: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0x1AFFFFFF),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh.withOpacity(0.9),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0x1AFFFFFF)),
              ),
              child: Center(
                child: Icon(
                  _getIconForTaskType(data.iconType),
                  size: 12,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ],
      ),
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
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
            )
          : null,
      children: [
        if (isParent)
          Text(
            data.title,
            style: const TextStyle(
              color: AppColors.onSurfaceVariant,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      data.category,
                      style: const TextStyle(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.92,
                      ),
                    ),
                    Text(
                      data.price,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  data.title,
                  style: const TextStyle(
                    color: AppColors.onSurface,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                ExpandableText(
                  text: data.description,
                  limit: 100,
                  style: const TextStyle(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 12,
                    height: 1.5,
                  ),
                  buttonStyle: const TextStyle(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
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
                        style: const TextStyle(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
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
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        if (!isParent && data.assignedWorker != null) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0x1AFFFFFF)),
            ),
            child: Row(
              children: [
                UserAvatar(
                  src: data.assignedWorker!.avatar,
                  size: AvatarSize.sm,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.assignedWorker!.name,
                        style: const TextStyle(
                          color: AppColors.onSurface,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Accepted: ${data.acceptedBidAmount}',
                        style: const TextStyle(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
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
                    border: Border.all(color: const Color(0x1AFFFFFF)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        PhosphorIconsRegular.mapPin,
                        size: 10,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Static Route',
                        style: TextStyle(
                          color: AppColors.onSurface,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
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
// _BaseFeedCard — shared wrapper (matches social_post_card.dart version)
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
