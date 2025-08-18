import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/core/entity/activity_visualization.dart';
import '../../../domain/core/type/activity_level_type.dart';

/// GitHub風アクティビティカレンダーウィジェット
/// 年間の歩数データを草のような視覚化で表示する
class ActivityCalendar extends ConsumerWidget {
  const ActivityCalendar({
    super.key,
    required this.yearlyData,
    this.cellSize = 12.0,
    this.cellSpacing = 2.0,
    this.showMonthLabels = true,
    this.showWeekdayLabels = true,
    this.onCellTap,
    this.selectedDate,
  });

  /// 年間のアクティビティデータ（週ごとのリスト）
  final List<List<ActivityVisualization>> yearlyData;

  /// セルのサイズ
  final double cellSize;

  /// セル間のスペース
  final double cellSpacing;

  /// 月ラベルを表示するかどうか
  final bool showMonthLabels;

  /// 曜日ラベルを表示するかどうか
  final bool showWeekdayLabels;

  /// セルタップ時のコールバック
  final void Function(ActivityVisualization)? onCellTap;

  /// 選択された日付
  final DateTime? selectedDate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (yearlyData.isEmpty) {
      return const Center(child: Text('No data available'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showMonthLabels) _buildMonthLabels(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showWeekdayLabels) _buildWeekdayLabels(),
            Expanded(child: _buildCalendarGrid()),
          ],
        ),
        const SizedBox(height: 16),
        _buildLegend(),
      ],
    );
  }

  /// 月ラベルを構築
  Widget _buildMonthLabels() {
    final months = <String>[];
    final monthWidths = <double>[];

    // 各月の週数を計算
    for (int month = 1; month <= 12; month++) {
      final monthName = _getMonthName(month);
      months.add(monthName);

      // その月に含まれる週数を概算
      final weeksInMonth = 4.3; // 平均的な週数
      monthWidths.add(weeksInMonth * (cellSize + cellSpacing));
    }

    return Container(
      height: 20,
      margin: EdgeInsets.only(left: showWeekdayLabels ? 30 : 0, bottom: 8),
      child: Row(
        children: months.asMap().entries.map((entry) {
          final index = entry.key;
          final month = entry.value;
          final width = monthWidths[index];

          return SizedBox(
            width: width,
            child: Text(
              month,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// 曜日ラベルを構築
  Widget _buildWeekdayLabels() {
    const weekdays = ['Mon', 'Wed', 'Fri'];

    return Container(
      width: 30,
      margin: const EdgeInsets.only(right: 8),
      child: Column(
        children: List.generate(7, (index) {
          final isLabelDay =
              index == 0 || index == 2 || index == 4; // Mon, Wed, Fri
          return Container(
            height: cellSize,
            margin: EdgeInsets.only(bottom: cellSpacing),
            alignment: Alignment.centerRight,
            child: isLabelDay
                ? Text(
                    weekdays[index ~/ 2],
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  )
                : null,
          );
        }),
      ),
    );
  }

  /// カレンダーグリッドを構築
  Widget _buildCalendarGrid() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: yearlyData.map((week) => _buildWeekColumn(week)).toList(),
      ),
    );
  }

  /// 週のカラムを構築
  Widget _buildWeekColumn(List<ActivityVisualization> week) {
    return Container(
      margin: EdgeInsets.only(right: cellSpacing),
      child: Column(children: week.map((day) => _buildDayCell(day)).toList()),
    );
  }

  /// 日のセルを構築
  Widget _buildDayCell(ActivityVisualization day) {
    final isSelected =
        selectedDate != null &&
        day.date.year == selectedDate!.year &&
        day.date.month == selectedDate!.month &&
        day.date.day == selectedDate!.day;

    return GestureDetector(
      onTap: () => onCellTap?.call(day),
      child: Tooltip(
        message: day.tooltip ?? 'No data',
        child: Container(
          width: cellSize,
          height: cellSize,
          margin: EdgeInsets.only(bottom: cellSpacing),
          decoration: BoxDecoration(
            color: day.color,
            borderRadius: BorderRadius.circular(2),
            border: isSelected
                ? Border.all(color: Colors.blue, width: 2)
                : day.isToday
                ? Border.all(color: Colors.black, width: 1)
                : null,
          ),
        ),
      ),
    );
  }

  /// 凡例を構築
  Widget _buildLegend() {
    return Row(
      children: [
        const Text('Less', style: TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(width: 8),
        ...ActivityLevel.values.map((level) {
          return Container(
            width: cellSize,
            height: cellSize,
            margin: const EdgeInsets.only(right: 2),
            decoration: BoxDecoration(
              color: level.color,
              borderRadius: BorderRadius.circular(2),
            ),
          );
        }),
        const SizedBox(width: 8),
        const Text('More', style: TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  /// 月名を取得
  String _getMonthName(int month) {
    const monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return monthNames[month - 1];
  }
}

/// アクティビティカレンダーの統計情報を表示するウィジェット
class ActivityCalendarStats extends StatelessWidget {
  const ActivityCalendarStats({super.key, required this.statistics});

  final Map<String, dynamic> statistics;

  @override
  Widget build(BuildContext context) {
    final totalDays = statistics['totalDays'] as int? ?? 0;
    final activeDays = statistics['activeDays'] as int? ?? 0;
    final totalSteps = statistics['totalSteps'] as int? ?? 0;
    final averageSteps = statistics['averageSteps'] as double? ?? 0.0;
    final streakDays = statistics['streakDays'] as int? ?? 0;
    final goalAchievementRate =
        statistics['goalAchievementRate'] as double? ?? 0.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Activity Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildStatRow('Total Days', totalDays.toString()),
            _buildStatRow('Active Days', activeDays.toString()),
            _buildStatRow('Total Steps', _formatNumber(totalSteps)),
            _buildStatRow('Average Steps', _formatNumber(averageSteps.round())),
            _buildStatRow('Current Streak', '$streakDays days'),
            _buildStatRow(
              'Goal Achievement',
              '${(goalAchievementRate * 100).toInt()}%',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}
