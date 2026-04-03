import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../app_theme.dart';
import '../widgets/pulsing_dot.dart';

class MapPreview extends StatelessWidget {
  final String mapUrl;

  const MapPreview({super.key, required this.mapUrl});

  @override
  Widget build(BuildContext context) {
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
            SizedBox(
              height: 160,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: mapUrl,
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
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const PulsingDot(color: AppColors.emerald, size: 8),
                          const SizedBox(width: 6),
                          Text(
                            'OSRM ROUTED',
                            style: AppTheme.scaled(
                              multiplier: AppTheme.m2xs,
                              color: Colors.white,
                              weight: FontWeight.w900,
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
            Container(
              padding: const EdgeInsets.all(20),
              color: AppColors.surfaceContainerHigh,
              child: Column(
                children: [
                  Row(
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.primary,
                                width: 2,
                              ),
                              color: AppColors.background,
                            ),
                          ),
                          Container(
                            width: 2,
                            height: 32,
                            color: Colors.white.withOpacity(0.1),
                          ),
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.emerald,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.emerald.withOpacity(0.5),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          children: [
                            _RoutePoint(
                              label: 'PICKUP POINT',
                              value: 'Downtown Hub (37.7749 N, 122.4194 W)',
                            ),
                            const SizedBox(height: 12),
                            _RoutePoint(
                              label: 'DROPOFF POINT',
                              value: 'Midtown Square (37.7833 N, 122.4167 W)',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          PhosphorIconsRegular.navigationArrow,
                          size: 16,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Navigate via Google Maps',
                          style: AppTheme.scaled(
                            multiplier: AppTheme.mbase,
                            color: AppColors.primary,
                            weight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          PhosphorIconsRegular.arrowSquareOut,
                          size: 14,
                          color: AppColors.primary,
                        ),
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
}

class _RoutePoint extends StatelessWidget {
  final String label;
  final String value;

  const _RoutePoint({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.scaled(
            multiplier: AppTheme.m2xs,
            color: AppColors.onSurfaceVariant.withOpacity(0.7),
            weight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTheme.scaled(
            multiplier: AppTheme.m13,
            color: AppColors.onSurface,
            weight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
