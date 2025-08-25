/// ヘルスデータの種類を表すEnum
enum HealthDataType {
  /// 歩数
  stepCount('step_count', 'Steps', 'steps'),

  /// 距離
  distance('distance', 'Distance', 'km'),

  /// 消費カロリー
  caloriesBurned('calories_burned', 'Calories', 'kcal'),

  /// アクティブ時間
  activeTime('active_time', 'Active Time', 'min');

  const HealthDataType(this.id, this.displayName, this.unit);

  /// データタイプID
  final String id;

  /// 表示名
  final String displayName;

  /// 単位
  final String unit;
}

/// データ同期状態を表すEnum
enum SyncStatus {
  /// 同期済み
  synced('synced', 'Synced'),

  /// 同期中
  syncing('syncing', 'Syncing'),

  /// 同期失敗
  failed('failed', 'Failed'),

  /// 未同期
  pending('pending', 'Pending');

  const SyncStatus(this.id, this.displayName);

  /// ステータスID
  final String id;

  /// 表示名
  final String displayName;
}

/// 日付範囲を表すEnum
enum DateRangeType {
  /// 今日
  today('today', 'Today'),

  /// 今週
  thisWeek('this_week', 'This Week'),

  /// 今月
  thisMonth('this_month', 'This Month'),

  /// 今年
  thisYear('this_year', 'This Year'),

  /// カスタム範囲
  custom('custom', 'Custom Range');

  const DateRangeType(this.id, this.displayName);

  /// 範囲タイプID
  final String id;

  /// 表示名
  final String displayName;
}
