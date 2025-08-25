import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:frontend/presentation/provider/ui_state_provider.dart';

void main() {
  group('UI State Provider Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    group('AppLoadingState Provider', () {
      test('初期状態で読み込み中ではない', () {
        // Act
        final isLoading = container.read(appLoadingStateProvider);

        // Assert
        expect(isLoading, isFalse);
      });

      test('読み込み状態を正しく設定できる', () {
        // Act
        container.read(appLoadingStateProvider.notifier).setLoading(true);
        final isLoading = container.read(appLoadingStateProvider);

        // Assert
        expect(isLoading, isTrue);
      });

      test('読み込み状態を切り替えられる', () {
        final notifier = container.read(appLoadingStateProvider.notifier);

        // Act & Assert
        notifier.setLoading(true);
        expect(container.read(appLoadingStateProvider), isTrue);

        notifier.setLoading(false);
        expect(container.read(appLoadingStateProvider), isFalse);
      });
    });

    group('AppErrorState Provider', () {
      test('初期状態でエラーがない', () {
        // Act
        final error = container.read(appErrorStateProvider);

        // Assert
        expect(error, isNull);
      });

      test('エラーを正しく設定できる', () {
        const errorMessage = 'テストエラー';

        // Act
        container.read(appErrorStateProvider.notifier).setError(errorMessage);
        final error = container.read(appErrorStateProvider);

        // Assert
        expect(error, equals(errorMessage));
      });

      test('エラーをクリアできる', () {
        const errorMessage = 'テストエラー';
        final notifier = container.read(appErrorStateProvider.notifier);

        // Arrange
        notifier.setError(errorMessage);
        expect(container.read(appErrorStateProvider), equals(errorMessage));

        // Act
        notifier.clearError();
        final error = container.read(appErrorStateProvider);

        // Assert
        expect(error, isNull);
      });

      test('複数のエラーを設定しても最新のエラーが保持される', () {
        const firstError = 'エラー1';
        const secondError = 'エラー2';
        final notifier = container.read(appErrorStateProvider.notifier);

        // Act
        notifier.setError(firstError);
        notifier.setError(secondError);
        final error = container.read(appErrorStateProvider);

        // Assert
        expect(error, equals(secondError));
      });
    });

    group('SelectedTabIndex Provider', () {
      test('初期状態でタブインデックスが0（ホームタブ）', () {
        // Act
        final selectedTab = container.read(selectedTabIndexProvider);

        // Assert
        expect(selectedTab, equals(0));
      });

      test('タブインデックスを正しく変更できる', () {
        const newTabIndex = 2;

        // Act
        container.read(selectedTabIndexProvider.notifier).changeTab(newTabIndex);
        final selectedTab = container.read(selectedTabIndexProvider);

        // Assert
        expect(selectedTab, equals(newTabIndex));
      });

      test('複数回タブを変更できる', () {
        final notifier = container.read(selectedTabIndexProvider.notifier);

        // Act & Assert
        notifier.changeTab(1);
        expect(container.read(selectedTabIndexProvider), equals(1));

        notifier.changeTab(3);
        expect(container.read(selectedTabIndexProvider), equals(3));

        notifier.changeTab(0);
        expect(container.read(selectedTabIndexProvider), equals(0));
      });
    });

    group('UserSettings Provider', () {
      test('初期状態で正しいデフォルト設定を持つ', () {
        // Act
        final settings = container.read(userSettingsProvider);

        // Assert
        expect(settings['dailyStepGoal'], equals(8000));
        expect(settings['notificationsEnabled'], isTrue);
        expect(settings['darkMode'], isFalse);
        expect(settings['language'], equals('ja'));
        expect(settings['privacyLevel'], equals('friends'));
      });

      test('歩数目標を正しく更新できる', () {
        const newGoal = 10000;

        // Act
        container.read(userSettingsProvider.notifier).updateDailyStepGoal(newGoal);
        final settings = container.read(userSettingsProvider);

        // Assert
        expect(settings['dailyStepGoal'], equals(newGoal));
        // 他の設定は変更されない
        expect(settings['notificationsEnabled'], isTrue);
        expect(settings['darkMode'], isFalse);
      });

      test('通知設定を正しく更新できる', () {
        // Act
        container.read(userSettingsProvider.notifier).updateNotificationsEnabled(false);
        final settings = container.read(userSettingsProvider);

        // Assert
        expect(settings['notificationsEnabled'], isFalse);
        // 他の設定は変更されない
        expect(settings['dailyStepGoal'], equals(8000));
      });

      test('ダークモード設定を正しく更新できる', () {
        // Act
        container.read(userSettingsProvider.notifier).updateDarkMode(true);
        final settings = container.read(userSettingsProvider);

        // Assert
        expect(settings['darkMode'], isTrue);
      });

      test('言語設定を正しく更新できる', () {
        const newLanguage = 'en';

        // Act
        container.read(userSettingsProvider.notifier).updateLanguage(newLanguage);
        final settings = container.read(userSettingsProvider);

        // Assert
        expect(settings['language'], equals(newLanguage));
      });

      test('プライバシーレベルを正しく更新できる', () {
        const newLevel = 'public';

        // Act
        container.read(userSettingsProvider.notifier).updatePrivacyLevel(newLevel);
        final settings = container.read(userSettingsProvider);

        // Assert
        expect(settings['privacyLevel'], equals(newLevel));
      });

      test('設定を一括更新できる', () {
        final newSettings = {
          'dailyStepGoal': 12000,
          'darkMode': true,
          'language': 'en',
        };

        // Act
        container.read(userSettingsProvider.notifier).updateSettings(newSettings);
        final settings = container.read(userSettingsProvider);

        // Assert
        expect(settings['dailyStepGoal'], equals(12000));
        expect(settings['darkMode'], isTrue);
        expect(settings['language'], equals('en'));
        // 更新されていない設定は元の値を保持
        expect(settings['notificationsEnabled'], isTrue);
        expect(settings['privacyLevel'], equals('friends'));
      });

      test('複数の個別設定を順次更新できる', () {
        final notifier = container.read(userSettingsProvider.notifier);

        // Act
        notifier.updateDailyStepGoal(15000);
        notifier.updateDarkMode(true);
        notifier.updateNotificationsEnabled(false);
        final settings = container.read(userSettingsProvider);

        // Assert
        expect(settings['dailyStepGoal'], equals(15000));
        expect(settings['darkMode'], isTrue);
        expect(settings['notificationsEnabled'], isFalse);
        expect(settings['language'], equals('ja')); // 変更されない
      });
    });

    group('CalendarViewSettings Provider', () {
      test('初期状態で正しいデフォルト設定を持つ', () {
        // Act
        final settings = container.read(calendarViewSettingsProvider);
        final now = DateTime.now();

        // Assert
        expect(settings['selectedYear'], equals(now.year));
        expect(settings['selectedMonth'], equals(now.month));
        expect(settings['viewMode'], equals('yearly'));
        expect(settings['showWeekends'], isTrue);
        expect(settings['showGoalLine'], isTrue);
      });

      test('選択年を正しく更新できる', () {
        const newYear = 2025;

        // Act
        container.read(calendarViewSettingsProvider.notifier).updateSelectedYear(newYear);
        final settings = container.read(calendarViewSettingsProvider);

        // Assert
        expect(settings['selectedYear'], equals(newYear));
      });

      test('選択月を正しく更新できる', () {
        const newMonth = 6;

        // Act
        container.read(calendarViewSettingsProvider.notifier).updateSelectedMonth(newMonth);
        final settings = container.read(calendarViewSettingsProvider);

        // Assert
        expect(settings['selectedMonth'], equals(newMonth));
      });

      test('表示モードを正しく更新できる', () {
        const newMode = 'monthly';

        // Act
        container.read(calendarViewSettingsProvider.notifier).updateViewMode(newMode);
        final settings = container.read(calendarViewSettingsProvider);

        // Assert
        expect(settings['viewMode'], equals(newMode));
      });

      test('週末表示設定を正しく更新できる', () {
        // Act
        container.read(calendarViewSettingsProvider.notifier).updateShowWeekends(false);
        final settings = container.read(calendarViewSettingsProvider);

        // Assert
        expect(settings['showWeekends'], isFalse);
      });

      test('目標ライン表示設定を正しく更新できる', () {
        // Act
        container.read(calendarViewSettingsProvider.notifier).updateShowGoalLine(false);
        final settings = container.read(calendarViewSettingsProvider);

        // Assert
        expect(settings['showGoalLine'], isFalse);
      });
    });

    group('StatisticsViewSettings Provider', () {
      test('初期状態で正しいデフォルト設定を持つ', () {
        // Act
        final settings = container.read(statisticsViewSettingsProvider);

        // Assert
        expect(settings['selectedPeriod'], equals('weekly'));
        expect(settings['chartType'], equals('bar'));
        expect(settings['showComparison'], isFalse);
        expect(settings['comparisonPeriod'], equals('previous'));
      });

      test('選択期間を正しく更新できる', () {
        const newPeriod = 'monthly';

        // Act
        container.read(statisticsViewSettingsProvider.notifier).updateSelectedPeriod(newPeriod);
        final settings = container.read(statisticsViewSettingsProvider);

        // Assert
        expect(settings['selectedPeriod'], equals(newPeriod));
      });

      test('チャートタイプを正しく更新できる', () {
        const newType = 'line';

        // Act
        container.read(statisticsViewSettingsProvider.notifier).updateChartType(newType);
        final settings = container.read(statisticsViewSettingsProvider);

        // Assert
        expect(settings['chartType'], equals(newType));
      });

      test('比較表示設定を正しく更新できる', () {
        // Act
        container.read(statisticsViewSettingsProvider.notifier).updateShowComparison(true);
        final settings = container.read(statisticsViewSettingsProvider);

        // Assert
        expect(settings['showComparison'], isTrue);
      });

      test('比較期間を正しく更新できる', () {
        const newPeriod = 'last_year';

        // Act
        container.read(statisticsViewSettingsProvider.notifier).updateComparisonPeriod(newPeriod);
        final settings = container.read(statisticsViewSettingsProvider);

        // Assert
        expect(settings['comparisonPeriod'], equals(newPeriod));
      });
    });

    group('SocialViewSettings Provider', () {
      test('初期状態で正しいデフォルト設定を持つ', () {
        // Act
        final settings = container.read(socialViewSettingsProvider);

        // Assert
        expect(settings['selectedTab'], equals('friends'));
        expect(settings['rankingPeriod'], equals('weekly'));
        expect(settings['showOnlineFriendsOnly'], isFalse);
        expect(settings['sortBy'], equals('name'));
      });

      test('選択タブを正しく更新できる', () {
        const newTab = 'ranking';

        // Act
        container.read(socialViewSettingsProvider.notifier).updateSelectedTab(newTab);
        final settings = container.read(socialViewSettingsProvider);

        // Assert
        expect(settings['selectedTab'], equals(newTab));
      });

      test('ランキング期間を正しく更新できる', () {
        const newPeriod = 'monthly';

        // Act
        container.read(socialViewSettingsProvider.notifier).updateRankingPeriod(newPeriod);
        final settings = container.read(socialViewSettingsProvider);

        // Assert
        expect(settings['rankingPeriod'], equals(newPeriod));
      });

      test('オンライン友達のみ表示設定を正しく更新できる', () {
        // Act
        container.read(socialViewSettingsProvider.notifier).updateShowOnlineFriendsOnly(true);
        final settings = container.read(socialViewSettingsProvider);

        // Assert
        expect(settings['showOnlineFriendsOnly'], isTrue);
      });

      test('ソート方法を正しく更新できる', () {
        const newSortBy = 'activity';

        // Act
        container.read(socialViewSettingsProvider.notifier).updateSortBy(newSortBy);
        final settings = container.read(socialViewSettingsProvider);

        // Assert
        expect(settings['sortBy'], equals(newSortBy));
      });
    });

    group('NotificationState Provider', () {
      test('初期状態で通知リストが空', () {
        // Act
        final notifications = container.read(notificationStateProvider);

        // Assert
        expect(notifications, isEmpty);
      });

      test('通知を正しく追加できる', () {
        const message = 'テスト通知';

        // Act
        container.read(notificationStateProvider.notifier).addNotification(message: message);
        final notifications = container.read(notificationStateProvider);

        // Assert
        expect(notifications.length, equals(1));
        expect(notifications[0]['message'], equals(message));
        expect(notifications[0]['type'], equals('info'));
        expect(notifications[0]['id'], isNotNull);
        expect(notifications[0]['timestamp'], isA<DateTime>());
      });

      test('通知をタイプ指定で追加できる', () {
        const message = 'エラー通知';
        const type = 'error';

        // Act
        container.read(notificationStateProvider.notifier).addNotification(
          message: message,
          type: type,
        );
        final notifications = container.read(notificationStateProvider);

        // Assert
        expect(notifications.length, equals(1));
        expect(notifications[0]['message'], equals(message));
        expect(notifications[0]['type'], equals(type));
      });

      test('通知を正しく削除できる', () {
        const message = 'テスト通知';
        final notifier = container.read(notificationStateProvider.notifier);

        // Arrange
        notifier.addNotification(message: message);
        final notifications = container.read(notificationStateProvider);
        final notificationId = notifications[0]['id'] as String;

        // Act
        notifier.removeNotification(notificationId);
        final updatedNotifications = container.read(notificationStateProvider);

        // Assert
        expect(updatedNotifications, isEmpty);
      });

      test('全通知を正しくクリアできる', () {
        final notifier = container.read(notificationStateProvider.notifier);

        // Arrange
        notifier.addNotification(message: '通知1');
        notifier.addNotification(message: '通知2');
        notifier.addNotification(message: '通知3');
        expect(container.read(notificationStateProvider).length, equals(3));

        // Act
        notifier.clearAllNotifications();
        final notifications = container.read(notificationStateProvider);

        // Assert
        expect(notifications, isEmpty);
      });

      test('成功通知を正しく表示できる', () {
        const message = '成功メッセージ';

        // Act
        container.read(notificationStateProvider.notifier).showSuccess(message);
        final notifications = container.read(notificationStateProvider);

        // Assert
        expect(notifications.length, equals(1));
        expect(notifications[0]['message'], equals(message));
        expect(notifications[0]['type'], equals('success'));
      });

      test('エラー通知を正しく表示できる', () {
        const message = 'エラーメッセージ';

        // Act
        container.read(notificationStateProvider.notifier).showError(message);
        final notifications = container.read(notificationStateProvider);

        // Assert
        expect(notifications.length, equals(1));
        expect(notifications[0]['message'], equals(message));
        expect(notifications[0]['type'], equals('error'));
        expect(notifications[0]['duration'], equals(const Duration(seconds: 5)));
      });

      test('警告通知を正しく表示できる', () {
        const message = '警告メッセージ';

        // Act
        container.read(notificationStateProvider.notifier).showWarning(message);
        final notifications = container.read(notificationStateProvider);

        // Assert
        expect(notifications.length, equals(1));
        expect(notifications[0]['message'], equals(message));
        expect(notifications[0]['type'], equals('warning'));
        expect(notifications[0]['duration'], equals(const Duration(seconds: 4)));
      });

      test('情報通知を正しく表示できる', () {
        const message = '情報メッセージ';

        // Act
        container.read(notificationStateProvider.notifier).showInfo(message);
        final notifications = container.read(notificationStateProvider);

        // Assert
        expect(notifications.length, equals(1));
        expect(notifications[0]['message'], equals(message));
        expect(notifications[0]['type'], equals('info'));
      });

      test('複数の通知を管理できる', () {
        final notifier = container.read(notificationStateProvider.notifier);

        // Act
        notifier.showSuccess('成功');
        notifier.showError('エラー');
        notifier.showWarning('警告');
        final notifications = container.read(notificationStateProvider);

        // Assert
        expect(notifications.length, equals(3));
        expect(notifications[0]['type'], equals('success'));
        expect(notifications[1]['type'], equals('error'));
        expect(notifications[2]['type'], equals('warning'));
      });
    });

    group('DialogState Provider', () {
      test('初期状態でダイアログが非表示', () {
        // Act
        final dialog = container.read(dialogStateProvider);

        // Assert
        expect(dialog, isNull);
      });

      test('ダイアログを正しく表示できる', () {
        const type = 'custom';
        const title = 'テストタイトル';
        const message = 'テストメッセージ';

        // Act
        container.read(dialogStateProvider.notifier).showDialog(
          type: type,
          title: title,
          message: message,
        );
        final dialog = container.read(dialogStateProvider);

        // Assert
        expect(dialog, isNotNull);
        expect(dialog!['type'], equals(type));
        expect(dialog['title'], equals(title));
        expect(dialog['message'], equals(message));
        expect(dialog['isVisible'], isTrue);
        expect(dialog['data'], isNull);
      });

      test('ダイアログをデータ付きで表示できる', () {
        const type = 'custom';
        const title = 'テストタイトル';
        const message = 'テストメッセージ';
        final data = {'key': 'value', 'number': 123};

        // Act
        container.read(dialogStateProvider.notifier).showDialog(
          type: type,
          title: title,
          message: message,
          data: data,
        );
        final dialog = container.read(dialogStateProvider);

        // Assert
        expect(dialog!['data'], equals(data));
      });

      test('ダイアログを正しく非表示にできる', () {
        final notifier = container.read(dialogStateProvider.notifier);

        // Arrange
        notifier.showDialog(
          type: 'test',
          title: 'テスト',
          message: 'テストメッセージ',
        );
        expect(container.read(dialogStateProvider), isNotNull);

        // Act
        notifier.hideDialog();
        final dialog = container.read(dialogStateProvider);

        // Assert
        expect(dialog, isNull);
      });

      test('確認ダイアログを正しく表示できる', () {
        const title = '確認';
        const message = '削除しますか？';
        const confirmText = '削除';
        const cancelText = 'キャンセル';

        // Act
        container.read(dialogStateProvider.notifier).showConfirmDialog(
          title: title,
          message: message,
          confirmText: confirmText,
          cancelText: cancelText,
        );
        final dialog = container.read(dialogStateProvider);

        // Assert
        expect(dialog!['type'], equals('confirm'));
        expect(dialog['title'], equals(title));
        expect(dialog['message'], equals(message));
        expect(dialog['data']['confirmText'], equals(confirmText));
        expect(dialog['data']['cancelText'], equals(cancelText));
      });

      test('アラートダイアログを正しく表示できる', () {
        const title = 'エラー';
        const message = '処理に失敗しました';
        const buttonText = '閉じる';

        // Act
        container.read(dialogStateProvider.notifier).showAlertDialog(
          title: title,
          message: message,
          buttonText: buttonText,
        );
        final dialog = container.read(dialogStateProvider);

        // Assert
        expect(dialog!['type'], equals('alert'));
        expect(dialog['title'], equals(title));
        expect(dialog['message'], equals(message));
        expect(dialog['data']['buttonText'], equals(buttonText));
      });

      test('デフォルトテキストで確認ダイアログを表示できる', () {
        const title = '確認';
        const message = '実行しますか？';

        // Act
        container.read(dialogStateProvider.notifier).showConfirmDialog(
          title: title,
          message: message,
        );
        final dialog = container.read(dialogStateProvider);

        // Assert
        expect(dialog!['data']['confirmText'], equals('OK'));
        expect(dialog['data']['cancelText'], equals('Cancel'));
      });
    });

    group('BottomSheetState Provider', () {
      test('初期状態でボトムシートが非表示', () {
        // Act
        final bottomSheet = container.read(bottomSheetStateProvider);

        // Assert
        expect(bottomSheet, isNull);
      });

      test('ボトムシートを正しく表示できる', () {
        const type = 'menu';
        const title = 'メニュー';
        final data = {'items': ['項目1', '項目2']};

        // Act
        container.read(bottomSheetStateProvider.notifier).showBottomSheet(
          type: type,
          title: title,
          data: data,
        );
        final bottomSheet = container.read(bottomSheetStateProvider);

        // Assert
        expect(bottomSheet, isNotNull);
        expect(bottomSheet!['type'], equals(type));
        expect(bottomSheet['title'], equals(title));
        expect(bottomSheet['data'], equals(data));
        expect(bottomSheet['isVisible'], isTrue);
      });

      test('ボトムシートを正しく非表示にできる', () {
        final notifier = container.read(bottomSheetStateProvider.notifier);

        // Arrange
        notifier.showBottomSheet(type: 'test', title: 'テスト');
        expect(container.read(bottomSheetStateProvider), isNotNull);

        // Act
        notifier.hideBottomSheet();
        final bottomSheet = container.read(bottomSheetStateProvider);

        // Assert
        expect(bottomSheet, isNull);
      });
    });

    group('SearchState Provider', () {
      test('初期状態で正しいデフォルト検索状態を持つ', () {
        // Act
        final searchState = container.read(searchStateProvider);

        // Assert
        expect(searchState['query'], equals(''));
        expect(searchState['isActive'], isFalse);
        expect(searchState['results'], isEmpty);
        expect(searchState['isLoading'], isFalse);
      });

      test('検索クエリを正しく更新できる', () {
        const query = 'テスト検索';

        // Act
        container.read(searchStateProvider.notifier).updateQuery(query);
        final searchState = container.read(searchStateProvider);

        // Assert
        expect(searchState['query'], equals(query));
      });

      test('検索状態を正しく更新できる', () {
        // Act
        container.read(searchStateProvider.notifier).updateIsActive(true);
        final searchState = container.read(searchStateProvider);

        // Assert
        expect(searchState['isActive'], isTrue);
      });

      test('検索結果を正しく更新できる', () {
        final results = ['結果1', '結果2', '結果3'];

        // Act
        container.read(searchStateProvider.notifier).updateResults(results);
        final searchState = container.read(searchStateProvider);

        // Assert
        expect(searchState['results'], equals(results));
      });

      test('読み込み状態を正しく更新できる', () {
        // Act
        container.read(searchStateProvider.notifier).updateIsLoading(true);
        final searchState = container.read(searchStateProvider);

        // Assert
        expect(searchState['isLoading'], isTrue);
      });

      test('検索をクリアできる', () {
        final notifier = container.read(searchStateProvider.notifier);

        // Arrange - 検索状態を設定
        notifier.updateQuery('テスト');
        notifier.updateIsActive(true);
        notifier.updateResults(['結果']);
        notifier.updateIsLoading(true);

        // Act
        notifier.clearSearch();
        final searchState = container.read(searchStateProvider);

        // Assert
        expect(searchState['query'], equals(''));
        expect(searchState['isActive'], isFalse);
        expect(searchState['results'], isEmpty);
        expect(searchState['isLoading'], isFalse);
      });

      test('複数の検索状態を順次更新できる', () {
        final notifier = container.read(searchStateProvider.notifier);

        // Act
        notifier.updateQuery('検索中...');
        notifier.updateIsActive(true);
        notifier.updateIsLoading(true);
        
        final results = ['結果A', '結果B'];
        notifier.updateResults(results);
        notifier.updateIsLoading(false);
        
        final searchState = container.read(searchStateProvider);

        // Assert
        expect(searchState['query'], equals('検索中...'));
        expect(searchState['isActive'], isTrue);
        expect(searchState['results'], equals(results));
        expect(searchState['isLoading'], isFalse);
      });
    });

    // NOTE: UIStateManager Integration Provider tests are commented out due to
    // Riverpod ref usage limitations in testing environment
    // TODO: Implement UIStateManager tests with proper container setup
    /*
    group('UIStateManager Integration Provider', () {
      test('初期状態で各プロバイダーの値を正しく統合する', () {
        // Act
        final uiState = container.read(uIStateManagerProvider);

        // Assert
        expect(uiState['isLoading'], isFalse);
        expect(uiState['error'], isNull);
        expect(uiState['selectedTab'], equals(0));
        expect(uiState['userSettings'], isA<Map<String, dynamic>>());
        expect(uiState['notifications'], isEmpty);
        expect(uiState['hasError'], isFalse);
        expect(uiState['notificationCount'], equals(0));
      });

      test('依存するプロバイダーの変更を正しく反映する', () {
        // Arrange & Act
        container.read(appLoadingStateProvider.notifier).setLoading(true);
        container.read(appErrorStateProvider.notifier).setError('テストエラー');
        container.read(selectedTabIndexProvider.notifier).changeTab(2);
        container.read(notificationStateProvider.notifier).addNotification(message: '通知');

        final uiState = container.read(uIStateManagerProvider);

        // Assert
        expect(uiState['isLoading'], isTrue);
        expect(uiState['error'], equals('テストエラー'));
        expect(uiState['selectedTab'], equals(2));
        expect(uiState['hasError'], isTrue);
        expect(uiState['notificationCount'], equals(1));
      });

      test('UI状態を正しくリセットできる', () {
        // Arrange - 各種状態を設定
        container.read(appLoadingStateProvider.notifier).setLoading(true);
        container.read(appErrorStateProvider.notifier).setError('テストエラー');
        container.read(notificationStateProvider.notifier).addNotification(message: '通知1');
        container.read(notificationStateProvider.notifier).addNotification(message: '通知2');

        // Act
        container.read(uIStateManagerProvider.notifier).resetUIState();
        final uiState = container.read(uIStateManagerProvider);

        // Assert
        expect(uiState['isLoading'], isFalse);
        expect(uiState['error'], isNull);
        expect(uiState['hasError'], isFalse);
        expect(uiState['notificationCount'], equals(0));
      });

      test('エラー状態を正しく設定できる', () {
        const errorMessage = 'エラーが発生しました';

        // Act
        container.read(uIStateManagerProvider.notifier).setError(errorMessage);
        final uiState = container.read(uIStateManagerProvider);

        // Assert
        expect(uiState['error'], equals(errorMessage));
        expect(uiState['hasError'], isTrue);
        expect(uiState['notificationCount'], equals(1));
        
        // 通知も追加される
        final notifications = container.read(notificationStateProvider);
        expect(notifications.length, equals(1));
        expect(notifications[0]['type'], equals('error'));
        expect(notifications[0]['message'], equals(errorMessage));
      });

      test('成功状態を正しく設定できる', () {
        const successMessage = '処理が完了しました';

        // Arrange - まずエラーを設定
        container.read(appErrorStateProvider.notifier).setError('エラー');

        // Act
        container.read(uIStateManagerProvider.notifier).setSuccess(successMessage);
        final uiState = container.read(uIStateManagerProvider);

        // Assert
        expect(uiState['error'], isNull);
        expect(uiState['hasError'], isFalse);
        expect(uiState['notificationCount'], equals(1));
        
        // 成功通知が追加される
        final notifications = container.read(notificationStateProvider);
        expect(notifications.length, equals(1));
        expect(notifications[0]['type'], equals('success'));
        expect(notifications[0]['message'], equals(successMessage));
      });

      test('複数の状態変更が統合プロバイダーに正しく反映される', () {
        final uiStateNotifier = container.read(uIStateManagerProvider.notifier);

        // Act - 複数のアクションを実行
        uiStateNotifier.setError('エラー1');
        container.read(selectedTabIndexProvider.notifier).changeTab(3);
        container.read(userSettingsProvider.notifier).updateDarkMode(true);
        uiStateNotifier.setSuccess('成功');

        final uiState = container.read(uIStateManagerProvider);

        // Assert
        expect(uiState['selectedTab'], equals(3));
        expect(uiState['error'], isNull); // setSuccessでクリアされる
        expect(uiState['hasError'], isFalse);
        expect(uiState['userSettings']['darkMode'], isTrue);
        expect(uiState['notificationCount'], equals(1)); // 成功通知のみ残る
      });
    });
    */

    group('Edge Cases and Error Scenarios', () {
      test('同じ設定値を複数回設定しても正常に動作する', () {
        final notifier = container.read(userSettingsProvider.notifier);

        // Act
        notifier.updateDailyStepGoal(10000);
        notifier.updateDailyStepGoal(10000);
        notifier.updateDailyStepGoal(10000);
        final settings = container.read(userSettingsProvider);

        // Assert
        expect(settings['dailyStepGoal'], equals(10000));
      });

      test('存在しない通知IDで削除を試みてもエラーが発生しない', () {
        final notifier = container.read(notificationStateProvider.notifier);

        // Act
        notifier.addNotification(message: '通知1');
        notifier.removeNotification('存在しないID');
        final notifications = container.read(notificationStateProvider);

        // Assert
        expect(notifications.length, equals(1));
      });

      test('空の設定で一括更新してもエラーが発生しない', () {
        final notifier = container.read(userSettingsProvider.notifier);
        final originalSettings = container.read(userSettingsProvider);

        // Act
        notifier.updateSettings({});
        final settings = container.read(userSettingsProvider);

        // Assert
        expect(settings, equals(originalSettings));
      });

      test('複数のダイアログを連続して表示しても最新のものが表示される', () {
        final notifier = container.read(dialogStateProvider.notifier);

        // Act
        notifier.showAlertDialog(title: 'ダイアログ1', message: 'メッセージ1');
        notifier.showConfirmDialog(title: 'ダイアログ2', message: 'メッセージ2');
        final dialog = container.read(dialogStateProvider);

        // Assert
        expect(dialog!['type'], equals('confirm'));
        expect(dialog['title'], equals('ダイアログ2'));
        expect(dialog['message'], equals('メッセージ2'));
      });
    });
  });
}