import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_router.dart';
import 'app_theme.dart';
import 'shared/zoom_wrapper.dart';
import 'shared/zoom_provider.dart';
import 'shared/settings_provider.dart';
import 'features/feed/pages/desktop_kanban_layout.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ProviderScope(
      child: Builder(
        builder: (context) {
          final container = ProviderScope.containerOf(context);
          // Lazy init — don't block runApp
          container.read(settingsProvider.notifier).init();
          container.read(zoomProvider.notifier).init();
          return const SiapAjaApp();
        },
      ),
    ),
  );
}

class SiapAjaApp extends ConsumerWidget {
  const SiapAjaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final scaleFactor = AppTheme.textScaleFactor(settings.textSize);

    return MaterialApp.router(
      title: 'SiapAja',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme(themeColor: settings.themeColor),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(scaleFactor)),
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth >= 768) {
                return const ZoomWrapper(
                  child: HeroControllerScope.none(child: DesktopKanbanLayout()),
                );
              }
              return ZoomWrapper(child: child!);
            },
          ),
        );
      },
      routerConfig: AppRouter.router,
    );
  }
}
