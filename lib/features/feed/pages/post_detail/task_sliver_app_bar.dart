import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../app_theme.dart';
import '../../../../models/feed_item.dart';
import '../../../../shared/utils/task_icons.dart';
import '../../../../shared/widgets/tag_pill.dart';
import '../../../../shared/widgets/view_stats_badge.dart';

class TaskSliverAppBar extends StatelessWidget {
  final TaskData task;
  final VoidCallback onBack;
  final int viewCount;
  final int viewingNow;

  const TaskSliverAppBar({
    super.key,
    required this.task,
    required this.onBack,
    required this.viewCount,
    required this.viewingNow,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: false,
      expandedHeight: 200,
      backgroundColor: AppColors.surfaceContainerHigh,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsetsDirectional.only(start: 56, bottom: 14),
        title: Row(
          children: [
            Flexible(
              child: Text(
                task.title,
                style: AppTheme.scaled(multiplier: AppTheme.m2xs,
                  weight: FontWeight.w900,
                  color: AppColors.onSurfaceVariant,
                  letterSpacing: 1.5,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            TagPill(
              label: task.category.toUpperCase(),
              fontSize: 9,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            ),
          ],
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.emerald.withOpacity(0.12),
                    AppColors.primary.withOpacity(0.08),
                    AppColors.indigo.withOpacity(0.04),
                    AppColors.surfaceContainerHigh,
                  ],
                  stops: const [0.0, 0.35, 0.65, 1.0],
                ),
              ),
            ),
            Positioned(
              top: -20,
              right: -20,
              child: Icon(
                getIconForTaskType(task.iconType),
                size: 160,
                color: Colors.white.withOpacity(0.03),
              ),
            ),
            Positioned(
              bottom: 56,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: AppTheme.scaled(multiplier: AppTheme.m15,
                      weight: FontWeight.w700,
                      color: AppColors.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.glassTint,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.glassBorder),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              getIconForTaskType(task.iconType),
                              size: 12,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              task.category.toUpperCase(),
                              style: AppTheme.scaled(multiplier: AppTheme.m2xl,
                                weight: FontWeight.w900,
                                color: AppColors.onSurface,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        task.price,
                        style: AppTheme.scaled(multiplier: AppTheme.m2xl,
                          weight: FontWeight.w900,
                          color: AppColors.onSurface,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        collapseMode: CollapseMode.pin,
      ),
      leading: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.glassTint,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.glassBorder),
              ),
              child: IconButton(
                onPressed: onBack,
                padding: EdgeInsets.zero,
                icon: const Icon(
                  PhosphorIconsRegular.arrowLeft,
                  size: 20,
                  color: AppColors.onSurface,
                ),
              ),
            ),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ViewStatsBadge(viewCount: viewCount, viewingNow: viewingNow),
        ),
      ],
    );
  }
}
