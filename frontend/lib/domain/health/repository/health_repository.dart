import '../../core/entity/health_data.dart';
import '../../core/type/health_data_type.dart';

/// ヘルスデータリポジトリの抽象クラス
/// ヘルスデータの取得、同期、権限管理を担当する
abstract class HealthRepository {
  /// 指定期間の歩数データを取得
  /// [startDate] 開始日
  /// [endDate] 終了日
  /// Returns: HealthDataのリスト
  Future<List<HealthData>> getStepData({
    required DateTime startDate,
    required DateTime endDate,
  });

  /// 今日の歩数データを取得
  /// Returns: 今日のHealthData、データがない場合はnull
  Future<HealthData?> getTodayStepData();

  /// 特定日の歩数データを取得
  /// [date] 対象日
  /// Returns: 指定日のHealthData、データがない場合はnull
  Future<HealthData?> getStepDataForDate(DateTime date);

  /// ヘルスデータへのアクセス権限を要求
  /// Returns: 権限が許可された場合true
  Future<bool> requestHealthPermission();

  /// ヘルスデータのアクセス権限状態を確認
  /// Returns: 権限が許可されている場合true
  Future<bool> hasHealthPermission();

  /// ヘルスデータを同期
  /// ローカルストレージとデバイスのヘルスアプリを同期する
  Future<void> syncHealthData();

  /// 今日の歩数データをリアルタイムで監視
  /// Returns: 今日の歩数データのStream
  Stream<HealthData?> watchTodaySteps();

  /// 指定期間のヘルスデータをリアルタイムで監視
  /// [startDate] 開始日
  /// [endDate] 終了日
  /// Returns: HealthDataのリストのStream
  Stream<List<HealthData>> watchHealthData({
    required DateTime startDate,
    required DateTime endDate,
  });

  /// ヘルスデータの同期状態を監視
  /// Returns: 同期状態のStream
  Stream<SyncStatus> watchSyncStatus();

  /// ローカルに保存されたヘルスデータを削除
  /// [startDate] 削除開始日（オプション）
  /// [endDate] 削除終了日（オプション）
  Future<void> clearLocalHealthData({DateTime? startDate, DateTime? endDate});

  /// ヘルスデータの統計情報を取得
  /// [period] 統計期間
  /// Returns: 統計データのMap
  Future<Map<String, dynamic>> getHealthStatistics({
    required DateRangeType period,
    DateTime? startDate,
    DateTime? endDate,
  });

  /// バックグラウンド同期を設定
  /// [enabled] バックグラウンド同期を有効にするかどうか
  Future<void> setBackgroundSyncEnabled(bool enabled);

  /// 最後の同期日時を取得
  /// Returns: 最後の同期日時、同期したことがない場合はnull
  Future<DateTime?> getLastSyncTime();
}
