import '../repository/health_repository.dart';
import '../../core/entity/health_data.dart';

/// 歩数データ取得ユースケース
/// 指定期間の歩数データを取得し、ビジネスロジックを適用する
class GetStepDataUseCase {
  const GetStepDataUseCase(this._healthRepository);

  final HealthRepository _healthRepository;

  /// 指定期間の歩数データを取得
  /// [startDate] 開始日
  /// [endDate] 終了日
  /// Returns: HealthDataのリスト
  Future<List<HealthData>> call({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    // 日付の妥当性チェック
    if (startDate.isAfter(endDate)) {
      throw ArgumentError('Start date must be before or equal to end date');
    }

    // 未来の日付をチェック
    final now = DateTime.now();
    final adjustedEndDate = endDate.isAfter(now)
        ? DateTime(now.year, now.month, now.day)
        : endDate;

    try {
      final healthDataList = await _healthRepository.getStepData(
        startDate: startDate,
        endDate: adjustedEndDate,
      );

      // データを日付順にソート
      healthDataList.sort((a, b) => a.date.compareTo(b.date));

      return healthDataList;
    } catch (e) {
      throw HealthDataException('Failed to get step data: $e');
    }
  }

  /// 今日の歩数データを取得
  /// Returns: 今日のHealthData、データがない場合はnull
  Future<HealthData?> getTodayStepData() async {
    try {
      return await _healthRepository.getTodayStepData();
    } catch (e) {
      throw HealthDataException('Failed to get today step data: $e');
    }
  }

  /// 特定日の歩数データを取得
  /// [date] 対象日
  /// Returns: 指定日のHealthData、データがない場合はnull
  Future<HealthData?> getStepDataForDate(DateTime date) async {
    // 未来の日付をチェック
    final now = DateTime.now();
    if (date.isAfter(DateTime(now.year, now.month, now.day))) {
      return null;
    }

    try {
      return await _healthRepository.getStepDataForDate(date);
    } catch (e) {
      throw HealthDataException('Failed to get step data for date: $e');
    }
  }

  /// 指定期間の歩数データをリアルタイムで監視
  /// [startDate] 開始日
  /// [endDate] 終了日
  /// Returns: HealthDataのリストのStream
  Stream<List<HealthData>> watchStepData({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    // 日付の妥当性チェック
    if (startDate.isAfter(endDate)) {
      throw ArgumentError('Start date must be before or equal to end date');
    }

    return _healthRepository
        .watchHealthData(startDate: startDate, endDate: endDate)
        .map((healthDataList) {
          // データを日付順にソート
          healthDataList.sort((a, b) => a.date.compareTo(b.date));
          return healthDataList;
        });
  }

  /// 今日の歩数データをリアルタイムで監視
  /// Returns: 今日の歩数データのStream
  Stream<HealthData?> watchTodayStepData() {
    return _healthRepository.watchTodaySteps();
  }

  /// 週間の歩数データを取得
  /// [weekStart] 週の開始日（通常は月曜日）
  /// Returns: その週のHealthDataのリスト
  Future<List<HealthData>> getWeeklyStepData(DateTime weekStart) async {
    final weekEnd = weekStart.add(const Duration(days: 6));
    return call(startDate: weekStart, endDate: weekEnd);
  }

  /// 月間の歩数データを取得
  /// [year] 年
  /// [month] 月
  /// Returns: その月のHealthDataのリスト
  Future<List<HealthData>> getMonthlyStepData(int year, int month) async {
    final startDate = DateTime(year, month, 1);
    final endDate = DateTime(year, month + 1, 0); // 月末日
    return call(startDate: startDate, endDate: endDate);
  }

  /// 年間の歩数データを取得
  /// [year] 年
  /// Returns: その年のHealthDataのリスト
  Future<List<HealthData>> getYearlyStepData(int year) async {
    final startDate = DateTime(year, 1, 1);
    final endDate = DateTime(year, 12, 31);
    return call(startDate: startDate, endDate: endDate);
  }
}

/// ヘルスデータ関連の例外クラス
class HealthDataException implements Exception {
  const HealthDataException(this.message);

  final String message;

  @override
  String toString() => 'HealthDataException: $message';
}
