import 'package:flutter/material.dart';

import '../utils/color_extensions.dart';

/// Horizontal gradient divider line.
///
/// Fades from transparent → [color] (default `Colors.white.w08`) → transparent.
///
/// Replaces the repeated `Container(height: 1, decoration: BoxDecoration(
///   gradient: LinearGradient(colors: [transparent, white.w08, transparent])))`
/// pattern.
class GradientDivider extends StatelessWidget {
  final double height;
  final Color color;

  const GradientDivider({
    super.key,
    this.height = 1,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0),
            color.w08,
            color.withValues(alpha: 0),
          ],
        ),
      ),
    );
  }
}
