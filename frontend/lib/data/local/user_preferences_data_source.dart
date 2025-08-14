import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/core/entity/user_profile.dart';
import 'model/user_profile_model.dart';

/// ユーザー設定のローカルデータソース
/// Hiveを使用してユーザープロフィールと設定をローカルに保存・取得する
class UserPreferencesDataSource {
  static const String _boxName = 'user_preferences';
  static const String _profileKey = 'user_profile';
  static const String _settingsKey = 'app_settings';

  late Box<dynamic> _box;

  /// 初期化
  Future<void> initialize() async {
    await Hive.initFlutter();

    // アダプターの登録
    if (!Hive.isAdapterRegistered(UserProfileModelAdapter().typeId)) {
      Hive.registerAdapter(UserProfileModelAdapter());
    }

    _box = await Hive.openBox<dynamic>(_boxName);
  }

  /// テスト用初期化（Hive.initFlutterを使わない）
  Future<void> initializeForTest() async {
    // アダプターの登録
    if (!Hive.isAdapterRegistered(UserProfileModelAdapter().typeId)) {
      Hive.registerAdapter(UserProfileModelAdapter());
    }

    _box = await Hive.openBox<dynamic>(_boxName);
  }

  /// ユーザープロフィールを保存
  Future<void> saveUserProfile(UserProfile profile) async {
    final model = UserProfileModel.fromEntity(profile);
    await _box.put(_profileKey, model);
  }

  /// ユーザープロフィールを取得
  Future<UserProfile?> getUserProfile() async {
    final model = _box.get(_profileKey) as UserProfileModel?;
    return model?.toEntity();
  }

  /// 歩数目標を保存
  Future<void> saveDailyStepGoal(int goal) async {
    await _box.put('daily_step_goal', goal);
  }

  /// 歩数目標を取得
  Future<int> getDailyStepGoal() async {
    return _box.get('daily_step_goal', defaultValue: 8000) as int;
  }

  /// 通知設定を保存
  Future<void> saveNotificationSettings(bool enabled) async {
    await _box.put('notifications_enabled', enabled);
  }

  /// 通知設定を取得
  Future<bool> getNotificationSettings() async {
    return _box.get('notifications_enabled', defaultValue: true) as bool;
  }

  /// プライバシーレベルを保存
  Future<void> savePrivacyLevel(PrivacyLevel level) async {
    await _box.put('privacy_level', level.id);
  }

  /// プライバシーレベルを取得
  Future<PrivacyLevel> getPrivacyLevel() async {
    final levelId =
        _box.get('privacy_level', defaultValue: PrivacyLevel.friends.id)
            as String;
    return PrivacyLevel.values.firstWhere(
      (level) => level.id == levelId,
      orElse: () => PrivacyLevel.friends,
    );
  }

  /// 言語設定を保存
  Future<void> saveLanguage(String language) async {
    await _box.put('language', language);
  }

  /// 言語設定を取得
  Future<String> getLanguage() async {
    return _box.get('language', defaultValue: 'en') as String;
  }

  /// タイムゾーンを保存
  Future<void> saveTimezone(String timezone) async {
    await _box.put('timezone', timezone);
  }

  /// タイムゾーンを取得
  Future<String> getTimezone() async {
    return _box.get('timezone', defaultValue: 'UTC') as String;
  }

  /// テーマ設定を保存
  Future<void> saveThemeMode(String themeMode) async {
    await _box.put('theme_mode', themeMode);
  }

  /// テーマ設定を取得
  Future<String> getThemeMode() async {
    return _box.get('theme_mode', defaultValue: 'system') as String;
  }

  /// 初回起動フラグを保存
  Future<void> setFirstLaunch(bool isFirstLaunch) async {
    await _box.put('is_first_launch', isFirstLaunch);
  }

  /// 初回起動かどうかを取得
  Future<bool> isFirstLaunch() async {
    return _box.get('is_first_launch', defaultValue: true) as bool;
  }

  /// オンボーディング完了フラグを保存
  Future<void> setOnboardingCompleted(bool completed) async {
    await _box.put('onboarding_completed', completed);
  }

  /// オンボーディングが完了しているかを取得
  Future<bool> isOnboardingCompleted() async {
    return _box.get('onboarding_completed', defaultValue: false) as bool;
  }

  /// ヘルスデータ許可状態を保存
  Future<void> saveHealthPermissionGranted(bool granted) async {
    await _box.put('health_permission_granted', granted);
  }

  /// ヘルスデータ許可状態を取得
  Future<bool> isHealthPermissionGranted() async {
    return _box.get('health_permission_granted', defaultValue: false) as bool;
  }

  /// 最後の同期日時を保存
  Future<void> saveLastSyncTime(DateTime syncTime) async {
    await _box.put('last_sync_time', syncTime.toIso8601String());
  }

  /// 最後の同期日時を取得
  Future<DateTime?> getLastSyncTime() async {
    final syncTimeString = _box.get('last_sync_time') as String?;
    return syncTimeString != null ? DateTime.parse(syncTimeString) : null;
  }

  /// アプリ設定を一括保存
  Future<void> saveAppSettings(Map<String, dynamic> settings) async {
    await _box.put(_settingsKey, settings);
  }

  /// アプリ設定を一括取得
  Future<Map<String, dynamic>> getAppSettings() async {
    final settings = _box.get(_settingsKey) as Map<String, dynamic>?;
    return settings ?? <String, dynamic>{};
  }

  /// 特定の設定値を保存
  Future<void> saveSetting(String key, dynamic value) async {
    await _box.put('setting_$key', value);
  }

  /// 特定の設定値を取得
  Future<T?> getSetting<T>(String key, {T? defaultValue}) async {
    return _box.get('setting_$key', defaultValue: defaultValue) as T?;
  }

  /// 設定値が存在するかチェック
  bool hasSetting(String key) {
    return _box.containsKey('setting_$key');
  }

  /// 特定の設定を削除
  Future<void> deleteSetting(String key) async {
    await _box.delete('setting_$key');
  }

  /// すべての設定をリセット
  Future<void> resetAllSettings() async {
    await _box.clear();
  }

  /// ユーザープロフィールを削除
  Future<void> deleteUserProfile() async {
    await _box.delete(_profileKey);
  }

  /// 設定の統計情報を取得
  Map<String, dynamic> getSettingsStatistics() {
    final keys = _box.keys.toList();
    final settingKeys = keys
        .where((key) => key.toString().startsWith('setting_'))
        .toList();

    return {
      'totalKeys': keys.length,
      'settingKeys': settingKeys.length,
      'hasProfile': _box.containsKey(_profileKey),
      'hasAppSettings': _box.containsKey(_settingsKey),
    };
  }

  /// データベースを閉じる
  Future<void> close() async {
    await _box.close();
  }

  /// データが存在するかチェック
  bool get hasUserProfile => _box.containsKey(_profileKey);

  /// 設定データの件数を取得
  int get settingsCount => _box.length;
}
