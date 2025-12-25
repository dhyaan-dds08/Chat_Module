import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/chat/bloc/chat_bloc.dart';
import '../../features/chat/bloc/chat_event.dart';
import '../../screens/chat_screen.dart';
import '../../screens/home_screen.dart';
import '../../screens/main_screen.dart';
import '../../screens/placeholder_screen.dart';
import '../services/message_service.dart';

class AppRouter {
  static final goRouter = GoRouter(
    initialLocation: '/home',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return MainScreen(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
            routes: [
              GoRoute(
                path: 'chat/:userId',
                builder: (context, state) {
                  final String userId = state.pathParameters['userId'] ?? '';
                  return BlocProvider(
                    create: (context) =>
                        ChatBloc(messageService: MessageService())
                          ..add(LoadChatMessages(userId)),
                    child: ChatScreen(userId: userId),
                  );
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
