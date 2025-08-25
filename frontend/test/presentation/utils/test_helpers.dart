import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:fake_async/fake_async.dart';

/// Common testing utilities for presentation layer tests
class TestHelpers {
  /// Default test timeout duration
  static const Duration defaultTimeout = Duration(seconds: 10);

  /// Creates a ProviderContainer with the given overrides
  static ProviderContainer createContainer({
    List<Override> overrides = const [],
    ProviderContainer? parent,
  }) {
    return ProviderContainer(overrides: overrides, parent: parent);
  }

  /// Disposes a ProviderContainer safely
  static void disposeContainer(ProviderContainer container) {
    container.dispose();
  }

  /// Waits for a provider to complete its async operation
  static Future<T> waitForProvider<T>(
    ProviderContainer container,
    ProviderListenable<AsyncValue<T>> provider, {
    Duration timeout = defaultTimeout,
  }) async {
    final completer = Completer<T>();
    late final ProviderSubscription subscription;

    subscription = container.listen(provider, (previous, next) {
      next.when(
        data: (data) {
          if (!completer.isCompleted) {
            completer.complete(data);
          }
          subscription.close();
        },
        error: (error, stackTrace) {
          if (!completer.isCompleted) {
            completer.completeError(error, stackTrace);
          }
          subscription.close();
        },
        loading: () {
          // Continue waiting
        },
      );
    });

    return completer.future.timeout(timeout);
  }

  /// Waits for a provider state to match a condition
  static Future<T> waitForProviderCondition<T>(
    ProviderContainer container,
    ProviderListenable<T> provider,
    bool Function(T state) condition, {
    Duration timeout = defaultTimeout,
  }) async {
    final completer = Completer<T>();
    late final ProviderSubscription subscription;

    subscription = container.listen(provider, (previous, next) {
      if (condition(next)) {
        if (!completer.isCompleted) {
          completer.complete(next);
        }
        subscription.close();
      }
    });

    // Check initial state
    final initialState = container.read(provider);
    if (condition(initialState)) {
      subscription.close();
      return initialState;
    }

    return completer.future.timeout(timeout);
  }

  /// Executes a test with fake async to control time
  static void testWithFakeAsync(
    String description,
    void Function(FakeAsync fakeAsync) test,
  ) {
    testWidgets(description, (tester) async {
      fakeAsync((fakeAsync) {
        test(fakeAsync);
      });
    });
  }

  /// Verifies that a mock was called with specific arguments
  static void verifyMockCall<T>(Mock mock, T Function() call, {int times = 1}) {
    verify(call()).called(times);
  }

  /// Verifies that a mock was never called
  static void verifyMockNeverCalled<T>(Mock mock, T Function() call) {
    verifyNever(call());
  }

  /// Sets up a mock to return a value
  static void setupMockReturn<T>(Mock mock, T Function() call, T returnValue) {
    when(call()).thenReturn(returnValue);
  }

  /// Sets up a mock to return a future value
  static void setupMockReturnAsync<T>(
    Mock mock,
    Future<T> Function() call,
    T returnValue,
  ) {
    when(call()).thenAnswer((_) async => returnValue);
  }

  /// Sets up a mock to throw an exception
  static void setupMockThrow<T>(
    Mock mock,
    T Function() call,
    Object exception,
  ) {
    when(call()).thenThrow(exception);
  }

  /// Sets up a mock to throw an exception asynchronously
  static void setupMockThrowAsync<T>(
    Mock mock,
    Future<T> Function() call,
    Object exception,
  ) {
    when(call()).thenAnswer((_) async => throw exception);
  }

  /// Resets all mocks in a list
  static void resetMocks(List<Mock> mocks) {
    for (final mock in mocks) {
      reset(mock);
    }
  }

  /// Creates a test group with common setup and teardown
  static void testGroup(
    String description,
    void Function() body, {
    void Function()? setUp,
    void Function()? tearDown,
  }) {
    group(description, () {
      if (setUp != null) {
        setUp();
      }

      body();

      if (tearDown != null) {
        tearDown();
      }
    });
  }

  /// Asserts that an async value is in loading state
  static void expectLoading<T>(AsyncValue<T> value) {
    expect(value.isLoading, isTrue);
    expect(value.hasValue, isFalse);
    expect(value.hasError, isFalse);
  }

  /// Asserts that an async value has data
  static void expectData<T>(AsyncValue<T> value, T expectedData) {
    expect(value.isLoading, isFalse);
    expect(value.hasValue, isTrue);
    expect(value.hasError, isFalse);
    expect(value.value, equals(expectedData));
  }

  /// Asserts that an async value has an error
  static void expectError<T>(AsyncValue<T> value, [Object? expectedError]) {
    expect(value.isLoading, isFalse);
    expect(value.hasValue, isFalse);
    expect(value.hasError, isTrue);
    if (expectedError != null) {
      expect(value.error, equals(expectedError));
    }
  }

  /// Asserts that an async value has an error containing a message
  static void expectErrorContaining<T>(AsyncValue<T> value, String message) {
    expect(value.isLoading, isFalse);
    expect(value.hasValue, isFalse);
    expect(value.hasError, isTrue);
    expect(value.error.toString(), contains(message));
  }

  /// Creates a test date for consistent testing
  static DateTime createTestDate({
    int year = 2024,
    int month = 1,
    int day = 1,
    int hour = 0,
    int minute = 0,
    int second = 0,
  }) {
    return DateTime(year, month, day, hour, minute, second);
  }

  /// Creates a date range for testing
  static Map<String, DateTime> createTestDateRange({
    DateTime? start,
    DateTime? end,
  }) {
    return {
      'start': start ?? createTestDate(),
      'end': end ?? createTestDate(day: 7),
    };
  }

  /// Pumps and settles a widget test with a timeout
  static Future<void> pumpAndSettleWithTimeout(
    WidgetTester tester, {
    Duration timeout = const Duration(seconds: 5),
  }) async {
    await tester.pumpAndSettle(timeout);
  }

  /// Executes a function and measures its execution time
  static Future<Duration> measureExecutionTime(
    Future<void> Function() function,
  ) async {
    final stopwatch = Stopwatch()..start();
    await function();
    stopwatch.stop();
    return stopwatch.elapsed;
  }

  /// Asserts that execution time is within expected bounds
  static void expectExecutionTime(
    Duration actualTime,
    Duration maxExpectedTime, {
    String? reason,
  }) {
    expect(
      actualTime.inMilliseconds,
      lessThanOrEqualTo(maxExpectedTime.inMilliseconds),
      reason: reason ?? 'Execution took too long: $actualTime',
    );
  }
}

/// Extension methods for easier testing
extension TestHelpersExtension on ProviderContainer {
  /// Reads a provider and waits for it to complete
  Future<T> readAndWait<T>(
    ProviderListenable<AsyncValue<T>> provider, {
    Duration timeout = TestHelpers.defaultTimeout,
  }) {
    return TestHelpers.waitForProvider(this, provider, timeout: timeout);
  }

  /// Reads a provider and waits for a condition
  Future<T> readAndWaitFor<T>(
    ProviderListenable<T> provider,
    bool Function(T state) condition, {
    Duration timeout = TestHelpers.defaultTimeout,
  }) {
    return TestHelpers.waitForProviderCondition(
      this,
      provider,
      condition,
      timeout: timeout,
    );
  }
}
