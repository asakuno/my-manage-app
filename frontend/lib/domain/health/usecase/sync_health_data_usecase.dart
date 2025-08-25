import '../repository/health_repository.dart';
import '../../core/type/health_data_type.dart';

/// ヘルスデータ同期ユースケース
/// デバイスのヘルスアプリとローカルストレージの同期を管理する
class SyncHealthDataUseCase {
  const SyncHealthDataUseCase(this._healthRepository);

  final HealthRepository _healthRepository;

  /// ヘルスデータを同期
  /// Returns: 同期が成功した場合true
  Future<bool> call() async {
    try {
      // 権限チェック
      final hasPermission = await _healthRepository.hasHealthPermission();
      if (!hasPermission) {
        throw HealthSyncException('Health permission not granted');
      }

      // データ同期実行
      await _healthRepository.syncHealthData();
      return true;
    } catch (e) {
      throw HealthSyncException('Failed to sync health data: $e');
    }
  }

  /// 権限を要求してからデータを同期
  /// Returns: 同期が成功した場合true
  Future<bool> requestPermissionAndSync() async {
    try {
      // 権限要求
      final permissionGranted = await _healthRepository
          .requestHealthPermission();
      if (!permissionGranted) {
        throw HealthSyncException('Health permission denied by user');
      }

      // データ同期実行
      await _healthRepository.syncHealthData();
      return true;
    } catch (e) {
      throw HealthSyncException('Failed to request permission and sync: $e');
    }
  }

  /// バックグラウンド同期を設定
  /// [enabled] バックグラウンド同期を有効にするかどうか
  /// Returns: 設定が成功した場合true
  Future<bool> setBackgroundSync(bool enabled) async {
    try {
      await _healthRepository.setBackgroundSyncEnabled(enabled);
      return true;
    } catch (e) {
      throw HealthSyncException('Failed to set background sync: $e');
    }
  }

  /// 同期状態を監視
  /// Returns: 同期状態のStream
  Stream<SyncStatus> watchSyncStatus() {
    return _healthRepository.watchSyncStatus();
  }

  /// 最後の同期日時を取得
  /// Returns: 最後の同期日時、同期したことがない場合はnull
  Future<DateTime?> getLastSyncTime() async {
    try {
      return await _healthRepository.getLastSyncTime();
    } catch (e) {
      throw HealthSyncException('Failed to get last sync time: $e');
    }
  }

  /// 同期が必要かどうかを判定
  /// [maxHoursSinceLastSync] 最後の同期からの最大時間（デフォルト: 24時間）
  /// Returns: 同期が必要な場合true
  Future<bool> needsSync({int maxHoursSinceLastSync = 24}) async {
    try {
      final lastSyncTime = await getLastSyncTime();

      // 一度も同期していない場合は同期が必要
      if (lastSyncTime == null) {
        return true;
      }

      // 指定時間以上経過している場合は同期が必要
      final hoursSinceLastSync = DateTime.now()
          .difference(lastSyncTime)
          .inHours;
      return hoursSinceLastSync >= maxHoursSinceLastSync;
    } catch (e) {
      // エラーが発生した場合は安全のため同期が必要と判定
      return true;
    }
  }

  /// 自動同期を実行
  /// 必要に応じて同期を実行する
  /// [maxHoursSinceLastSync] 最後の同期からの最大時間（デフォルト: 24時間）
  /// Returns: 同期を実行した場合true、不要だった場合false
  Future<bool> autoSync({int maxHoursSinceLastSync = 24}) async {
    try {
      final syncNeeded = await needsSync(
        maxHoursSinceLastSync: maxHoursSinceLastSync,
      );

      if (!syncNeeded) {
        return false;
      }

      await call();
      return true;
    } catch (e) {
      throw HealthSyncException('Failed to auto sync: $e');
    }
  }

  /// 強制同期を実行
  /// 最後の同期時間に関係なく同期を実行する
  /// Returns: 同期が成功した場合true
  Future<bool> forceSync() async {
    return await call();
  }

  /// ローカルデータをクリア
  /// [startDate] 削除開始日（オプション）
  /// [endDate] 削除終了日（オプション）
  /// Returns: クリアが成功した場合true
  Future<bool> clearLocalData({DateTime? startDate, DateTime? endDate}) async {
    try {
      await _healthRepository.clearLocalHealthData(
        startDate: startDate,
        endDate: endDate,
      );
      return true;
    } catch (e) {
      throw HealthSyncException('Failed to clear local data: $e');
    }
  }

  /// 同期エラーの詳細情報を取得
  /// Returns: エラー情報のMap
  Future<Map<String, dynamic>> getSyncErrorInfo() async {
    try {
      final hasPermission = await _healthRepository.hasHealthPermission();
      final lastSyncTime = await _healthRepository.getLastSyncTime();

      return {
        'hasPermission': hasPermission,
        'lastSyncTime': lastSyncTime?.toIso8601String(),
        'hoursSinceLastSync': lastSyncTime != null
            ? DateTime.now().difference(lastSyncTime).inHours
            : null,
      };
    } catch (e) {
      return {'error': e.toString()};
    }
  }
}

/// ヘルスデータ同期関連の例外クラス
class HealthSyncException implements Exception {
  const HealthSyncException(this.message);

  final String message;

  @override
  String toString() => 'HealthSyncException: $message';
}
