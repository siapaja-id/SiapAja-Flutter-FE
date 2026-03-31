import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_router.dart';
import 'app_theme.dart';
import 'shared/zoom_wrapper.dart';
import 'features/feed/pages/desktop_kanban_layout.dart';

void main() {
  runApp(const ProviderScope(child: SiapAjaApp()));
}

class SiapAjaApp extends StatelessWidget {
  const SiapAjaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'SiapAja',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      builder: (context, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= 768) {
              return const ZoomWrapper(child: DesktopKanbanLayout());
            }
            return ZoomWrapper(child: child!);
          },
        );
      },
      routerConfig: AppRouter.router,
    );
  }
}
