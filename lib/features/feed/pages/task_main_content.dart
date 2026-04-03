import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../app_theme.dart';
import '../../../models/feed_item.dart';
import '../../../shared/utils/task_icons.dart';
import '../../../shared/widgets/user_avatar.dart';
import '../../../shared/widgets/media_carousel.dart';
import '../../../shared/widgets/post_actions.dart';
import '../../../shared/widgets/pulsing_dot.dart';
import '../../../shared/widgets/tag_pill.dart';
import '../../../shared/widgets/voice_note_player.dart';
import '../../../shared/widgets/map_preview.dart';
import '../widgets/base_feed_card.dart';

class TaskMainContent extends StatefulWidget {
  final TaskData data;

  const TaskMainContent({super.key, required this.data});

  @override
  State<TaskMainContent> createState() => _TaskMainContentState();
}

class _TaskMainContentState extends State<TaskMainContent> {
  bool _isDescExpanded = false;

  TaskData get data => widget.data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 16),
          Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.08),
                  Colors.white.withOpacity(0.02),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          if (data.isFirstPost == true) ...[
            FirstItemBadge(
              label: 'First Post',
              bgColor: const Color(0xFF10B981),
              fgColor: Colors.black,
              dotColor: Colors.black,
            ),
            const SizedBox(height: 16),
          ],
          if (data.isFirstTask == true) ...[
            FirstItemBadge(
              label: 'First Task',
              bgColor: AppColors.primary,
              fgColor: AppColors.primaryForeground,
              dotColor: AppColors.primaryForeground,
            ),
            const SizedBox(height: 16),
          ],
          _buildInfoPill(context),
          const SizedBox(height: 20),
          _buildTitle(context),
          const SizedBox(height: 24),
          _buildTrustCard(context),
          const SizedBox(height: 24),
          _buildStatusTracker(context),
          const SizedBox(height: 24),
          _buildSectionLabel('DESCRIPTION'),
          const SizedBox(height: 10),
          _buildDescription(context),
          if (data.mapUrl != null ||
              (data.images != null && data.images!.isNotEmpty) ||
              data.video != null ||
              data.voiceNote != null) ...[
            const SizedBox(height: 32),
            _buildSectionLabel('ATTACHMENTS'),
            const SizedBox(height: 10),
            _buildMediaModules(context),
          ],
          if (data.tags != null && data.tags!.isNotEmpty) ...[
            const SizedBox(height: 24),
            _buildSectionLabel('TAGS'),
            const SizedBox(height: 10),
            _buildTags(context),
          ],
          if (data.meta != null) ...[
            const SizedBox(height: 16),
            _buildMeta(context),
          ],
          const SizedBox(height: 24),
          _buildPostActions(context),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: AppTheme.scaled(
        multiplier: AppTheme.m2xs,
        color: AppColors.onSurfaceVariant.withOpacity(0.4),
        weight: FontWeight.w900,
        letterSpacing: 2.5,
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 16,
                    ),
                  ],
                ),
                child: UserAvatar(
                  src: data.author.avatar,
                  size: AvatarSize.xl,
                  isOnline: data.author.isOnline,
                ),
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            data.author.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTheme.scaled(
                              multiplier: AppTheme.mlg,
                              color: AppColors.onSurface,
                              weight: FontWeight.w900,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                        if (data.author.verified) ...[
                          const SizedBox(width: 6),
                          const Icon(
                            PhosphorIconsFill.sealCheck,
                            size: 16,
                            color: AppColors.primary,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '@${data.author.handle}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTheme.scaled(
                        multiplier: AppTheme.m13,
                        color: AppColors.onSurfaceVariant,
                        weight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                data.price,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTheme.scaled(
                  multiplier: AppTheme.m28,
                  color: AppColors.onSurface,
                  weight: FontWeight.w900,
                  letterSpacing: -1,
                ),
              ),
              if (data.status != TaskStatus.open) ...[
                const SizedBox(height: 4),
                _buildStatusTag(data.status),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusTag(TaskStatus status) {
    final label = switch (status) {
      TaskStatus.open => 'Open',
      TaskStatus.assigned => 'Assigned',
      TaskStatus.inProgress => 'In Progress',
      TaskStatus.completed => 'Completed',
      TaskStatus.finished => 'Finished',
    };
    return TagPill(label: label);
  }

  Widget _buildInfoPill(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.glassTint,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                getIconForTaskType(data.iconType),
                size: 12,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              data.category.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTheme.scaled(
                multiplier: AppTheme.m2sm,
                color: AppColors.onSurfaceVariant,
                weight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: SizedBox(
              width: 4,
              height: 4,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white24,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          const Icon(
            PhosphorIconsRegular.clock,
            size: 12,
            color: AppColors.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          Text(
            data.timestamp,
            style: AppTheme.scaled(
              multiplier: AppTheme.m1sm,
              color: AppColors.onSurfaceVariant,
              weight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      data.title,
      style: AppTheme.scaled(
        multiplier: AppTheme.m26,
        color: AppColors.onSurface,
        weight: FontWeight.w900,
        height: 1.15,
        letterSpacing: -0.5,
      ),
    );
  }

  Widget _buildTrustCard(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.glassTint,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.glassBorder),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                height: 1,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.glassGlow,
                        AppColors.glassGlow.withOpacity(0),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: -40,
                right: -40,
                child: Container(
                  width: 128,
                  height: 128,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.emerald.withOpacity(0.1),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: 1,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.emerald.withOpacity(0),
                        AppColors.emerald.withOpacity(0.15),
                        AppColors.emerald.withOpacity(0),
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'REQUESTER RATING',
                          style: AppTheme.scaled(
                            multiplier: AppTheme.m2sm,
                            color: AppColors.onSurfaceVariant,
                            weight: FontWeight.w900,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(
                              PhosphorIconsFill.star,
                              size: 18,
                              color: Color(0xFFFBBF24),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '4.9',
                              style: AppTheme.scaled(
                                multiplier: AppTheme.mxl,
                                color: AppColors.onSurface,
                                weight: FontWeight.w900,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '(124)',
                              style: AppTheme.scaled(
                                multiplier: AppTheme.m1sm,
                                color: AppColors.onSurfaceVariant.withOpacity(
                                  0.6,
                                ),
                                weight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: Colors.white.withOpacity(0.1),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PAYMENT',
                          style: AppTheme.scaled(
                            multiplier: AppTheme.m2sm,
                            color: AppColors.onSurfaceVariant.withOpacity(0.6),
                            weight: FontWeight.w900,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(
                              PhosphorIconsRegular.shieldCheck,
                              size: 18,
                              color: AppColors.emerald,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Verified',
                              style: AppTheme.scaled(
                                multiplier: AppTheme.mbase,
                                color: AppColors.emerald,
                                weight: FontWeight.w900,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusTracker(BuildContext context) {
    const statuses = [
      'Open',
      'Assigned',
      'In Progress',
      'Reviewing',
      'Finished',
    ];
    final currentIndex = data.status.index;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -40,
            right: -40,
            child: Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.emerald.withOpacity(0.05),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Column(
            children: [
              SizedBox(
                height: 50,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: 7,
                      left: 7,
                      right: 7,
                      child: Container(
                        height: 3,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 7,
                      left: 7,
                      right: 7,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final progressWidth =
                              constraints.maxWidth *
                              (currentIndex / (statuses.length - 1));
                          return SizedBox(
                            width: progressWidth,
                            child: Container(
                              height: 3,
                              decoration: BoxDecoration(
                                color: AppColors.emerald,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: statuses.asMap().entries.map((entry) {
                        final i = entry.key;
                        final label = entry.value;
                        final isActive = i <= currentIndex;
                        return Column(
                          children: [
                            if (isActive && i == currentIndex)
                              Container(
                                width: 14,
                                height: 14,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.emerald.withOpacity(0.5),
                                      blurRadius: 20,
                                    ),
                                  ],
                                ),
                                child: const PulsingDot(
                                  color: AppColors.emerald,
                                  size: 14,
                                ),
                              )
                            else
                              Container(
                                width: 14,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? AppColors.emerald
                                      : AppColors.surfaceContainer,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isActive
                                        ? AppColors.emerald
                                        : Colors.white.withOpacity(0.2),
                                    width: 2.5,
                                  ),
                                  boxShadow: isActive
                                      ? [
                                          BoxShadow(
                                            color: AppColors.emerald
                                                .withOpacity(0.5),
                                            blurRadius: 20,
                                          ),
                                        ]
                                      : null,
                                ),
                              ),
                            const SizedBox(height: 8),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                label,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                style: AppTheme.scaled(
                                  multiplier: AppTheme.m2xs,
                                  color: isActive
                                      ? AppColors.emerald
                                      : AppColors.onSurfaceVariant.withOpacity(
                                          0.4,
                                        ),
                                  weight: FontWeight.w900,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              if (data.assignedWorker != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.only(top: 16),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.white.withOpacity(0.05)),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          UserAvatar(
                            src: data.assignedWorker!.avatar,
                            size: AvatarSize.md,
                            isOnline: data.assignedWorker!.isOnline,
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ASSIGNED TO',
                                style: AppTheme.scaled(
                                  multiplier: AppTheme.m2xs,
                                  color: AppColors.onSurfaceVariant.withOpacity(
                                    0.6,
                                  ),
                                  weight: FontWeight.w900,
                                  letterSpacing: 2,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '@${data.assignedWorker!.handle}',
                                style: AppTheme.scaled(
                                  multiplier: AppTheme.mbase,
                                  color: AppColors.onSurface,
                                  weight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'AGREED PRICE',
                            style: AppTheme.scaled(
                              multiplier: AppTheme.m2xs,
                              color: AppColors.onSurfaceVariant.withOpacity(
                                0.6,
                              ),
                              weight: FontWeight.w900,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            data.acceptedBidAmount ?? data.price,
                            style: AppTheme.scaled(
                              multiplier: AppTheme.mxl,
                              color: AppColors.emerald,
                              weight: FontWeight.w900,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(BuildContext context) {
    final isLong = data.description.length > 500;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isLong && !_isDescExpanded
              ? '${data.description.substring(0, 500)}...'
              : data.description,
          style: AppTheme.scaled(
            multiplier: AppTheme.mbase,
            color: AppColors.onSurfaceVariant.withOpacity(0.9),
            height: 1.5,
          ),
        ),
        if (isLong)
          GestureDetector(
            onTap: () => setState(() => _isDescExpanded = !_isDescExpanded),
            child: Container(
              margin: EdgeInsets.only(top: _isDescExpanded ? 16 : 10),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.glassTint,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.glassBorder),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _isDescExpanded ? 'Show Less' : 'Show Full Description',
                    style: AppTheme.scaled(
                      multiplier: AppTheme.m2sm,
                      color: _isDescExpanded
                          ? AppColors.onSurfaceVariant
                          : AppColors.primary,
                      weight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    _isDescExpanded
                        ? PhosphorIconsRegular.caretUp
                        : PhosphorIconsRegular.caretDown,
                    size: 12,
                    color: _isDescExpanded
                        ? AppColors.onSurfaceVariant
                        : AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMediaModules(BuildContext context) {
    return Column(
      children: [
        if (data.mapUrl != null) ...[
          _buildMapPreview(context),
          if (data.images != null && data.images!.isNotEmpty ||
              data.video != null ||
              data.voiceNote != null)
            const SizedBox(height: 16),
        ],
        if (data.images != null && data.images!.isNotEmpty) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: MediaCarousel(images: data.images!, aspect: '16/9'),
          ),
          if (data.video != null || data.voiceNote != null)
            const SizedBox(height: 16),
        ],
        if (data.video != null) ...[
          _buildVideoModule(),
          if (data.voiceNote != null) const SizedBox(height: 16),
        ],
        if (data.voiceNote != null) _buildVoiceNoteModule(),
      ],
    );
  }

  Widget _buildVideoModule() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          color: Colors.black,
          height: 200,
          child: const Center(
            child: Icon(
              PhosphorIconsRegular.play,
              size: 48,
              color: Colors.white54,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVoiceNoteModule() {
    return VoiceNotePlayer(duration: data.voiceNote ?? '0:00');
  }

  Widget _buildMapPreview(BuildContext context) {
    return MapPreview(mapUrl: data.mapUrl!);
  }

  Widget _buildTags(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: data.tags!
          .map((tag) => TagPill.ghost(label: '#${tag.toUpperCase()}'))
          .toList(),
    );
  }

  Widget _buildMeta(BuildContext context) {
    return Center(
      child: Text(
        data.meta!,
        style: AppTheme.scaled(
          multiplier: AppTheme.m1sm,
          color: AppColors.onSurfaceVariant.withOpacity(0.6),
          weight: FontWeight.w700,
          letterSpacing: 2,
        ),
      ),
    );
  }

  Widget _buildPostActions(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0),
                Colors.white.withOpacity(0.08),
                Colors.white.withOpacity(0),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        PostActions(
          id: data.id,
          votes: data.votes,
          replies: data.replies,
          reposts: data.reposts,
          shares: data.shares,
        ),
      ],
    );
  }
}
