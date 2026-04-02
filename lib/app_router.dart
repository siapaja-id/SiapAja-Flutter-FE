import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'features/feed/pages/feed_page.dart';
import 'features/feed/pages/main_shell.dart';
import 'features/feed/pages/post_detail_page.dart';
import 'features/settings/pages/settings_page.dart';

/// GoRouter configuration
class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      // Shell route for persistent bottom navigation
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          // Home / Feed page
          GoRoute(path: '/', builder: (context, state) => const FeedPage()),
          GoRoute(path: '/feed', builder: (context, state) => const FeedPage()),
          // Explore page (stub)
          GoRoute(
            path: '/explore',
            builder: (context, state) =>
                const ScaffoldPageStub(title: 'Explore'),
          ),
          // Messages page (stub)
          GoRoute(
            path: '/messages',
            builder: (context, state) =>
                const ScaffoldPageStub(title: 'Messages'),
          ),
          // Orders page (stub)
          GoRoute(
            path: '/orders',
            builder: (context, state) =>
                const ScaffoldPageStub(title: 'Orders'),
          ),
        ],
      ),
      // Post detail page
      GoRoute(
        path: '/post/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return PostDetailPage(postId: id);
        },
      ),
      // Task detail page
      GoRoute(
        path: '/task/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return PostDetailPage(postId: id);
        },
      ),
      // Settings page
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsPage(),
      ),
    ],
  );
}

/// Simple scaffold page stub for unimplemented routes
class ScaffoldPageStub extends StatelessWidget {
  final String title;

  const ScaffoldPageStub({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: Center(
        child: Text(
          title,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: const Color(0xFFA1A1AA),
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}
