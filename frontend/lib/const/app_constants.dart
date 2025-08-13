/// アプリケーション全体で使用される定数を定義
class AppConstants {
  // アプリ基本情報
  static const String appName = 'Health Activity Visualization';
  static const String appVersion = '1.0.0';

  // デフォルト設定
  static const int defaultStepGoal = 8000;
  static const int minStepGoal = 1000;
  static const int maxStepGoal = 50000;

  // アクティビティレベルの閾値（歩数）
  static const List<int> activityLevelThresholds = [
    2000, // Level 1: 0-2000歩
    5000, // Level 2: 2001-5000歩
    8000, // Level 3: 5001-8000歩
    12000, // Level 4: 8001歩以上
  ];

  // データ同期設定
  static const Duration syncInterval = Duration(hours: 1);
  static const Duration cacheExpiration = Duration(days: 7);

  // UI設定
  static const int calendarDaysToShow = 365;
  static const double activityCellSize = 12.0;
  static const double activityCellSpacing = 2.0;

  // 友達機能制限
  static const int freeTierFriendLimit = 10;
  static const int premiumTierFriendLimit = 50;

  // プライベートコンストラクタ（インスタンス化を防ぐ）
  AppConstants._();
}
