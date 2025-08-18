// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userPreferencesDataSourceHash() =>
    r'90c4db9055c3c17ebb50d84417061ee661811bcf';

/// ユーザー設定データソースプロバイダー
///
/// Copied from [userPreferencesDataSource].
@ProviderFor(userPreferencesDataSource)
final userPreferencesDataSourceProvider =
    AutoDisposeProvider<UserPreferencesDataSource>.internal(
  userPreferencesDataSource,
  name: r'userPreferencesDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userPreferencesDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserPreferencesDataSourceRef
    = AutoDisposeProviderRef<UserPreferencesDataSource>;
String _$socialRepositoryHash() => r'a94acb99777329bb3e3c5e1a8fc54e791d40d8d2';

/// ソーシャルリポジトリプロバイダー
///
/// Copied from [socialRepository].
@ProviderFor(socialRepository)
final socialRepositoryProvider =
    AutoDisposeProvider<SocialRepositoryImpl>.internal(
  socialRepository,
  name: r'socialRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$socialRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SocialRepositoryRef = AutoDisposeProviderRef<SocialRepositoryImpl>;
String _$addFriendUseCaseHash() => r'9999ff6bc9748c765c0f737b96dd6a5b9bf66f2b';

/// 友達追加ユースケースプロバイダー
///
/// Copied from [addFriendUseCase].
@ProviderFor(addFriendUseCase)
final addFriendUseCaseProvider = AutoDisposeProvider<AddFriendUseCase>.internal(
  addFriendUseCase,
  name: r'addFriendUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$addFriendUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AddFriendUseCaseRef = AutoDisposeProviderRef<AddFriendUseCase>;
String _$getFriendsRankingUseCaseHash() =>
    r'1a8b0fa390ccaa2266c14badefabaffd9f504d51';

/// 友達ランキング取得ユースケースプロバイダー
///
/// Copied from [getFriendsRankingUseCase].
@ProviderFor(getFriendsRankingUseCase)
final getFriendsRankingUseCaseProvider =
    AutoDisposeProvider<GetFriendsRankingUseCase>.internal(
  getFriendsRankingUseCase,
  name: r'getFriendsRankingUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getFriendsRankingUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetFriendsRankingUseCaseRef
    = AutoDisposeProviderRef<GetFriendsRankingUseCase>;
String _$currentFriendsCountHash() =>
    r'8ce7f99477c34ba8bf968616d2e13419a84f2343';

/// 現在の友達数プロバイダー
///
/// Copied from [currentFriendsCount].
@ProviderFor(currentFriendsCount)
final currentFriendsCountProvider = AutoDisposeFutureProvider<int>.internal(
  currentFriendsCount,
  name: r'currentFriendsCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentFriendsCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentFriendsCountRef = AutoDisposeFutureProviderRef<int>;
String _$canAddMoreFriendsHash() => r'd3447dc999d0e80b6c19eb3b941223851d29fcf7';

/// 友達追加可能性プロバイダー
///
/// Copied from [canAddMoreFriends].
@ProviderFor(canAddMoreFriends)
final canAddMoreFriendsProvider = AutoDisposeFutureProvider<bool>.internal(
  canAddMoreFriends,
  name: r'canAddMoreFriendsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$canAddMoreFriendsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CanAddMoreFriendsRef = AutoDisposeFutureProviderRef<bool>;
String _$friendsListHash() => r'58ab2c13a692bf9a745d250b292c3d3b71bbd6c2';

/// 友達リストプロバイダー
///
/// Copied from [FriendsList].
@ProviderFor(FriendsList)
final friendsListProvider =
    AutoDisposeAsyncNotifierProvider<FriendsList, List<UserProfile>>.internal(
  FriendsList.new,
  name: r'friendsListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$friendsListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$FriendsList = AutoDisposeAsyncNotifier<List<UserProfile>>;
String _$friendsListStreamHash() => r'88dd63be06a0f18cb59b25905c06448c98beb2d5';

/// 友達リストをリアルタイムで監視するプロバイダー
///
/// Copied from [FriendsListStream].
@ProviderFor(FriendsListStream)
final friendsListStreamProvider = AutoDisposeStreamNotifierProvider<
    FriendsListStream, List<UserProfile>>.internal(
  FriendsListStream.new,
  name: r'friendsListStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$friendsListStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$FriendsListStream = AutoDisposeStreamNotifier<List<UserProfile>>;
String _$friendInvitationsHash() => r'd5ca4ad93d52f4f8ca0343e3875efd5763a830df';

/// 友達招待プロバイダー
///
/// Copied from [FriendInvitations].
@ProviderFor(FriendInvitations)
final friendInvitationsProvider = AutoDisposeAsyncNotifierProvider<
    FriendInvitations, Map<String, List<dynamic>>>.internal(
  FriendInvitations.new,
  name: r'friendInvitationsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$friendInvitationsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$FriendInvitations
    = AutoDisposeAsyncNotifier<Map<String, List<dynamic>>>;
String _$friendInvitationsStreamHash() =>
    r'1bfb01e235bf8d52134584a055e29770ed84a1fe';

/// 友達招待をリアルタイムで監視するプロバイダー
///
/// Copied from [FriendInvitationsStream].
@ProviderFor(FriendInvitationsStream)
final friendInvitationsStreamProvider = AutoDisposeStreamNotifierProvider<
    FriendInvitationsStream, List<dynamic>>.internal(
  FriendInvitationsStream.new,
  name: r'friendInvitationsStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$friendInvitationsStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$FriendInvitationsStream = AutoDisposeStreamNotifier<List<dynamic>>;
String _$weeklyRankingHash() => r'5a27af1ce7b6a4aab4a3e950f66826454b5776c8';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$WeeklyRanking
    extends BuildlessAutoDisposeAsyncNotifier<List<dynamic>> {
  late final DateTime? startDate;
  late final DateTime? endDate;

  FutureOr<List<dynamic>> build({
    DateTime? startDate,
    DateTime? endDate,
  });
}

/// 週間ランキングプロバイダー
///
/// Copied from [WeeklyRanking].
@ProviderFor(WeeklyRanking)
const weeklyRankingProvider = WeeklyRankingFamily();

/// 週間ランキングプロバイダー
///
/// Copied from [WeeklyRanking].
class WeeklyRankingFamily extends Family<AsyncValue<List<dynamic>>> {
  /// 週間ランキングプロバイダー
  ///
  /// Copied from [WeeklyRanking].
  const WeeklyRankingFamily();

  /// 週間ランキングプロバイダー
  ///
  /// Copied from [WeeklyRanking].
  WeeklyRankingProvider call({
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return WeeklyRankingProvider(
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  WeeklyRankingProvider getProviderOverride(
    covariant WeeklyRankingProvider provider,
  ) {
    return call(
      startDate: provider.startDate,
      endDate: provider.endDate,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'weeklyRankingProvider';
}

/// 週間ランキングプロバイダー
///
/// Copied from [WeeklyRanking].
class WeeklyRankingProvider
    extends AutoDisposeAsyncNotifierProviderImpl<WeeklyRanking, List<dynamic>> {
  /// 週間ランキングプロバイダー
  ///
  /// Copied from [WeeklyRanking].
  WeeklyRankingProvider({
    DateTime? startDate,
    DateTime? endDate,
  }) : this._internal(
          () => WeeklyRanking()
            ..startDate = startDate
            ..endDate = endDate,
          from: weeklyRankingProvider,
          name: r'weeklyRankingProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$weeklyRankingHash,
          dependencies: WeeklyRankingFamily._dependencies,
          allTransitiveDependencies:
              WeeklyRankingFamily._allTransitiveDependencies,
          startDate: startDate,
          endDate: endDate,
        );

  WeeklyRankingProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.startDate,
    required this.endDate,
  }) : super.internal();

  final DateTime? startDate;
  final DateTime? endDate;

  @override
  FutureOr<List<dynamic>> runNotifierBuild(
    covariant WeeklyRanking notifier,
  ) {
    return notifier.build(
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  Override overrideWith(WeeklyRanking Function() create) {
    return ProviderOverride(
      origin: this,
      override: WeeklyRankingProvider._internal(
        () => create()
          ..startDate = startDate
          ..endDate = endDate,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        startDate: startDate,
        endDate: endDate,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<WeeklyRanking, List<dynamic>>
      createElement() {
    return _WeeklyRankingProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WeeklyRankingProvider &&
        other.startDate == startDate &&
        other.endDate == endDate;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, startDate.hashCode);
    hash = _SystemHash.combine(hash, endDate.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin WeeklyRankingRef on AutoDisposeAsyncNotifierProviderRef<List<dynamic>> {
  /// The parameter `startDate` of this provider.
  DateTime? get startDate;

  /// The parameter `endDate` of this provider.
  DateTime? get endDate;
}

class _WeeklyRankingProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<WeeklyRanking,
        List<dynamic>> with WeeklyRankingRef {
  _WeeklyRankingProviderElement(super.provider);

  @override
  DateTime? get startDate => (origin as WeeklyRankingProvider).startDate;
  @override
  DateTime? get endDate => (origin as WeeklyRankingProvider).endDate;
}

String _$monthlyRankingHash() => r'3fa2c8c7d0d4d3c0616e6e53d2e9df5835ecccb4';

abstract class _$MonthlyRanking
    extends BuildlessAutoDisposeAsyncNotifier<List<dynamic>> {
  late final int? year;
  late final int? month;

  FutureOr<List<dynamic>> build({
    int? year,
    int? month,
  });
}

/// 月間ランキングプロバイダー
///
/// Copied from [MonthlyRanking].
@ProviderFor(MonthlyRanking)
const monthlyRankingProvider = MonthlyRankingFamily();

/// 月間ランキングプロバイダー
///
/// Copied from [MonthlyRanking].
class MonthlyRankingFamily extends Family<AsyncValue<List<dynamic>>> {
  /// 月間ランキングプロバイダー
  ///
  /// Copied from [MonthlyRanking].
  const MonthlyRankingFamily();

  /// 月間ランキングプロバイダー
  ///
  /// Copied from [MonthlyRanking].
  MonthlyRankingProvider call({
    int? year,
    int? month,
  }) {
    return MonthlyRankingProvider(
      year: year,
      month: month,
    );
  }

  @override
  MonthlyRankingProvider getProviderOverride(
    covariant MonthlyRankingProvider provider,
  ) {
    return call(
      year: provider.year,
      month: provider.month,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'monthlyRankingProvider';
}

/// 月間ランキングプロバイダー
///
/// Copied from [MonthlyRanking].
class MonthlyRankingProvider extends AutoDisposeAsyncNotifierProviderImpl<
    MonthlyRanking, List<dynamic>> {
  /// 月間ランキングプロバイダー
  ///
  /// Copied from [MonthlyRanking].
  MonthlyRankingProvider({
    int? year,
    int? month,
  }) : this._internal(
          () => MonthlyRanking()
            ..year = year
            ..month = month,
          from: monthlyRankingProvider,
          name: r'monthlyRankingProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$monthlyRankingHash,
          dependencies: MonthlyRankingFamily._dependencies,
          allTransitiveDependencies:
              MonthlyRankingFamily._allTransitiveDependencies,
          year: year,
          month: month,
        );

  MonthlyRankingProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.year,
    required this.month,
  }) : super.internal();

  final int? year;
  final int? month;

  @override
  FutureOr<List<dynamic>> runNotifierBuild(
    covariant MonthlyRanking notifier,
  ) {
    return notifier.build(
      year: year,
      month: month,
    );
  }

  @override
  Override overrideWith(MonthlyRanking Function() create) {
    return ProviderOverride(
      origin: this,
      override: MonthlyRankingProvider._internal(
        () => create()
          ..year = year
          ..month = month,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        year: year,
        month: month,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<MonthlyRanking, List<dynamic>>
      createElement() {
    return _MonthlyRankingProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MonthlyRankingProvider &&
        other.year == year &&
        other.month == month;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, year.hashCode);
    hash = _SystemHash.combine(hash, month.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MonthlyRankingRef on AutoDisposeAsyncNotifierProviderRef<List<dynamic>> {
  /// The parameter `year` of this provider.
  int? get year;

  /// The parameter `month` of this provider.
  int? get month;
}

class _MonthlyRankingProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<MonthlyRanking,
        List<dynamic>> with MonthlyRankingRef {
  _MonthlyRankingProviderElement(super.provider);

  @override
  int? get year => (origin as MonthlyRankingProvider).year;
  @override
  int? get month => (origin as MonthlyRankingProvider).month;
}

String _$rankingStreamHash() => r'f7143c55b27bf7d99949e3940d07ab0e86f8a871';

abstract class _$RankingStream
    extends BuildlessAutoDisposeStreamNotifier<List<dynamic>> {
  late final dynamic period;

  Stream<List<dynamic>> build(
    dynamic period,
  );
}

/// ランキングをリアルタイムで監視するプロバイダー
///
/// Copied from [RankingStream].
@ProviderFor(RankingStream)
const rankingStreamProvider = RankingStreamFamily();

/// ランキングをリアルタイムで監視するプロバイダー
///
/// Copied from [RankingStream].
class RankingStreamFamily extends Family<AsyncValue<List<dynamic>>> {
  /// ランキングをリアルタイムで監視するプロバイダー
  ///
  /// Copied from [RankingStream].
  const RankingStreamFamily();

  /// ランキングをリアルタイムで監視するプロバイダー
  ///
  /// Copied from [RankingStream].
  RankingStreamProvider call(
    dynamic period,
  ) {
    return RankingStreamProvider(
      period,
    );
  }

  @override
  RankingStreamProvider getProviderOverride(
    covariant RankingStreamProvider provider,
  ) {
    return call(
      provider.period,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'rankingStreamProvider';
}

/// ランキングをリアルタイムで監視するプロバイダー
///
/// Copied from [RankingStream].
class RankingStreamProvider extends AutoDisposeStreamNotifierProviderImpl<
    RankingStream, List<dynamic>> {
  /// ランキングをリアルタイムで監視するプロバイダー
  ///
  /// Copied from [RankingStream].
  RankingStreamProvider(
    dynamic period,
  ) : this._internal(
          () => RankingStream()..period = period,
          from: rankingStreamProvider,
          name: r'rankingStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$rankingStreamHash,
          dependencies: RankingStreamFamily._dependencies,
          allTransitiveDependencies:
              RankingStreamFamily._allTransitiveDependencies,
          period: period,
        );

  RankingStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.period,
  }) : super.internal();

  final dynamic period;

  @override
  Stream<List<dynamic>> runNotifierBuild(
    covariant RankingStream notifier,
  ) {
    return notifier.build(
      period,
    );
  }

  @override
  Override overrideWith(RankingStream Function() create) {
    return ProviderOverride(
      origin: this,
      override: RankingStreamProvider._internal(
        () => create()..period = period,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        period: period,
      ),
    );
  }

  @override
  AutoDisposeStreamNotifierProviderElement<RankingStream, List<dynamic>>
      createElement() {
    return _RankingStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RankingStreamProvider && other.period == period;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, period.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RankingStreamRef on AutoDisposeStreamNotifierProviderRef<List<dynamic>> {
  /// The parameter `period` of this provider.
  dynamic get period;
}

class _RankingStreamProviderElement
    extends AutoDisposeStreamNotifierProviderElement<RankingStream,
        List<dynamic>> with RankingStreamRef {
  _RankingStreamProviderElement(super.provider);

  @override
  dynamic get period => (origin as RankingStreamProvider).period;
}

String _$friendSearchHash() => r'5adaba753db9152c7583d917f1d8f4bf3e34e885';

abstract class _$FriendSearch
    extends BuildlessAutoDisposeAsyncNotifier<List<UserProfile>> {
  late final String query;

  FutureOr<List<UserProfile>> build(
    String query,
  );
}

/// 友達検索プロバイダー
///
/// Copied from [FriendSearch].
@ProviderFor(FriendSearch)
const friendSearchProvider = FriendSearchFamily();

/// 友達検索プロバイダー
///
/// Copied from [FriendSearch].
class FriendSearchFamily extends Family<AsyncValue<List<UserProfile>>> {
  /// 友達検索プロバイダー
  ///
  /// Copied from [FriendSearch].
  const FriendSearchFamily();

  /// 友達検索プロバイダー
  ///
  /// Copied from [FriendSearch].
  FriendSearchProvider call(
    String query,
  ) {
    return FriendSearchProvider(
      query,
    );
  }

  @override
  FriendSearchProvider getProviderOverride(
    covariant FriendSearchProvider provider,
  ) {
    return call(
      provider.query,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'friendSearchProvider';
}

/// 友達検索プロバイダー
///
/// Copied from [FriendSearch].
class FriendSearchProvider extends AutoDisposeAsyncNotifierProviderImpl<
    FriendSearch, List<UserProfile>> {
  /// 友達検索プロバイダー
  ///
  /// Copied from [FriendSearch].
  FriendSearchProvider(
    String query,
  ) : this._internal(
          () => FriendSearch()..query = query,
          from: friendSearchProvider,
          name: r'friendSearchProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$friendSearchHash,
          dependencies: FriendSearchFamily._dependencies,
          allTransitiveDependencies:
              FriendSearchFamily._allTransitiveDependencies,
          query: query,
        );

  FriendSearchProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
  }) : super.internal();

  final String query;

  @override
  FutureOr<List<UserProfile>> runNotifierBuild(
    covariant FriendSearch notifier,
  ) {
    return notifier.build(
      query,
    );
  }

  @override
  Override overrideWith(FriendSearch Function() create) {
    return ProviderOverride(
      origin: this,
      override: FriendSearchProvider._internal(
        () => create()..query = query,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<FriendSearch, List<UserProfile>>
      createElement() {
    return _FriendSearchProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FriendSearchProvider && other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FriendSearchRef
    on AutoDisposeAsyncNotifierProviderRef<List<UserProfile>> {
  /// The parameter `query` of this provider.
  String get query;
}

class _FriendSearchProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<FriendSearch,
        List<UserProfile>> with FriendSearchRef {
  _FriendSearchProviderElement(super.provider);

  @override
  String get query => (origin as FriendSearchProvider).query;
}

String _$friendsStatisticsHash() => r'ce70d5f4528dba20da6ff46b8e0820611cbcc0c5';

/// 友達数統計プロバイダー
///
/// Copied from [FriendsStatistics].
@ProviderFor(FriendsStatistics)
final friendsStatisticsProvider = AutoDisposeAsyncNotifierProvider<
    FriendsStatistics, Map<String, dynamic>>.internal(
  FriendsStatistics.new,
  name: r'friendsStatisticsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$friendsStatisticsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$FriendsStatistics = AutoDisposeAsyncNotifier<Map<String, dynamic>>;
String _$friendActivityDataHash() =>
    r'28b288415750ab40fdc67ef8b3f9e50f59ec786a';

abstract class _$FriendActivityData
    extends BuildlessAutoDisposeAsyncNotifier<List<dynamic>> {
  late final String friendId;
  late final DateTime startDate;
  late final DateTime endDate;

  FutureOr<List<dynamic>> build({
    required String friendId,
    required DateTime startDate,
    required DateTime endDate,
  });
}

/// 友達のアクティビティデータプロバイダー
///
/// Copied from [FriendActivityData].
@ProviderFor(FriendActivityData)
const friendActivityDataProvider = FriendActivityDataFamily();

/// 友達のアクティビティデータプロバイダー
///
/// Copied from [FriendActivityData].
class FriendActivityDataFamily extends Family<AsyncValue<List<dynamic>>> {
  /// 友達のアクティビティデータプロバイダー
  ///
  /// Copied from [FriendActivityData].
  const FriendActivityDataFamily();

  /// 友達のアクティビティデータプロバイダー
  ///
  /// Copied from [FriendActivityData].
  FriendActivityDataProvider call({
    required String friendId,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return FriendActivityDataProvider(
      friendId: friendId,
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  FriendActivityDataProvider getProviderOverride(
    covariant FriendActivityDataProvider provider,
  ) {
    return call(
      friendId: provider.friendId,
      startDate: provider.startDate,
      endDate: provider.endDate,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'friendActivityDataProvider';
}

/// 友達のアクティビティデータプロバイダー
///
/// Copied from [FriendActivityData].
class FriendActivityDataProvider extends AutoDisposeAsyncNotifierProviderImpl<
    FriendActivityData, List<dynamic>> {
  /// 友達のアクティビティデータプロバイダー
  ///
  /// Copied from [FriendActivityData].
  FriendActivityDataProvider({
    required String friendId,
    required DateTime startDate,
    required DateTime endDate,
  }) : this._internal(
          () => FriendActivityData()
            ..friendId = friendId
            ..startDate = startDate
            ..endDate = endDate,
          from: friendActivityDataProvider,
          name: r'friendActivityDataProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$friendActivityDataHash,
          dependencies: FriendActivityDataFamily._dependencies,
          allTransitiveDependencies:
              FriendActivityDataFamily._allTransitiveDependencies,
          friendId: friendId,
          startDate: startDate,
          endDate: endDate,
        );

  FriendActivityDataProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.friendId,
    required this.startDate,
    required this.endDate,
  }) : super.internal();

  final String friendId;
  final DateTime startDate;
  final DateTime endDate;

  @override
  FutureOr<List<dynamic>> runNotifierBuild(
    covariant FriendActivityData notifier,
  ) {
    return notifier.build(
      friendId: friendId,
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  Override overrideWith(FriendActivityData Function() create) {
    return ProviderOverride(
      origin: this,
      override: FriendActivityDataProvider._internal(
        () => create()
          ..friendId = friendId
          ..startDate = startDate
          ..endDate = endDate,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        friendId: friendId,
        startDate: startDate,
        endDate: endDate,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<FriendActivityData, List<dynamic>>
      createElement() {
    return _FriendActivityDataProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FriendActivityDataProvider &&
        other.friendId == friendId &&
        other.startDate == startDate &&
        other.endDate == endDate;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, friendId.hashCode);
    hash = _SystemHash.combine(hash, startDate.hashCode);
    hash = _SystemHash.combine(hash, endDate.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FriendActivityDataRef
    on AutoDisposeAsyncNotifierProviderRef<List<dynamic>> {
  /// The parameter `friendId` of this provider.
  String get friendId;

  /// The parameter `startDate` of this provider.
  DateTime get startDate;

  /// The parameter `endDate` of this provider.
  DateTime get endDate;
}

class _FriendActivityDataProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<FriendActivityData,
        List<dynamic>> with FriendActivityDataRef {
  _FriendActivityDataProviderElement(super.provider);

  @override
  String get friendId => (origin as FriendActivityDataProvider).friendId;
  @override
  DateTime get startDate => (origin as FriendActivityDataProvider).startDate;
  @override
  DateTime get endDate => (origin as FriendActivityDataProvider).endDate;
}

String _$friendComparisonHash() => r'1350217bf851e61d2b269223af4b451c4fc5932b';

abstract class _$FriendComparison
    extends BuildlessAutoDisposeAsyncNotifier<Map<String, dynamic>> {
  late final String friendId;
  late final dynamic period;

  FutureOr<Map<String, dynamic>> build({
    required String friendId,
    required dynamic period,
  });
}

/// 友達との比較データプロバイダー
///
/// Copied from [FriendComparison].
@ProviderFor(FriendComparison)
const friendComparisonProvider = FriendComparisonFamily();

/// 友達との比較データプロバイダー
///
/// Copied from [FriendComparison].
class FriendComparisonFamily extends Family<AsyncValue<Map<String, dynamic>>> {
  /// 友達との比較データプロバイダー
  ///
  /// Copied from [FriendComparison].
  const FriendComparisonFamily();

  /// 友達との比較データプロバイダー
  ///
  /// Copied from [FriendComparison].
  FriendComparisonProvider call({
    required String friendId,
    required dynamic period,
  }) {
    return FriendComparisonProvider(
      friendId: friendId,
      period: period,
    );
  }

  @override
  FriendComparisonProvider getProviderOverride(
    covariant FriendComparisonProvider provider,
  ) {
    return call(
      friendId: provider.friendId,
      period: provider.period,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'friendComparisonProvider';
}

/// 友達との比較データプロバイダー
///
/// Copied from [FriendComparison].
class FriendComparisonProvider extends AutoDisposeAsyncNotifierProviderImpl<
    FriendComparison, Map<String, dynamic>> {
  /// 友達との比較データプロバイダー
  ///
  /// Copied from [FriendComparison].
  FriendComparisonProvider({
    required String friendId,
    required dynamic period,
  }) : this._internal(
          () => FriendComparison()
            ..friendId = friendId
            ..period = period,
          from: friendComparisonProvider,
          name: r'friendComparisonProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$friendComparisonHash,
          dependencies: FriendComparisonFamily._dependencies,
          allTransitiveDependencies:
              FriendComparisonFamily._allTransitiveDependencies,
          friendId: friendId,
          period: period,
        );

  FriendComparisonProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.friendId,
    required this.period,
  }) : super.internal();

  final String friendId;
  final dynamic period;

  @override
  FutureOr<Map<String, dynamic>> runNotifierBuild(
    covariant FriendComparison notifier,
  ) {
    return notifier.build(
      friendId: friendId,
      period: period,
    );
  }

  @override
  Override overrideWith(FriendComparison Function() create) {
    return ProviderOverride(
      origin: this,
      override: FriendComparisonProvider._internal(
        () => create()
          ..friendId = friendId
          ..period = period,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        friendId: friendId,
        period: period,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<FriendComparison,
      Map<String, dynamic>> createElement() {
    return _FriendComparisonProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FriendComparisonProvider &&
        other.friendId == friendId &&
        other.period == period;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, friendId.hashCode);
    hash = _SystemHash.combine(hash, period.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FriendComparisonRef
    on AutoDisposeAsyncNotifierProviderRef<Map<String, dynamic>> {
  /// The parameter `friendId` of this provider.
  String get friendId;

  /// The parameter `period` of this provider.
  dynamic get period;
}

class _FriendComparisonProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<FriendComparison,
        Map<String, dynamic>> with FriendComparisonRef {
  _FriendComparisonProviderElement(super.provider);

  @override
  String get friendId => (origin as FriendComparisonProvider).friendId;
  @override
  dynamic get period => (origin as FriendComparisonProvider).period;
}

String _$socialManagerHash() => r'15942c6d3ec14ee040679dce10f4414afb2f74c9';

/// ソーシャル機能の統合プロバイダー
///
/// Copied from [SocialManager].
@ProviderFor(SocialManager)
final socialManagerProvider = AutoDisposeAsyncNotifierProvider<SocialManager,
    Map<String, dynamic>>.internal(
  SocialManager.new,
  name: r'socialManagerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$socialManagerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SocialManager = AutoDisposeAsyncNotifier<Map<String, dynamic>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
