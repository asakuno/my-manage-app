import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:frontend/domain/subscription/usecase/purchase_subscription_usecase.dart';
import 'package:frontend/domain/subscription/repository/subscription_repository.dart';
import 'package:frontend/domain/core/entity/subscription_status.dart';
import 'package:frontend/domain/core/type/subscription_type.dart';

import 'purchase_subscription_usecase_test.mocks.dart';

@GenerateMocks([SubscriptionRepository])
void main() {
  group('PurchaseSubscriptionUseCase', () {
    late PurchaseSubscriptionUseCase useCase;
    late MockSubscriptionRepository mockRepository;

    setUp(() {
      mockRepository = MockSubscriptionRepository();
      useCase = PurchaseSubscriptionUseCase(mockRepository);
    });

    group('call (purchaseSubscription)', () {
      test('should purchase premium subscription successfully', () async {
        // Arrange
        final freeStatus = SubscriptionStatus.free();
        when(
          mockRepository.getSubscriptionStatus(),
        ).thenAnswer((_) async => freeStatus);
        when(
          mockRepository.purchaseSubscription(SubscriptionType.premium),
        ).thenAnswer((_) async => true);

        // Act
        final result = await useCase.call(SubscriptionType.premium);

        // Assert
        expect(result, isTrue);
        verify(mockRepository.getSubscriptionStatus()).called(1);
        verify(
          mockRepository.purchaseSubscription(SubscriptionType.premium),
        ).called(1);
      });

      test(
        'should throw SubscriptionException when already subscribed to premium',
        () async {
          // Arrange
          final premiumStatus = SubscriptionStatus.premium(
            expiryDate: DateTime.now().add(const Duration(days: 30)),
          );
          when(
            mockRepository.getSubscriptionStatus(),
          ).thenAnswer((_) async => premiumStatus);

          // Act & Assert
          expect(
            () => useCase.call(SubscriptionType.premium),
            throwsA(isA<SubscriptionException>()),
          );
          verify(mockRepository.getSubscriptionStatus()).called(1);
          verifyNever(mockRepository.purchaseSubscription(any));
        },
      );

      test(
        'should throw SubscriptionException when trying to purchase free plan',
        () async {
          // Arrange
          final freeStatus = SubscriptionStatus.free();
          when(
            mockRepository.getSubscriptionStatus(),
          ).thenAnswer((_) async => freeStatus);

          // Act & Assert
          expect(
            () => useCase.call(SubscriptionType.free),
            throwsA(isA<SubscriptionException>()),
          );
          verify(mockRepository.getSubscriptionStatus()).called(1);
          verifyNever(mockRepository.purchaseSubscription(any));
        },
      );

      test('should throw SubscriptionException when purchase fails', () async {
        // Arrange
        final freeStatus = SubscriptionStatus.free();
        when(
          mockRepository.getSubscriptionStatus(),
        ).thenAnswer((_) async => freeStatus);
        when(
          mockRepository.purchaseSubscription(SubscriptionType.premium),
        ).thenAnswer((_) async => false);

        // Act & Assert
        expect(
          () => useCase.call(SubscriptionType.premium),
          throwsA(isA<SubscriptionException>()),
        );
      });

      test(
        'should throw SubscriptionException when repository throws',
        () async {
          // Arrange
          when(
            mockRepository.getSubscriptionStatus(),
          ).thenThrow(Exception('Repository error'));

          // Act & Assert
          expect(
            () => useCase.call(SubscriptionType.premium),
            throwsA(isA<SubscriptionException>()),
          );
        },
      );
    });

    group('getAvailableSubscriptions', () {
      test('should return available subscriptions', () async {
        // Arrange
        final availableSubscriptions = [SubscriptionType.premium];
        when(
          mockRepository.getAvailableSubscriptions(),
        ).thenAnswer((_) async => availableSubscriptions);

        // Act
        final result = await useCase.getAvailableSubscriptions();

        // Assert
        expect(result, equals(availableSubscriptions));
        verify(mockRepository.getAvailableSubscriptions()).called(1);
      });

      test(
        'should throw SubscriptionException when repository throws',
        () async {
          // Arrange
          when(
            mockRepository.getAvailableSubscriptions(),
          ).thenThrow(Exception('Repository error'));

          // Act & Assert
          expect(
            () => useCase.getAvailableSubscriptions(),
            throwsA(isA<SubscriptionException>()),
          );
        },
      );
    });

    group('getSubscriptionPrice', () {
      test('should return price information', () async {
        // Arrange
        final priceInfo = {
          'price': 9.99,
          'currency': 'USD',
          'period': 'monthly',
        };
        when(
          mockRepository.getSubscriptionPrice(SubscriptionType.premium),
        ).thenAnswer((_) async => priceInfo);

        // Act
        final result = await useCase.getSubscriptionPrice(
          SubscriptionType.premium,
        );

        // Assert
        expect(result, equals(priceInfo));
        verify(
          mockRepository.getSubscriptionPrice(SubscriptionType.premium),
        ).called(1);
      });

      test(
        'should throw SubscriptionException when repository throws',
        () async {
          // Arrange
          when(
            mockRepository.getSubscriptionPrice(SubscriptionType.premium),
          ).thenThrow(Exception('Repository error'));

          // Act & Assert
          expect(
            () => useCase.getSubscriptionPrice(SubscriptionType.premium),
            throwsA(isA<SubscriptionException>()),
          );
        },
      );
    });

    group('validatePurchase', () {
      test('should return true for valid premium purchase', () async {
        // Arrange
        final freeStatus = SubscriptionStatus.free();
        final availableSubscriptions = [SubscriptionType.premium];
        when(
          mockRepository.getSubscriptionStatus(),
        ).thenAnswer((_) async => freeStatus);
        when(
          mockRepository.getAvailableSubscriptions(),
        ).thenAnswer((_) async => availableSubscriptions);

        // Act
        final result = await useCase.validatePurchase(SubscriptionType.premium);

        // Assert
        expect(result, isTrue);
      });

      test('should return false for free plan purchase', () async {
        // Arrange
        final freeStatus = SubscriptionStatus.free();
        when(
          mockRepository.getSubscriptionStatus(),
        ).thenAnswer((_) async => freeStatus);

        // Act
        final result = await useCase.validatePurchase(SubscriptionType.free);

        // Assert
        expect(result, isFalse);
      });

      test('should return false when already have active premium', () async {
        // Arrange
        final premiumStatus = SubscriptionStatus.premium(
          expiryDate: DateTime.now().add(const Duration(days: 30)),
        );
        when(
          mockRepository.getSubscriptionStatus(),
        ).thenAnswer((_) async => premiumStatus);

        // Act
        final result = await useCase.validatePurchase(SubscriptionType.premium);

        // Assert
        expect(result, isFalse);
      });

      test('should return false when subscription not available', () async {
        // Arrange
        final freeStatus = SubscriptionStatus.free();
        final availableSubscriptions = <SubscriptionType>[];
        when(
          mockRepository.getSubscriptionStatus(),
        ).thenAnswer((_) async => freeStatus);
        when(
          mockRepository.getAvailableSubscriptions(),
        ).thenAnswer((_) async => availableSubscriptions);

        // Act
        final result = await useCase.validatePurchase(SubscriptionType.premium);

        // Assert
        expect(result, isFalse);
      });

      test('should return false when error occurs', () async {
        // Arrange
        when(
          mockRepository.getSubscriptionStatus(),
        ).thenThrow(Exception('Error'));

        // Act
        final result = await useCase.validatePurchase(SubscriptionType.premium);

        // Assert
        expect(result, isFalse);
      });
    });

    group('applyPromoCode', () {
      test('should apply promo code successfully', () async {
        // Arrange
        const promoCode = 'SAVE20';
        when(
          mockRepository.applyPromoCode(promoCode),
        ).thenAnswer((_) async => true);

        // Act
        final result = await useCase.applyPromoCode(promoCode);

        // Assert
        expect(result, isTrue);
        verify(mockRepository.applyPromoCode(promoCode)).called(1);
      });

      test('should throw SubscriptionException for empty promo code', () async {
        // Act & Assert
        expect(
          () => useCase.applyPromoCode(''),
          throwsA(isA<SubscriptionException>()),
        );
        expect(
          () => useCase.applyPromoCode('   '),
          throwsA(isA<SubscriptionException>()),
        );
        verifyNever(mockRepository.applyPromoCode(any));
      });

      test(
        'should throw SubscriptionException when repository throws',
        () async {
          // Arrange
          const promoCode = 'SAVE20';
          when(
            mockRepository.applyPromoCode(promoCode),
          ).thenThrow(Exception('Repository error'));

          // Act & Assert
          expect(
            () => useCase.applyPromoCode(promoCode),
            throwsA(isA<SubscriptionException>()),
          );
        },
      );
    });

    group('canMakePurchases', () {
      test('should return true when subscriptions are available', () async {
        // Arrange
        final availableSubscriptions = [SubscriptionType.premium];
        when(
          mockRepository.getAvailableSubscriptions(),
        ).thenAnswer((_) async => availableSubscriptions);

        // Act
        final result = await useCase.canMakePurchases();

        // Assert
        expect(result, isTrue);
      });

      test('should return false when no subscriptions are available', () async {
        // Arrange
        final availableSubscriptions = <SubscriptionType>[];
        when(
          mockRepository.getAvailableSubscriptions(),
        ).thenAnswer((_) async => availableSubscriptions);

        // Act
        final result = await useCase.canMakePurchases();

        // Assert
        expect(result, isFalse);
      });

      test('should return false when error occurs', () async {
        // Arrange
        when(
          mockRepository.getAvailableSubscriptions(),
        ).thenThrow(Exception('Error'));

        // Act
        final result = await useCase.canMakePurchases();

        // Assert
        expect(result, isFalse);
      });
    });
  });
}
