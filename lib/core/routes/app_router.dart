import 'package:chat_module/screens/main_screen.dart';
import 'package:chat_module/screens/placeholder_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../screens/home_screen.dart';

class AppRouter {
  static final goRouter = GoRouter(
    initialLocation: '/home',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return MainScreen(child: child); // MainScreen has bottom nav
        },
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
            routes: [
              // Nested route - keeps bottom nav visible
              GoRoute(
                path: 'chat/:userId',
                builder: (context, state) {
                  final userId = state.pathParameters['userId']!;
                  return PlaceholderScreen(tabName: 'Chat');
                },
              ),
            ],
          ),
          GoRoute(
            path: '/offers',
            builder: (context, state) => PlaceholderScreen(tabName: 'Offers'),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => PlaceholderScreen(tabName: 'Settings'),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text('Page not found'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}
