import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'features/feed/pages/feed_page.dart';
import 'features/feed/pages/main_shell.dart';

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
      // Post detail page (stub)
      GoRoute(
        path: '/post/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return ScaffoldPageStub(title: 'Post #$id');
        },
      ),
      // Task detail page (stub)
      GoRoute(
        path: '/task/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return ScaffoldPageStub(title: 'Task #$id');
        },
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
          style: const TextStyle(
            color: Color(0xFFA1A1AA),
            fontSize: 14,
            fontWeight: FontWeight.w800,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}
