import 'package:flutter/material.dart';
import 'package:frontend/domain/core/entity/health_data.dart';
import 'package:frontend/domain/core/entity/activity_visualization.dart';
import 'package:frontend/domain/core/entity/user_profile.dart';
import 'package:frontend/domain/core/type/activity_level_type.dart';
import 'package:frontend/domain/core/type/health_data_type.dart';
import 'package:frontend/domain/social/repository/social_repository.dart';

/// Builders for creating consistent test data across presentation layer tests
class TestDataBuilders {
  /// Default test date for consistent testing
  static final DateTime defaultTestDate = DateTime(2024, 1, 1);

  /// Creates a HealthData builder with default values
  static HealthDataBuilder healthData() => HealthDataBuilder();

  /// Creates an ActivityVisualization builder with default values
  static ActivityVisualizationBuilder activityVisualization() =>
      ActivityVisualizationBuilder();

  /// Creates a list of HealthData for a date range
  static List<HealthData> healthDataRange({
    required DateTime startDate,
    required DateTime endDate,
    int baseStepCount = 5000,
    int stepVariation = 2000,
  }) {
    final data = <HealthData>[];
    var currentDate = startDate;
    var stepCount = baseStepCount;

    while (currentDate.isBefore(endDate) ||
        currentDate.isAtSameMomentAs(endDate)) {
      data.add(
        healthData().withDate(currentDate).withStepCount(stepCount).build(),
      );

      currentDate = currentDate.add(const Duration(days: 1));
      stepCount = (baseStepCount + (stepCount % stepVariation)).clamp(0, 20000);
    }

    return data;
  }

  /// Creates a weekly activity visualization grid
  static List<List<ActivityVisualization>> weeklyActivityGrid({
    required DateTime startDate,
    int goalSteps = 8000,
  }) {
    final grid = <List<ActivityVisualization>>[];
    var currentDate = startDate;

    for (int week = 0; week < 4; week++) {
      final weekData = <ActivityVisualization>[];

      for (int day = 0; day < 7; day++) {
        final stepCount = (5000 + (week * 1000) + (day * 500)).clamp(0, 15000);
        weekData.add(
          activityVisualization()
              .withDate(currentDate)
              .withStepCount(stepCount)
              .withGoalSteps(goalSteps)
              .build(),
        );
        currentDate = currentDate.add(const Duration(days: 1));
      }

      grid.add(weekData);
    }

    return grid;
  }

  /// Creates a yearly activity visualization grid
  static List<List<ActivityVisualization>> yearlyActivityGrid({
    required int year,
    int goalSteps = 8000,
  }) {
    final grid = <List<ActivityVisualization>>[];
    final startDate = DateTime(year, 1, 1);
    final endDate = DateTime(year, 12, 31);
    var currentDate = startDate;

    while (currentDate.isBefore(endDate) ||
        currentDate.isAtSameMomentAs(endDate)) {
      final weekData = <ActivityVisualization>[];

      // Fill week starting from Monday
      for (int day = 0; day < 7; day++) {
        if (currentDate.isAfter(endDate)) {
          // Add empty visualization for dates beyond the year
          weekData.add(
            activityVisualization().withDate(currentDate).withNoData().build(),
          );
        } else {
          final stepCount = _generateRealisticStepCount(currentDate);
          weekData.add(
            activityVisualization()
                .withDate(currentDate)
                .withStepCount(stepCount)
                .withGoalSteps(goalSteps)
                .build(),
          );
        }
        currentDate = currentDate.add(const Duration(days: 1));
      }

      grid.add(weekData);
    }

    return grid;
  }

  /// Generates realistic step count based on date patterns
  static int _generateRealisticStepCount(DateTime date) {
    // Weekend pattern (lower activity)
    if (date.weekday == DateTime.saturday || date.weekday == DateTime.sunday) {
      return (3000 + (date.day * 100)).clamp(1000, 6000);
    }

    // Weekday pattern (higher activity)
    return (6000 + (date.day * 150)).clamp(4000, 12000);
  }

  /// Creates test statistics data
  static Map<String, dynamic> activityStatistics({
    int totalSteps = 50000,
    double averageSteps = 7142.86,
    double goalAchievementRate = 0.89,
    int activeDays = 6,
    int totalDays = 7,
  }) {
    return {
      'totalSteps': totalSteps,
      'averageSteps': averageSteps,
      'goalAchievementRate': goalAchievementRate,
      'activeDays': activeDays,
      'totalDays': totalDays,
    };
  }

  /// Creates test friend data
  static Map<String, dynamic> friendData({
    String id = 'friend_1',
    String name = 'Test Friend',
    String email = 'friend@test.com',
    int stepCount = 8000,
    int rank = 1,
  }) {
    return {
      'id': id,
      'name': name,
      'email': email,
      'stepCount': stepCount,
      'rank': rank,
    };
  }

  /// Creates test subscription data
  static Map<String, dynamic> subscriptionData({
    bool isPremium = false,
    DateTime? expiryDate,
    String status = 'active',
  }) {
    return {
      'isPremium': isPremium,
      'expiryDate': expiryDate?.toIso8601String(),
      'status': status,
    };
  }
}

/// Builder class for HealthData
class HealthDataBuilder {
  DateTime _date = TestDataBuilders.defaultTestDate;
  int _stepCount = 5000;
  double _distance = 3.5;
  int _caloriesBurned = 250;
  ActivityLevel _activityLevel = ActivityLevel.medium;
  int _activeTime = 60;
  SyncStatus _syncStatus = SyncStatus.synced;
  DateTime? _createdAt;
  DateTime? _updatedAt;

  HealthDataBuilder withDate(DateTime date) {
    _date = date;
    return this;
  }

  HealthDataBuilder withStepCount(int stepCount) {
    _stepCount = stepCount;
    // Auto-calculate related values
    _distance = stepCount * 0.0007; // Rough conversion
    _caloriesBurned = (stepCount * 0.05).round();
    _activityLevel = ActivityLevel.fromStepCount(stepCount);
    return this;
  }

  HealthDataBuilder withDistance(double distance) {
    _distance = distance;
    return this;
  }

  HealthDataBuilder withCaloriesBurned(int calories) {
    _caloriesBurned = calories;
    return this;
  }

  HealthDataBuilder withActivityLevel(ActivityLevel level) {
    _activityLevel = level;
    return this;
  }

  HealthDataBuilder withActiveTime(int minutes) {
    _activeTime = minutes;
    return this;
  }

  HealthDataBuilder withSyncStatus(SyncStatus status) {
    _syncStatus = status;
    return this;
  }

  HealthDataBuilder withCreatedAt(DateTime createdAt) {
    _createdAt = createdAt;
    return this;
  }

  HealthDataBuilder withUpdatedAt(DateTime updatedAt) {
    _updatedAt = updatedAt;
    return this;
  }

  HealthDataBuilder withTodayDate() {
    _date = DateTime.now();
    return this;
  }

  HealthDataBuilder withYesterdayDate() {
    _date = DateTime.now().subtract(const Duration(days: 1));
    return this;
  }

  HealthDataBuilder withHighActivity() {
    return withStepCount(10000).withActivityLevel(ActivityLevel.veryHigh);
  }

  HealthDataBuilder withLowActivity() {
    return withStepCount(1500).withActivityLevel(ActivityLevel.low);
  }

  HealthDataBuilder withNoActivity() {
    return withStepCount(0)
        .withActivityLevel(ActivityLevel.none)
        .withDistance(0.0)
        .withCaloriesBurned(0);
  }

  HealthDataBuilder withPendingSync() {
    return withSyncStatus(SyncStatus.pending);
  }

  HealthDataBuilder withFailedSync() {
    return withSyncStatus(SyncStatus.failed);
  }

  HealthData build() {
    return HealthData(
      date: _date,
      stepCount: _stepCount,
      distance: _distance,
      caloriesBurned: _caloriesBurned,
      activityLevel: _activityLevel,
      activeTime: _activeTime,
      syncStatus: _syncStatus,
      createdAt: _createdAt,
      updatedAt: _updatedAt,
    );
  }
}

/// Builder class for ActivityVisualization
class ActivityVisualizationBuilder {
  DateTime _date = TestDataBuilders.defaultTestDate;
  ActivityLevel _level = ActivityLevel.medium;
  Color _color = ActivityLevel.medium.color;
  bool _hasData = true;
  int _stepCount = 5000;
  double _goalAchievementRate = 0.625;
  String? _tooltip;

  ActivityVisualizationBuilder withDate(DateTime date) {
    _date = date;
    return this;
  }

  ActivityVisualizationBuilder withLevel(ActivityLevel level) {
    _level = level;
    _color = level.color;
    return this;
  }

  ActivityVisualizationBuilder withColor(Color color) {
    _color = color;
    return this;
  }

  ActivityVisualizationBuilder withStepCount(int stepCount) {
    _stepCount = stepCount;
    _level = ActivityLevel.fromStepCount(stepCount);
    _color = _level.color;
    _hasData = stepCount > 0;
    return this;
  }

  ActivityVisualizationBuilder withGoalSteps(int goalSteps) {
    if (goalSteps > 0) {
      _goalAchievementRate = (_stepCount / goalSteps).clamp(0.0, 1.0);
      _level = ActivityLevel.fromStepCountWithGoal(_stepCount, goalSteps);
      _color = _level.color;
    }
    return this;
  }

  ActivityVisualizationBuilder withGoalAchievementRate(double rate) {
    _goalAchievementRate = rate.clamp(0.0, 1.0);
    return this;
  }

  ActivityVisualizationBuilder withTooltip(String tooltip) {
    _tooltip = tooltip;
    return this;
  }

  ActivityVisualizationBuilder withNoData() {
    _hasData = false;
    _stepCount = 0;
    _level = ActivityLevel.none;
    _color = Colors.grey.shade200;
    _goalAchievementRate = 0.0;
    _tooltip = 'No data available';
    return this;
  }

  ActivityVisualizationBuilder withTodayDate() {
    _date = DateTime.now();
    return this;
  }

  ActivityVisualizationBuilder withHighActivity() {
    return withStepCount(10000).withLevel(ActivityLevel.veryHigh);
  }

  ActivityVisualizationBuilder withLowActivity() {
    return withStepCount(1500).withLevel(ActivityLevel.low);
  }

  ActivityVisualizationBuilder withGoalAchieved(int goalSteps) {
    return withStepCount(goalSteps + 1000).withGoalSteps(goalSteps);
  }

  ActivityVisualizationBuilder withGoalNotAchieved(int goalSteps) {
    return withStepCount((goalSteps * 0.7).round()).withGoalSteps(goalSteps);
  }

  ActivityVisualization build() {
    return ActivityVisualization(
      date: _date,
      level: _level,
      color: _color,
      hasData: _hasData,
      stepCount: _stepCount,
      goalAchievementRate: _goalAchievementRate,
      tooltip: _tooltip ?? _generateTooltip(),
    );
  }

  String _generateTooltip() {
    if (!_hasData) {
      return 'No data available';
    }
    return '$_stepCount steps (${(_goalAchievementRate * 100).toInt()}% of goal)';
  }
}

/// Utility class for creating test scenarios
class TestScenarios {
  /// Creates a scenario with no health data
  static List<HealthData> noHealthData() => [];

  /// Creates a scenario with consistent daily activity
  static List<HealthData> consistentDailyActivity({
    required DateTime startDate,
    int days = 7,
    int stepCount = 8000,
  }) {
    return List.generate(days, (index) {
      return TestDataBuilders.healthData()
          .withDate(startDate.add(Duration(days: index)))
          .withStepCount(stepCount)
          .build();
    });
  }

  /// Creates a scenario with varying activity levels
  static List<HealthData> varyingActivity({
    required DateTime startDate,
    int days = 7,
  }) {
    final stepCounts = [12000, 3000, 8000, 15000, 1000, 6000, 9000];
    return List.generate(days, (index) {
      return TestDataBuilders.healthData()
          .withDate(startDate.add(Duration(days: index)))
          .withStepCount(stepCounts[index % stepCounts.length])
          .build();
    });
  }

  /// Creates a scenario with sync issues
  static List<HealthData> syncIssues({
    required DateTime startDate,
    int days = 7,
  }) {
    final syncStatuses = [
      SyncStatus.synced,
      SyncStatus.pending,
      SyncStatus.failed,
      SyncStatus.syncing,
    ];

    return List.generate(days, (index) {
      return TestDataBuilders.healthData()
          .withDate(startDate.add(Duration(days: index)))
          .withSyncStatus(syncStatuses[index % syncStatuses.length])
          .build();
    });
  }

  /// Creates a scenario for weekend vs weekday patterns
  static List<HealthData> weekendWeekdayPattern({
    required DateTime startDate,
    int weeks = 4,
  }) {
    final data = <HealthData>[];
    var currentDate = startDate;

    for (int week = 0; week < weeks; week++) {
      for (int day = 0; day < 7; day++) {
        final isWeekend =
            currentDate.weekday == DateTime.saturday ||
            currentDate.weekday == DateTime.sunday;
        final stepCount = isWeekend ? 4000 : 8000;

        data.add(
          TestDataBuilders.healthData()
              .withDate(currentDate)
              .withStepCount(stepCount)
              .build(),
        );

        currentDate = currentDate.add(const Duration(days: 1));
      }
    }

    return data;
  }

  /// Creates a scenario with gradual improvement
  static List<HealthData> gradualImprovement({
    required DateTime startDate,
    int days = 30,
    int startingSteps = 3000,
    int endingSteps = 10000,
  }) {
    final stepIncrement = (endingSteps - startingSteps) / days;

    return List.generate(days, (index) {
      final stepCount = (startingSteps + (stepIncrement * index)).round();
      return TestDataBuilders.healthData()
          .withDate(startDate.add(Duration(days: index)))
          .withStepCount(stepCount)
          .build();
    });
  }

  /// Creates a UserProfile for testing
  static UserProfile createUserProfile({
    String id = 'test_user_1',
    String name = 'Test User',
    String email = 'test@example.com',
    int dailyStepGoal = 8000,
    String? avatarUrl,
    int? age,
    double? height,
    double? weight,
    String timezone = 'UTC',
    String language = 'en',
    PrivacyLevel privacyLevel = PrivacyLevel.friends,
    bool notificationsEnabled = true,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id,
      name: name,
      email: email,
      dailyStepGoal: dailyStepGoal,
      avatarUrl: avatarUrl,
      age: age,
      height: height,
      weight: weight,
      timezone: timezone,
      language: language,
      privacyLevel: privacyLevel,
      notificationsEnabled: notificationsEnabled,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Creates a FriendInvitation for testing
  static FriendInvitation createFriendInvitation({
    String id = 'invitation_1',
    String fromUserId = 'user_1',
    String toUserId = 'user_2',
    String fromUserName = 'Test User 1',
    String toUserEmail = 'user2@test.com',
    InvitationStatus status = InvitationStatus.sent,
    String? message,
    DateTime? createdAt,
    DateTime? respondedAt,
  }) {
    return FriendInvitation(
      id: id,
      fromUserId: fromUserId,
      toUserId: toUserId,
      fromUserName: fromUserName,
      toUserEmail: toUserEmail,
      status: status,
      message: message,
      createdAt: createdAt ?? DateTime.now(),
      respondedAt: respondedAt,
    );
  }

  /// Creates a RankingData for testing
  static RankingData createRankingData({
    String userId = 'user_1',
    String userName = 'Test User',
    int stepCount = 8000,
    int rank = 1,
    String? avatarUrl,
    bool isCurrentUser = false,
  }) {
    return RankingData(
      userId: userId,
      userName: userName,
      stepCount: stepCount,
      rank: rank,
      avatarUrl: avatarUrl,
      isCurrentUser: isCurrentUser,
    );
  }

  /// Creates friends statistics data for testing
  static Map<String, dynamic> createFriendsStatistics({
    int totalFriends = 5,
    int maxFriends = 10,
    int remainingSlots = 5,
    int pendingReceivedInvitations = 2,
    int pendingSentInvitations = 1,
    bool canAddMore = true,
  }) {
    return {
      'totalFriends': totalFriends,
      'maxFriends': maxFriends,
      'remainingSlots': remainingSlots,
      'pendingReceivedInvitations': pendingReceivedInvitations,
      'pendingSentInvitations': pendingSentInvitations,
      'canAddMore': canAddMore,
    };
  }

  /// Creates friend comparison data for testing
  static Map<String, dynamic> createFriendComparison({
    int currentUserSteps = 8000,
    int currentUserRank = 2,
    String friendName = 'Test Friend',
    int friendSteps = 7500,
    int friendRank = 3,
    int stepDifference = 500,
    int rankDifference = -1,
    bool isAhead = true,
  }) {
    return {
      'currentUser': {'steps': currentUserSteps, 'rank': currentUserRank},
      'friend': {'name': friendName, 'steps': friendSteps, 'rank': friendRank},
      'comparison': {
        'stepDifference': stepDifference,
        'rankDifference': rankDifference,
        'isAhead': isAhead,
      },
    };
  }

  /// Creates a HealthData for testing (if not already available)
  static HealthData createHealthData({
    DateTime? date,
    int stepCount = 5000,
    double distance = 3.5,
    int caloriesBurned = 250,
    ActivityLevel activityLevel = ActivityLevel.medium,
    int activeTime = 60,
    SyncStatus syncStatus = SyncStatus.synced,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return HealthData(
      date: date ?? DateTime.now(),
      stepCount: stepCount,
      distance: distance,
      caloriesBurned: caloriesBurned,
      activityLevel: activityLevel,
      activeTime: activeTime,
      syncStatus: syncStatus,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

/// Social test scenarios
class SocialTestScenarios {
  /// Creates a scenario with multiple friends
  static List<UserProfile> multipleFriends({int count = 5}) {
    return List.generate(count, (index) {
      return createUserProfile(
        id: 'friend_${index + 1}',
        name: 'Friend ${index + 1}',
        email: 'friend${index + 1}@test.com',
      );
    });
  }

  /// Creates a scenario with pending invitations
  static Map<String, List<FriendInvitation>> pendingInvitations({
    int receivedCount = 2,
    int sentCount = 1,
  }) {
    final received = List.generate(receivedCount, (index) {
      return createFriendInvitation(
        id: 'received_${index + 1}',
        fromUserId: 'sender_${index + 1}',
        fromUserName: 'Sender ${index + 1}',
        status: InvitationStatus.sent,
      );
    });

    final sent = List.generate(sentCount, (index) {
      return createFriendInvitation(
        id: 'sent_${index + 1}',
        toUserId: 'recipient_${index + 1}',
        toUserEmail: 'recipient${index + 1}@test.com',
        status: InvitationStatus.sent,
      );
    });

    return {'received': received, 'sent': sent};
  }

  /// Creates a ranking scenario with multiple users
  static List<RankingData> weeklyRanking({int participantCount = 5}) {
    return List.generate(participantCount, (index) {
      final isCurrentUser = index == 1; // Make second user the current user
      return createRankingData(
        userId: 'user_${index + 1}',
        userName: isCurrentUser ? 'You' : 'User ${index + 1}',
        stepCount: 10000 - (index * 1000), // Descending step counts
        rank: index + 1,
        isCurrentUser: isCurrentUser,
      );
    });
  }

  /// Creates a monthly ranking scenario
  static List<RankingData> monthlyRanking({int participantCount = 10}) {
    return List.generate(participantCount, (index) {
      final isCurrentUser = index == 2; // Make third user the current user
      return createRankingData(
        userId: 'user_${index + 1}',
        userName: isCurrentUser ? 'You' : 'User ${index + 1}',
        stepCount: 50000 - (index * 3000), // Descending step counts for monthly
        rank: index + 1,
        isCurrentUser: isCurrentUser,
      );
    });
  }

  /// Creates a scenario with no friends
  static List<UserProfile> noFriends() => [];

  /// Creates a scenario with no invitations
  static Map<String, List<FriendInvitation>> noInvitations() => {
    'received': <FriendInvitation>[],
    'sent': <FriendInvitation>[],
  };

  /// Creates a scenario with empty ranking
  static List<RankingData> emptyRanking() => [];

  /// Creates a scenario with friend at capacity
  static Map<String, dynamic> friendsAtCapacity() {
    return createFriendsStatistics(
      totalFriends: 10,
      maxFriends: 10,
      remainingSlots: 0,
      canAddMore: false,
    );
  }

  /// Creates a scenario with search results
  static List<UserProfile> searchResults({String query = 'John'}) {
    return [
      createUserProfile(
        id: 'john_1',
        name: 'John Doe',
        email: 'john.doe@test.com',
      ),
      createUserProfile(
        id: 'john_2',
        name: 'Johnny Smith',
        email: 'johnny.smith@test.com',
      ),
    ];
  }

  /// Creates a scenario with no search results
  static List<UserProfile> noSearchResults() => [];

  /// Creates a scenario with friend activity data
  static List<HealthData> friendActivityData({
    required DateTime startDate,
    int days = 7,
    int baseStepCount = 6000,
  }) {
    return List.generate(days, (index) {
      return createHealthData(
        date: startDate.add(Duration(days: index)),
        stepCount: baseStepCount + (index * 500),
      );
    });
  }

  /// Creates a scenario with comparison where current user is ahead
  static Map<String, dynamic> currentUserAhead() {
    return createFriendComparison(
      currentUserSteps: 9000,
      currentUserRank: 1,
      friendSteps: 7500,
      friendRank: 3,
      stepDifference: 1500,
      rankDifference: -2,
      isAhead: true,
    );
  }

  /// Creates a scenario with comparison where friend is ahead
  static Map<String, dynamic> friendAhead() {
    return createFriendComparison(
      currentUserSteps: 6000,
      currentUserRank: 4,
      friendSteps: 8500,
      friendRank: 2,
      stepDifference: -2500,
      rankDifference: 2,
      isAhead: false,
    );
  }
}
