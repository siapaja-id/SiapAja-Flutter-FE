import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_router.dart';
import 'app_theme.dart';
import 'shared/zoom_wrapper.dart';
import 'shared/zoom_provider.dart';
import 'shared/settings_provider.dart';
import 'features/feed/pages/desktop_kanban_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();
  await container.read(settingsProvider.notifier).init();
  await container.read(zoomProvider.notifier).init();

  runApp(
    UncontrolledProviderScope(container: container, child: const SiapAjaApp()),
  );
}

class SiapAjaApp extends ConsumerWidget {
  const SiapAjaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return MaterialApp.router(
      title: 'SiapAja',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme(
        themeColor: settings.themeColor,
        textSize: settings.textSize,
      ),
      builder: (context, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final vw = constraints.maxWidth.isFinite && constraints.maxWidth > 0
                ? constraints.maxWidth
                : MediaQuery.sizeOf(context).width;
            final vh =
                constraints.maxHeight.isFinite && constraints.maxHeight > 0
                ? constraints.maxHeight
                : MediaQuery.sizeOf(context).height;

            if (constraints.maxWidth >= 768) {
              return ZoomWrapper(
                viewportWidth: vw,
                viewportHeight: vh,
                child: HeroControllerScope.none(child: DesktopKanbanLayout()),
              );
            }
            return ZoomWrapper(
              viewportWidth: vw,
              viewportHeight: vh,
              child: child!,
            );
          },
        );
      },
      routerConfig: AppRouter.router,
    );
  }
}
