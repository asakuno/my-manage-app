import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../pages/home_page.dart';
import '../pages/activity_page.dart';
import '../pages/friends_page.dart';
import '../pages/settings_page.dart';
import '../widgets/main_shell.dart';
import '../provider/subscription_provider.dart';
import '../provider/ui_state_provider.dart';

part 'app_router.g.dart';

/// アプリケーションのルート定義
@riverpod
GoRouter appRouter(AppRouterRef ref) {
  return GoRouter(
    initialLocation: '/home',
    debugLogDiagnostics: true,
    routes: [
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          // ホーム画面
          GoRoute(
            path: '/home',
            name: AppRoutes.home,
            builder: (context, state) => const HomePage(),
            routes: [
              // 特定日の詳細画面
              GoRoute(
                path: '/day/:date',
                name: AppRoutes.dayDetail,
                builder: (context, state) {
                  final dateStr = state.pathParameters['date']!;
                  final date = DateTime.parse(dateStr);
                  return DayDetailPage(date: date);
                },
              ),
            ],
          ),

          // アクティビティ画面
          GoRoute(
            path: '/activity',
            name: AppRoutes.activity,
            builder: (context, state) => const ActivityPage(),
            routes: [
              // 統計詳細画面
              GoRoute(
                path: '/statistics',
                name: AppRoutes.statistics,
                builder: (context, state) {
                  final period =
                      state.uri.queryParameters['period'] ?? 'weekly';
                  return StatisticsPage(period: period);
                },
              ),
              // データエクスポート画面（プレミアム機能）
              GoRoute(
                path: '/export',
                name: AppRoutes.dataExport,
                builder: (context, state) => const DataExportPage(),
                redirect: (context, state) => _premiumRedirect(ref),
              ),
            ],
          ),

          // 友達画面
          GoRoute(
            path: '/friends',
            name: AppRoutes.friends,
            builder: (context, state) => const FriendsPage(),
            routes: [
              // 友達追加画面
              GoRoute(
                path: '/add',
                name: AppRoutes.addFriend,
                builder: (context, state) => const AddFriendPage(),
              ),
              // 友達詳細画面
              GoRoute(
                path: '/profile/:friendId',
                name: AppRoutes.friendProfile,
                builder: (context, state) {
                  final friendId = state.pathParameters['friendId']!;
                  return FriendProfilePage(friendId: friendId);
                },
              ),
              // ランキング画面
              GoRoute(
                path: '/ranking',
                name: AppRoutes.ranking,
                builder: (context, state) {
                  final period =
                      state.uri.queryParameters['period'] ?? 'weekly';
                  return RankingPage(period: period);
                },
              ),
            ],
          ),

          // 設定画面
          GoRoute(
            path: '/settings',
            name: AppRoutes.settings,
            builder: (context, state) => const SettingsPage(),
            routes: [
              // プロフィール設定画面
              GoRoute(
                path: '/profile',
                name: AppRoutes.profileSettings,
                builder: (context, state) => const ProfileSettingsPage(),
              ),
              // 目標設定画面
              GoRoute(
                path: '/goals',
                name: AppRoutes.goalSettings,
                builder: (context, state) => const GoalSettingsPage(),
              ),
              // プライバシー設定画面
              GoRoute(
                path: '/privacy',
                name: AppRoutes.privacySettings,
                builder: (context, state) => const PrivacySettingsPage(),
              ),
              // サブスクリプション管理画面
              GoRoute(
                path: '/subscription',
                name: AppRoutes.subscription,
                builder: (context, state) => const SubscriptionPage(),
              ),
              // 通知設定画面
              GoRoute(
                path: '/notifications',
                name: AppRoutes.notificationSettings,
                builder: (context, state) => const NotificationSettingsPage(),
              ),
            ],
          ),
        ],
      ),

      // オンボーディング画面（シェル外）
      GoRoute(
        path: '/onboarding',
        name: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingPage(),
      ),

      // プレミアムアップグレード画面（シェル外）
      GoRoute(
        path: '/premium',
        name: AppRoutes.premium,
        builder: (context, state) => const PremiumPage(),
      ),

      // エラー画面（シェル外）
      GoRoute(
        path: '/error',
        name: AppRoutes.error,
        builder: (context, state) {
          final error = state.extra as String? ?? 'Unknown error';
          return ErrorPage(error: error);
        },
      ),
    ],
    errorBuilder: (context, state) =>
        ErrorPage(error: 'Page not found: ${state.uri}'),
    redirect: (context, state) => _globalRedirect(context, state, ref),
  );
}

/// グローバルリダイレクト処理
String? _globalRedirect(BuildContext context, GoRouterState state, AppRouterRef ref) {
  // エラー状態の場合はエラーページにリダイレクト
  final errorState = ref.read(appErrorStateProvider);
  if (errorState != null && state.uri.path != '/error') {
    return '/error';
  }

  return null; // リダイレクトなし
}

/// プレミアム機能のリダイレクト処理
Future<String?> _premiumRedirect(AppRouterRef ref) async {
  final isPremium = await ref.read(isPremiumActiveProvider.future);
  if (!isPremium) {
    return '/premium';
  }
  return null;
}

/// アプリケーションのルート名定数
class AppRoutes {
  static const String home = 'home';
  static const String dayDetail = 'dayDetail';
  static const String activity = 'activity';
  static const String statistics = 'statistics';
  static const String dataExport = 'dataExport';
  static const String friends = 'friends';
  static const String addFriend = 'addFriend';
  static const String friendProfile = 'friendProfile';
  static const String ranking = 'ranking';
  static const String settings = 'settings';
  static const String profileSettings = 'profileSettings';
  static const String goalSettings = 'goalSettings';
  static const String privacySettings = 'privacySettings';
  static const String subscription = 'subscription';
  static const String notificationSettings = 'notificationSettings';
  static const String onboarding = 'onboarding';
  static const String premium = 'premium';
  static const String error = 'error';
}

/// ナビゲーションヘルパークラス
class AppNavigation {
  static void goToHome(BuildContext context) {
    context.goNamed(AppRoutes.home);
  }

  static void goToDayDetail(BuildContext context, DateTime date) {
    context.goNamed(
      AppRoutes.dayDetail,
      pathParameters: {'date': date.toIso8601String().split('T')[0]},
    );
  }

  static void goToStatistics(BuildContext context, {String period = 'weekly'}) {
    context.goNamed(AppRoutes.statistics, queryParameters: {'period': period});
  }

  static void goToDataExport(BuildContext context) {
    context.goNamed(AppRoutes.dataExport);
  }

  static void goToAddFriend(BuildContext context) {
    context.goNamed(AppRoutes.addFriend);
  }

  static void goToFriendProfile(BuildContext context, String friendId) {
    context.goNamed(
      AppRoutes.friendProfile,
      pathParameters: {'friendId': friendId},
    );
  }

  static void goToRanking(BuildContext context, {String period = 'weekly'}) {
    context.goNamed(AppRoutes.ranking, queryParameters: {'period': period});
  }

  static void goToProfileSettings(BuildContext context) {
    context.goNamed(AppRoutes.profileSettings);
  }

  static void goToGoalSettings(BuildContext context) {
    context.goNamed(AppRoutes.goalSettings);
  }

  static void goToPrivacySettings(BuildContext context) {
    context.goNamed(AppRoutes.privacySettings);
  }

  static void goToSubscription(BuildContext context) {
    context.goNamed(AppRoutes.subscription);
  }

  static void goToNotificationSettings(BuildContext context) {
    context.goNamed(AppRoutes.notificationSettings);
  }

  static void goToPremium(BuildContext context) {
    context.goNamed(AppRoutes.premium);
  }

  static void goToOnboarding(BuildContext context) {
    context.goNamed(AppRoutes.onboarding);
  }

  static void goToError(BuildContext context, String error) {
    context.goNamed(AppRoutes.error, extra: error);
  }
}

// プレースホルダーページクラス（実際の実装は後で行う）
class DayDetailPage extends StatelessWidget {
  const DayDetailPage({super.key, required this.date});
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Day Detail: ${date.toIso8601String().split('T')[0]}'),
      ),
      body: const Center(child: Text('Day Detail Page - To be implemented')),
    );
  }
}

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key, required this.period});
  final String period;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Statistics ($period)')),
      body: const Center(child: Text('Statistics Page - To be implemented')),
    );
  }
}

class DataExportPage extends StatelessWidget {
  const DataExportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Data Export')),
      body: const Center(child: Text('Data Export Page - To be implemented')),
    );
  }
}

class AddFriendPage extends StatelessWidget {
  const AddFriendPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Friend')),
      body: const Center(child: Text('Add Friend Page - To be implemented')),
    );
  }
}

class FriendProfilePage extends StatelessWidget {
  const FriendProfilePage({super.key, required this.friendId});
  final String friendId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Friend Profile')),
      body: Center(child: Text('Friend Profile Page - Friend ID: $friendId')),
    );
  }
}

class RankingPage extends StatelessWidget {
  const RankingPage({super.key, required this.period});
  final String period;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ranking ($period)')),
      body: const Center(child: Text('Ranking Page - To be implemented')),
    );
  }
}

class ProfileSettingsPage extends StatelessWidget {
  const ProfileSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile Settings')),
      body: const Center(
        child: Text('Profile Settings Page - To be implemented'),
      ),
    );
  }
}

class GoalSettingsPage extends StatelessWidget {
  const GoalSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Goal Settings')),
      body: const Center(child: Text('Goal Settings Page - To be implemented')),
    );
  }
}

class PrivacySettingsPage extends StatelessWidget {
  const PrivacySettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Settings')),
      body: const Center(
        child: Text('Privacy Settings Page - To be implemented'),
      ),
    );
  }
}

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Subscription')),
      body: const Center(child: Text('Subscription Page - To be implemented')),
    );
  }
}

class NotificationSettingsPage extends StatelessWidget {
  const NotificationSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notification Settings')),
      body: const Center(
        child: Text('Notification Settings Page - To be implemented'),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome')),
      body: const Center(child: Text('Onboarding Page - To be implemented')),
    );
  }
}

class PremiumPage extends StatelessWidget {
  const PremiumPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Premium')),
      body: const Center(child: Text('Premium Page - To be implemented')),
    );
  }
}

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key, required this.error});
  final String error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'An error occurred',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(error),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}
