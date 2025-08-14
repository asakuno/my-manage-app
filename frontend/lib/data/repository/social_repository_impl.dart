import 'dart:async';
import '../../domain/core/entity/user_profile.dart';
import '../../domain/core/entity/health_data.dart';
import '../../domain/social/repository/social_repository.dart';
import '../local/user_preferences_data_source.dart';
import '../api/mock/mock_social_data.dart';
import '../api/mock/mock_health_data.dart';

/// ソーシャル機能リポジトリの実装クラス
/// ローカルデータソースとモックデータを組み合わせてソーシャル機能を管理する
class SocialRepositoryImpl implements SocialRepository {
  final UserPreferencesDataSource _localDataSource;
  final bool _useMockData;

  // Stream controllers for real-time data
  final StreamController<List<UserProfile>> _friendsController =
      StreamController<List<UserProfile>>.broadcast();
  final StreamController<List<RankingData>> _rankingController =
      StreamController<List<RankingData>>.broadcast();
  final StreamController<List<FriendInvitation>> _invitationsController =
      StreamController<List<FriendInvitation>>.broadcast();

  // In-memory storage for mock data (実際の実装ではサーバーまたはローカルDBを使用)
  final List<UserProfile> _mockFriends = [];
  final List<FriendInvitation> _mockInvitations = [];
  final List<UserProfile> _mockBlockedFriends = [];

  SocialRepositoryImpl({
    required UserPreferencesDataSource localDataSource,
    bool useMockData = true, // 開発中はモックデータを使用
  }) : _localDataSource = localDataSource,
       _useMockData = useMockData {
    if (_useMockData) {
      _initializeMockData();
    }
  }

  /// モックデータを初期化
  void _initializeMockData() {
    _mockFriends.addAll(MockSocialData.generateFriendsList(count: 8));
  }

  @override
  Future<bool> addFriend(String friendId) async {
    try {
      if (_useMockData) {
        // モックデータの場合は友達を追加
        final newFriend = MockSocialData.generateFriendProfile(id: friendId);

        // 既に友達でないかチェック
        if (!_mockFriends.any((friend) => friend.id == friendId)) {
          _mockFriends.add(newFriend);
          _friendsController.add(List.from(_mockFriends));
          return true;
        }
        return false;
      } else {
        // 実際のAPI呼び出し（実装は省略）
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> removeFriend(String friendId) async {
    try {
      if (_useMockData) {
        // モックデータの場合は友達を削除
        final initialLength = _mockFriends.length;
        _mockFriends.removeWhere((friend) => friend.id == friendId);
        if (_mockFriends.length < initialLength) {
          _friendsController.add(List.from(_mockFriends));
          return true;
        }
        return false;
      } else {
        // 実際のAPI呼び出し（実装は省略）
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<UserProfile>> getFriends() async {
    if (_useMockData) {
      return List.from(_mockFriends);
    } else {
      // 実際のAPI呼び出し（実装は省略）
      return [];
    }
  }

  @override
  Future<bool> inviteFriend(String email, {String? message}) async {
    try {
      if (_useMockData) {
        // モックデータの場合は招待を作成
        final invitation = FriendInvitation(
          id: 'invite_${DateTime.now().millisecondsSinceEpoch}',
          fromUserId: 'current_user',
          toUserId: 'user_${email.hashCode}',
          fromUserName: 'Current User',
          toUserEmail: email,
          status: InvitationStatus.sent,
          message: message,
          createdAt: DateTime.now(),
        );

        _mockInvitations.add(invitation);
        _invitationsController.add(List.from(_mockInvitations));
        return true;
      } else {
        // 実際のAPI呼び出し（実装は省略）
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> acceptFriendInvitation(String invitationId) async {
    try {
      if (_useMockData) {
        // モックデータの場合は招待を受諾
        final invitationIndex = _mockInvitations.indexWhere(
          (inv) => inv.id == invitationId,
        );
        if (invitationIndex != -1) {
          final invitation = _mockInvitations[invitationIndex];

          // 招待状態を更新
          final updatedInvitation = FriendInvitation(
            id: invitation.id,
            fromUserId: invitation.fromUserId,
            toUserId: invitation.toUserId,
            fromUserName: invitation.fromUserName,
            toUserEmail: invitation.toUserEmail,
            status: InvitationStatus.accepted,
            message: invitation.message,
            createdAt: invitation.createdAt,
            respondedAt: DateTime.now(),
          );

          _mockInvitations[invitationIndex] = updatedInvitation;

          // 友達リストに追加
          final newFriend = MockSocialData.generateFriendProfile(
            id: invitation.fromUserId,
          );
          _mockFriends.add(newFriend);

          _invitationsController.add(List.from(_mockInvitations));
          _friendsController.add(List.from(_mockFriends));

          return true;
        }
        return false;
      } else {
        // 実際のAPI呼び出し（実装は省略）
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> declineFriendInvitation(String invitationId) async {
    try {
      if (_useMockData) {
        // モックデータの場合は招待を拒否
        final invitationIndex = _mockInvitations.indexWhere(
          (inv) => inv.id == invitationId,
        );
        if (invitationIndex != -1) {
          final invitation = _mockInvitations[invitationIndex];

          // 招待状態を更新
          final updatedInvitation = FriendInvitation(
            id: invitation.id,
            fromUserId: invitation.fromUserId,
            toUserId: invitation.toUserId,
            fromUserName: invitation.fromUserName,
            toUserEmail: invitation.toUserEmail,
            status: InvitationStatus.declined,
            message: invitation.message,
            createdAt: invitation.createdAt,
            respondedAt: DateTime.now(),
          );

          _mockInvitations[invitationIndex] = updatedInvitation;
          _invitationsController.add(List.from(_mockInvitations));

          return true;
        }
        return false;
      } else {
        // 実際のAPI呼び出し（実装は省略）
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<FriendInvitation>> getReceivedInvitations() async {
    if (_useMockData) {
      // 受信した招待のみを返す
      return _mockInvitations
          .where((inv) => inv.toUserId == 'current_user')
          .toList();
    } else {
      // 実際のAPI呼び出し（実装は省略）
      return [];
    }
  }

  @override
  Future<List<FriendInvitation>> getSentInvitations() async {
    if (_useMockData) {
      // 送信した招待のみを返す
      return _mockInvitations
          .where((inv) => inv.fromUserId == 'current_user')
          .toList();
    } else {
      // 実際のAPI呼び出し（実装は省略）
      return [];
    }
  }

  @override
  Future<List<RankingData>> getWeeklyRanking({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    if (_useMockData) {
      // モックデータの週間ランキングを生成
      final mockRanking = MockSocialData.generateWeeklyRanking(
        count: _mockFriends.length,
      );
      return mockRanking
          .map(
            (data) => RankingData(
              userId: (data['user'] as UserProfile).id,
              userName: (data['user'] as UserProfile).name,
              stepCount: data['totalSteps'] as int,
              rank: data['rank'] as int,
              avatarUrl: (data['user'] as UserProfile).avatarUrl,
              isCurrentUser: (data['user'] as UserProfile).id == 'current_user',
            ),
          )
          .toList();
    } else {
      // 実際のAPI呼び出し（実装は省略）
      return [];
    }
  }

  @override
  Future<List<RankingData>> getMonthlyRanking({
    required int year,
    required int month,
  }) async {
    if (_useMockData) {
      // モックデータの月間ランキングを生成
      final mockRanking = MockSocialData.generateMonthlyRanking(
        count: _mockFriends.length,
      );
      return mockRanking
          .map(
            (data) => RankingData(
              userId: (data['user'] as UserProfile).id,
              userName: (data['user'] as UserProfile).name,
              stepCount: data['totalSteps'] as int,
              rank: data['rank'] as int,
              avatarUrl: (data['user'] as UserProfile).avatarUrl,
              isCurrentUser: (data['user'] as UserProfile).id == 'current_user',
            ),
          )
          .toList();
    } else {
      // 実際のAPI呼び出し（実装は省略）
      return [];
    }
  }

  @override
  Future<List<HealthData>> getFriendActivityData({
    required String friendId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    if (_useMockData) {
      // モックデータの友達のアクティビティデータを生成
      return MockHealthData.generateHealthDataRange(startDate, endDate);
    } else {
      // 実際のAPI呼び出し（実装は省略）
      return [];
    }
  }

  @override
  Future<bool> shareActivityData({
    required List<String> friendIds,
    required HealthData data,
  }) async {
    if (_useMockData) {
      // モックデータの場合は常に成功
      return true;
    } else {
      // 実際のAPI呼び出し（実装は省略）
      return false;
    }
  }

  @override
  Future<bool> updatePrivacyLevel(PrivacyLevel level) async {
    try {
      await _localDataSource.savePrivacyLevel(level);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<PrivacyLevel> getPrivacyLevel() async {
    return await _localDataSource.getPrivacyLevel();
  }

  @override
  Future<List<UserProfile>> searchFriends(String query) async {
    if (_useMockData) {
      // モックデータから検索
      return _mockFriends
          .where(
            (friend) =>
                friend.name.toLowerCase().contains(query.toLowerCase()) ||
                friend.email.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    } else {
      // 実際のAPI呼び出し（実装は省略）
      return [];
    }
  }

  @override
  Stream<List<UserProfile>> watchFriends() {
    // 定期的に友達リストを更新
    Timer.periodic(const Duration(minutes: 5), (timer) async {
      final friends = await getFriends();
      _friendsController.add(friends);
    });

    return _friendsController.stream;
  }

  @override
  Stream<List<RankingData>> watchRanking(RankingPeriod period) {
    // 定期的にランキングを更新
    Timer.periodic(const Duration(minutes: 10), (timer) async {
      List<RankingData> ranking;
      final now = DateTime.now();

      switch (period) {
        case RankingPeriod.weekly:
          final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
          ranking = await getWeeklyRanking(
            startDate: startOfWeek,
            endDate: now,
          );
          break;
        case RankingPeriod.monthly:
          ranking = await getMonthlyRanking(year: now.year, month: now.month);
          break;
        case RankingPeriod.yearly:
          // 年間ランキングは月間ランキングと同じロジックを使用
          ranking = await getMonthlyRanking(year: now.year, month: now.month);
          break;
      }

      _rankingController.add(ranking);
    });

    return _rankingController.stream;
  }

  @override
  Stream<List<FriendInvitation>> watchInvitations() {
    // 定期的に招待を更新
    Timer.periodic(const Duration(minutes: 2), (timer) async {
      final invitations = await getReceivedInvitations();
      _invitationsController.add(invitations);
    });

    return _invitationsController.stream;
  }

  @override
  Future<int> getMaxFriendsCount() async {
    // プレミアム機能に応じて最大友達数を返す
    // 実際の実装では SubscriptionRepository から取得
    return 50; // プレミアムユーザーの場合
  }

  @override
  Future<int> getCurrentFriendsCount() async {
    final friends = await getFriends();
    return friends.length;
  }

  @override
  Future<List<UserProfile>> getBlockedFriends() async {
    if (_useMockData) {
      return List.from(_mockBlockedFriends);
    } else {
      // 実際のAPI呼び出し（実装は省略）
      return [];
    }
  }

  @override
  Future<bool> blockFriend(String friendId) async {
    try {
      if (_useMockData) {
        // 友達リストから削除してブロックリストに追加
        final friendIndex = _mockFriends.indexWhere(
          (friend) => friend.id == friendId,
        );
        if (friendIndex != -1) {
          final blockedFriend = _mockFriends.removeAt(friendIndex);
          _mockBlockedFriends.add(blockedFriend);

          _friendsController.add(List.from(_mockFriends));
          return true;
        }
        return false;
      } else {
        // 実際のAPI呼び出し（実装は省略）
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> unblockFriend(String friendId) async {
    try {
      if (_useMockData) {
        // ブロックリストから削除
        final initialLength = _mockBlockedFriends.length;
        _mockBlockedFriends.removeWhere((friend) => friend.id == friendId);
        return _mockBlockedFriends.length < initialLength;
      } else {
        // 実際のAPI呼び出し（実装は省略）
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  /// リソースを解放
  void dispose() {
    _friendsController.close();
    _rankingController.close();
    _invitationsController.close();
  }
}
