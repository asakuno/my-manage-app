import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:frontend/data/repository/subscription_repository_impl.dart';
import 'package:frontend/data/local/subscription_local_data_source.dart';
import 'package:frontend/domain/core/entity/subscription_status.dart';
import 'package:frontend/domain/core/type/subscription_type.dart';
import 'package:frontend/domain/subscription/repository/subscription_repository.dart';

import 'subscription_repository_impl_test.mocks.dart';

@GenerateMocks([SubscriptionLocalDataSource])
void main() {
  group('SubscriptionRepositoryImpl', () {
    late SubscriptionRepositoryImpl repository;
    late MockSubscriptionLocalDataSource mockLocalDataSource;

    setUp(() {
      mockLocalDataSource = MockSubscriptionLocalDataSource();
      repository = SubscriptionRepositoryImpl(
        localDataSource: mockLocalDataSource,
        useMockData: true,
      );
    });

    tearDown(() {
      repository.dispose();
    });

    group('getSubscriptionStatus', () {
      test('should return local subscription status when available', () async {
        // Arrange
        final expectedStatus = SubscriptionStatus.premium(
          expiryDate: DateTime.now().add(const Duration(days: 30)),
          purchaseDate: DateTime.now().subtract(const Duration(days: 1)),
        );

        when(
          mockLocalDataSource.getSubscriptionStatus(),
        ).thenAnswer((_) async => expectedStatus);

        // Act
        final result = await repository.getSubscriptionStatus();

        // Assert
        expect(result, equals(expectedStatus));
        verify(mockLocalDataSource.getSubscriptionStatus()).called(1);
      });

      test(
        'should generate mock subscription when no local data exists',
        () async {
          // Arrange
          when(
            mockLocalDataSource.getSubscriptionStatus(),
          ).thenAnswer((_) async => null);
          when(
            mockLocalDataSource.saveSubscriptionStatus(any),
          ).thenAnswer((_) async => {});

          // Act
          final result = await repository.getSubscriptionStatus();

          // Assert
          expect(result, isNotNull);
          expect(result.type, isA<SubscriptionType>());
          verify(mockLocalDataSource.getSubscriptionStatus()).called(1);
          verify(mockLocalDataSource.saveSubscriptionStatus(any)).called(1);
        },
      );

      test('should return free subscription on error', () async {
        // Arrange
        when(
          mockLocalDataSource.getSubscriptionStatus(),
        ).thenThrow(Exception('Database error'));

        // Act
        final result = await repository.getSubscriptionStatus();

        // Assert
        expect(result.type, equals(SubscriptionType.free));
        expect(result.isActive, isTrue);
        expect(result.availableFeatures, isEmpty);
      });
    });

    group('purchaseSubscription', () {
      test(
        'should successfully purchase premium subscription with mock data',
        () async {
          // Arrange
          when(
            mockLocalDataSource.saveSubscriptionStatus(any),
          ).thenAnswer((_) async => {});
          when(
            mockLocalDataSource.getPurchaseHistory(),
          ).thenAnswer((_) async => []);
          when(
            mockLocalDataSource.savePurchaseHistory(any),
          ).thenAnswer((_) async => {});

          // Act
          final result = await repository.purchaseSubscription(
            SubscriptionType.premium,
          );

          // Assert
          expect(result, isTrue);
          verify(mockLocalDataSource.saveSubscriptionStatus(any)).called(1);
          verify(mockLocalDataSource.getPurchaseHistory()).called(1);
          verify(mockLocalDataSource.savePurchaseHistory(any)).called(1);
        },
      );

      test('should return false on purchase failure', () async {
        // Arrange
        when(
          mockLocalDataSource.saveSubscriptionStatus(any),
        ).thenThrow(Exception('Save failed'));

        // Act
        final result = await repository.purchaseSubscription(
          SubscriptionType.premium,
        );

        // Assert
        expect(result, isFalse);
      });
    });

    group('verifySubscription', () {
      test('should verify active subscription with mock data', () async {
        // Arrange
        final activeStatus = SubscriptionStatus.premium(
          expiryDate: DateTime.now().add(const Duration(days: 30)),
          purchaseDate: DateTime.now().subtract(const Duration(days: 1)),
        );

        when(
          mockLocalDataSource.getSubscriptionStatus(),
        ).thenAnswer((_) async => activeStatus);
        when(
          mockLocalDataSource.saveSubscriptionStatus(any),
        ).thenAnswer((_) async => {});

        // Act
        final result = await repository.verifySubscription();

        // Assert
        expect(result, isTrue);
      });

      test('should return false for expired subscription', () async {
        // Arrange
        final expiredStatus = SubscriptionStatus.premium(
          expiryDate: DateTime.now().subtract(const Duration(days: 1)),
          purchaseDate: DateTime.now().subtract(const Duration(days: 31)),
        );

        when(
          mockLocalDataSource.getSubscriptionStatus(),
        ).thenAnswer((_) async => expiredStatus);
        when(
          mockLocalDataSource.saveSubscriptionStatus(any),
        ).thenAnswer((_) async => {});

        // Act
        final result = await repository.verifySubscription();

        // Assert
        expect(result, isFalse);
      });
    });

    group('restorePurchases', () {
      test('should successfully restore purchases with mock data', () async {
        // Arrange
        when(
          mockLocalDataSource.saveSubscriptionStatus(any),
        ).thenAnswer((_) async => {});

        // Act
        final result = await repository.restorePurchases();

        // Assert
        expect(result, isTrue);
        verify(mockLocalDataSource.saveSubscriptionStatus(any)).called(1);
      });

      test('should return false on restore failure', () async {
        // Arrange
        when(
          mockLocalDataSource.saveSubscriptionStatus(any),
        ).thenThrow(Exception('Restore failed'));

        // Act
        final result = await repository.restorePurchases();

        // Assert
        expect(result, isFalse);
      });
    });

    group('cancelSubscription', () {
      test('should successfully cancel subscription with mock data', () async {
        // Arrange
        when(
          mockLocalDataSource.resetToFreeSubscription(),
        ).thenAnswer((_) async => {});

        // Act
        final result = await repository.cancelSubscription();

        // Assert
        expect(result, isTrue);
        verify(mockLocalDataSource.resetToFreeSubscription()).called(1);
      });

      test('should return false on cancellation failure', () async {
        // Arrange
        when(
          mockLocalDataSource.resetToFreeSubscription(),
        ).thenThrow(Exception('Cancel failed'));

        // Act
        final result = await repository.cancelSubscription();

        // Assert
        expect(result, isFalse);
      });
    });

    group('getAvailableSubscriptions', () {
      test('should return all subscription types', () async {
        // Act
        final result = await repository.getAvailableSubscriptions();

        // Assert
        expect(result, equals(SubscriptionType.values));
      });
    });

    group('hasFeature', () {
      test('should check feature availability', () async {
        // Arrange
        final premiumStatus = SubscriptionStatus.premium(
          expiryDate: DateTime.now().add(const Duration(days: 30)),
          purchaseDate: DateTime.now().subtract(const Duration(days: 1)),
        );

        when(
          mockLocalDataSource.getSubscriptionStatus(),
        ).thenAnswer((_) async => premiumStatus);
        when(
          mockLocalDataSource.saveSubscriptionStatus(any),
        ).thenAnswer((_) async => {});

        // Act
        final result = await repository.hasFeature(PremiumFeature.adFree);

        // Assert
        expect(result, isTrue);
      });

      test('should return false for free subscription features', () async {
        // Arrange
        final freeStatus = SubscriptionStatus.free();

        when(
          mockLocalDataSource.getSubscriptionStatus(),
        ).thenAnswer((_) async => freeStatus);

        // Act
        final result = await repository.hasFeature(PremiumFeature.adFree);

        // Assert
        expect(result, isFalse);
      });
    });

    group('getSubscriptionPrice', () {
      test('should return price information for subscription type', () async {
        // Act
        final result = await repository.getSubscriptionPrice(
          SubscriptionType.premium,
        );

        // Assert
        expect(result, isNotNull);
        expect(result!['price'], equals(SubscriptionType.premium.price));
        expect(result['currency'], equals('USD'));
        expect(result['period'], equals('monthly'));
        expect(result['formattedPrice'], contains('\$'));
      });

      test('should return price information for free subscription', () async {
        // Act
        final result = await repository.getSubscriptionPrice(
          SubscriptionType.free,
        );

        // Assert
        expect(result, isNotNull);
        expect(result!['price'], equals(0.0));
        expect(result['period'], equals('free'));
      });
    });

    group('applyPromoCode', () {
      test('should apply valid promo code', () async {
        // Arrange
        when(
          mockLocalDataSource.saveSubscriptionStatus(any),
        ).thenAnswer((_) async => {});

        // Act
        final result = await repository.applyPromoCode('PREMIUM30');

        // Assert
        expect(result, isTrue);
        verify(mockLocalDataSource.saveSubscriptionStatus(any)).called(1);
      });

      test('should reject invalid promo code', () async {
        // Act
        final result = await repository.applyPromoCode('INVALID');

        // Assert
        expect(result, isFalse);
      });
    });

    group('setAutoRenew', () {
      test('should update auto renew setting', () async {
        // Arrange
        final currentStatus = SubscriptionStatus.premium(
          expiryDate: DateTime.now().add(const Duration(days: 30)),
          purchaseDate: DateTime.now().subtract(const Duration(days: 1)),
          autoRenew: false,
        );

        when(
          mockLocalDataSource.getSubscriptionStatus(),
        ).thenAnswer((_) async => currentStatus);
        when(
          mockLocalDataSource.saveSubscriptionStatus(any),
        ).thenAnswer((_) async => {});

        // Act
        final result = await repository.setAutoRenew(true);

        // Assert
        expect(result, isTrue);
        verify(mockLocalDataSource.saveSubscriptionStatus(any)).called(1);
      });

      test('should return false on update failure', () async {
        // Arrange
        when(
          mockLocalDataSource.getSubscriptionStatus(),
        ).thenThrow(Exception('Get failed'));

        // Act
        final result = await repository.setAutoRenew(true);

        // Assert
        expect(result, isFalse);
      });
    });

    group('getPurchaseHistory', () {
      test('should return mock purchase history', () async {
        // Act
        final result = await repository.getPurchaseHistory();

        // Assert
        expect(result, isA<List<PurchaseHistory>>());
        expect(result, isNotEmpty);

        for (final purchase in result) {
          expect(purchase.transactionId, isNotEmpty);
          expect(purchase.productId, isNotEmpty);
          expect(purchase.amount, equals(SubscriptionType.premium.price));
          expect(purchase.currency, equals('USD'));
        }
      });
    });

    group('getSubscriptionDetails', () {
      test('should return detailed subscription information', () async {
        // Arrange
        final status = SubscriptionStatus.premium(
          expiryDate: DateTime.now().add(const Duration(days: 30)),
          purchaseDate: DateTime.now().subtract(const Duration(days: 1)),
        );

        when(
          mockLocalDataSource.getSubscriptionStatus(),
        ).thenAnswer((_) async => status);
        when(
          mockLocalDataSource.saveSubscriptionStatus(any),
        ).thenAnswer((_) async => {});
        when(mockLocalDataSource.getSubscriptionStatistics()).thenAnswer(
          (_) async => {
            'totalPurchases': 1,
            'activePurchases': 1,
            'expiredPurchases': 0,
          },
        );

        // Act
        final result = await repository.getSubscriptionDetails();

        // Assert
        expect(result, isA<Map<String, dynamic>>());
        expect(result.containsKey('currentSubscription'), isTrue);
        expect(result.containsKey('statistics'), isTrue);
        expect(result.containsKey('pricing'), isTrue);

        final currentSub =
            result['currentSubscription'] as Map<String, dynamic>;
        expect(currentSub['type'], equals(SubscriptionType.premium.id));
        expect(currentSub['isActive'], isTrue);
      });
    });
  });
}
