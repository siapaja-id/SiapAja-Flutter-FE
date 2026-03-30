import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../app_theme.dart';
import '../../../models/feed_item.dart';
import '../../../shared/widgets/user_avatar.dart';
import '../../../shared/widgets/expandable_text.dart';
import '../../../shared/widgets/media_carousel.dart';
import '../../../shared/widgets/post_actions.dart';

/// Full task detail view — matches React TaskMainContent.Component.tsx exactly.
class TaskMainContent extends StatelessWidget {
  final TaskData data;

  const TaskMainContent({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Depth background gradient (matches React: from-primary/10 via-background to-transparent)
        _buildBackgroundGradient(),
        // Content above gradient
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 24),
              
              if (data.isFirstTask == true) ...[_buildFirstTaskBadge(), const SizedBox(height: 16)],
              _buildInfoPill(context),
              const SizedBox(height: 20),
              _buildTitle(context),
              const SizedBox(height: 24),
              _buildTrustCard(context),
              const SizedBox(height: 24),
              _buildStatusTracker(context),
              const SizedBox(height: 24),
              _buildDescription(context),
              if (data.mapUrl != null || (data.images != null && data.images!.isNotEmpty)) ...[
                const SizedBox(height: 32),
                _buildMediaModules(context),
              ],
              if (data.tags != null && data.tags!.isNotEmpty) ...[
                const SizedBox(height: 24),
                _buildTags(context),
              ],
              if (data.meta != null) ...[
                const SizedBox(height: 16),
                _buildMeta(context),
              ],
              const SizedBox(height: 16),
              _buildPostActions(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBackgroundGradient() {
    // React: absolute top-0 inset-x-0 h-64 bg-[radial-gradient(...)] from-primary/10 via-background to-transparent
    return Container(
      height: 256,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topCenter,
          radius: 1.5,
          colors: [
            AppColors.primary.withOpacity(0.1),
            AppColors.background,
            Colors.transparent,
          ],
          stops: const [0.0, 0.6, 1.0],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    // React: flex items-center justify-between mb-6
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Left: avatar + name + handle
        Row(
          children: [
            UserAvatar(
              src: data.author.avatar,
              size: AvatarSize.xl,
              isOnline: data.author.isOnline,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      data.author.name,
                      style: const TextStyle(
                        color: AppColors.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
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
                  style: const TextStyle(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        // Right: price + status tag
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // React: text-3xl font-black tracking-tighter (white, NOT red)
            Text(
              data.price,
              style: const TextStyle(
                color: AppColors.onSurface,
                fontSize: 28,
                fontWeight: FontWeight.w900,
                letterSpacing: -1,
              ),
            ),
            // Status TagBadge below price
            if (data.status != TaskStatus.open) ...[
              const SizedBox(height: 4),
              _buildStatusTag(data.status),
            ],
          ],
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

    // React: TagBadge variant="primary" className="mt-1 shadow-sm px-2 py-0.5 text-[10px]"
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 2),
        ],
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildFirstPostBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.emerald,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.emerald.withOpacity(0.5),
            blurRadius: 15,
          ),
        ],
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 6,
            height: 6,
            child: DecoratedBox(
              decoration: BoxDecoration(color: Colors.black, shape: BoxShape.circle),
            ),
          ),
          SizedBox(width: 6),
          Text(
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

  Widget _buildFirstTaskBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.5),
            blurRadius: 15,
          ),
        ],
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 6,
            height: 6,
            child: DecoratedBox(
              decoration: BoxDecoration(color: AppColors.primaryForeground, shape: BoxShape.circle),
            ),
          ),
          SizedBox(width: 6),
          Text(
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

  Widget _buildInfoPill(BuildContext context) {
    // React: inline-flex items-center gap-2 px-3 py-1.5 rounded-full glass
    // icon in w-5 h-5 rounded-full bg-primary/20, dot separator, Clock icon
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
      decoration: BoxDecoration(
        color: AppColors.glassTint,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon in circle
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                _getIconForTaskType(data.iconType),
                size: 12,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Category
          Text(
            data.category.toUpperCase(),
            style: const TextStyle(
              color: AppColors.onSurfaceVariant,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
          // Dot separator
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: SizedBox(
              width: 4,
              height: 4,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
              ),
            ),
          ),
          // Timestamp with clock icon
          const Icon(PhosphorIconsRegular.clock, size: 12, color: AppColors.onSurfaceVariant),
          const SizedBox(width: 4),
          Text(
            data.timestamp,
            style: const TextStyle(
              color: AppColors.onSurfaceVariant,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    // React: h2 text-[26px] font-black leading-[1.15] tracking-tight mb-6
    return Text(
      data.title,
      style: const TextStyle(
        color: AppColors.onSurface,
        fontSize: 26,
        fontWeight: FontWeight.w900,
        height: 1.15,
        letterSpacing: -0.5,
      ),
    );
  }

  Widget _buildTrustCard(BuildContext context) {
    // React: rounded-[24px] p-5 glass shadow-xl, emerald radial gradient in corner
    // Single star icon + "4.9" + "(124)", separator line, ShieldCheck + "Verified"
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
              // Top glow line
              Positioned(
                left: 0, right: 0, top: 0, height: 1,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.glassGlow, AppColors.glassGlow.withOpacity(0)],
                    ),
                  ),
                ),
              ),
              // Emerald radial gradient in corner
              Positioned(
                top: -40, right: -40,
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
              // Content
              Row(
                children: [
                  // Rating
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'REQUESTER RATING',
                          style: TextStyle(
                            color: AppColors.onSurfaceVariant,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
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
                            const Text(
                              '4.9',
                              style: TextStyle(
                                color: AppColors.onSurface,
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '(124)',
                              style: TextStyle(
                                color: AppColors.onSurfaceVariant.withOpacity(0.6),
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Separator line
                  Container(
                    width: 1,
                    height: 40,
                    color: Colors.white.withOpacity(0.1),
                  ),
                  const SizedBox(width: 16),
                  // Payment
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PAYMENT',
                          style: TextStyle(
                            color: AppColors.onSurfaceVariant.withOpacity(0.6),
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Row(
                          children: [
                            Icon(
                              PhosphorIconsRegular.shieldCheck,
                              size: 18,
                              color: AppColors.emerald,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Verified',
                              style: TextStyle(
                                color: AppColors.emerald,
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
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
    // React: rounded-2xl p-5 bg-surface-container border border-white/5 shadow-lg
    // Dots: w-3.5 h-3.5 (14px), border-[2.5px]
    // Labels: absolute -bottom-5, text-[9px] font-black uppercase tracking-widest
    // Assigned worker inside this container, separated by border-t
    const statuses = ['Open', 'Assigned', 'In Progress', 'Reviewing', 'Finished'];
    final currentIndex = data.status.index;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Emerald radial gradient in corner
          Positioned(
            top: -40, right: -40,
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
              // Progress dots with track
              SizedBox(
                height: 40,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Background track line
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
                    // Progress fill line
                    Positioned(
                      top: 7,
                      left: 7,
                      child: FractionallySizedBox(
                        widthFactor: currentIndex / (statuses.length - 1),
                        child: Container(
                          height: 3,
                          decoration: BoxDecoration(
                            color: AppColors.emerald,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                    // Dots + labels
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: statuses.asMap().entries.map((entry) {
                        final i = entry.key;
                        final label = entry.value;
                        final isActive = i <= currentIndex;
                        return SizedBox(
                          width: 48,
                          child: Column(
                            children: [
                              // Dot
                              Container(
                                width: 14,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: isActive ? AppColors.emerald : AppColors.surfaceContainer,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isActive ? AppColors.emerald : Colors.white.withOpacity(0.2),
                                    width: 2.5,
                                  ),
                                  boxShadow: isActive
                                      ? [BoxShadow(color: AppColors.emerald.withOpacity(0.5), blurRadius: 15)]
                                      : null,
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Label
                              Text(
                                label,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: isActive
                                      ? AppColors.emerald
                                      : AppColors.onSurfaceVariant.withOpacity(0.4),
                                  fontSize: 9,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              // Assigned worker (inside tracker, separated by border-t)
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
                                style: TextStyle(
                                  color: AppColors.onSurfaceVariant.withOpacity(0.6),
                                  fontSize: 9,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 2,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '@${data.assignedWorker!.handle}',
                                style: const TextStyle(
                                  color: AppColors.onSurface,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
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
                            style: TextStyle(
                              color: AppColors.onSurfaceVariant.withOpacity(0.6),
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            data.acceptedBidAmount ?? data.price,
                            style: const TextStyle(
                              color: AppColors.emerald,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
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
    // React: prose prose-invert prose-sm with Markdown, expand button text-[10px] uppercase tracking-[0.2em]
    return ExpandableText(
      text: data.description,
      limit: 500,
      style: const TextStyle(
        color: AppColors.onSurface,
        fontSize: 14,
        height: 1.7,
      ),
      buttonStyle: const TextStyle(
        color: AppColors.primary,
        fontSize: 10,
        fontWeight: FontWeight.w900,
        letterSpacing: 2,
      ),
    );
  }

  Widget _buildMediaModules(BuildContext context) {
    return Column(
      children: [
        // Map preview
        if (data.mapUrl != null) ...[
          _buildMapPreview(context),
          if (data.images != null && data.images!.isNotEmpty) const SizedBox(height: 16),
        ],
        // Image carousel
        if (data.images != null && data.images!.isNotEmpty)
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: MediaCarousel(images: data.images!, aspect: '16/9'),
          ),
      ],
    );
  }

  Widget _buildMapPreview(BuildContext context) {
    // React: rounded-[24px], route details with pickup/dropoff, "Navigate via Google Maps" button, "OSRM Routed" badge
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
        child: Column(
          children: [
            // Map image
            SizedBox(
              height: 160,
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
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.transparent,
                          AppColors.surfaceContainerHigh.withOpacity(1),
                        ],
                      ),
                    ),
                  ),
                  // OSRM Routed badge
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.1)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 8,
                            height: 8,
                            child: DecoratedBox(
                              decoration: BoxDecoration(color: AppColors.emerald, shape: BoxShape.circle),
                            ),
                          ),
                          SizedBox(width: 6),
                          Text(
                            'OSRM ROUTED',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Route details
            Container(
              padding: const EdgeInsets.all(20),
              color: AppColors.surfaceContainerHigh,
              child: Column(
                children: [
                  Row(
                    children: [
                      // Pickup/dropoff indicators
                      Column(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.primary, width: 2),
                              color: AppColors.background,
                            ),
                          ),
                          Container(width: 2, height: 32, color: Colors.white.withOpacity(0.1)),
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.emerald,
                              boxShadow: [
                                BoxShadow(color: AppColors.emerald.withOpacity(0.5), blurRadius: 10),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          children: [
                            _buildRoutePoint('PICKUP POINT', 'Downtown Hub (37.7749 N, 122.4194 W)'),
                            const SizedBox(height: 12),
                            _buildRoutePoint('DROPOFF POINT', 'Midtown Square (37.7833 N, 122.4167 W)'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Navigate button
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(PhosphorIconsRegular.navigationArrow, size: 16, color: AppColors.primary),
                        SizedBox(width: 8),
                        Text(
                          'Navigate via Google Maps',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(PhosphorIconsRegular.arrowSquareOut, size: 14, color: AppColors.primary),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoutePoint(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.onSurfaceVariant.withOpacity(0.7),
            fontSize: 9,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.onSurface,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildTags(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: data.tags!.map((tag) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Text(
            tag.toUpperCase(),
            style: const TextStyle(
              color: AppColors.onSurfaceVariant,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMeta(BuildContext context) {
    return Center(
      child: Text(
        data.meta!,
        style: TextStyle(
          color: AppColors.onSurfaceVariant.withOpacity(0.6),
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 2,
        ),
      ),
    );
  }

  Widget _buildPostActions(BuildContext context) {
    // React: pt-4 border-t border-white/5
    return Container(
      padding: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.05)),
        ),
      ),
      child: PostActions(
        id: data.id,
        votes: data.votes,
        replies: data.replies,
        reposts: data.reposts,
        shares: data.shares,
      ),
    );
  }

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
}
