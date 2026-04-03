import 'package:flutter/widgets.dart';

import '../../app_theme.dart';

void scrollToBottom(ScrollController controller, {int extraPixels = 100}) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (controller.hasClients) {
      controller.animateTo(
        controller.position.maxScrollExtent + extraPixels,
        duration: AppTheme.animSlide,
        curve: AppTheme.curveOut,
      );
    }
  });
}
