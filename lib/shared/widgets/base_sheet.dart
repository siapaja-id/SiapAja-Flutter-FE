import 'package:flutter/material.dart' hide CloseButton;

import '../../app_theme.dart';
import '../utils/color_extensions.dart';
import '../utils/decorations.dart';
import 'close_button.dart';

/// Shared bottom-sheet scaffold used by all modal sheets in the app.
///
/// Provides the standard chrome — surface decoration, title row with close
/// button, and consistent padding — so that each sheet only needs to supply
/// its own body content.
///
/// Usage:
/// ```dart
/// BaseSheet.show(
///   context: context,
///   title: 'Submit Your Bid',
///   builder: (_) => BidContent(...),
/// );
/// ```
class BaseSheet extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback? onClose;

  const BaseSheet({
    super.key,
    required this.title,
    required this.child,
    this.onClose,
  });

  /// Convenience method for `showModalBottomSheet` with the standard
  /// sheet configuration (transparent background, scroll-controlled).
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required WidgetBuilder builder,
    VoidCallback? onClose,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      builder: (context) => BaseSheet(
        title: title,
        onClose: onClose ?? () => Navigator.pop(context),
        child: builder(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 48),
      decoration: surfaceSheetDecor(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Title row ──────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTheme.largeTitle,
              ),
              CloseButton(
                onTap: onClose ?? () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // ── Sheet body ────────────────────────────────────────
          child,
        ],
      ),
    );
  }
}
