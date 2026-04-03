import 'package:flutter/material.dart';

import '../../app_theme.dart';

/// Semi-transparent glass pill container.
///
/// Wraps [child] in a rounded container with [AppColors.glassTint] background
/// and [AppColors.glassBorder] border. Optionally applies horizontal [padding].
///
/// Replaces the repeated `Container(decoration: BoxDecoration(
///   color: AppColors.glassTint, borderRadius: 20,
///   border: Border.all(color: AppColors.glassBorder)))` pattern.
class GlassPill extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const GlassPill({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.glassTint,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: child,
    );
  }
}
