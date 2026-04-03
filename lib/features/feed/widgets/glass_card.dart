import '../../../shared/utils/color_extensions.dart';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../app_theme.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final bool showGlow;
  final double blurSigma;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;
  final Color? tint;
  final BorderRadius? customBorderRadius;

  const GlassCard({
    super.key,
    required this.child,
    this.borderRadius = 16,
    this.padding,
    this.showGlow = true,
    this.blurSigma = 12,
    this.border,
    this.boxShadow,
    this.tint,
    this.customBorderRadius,
  });

  /// Horizontal bar variant — no border-radius, no padding, no glow,
  /// no border, no shadow.
  /// Ideal for nav bars, headers, and toolbars.
  const GlassCard.bar({
    super.key,
    required this.child,
    this.blurSigma = 12,
  }) : borderRadius = 0,
       padding = EdgeInsets.zero,
       showGlow = false,
       border = Border.none,
       boxShadow = const [],
       tint = null,
       customBorderRadius = null;

  /// Full-width panel variant — no glow. Border-radius, padding,
  /// border, shadow, and tint are all configurable.
  /// Ideal for sidebars and full-bleed panels.
  const GlassCard.slab({
    super.key,
    required this.child,
    this.borderRadius = 0,
    this.padding,
    this.blurSigma = 12,
    this.border,
    this.boxShadow,
    this.tint,
  }) : showGlow = false,
       customBorderRadius = null;

  @override
  Widget build(BuildContext context) {
    final effectiveRadius =
        customBorderRadius ?? BorderRadius.circular(borderRadius);
    final content = Container(
      padding: padding ?? const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: tint ?? AppColors.glassTint,
        borderRadius: effectiveRadius,
        border: border ?? Border.all(color: AppColors.glassBorder),
        boxShadow: boxShadow ?? [
          BoxShadow(
            color: Colors.black.black25,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );

    return ClipRRect(
      borderRadius: effectiveRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: showGlow
            ? _wrapWithGlow(content)
            : content,
      ),
    );
  }

  Widget _wrapWithGlow(Widget child) {
    return Stack(
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
        child,
      ],
    );
  }
}
