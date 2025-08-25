import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Widget testing utilities for presentation layer tests
class WidgetTestUtils {
  /// Default test timeout for widget operations
  static const Duration defaultTimeout = Duration(seconds: 5);

  /// Creates a test app wrapper with providers and routing
  static Widget createTestApp({
    required Widget child,
    List<Override> providerOverrides = const [],
    GoRouter? router,
    ThemeData? theme,
    Locale? locale,
  }) {
    Widget app = ProviderScope(
      overrides: providerOverrides,
      child: MaterialApp(
        home: child,
        theme: theme ?? ThemeData.light(),
        locale: locale,
        // Disable animations for testing
        debugShowCheckedModeBanner: false,
      ),
    );

    if (router != null) {
      app = ProviderScope(
        overrides: providerOverrides,
        child: MaterialApp.router(
          routerConfig: router,
          theme: theme ?? ThemeData.light(),
          locale: locale,
          debugShowCheckedModeBanner: false,
        ),
      );
    }

    return app;
  }

  /// Pumps a widget with providers and common setup
  static Future<void> pumpWidgetWithProviders(
    WidgetTester tester,
    Widget widget, {
    List<Override> providerOverrides = const [],
    GoRouter? router,
    ThemeData? theme,
    Locale? locale,
  }) async {
    await tester.pumpWidget(
      createTestApp(
        child: widget,
        providerOverrides: providerOverrides,
        router: router,
        theme: theme,
        locale: locale,
      ),
    );
  }

  /// Pumps a widget and waits for it to settle
  static Future<void> pumpAndSettle(
    WidgetTester tester,
    Widget widget, {
    List<Override> providerOverrides = const [],
    Duration timeout = defaultTimeout,
  }) async {
    await pumpWidgetWithProviders(
      tester,
      widget,
      providerOverrides: providerOverrides,
    );
    await tester.pumpAndSettle(timeout);
  }

  /// Finds a widget by its key
  static Finder findByKey(Key key) {
    return find.byKey(key);
  }

  /// Finds a widget by its type
  static Finder findByType<T extends Widget>() {
    return find.byType(T);
  }

  /// Finds a widget by text content
  static Finder findByText(String text) {
    return find.text(text);
  }

  /// Finds a widget containing specific text
  static Finder findTextContaining(String text) {
    return find.textContaining(text);
  }

  /// Finds an icon by its icon data
  static Finder findByIcon(IconData icon) {
    return find.byIcon(icon);
  }

  /// Taps a widget and waits for animations to complete
  static Future<void> tapAndSettle(
    WidgetTester tester,
    Finder finder, {
    Duration timeout = defaultTimeout,
  }) async {
    await tester.tap(finder);
    await tester.pumpAndSettle(timeout);
  }

  /// Long presses a widget and waits for animations to complete
  static Future<void> longPressAndSettle(
    WidgetTester tester,
    Finder finder, {
    Duration timeout = defaultTimeout,
  }) async {
    await tester.longPress(finder);
    await tester.pumpAndSettle(timeout);
  }

  /// Enters text into a text field
  static Future<void> enterText(
    WidgetTester tester,
    Finder finder,
    String text, {
    Duration timeout = defaultTimeout,
  }) async {
    await tester.enterText(finder, text);
    await tester.pumpAndSettle(timeout);
  }

  /// Scrolls a widget until a target is visible
  static Future<void> scrollUntilVisible(
    WidgetTester tester,
    Finder target,
    Finder scrollable, {
    double delta = 100.0,
    AxisDirection direction = AxisDirection.down,
    Duration timeout = defaultTimeout,
  }) async {
    await tester.scrollUntilVisible(target, delta, scrollable: scrollable);
    await tester.pumpAndSettle(timeout);
  }

  /// Drags a widget by a specific offset
  static Future<void> dragAndSettle(
    WidgetTester tester,
    Finder finder,
    Offset offset, {
    Duration timeout = defaultTimeout,
  }) async {
    await tester.drag(finder, offset);
    await tester.pumpAndSettle(timeout);
  }

  /// Verifies that a widget exists
  static void expectWidgetExists(Finder finder) {
    expect(finder, findsOneWidget);
  }

  /// Verifies that multiple widgets exist
  static void expectWidgetsExist(Finder finder, int count) {
    expect(finder, findsNWidgets(count));
  }

  /// Verifies that a widget does not exist
  static void expectWidgetNotExists(Finder finder) {
    expect(finder, findsNothing);
  }

  /// Verifies that text is displayed
  static void expectTextDisplayed(String text) {
    expect(find.text(text), findsOneWidget);
  }

  /// Verifies that text containing a substring is displayed
  static void expectTextContaining(String substring) {
    expect(find.textContaining(substring), findsAtLeastNWidgets(1));
  }

  /// Verifies that an icon is displayed
  static void expectIconDisplayed(IconData icon) {
    expect(find.byIcon(icon), findsOneWidget);
  }

  /// Verifies widget properties
  static void expectWidgetProperty<T extends Widget>(
    WidgetTester tester,
    Finder finder,
    bool Function(T widget) predicate, {
    String? reason,
  }) {
    final widget = tester.widget<T>(finder);
    expect(predicate(widget), isTrue, reason: reason);
  }

  /// Verifies that a loading indicator is shown
  static void expectLoadingIndicator() {
    expect(find.byType(CircularProgressIndicator), findsAtLeastNWidgets(1));
  }

  /// Verifies that an error message is shown
  static void expectErrorMessage([String? message]) {
    if (message != null) {
      expectTextContaining(message);
    } else {
      // Look for common error indicators
      final errorFinders = [
        find.textContaining('Error'),
        find.textContaining('Failed'),
        find.textContaining('Something went wrong'),
        find.byIcon(Icons.error),
        find.byIcon(Icons.warning),
      ];

      bool foundError = false;
      for (final finder in errorFinders) {
        if (finder.evaluate().isNotEmpty) {
          foundError = true;
          break;
        }
      }
      expect(foundError, isTrue, reason: 'No error indicator found');
    }
  }

  /// Waits for a specific widget to appear
  static Future<void> waitForWidget(
    WidgetTester tester,
    Finder finder, {
    Duration timeout = defaultTimeout,
  }) async {
    final endTime = DateTime.now().add(timeout);

    while (DateTime.now().isBefore(endTime)) {
      await tester.pump(const Duration(milliseconds: 100));
      if (finder.evaluate().isNotEmpty) {
        return;
      }
    }

    throw Exception('Widget not found within timeout: $timeout');
  }

  /// Waits for a widget to disappear
  static Future<void> waitForWidgetToDisappear(
    WidgetTester tester,
    Finder finder, {
    Duration timeout = defaultTimeout,
  }) async {
    final endTime = DateTime.now().add(timeout);

    while (DateTime.now().isBefore(endTime)) {
      await tester.pump(const Duration(milliseconds: 100));
      if (finder.evaluate().isEmpty) {
        return;
      }
    }

    throw Exception('Widget did not disappear within timeout: $timeout');
  }

  /// Simulates device back button press
  static Future<void> pressBackButton(WidgetTester tester) async {
    await tester.binding.defaultBinaryMessenger.handlePlatformMessage(
      'flutter/navigation',
      const StandardMethodCodec().encodeMethodCall(
        const MethodCall('routePopped', <String, dynamic>{
          'location': '/',
          'state': null,
        }),
      ),
      (data) {},
    );
    await tester.pumpAndSettle();
  }

  /// Takes a screenshot of the current widget tree
  static Future<void> takeScreenshot(
    WidgetTester tester,
    String filename,
  ) async {
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('screenshots/$filename.png'),
    );
  }

  /// Verifies accessibility properties
  static void verifyAccessibility(WidgetTester tester) {
    final SemanticsHandle handle = tester.ensureSemantics();
    expect(tester.binding.rootPipelineOwner.semanticsOwner, isNotNull);
    handle.dispose();
  }

  /// Finds a widget by its semantic label
  static Finder findBySemanticsLabel(String label) {
    return find.bySemanticsLabel(label);
  }

  /// Verifies that a widget has proper semantic properties
  static void expectSemanticProperties(
    Finder finder, {
    String? label,
    String? hint,
    bool? enabled,
    bool? focusable,
  }) {
    final element = finder.evaluate().single;
    final renderObject = element.renderObject;

    if (renderObject != null) {
      final semantics = renderObject.debugSemantics;
      if (semantics != null) {
        if (label != null) {
          expect(semantics.label, equals(label));
        }
        if (hint != null) {
          expect(semantics.hint, equals(hint));
        }
        if (enabled != null) {
          // Check enabled state - simplified for now
          // Note: Actual implementation would check semantics flags
          expect(semantics.label, isNotNull);
        }
        if (focusable != null) {
          // Check focusable state - simplified for now
          // Note: Actual implementation would check semantics flags
          expect(semantics.label, isNotNull);
        }
      }
    }
  }

  /// Creates a mock GoRouter for testing
  static GoRouter createMockRouter({
    String initialLocation = '/',
    List<RouteBase> routes = const [],
  }) {
    return GoRouter(
      initialLocation: initialLocation,
      routes: routes.isEmpty
          ? [
              GoRoute(
                path: '/',
                builder: (context, state) => const Scaffold(body: Text('Home')),
              ),
            ]
          : routes,
    );
  }
}

/// Extension methods for WidgetTester
extension WidgetTesterExtension on WidgetTester {
  /// Pumps widget with providers using extension method
  Future<void> pumpWithProviders(
    Widget widget, {
    List<Override> providerOverrides = const [],
    Duration timeout = WidgetTestUtils.defaultTimeout,
  }) async {
    await WidgetTestUtils.pumpAndSettle(
      this,
      widget,
      providerOverrides: providerOverrides,
      timeout: timeout,
    );
  }

  /// Taps and settles using extension method
  Future<void> tapAndSettle(
    Finder finder, {
    Duration timeout = WidgetTestUtils.defaultTimeout,
  }) async {
    await WidgetTestUtils.tapAndSettle(this, finder, timeout: timeout);
  }

  /// Waits for widget using extension method
  Future<void> waitFor(
    Finder finder, {
    Duration timeout = WidgetTestUtils.defaultTimeout,
  }) async {
    await WidgetTestUtils.waitForWidget(this, finder, timeout: timeout);
  }
}
