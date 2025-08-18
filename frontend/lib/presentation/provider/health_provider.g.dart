// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$healthLocalDataSourceHash() =>
    r'adc8d6c8e2d143b2c7a773893a99dd9c93ce504b';

/// ヘルスローカルデータソースプロバイダー
///
/// Copied from [healthLocalDataSource].
@ProviderFor(healthLocalDataSource)
final healthLocalDataSourceProvider =
    AutoDisposeProvider<HealthLocalDataSource>.internal(
  healthLocalDataSource,
  name: r'healthLocalDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$healthLocalDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HealthLocalDataSourceRef
    = AutoDisposeProviderRef<HealthLocalDataSource>;
String _$healthApiDataSourceHash() =>
    r'59801e5e1ddd58fca9a85f4a4f5bfbf64409dbaf';

/// ヘルスAPIデータソースプロバイダー
///
/// Copied from [healthApiDataSource].
@ProviderFor(healthApiDataSource)
final healthApiDataSourceProvider =
    AutoDisposeProvider<HealthApiDataSource>.internal(
  healthApiDataSource,
  name: r'healthApiDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$healthApiDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HealthApiDataSourceRef = AutoDisposeProviderRef<HealthApiDataSource>;
String _$healthRepositoryHash() => r'3b68bb85f8788586e1c37328c3ff550109b46976';

/// ヘルスリポジトリプロバイダー
///
/// Copied from [healthRepository].
@ProviderFor(healthRepository)
final healthRepositoryProvider =
    AutoDisposeProvider<HealthRepositoryImpl>.internal(
  healthRepository,
  name: r'healthRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$healthRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HealthRepositoryRef = AutoDisposeProviderRef<HealthRepositoryImpl>;
String _$getStepDataUseCaseHash() =>
    r'3279ed8cea5a67dcc08bd5ef352826724f59af9d';

/// 歩数データ取得ユースケースプロバイダー
///
/// Copied from [getStepDataUseCase].
@ProviderFor(getStepDataUseCase)
final getStepDataUseCaseProvider =
    AutoDisposeProvider<GetStepDataUseCase>.internal(
  getStepDataUseCase,
  name: r'getStepDataUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getStepDataUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetStepDataUseCaseRef = AutoDisposeProviderRef<GetStepDataUseCase>;
String _$calculateActivityLevelUseCaseHash() =>
    r'e7aaa1996ceecfcafd76b8cbd3a8da3531f0f484';

/// アクティビティレベル計算ユースケースプロバイダー
///
/// Copied from [calculateActivityLevelUseCase].
@ProviderFor(calculateActivityLevelUseCase)
final calculateActivityLevelUseCaseProvider =
    AutoDisposeProvider<CalculateActivityLevelUseCase>.internal(
  calculateActivityLevelUseCase,
  name: r'calculateActivityLevelUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$calculateActivityLevelUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CalculateActivityLevelUseCaseRef
    = AutoDisposeProviderRef<CalculateActivityLevelUseCase>;
String _$syncHealthDataUseCaseHash() =>
    r'1d4968aecd70cbb87fa132a5af705e6f7df0f206';

/// ヘルスデータ同期ユースケースプロバイダー
///
/// Copied from [syncHealthDataUseCase].
@ProviderFor(syncHealthDataUseCase)
final syncHealthDataUseCaseProvider =
    AutoDisposeProvider<SyncHealthDataUseCase>.internal(
  syncHealthDataUseCase,
  name: r'syncHealthDataUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$syncHealthDataUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SyncHealthDataUseCaseRef
    = AutoDisposeProviderRef<SyncHealthDataUseCase>;
String _$todayStepDataHash() => r'7303a3fcf0398d2532ec49ef508e9fc5025ba21e';

/// 今日の歩数データプロバイダー
///
/// Copied from [TodayStepData].
@ProviderFor(TodayStepData)
final todayStepDataProvider =
    AutoDisposeAsyncNotifierProvider<TodayStepData, HealthData?>.internal(
  TodayStepData.new,
  name: r'todayStepDataProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$todayStepDataHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TodayStepData = AutoDisposeAsyncNotifier<HealthData?>;
String _$stepDataRangeHash() => r'2204f55bd6637b4eaf054ca7888c1f0c11d1743c';

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

abstract class _$StepDataRange
    extends BuildlessAutoDisposeAsyncNotifier<List<HealthData>> {
  late final DateTime startDate;
  late final DateTime endDate;

  FutureOr<List<HealthData>> build({
    required DateTime startDate,
    required DateTime endDate,
  });
}

/// 指定期間の歩数データプロバイダー
///
/// Copied from [StepDataRange].
@ProviderFor(StepDataRange)
const stepDataRangeProvider = StepDataRangeFamily();

/// 指定期間の歩数データプロバイダー
///
/// Copied from [StepDataRange].
class StepDataRangeFamily extends Family<AsyncValue<List<HealthData>>> {
  /// 指定期間の歩数データプロバイダー
  ///
  /// Copied from [StepDataRange].
  const StepDataRangeFamily();

  /// 指定期間の歩数データプロバイダー
  ///
  /// Copied from [StepDataRange].
  StepDataRangeProvider call({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return StepDataRangeProvider(
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  StepDataRangeProvider getProviderOverride(
    covariant StepDataRangeProvider provider,
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
  String? get name => r'stepDataRangeProvider';
}

/// 指定期間の歩数データプロバイダー
///
/// Copied from [StepDataRange].
class StepDataRangeProvider extends AutoDisposeAsyncNotifierProviderImpl<
    StepDataRange, List<HealthData>> {
  /// 指定期間の歩数データプロバイダー
  ///
  /// Copied from [StepDataRange].
  StepDataRangeProvider({
    required DateTime startDate,
    required DateTime endDate,
  }) : this._internal(
          () => StepDataRange()
            ..startDate = startDate
            ..endDate = endDate,
          from: stepDataRangeProvider,
          name: r'stepDataRangeProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$stepDataRangeHash,
          dependencies: StepDataRangeFamily._dependencies,
          allTransitiveDependencies:
              StepDataRangeFamily._allTransitiveDependencies,
          startDate: startDate,
          endDate: endDate,
        );

  StepDataRangeProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.startDate,
    required this.endDate,
  }) : super.internal();

  final DateTime startDate;
  final DateTime endDate;

  @override
  FutureOr<List<HealthData>> runNotifierBuild(
    covariant StepDataRange notifier,
  ) {
    return notifier.build(
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  Override overrideWith(StepDataRange Function() create) {
    return ProviderOverride(
      origin: this,
      override: StepDataRangeProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<StepDataRange, List<HealthData>>
      createElement() {
    return _StepDataRangeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StepDataRangeProvider &&
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
mixin StepDataRangeRef
    on AutoDisposeAsyncNotifierProviderRef<List<HealthData>> {
  /// The parameter `startDate` of this provider.
  DateTime get startDate;

  /// The parameter `endDate` of this provider.
  DateTime get endDate;
}

class _StepDataRangeProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<StepDataRange,
        List<HealthData>> with StepDataRangeRef {
  _StepDataRangeProviderElement(super.provider);

  @override
  DateTime get startDate => (origin as StepDataRangeProvider).startDate;
  @override
  DateTime get endDate => (origin as StepDataRangeProvider).endDate;
}

String _$todayStepDataStreamHash() =>
    r'10a2212e1b78561175647bf298a38670a1a0a1e7';

/// 今日の歩数データをリアルタイムで監視するプロバイダー
///
/// Copied from [TodayStepDataStream].
@ProviderFor(TodayStepDataStream)
final todayStepDataStreamProvider = AutoDisposeStreamNotifierProvider<
    TodayStepDataStream, HealthData?>.internal(
  TodayStepDataStream.new,
  name: r'todayStepDataStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$todayStepDataStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TodayStepDataStream = AutoDisposeStreamNotifier<HealthData?>;
String _$yearlyActivityVisualizationHash() =>
    r'fb794992059433dbe60d592b03d72e8b8240271d';

abstract class _$YearlyActivityVisualization
    extends BuildlessAutoDisposeAsyncNotifier<
        List<List<ActivityVisualization>>> {
  late final int year;
  late final int goalSteps;

  FutureOr<List<List<ActivityVisualization>>> build({
    required int year,
    int goalSteps = 8000,
  });
}

/// 年間アクティビティ視覚化データプロバイダー
///
/// Copied from [YearlyActivityVisualization].
@ProviderFor(YearlyActivityVisualization)
const yearlyActivityVisualizationProvider = YearlyActivityVisualizationFamily();

/// 年間アクティビティ視覚化データプロバイダー
///
/// Copied from [YearlyActivityVisualization].
class YearlyActivityVisualizationFamily
    extends Family<AsyncValue<List<List<ActivityVisualization>>>> {
  /// 年間アクティビティ視覚化データプロバイダー
  ///
  /// Copied from [YearlyActivityVisualization].
  const YearlyActivityVisualizationFamily();

  /// 年間アクティビティ視覚化データプロバイダー
  ///
  /// Copied from [YearlyActivityVisualization].
  YearlyActivityVisualizationProvider call({
    required int year,
    int goalSteps = 8000,
  }) {
    return YearlyActivityVisualizationProvider(
      year: year,
      goalSteps: goalSteps,
    );
  }

  @override
  YearlyActivityVisualizationProvider getProviderOverride(
    covariant YearlyActivityVisualizationProvider provider,
  ) {
    return call(
      year: provider.year,
      goalSteps: provider.goalSteps,
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
  String? get name => r'yearlyActivityVisualizationProvider';
}

/// 年間アクティビティ視覚化データプロバイダー
///
/// Copied from [YearlyActivityVisualization].
class YearlyActivityVisualizationProvider
    extends AutoDisposeAsyncNotifierProviderImpl<YearlyActivityVisualization,
        List<List<ActivityVisualization>>> {
  /// 年間アクティビティ視覚化データプロバイダー
  ///
  /// Copied from [YearlyActivityVisualization].
  YearlyActivityVisualizationProvider({
    required int year,
    int goalSteps = 8000,
  }) : this._internal(
          () => YearlyActivityVisualization()
            ..year = year
            ..goalSteps = goalSteps,
          from: yearlyActivityVisualizationProvider,
          name: r'yearlyActivityVisualizationProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$yearlyActivityVisualizationHash,
          dependencies: YearlyActivityVisualizationFamily._dependencies,
          allTransitiveDependencies:
              YearlyActivityVisualizationFamily._allTransitiveDependencies,
          year: year,
          goalSteps: goalSteps,
        );

  YearlyActivityVisualizationProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.year,
    required this.goalSteps,
  }) : super.internal();

  final int year;
  final int goalSteps;

  @override
  FutureOr<List<List<ActivityVisualization>>> runNotifierBuild(
    covariant YearlyActivityVisualization notifier,
  ) {
    return notifier.build(
      year: year,
      goalSteps: goalSteps,
    );
  }

  @override
  Override overrideWith(YearlyActivityVisualization Function() create) {
    return ProviderOverride(
      origin: this,
      override: YearlyActivityVisualizationProvider._internal(
        () => create()
          ..year = year
          ..goalSteps = goalSteps,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        year: year,
        goalSteps: goalSteps,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<YearlyActivityVisualization,
      List<List<ActivityVisualization>>> createElement() {
    return _YearlyActivityVisualizationProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is YearlyActivityVisualizationProvider &&
        other.year == year &&
        other.goalSteps == goalSteps;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, year.hashCode);
    hash = _SystemHash.combine(hash, goalSteps.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin YearlyActivityVisualizationRef
    on AutoDisposeAsyncNotifierProviderRef<List<List<ActivityVisualization>>> {
  /// The parameter `year` of this provider.
  int get year;

  /// The parameter `goalSteps` of this provider.
  int get goalSteps;
}

class _YearlyActivityVisualizationProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<YearlyActivityVisualization,
        List<List<ActivityVisualization>>> with YearlyActivityVisualizationRef {
  _YearlyActivityVisualizationProviderElement(super.provider);

  @override
  int get year => (origin as YearlyActivityVisualizationProvider).year;
  @override
  int get goalSteps =>
      (origin as YearlyActivityVisualizationProvider).goalSteps;
}

String _$monthlyStepDataHash() => r'617f30cb520e7fd6ecf40ba6ccb3a2ab213837f1';

abstract class _$MonthlyStepData
    extends BuildlessAutoDisposeAsyncNotifier<List<HealthData>> {
  late final int year;
  late final int month;

  FutureOr<List<HealthData>> build({
    required int year,
    required int month,
  });
}

/// 月間歩数データプロバイダー
///
/// Copied from [MonthlyStepData].
@ProviderFor(MonthlyStepData)
const monthlyStepDataProvider = MonthlyStepDataFamily();

/// 月間歩数データプロバイダー
///
/// Copied from [MonthlyStepData].
class MonthlyStepDataFamily extends Family<AsyncValue<List<HealthData>>> {
  /// 月間歩数データプロバイダー
  ///
  /// Copied from [MonthlyStepData].
  const MonthlyStepDataFamily();

  /// 月間歩数データプロバイダー
  ///
  /// Copied from [MonthlyStepData].
  MonthlyStepDataProvider call({
    required int year,
    required int month,
  }) {
    return MonthlyStepDataProvider(
      year: year,
      month: month,
    );
  }

  @override
  MonthlyStepDataProvider getProviderOverride(
    covariant MonthlyStepDataProvider provider,
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
  String? get name => r'monthlyStepDataProvider';
}

/// 月間歩数データプロバイダー
///
/// Copied from [MonthlyStepData].
class MonthlyStepDataProvider extends AutoDisposeAsyncNotifierProviderImpl<
    MonthlyStepData, List<HealthData>> {
  /// 月間歩数データプロバイダー
  ///
  /// Copied from [MonthlyStepData].
  MonthlyStepDataProvider({
    required int year,
    required int month,
  }) : this._internal(
          () => MonthlyStepData()
            ..year = year
            ..month = month,
          from: monthlyStepDataProvider,
          name: r'monthlyStepDataProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$monthlyStepDataHash,
          dependencies: MonthlyStepDataFamily._dependencies,
          allTransitiveDependencies:
              MonthlyStepDataFamily._allTransitiveDependencies,
          year: year,
          month: month,
        );

  MonthlyStepDataProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.year,
    required this.month,
  }) : super.internal();

  final int year;
  final int month;

  @override
  FutureOr<List<HealthData>> runNotifierBuild(
    covariant MonthlyStepData notifier,
  ) {
    return notifier.build(
      year: year,
      month: month,
    );
  }

  @override
  Override overrideWith(MonthlyStepData Function() create) {
    return ProviderOverride(
      origin: this,
      override: MonthlyStepDataProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<MonthlyStepData, List<HealthData>>
      createElement() {
    return _MonthlyStepDataProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MonthlyStepDataProvider &&
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
mixin MonthlyStepDataRef
    on AutoDisposeAsyncNotifierProviderRef<List<HealthData>> {
  /// The parameter `year` of this provider.
  int get year;

  /// The parameter `month` of this provider.
  int get month;
}

class _MonthlyStepDataProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<MonthlyStepData,
        List<HealthData>> with MonthlyStepDataRef {
  _MonthlyStepDataProviderElement(super.provider);

  @override
  int get year => (origin as MonthlyStepDataProvider).year;
  @override
  int get month => (origin as MonthlyStepDataProvider).month;
}

String _$weeklyStepDataHash() => r'b2c4a56870e20e5317e635b6af3105da33f39816';

abstract class _$WeeklyStepData
    extends BuildlessAutoDisposeAsyncNotifier<List<HealthData>> {
  late final DateTime weekStart;

  FutureOr<List<HealthData>> build({
    required DateTime weekStart,
  });
}

/// 週間歩数データプロバイダー
///
/// Copied from [WeeklyStepData].
@ProviderFor(WeeklyStepData)
const weeklyStepDataProvider = WeeklyStepDataFamily();

/// 週間歩数データプロバイダー
///
/// Copied from [WeeklyStepData].
class WeeklyStepDataFamily extends Family<AsyncValue<List<HealthData>>> {
  /// 週間歩数データプロバイダー
  ///
  /// Copied from [WeeklyStepData].
  const WeeklyStepDataFamily();

  /// 週間歩数データプロバイダー
  ///
  /// Copied from [WeeklyStepData].
  WeeklyStepDataProvider call({
    required DateTime weekStart,
  }) {
    return WeeklyStepDataProvider(
      weekStart: weekStart,
    );
  }

  @override
  WeeklyStepDataProvider getProviderOverride(
    covariant WeeklyStepDataProvider provider,
  ) {
    return call(
      weekStart: provider.weekStart,
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
  String? get name => r'weeklyStepDataProvider';
}

/// 週間歩数データプロバイダー
///
/// Copied from [WeeklyStepData].
class WeeklyStepDataProvider extends AutoDisposeAsyncNotifierProviderImpl<
    WeeklyStepData, List<HealthData>> {
  /// 週間歩数データプロバイダー
  ///
  /// Copied from [WeeklyStepData].
  WeeklyStepDataProvider({
    required DateTime weekStart,
  }) : this._internal(
          () => WeeklyStepData()..weekStart = weekStart,
          from: weeklyStepDataProvider,
          name: r'weeklyStepDataProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$weeklyStepDataHash,
          dependencies: WeeklyStepDataFamily._dependencies,
          allTransitiveDependencies:
              WeeklyStepDataFamily._allTransitiveDependencies,
          weekStart: weekStart,
        );

  WeeklyStepDataProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.weekStart,
  }) : super.internal();

  final DateTime weekStart;

  @override
  FutureOr<List<HealthData>> runNotifierBuild(
    covariant WeeklyStepData notifier,
  ) {
    return notifier.build(
      weekStart: weekStart,
    );
  }

  @override
  Override overrideWith(WeeklyStepData Function() create) {
    return ProviderOverride(
      origin: this,
      override: WeeklyStepDataProvider._internal(
        () => create()..weekStart = weekStart,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        weekStart: weekStart,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<WeeklyStepData, List<HealthData>>
      createElement() {
    return _WeeklyStepDataProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WeeklyStepDataProvider && other.weekStart == weekStart;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, weekStart.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin WeeklyStepDataRef
    on AutoDisposeAsyncNotifierProviderRef<List<HealthData>> {
  /// The parameter `weekStart` of this provider.
  DateTime get weekStart;
}

class _WeeklyStepDataProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<WeeklyStepData,
        List<HealthData>> with WeeklyStepDataRef {
  _WeeklyStepDataProviderElement(super.provider);

  @override
  DateTime get weekStart => (origin as WeeklyStepDataProvider).weekStart;
}

String _$healthDataSyncHash() => r'a8fddef01720b7b3bbd012348f5fd0da05992ad9';

/// ヘルスデータ同期状態プロバイダー
///
/// Copied from [HealthDataSync].
@ProviderFor(HealthDataSync)
final healthDataSyncProvider =
    AutoDisposeAsyncNotifierProvider<HealthDataSync, bool>.internal(
  HealthDataSync.new,
  name: r'healthDataSyncProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$healthDataSyncHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$HealthDataSync = AutoDisposeAsyncNotifier<bool>;
String _$activityStatisticsHash() =>
    r'1aa81f63639be98b0c6f40316f55e3acd0002adf';

abstract class _$ActivityStatistics
    extends BuildlessAutoDisposeAsyncNotifier<Map<String, dynamic>> {
  late final DateTime startDate;
  late final DateTime endDate;
  late final int goalSteps;

  FutureOr<Map<String, dynamic>> build({
    required DateTime startDate,
    required DateTime endDate,
    int goalSteps = 8000,
  });
}

/// アクティビティ統計プロバイダー
///
/// Copied from [ActivityStatistics].
@ProviderFor(ActivityStatistics)
const activityStatisticsProvider = ActivityStatisticsFamily();

/// アクティビティ統計プロバイダー
///
/// Copied from [ActivityStatistics].
class ActivityStatisticsFamily
    extends Family<AsyncValue<Map<String, dynamic>>> {
  /// アクティビティ統計プロバイダー
  ///
  /// Copied from [ActivityStatistics].
  const ActivityStatisticsFamily();

  /// アクティビティ統計プロバイダー
  ///
  /// Copied from [ActivityStatistics].
  ActivityStatisticsProvider call({
    required DateTime startDate,
    required DateTime endDate,
    int goalSteps = 8000,
  }) {
    return ActivityStatisticsProvider(
      startDate: startDate,
      endDate: endDate,
      goalSteps: goalSteps,
    );
  }

  @override
  ActivityStatisticsProvider getProviderOverride(
    covariant ActivityStatisticsProvider provider,
  ) {
    return call(
      startDate: provider.startDate,
      endDate: provider.endDate,
      goalSteps: provider.goalSteps,
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
  String? get name => r'activityStatisticsProvider';
}

/// アクティビティ統計プロバイダー
///
/// Copied from [ActivityStatistics].
class ActivityStatisticsProvider extends AutoDisposeAsyncNotifierProviderImpl<
    ActivityStatistics, Map<String, dynamic>> {
  /// アクティビティ統計プロバイダー
  ///
  /// Copied from [ActivityStatistics].
  ActivityStatisticsProvider({
    required DateTime startDate,
    required DateTime endDate,
    int goalSteps = 8000,
  }) : this._internal(
          () => ActivityStatistics()
            ..startDate = startDate
            ..endDate = endDate
            ..goalSteps = goalSteps,
          from: activityStatisticsProvider,
          name: r'activityStatisticsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$activityStatisticsHash,
          dependencies: ActivityStatisticsFamily._dependencies,
          allTransitiveDependencies:
              ActivityStatisticsFamily._allTransitiveDependencies,
          startDate: startDate,
          endDate: endDate,
          goalSteps: goalSteps,
        );

  ActivityStatisticsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.startDate,
    required this.endDate,
    required this.goalSteps,
  }) : super.internal();

  final DateTime startDate;
  final DateTime endDate;
  final int goalSteps;

  @override
  FutureOr<Map<String, dynamic>> runNotifierBuild(
    covariant ActivityStatistics notifier,
  ) {
    return notifier.build(
      startDate: startDate,
      endDate: endDate,
      goalSteps: goalSteps,
    );
  }

  @override
  Override overrideWith(ActivityStatistics Function() create) {
    return ProviderOverride(
      origin: this,
      override: ActivityStatisticsProvider._internal(
        () => create()
          ..startDate = startDate
          ..endDate = endDate
          ..goalSteps = goalSteps,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        startDate: startDate,
        endDate: endDate,
        goalSteps: goalSteps,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<ActivityStatistics,
      Map<String, dynamic>> createElement() {
    return _ActivityStatisticsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ActivityStatisticsProvider &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.goalSteps == goalSteps;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, startDate.hashCode);
    hash = _SystemHash.combine(hash, endDate.hashCode);
    hash = _SystemHash.combine(hash, goalSteps.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ActivityStatisticsRef
    on AutoDisposeAsyncNotifierProviderRef<Map<String, dynamic>> {
  /// The parameter `startDate` of this provider.
  DateTime get startDate;

  /// The parameter `endDate` of this provider.
  DateTime get endDate;

  /// The parameter `goalSteps` of this provider.
  int get goalSteps;
}

class _ActivityStatisticsProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<ActivityStatistics,
        Map<String, dynamic>> with ActivityStatisticsRef {
  _ActivityStatisticsProviderElement(super.provider);

  @override
  DateTime get startDate => (origin as ActivityStatisticsProvider).startDate;
  @override
  DateTime get endDate => (origin as ActivityStatisticsProvider).endDate;
  @override
  int get goalSteps => (origin as ActivityStatisticsProvider).goalSteps;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
