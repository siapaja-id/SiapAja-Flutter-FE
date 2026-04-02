import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'zoom_provider.dart';

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
        final viewportWidth = constraints.maxWidth;
        final viewportHeight = constraints.maxHeight;

        final childWidth = viewportWidth / zoom;
        final childHeight = viewportHeight / zoom;

        return Focus(
          autofocus: true,
          onKeyEvent: (FocusNode node, KeyEvent event) {
            if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
              return KeyEventResult.ignored;
            }

            final isCtrlPressed = HardwareKeyboard.instance.isControlPressed;
            if (!isCtrlPressed) {
              return KeyEventResult.ignored;
            }

            if (event.logicalKey == LogicalKeyboardKey.equal) {
              zoomNotifier.zoomIn();
              return KeyEventResult.handled;
            }
            if (event.logicalKey == LogicalKeyboardKey.minus) {
              zoomNotifier.zoomOut();
              return KeyEventResult.handled;
            }
            if (event.logicalKey == LogicalKeyboardKey.digit0) {
              zoomNotifier.reset();
              return KeyEventResult.handled;
            }

            return KeyEventResult.ignored;
          },
          child: Listener(
            onPointerSignal: (event) {
              if (event is PointerScrollEvent) {
                final isCtrlPressed =
                    HardwareKeyboard.instance.isControlPressed;
                if (isCtrlPressed) {
                  if (event.scrollDelta.dy < 0) {
                    zoomNotifier.zoomIn();
                  } else if (event.scrollDelta.dy > 0) {
                    zoomNotifier.zoomOut();
                  }
                }
              }
            },
            child: FittedBox(
              fit: BoxFit.contain,
              child: SizedBox(
                width: childWidth,
                height: childHeight,
                child: MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    size: Size(childWidth, childHeight),
                    textScaler: const TextScaler.linear(1.0),
                  ),
                  child: widget.child,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
