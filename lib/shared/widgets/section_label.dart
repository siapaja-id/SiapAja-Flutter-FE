import 'package:flutter/material.dart';

import '../../app_theme.dart';

/// Section heading label (e.g. "DESCRIPTION", "ATTACHMENTS", "TAGS").
///
/// Renders uppercase text in the standard section-label style:
/// `AppTheme.scaled(multiplier: m2xs, weight: w900, letterSpacing: 2.5)`.
///
/// Replaces the repeated `_buildSectionLabel("…")` helper methods found in
/// [TaskMainContent] and similar pages.
class SectionLabel extends StatelessWidget {
  final String label;
  final Color? color;

  const SectionLabel({super.key, required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTheme.scaled(
        multiplier: AppTheme.m2xs,
        color: color ?? AppColors.onSurfaceVariant.withOpacity(0.4),
        weight: FontWeight.w900,
        letterSpacing: 2.5,
      ),
    );
  }
}
