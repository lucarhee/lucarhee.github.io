import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/home_screen.dart';
import 'screens/blog_screen.dart';
import 'screens/post_screen.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) => child,
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => _fade(state, const HomeScreen()),
        ),
        GoRoute(
          path: '/blog',
          pageBuilder: (context, state) => _fade(state, const BlogScreen()),
        ),
        GoRoute(
          path: '/blog/:slug',
          pageBuilder: (context, state) {
            final slug = state.pathParameters['slug']!;
            return _fade(state, PostScreen(slug: slug));
          },
        ),
      ],
    ),
  ],
);

CustomTransitionPage<void> _fade(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
        child: child,
      );
    },
  );
}
