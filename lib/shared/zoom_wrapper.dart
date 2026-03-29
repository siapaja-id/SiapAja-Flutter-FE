import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'zoom_provider.dart';

/// Wrapper widget that provides browser-like zoom functionality.
/// 
/// Features:
/// - Ctrl+Plus/Ctrl+Equal: Zoom in
/// - Ctrl+Minus: Zoom out
/// - Ctrl+0: Reset zoom
/// - Ctrl+MouseWheel: Zoom in/out with scroll wheel
/// 
/// Uses FittedBox + Transform.scale for uniform scaling of all UI elements,
/// and overrides MediaQuery to provide zoom-adjusted screen dimensions.
class ZoomWrapper extends ConsumerStatefulWidget {
  final Widget child;

  const ZoomWrapper({super.key, required this.child});

  @override
  ConsumerState<ZoomWrapper> createState() => _ZoomWrapperState();
}

class _ZoomWrapperState extends ConsumerState<ZoomWrapper> {
  @override
  Widget build(BuildContext context) {
    final zoom = ref.watch(zoomProvider);
    final zoomNotifier = ref.read(zoomProvider.notifier);

    return LayoutBuilder(
      builder: (context, constraints) {
        final originalWidth = constraints.maxWidth;
        final originalHeight = constraints.maxHeight;

        // Calculate the scaled child size
        final childWidth = originalWidth / zoom;
        final childHeight = originalHeight / zoom;

        return Focus(
          autofocus: true,
          onKeyEvent: (FocusNode node, KeyEvent event) {
            // Only handle key down events
            if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
              return KeyEventResult.ignored;
            }

            // Check if Ctrl is pressed
            final isCtrlPressed = HardwareKeyboard.instance.isControlPressed;

            if (!isCtrlPressed) {
              return KeyEventResult.ignored;
            }

            // Handle Ctrl+Plus (Equal) for zoom in
            if (event.logicalKey == LogicalKeyboardKey.equal) {
              zoomNotifier.zoomIn();
              return KeyEventResult.handled;
            }

            // Handle Ctrl+Minus for zoom out
            if (event.logicalKey == LogicalKeyboardKey.minus) {
              zoomNotifier.zoomOut();
              return KeyEventResult.handled;
            }

            // Handle Ctrl+0 for reset
            if (event.logicalKey == LogicalKeyboardKey.digit0) {
              zoomNotifier.reset();
              return KeyEventResult.handled;
            }

            return KeyEventResult.ignored;
          },
          child: GestureDetector(
            onPanUpdate: (event) {
              // Handle Ctrl+drag for zoom (alternative to scroll wheel)
              final isCtrlPressed = HardwareKeyboard.instance.isControlPressed;
              if (isCtrlPressed) {
                if (event.delta.dy < 0) {
                  zoomNotifier.zoomIn();
                } else if (event.delta.dy > 0) {
                  zoomNotifier.zoomOut();
                }
              }
            },
            child: FittedBox(
              fit: BoxFit.fill,
              child: SizedBox(
                width: childWidth,
                height: childHeight,
                child: Transform.scale(
                  scale: zoom,
                  child: MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                      size: Size(childWidth, childHeight),
                      // Clamp text scaler to prevent excessive text scaling
                      textScaler: MediaQuery.of(context).textScaler.clamp(
                        minScaleFactor: 0.8,
                        maxScaleFactor: 2.0,
                      ),
                    ),
                    child: widget.child,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
