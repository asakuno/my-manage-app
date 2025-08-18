import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ui_state_provider.g.dart';

/// アプリの読み込み状態を管理するプロバイダー
@riverpod
class AppLoadingState extends _$AppLoadingState {
  @override
  bool build() {
    return false;
  }

  /// 読み込み状態を設定
  void setLoading(bool isLoading) {
    state = isLoading;
  }
}

/// エラー状態を管理するプロバイダー
@riverpod
class AppErrorState extends _$AppErrorState {
  @override
  String? build() {
    return null;
  }

  /// エラーを設定
  void setError(String? error) {
    state = error;
  }

  /// エラーをクリア
  void clearError() {
    state = null;
  }
}

/// 現在選択されているタブインデックスプロバイダー
@riverpod
class SelectedTabIndex extends _$SelectedTabIndex {
  @override
  int build() {
    return 0; // デフォルトはホームタブ
  }

  /// タブを変更
  void changeTab(int index) {
    state = index;
  }
}

/// ユーザー設定プロバイダー
@riverpod
class UserSettings extends _$UserSettings {
  @override
  Map<String, dynamic> build() {
    return {
      'dailyStepGoal': 8000,
      'notificationsEnabled': true,
      'darkMode': false,
      'language': 'ja',
      'privacyLevel': 'friends',
    };
  }

  /// 歩数目標を更新
  void updateDailyStepGoal(int goal) {
    state = {...state, 'dailyStepGoal': goal};
  }

  /// 通知設定を更新
  void updateNotificationsEnabled(bool enabled) {
    state = {...state, 'notificationsEnabled': enabled};
  }

  /// ダークモード設定を更新
  void updateDarkMode(bool enabled) {
    state = {...state, 'darkMode': enabled};
  }

  /// 言語設定を更新
  void updateLanguage(String language) {
    state = {...state, 'language': language};
  }

  /// プライバシーレベルを更新
  void updatePrivacyLevel(String level) {
    state = {...state, 'privacyLevel': level};
  }

  /// 設定を一括更新
  void updateSettings(Map<String, dynamic> newSettings) {
    state = {...state, ...newSettings};
  }
}

/// カレンダー表示設定プロバイダー
@riverpod
class CalendarViewSettings extends _$CalendarViewSettings {
  @override
  Map<String, dynamic> build() {
    return {
      'selectedYear': DateTime.now().year,
      'selectedMonth': DateTime.now().month,
      'viewMode': 'yearly', // 'yearly', 'monthly', 'weekly'
      'showWeekends': true,
      'showGoalLine': true,
    };
  }

  /// 選択年を更新
  void updateSelectedYear(int year) {
    state = {...state, 'selectedYear': year};
  }

  /// 選択月を更新
  void updateSelectedMonth(int month) {
    state = {...state, 'selectedMonth': month};
  }

  /// 表示モードを更新
  void updateViewMode(String mode) {
    state = {...state, 'viewMode': mode};
  }

  /// 週末表示設定を更新
  void updateShowWeekends(bool show) {
    state = {...state, 'showWeekends': show};
  }

  /// 目標ライン表示設定を更新
  void updateShowGoalLine(bool show) {
    state = {...state, 'showGoalLine': show};
  }
}

/// 統計画面の設定プロバイダー
@riverpod
class StatisticsViewSettings extends _$StatisticsViewSettings {
  @override
  Map<String, dynamic> build() {
    return {
      'selectedPeriod': 'weekly', // 'weekly', 'monthly', 'yearly'
      'chartType': 'bar', // 'bar', 'line', 'pie'
      'showComparison': false,
      'comparisonPeriod': 'previous',
    };
  }

  /// 選択期間を更新
  void updateSelectedPeriod(String period) {
    state = {...state, 'selectedPeriod': period};
  }

  /// チャートタイプを更新
  void updateChartType(String type) {
    state = {...state, 'chartType': type};
  }

  /// 比較表示設定を更新
  void updateShowComparison(bool show) {
    state = {...state, 'showComparison': show};
  }

  /// 比較期間を更新
  void updateComparisonPeriod(String period) {
    state = {...state, 'comparisonPeriod': period};
  }
}

/// ソーシャル画面の設定プロバイダー
@riverpod
class SocialViewSettings extends _$SocialViewSettings {
  @override
  Map<String, dynamic> build() {
    return {
      'selectedTab': 'friends', // 'friends', 'ranking', 'invitations'
      'rankingPeriod': 'weekly', // 'weekly', 'monthly'
      'showOnlineFriendsOnly': false,
      'sortBy': 'name', // 'name', 'activity', 'recent'
    };
  }

  /// 選択タブを更新
  void updateSelectedTab(String tab) {
    state = {...state, 'selectedTab': tab};
  }

  /// ランキング期間を更新
  void updateRankingPeriod(String period) {
    state = {...state, 'rankingPeriod': period};
  }

  /// オンライン友達のみ表示設定を更新
  void updateShowOnlineFriendsOnly(bool show) {
    state = {...state, 'showOnlineFriendsOnly': show};
  }

  /// ソート方法を更新
  void updateSortBy(String sortBy) {
    state = {...state, 'sortBy': sortBy};
  }
}

/// 通知状態プロバイダー
@riverpod
class NotificationState extends _$NotificationState {
  @override
  List<Map<String, dynamic>> build() {
    return [];
  }

  /// 通知を追加
  void addNotification({
    required String message,
    String type = 'info',
    Duration? duration,
  }) {
    final notification = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'message': message,
      'type': type,
      'timestamp': DateTime.now(),
      'duration': duration ?? const Duration(seconds: 3),
    };

    state = [...state, notification];

    // 指定時間後に自動削除
    Future.delayed(notification['duration'] as Duration, () {
      removeNotification(notification['id'] as String);
    });
  }

  /// 通知を削除
  void removeNotification(String id) {
    state = state.where((notification) => notification['id'] != id).toList();
  }

  /// 全通知をクリア
  void clearAllNotifications() {
    state = [];
  }

  /// 成功通知を表示
  void showSuccess(String message) {
    addNotification(message: message, type: 'success');
  }

  /// エラー通知を表示
  void showError(String message) {
    addNotification(
      message: message,
      type: 'error',
      duration: const Duration(seconds: 5),
    );
  }

  /// 警告通知を表示
  void showWarning(String message) {
    addNotification(
      message: message,
      type: 'warning',
      duration: const Duration(seconds: 4),
    );
  }

  /// 情報通知を表示
  void showInfo(String message) {
    addNotification(message: message, type: 'info');
  }
}

/// ダイアログ状態プロバイダー
@riverpod
class DialogState extends _$DialogState {
  @override
  Map<String, dynamic>? build() {
    return null;
  }

  /// ダイアログを表示
  void showDialog({
    required String type,
    required String title,
    required String message,
    Map<String, dynamic>? data,
  }) {
    state = {
      'type': type,
      'title': title,
      'message': message,
      'data': data,
      'isVisible': true,
    };
  }

  /// ダイアログを非表示
  void hideDialog() {
    state = null;
  }

  /// 確認ダイアログを表示
  void showConfirmDialog({
    required String title,
    required String message,
    String confirmText = 'OK',
    String cancelText = 'Cancel',
  }) {
    showDialog(
      type: 'confirm',
      title: title,
      message: message,
      data: {'confirmText': confirmText, 'cancelText': cancelText},
    );
  }

  /// アラートダイアログを表示
  void showAlertDialog({
    required String title,
    required String message,
    String buttonText = 'OK',
  }) {
    showDialog(
      type: 'alert',
      title: title,
      message: message,
      data: {'buttonText': buttonText},
    );
  }
}

/// ボトムシート状態プロバイダー
@riverpod
class BottomSheetState extends _$BottomSheetState {
  @override
  Map<String, dynamic>? build() {
    return null;
  }

  /// ボトムシートを表示
  void showBottomSheet({
    required String type,
    required String title,
    Map<String, dynamic>? data,
  }) {
    state = {'type': type, 'title': title, 'data': data, 'isVisible': true};
  }

  /// ボトムシートを非表示
  void hideBottomSheet() {
    state = null;
  }
}

/// 検索状態プロバイダー
@riverpod
class SearchState extends _$SearchState {
  @override
  Map<String, dynamic> build() {
    return {'query': '', 'isActive': false, 'results': [], 'isLoading': false};
  }

  /// 検索クエリを更新
  void updateQuery(String query) {
    state = {...state, 'query': query};
  }

  /// 検索状態を更新
  void updateIsActive(bool isActive) {
    state = {...state, 'isActive': isActive};
  }

  /// 検索結果を更新
  void updateResults(List<dynamic> results) {
    state = {...state, 'results': results};
  }

  /// 読み込み状態を更新
  void updateIsLoading(bool isLoading) {
    state = {...state, 'isLoading': isLoading};
  }

  /// 検索をクリア
  void clearSearch() {
    state = {'query': '', 'isActive': false, 'results': [], 'isLoading': false};
  }
}

/// UI状態の統合プロバイダー
@riverpod
class UIStateManager extends _$UIStateManager {
  @override
  Map<String, dynamic> build() {
    final isLoading = ref.watch(appLoadingStateProvider);
    final error = ref.watch(appErrorStateProvider);
    final selectedTab = ref.watch(selectedTabIndexProvider);
    final userSettings = ref.watch(userSettingsProvider);
    final notifications = ref.watch(notificationStateProvider);

    return {
      'isLoading': isLoading,
      'error': error,
      'selectedTab': selectedTab,
      'userSettings': userSettings,
      'notifications': notifications,
      'hasError': error != null,
      'notificationCount': notifications.length,
    };
  }

  /// UI状態をリセット
  void resetUIState() {
    ref.read(appLoadingStateProvider.notifier).setLoading(false);
    ref.read(appErrorStateProvider.notifier).clearError();
    ref.read(notificationStateProvider.notifier).clearAllNotifications();
  }

  /// エラー状態を設定
  void setError(String error) {
    ref.read(appErrorStateProvider.notifier).setError(error);
    ref.read(notificationStateProvider.notifier).showError(error);
  }

  /// 成功状態を設定
  void setSuccess(String message) {
    ref.read(appErrorStateProvider.notifier).clearError();
    ref.read(notificationStateProvider.notifier).showSuccess(message);
  }
}
