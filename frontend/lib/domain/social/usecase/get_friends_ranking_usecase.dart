import '../repository/social_repository.dart';
import '../../core/entity/health_data.dart';

/// 友達ランキング取得ユースケース
/// 友達間のランキングとアクティビティ比較を管理する
class GetFriendsRankingUseCase {
  const GetFriendsRankingUseCase(this._socialRepository);

  final SocialRepository _socialRepository;

  /// 週間ランキングを取得
  /// [startDate] 週の開始日
  /// [endDate] 週の終了日
  /// Returns: ランキングデータのリスト
  Future<List<RankingData>> getWeeklyRanking({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    if (startDate.isAfter(endDate)) {
      throw ArgumentError('Start date must be before or equal to end date');
    }

    try {
      final ranking = await _socialRepository.getWeeklyRanking(
        startDate: startDate,
        endDate: endDate,
      );

      // ランキングを歩数順にソート（降順）
      ranking.sort((a, b) => b.stepCount.compareTo(a.stepCount));

      // 順位を再設定
      for (int i = 0; i < ranking.length; i++) {
        ranking[i] = RankingData(
          userId: ranking[i].userId,
          userName: ranking[i].userName,
          stepCount: ranking[i].stepCount,
          rank: i + 1,
          avatarUrl: ranking[i].avatarUrl,
          isCurrentUser: ranking[i].isCurrentUser,
        );
      }

      return ranking;
    } catch (e) {
      throw SocialRankingException('Failed to get weekly ranking: $e');
    }
  }

  /// 月間ランキングを取得
  /// [year] 年
  /// [month] 月
  /// Returns: ランキングデータのリスト
  Future<List<RankingData>> getMonthlyRanking({
    required int year,
    required int month,
  }) async {
    if (month < 1 || month > 12) {
      throw ArgumentError('Month must be between 1 and 12');
    }

    try {
      final ranking = await _socialRepository.getMonthlyRanking(
        year: year,
        month: month,
      );

      // ランキングを歩数順にソート（降順）
      ranking.sort((a, b) => b.stepCount.compareTo(a.stepCount));

      // 順位を再設定
      for (int i = 0; i < ranking.length; i++) {
        ranking[i] = RankingData(
          userId: ranking[i].userId,
          userName: ranking[i].userName,
          stepCount: ranking[i].stepCount,
          rank: i + 1,
          avatarUrl: ranking[i].avatarUrl,
          isCurrentUser: ranking[i].isCurrentUser,
        );
      }

      return ranking;
    } catch (e) {
      throw SocialRankingException('Failed to get monthly ranking: $e');
    }
  }

  /// 現在の週のランキングを取得
  /// Returns: 今週のランキングデータのリスト
  Future<List<RankingData>> getCurrentWeekRanking() async {
    final now = DateTime.now();
    final weekStart = _getWeekStart(now);
    final weekEnd = weekStart.add(const Duration(days: 6));

    return getWeeklyRanking(startDate: weekStart, endDate: weekEnd);
  }

  /// 現在の月のランキングを取得
  /// Returns: 今月のランキングデータのリスト
  Future<List<RankingData>> getCurrentMonthRanking() async {
    final now = DateTime.now();
    return getMonthlyRanking(year: now.year, month: now.month);
  }

  /// 友達のアクティビティデータを取得
  /// [friendId] 友達のID
  /// [startDate] 開始日
  /// [endDate] 終了日
  /// Returns: 友達のHealthDataリスト
  Future<List<HealthData>> getFriendActivityData({
    required String friendId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    if (friendId.trim().isEmpty) {
      throw ArgumentError('Friend ID cannot be empty');
    }

    if (startDate.isAfter(endDate)) {
      throw ArgumentError('Start date must be before or equal to end date');
    }

    try {
      final activityData = await _socialRepository.getFriendActivityData(
        friendId: friendId,
        startDate: startDate,
        endDate: endDate,
      );

      // データを日付順にソート
      activityData.sort((a, b) => a.date.compareTo(b.date));

      return activityData;
    } catch (e) {
      throw SocialRankingException('Failed to get friend activity data: $e');
    }
  }

  /// ランキングをリアルタイムで監視
  /// [period] ランキング期間
  /// Returns: ランキングデータのStream
  Stream<List<RankingData>> watchRanking(RankingPeriod period) {
    return _socialRepository.watchRanking(period).map((ranking) {
      // ランキングを歩数順にソート（降順）
      ranking.sort((a, b) => b.stepCount.compareTo(a.stepCount));

      // 順位を再設定
      for (int i = 0; i < ranking.length; i++) {
        ranking[i] = RankingData(
          userId: ranking[i].userId,
          userName: ranking[i].userName,
          stepCount: ranking[i].stepCount,
          rank: i + 1,
          avatarUrl: ranking[i].avatarUrl,
          isCurrentUser: ranking[i].isCurrentUser,
        );
      }

      return ranking;
    });
  }

  /// 現在のユーザーの順位を取得
  /// [ranking] ランキングデータのリスト
  /// Returns: 現在のユーザーの順位、見つからない場合は-1
  int getCurrentUserRank(List<RankingData> ranking) {
    final currentUserData = ranking.firstWhere(
      (data) => data.isCurrentUser,
      orElse: () => RankingData(
        userId: '',
        userName: '',
        stepCount: 0,
        rank: -1,
        isCurrentUser: false,
      ),
    );

    return currentUserData.rank;
  }

  /// ランキングの統計情報を取得
  /// [ranking] ランキングデータのリスト
  /// Returns: 統計情報のMap
  Map<String, dynamic> getRankingStatistics(List<RankingData> ranking) {
    if (ranking.isEmpty) {
      return {
        'totalParticipants': 0,
        'averageSteps': 0.0,
        'maxSteps': 0,
        'minSteps': 0,
        'currentUserRank': -1,
        'currentUserSteps': 0,
      };
    }

    final totalSteps = ranking.fold<int>(
      0,
      (sum, data) => sum + data.stepCount,
    );
    final averageSteps = totalSteps / ranking.length;
    final maxSteps = ranking
        .map((data) => data.stepCount)
        .reduce((a, b) => a > b ? a : b);
    final minSteps = ranking
        .map((data) => data.stepCount)
        .reduce((a, b) => a < b ? a : b);

    final currentUser = ranking.firstWhere(
      (data) => data.isCurrentUser,
      orElse: () => RankingData(
        userId: '',
        userName: '',
        stepCount: 0,
        rank: -1,
        isCurrentUser: false,
      ),
    );

    return {
      'totalParticipants': ranking.length,
      'averageSteps': averageSteps,
      'maxSteps': maxSteps,
      'minSteps': minSteps,
      'currentUserRank': currentUser.rank,
      'currentUserSteps': currentUser.stepCount,
    };
  }

  /// 友達との比較データを取得
  /// [friendId] 比較する友達のID
  /// [period] 比較期間
  /// Returns: 比較データのMap
  Future<Map<String, dynamic>> compareWithFriend({
    required String friendId,
    required RankingPeriod period,
  }) async {
    try {
      List<RankingData> ranking;

      switch (period) {
        case RankingPeriod.weekly:
          ranking = await getCurrentWeekRanking();
          break;
        case RankingPeriod.monthly:
          ranking = await getCurrentMonthRanking();
          break;
        case RankingPeriod.yearly:
          // 年間ランキングは実装されていないため、月間を使用
          ranking = await getCurrentMonthRanking();
          break;
      }

      final currentUser = ranking.firstWhere(
        (data) => data.isCurrentUser,
        orElse: () => RankingData(
          userId: '',
          userName: '',
          stepCount: 0,
          rank: -1,
          isCurrentUser: false,
        ),
      );

      final friend = ranking.firstWhere(
        (data) => data.userId == friendId,
        orElse: () => RankingData(
          userId: friendId,
          userName: 'Unknown',
          stepCount: 0,
          rank: -1,
          isCurrentUser: false,
        ),
      );

      final stepDifference = currentUser.stepCount - friend.stepCount;
      final rankDifference = friend.rank - currentUser.rank; // 順位は小さい方が上位

      return {
        'currentUser': {
          'steps': currentUser.stepCount,
          'rank': currentUser.rank,
        },
        'friend': {
          'name': friend.userName,
          'steps': friend.stepCount,
          'rank': friend.rank,
        },
        'comparison': {
          'stepDifference': stepDifference,
          'rankDifference': rankDifference,
          'isAhead': stepDifference > 0,
        },
      };
    } catch (e) {
      throw SocialRankingException('Failed to compare with friend: $e');
    }
  }

  /// 週の開始日（月曜日）を取得
  DateTime _getWeekStart(DateTime date) {
    final weekday = date.weekday; // 月曜日=1, 日曜日=7
    return date.subtract(Duration(days: weekday - 1));
  }
}

/// ソーシャルランキング関連の例外クラス
class SocialRankingException implements Exception {
  const SocialRankingException(this.message);

  final String message;

  @override
  String toString() => 'SocialRankingException: $message';
}
