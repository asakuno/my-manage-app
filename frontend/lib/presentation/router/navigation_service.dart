import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'app_router.dart';
import '../provider/ui_state_provider.dart';
import '../provider/subscription_provider.dart';

/// ナビゲーションサービス
/// プログラマティックなナビゲーションを管理する
class NavigationService {
  NavigationService(this._ref);

  final Ref _ref;

  /// ホーム画面に移動
  void goToHome(BuildContext context) {
    _updateTabIndex(0);
    AppNavigation.goToHome(context);
  }

  /// アクティビティ画面に移動
  void goToActivity(BuildContext context) {
    _updateTabIndex(1);
    context.go('/activity');
  }

  /// 友達画面に移動
  void goToFriends(BuildContext context) {
    _updateTabIndex(2);
    context.go('/friends');
  }

  /// 設定画面に移動
  void goToSettings(BuildContext context) {
    _updateTabIndex(3);
    context.go('/settings');
  }

  /// 特定日の詳細画面に移動
  void goToDayDetail(BuildContext context, DateTime date) {
    AppNavigation.goToDayDetail(context, date);
  }

  /// 統計画面に移動
  void goToStatistics(BuildContext context, {String period = 'weekly'}) {
    AppNavigation.goToStatistics(context, period: period);
  }

  /// データエクスポート画面に移動（プレミアム機能チェック付き）
  Future<void> goToDataExport(BuildContext context) async {
    final isPremium = await _ref.read(isPremiumActiveProvider.future);
    if (!context.mounted) return;
    
    if (!isPremium) {
      _showPremiumRequiredDialog(context);
      return;
    }
    AppNavigation.goToDataExport(context);
  }

  /// 友達追加画面に移動
  void goToAddFriend(BuildContext context) {
    AppNavigation.goToAddFriend(context);
  }

  /// 友達プロフィール画面に移動
  void goToFriendProfile(BuildContext context, String friendId) {
    AppNavigation.goToFriendProfile(context, friendId);
  }

  /// ランキング画面に移動
  void goToRanking(BuildContext context, {String period = 'weekly'}) {
    AppNavigation.goToRanking(context, period: period);
  }

  /// プロフィール設定画面に移動
  void goToProfileSettings(BuildContext context) {
    AppNavigation.goToProfileSettings(context);
  }

  /// 目標設定画面に移動
  void goToGoalSettings(BuildContext context) {
    AppNavigation.goToGoalSettings(context);
  }

  /// プライバシー設定画面に移動
  void goToPrivacySettings(BuildContext context) {
    AppNavigation.goToPrivacySettings(context);
  }

  /// サブスクリプション画面に移動
  void goToSubscription(BuildContext context) {
    AppNavigation.goToSubscription(context);
  }

  /// 通知設定画面に移動
  void goToNotificationSettings(BuildContext context) {
    AppNavigation.goToNotificationSettings(context);
  }

  /// プレミアム画面に移動
  void goToPremium(BuildContext context) {
    AppNavigation.goToPremium(context);
  }

  /// オンボーディング画面に移動
  void goToOnboarding(BuildContext context) {
    AppNavigation.goToOnboarding(context);
  }

  /// エラー画面に移動
  void goToError(BuildContext context, String error) {
    _ref.read(appErrorStateProvider.notifier).setError(error);
    AppNavigation.goToError(context, error);
  }

  /// 戻る
  void goBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      goToHome(context);
    }
  }

  /// 成功メッセージを表示して画面遷移
  void goWithSuccessMessage(
    BuildContext context,
    String message,
    VoidCallback navigation,
  ) {
    _ref.read(notificationStateProvider.notifier).showSuccess(message);
    navigation();
  }

  /// エラーメッセージを表示
  void showError(String message) {
    _ref.read(notificationStateProvider.notifier).showError(message);
  }

  /// 成功メッセージを表示
  void showSuccess(String message) {
    _ref.read(notificationStateProvider.notifier).showSuccess(message);
  }

  /// 警告メッセージを表示
  void showWarning(String message) {
    _ref.read(notificationStateProvider.notifier).showWarning(message);
  }

  /// 情報メッセージを表示
  void showInfo(String message) {
    _ref.read(notificationStateProvider.notifier).showInfo(message);
  }

  /// 確認ダイアログを表示
  void showConfirmDialog({
    required String title,
    required String message,
    String confirmText = 'OK',
    String cancelText = 'Cancel',
  }) {
    _ref
        .read(dialogStateProvider.notifier)
        .showConfirmDialog(
          title: title,
          message: message,
          confirmText: confirmText,
          cancelText: cancelText,
        );
  }

  /// アラートダイアログを表示
  void showAlertDialog({
    required String title,
    required String message,
    String buttonText = 'OK',
  }) {
    _ref
        .read(dialogStateProvider.notifier)
        .showAlertDialog(
          title: title,
          message: message,
          buttonText: buttonText,
        );
  }

  /// ボトムシートを表示
  void showBottomSheet({
    required String type,
    required String title,
    Map<String, dynamic>? data,
  }) {
    _ref
        .read(bottomSheetStateProvider.notifier)
        .showBottomSheet(type: type, title: title, data: data);
  }

  /// タブインデックスを更新
  void _updateTabIndex(int index) {
    _ref.read(selectedTabIndexProvider.notifier).changeTab(index);
  }

  /// プレミアム機能が必要なダイアログを表示
  void _showPremiumRequiredDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Premium Feature'),
        content: const Text(
          'This feature is only available for Premium users. '
          'Would you like to upgrade now?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Maybe Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              goToPremium(context);
            },
            child: const Text('Upgrade'),
          ),
        ],
      ),
    );
  }
}

/// ナビゲーションサービスプロバイダー
final navigationServiceProvider = Provider<NavigationService>((ref) {
  return NavigationService(ref);
});

/// ディープリンクハンドラー
class DeepLinkHandler {
  static void handleDeepLink(String link, BuildContext context, Ref ref) {
    final uri = Uri.parse(link);
    final navigationService = ref.read(navigationServiceProvider);

    switch (uri.pathSegments.first) {
      case 'home':
        navigationService.goToHome(context);
        break;
      case 'activity':
        if (uri.pathSegments.length > 1) {
          switch (uri.pathSegments[1]) {
            case 'statistics':
              final period = uri.queryParameters['period'] ?? 'weekly';
              navigationService.goToStatistics(context, period: period);
              break;
            case 'export':
              navigationService.goToDataExport(context);
              break;
            default:
              navigationService.goToActivity(context);
          }
        } else {
          navigationService.goToActivity(context);
        }
        break;
      case 'friends':
        if (uri.pathSegments.length > 1) {
          switch (uri.pathSegments[1]) {
            case 'add':
              navigationService.goToAddFriend(context);
              break;
            case 'profile':
              if (uri.pathSegments.length > 2) {
                navigationService.goToFriendProfile(
                  context,
                  uri.pathSegments[2],
                );
              }
              break;
            case 'ranking':
              final period = uri.queryParameters['period'] ?? 'weekly';
              navigationService.goToRanking(context, period: period);
              break;
            default:
              navigationService.goToFriends(context);
          }
        } else {
          navigationService.goToFriends(context);
        }
        break;
      case 'settings':
        if (uri.pathSegments.length > 1) {
          switch (uri.pathSegments[1]) {
            case 'profile':
              navigationService.goToProfileSettings(context);
              break;
            case 'goals':
              navigationService.goToGoalSettings(context);
              break;
            case 'privacy':
              navigationService.goToPrivacySettings(context);
              break;
            case 'subscription':
              navigationService.goToSubscription(context);
              break;
            case 'notifications':
              navigationService.goToNotificationSettings(context);
              break;
            default:
              navigationService.goToSettings(context);
          }
        } else {
          navigationService.goToSettings(context);
        }
        break;
      case 'premium':
        navigationService.goToPremium(context);
        break;
      case 'day':
        if (uri.pathSegments.length > 1) {
          try {
            final date = DateTime.parse(uri.pathSegments[1]);
            navigationService.goToDayDetail(context, date);
          } catch (e) {
            navigationService.showError('Invalid date format');
            navigationService.goToHome(context);
          }
        }
        break;
      default:
        navigationService.goToHome(context);
    }
  }
}

/// ナビゲーション履歴管理
class NavigationHistory {
  static final List<String> _history = [];
  static const int maxHistorySize = 10;

  static void addToHistory(String route) {
    _history.add(route);
    if (_history.length > maxHistorySize) {
      _history.removeAt(0);
    }
  }

  static List<String> get history => List.unmodifiable(_history);

  static String? get previousRoute {
    if (_history.length < 2) return null;
    return _history[_history.length - 2];
  }

  static void clear() {
    _history.clear();
  }
}

/// ナビゲーション履歴プロバイダー
final navigationHistoryProvider = StateProvider<List<String>>((ref) => []);

/// ナビゲーション状態プロバイダー
final navigationStateProvider = StateProvider<Map<String, dynamic>>(
  (ref) => {'currentRoute': '/home', 'canGoBack': false, 'isLoading': false},
);
