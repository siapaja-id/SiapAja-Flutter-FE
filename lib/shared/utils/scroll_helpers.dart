import 'package:flutter/widgets.dart';

void scrollToBottom(ScrollController controller, {int extraPixels = 100}) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (controller.hasClients) {
      controller.animateTo(
        controller.position.maxScrollExtent + extraPixels,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    }
  });
}
