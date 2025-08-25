import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/core/entity/user_profile.dart';
import '../../domain/social/usecase/add_friend_usecase.dart';
import '../../domain/social/usecase/get_friends_ranking_usecase.dart';
import '../../data/repository/social_repository_impl.dart';
import '../../data/local/user_preferences_data_source.dart';

part 'social_provider.g.dart';

/// ユーザー設定データソースプロバイダー
@riverpod
UserPreferencesDataSource userPreferencesDataSource(UserPreferencesDataSourceRef ref) {
  return UserPreferencesDataSource();
}

/// ソーシャルリポジトリプロバイダー
@riverpod
SocialRepositoryImpl socialRepository(SocialRepositoryRef ref) {
  return SocialRepositoryImpl(
    localDataSource: ref.watch(userPreferencesDataSourceProvider),
  );
}

/// 友達追加ユースケースプロバイダー
@riverpod
AddFriendUseCase addFriendUseCase(AddFriendUseCaseRef ref) {
  return AddFriendUseCase(ref.watch(socialRepositoryProvider));
}

/// 友達ランキング取得ユースケースプロバイダー
@riverpod
GetFriendsRankingUseCase getFriendsRankingUseCase(GetFriendsRankingUseCaseRef ref) {
  return GetFriendsRankingUseCase(ref.watch(socialRepositoryProvider));
}

/// 友達リストプロバイダー
@riverpod
class FriendsList extends _$FriendsList {
  @override
  Future<List<UserProfile>> build() async {
    final useCase = ref.watch(addFriendUseCaseProvider);
    return await useCase.getFriends();
  }

  /// 友達リストを手動で更新
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final useCase = ref.read(addFriendUseCaseProvider);
      return await useCase.getFriends();
    });
  }

  /// 友達を追加
  Future<bool> addFriend(String friendId) async {
    try {
      final useCase = ref.read(addFriendUseCaseProvider);
      final success = await useCase.call(friendId);

      if (success) {
        // 友達追加成功時はリストを更新
        await refresh();
      }

      return success;
    } catch (e) {
      return false;
    }
  }

  /// 友達を削除
  Future<bool> removeFriend(String friendId) async {
    try {
      final useCase = ref.read(addFriendUseCaseProvider);
      final success = await useCase.removeFriend(friendId);

      if (success) {
        // 友達削除成功時はリストを更新
        await refresh();
      }

      return success;
    } catch (e) {
      return false;
    }
  }
}

/// 友達リストをリアルタイムで監視するプロバイダー
@riverpod
class FriendsListStream extends _$FriendsListStream {
  @override
  Stream<List<UserProfile>> build() {
    final useCase = ref.watch(addFriendUseCaseProvider);
    return useCase.watchFriends();
  }
}

/// 友達招待プロバイダー
@riverpod
class FriendInvitations extends _$FriendInvitations {
  @override
  Future<Map<String, List<dynamic>>> build() async {
    final useCase = ref.watch(addFriendUseCaseProvider);

    final received = await useCase.getReceivedInvitations();
    final sent = await useCase.getSentInvitations();

    return {'received': received, 'sent': sent};
  }

  /// 招待リストを手動で更新
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final useCase = ref.read(addFriendUseCaseProvider);

      final received = await useCase.getReceivedInvitations();
      final sent = await useCase.getSentInvitations();

      return {'received': received, 'sent': sent};
    });
  }

  /// 友達を招待
  Future<bool> inviteFriend(String email, {String? message}) async {
    try {
      final useCase = ref.read(addFriendUseCaseProvider);
      final success = await useCase.inviteFriend(email, message: message);

      if (success) {
        // 招待送信成功時は招待リストを更新
        await refresh();
      }

      return success;
    } catch (e) {
      return false;
    }
  }

  /// 招待を受諾
  Future<bool> acceptInvitation(String invitationId) async {
    try {
      final useCase = ref.read(addFriendUseCaseProvider);
      final success = await useCase.acceptInvitation(invitationId);

      if (success) {
        // 招待受諾成功時は友達リストと招待リストを更新
        ref.invalidate(friendsListProvider);
        await refresh();
      }

      return success;
    } catch (e) {
      return false;
    }
  }

  /// 招待を拒否
  Future<bool> declineInvitation(String invitationId) async {
    try {
      final useCase = ref.read(addFriendUseCaseProvider);
      final success = await useCase.declineInvitation(invitationId);

      if (success) {
        // 招待拒否成功時は招待リストを更新
        await refresh();
      }

      return success;
    } catch (e) {
      return false;
    }
  }
}

/// 友達招待をリアルタイムで監視するプロバイダー
@riverpod
class FriendInvitationsStream extends _$FriendInvitationsStream {
  @override
  Stream<List<dynamic>> build() {
    final useCase = ref.watch(addFriendUseCaseProvider);
    return useCase.watchInvitations();
  }
}

/// 週間ランキングプロバイダー
@riverpod
class WeeklyRanking extends _$WeeklyRanking {
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  Future<List<dynamic>> build({DateTime? startDate, DateTime? endDate}) async {
    _startDate = startDate;
    _endDate = endDate;
    final useCase = ref.watch(getFriendsRankingUseCaseProvider);

    if (startDate != null && endDate != null) {
      return await useCase.getWeeklyRanking(
        startDate: startDate,
        endDate: endDate,
      );
    } else {
      return await useCase.getCurrentWeekRanking();
    }
  }

  /// ランキングを手動で更新
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final useCase = ref.read(getFriendsRankingUseCaseProvider);

      if (_startDate != null && _endDate != null) {
        return await useCase.getWeeklyRanking(
          startDate: _startDate!,
          endDate: _endDate!,
        );
      } else {
        return await useCase.getCurrentWeekRanking();
      }
    });
  }
}

/// 月間ランキングプロバイダー
@riverpod
class MonthlyRanking extends _$MonthlyRanking {
  int? _year;
  int? _month;

  @override
  Future<List<dynamic>> build({int? year, int? month}) async {
    _year = year;
    _month = month;
    final useCase = ref.watch(getFriendsRankingUseCaseProvider);

    if (year != null && month != null) {
      return await useCase.getMonthlyRanking(year: year, month: month);
    } else {
      return await useCase.getCurrentMonthRanking();
    }
  }

  /// ランキングを手動で更新
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final useCase = ref.read(getFriendsRankingUseCaseProvider);

      if (_year != null && _month != null) {
        return await useCase.getMonthlyRanking(year: _year!, month: _month!);
      } else {
        return await useCase.getCurrentMonthRanking();
      }
    });
  }
}

/// ランキングをリアルタイムで監視するプロバイダー
@riverpod
class RankingStream extends _$RankingStream {
  @override
  Stream<List<dynamic>> build(dynamic period) {
    final useCase = ref.watch(getFriendsRankingUseCaseProvider);
    return useCase.watchRanking(period);
  }
}

/// 友達検索プロバイダー
@riverpod
class FriendSearch extends _$FriendSearch {
  @override
  Future<List<UserProfile>> build(String query) async {
    if (query.trim().isEmpty) {
      return [];
    }

    final useCase = ref.watch(addFriendUseCaseProvider);
    return await useCase.searchFriends(query);
  }

  /// 検索を実行
  Future<void> search(String newQuery) async {
    if (newQuery.trim().isEmpty) {
      state = const AsyncValue.data([]);
      return;
    }

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final useCase = ref.read(addFriendUseCaseProvider);
      return await useCase.searchFriends(newQuery);
    });
  }
}

/// 友達数統計プロバイダー
@riverpod
class FriendsStatistics extends _$FriendsStatistics {
  @override
  Future<Map<String, dynamic>> build() async {
    final useCase = ref.watch(addFriendUseCaseProvider);
    return await useCase.getFriendsStatistics();
  }

  /// 統計を手動で更新
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final useCase = ref.read(addFriendUseCaseProvider);
      return await useCase.getFriendsStatistics();
    });
  }
}

/// 現在の友達数プロバイダー
@riverpod
Future<int> currentFriendsCount(CurrentFriendsCountRef ref) async {
  final useCase = ref.watch(addFriendUseCaseProvider);
  return await useCase.getCurrentFriendsCount();
}

/// 友達追加可能性プロバイダー
@riverpod
Future<bool> canAddMoreFriends(CanAddMoreFriendsRef ref) async {
  final useCase = ref.watch(addFriendUseCaseProvider);
  return await useCase.canAddMoreFriends();
}

/// 友達のアクティビティデータプロバイダー
@riverpod
class FriendActivityData extends _$FriendActivityData {
  String? _friendId;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  Future<List<dynamic>> build({
    required String friendId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    _friendId = friendId;
    _startDate = startDate;
    _endDate = endDate;
    final useCase = ref.watch(getFriendsRankingUseCaseProvider);
    return await useCase.getFriendActivityData(
      friendId: friendId,
      startDate: startDate,
      endDate: endDate,
    );
  }

  /// データを手動で更新
  Future<void> refresh() async {
    if (_friendId == null || _startDate == null || _endDate == null) return;
    
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final useCase = ref.read(getFriendsRankingUseCaseProvider);
      return await useCase.getFriendActivityData(
        friendId: _friendId!,
        startDate: _startDate!,
        endDate: _endDate!,
      );
    });
  }
}

/// 友達との比較データプロバイダー
@riverpod
class FriendComparison extends _$FriendComparison {
  String? _friendId;
  dynamic _period;

  @override
  Future<Map<String, dynamic>> build({
    required String friendId,
    required dynamic period,
  }) async {
    _friendId = friendId;
    _period = period;
    final useCase = ref.watch(getFriendsRankingUseCaseProvider);
    return await useCase.compareWithFriend(friendId: friendId, period: period);
  }

  /// 比較データを手動で更新
  Future<void> refresh() async {
    if (_friendId == null || _period == null) return;
    
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final useCase = ref.read(getFriendsRankingUseCaseProvider);
      return await useCase.compareWithFriend(
        friendId: _friendId!,
        period: _period,
      );
    });
  }
}

/// ソーシャル機能の統合プロバイダー
@riverpod
class SocialManager extends _$SocialManager {
  @override
  Future<Map<String, dynamic>> build() async {
    final friends = await ref.watch(friendsListProvider.future);
    final invitations = await ref.watch(friendInvitationsProvider.future);
    final statistics = await ref.watch(friendsStatisticsProvider.future);
    final canAddMore = await ref.watch(canAddMoreFriendsProvider.future);

    return {
      'friends': friends,
      'invitations': invitations,
      'statistics': statistics,
      'canAddMoreFriends': canAddMore,
    };
  }

  /// 統合情報を手動で更新
  Future<void> refresh() async {
    state = const AsyncValue.loading();

    // 関連するプロバイダーを無効化
    ref.invalidate(friendsListProvider);
    ref.invalidate(friendInvitationsProvider);
    ref.invalidate(friendsStatisticsProvider);
    ref.invalidate(canAddMoreFriendsProvider);

    state = await AsyncValue.guard(() async {
      final friends = await ref.read(friendsListProvider.future);
      final invitations = await ref.read(friendInvitationsProvider.future);
      final statistics = await ref.read(friendsStatisticsProvider.future);
      final canAddMore = await ref.read(canAddMoreFriendsProvider.future);

      return {
        'friends': friends,
        'invitations': invitations,
        'statistics': statistics,
        'canAddMoreFriends': canAddMore,
      };
    });
  }
}
