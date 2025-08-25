import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/core/entity/health_data.dart';
import '../../domain/core/type/health_data_type.dart';
import 'model/health_data_model.dart';

/// ヘルスデータのローカルデータソース
/// Hiveを使用してヘルスデータをローカルに保存・取得する
class HealthLocalDataSource {
  static const String _boxName = 'health_data';
  late Box<HealthDataModel> _box;

  /// 初期化
  Future<void> initialize() async {
    await Hive.initFlutter();

    // アダプターの登録
    if (!Hive.isAdapterRegistered(HealthDataModelAdapter().typeId)) {
      Hive.registerAdapter(HealthDataModelAdapter());
    }

    _box = await Hive.openBox<HealthDataModel>(_boxName);
  }

  /// テスト用初期化（Hive.initFlutterを使わない）
  Future<void> initializeForTest() async {
    // アダプターの登録
    if (!Hive.isAdapterRegistered(HealthDataModelAdapter().typeId)) {
      Hive.registerAdapter(HealthDataModelAdapter());
    }

    _box = await Hive.openBox<HealthDataModel>(_boxName);
  }

  /// ヘルスデータを保存
  Future<void> saveHealthData(HealthData healthData) async {
    final model = HealthDataModel.fromEntity(healthData);
    final key = _generateKey(healthData.date);
    await _box.put(key, model);
  }

  /// 複数のヘルスデータを一括保存
  Future<void> saveHealthDataList(List<HealthData> healthDataList) async {
    final Map<String, HealthDataModel> dataMap = {};

    for (final healthData in healthDataList) {
      final model = HealthDataModel.fromEntity(healthData);
      final key = _generateKey(healthData.date);
      dataMap[key] = model;
    }

    await _box.putAll(dataMap);
  }

  /// 特定の日のヘルスデータを取得
  Future<HealthData?> getHealthData(DateTime date) async {
    final key = _generateKey(date);
    final model = _box.get(key);
    return model?.toEntity();
  }

  /// 日付範囲でヘルスデータを取得
  Future<List<HealthData>> getHealthDataRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final List<HealthData> result = [];

    // 日付範囲内のすべての日をチェック
    DateTime currentDate = DateTime(
      startDate.year,
      startDate.month,
      startDate.day,
    );
    final end = DateTime(endDate.year, endDate.month, endDate.day);

    while (!currentDate.isAfter(end)) {
      final key = _generateKey(currentDate);
      final model = _box.get(key);

      if (model != null) {
        result.add(model.toEntity());
      }

      currentDate = currentDate.add(const Duration(days: 1));
    }

    return result;
  }

  /// 最新のヘルスデータを取得
  Future<HealthData?> getLatestHealthData() async {
    if (_box.isEmpty) return null;

    final models = _box.values.toList();
    models.sort((a, b) => b.date.compareTo(a.date));

    return models.first.toEntity();
  }

  /// 同期が必要なデータを取得
  Future<List<HealthData>> getPendingSyncData() async {
    final models = _box.values
        .where(
          (model) =>
              model.syncStatus == SyncStatus.pending.id ||
              model.syncStatus == SyncStatus.failed.id,
        )
        .toList();

    return models.map((model) => model.toEntity()).toList();
  }

  /// ヘルスデータを削除
  Future<void> deleteHealthData(DateTime date) async {
    final key = _generateKey(date);
    await _box.delete(key);
  }

  /// 日付範囲のヘルスデータを削除
  Future<void> deleteHealthDataRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final keysToDelete = <String>[];

    DateTime currentDate = DateTime(
      startDate.year,
      startDate.month,
      startDate.day,
    );
    final end = DateTime(endDate.year, endDate.month, endDate.day);

    while (!currentDate.isAfter(end)) {
      keysToDelete.add(_generateKey(currentDate));
      currentDate = currentDate.add(const Duration(days: 1));
    }

    await _box.deleteAll(keysToDelete);
  }

  /// すべてのヘルスデータを削除
  Future<void> clearAllHealthData() async {
    await _box.clear();
  }

  /// データ数を取得
  int get dataCount => _box.length;

  /// データが存在するかチェック
  bool hasData(DateTime date) {
    final key = _generateKey(date);
    return _box.containsKey(key);
  }

  /// 統計情報を取得
  Future<Map<String, dynamic>> getStatistics() async {
    if (_box.isEmpty) {
      return {
        'totalDays': 0,
        'averageSteps': 0.0,
        'maxSteps': 0,
        'totalSteps': 0,
      };
    }

    final models = _box.values.toList();
    final totalSteps = models.fold<int>(
      0,
      (sum, model) => sum + model.stepCount,
    );
    final maxSteps = models
        .map((model) => model.stepCount)
        .reduce((a, b) => a > b ? a : b);

    return {
      'totalDays': models.length,
      'averageSteps': totalSteps / models.length,
      'maxSteps': maxSteps,
      'totalSteps': totalSteps,
    };
  }

  /// データベースを閉じる
  Future<void> close() async {
    await _box.close();
  }

  /// 日付からキーを生成
  String _generateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
