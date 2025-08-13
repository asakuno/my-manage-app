import 'package:health/health.dart';

/// ヘルスデータ関連の定数定義
class HealthConstants {
  // 取得するヘルスデータタイプ
  static const List<HealthDataType> dataTypes = [
    HealthDataType.STEPS,
    HealthDataType.DISTANCE_WALKING_RUNNING,
    HealthDataType.ACTIVE_ENERGY_BURNED,
  ];

  // ヘルスデータアクセス権限
  static const List<HealthDataAccess> permissions = [
    HealthDataAccess.READ,
    HealthDataAccess.READ,
    HealthDataAccess.READ,
  ];

  // データ取得期間設定
  static const int defaultDataRangeDays = 365;
  static const int maxDataRangeDays = 730; // 2年
  static const int minDataRangeDays = 1;

  // 同期設定
  static const Duration backgroundSyncInterval = Duration(hours: 2);
  static const Duration foregroundSyncInterval = Duration(minutes: 15);
  static const int maxRetryAttempts = 3;
  static const Duration retryDelay = Duration(seconds: 30);

  // データ検証設定
  static const int maxReasonableStepsPerDay = 100000;
  static const int minReasonableStepsPerDay = 0;
  static const double maxReasonableDistanceKm = 200.0;
  static const int maxReasonableCalories = 10000;

  // キャッシュ設定
  static const Duration cacheValidityPeriod = Duration(hours: 6);
  static const int maxCachedDays = 90;

  // プライベートコンストラクタ
  HealthConstants._();
}
