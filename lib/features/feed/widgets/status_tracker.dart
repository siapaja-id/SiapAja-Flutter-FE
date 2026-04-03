import '../../../shared/utils/color_extensions.dart';
import '../../../shared/utils/decorations.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../app_theme.dart';
import '../../../models/feed_item.dart';
import '../../../models/author.dart';
import '../../../shared/widgets/user_avatar.dart';
import '../../../shared/widgets/pulsing_dot.dart';

class StatusTracker extends StatelessWidget {
  final TaskStatus currentStatus;
  final Author? assignedWorker;
  final String? acceptedBidAmount;
  final String price;

  const StatusTracker({
    super.key,
    required this.currentStatus,
    required this.assignedWorker,
    this.acceptedBidAmount,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    const statuses = [
      'Open',
      'Assigned',
      'In Progress',
      'Reviewing',
      'Finished',
    ];
    final currentIndex = currentStatus.index;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.w05),
        boxShadow: [
          shadowSm(),
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
                    AppColors.emerald.e05,
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
                          color: Colors.white.w10,
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
                                    shadowGlow(color: AppColors.emerald),
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
                                        : Colors.white.w20,
                                    width: 2.5,
                                  ),
                                  boxShadow: isActive
                                      ? [
                                          shadowGlow(color: AppColors.emerald),
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
              if (assignedWorker != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.only(top: 16),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.white.w05),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          UserAvatar(
                            src: assignedWorker!.avatar,
                            size: AvatarSize.md,
                            isOnline: assignedWorker!.isOnline,
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
                                '@${assignedWorker!.handle}',
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
                            acceptedBidAmount ?? price,
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
}
