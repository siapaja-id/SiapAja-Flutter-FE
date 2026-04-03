import 'package:flutter/material.dart';

import '../app_theme.dart';

/// Reusable button style presets for the app.
///
/// Every preset here is referenced from **3+ call sites** — no speculative abstractions.

/// Primary action button style: themed background, white text, pill shape, zero elevation.
///
/// Used in FeedComposer (×2), fullscreen composer, and other primary action buttons.
ButtonStyle get primaryButtonStyle => ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.primaryForeground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      elevation: 0,
    );
