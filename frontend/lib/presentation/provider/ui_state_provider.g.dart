// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ui_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appLoadingStateHash() => r'e7a0dc81222b60f5f6693f33d947bbefe489bf77';

/// アプリの読み込み状態を管理するプロバイダー
///
/// Copied from [AppLoadingState].
@ProviderFor(AppLoadingState)
final appLoadingStateProvider =
    AutoDisposeNotifierProvider<AppLoadingState, bool>.internal(
  AppLoadingState.new,
  name: r'appLoadingStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$appLoadingStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AppLoadingState = AutoDisposeNotifier<bool>;
String _$appErrorStateHash() => r'90331558443c3babb1ee34a2984d58ecc52f5a59';

/// エラー状態を管理するプロバイダー
///
/// Copied from [AppErrorState].
@ProviderFor(AppErrorState)
final appErrorStateProvider =
    AutoDisposeNotifierProvider<AppErrorState, String?>.internal(
  AppErrorState.new,
  name: r'appErrorStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$appErrorStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AppErrorState = AutoDisposeNotifier<String?>;
String _$selectedTabIndexHash() => r'6c283c3577bc75458ff27012035ff5897cd3f79f';

/// 現在選択されているタブインデックスプロバイダー
///
/// Copied from [SelectedTabIndex].
@ProviderFor(SelectedTabIndex)
final selectedTabIndexProvider =
    AutoDisposeNotifierProvider<SelectedTabIndex, int>.internal(
  SelectedTabIndex.new,
  name: r'selectedTabIndexProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedTabIndexHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedTabIndex = AutoDisposeNotifier<int>;
String _$userSettingsHash() => r'85c31d85c830b279d74f57ee888f5f51858026a3';

/// ユーザー設定プロバイダー
///
/// Copied from [UserSettings].
@ProviderFor(UserSettings)
final userSettingsProvider =
    AutoDisposeNotifierProvider<UserSettings, Map<String, dynamic>>.internal(
  UserSettings.new,
  name: r'userSettingsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userSettingsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$UserSettings = AutoDisposeNotifier<Map<String, dynamic>>;
String _$calendarViewSettingsHash() =>
    r'69c07496d47e0ff181da099a1b613f18c0666543';

/// カレンダー表示設定プロバイダー
///
/// Copied from [CalendarViewSettings].
@ProviderFor(CalendarViewSettings)
final calendarViewSettingsProvider = AutoDisposeNotifierProvider<
    CalendarViewSettings, Map<String, dynamic>>.internal(
  CalendarViewSettings.new,
  name: r'calendarViewSettingsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$calendarViewSettingsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CalendarViewSettings = AutoDisposeNotifier<Map<String, dynamic>>;
String _$statisticsViewSettingsHash() =>
    r'a17c8d43049d30774f911c4bb8b709f51253fe0e';

/// 統計画面の設定プロバイダー
///
/// Copied from [StatisticsViewSettings].
@ProviderFor(StatisticsViewSettings)
final statisticsViewSettingsProvider = AutoDisposeNotifierProvider<
    StatisticsViewSettings, Map<String, dynamic>>.internal(
  StatisticsViewSettings.new,
  name: r'statisticsViewSettingsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$statisticsViewSettingsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$StatisticsViewSettings = AutoDisposeNotifier<Map<String, dynamic>>;
String _$socialViewSettingsHash() =>
    r'f2f82b4e5dc55457cf20cc1be4987b001c186d50';

/// ソーシャル画面の設定プロバイダー
///
/// Copied from [SocialViewSettings].
@ProviderFor(SocialViewSettings)
final socialViewSettingsProvider = AutoDisposeNotifierProvider<
    SocialViewSettings, Map<String, dynamic>>.internal(
  SocialViewSettings.new,
  name: r'socialViewSettingsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$socialViewSettingsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SocialViewSettings = AutoDisposeNotifier<Map<String, dynamic>>;
String _$notificationStateHash() => r'50053ba56bd8683610677efd53d66b89a818e37c';

/// 通知状態プロバイダー
///
/// Copied from [NotificationState].
@ProviderFor(NotificationState)
final notificationStateProvider = AutoDisposeNotifierProvider<NotificationState,
    List<Map<String, dynamic>>>.internal(
  NotificationState.new,
  name: r'notificationStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$NotificationState = AutoDisposeNotifier<List<Map<String, dynamic>>>;
String _$dialogStateHash() => r'5d111e0fd11be66eec80eb49a17f2a40ba7a5051';

/// ダイアログ状態プロバイダー
///
/// Copied from [DialogState].
@ProviderFor(DialogState)
final dialogStateProvider =
    AutoDisposeNotifierProvider<DialogState, Map<String, dynamic>?>.internal(
  DialogState.new,
  name: r'dialogStateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$dialogStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DialogState = AutoDisposeNotifier<Map<String, dynamic>?>;
String _$bottomSheetStateHash() => r'3b3ecb1e29529e84ec18ffd5131f205ce07c020a';

/// ボトムシート状態プロバイダー
///
/// Copied from [BottomSheetState].
@ProviderFor(BottomSheetState)
final bottomSheetStateProvider = AutoDisposeNotifierProvider<BottomSheetState,
    Map<String, dynamic>?>.internal(
  BottomSheetState.new,
  name: r'bottomSheetStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$bottomSheetStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$BottomSheetState = AutoDisposeNotifier<Map<String, dynamic>?>;
String _$searchStateHash() => r'85ca0f5e415fa0fbdae4e7dd48a722362ce002e4';

/// 検索状態プロバイダー
///
/// Copied from [SearchState].
@ProviderFor(SearchState)
final searchStateProvider =
    AutoDisposeNotifierProvider<SearchState, Map<String, dynamic>>.internal(
  SearchState.new,
  name: r'searchStateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$searchStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SearchState = AutoDisposeNotifier<Map<String, dynamic>>;
String _$uIStateManagerHash() => r'0bff582497a2a82bad2961b4a3a55c74579765c2';

/// UI状態の統合プロバイダー
///
/// Copied from [UIStateManager].
@ProviderFor(UIStateManager)
final uIStateManagerProvider =
    AutoDisposeNotifierProvider<UIStateManager, Map<String, dynamic>>.internal(
  UIStateManager.new,
  name: r'uIStateManagerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$uIStateManagerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$UIStateManager = AutoDisposeNotifier<Map<String, dynamic>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
