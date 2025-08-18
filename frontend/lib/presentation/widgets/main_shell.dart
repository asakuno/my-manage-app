import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../provider/ui_state_provider.dart';
import '../provider/subscription_provider.dart';
import '../router/app_router.dart';

/// メインシェル - BottomNavigationBarを固定で表示
class MainShell extends ConsumerWidget {
  const MainShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shouldShowAds = ref.watch(shouldShowAdsProvider);

    return Scaffold(
      body: Column(
        children: [
          Expanded(child: child),
          // 広告バナーを表示（無料ユーザーのみ）
          shouldShowAds.when(
            data: (showAds) => showAds
                ? Container(
                    height: 50,
                    color: Colors.grey.shade100,
                    child: const Center(
                      child: Text(
                        'Advertisement',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onItemTapped(index, context, ref),
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Activity',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Friends'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  /// 現在のルートに基づいて選択されたインデックスを計算
  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;

    if (location.startsWith('/home')) {
      return 0;
    } else if (location.startsWith('/activity')) {
      return 1;
    } else if (location.startsWith('/friends')) {
      return 2;
    } else if (location.startsWith('/settings')) {
      return 3;
    }

    return 0; // デフォルトはホーム
  }

  /// BottomNavigationBarのタップ処理
  void _onItemTapped(int index, BuildContext context, WidgetRef ref) {
    // UI状態を更新
    ref.read(selectedTabIndexProvider.notifier).changeTab(index);

    switch (index) {
      case 0:
        AppNavigation.goToHome(context);
        break;
      case 1:
        context.go('/activity');
        break;
      case 2:
        context.go('/friends');
        break;
      case 3:
        context.go('/settings');
        break;
    }
  }
}

/// アプリバーを含むページのベースウィジェット
class BasePage extends ConsumerWidget {
  const BasePage({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
    this.showBackButton = false,
  });

  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final bool showBackButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        automaticallyImplyLeading: showBackButton,
        actions: [
          // 通知アイコン
          if (notifications.isNotEmpty)
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications),
                  onPressed: () => _showNotifications(context, ref),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${notifications.length}',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ...?actions,
        ],
      ),
      body: Stack(
        children: [
          body,
          // 通知オーバーレイ
          if (notifications.isNotEmpty)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _buildNotificationOverlay(notifications, ref),
            ),
        ],
      ),
      floatingActionButton: floatingActionButton,
    );
  }

  Widget _buildNotificationOverlay(
    List<Map<String, dynamic>> notifications,
    WidgetRef ref,
  ) {
    return Column(
      children: notifications.take(3).map((notification) {
        final type = notification['type'] as String;
        final message = notification['message'] as String;
        final id = notification['id'] as String;

        Color backgroundColor;
        IconData icon;

        switch (type) {
          case 'success':
            backgroundColor = Colors.green;
            icon = Icons.check_circle;
            break;
          case 'error':
            backgroundColor = Colors.red;
            icon = Icons.error;
            break;
          case 'warning':
            backgroundColor = Colors.orange;
            icon = Icons.warning;
            break;
          default:
            backgroundColor = Colors.blue;
            icon = Icons.info;
        }

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 20),
                onPressed: () => ref
                    .read(notificationStateProvider.notifier)
                    .removeNotification(id),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  void _showNotifications(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) => const NotificationSheet(),
    );
  }
}

/// 通知一覧シート
class NotificationSheet extends ConsumerWidget {
  const NotificationSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationStateProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Notifications',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () => ref
                    .read(notificationStateProvider.notifier)
                    .clearAllNotifications(),
                child: const Text('Clear All'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (notifications.isEmpty)
            const Center(child: Text('No notifications'))
          else
            ...notifications.map((notification) {
              final type = notification['type'] as String;
              final message = notification['message'] as String;
              final timestamp = notification['timestamp'] as DateTime;

              return ListTile(
                leading: Icon(_getNotificationIcon(type)),
                title: Text(message),
                subtitle: Text(_formatTimestamp(timestamp)),
                trailing: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => ref
                      .read(notificationStateProvider.notifier)
                      .removeNotification(notification['id'] as String),
                ),
              );
            }),
        ],
      ),
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'success':
        return Icons.check_circle;
      case 'error':
        return Icons.error;
      case 'warning':
        return Icons.warning;
      default:
        return Icons.info;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
