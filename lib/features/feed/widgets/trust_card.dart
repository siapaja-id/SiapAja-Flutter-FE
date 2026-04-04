import '../../../shared/utils/color_extensions.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../app_theme.dart';

class TrustCard extends StatelessWidget {
  final double rating;
  final int reviewCount;
  final bool paymentVerified;

  const TrustCard({
    super.key,
    required this.rating,
    required this.reviewCount,
    required this.paymentVerified,
  });

  @override
  Widget build(BuildContext context) {
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
                color: Colors.black.black25,
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
                        AppColors.glassGlow.withValues(alpha: 0),
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
                        AppColors.emerald.e10,
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
                        AppColors.emerald.withValues(alpha: 0),
                        AppColors.emerald.e15,
                        AppColors.emerald.withValues(alpha: 0),
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
                              rating.toStringAsFixed(1),
                              style: AppTheme.scaled(
                                multiplier: AppTheme.mxl,
                                color: AppColors.onSurface,
                                weight: FontWeight.w900,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '($reviewCount)',
                              style: AppTheme.scaled(
                                multiplier: AppTheme.m1sm,
                                color: AppColors.onSurfaceVariant.withValues(alpha: 
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
                    color: Colors.white.w10,
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
                            color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
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
                              paymentVerified ? 'Verified' : 'Unverified',
                              style: AppTheme.scaled(
                                multiplier: AppTheme.mbase,
                                color: paymentVerified
                                    ? AppColors.emerald
                                    : AppColors.onSurfaceVariant,
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
}
