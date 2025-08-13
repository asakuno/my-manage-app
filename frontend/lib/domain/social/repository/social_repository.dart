import '../../core/entity/user_profile.dart';
import '../../core/entity/health_data.dart';

/// ソーシャル機能リポジトリの抽象クラス
/// 友達機能、ランキング、データ共有を担当する
abstract class SocialRepository {
  /// 友達を追加
  /// [friendId] 追加する友達のID
  /// Returns: 追加が成功した場合true
  Future<bool> addFriend(String friendId);

  /// 友達を削除
  /// [friendId] 削除する友達のID
  /// Returns: 削除が成功した場合true
  Future<bool> removeFriend(String friendId);

  /// 友達リストを取得
  /// Returns: 友達のUserProfileリスト
  Future<List<UserProfile>> getFriends();

  /// 友達招待を送信
  /// [email] 招待する友達のメールアドレス
  /// [message] 招待メッセージ（オプション）
  /// Returns: 招待送信が成功した場合true
  Future<bool> inviteFriend(String email, {String? message});

  /// 友達招待を受諾
  /// [invitationId] 招待ID
  /// Returns: 受諾が成功した場合true
  Future<bool> acceptFriendInvitation(String invitationId);

  /// 友達招待を拒否
  /// [invitationId] 招待ID
  /// Returns: 拒否が成功した場合true
  Future<bool> declineFriendInvitation(String invitationId);

  /// 受信した友達招待を取得
  /// Returns: 友達招待のリスト
  Future<List<FriendInvitation>> getReceivedInvitations();

  /// 送信した友達招待を取得
  /// Returns: 友達招待のリスト
  Future<List<FriendInvitation>> getSentInvitations();

  /// 週間ランキングを取得
  /// [startDate] 週の開始日
  /// [endDate] 週の終了日
  /// Returns: ランキングデータのリスト
  Future<List<RankingData>> getWeeklyRanking({
    required DateTime startDate,
    required DateTime endDate,
  });

  /// 月間ランキングを取得
  /// [year] 年
  /// [month] 月
  /// Returns: ランキングデータのリスト
  Future<List<RankingData>> getMonthlyRanking({
    required int year,
    required int month,
  });

  /// 友達のアクティビティデータを取得
  /// [friendId] 友達のID
  /// [startDate] 開始日
  /// [endDate] 終了日
  /// Returns: 友達のHealthDataリスト
  Future<List<HealthData>> getFriendActivityData({
    required String friendId,
    required DateTime startDate,
    required DateTime endDate,
  });

  /// 自分のアクティビティデータを共有
  /// [friendIds] 共有する友達のIDリスト
  /// [data] 共有するHealthData
  /// Returns: 共有が成功した場合true
  Future<bool> shareActivityData({
    required List<String> friendIds,
    required HealthData data,
  });

  /// プライバシー設定を更新
  /// [level] プライバシーレベル
  /// Returns: 更新が成功した場合true
  Future<bool> updatePrivacyLevel(PrivacyLevel level);

  /// 現在のプライバシー設定を取得
  /// Returns: 現在のPrivacyLevel
  Future<PrivacyLevel> getPrivacyLevel();

  /// 友達の検索
  /// [query] 検索クエリ（名前またはメールアドレス）
  /// Returns: 検索結果のUserProfileリスト
  Future<List<UserProfile>> searchFriends(String query);

  /// 友達リストをリアルタイムで監視
  /// Returns: 友達リストのStream
  Stream<List<UserProfile>> watchFriends();

  /// ランキングをリアルタイムで監視
  /// [period] ランキング期間
  /// Returns: ランキングデータのStream
  Stream<List<RankingData>> watchRanking(RankingPeriod period);

  /// 友達招待をリアルタイムで監視
  /// Returns: 友達招待のStream
  Stream<List<FriendInvitation>> watchInvitations();

  /// 友達の最大追加可能数を取得
  /// Returns: 最大友達数
  Future<int> getMaxFriendsCount();

  /// 現在の友達数を取得
  /// Returns: 現在の友達数
  Future<int> getCurrentFriendsCount();

  /// ブロックした友達を取得
  /// Returns: ブロックした友達のリスト
  Future<List<UserProfile>> getBlockedFriends();

  /// 友達をブロック
  /// [friendId] ブロックする友達のID
  /// Returns: ブロックが成功した場合true
  Future<bool> blockFriend(String friendId);

  /// 友達のブロックを解除
  /// [friendId] ブロック解除する友達のID
  /// Returns: ブロック解除が成功した場合true
  Future<bool> unblockFriend(String friendId);
}

/// 友達招待エンティティ
class FriendInvitation {
  const FriendInvitation({
    required this.id,
    required this.fromUserId,
    required this.toUserId,
    required this.fromUserName,
    required this.toUserEmail,
    required this.status,
    required this.createdAt,
    this.message,
    this.respondedAt,
  });

  /// 招待ID
  final String id;

  /// 送信者のユーザーID
  final String fromUserId;

  /// 受信者のユーザーID
  final String toUserId;

  /// 送信者の名前
  final String fromUserName;

  /// 受信者のメールアドレス
  final String toUserEmail;

  /// 招待状態
  final InvitationStatus status;

  /// 招待メッセージ
  final String? message;

  /// 作成日時
  final DateTime createdAt;

  /// 応答日時
  final DateTime? respondedAt;
}

/// 招待状態を表すEnum
enum InvitationStatus {
  /// 送信済み
  sent,

  /// 受諾済み
  accepted,

  /// 拒否済み
  declined,

  /// 期限切れ
  expired,
}

/// ランキングデータエンティティ
class RankingData {
  const RankingData({
    required this.userId,
    required this.userName,
    required this.stepCount,
    required this.rank,
    this.avatarUrl,
    this.isCurrentUser = false,
  });

  /// ユーザーID
  final String userId;

  /// ユーザー名
  final String userName;

  /// 歩数
  final int stepCount;

  /// 順位
  final int rank;

  /// アバター画像URL
  final String? avatarUrl;

  /// 現在のユーザーかどうか
  final bool isCurrentUser;
}

/// ランキング期間を表すEnum
enum RankingPeriod {
  /// 週間
  weekly,

  /// 月間
  monthly,

  /// 年間
  yearly,
}
