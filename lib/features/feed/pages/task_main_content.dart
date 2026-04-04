import '../../../shared/utils/color_extensions.dart';
import '../../../shared/utils/decorations.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../app_theme.dart';
import '../../../models/feed_item.dart';
import '../../../shared/utils/task_icons.dart';
import '../../../shared/widgets/user_avatar.dart';
import '../../../shared/widgets/media_carousel.dart';
import '../../../shared/widgets/post_actions.dart';
import '../../../shared/widgets/tag_pill.dart';
import '../../../shared/widgets/voice_note_player.dart';
import '../../../shared/widgets/map_preview.dart';
import '../../../shared/widgets/glass_pill.dart';
import '../../../shared/widgets/section_label.dart';
import '../../../shared/widgets/gradient_divider.dart';
import '../widgets/base_feed_card.dart';
import '../widgets/trust_card.dart';
import '../widgets/status_tracker.dart';

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
          const GradientDivider(),
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
          TrustCard(rating: 4.9, reviewCount: 124, paymentVerified: true),
          const SizedBox(height: 24),
          StatusTracker(
            currentStatus: data.status,
            assignedWorker: data.assignedWorker,
            acceptedBidAmount: data.acceptedBidAmount,
            price: data.price,
          ),
          const SizedBox(height: 24),
          const SectionLabel(label: 'DESCRIPTION'),
          const SizedBox(height: 10),
          _buildDescription(context),
          if (data.mapUrl != null ||
              (data.images != null && data.images!.isNotEmpty) ||
              data.video != null ||
              data.voiceNote != null) ...[
            const SizedBox(height: 32),
            const SectionLabel(label: 'ATTACHMENTS'),
            const SizedBox(height: 10),
            _buildMediaModules(context),
          ],
          if (data.tags != null && data.tags!.isNotEmpty) ...[
            const SizedBox(height: 24),
            const SectionLabel(label: 'TAGS'),
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
                    color: Colors.white.w10,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.black40,
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
    return TagPill(label: getStatusText(status));
  }

  Widget _buildInfoPill(BuildContext context) {
    return GlassPill(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: AppColors.primary.p20,
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
            color: AppColors.onSurfaceVariant.withValues(alpha: 0.9),
            height: 1.5,
          ),
        ),
        if (isLong)
          GestureDetector(
            onTap: () => setState(() => _isDescExpanded = !_isDescExpanded),
            child: Container(
              margin: EdgeInsets.only(top: _isDescExpanded ? 16 : 10),
              child: GlassPill(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
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
          ),
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
      decoration: surfaceCardDecor(radius: 24, shadows: [shadowSm()]),
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
          color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
          weight: FontWeight.w700,
          letterSpacing: 2,
        ),
      ),
    );
  }

  Widget _buildPostActions(BuildContext context) {
    return Column(
      children: [
        const GradientDivider(),
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
