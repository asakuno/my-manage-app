import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../pages/home_page.dart';
import '../pages/activity_page.dart';
import '../pages/friends_page.dart';
import '../pages/settings_page.dart';
import '../widgets/main_shell.dart';

part 'app_router.g.dart';

/// アプリケーションのルート定義
@riverpod
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: '/home',
    routes: [
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          // ホーム画面
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) => const HomePage(),
          ),

          // アクティビティ画面
          GoRoute(
            path: '/activity',
            name: 'activity',
            builder: (context, state) => const ActivityPage(),
          ),

          // 友達画面
          GoRoute(
            path: '/friends',
            name: 'friends',
            builder: (context, state) => const FriendsPage(),
          ),

          // 設定画面
          GoRoute(
            path: '/settings',
            name: 'settings',
            builder: (context, state) => const SettingsPage(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page not found: ${state.uri}'))),
  );
}
