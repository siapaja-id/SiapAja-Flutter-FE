import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../app_theme.dart';
import '../../features/feed/providers.dart';

class PostActions extends ConsumerWidget {
  final String id;
  final int votes;
  final int replies;
  final int reposts;
  final int shares;
  final String? className;

  const PostActions({
    super.key,
    required this.id,
    required this.votes,
    required this.replies,
    required this.reposts,
    required this.shares,
    this.className,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appNotifierProvider);
    final voteValue = appState.userVotes[id] ?? 0;
    final isReposted = appState.userReposts.contains(id);
    final currentVotes = votes + voteValue;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Left side: Reply, Repost, Share (matches React)
        Row(
          children: [
            _ActionButton(
              icon: PhosphorIconsRegular.chatCircle,
              count: replies,
              hoverColor: const Color(0xFF3B82F6), // blue-500
              onTap: () {},
            ),
            const SizedBox(width: 2),
            _ActionButton(
              icon: PhosphorIconsRegular.repeat,
              count: reposts + (isReposted ? 1 : 0),
              active: isReposted,
              activeColor: const Color(0xFF10B981), // emerald-500
              hoverColor: const Color(0xFF10B981),
              onTap: () {
                ref.read(appNotifierProvider.notifier).toggleRepost(id);
              },
            ),
            const SizedBox(width: 2),
            _ActionButton(
              icon: PhosphorIconsRegular.paperPlaneTilt,
              count: shares,
              hoverColor: const Color(0xFF8B5CF6), // purple-500
              onTap: () {},
            ),
          ],
        ),
        // Vote pill
        _VotePill(
          votes: currentVotes,
          voteValue: voteValue,
          onUpvote: () {
            ref.read(appNotifierProvider.notifier).toggleVote(id, true);
          },
          onDownvote: () {
            ref.read(appNotifierProvider.notifier).toggleVote(id, false);
          },
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final int? count;
  final bool active;
  final Color? activeColor;
  final Color? hoverColor;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.icon,
    this.count,
    this.active = false,
    this.activeColor,
    this.hoverColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = active
        ? (activeColor ?? AppColors.primary)
        : AppColors.onSurfaceVariant;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      hoverColor: (hoverColor ?? activeColor ?? AppColors.primary).withOpacity(
        0.1,
      ),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: color),
            if (count != null && count! > 0) ...[
              const SizedBox(width: 4),
              Text(
                _formatCount(count!),
                style: Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(color: color),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return count.toString();
  }
}

class _VotePill extends StatelessWidget {
  final int votes;
  final int voteValue;
  final VoidCallback onUpvote;
  final VoidCallback onDownvote;

  const _VotePill({
    required this.votes,
    required this.voteValue,
    required this.onUpvote,
    required this.onDownvote,
  });

  @override
  Widget build(BuildContext context) {
    final voteColor = voteValue == 1
        ? const Color(0xFFF97316)
        : voteValue == -1
        ? const Color(0xFF6366F1)
        : AppColors.onSurfaceVariant;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0x0DFFFFFF), // bg-white/5 (matches React)
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0x1AFFFFFF)),
      ),
      child: Row(
        children: [
          // Upvote button
          InkWell(
            onTap: onUpvote,
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(20),
            ),
            hoverColor: const Color(0xFFF97316).withOpacity(0.1),
            child: Container(
              padding: const EdgeInsets.only(
                left: 8,
                right: 6,
                top: 6,
                bottom: 6,
              ),
              decoration: BoxDecoration(
                color: voteValue == 1
                    ? const Color(0xFFF97316).withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(20),
                ),
              ),
              child: Icon(
                PhosphorIconsRegular.arrowFatUp,
                size: 18,
                color: voteValue == 1
                    ? const Color(0xFFF97316)
                    : AppColors.onSurfaceVariant,
                fill: voteValue == 1 ? 1 : 0,
              ),
            ),
          ),
          // Vote count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              votes >= 1000
                  ? '${(votes / 1000).toStringAsFixed(1)}k'
                  : votes.toString(),
              style: Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(color: voteColor),
            ),
          ),
          // Downvote button
          InkWell(
            onTap: onDownvote,
            borderRadius: const BorderRadius.horizontal(
              right: Radius.circular(20),
            ),
            hoverColor: const Color(0xFF6366F1).withOpacity(0.1),
            child: Container(
              padding: const EdgeInsets.only(
                left: 6,
                right: 8,
                top: 6,
                bottom: 6,
              ),
              decoration: BoxDecoration(
                color: voteValue == -1
                    ? const Color(0xFF6366F1).withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: const BorderRadius.horizontal(
                  right: Radius.circular(20),
                ),
              ),
              child: Icon(
                PhosphorIconsRegular.arrowFatDown,
                size: 18,
                color: voteValue == -1
                    ? const Color(0xFF6366F1)
                    : AppColors.onSurfaceVariant,
                fill: voteValue == -1 ? 1 : 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
