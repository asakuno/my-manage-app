/// アプリケーション全体で使用される定数クラス
class AppConstants {
  AppConstants._();

  /// アプリ名
  static const String appName = 'Health Activity Visualization';

  /// アプリバージョン
  static const String appVersion = '1.0.0';

  /// デフォルトの歩数目標
  static const int defaultStepGoal = 8000;

  /// アクティビティレベルの閾値
  static const List<int> activityLevelThresholds = [
    2000, // low
    5000, // medium
    8000, // high
    12000, // very high
  ];

  /// 最大友達数（無料プラン）
  static const int maxFriendsCountFree = 10;

  /// 最大友達数（プレミアムプラン）
  static const int maxFriendsCountPremium = 50;

  /// データ同期間隔（分）
  static const int syncIntervalMinutes = 15;

  /// ローカルデータ保持期間（日）
  static const int dataRetentionDays = 365;

  /// API タイムアウト（秒）
  static const int apiTimeoutSeconds = 30;

  /// 最小歩数目標
  static const int minStepGoal = 1000;

  /// 最大歩数目標
  static const int maxStepGoal = 50000;

  /// デフォルトのプライバシーレベル
  static const String defaultPrivacyLevel = 'friends';

  /// サポートされる言語
  static const List<String> supportedLanguages = ['en', 'ja'];

  /// デフォルト言語
  static const String defaultLanguage = 'en';
}
