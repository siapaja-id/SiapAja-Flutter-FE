import 'package:flutter/material.dart';

import '../utils/color_extensions.dart';
import '../../app_theme.dart';

class TagPill extends StatelessWidget {
  final String label;
  final Color color;
  final double borderRadius;
  final double fontSize;
  final EdgeInsetsGeometry? padding;

  const TagPill({
    super.key,
    required this.label,
    this.color = AppColors.primary,
    this.borderRadius = 4,
    this.fontSize = 10,
    this.padding,
  });

  const TagPill.ghost({
    super.key,
    required this.label,
    this.borderRadius = 20,
    this.fontSize = 10,
    this.padding,
  }) : color = Colors.transparent;

  Color get _borderColor => color == Colors.transparent
      ? Colors.white.w10
      : color.withValues(alpha: 0.2);

  Color get _textColor =>
      color == Colors.transparent ? AppColors.onSurfaceVariant : color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color == Colors.transparent
            ? Colors.white.w05
            : color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: _borderColor),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: _textColor,
          fontSize: fontSize,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}
