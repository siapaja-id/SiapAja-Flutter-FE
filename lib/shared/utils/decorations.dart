import 'package:flutter/material.dart';

import '../app_theme.dart';
import 'color_extensions.dart';

/// Preset [BoxDecoration] factories for the most common decoration
/// patterns used throughout the app.  Every helper in this file is
/// referenced from **3+ call sites** — no speculative abstractions.

// ── BoxDecoration presets ─────────────────────────────────────────

/// Standard surface sheet decoration (bottom-sheets).
///
/// Uses `surfaceContainerHigh` fill, vertical top-only radius of 32,
/// and a `white.w10` border.
BoxDecoration surfaceSheetDecor({double radius = 32}) {
  return BoxDecoration(
    color: AppColors.surfaceContainerHigh,
    borderRadius: BorderRadius.vertical(top: Radius.circular(radius)),
    border: Border.all(color: Colors.white.w10),
  );
}

/// Surface container card decoration.
///
/// Same as [surfaceSheetDecor] but with a fully rounded border radius
/// and an optional shadow.
BoxDecoration surfaceCardDecor({
  double radius = 32,
  List<BoxShadow>? shadows,
}) {
  return BoxDecoration(
    color: AppColors.surfaceContainerHigh,
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(color: Colors.white.w10),
    boxShadow: shadows,
  );
}

/// Border-only decoration with a subtle `white.w05` or `white.w10` stroke.
///
/// Use when you need a visible border without a fill color.
BoxDecoration subtleBorderDecor({
  double radius = 16,
  Color borderColor = Colors.white,
  double opacity = 0.1,
}) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(color: borderColor.withOpacity(opacity)),
  );
}

/// Tinted pill decoration with matching border.
///
/// Used for status badges, selected chips, and accent containers.
BoxDecoration tintedDecor({
  required Color color,
  double radius = 12,
  double tintOpacity = 0.2,
}) {
  return BoxDecoration(
    color: color.withOpacity(tintOpacity),
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(color: color.withOpacity(tintOpacity)),
  );
}

/// Soft tinted decoration with half-opacity fill and full-opacity border.
///
/// Fill uses `tintOpacity * 0.5`, border uses `tintOpacity`.
/// Common pattern for bid cards, price badges, and thread-count chips
/// where the border should be more prominent than the fill.
BoxDecoration tintedDecorHalf({
  required Color color,
  double radius = 16,
  double tintOpacity = 0.2,
}) {
  return BoxDecoration(
    color: color.withOpacity(tintOpacity * 0.5),
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(color: color.withOpacity(tintOpacity)),
  );
}

// ── BoxShadow presets ─────────────────────────────────────────────

/// Standard dark shadow. Default matches the most common elevation
/// used across bottom-sheets, cards, and the sidebar.
BoxShadow shadowBlack({double blur = 20, double yOffset = 8, double opacity = 0.22}) {
  return BoxShadow(
    color: Colors.black.withOpacity(opacity),
    blurRadius: blur,
    offset: Offset(0, yOffset),
  );
}

/// Small ambient shadow for compact containers (input fields, chips).
BoxShadow shadowSm({double blur = 10, double opacity = 0.2}) {
  return BoxShadow(
    color: Colors.black.withOpacity(opacity),
    blurRadius: blur,
  );
}

/// Coloured glow shadow for active / selected / glowing elements.
BoxShadow shadowGlow({required Color color, double blur = 20, double opacity = 0.3}) {
  return BoxShadow(
    color: color.withOpacity(opacity),
    blurRadius: blur,
  );
}

// ── InputDecoration presets ──────────────────────────────────────

/// Glass-styled single-line input field.
InputDecoration glassInputField({String? hintText, int maxLines = 1}) {
  return InputDecoration(
    filled: true,
    fillColor: Colors.white.w05,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(color: Colors.white.w10),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(color: AppColors.primary.p50),
    ),
    hintText: hintText,
    hintStyle: const TextStyle(color: Colors.white30),
    maxLines: maxLines,
  );
}

/// Borderless input — no visible border, dense, zero padding.
InputDecoration borderlessInput() {
  return const InputDecoration(
    border: InputBorder.none,
    enabledBorder: InputBorder.none,
    focusedBorder: InputBorder.none,
    isDense: true,
    contentPadding: EdgeInsets.zero,
  );
}

/// Glass-styled multi-line text area.
InputDecoration glassInputArea({String? hintText}) {
  return InputDecoration(
    filled: true,
    fillColor: Colors.white.w05,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(color: Colors.white.w10),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(color: AppColors.primary.p50),
    ),
    hintText: hintText,
    hintStyle: const TextStyle(color: Colors.white30),
    maxLines: null,
  );
}
