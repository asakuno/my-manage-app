import '../repository/social_repository.dart';
import '../../core/entity/user_profile.dart';

/// 友達追加ユースケース
/// 友達の追加、招待、管理を行う
class AddFriendUseCase {
  const AddFriendUseCase(this._socialRepository);

  final SocialRepository _socialRepository;

  /// 友達を追加
  /// [friendId] 追加する友達のID
  /// Returns: 追加が成功した場合true
  Future<bool> call(String friendId) async {
    if (friendId.trim().isEmpty) {
      throw SocialException('Friend ID cannot be empty');
    }

    try {
      // 友達数の制限をチェック
      await _checkFriendsLimit();

      // 友達追加を実行
      return await _socialRepository.addFriend(friendId);
    } catch (e) {
      if (e is SocialException) {
        rethrow;
      }
      throw SocialException('Failed to add friend: $e');
    }
  }

  /// 友達招待を送信
  /// [email] 招待する友達のメールアドレス
  /// [message] 招待メッセージ（オプション）
  /// Returns: 招待送信が成功した場合true
  Future<bool> inviteFriend(String email, {String? message}) async {
    if (email.trim().isEmpty) {
      throw SocialException('Email cannot be empty');
    }

    // 簡単なメールアドレス形式チェック
    if (!_isValidEmail(email)) {
      throw SocialException('Invalid email format');
    }

    try {
      // 友達数の制限をチェック
      await _checkFriendsLimit();

      // 招待を送信
      return await _socialRepository.inviteFriend(email, message: message);
    } catch (e) {
      if (e is SocialException) {
        rethrow;
      }
      throw SocialException('Failed to invite friend: $e');
    }
  }

  /// 友達招待を受諾
  /// [invitationId] 招待ID
  /// Returns: 受諾が成功した場合true
  Future<bool> acceptInvitation(String invitationId) async {
    if (invitationId.trim().isEmpty) {
      throw SocialException('Invitation ID cannot be empty');
    }

    try {
      // 友達数の制限をチェック
      await _checkFriendsLimit();

      // 招待を受諾
      return await _socialRepository.acceptFriendInvitation(invitationId);
    } catch (e) {
      if (e is SocialException) {
        rethrow;
      }
      throw SocialException('Failed to accept invitation: $e');
    }
  }

  /// 友達招待を拒否
  /// [invitationId] 招待ID
  /// Returns: 拒否が成功した場合true
  Future<bool> declineInvitation(String invitationId) async {
    if (invitationId.trim().isEmpty) {
      throw SocialException('Invitation ID cannot be empty');
    }

    try {
      return await _socialRepository.declineFriendInvitation(invitationId);
    } catch (e) {
      throw SocialException('Failed to decline invitation: $e');
    }
  }

  /// 友達を削除
  /// [friendId] 削除する友達のID
  /// Returns: 削除が成功した場合true
  Future<bool> removeFriend(String friendId) async {
    if (friendId.trim().isEmpty) {
      throw SocialException('Friend ID cannot be empty');
    }

    try {
      return await _socialRepository.removeFriend(friendId);
    } catch (e) {
      throw SocialException('Failed to remove friend: $e');
    }
  }

  /// 友達リストを取得
  /// Returns: 友達のUserProfileリスト
  Future<List<UserProfile>> getFriends() async {
    try {
      return await _socialRepository.getFriends();
    } catch (e) {
      throw SocialException('Failed to get friends: $e');
    }
  }

  /// 受信した友達招待を取得
  /// Returns: 友達招待のリスト
  Future<List<FriendInvitation>> getReceivedInvitations() async {
    try {
      return await _socialRepository.getReceivedInvitations();
    } catch (e) {
      throw SocialException('Failed to get received invitations: $e');
    }
  }

  /// 送信した友達招待を取得
  /// Returns: 友達招待のリスト
  Future<List<FriendInvitation>> getSentInvitations() async {
    try {
      return await _socialRepository.getSentInvitations();
    } catch (e) {
      throw SocialException('Failed to get sent invitations: $e');
    }
  }

  /// 友達の検索
  /// [query] 検索クエリ（名前またはメールアドレス）
  /// Returns: 検索結果のUserProfileリスト
  Future<List<UserProfile>> searchFriends(String query) async {
    if (query.trim().isEmpty) {
      return [];
    }

    try {
      return await _socialRepository.searchFriends(query);
    } catch (e) {
      throw SocialException('Failed to search friends: $e');
    }
  }

  /// 友達リストをリアルタイムで監視
  /// Returns: 友達リストのStream
  Stream<List<UserProfile>> watchFriends() {
    return _socialRepository.watchFriends();
  }

  /// 友達招待をリアルタイムで監視
  /// Returns: 友達招待のStream
  Stream<List<FriendInvitation>> watchInvitations() {
    return _socialRepository.watchInvitations();
  }

  /// 現在の友達数を取得
  /// Returns: 現在の友達数
  Future<int> getCurrentFriendsCount() async {
    try {
      return await _socialRepository.getCurrentFriendsCount();
    } catch (e) {
      return 0;
    }
  }

  /// 友達の最大追加可能数を取得
  /// Returns: 最大友達数
  Future<int> getMaxFriendsCount() async {
    try {
      return await _socialRepository.getMaxFriendsCount();
    } catch (e) {
      return 10; // デフォルトは無料プランの制限
    }
  }

  /// 友達追加が可能かどうかを確認
  /// Returns: 追加可能な場合true
  Future<bool> canAddMoreFriends() async {
    try {
      final currentCount = await getCurrentFriendsCount();
      final maxCount = await getMaxFriendsCount();
      return currentCount < maxCount;
    } catch (e) {
      return false;
    }
  }

  /// 友達数の制限をチェック
  /// 制限に達している場合は例外をスロー
  Future<void> _checkFriendsLimit() async {
    final canAdd = await canAddMoreFriends();
    if (!canAdd) {
      final currentCount = await getCurrentFriendsCount();
      final maxCount = await getMaxFriendsCount();
      throw SocialException(
        'Friends limit reached ($currentCount/$maxCount). '
        'Upgrade to premium for unlimited friends.',
      );
    }
  }

  /// メールアドレスの形式をチェック
  bool _isValidEmail(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(email);
  }

  /// 友達管理の統計情報を取得
  /// Returns: 統計情報のMap
  Future<Map<String, dynamic>> getFriendsStatistics() async {
    try {
      final friends = await getFriends();
      final receivedInvitations = await getReceivedInvitations();
      final sentInvitations = await getSentInvitations();
      final maxCount = await getMaxFriendsCount();

      final pendingReceived = receivedInvitations
          .where((inv) => inv.status == InvitationStatus.sent)
          .length;

      final pendingSent = sentInvitations
          .where((inv) => inv.status == InvitationStatus.sent)
          .length;

      return {
        'totalFriends': friends.length,
        'maxFriends': maxCount,
        'remainingSlots': maxCount - friends.length,
        'pendingReceivedInvitations': pendingReceived,
        'pendingSentInvitations': pendingSent,
        'canAddMore': friends.length < maxCount,
      };
    } catch (e) {
      return {'error': e.toString()};
    }
  }
}

/// ソーシャル機能関連の例外クラス
class SocialException implements Exception {
  const SocialException(this.message);

  final String message;

  @override
  String toString() => 'SocialException: $message';
}
