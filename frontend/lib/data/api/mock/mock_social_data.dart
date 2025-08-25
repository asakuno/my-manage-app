import 'dart:math';
import '../../../domain/core/entity/user_profile.dart';
import 'mock_health_data.dart';

/// ソーシャル機能のモックデータクラス
/// 開発・テスト用のサンプルソーシャルデータを提供する
class MockSocialData {
  static final Random _random = Random();

  /// サンプル友達の名前リスト
  static const List<String> _friendNames = [
    'Alice Johnson',
    'Bob Smith',
    'Charlie Brown',
    'Diana Prince',
    'Edward Norton',
    'Fiona Green',
    'George Wilson',
    'Hannah Davis',
    'Ian Thompson',
    'Julia Roberts',
    'Kevin Hart',
    'Lisa Anderson',
    'Michael Jordan',
    'Nancy Drew',
    'Oliver Stone',
    'Patricia Lee',
    'Quincy Jones',
    'Rachel Green',
    'Steven King',
    'Tina Turner',
  ];

  /// サンプル友達のアバターURL
  static const List<String> _avatarUrls = [
    'https://i.pravatar.cc/150?img=1',
    'https://i.pravatar.cc/150?img=2',
    'https://i.pravatar.cc/150?img=3',
    'https://i.pravatar.cc/150?img=4',
    'https://i.pravatar.cc/150?img=5',
    'https://i.pravatar.cc/150?img=6',
    'https://i.pravatar.cc/150?img=7',
    'https://i.pravatar.cc/150?img=8',
    'https://i.pravatar.cc/150?img=9',
    'https://i.pravatar.cc/150?img=10',
  ];

  /// 友達のモックプロフィールを生成
  static UserProfile generateFriendProfile({String? id, String? name}) {
    final friendId = id ?? 'friend_${_random.nextInt(10000)}';
    final friendName =
        name ?? _friendNames[_random.nextInt(_friendNames.length)];
    final avatarUrl = _avatarUrls[_random.nextInt(_avatarUrls.length)];

    return UserProfile(
      id: friendId,
      name: friendName,
      email: '${friendName.toLowerCase().replaceAll(' ', '.')}@example.com',
      dailyStepGoal: 6000 + _random.nextInt(6000), // 6000-12000歩
      avatarUrl: avatarUrl,
      age: 20 + _random.nextInt(40), // 20-60歳
      height: 150.0 + _random.nextDouble() * 30, // 150-180cm
      weight: 50.0 + _random.nextDouble() * 40, // 50-90kg
      timezone: 'UTC',
      language: 'en',
      privacyLevel:
          PrivacyLevel.values[_random.nextInt(PrivacyLevel.values.length)],
      notificationsEnabled: _random.nextBool(),
      createdAt: DateTime.now().subtract(Duration(days: _random.nextInt(365))),
      updatedAt: DateTime.now(),
    );
  }

  /// 友達リストのモックデータを生成
  static List<UserProfile> generateFriendsList({int count = 10}) {
    final List<UserProfile> friends = [];
    final usedNames = <String>{};

    for (int i = 0; i < count && usedNames.length < _friendNames.length; i++) {
      String name;
      do {
        name = _friendNames[_random.nextInt(_friendNames.length)];
      } while (usedNames.contains(name));

      usedNames.add(name);
      friends.add(generateFriendProfile(name: name));
    }

    return friends;
  }

  /// 週間ランキングのモックデータを生成
  static List<Map<String, dynamic>> generateWeeklyRanking({int count = 10}) {
    final friends = generateFriendsList(count: count);
    final List<Map<String, dynamic>> ranking = [];

    // 今週の開始日を計算
    // final now = DateTime.now();

    for (int i = 0; i < friends.length; i++) {
      final friend = friends[i];

      // 今週の歩数データを生成
      final weeklySteps = _generateWeeklySteps();
      final totalSteps = weeklySteps.fold<int>(0, (sum, steps) => sum + steps);

      ranking.add({
        'rank': i + 1,
        'user': friend,
        'totalSteps': totalSteps,
        'dailySteps': weeklySteps,
        'averageSteps': (totalSteps / 7).round(),
        'goalAchievementRate': _calculateGoalAchievementRate(
          weeklySteps,
          friend.dailyStepGoal,
        ),
        'streak': _random.nextInt(30), // 連続達成日数
      });
    }

    // 歩数でソート
    ranking.sort(
      (a, b) => (b['totalSteps'] as int).compareTo(a['totalSteps'] as int),
    );

    // ランクを再設定
    for (int i = 0; i < ranking.length; i++) {
      ranking[i]['rank'] = i + 1;
    }

    return ranking;
  }

  /// 月間ランキングのモックデータを生成
  static List<Map<String, dynamic>> generateMonthlyRanking({int count = 10}) {
    final friends = generateFriendsList(count: count);
    final List<Map<String, dynamic>> ranking = [];

    for (int i = 0; i < friends.length; i++) {
      final friend = friends[i];

      // 今月の歩数データを生成
      final monthlySteps = _generateMonthlySteps();
      final totalSteps = monthlySteps.fold<int>(0, (sum, steps) => sum + steps);
      final daysWithData = monthlySteps.where((steps) => steps > 0).length;

      ranking.add({
        'rank': i + 1,
        'user': friend,
        'totalSteps': totalSteps,
        'averageSteps': daysWithData > 0
            ? (totalSteps / daysWithData).round()
            : 0,
        'activeDays': daysWithData,
        'goalAchievementRate': _calculateGoalAchievementRate(
          monthlySteps,
          friend.dailyStepGoal,
        ),
        'maxDailySteps': monthlySteps.isNotEmpty
            ? monthlySteps.reduce((a, b) => a > b ? a : b)
            : 0,
      });
    }

    // 歩数でソート
    ranking.sort(
      (a, b) => (b['totalSteps'] as int).compareTo(a['totalSteps'] as int),
    );

    // ランクを再設定
    for (int i = 0; i < ranking.length; i++) {
      ranking[i]['rank'] = i + 1;
    }

    return ranking;
  }

  /// 友達の今日のアクティビティを生成
  static Map<String, dynamic> generateFriendTodayActivity(UserProfile friend) {
    final today = DateTime.now();
    final healthData = MockHealthData.generateHealthDataForDate(today);

    return {
      'user': friend,
      'date': today.toIso8601String(),
      'stepCount': healthData.stepCount,
      'distance': healthData.distance,
      'caloriesBurned': healthData.caloriesBurned,
      'activityLevel': healthData.activityLevel.level,
      'goalAchievementRate': healthData.getAchievementRate(
        friend.dailyStepGoal,
      ),
      'isGoalAchieved': healthData.stepCount >= friend.dailyStepGoal,
    };
  }

  /// 友達招待のモックデータを生成
  static Map<String, dynamic> generateFriendInvitation() {
    return {
      'invitationId': 'invite_${_random.nextInt(100000)}',
      'inviteCode': _generateInviteCode(),
      'expiryDate': DateTime.now()
          .add(const Duration(days: 7))
          .toIso8601String(),
      'maxUses': 1,
      'currentUses': 0,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }

  /// 友達追加リクエストのモックデータを生成
  static Map<String, dynamic> generateFriendRequest({
    required String fromUserId,
    required String toUserId,
    bool isPending = true,
  }) {
    return {
      'requestId': 'request_${_random.nextInt(100000)}',
      'fromUserId': fromUserId,
      'toUserId': toUserId,
      'status': isPending ? 'pending' : 'accepted',
      'message': 'Let\'s be fitness buddies!',
      'createdAt': DateTime.now()
          .subtract(Duration(hours: _random.nextInt(48)))
          .toIso8601String(),
      'respondedAt': isPending ? null : DateTime.now().toIso8601String(),
    };
  }

  /// ソーシャル統計のモックデータを生成
  static Map<String, dynamic> generateSocialStatistics() {
    final friendsCount = 5 + _random.nextInt(15); // 5-20人の友達
    final weeklyRanking = generateWeeklyRanking(count: friendsCount);
    final currentUserRank = _random.nextInt(friendsCount) + 1;

    return {
      'friendsCount': friendsCount,
      'currentWeekRank': currentUserRank,
      'bestWeekRank': _random.nextInt(currentUserRank) + 1,
      'totalInvitesSent': _random.nextInt(20),
      'totalInvitesReceived': _random.nextInt(10),
      'pendingRequests': _random.nextInt(3),
      'weeklyRankingParticipants': friendsCount,
      'averageFriendSteps': weeklyRanking.isNotEmpty
          ? (weeklyRanking
                        .map((r) => r['totalSteps'] as int)
                        .reduce((a, b) => a + b) /
                    friendsCount)
                .round()
          : 0,
    };
  }

  /// プライバシー設定のモックデータを生成
  static Map<String, dynamic> generatePrivacySettings() {
    return {
      'shareStepCount': _random.nextBool(),
      'shareDistance': _random.nextBool(),
      'shareCalories': _random.nextBool(),
      'shareActivityLevel': _random.nextBool(),
      'allowFriendRequests': _random.nextBool(),
      'showInRanking': _random.nextBool(),
      'shareAchievements': _random.nextBool(),
      'privacyLevel':
          PrivacyLevel.values[_random.nextInt(PrivacyLevel.values.length)].id,
    };
  }

  /// 友達のアクティビティフィードを生成
  static List<Map<String, dynamic>> generateActivityFeed({int count = 20}) {
    final friends = generateFriendsList(count: 10);
    final List<Map<String, dynamic>> feed = [];

    for (int i = 0; i < count; i++) {
      final friend = friends[_random.nextInt(friends.length)];
      final daysAgo = _random.nextInt(7);
      final activityDate = DateTime.now().subtract(Duration(days: daysAgo));
      final healthData = MockHealthData.generateHealthDataForDate(activityDate);

      final activityTypes = [
        'goal_achieved',
        'new_record',
        'streak_milestone',
        'challenge_completed',
      ];

      final activityType = activityTypes[_random.nextInt(activityTypes.length)];

      feed.add({
        'id': 'activity_${_random.nextInt(100000)}',
        'user': friend,
        'type': activityType,
        'date': activityDate.toIso8601String(),
        'stepCount': healthData.stepCount,
        'message': _generateActivityMessage(activityType, healthData.stepCount),
        'likes': _random.nextInt(20),
        'comments': _random.nextInt(5),
      });
    }

    // 日付でソート（新しい順）
    feed.sort(
      (a, b) => DateTime.parse(
        b['date'] as String,
      ).compareTo(DateTime.parse(a['date'] as String)),
    );

    return feed;
  }

  /// 週間歩数データを生成
  static List<int> _generateWeeklySteps() {
    final List<int> steps = [];
    for (int i = 0; i < 7; i++) {
      final isWeekend = i == 5 || i == 6; // 土日
      final baseSteps = isWeekend ? 4000 : 7000;
      final randomSteps = baseSteps + _random.nextInt(6000);
      steps.add(randomSteps);
    }
    return steps;
  }

  /// 月間歩数データを生成
  static List<int> _generateMonthlySteps() {
    final List<int> steps = [];
    final daysInMonth = DateTime.now().day; // 今月の経過日数

    for (int i = 0; i < daysInMonth; i++) {
      // 90%の確率でデータあり
      if (_random.nextDouble() < 0.9) {
        final randomSteps = 3000 + _random.nextInt(10000);
        steps.add(randomSteps);
      } else {
        steps.add(0);
      }
    }
    return steps;
  }

  /// 目標達成率を計算
  static double _calculateGoalAchievementRate(
    List<int> stepsList,
    int goalSteps,
  ) {
    if (stepsList.isEmpty || goalSteps <= 0) return 0.0;

    final achievedDays = stepsList.where((steps) => steps >= goalSteps).length;
    return achievedDays / stepsList.length;
  }

  /// 招待コードを生成
  static String _generateInviteCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(
      8,
      (index) => chars[_random.nextInt(chars.length)],
    ).join();
  }

  /// アクティビティメッセージを生成
  static String _generateActivityMessage(String activityType, int stepCount) {
    switch (activityType) {
      case 'goal_achieved':
        return 'Achieved daily goal with $stepCount steps! 🎯';
      case 'new_record':
        return 'New personal record: $stepCount steps! 🏆';
      case 'streak_milestone':
        return 'Reached a ${_random.nextInt(30) + 1}-day streak! 🔥';
      case 'challenge_completed':
        return 'Completed the weekly challenge! 💪';
      default:
        return 'Had a great day with $stepCount steps!';
    }
  }
}
