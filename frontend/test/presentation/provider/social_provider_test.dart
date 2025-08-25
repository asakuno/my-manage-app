import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:frontend/presentation/provider/social_provider.dart';
import 'package:frontend/domain/social/usecase/add_friend_usecase.dart';
import 'package:frontend/domain/social/usecase/get_friends_ranking_usecase.dart';
import 'package:frontend/domain/social/repository/social_repository.dart';
import 'package:frontend/domain/core/entity/user_profile.dart';
import 'package:frontend/data/repository/social_repository_impl.dart';
import 'package:frontend/data/local/user_preferences_data_source.dart';

import '../utils/test_helpers.dart';
import '../utils/test_data_builders.dart';

// Generate mocks
@GenerateMocks([
  AddFriendUseCase,
  GetFriendsRankingUseCase,
  SocialRepositoryImpl,
  UserPreferencesDataSource,
])
import 'social_provider_test.mocks.dart';

void main() {
  group('Social Provider Tests', () {
    late ProviderContainer container;
    late MockAddFriendUseCase mockAddFriendUseCase;
    late MockGetFriendsRankingUseCase mockGetFriendsRankingUseCase;
    late MockSocialRepositoryImpl mockSocialRepository;
    late MockUserPreferencesDataSource mockUserPreferencesDataSource;

    setUp(() {
      mockAddFriendUseCase = MockAddFriendUseCase();
      mockGetFriendsRankingUseCase = MockGetFriendsRankingUseCase();
      mockSocialRepository = MockSocialRepositoryImpl();
      mockUserPreferencesDataSource = MockUserPreferencesDataSource();

      container = ProviderContainer(
        overrides: [
          addFriendUseCaseProvider.overrideWithValue(mockAddFriendUseCase),
          getFriendsRankingUseCaseProvider.overrideWithValue(
            mockGetFriendsRankingUseCase,
          ),
          socialRepositoryProvider.overrideWithValue(mockSocialRepository),
          userPreferencesDataSourceProvider.overrideWithValue(
            mockUserPreferencesDataSource,
          ),
        ],
      );
    });

    tearDown(() {
      container.dispose();
      reset(mockAddFriendUseCase);
      reset(mockGetFriendsRankingUseCase);
      reset(mockSocialRepository);
      reset(mockUserPreferencesDataSource);
    });

    group('FriendsList Provider Tests', () {
      group('Success Cases', () {
        testWidgets('should load friends list successfully', (tester) async {
          // Arrange
          final testFriends = [
            TestDataBuilders.createUserProfile(id: 'friend1', name: 'Friend 1'),
            TestDataBuilders.createUserProfile(id: 'friend2', name: 'Friend 2'),
          ];
          when(
            mockAddFriendUseCase.getFriends(),
          ).thenAnswer((_) async => testFriends);

          // Act
          final provider = container.read(friendsListProvider);

          // Assert
          await expectLater(provider, completion(testFriends));
          verify(mockAddFriendUseCase.getFriends()).called(1);
        });

        testWidgets('should refresh friends list successfully', (tester) async {
          // Arrange
          final initialFriends = [
            TestDataBuilders.createUserProfile(id: 'friend1'),
          ];
          final updatedFriends = [
            TestDataBuilders.createUserProfile(id: 'friend1'),
            TestDataBuilders.createUserProfile(id: 'friend2'),
          ];

          when(mockAddFriendUseCase.getFriends())
              .thenAnswer((_) async => initialFriends)
              .thenAnswer((_) async => updatedFriends);

          // Act
          final notifier = container.read(friendsListProvider.notifier);
          await container.read(friendsListProvider.future); // Initial load
          await notifier.refresh();

          // Assert
          final result = await container.read(friendsListProvider.future);
          expect(result, equals(updatedFriends));
          verify(mockAddFriendUseCase.getFriends()).called(2);
        });

        testWidgets('should add friend successfully', (tester) async {
          // Arrange
          final initialFriends = [
            TestDataBuilders.createUserProfile(id: 'friend1'),
          ];
          final updatedFriends = [
            TestDataBuilders.createUserProfile(id: 'friend1'),
            TestDataBuilders.createUserProfile(id: 'friend2'),
          ];

          when(mockAddFriendUseCase.getFriends())
              .thenAnswer((_) async => initialFriends)
              .thenAnswer((_) async => updatedFriends);
          when(
            mockAddFriendUseCase.call('friend2'),
          ).thenAnswer((_) async => true);

          // Act
          final notifier = container.read(friendsListProvider.notifier);
          await container.read(friendsListProvider.future); // Initial load
          final success = await notifier.addFriend('friend2');

          // Assert
          expect(success, isTrue);
          final result = await container.read(friendsListProvider.future);
          expect(result, equals(updatedFriends));
          verify(mockAddFriendUseCase.call('friend2')).called(1);
          verify(mockAddFriendUseCase.getFriends()).called(2);
        });

        testWidgets('should remove friend successfully', (tester) async {
          // Arrange
          final initialFriends = [
            TestDataBuilders.createUserProfile(id: 'friend1'),
            TestDataBuilders.createUserProfile(id: 'friend2'),
          ];
          final updatedFriends = [
            TestDataBuilders.createUserProfile(id: 'friend1'),
          ];

          when(mockAddFriendUseCase.getFriends())
              .thenAnswer((_) async => initialFriends)
              .thenAnswer((_) async => updatedFriends);
          when(
            mockAddFriendUseCase.removeFriend('friend2'),
          ).thenAnswer((_) async => true);

          // Act
          final notifier = container.read(friendsListProvider.notifier);
          await container.read(friendsListProvider.future); // Initial load
          final success = await notifier.removeFriend('friend2');

          // Assert
          expect(success, isTrue);
          final result = await container.read(friendsListProvider.future);
          expect(result, equals(updatedFriends));
          verify(mockAddFriendUseCase.removeFriend('friend2')).called(1);
          verify(mockAddFriendUseCase.getFriends()).called(2);
        });
      });

      group('Error Cases', () {
        testWidgets('should handle getFriends error', (tester) async {
          // Arrange
          when(
            mockAddFriendUseCase.getFriends(),
          ).thenThrow(Exception('Network error'));

          // Act & Assert
          final provider = container.read(friendsListProvider);
          await expectLater(provider, throwsException);
          verify(mockAddFriendUseCase.getFriends()).called(1);
        });

        testWidgets('should handle addFriend failure', (tester) async {
          // Arrange
          final initialFriends = [
            TestDataBuilders.createUserProfile(id: 'friend1'),
          ];
          when(
            mockAddFriendUseCase.getFriends(),
          ).thenAnswer((_) async => initialFriends);
          when(
            mockAddFriendUseCase.call('friend2'),
          ).thenThrow(Exception('Add friend failed'));

          // Act
          final notifier = container.read(friendsListProvider.notifier);
          await container.read(friendsListProvider.future); // Initial load
          final success = await notifier.addFriend('friend2');

          // Assert
          expect(success, isFalse);
          verify(mockAddFriendUseCase.call('friend2')).called(1);
          verifyNever(mockAddFriendUseCase.getFriends());
        });

        testWidgets('should handle removeFriend failure', (tester) async {
          // Arrange
          final initialFriends = [
            TestDataBuilders.createUserProfile(id: 'friend1'),
          ];
          when(
            mockAddFriendUseCase.getFriends(),
          ).thenAnswer((_) async => initialFriends);
          when(
            mockAddFriendUseCase.removeFriend('friend1'),
          ).thenThrow(Exception('Remove friend failed'));

          // Act
          final notifier = container.read(friendsListProvider.notifier);
          await container.read(friendsListProvider.future); // Initial load
          final success = await notifier.removeFriend('friend1');

          // Assert
          expect(success, isFalse);
          verify(mockAddFriendUseCase.removeFriend('friend1')).called(1);
          verifyNever(mockAddFriendUseCase.getFriends());
        });
      });

      group('Edge Cases', () {
        testWidgets('should handle empty friends list', (tester) async {
          // Arrange
          when(mockAddFriendUseCase.getFriends()).thenAnswer((_) async => []);

          // Act
          final provider = container.read(friendsListProvider);

          // Assert
          await expectLater(provider, completion(isEmpty));
          verify(mockAddFriendUseCase.getFriends()).called(1);
        });

        testWidgets('should not refresh list when addFriend fails', (
          tester,
        ) async {
          // Arrange
          final initialFriends = [
            TestDataBuilders.createUserProfile(id: 'friend1'),
          ];
          when(
            mockAddFriendUseCase.getFriends(),
          ).thenAnswer((_) async => initialFriends);
          when(
            mockAddFriendUseCase.call('friend2'),
          ).thenAnswer((_) async => false);

          // Act
          final notifier = container.read(friendsListProvider.notifier);
          await container.read(friendsListProvider.future); // Initial load
          final success = await notifier.addFriend('friend2');

          // Assert
          expect(success, isFalse);
          verify(mockAddFriendUseCase.call('friend2')).called(1);
          verify(
            mockAddFriendUseCase.getFriends(),
          ).called(1); // Only initial load
        });
      });
    });

    group('FriendsListStream Provider Tests', () {
      testWidgets('should provide friends stream', (tester) async {
        // Arrange
        final testFriends = [TestDataBuilders.createUserProfile(id: 'friend1')];
        when(
          mockAddFriendUseCase.watchFriends(),
        ).thenAnswer((_) => Stream.value(testFriends));

        // Act
        final stream = container.read(friendsListStreamProvider);

        // Assert
        await expectLater(stream, emits(testFriends));
        verify(mockAddFriendUseCase.watchFriends()).called(1);
      });

      testWidgets('should handle stream errors', (tester) async {
        // Arrange
        when(
          mockAddFriendUseCase.watchFriends(),
        ).thenAnswer((_) => Stream.error(Exception('Stream error')));

        // Act
        final stream = container.read(friendsListStreamProvider);

        // Assert
        await expectLater(stream, emitsError(isException));
        verify(mockAddFriendUseCase.watchFriends()).called(1);
      });
    });

    group('FriendInvitations Provider Tests', () {
      group('Success Cases', () {
        testWidgets('should load invitations successfully', (tester) async {
          // Arrange
          final receivedInvitations = [
            TestDataBuilders.createFriendInvitation(id: 'inv1'),
          ];
          final sentInvitations = [
            TestDataBuilders.createFriendInvitation(id: 'inv2'),
          ];

          when(
            mockAddFriendUseCase.getReceivedInvitations(),
          ).thenAnswer((_) async => receivedInvitations);
          when(
            mockAddFriendUseCase.getSentInvitations(),
          ).thenAnswer((_) async => sentInvitations);

          // Act
          final provider = container.read(friendInvitationsProvider);

          // Assert
          final result = await provider;
          expect(result['received'], equals(receivedInvitations));
          expect(result['sent'], equals(sentInvitations));
          verify(mockAddFriendUseCase.getReceivedInvitations()).called(1);
          verify(mockAddFriendUseCase.getSentInvitations()).called(1);
        });

        testWidgets('should invite friend successfully', (tester) async {
          // Arrange
          final initialReceived = [
            TestDataBuilders.createFriendInvitation(id: 'inv1'),
          ];
          final initialSent = [
            TestDataBuilders.createFriendInvitation(id: 'inv2'),
          ];
          final updatedSent = [
            TestDataBuilders.createFriendInvitation(id: 'inv2'),
            TestDataBuilders.createFriendInvitation(id: 'inv3'),
          ];

          when(
            mockAddFriendUseCase.getReceivedInvitations(),
          ).thenAnswer((_) async => initialReceived);
          when(mockAddFriendUseCase.getSentInvitations())
              .thenAnswer((_) async => initialSent)
              .thenAnswer((_) async => updatedSent);
          when(
            mockAddFriendUseCase.inviteFriend(
              'friend@test.com',
              message: 'Hello',
            ),
          ).thenAnswer((_) async => true);

          // Act
          final notifier = container.read(friendInvitationsProvider.notifier);
          await container.read(
            friendInvitationsProvider.future,
          ); // Initial load
          final success = await notifier.inviteFriend(
            'friend@test.com',
            message: 'Hello',
          );

          // Assert
          expect(success, isTrue);
          final result = await container.read(friendInvitationsProvider.future);
          expect(result['sent'], equals(updatedSent));
          verify(
            mockAddFriendUseCase.inviteFriend(
              'friend@test.com',
              message: 'Hello',
            ),
          ).called(1);
        });

        testWidgets('should accept invitation successfully', (tester) async {
          // Arrange
          final initialReceived = [
            TestDataBuilders.createFriendInvitation(id: 'inv1'),
          ];
          final initialSent = [
            TestDataBuilders.createFriendInvitation(id: 'inv2'),
          ];
          final updatedReceived = <FriendInvitation>[];

          when(mockAddFriendUseCase.getReceivedInvitations())
              .thenAnswer((_) async => initialReceived)
              .thenAnswer((_) async => updatedReceived);
          when(
            mockAddFriendUseCase.getSentInvitations(),
          ).thenAnswer((_) async => initialSent);
          when(
            mockAddFriendUseCase.acceptInvitation('inv1'),
          ).thenAnswer((_) async => true);

          // Act
          final notifier = container.read(friendInvitationsProvider.notifier);
          await container.read(
            friendInvitationsProvider.future,
          ); // Initial load
          final success = await notifier.acceptInvitation('inv1');

          // Assert
          expect(success, isTrue);
          final result = await container.read(friendInvitationsProvider.future);
          expect(result['received'], equals(updatedReceived));
          verify(mockAddFriendUseCase.acceptInvitation('inv1')).called(1);
        });

        testWidgets('should decline invitation successfully', (tester) async {
          // Arrange
          final initialReceived = [
            TestDataBuilders.createFriendInvitation(id: 'inv1'),
          ];
          final initialSent = [
            TestDataBuilders.createFriendInvitation(id: 'inv2'),
          ];
          final updatedReceived = <FriendInvitation>[];

          when(mockAddFriendUseCase.getReceivedInvitations())
              .thenAnswer((_) async => initialReceived)
              .thenAnswer((_) async => updatedReceived);
          when(
            mockAddFriendUseCase.getSentInvitations(),
          ).thenAnswer((_) async => initialSent);
          when(
            mockAddFriendUseCase.declineInvitation('inv1'),
          ).thenAnswer((_) async => true);

          // Act
          final notifier = container.read(friendInvitationsProvider.notifier);
          await container.read(
            friendInvitationsProvider.future,
          ); // Initial load
          final success = await notifier.declineInvitation('inv1');

          // Assert
          expect(success, isTrue);
          final result = await container.read(friendInvitationsProvider.future);
          expect(result['received'], equals(updatedReceived));
          verify(mockAddFriendUseCase.declineInvitation('inv1')).called(1);
        });
      });

      group('Error Cases', () {
        testWidgets('should handle invitation loading error', (tester) async {
          // Arrange
          when(
            mockAddFriendUseCase.getReceivedInvitations(),
          ).thenThrow(Exception('Network error'));
          when(
            mockAddFriendUseCase.getSentInvitations(),
          ).thenAnswer((_) async => []);

          // Act & Assert
          final provider = container.read(friendInvitationsProvider);
          await expectLater(provider, throwsException);
        });

        testWidgets('should handle invite friend failure', (tester) async {
          // Arrange
          when(
            mockAddFriendUseCase.getReceivedInvitations(),
          ).thenAnswer((_) async => []);
          when(
            mockAddFriendUseCase.getSentInvitations(),
          ).thenAnswer((_) async => []);
          when(
            mockAddFriendUseCase.inviteFriend('friend@test.com'),
          ).thenThrow(Exception('Invite failed'));

          // Act
          final notifier = container.read(friendInvitationsProvider.notifier);
          await container.read(
            friendInvitationsProvider.future,
          ); // Initial load
          final success = await notifier.inviteFriend('friend@test.com');

          // Assert
          expect(success, isFalse);
          verify(
            mockAddFriendUseCase.inviteFriend('friend@test.com'),
          ).called(1);
        });

        testWidgets('should handle accept invitation failure', (tester) async {
          // Arrange
          when(
            mockAddFriendUseCase.getReceivedInvitations(),
          ).thenAnswer((_) async => []);
          when(
            mockAddFriendUseCase.getSentInvitations(),
          ).thenAnswer((_) async => []);
          when(
            mockAddFriendUseCase.acceptInvitation('inv1'),
          ).thenThrow(Exception('Accept failed'));

          // Act
          final notifier = container.read(friendInvitationsProvider.notifier);
          await container.read(
            friendInvitationsProvider.future,
          ); // Initial load
          final success = await notifier.acceptInvitation('inv1');

          // Assert
          expect(success, isFalse);
          verify(mockAddFriendUseCase.acceptInvitation('inv1')).called(1);
        });
      });

      group('Edge Cases', () {
        testWidgets('should handle empty invitations', (tester) async {
          // Arrange
          when(
            mockAddFriendUseCase.getReceivedInvitations(),
          ).thenAnswer((_) async => []);
          when(
            mockAddFriendUseCase.getSentInvitations(),
          ).thenAnswer((_) async => []);

          // Act
          final provider = container.read(friendInvitationsProvider);

          // Assert
          final result = await provider;
          expect(result['received'], isEmpty);
          expect(result['sent'], isEmpty);
        });

        testWidgets('should not refresh when invitation action fails', (
          tester,
        ) async {
          // Arrange
          when(
            mockAddFriendUseCase.getReceivedInvitations(),
          ).thenAnswer((_) async => []);
          when(
            mockAddFriendUseCase.getSentInvitations(),
          ).thenAnswer((_) async => []);
          when(
            mockAddFriendUseCase.inviteFriend('friend@test.com'),
          ).thenAnswer((_) async => false);

          // Act
          final notifier = container.read(friendInvitationsProvider.notifier);
          await container.read(
            friendInvitationsProvider.future,
          ); // Initial load
          final success = await notifier.inviteFriend('friend@test.com');

          // Assert
          expect(success, isFalse);
          verify(
            mockAddFriendUseCase.inviteFriend('friend@test.com'),
          ).called(1);
          verify(
            mockAddFriendUseCase.getReceivedInvitations(),
          ).called(1); // Only initial load
          verify(
            mockAddFriendUseCase.getSentInvitations(),
          ).called(1); // Only initial load
        });
      });
    });

    group('FriendInvitationsStream Provider Tests', () {
      testWidgets('should provide invitations stream', (tester) async {
        // Arrange
        final testInvitations = [
          TestDataBuilders.createFriendInvitation(id: 'inv1'),
        ];
        when(
          mockAddFriendUseCase.watchInvitations(),
        ).thenAnswer((_) => Stream.value(testInvitations));

        // Act
        final stream = container.read(friendInvitationsStreamProvider);

        // Assert
        await expectLater(stream, emits(testInvitations));
        verify(mockAddFriendUseCase.watchInvitations()).called(1);
      });

      testWidgets('should handle stream errors', (tester) async {
        // Arrange
        when(
          mockAddFriendUseCase.watchInvitations(),
        ).thenAnswer((_) => Stream.error(Exception('Stream error')));

        // Act
        final stream = container.read(friendInvitationsStreamProvider);

        // Assert
        await expectLater(stream, emitsError(isException));
        verify(mockAddFriendUseCase.watchInvitations()).called(1);
      });
    });

    group('WeeklyRanking Provider Tests', () {
      group('Success Cases', () {
        testWidgets('should load current week ranking', (tester) async {
          // Arrange
          final testRanking = [
            TestDataBuilders.createRankingData(userId: 'user1', rank: 1),
          ];
          when(
            mockGetFriendsRankingUseCase.getCurrentWeekRanking(),
          ).thenAnswer((_) async => testRanking);

          // Act
          final provider = container.read(weeklyRankingProvider());

          // Assert
          await expectLater(provider, completion(testRanking));
          verify(
            mockGetFriendsRankingUseCase.getCurrentWeekRanking(),
          ).called(1);
        });

        testWidgets('should load specific week ranking', (tester) async {
          // Arrange
          final startDate = DateTime(2024, 1, 1);
          final endDate = DateTime(2024, 1, 7);
          final testRanking = [
            TestDataBuilders.createRankingData(userId: 'user1', rank: 1),
          ];
          when(
            mockGetFriendsRankingUseCase.getWeeklyRanking(
              startDate: startDate,
              endDate: endDate,
            ),
          ).thenAnswer((_) async => testRanking);

          // Act
          final provider = container.read(
            weeklyRankingProvider(startDate: startDate, endDate: endDate),
          );

          // Assert
          await expectLater(provider, completion(testRanking));
          verify(
            mockGetFriendsRankingUseCase.getWeeklyRanking(
              startDate: startDate,
              endDate: endDate,
            ),
          ).called(1);
        });

        testWidgets('should refresh ranking successfully', (tester) async {
          // Arrange
          final initialRanking = [
            TestDataBuilders.createRankingData(userId: 'user1', rank: 1),
          ];
          final updatedRanking = [
            TestDataBuilders.createRankingData(userId: 'user1', rank: 2),
            TestDataBuilders.createRankingData(userId: 'user2', rank: 1),
          ];

          when(mockGetFriendsRankingUseCase.getCurrentWeekRanking())
              .thenAnswer((_) async => initialRanking)
              .thenAnswer((_) async => updatedRanking);

          // Act
          final notifier = container.read(weeklyRankingProvider().notifier);
          await container.read(weeklyRankingProvider().future); // Initial load
          await notifier.refresh();

          // Assert
          final result = await container.read(weeklyRankingProvider().future);
          expect(result, equals(updatedRanking));
          verify(
            mockGetFriendsRankingUseCase.getCurrentWeekRanking(),
          ).called(2);
        });
      });

      group('Error Cases', () {
        testWidgets('should handle ranking loading error', (tester) async {
          // Arrange
          when(
            mockGetFriendsRankingUseCase.getCurrentWeekRanking(),
          ).thenThrow(Exception('Network error'));

          // Act & Assert
          final provider = container.read(weeklyRankingProvider());
          await expectLater(provider, throwsException);
          verify(
            mockGetFriendsRankingUseCase.getCurrentWeekRanking(),
          ).called(1);
        });
      });

      group('Edge Cases', () {
        testWidgets('should handle empty ranking', (tester) async {
          // Arrange
          when(
            mockGetFriendsRankingUseCase.getCurrentWeekRanking(),
          ).thenAnswer((_) async => []);

          // Act
          final provider = container.read(weeklyRankingProvider());

          // Assert
          await expectLater(provider, completion(isEmpty));
          verify(
            mockGetFriendsRankingUseCase.getCurrentWeekRanking(),
          ).called(1);
        });
      });
    });

    group('MonthlyRanking Provider Tests', () {
      group('Success Cases', () {
        testWidgets('should load current month ranking', (tester) async {
          // Arrange
          final testRanking = [
            TestDataBuilders.createRankingData(userId: 'user1', rank: 1),
          ];
          when(
            mockGetFriendsRankingUseCase.getCurrentMonthRanking(),
          ).thenAnswer((_) async => testRanking);

          // Act
          final provider = container.read(monthlyRankingProvider());

          // Assert
          await expectLater(provider, completion(testRanking));
          verify(
            mockGetFriendsRankingUseCase.getCurrentMonthRanking(),
          ).called(1);
        });

        testWidgets('should load specific month ranking', (tester) async {
          // Arrange
          const year = 2024;
          const month = 1;
          final testRanking = [
            TestDataBuilders.createRankingData(userId: 'user1', rank: 1),
          ];
          when(
            mockGetFriendsRankingUseCase.getMonthlyRanking(
              year: year,
              month: month,
            ),
          ).thenAnswer((_) async => testRanking);

          // Act
          final provider = container.read(
            monthlyRankingProvider(year: year, month: month),
          );

          // Assert
          await expectLater(provider, completion(testRanking));
          verify(
            mockGetFriendsRankingUseCase.getMonthlyRanking(
              year: year,
              month: month,
            ),
          ).called(1);
        });

        testWidgets('should refresh ranking successfully', (tester) async {
          // Arrange
          final initialRanking = [
            TestDataBuilders.createRankingData(userId: 'user1', rank: 1),
          ];
          final updatedRanking = [
            TestDataBuilders.createRankingData(userId: 'user1', rank: 2),
            TestDataBuilders.createRankingData(userId: 'user2', rank: 1),
          ];

          when(mockGetFriendsRankingUseCase.getCurrentMonthRanking())
              .thenAnswer((_) async => initialRanking)
              .thenAnswer((_) async => updatedRanking);

          // Act
          final notifier = container.read(monthlyRankingProvider().notifier);
          await container.read(monthlyRankingProvider().future); // Initial load
          await notifier.refresh();

          // Assert
          final result = await container.read(monthlyRankingProvider().future);
          expect(result, equals(updatedRanking));
          verify(
            mockGetFriendsRankingUseCase.getCurrentMonthRanking(),
          ).called(2);
        });
      });

      group('Error Cases', () {
        testWidgets('should handle ranking loading error', (tester) async {
          // Arrange
          when(
            mockGetFriendsRankingUseCase.getCurrentMonthRanking(),
          ).thenThrow(Exception('Network error'));

          // Act & Assert
          final provider = container.read(monthlyRankingProvider());
          await expectLater(provider, throwsException);
          verify(
            mockGetFriendsRankingUseCase.getCurrentMonthRanking(),
          ).called(1);
        });
      });

      group('Edge Cases', () {
        testWidgets('should handle empty ranking', (tester) async {
          // Arrange
          when(
            mockGetFriendsRankingUseCase.getCurrentMonthRanking(),
          ).thenAnswer((_) async => []);

          // Act
          final provider = container.read(monthlyRankingProvider());

          // Assert
          await expectLater(provider, completion(isEmpty));
          verify(
            mockGetFriendsRankingUseCase.getCurrentMonthRanking(),
          ).called(1);
        });
      });
    });
    group('RankingStream Provider Tests', () {
      testWidgets('should provide ranking stream', (tester) async {
        // Arrange
        final testRanking = [
          TestDataBuilders.createRankingData(userId: 'user1', rank: 1),
        ];
        when(
          mockGetFriendsRankingUseCase.watchRanking(RankingPeriod.weekly),
        ).thenAnswer((_) => Stream.value(testRanking));

        // Act
        final stream = container.read(
          rankingStreamProvider(RankingPeriod.weekly),
        );

        // Assert
        await expectLater(stream, emits(testRanking));
        verify(
          mockGetFriendsRankingUseCase.watchRanking(RankingPeriod.weekly),
        ).called(1);
      });

      testWidgets('should handle stream errors', (tester) async {
        // Arrange
        when(
          mockGetFriendsRankingUseCase.watchRanking(RankingPeriod.monthly),
        ).thenAnswer((_) => Stream.error(Exception('Stream error')));

        // Act
        final stream = container.read(
          rankingStreamProvider(RankingPeriod.monthly),
        );

        // Assert
        await expectLater(stream, emitsError(isException));
        verify(
          mockGetFriendsRankingUseCase.watchRanking(RankingPeriod.monthly),
        ).called(1);
      });
    });

    group('FriendSearch Provider Tests', () {
      group('Success Cases', () {
        testWidgets('should return empty list for empty query', (tester) async {
          // Act
          final provider = container.read(friendSearchProvider(''));

          // Assert
          await expectLater(provider, completion(isEmpty));
          verifyNever(mockAddFriendUseCase.searchFriends(any));
        });

        testWidgets('should search friends successfully', (tester) async {
          // Arrange
          const query = 'John';
          final searchResults = [
            TestDataBuilders.createUserProfile(name: 'John Doe'),
          ];
          when(
            mockAddFriendUseCase.searchFriends(query),
          ).thenAnswer((_) async => searchResults);

          // Act
          final provider = container.read(friendSearchProvider(query));

          // Assert
          await expectLater(provider, completion(searchResults));
          verify(mockAddFriendUseCase.searchFriends(query)).called(1);
        });

        testWidgets('should perform new search', (tester) async {
          // Arrange
          const initialQuery = 'John';
          const newQuery = 'Jane';
          final initialResults = [
            TestDataBuilders.createUserProfile(name: 'John Doe'),
          ];
          final newResults = [
            TestDataBuilders.createUserProfile(name: 'Jane Smith'),
          ];

          when(
            mockAddFriendUseCase.searchFriends(initialQuery),
          ).thenAnswer((_) async => initialResults);
          when(
            mockAddFriendUseCase.searchFriends(newQuery),
          ).thenAnswer((_) async => newResults);

          // Act
          final notifier = container.read(
            friendSearchProvider(initialQuery).notifier,
          );
          await container.read(
            friendSearchProvider(initialQuery).future,
          ); // Initial search
          await notifier.search(newQuery);

          // Assert
          final result = await container.read(
            friendSearchProvider(initialQuery).future,
          );
          expect(result, equals(newResults));
          verify(mockAddFriendUseCase.searchFriends(initialQuery)).called(1);
          verify(mockAddFriendUseCase.searchFriends(newQuery)).called(1);
        });

        testWidgets('should handle empty search query in search method', (
          tester,
        ) async {
          // Arrange
          const initialQuery = 'John';
          final initialResults = [
            TestDataBuilders.createUserProfile(name: 'John Doe'),
          ];
          when(
            mockAddFriendUseCase.searchFriends(initialQuery),
          ).thenAnswer((_) async => initialResults);

          // Act
          final notifier = container.read(
            friendSearchProvider(initialQuery).notifier,
          );
          await container.read(
            friendSearchProvider(initialQuery).future,
          ); // Initial search
          await notifier.search('');

          // Assert
          final result = await container.read(
            friendSearchProvider(initialQuery).future,
          );
          expect(result, isEmpty);
          verify(mockAddFriendUseCase.searchFriends(initialQuery)).called(1);
          verifyNever(mockAddFriendUseCase.searchFriends(''));
        });
      });

      group('Error Cases', () {
        testWidgets('should handle search error', (tester) async {
          // Arrange
          const query = 'John';
          when(
            mockAddFriendUseCase.searchFriends(query),
          ).thenThrow(Exception('Search failed'));

          // Act & Assert
          final provider = container.read(friendSearchProvider(query));
          await expectLater(provider, throwsException);
          verify(mockAddFriendUseCase.searchFriends(query)).called(1);
        });
      });

      group('Edge Cases', () {
        testWidgets('should handle whitespace-only query', (tester) async {
          // Act
          final provider = container.read(friendSearchProvider('   '));

          // Assert
          await expectLater(provider, completion(isEmpty));
          verifyNever(mockAddFriendUseCase.searchFriends(any));
        });

        testWidgets('should return empty results', (tester) async {
          // Arrange
          const query = 'NonExistentUser';
          when(
            mockAddFriendUseCase.searchFriends(query),
          ).thenAnswer((_) async => []);

          // Act
          final provider = container.read(friendSearchProvider(query));

          // Assert
          await expectLater(provider, completion(isEmpty));
          verify(mockAddFriendUseCase.searchFriends(query)).called(1);
        });
      });
    });

    group('FriendsStatistics Provider Tests', () {
      group('Success Cases', () {
        testWidgets('should load statistics successfully', (tester) async {
          // Arrange
          final testStatistics = TestDataBuilders.createFriendsStatistics();
          when(
            mockAddFriendUseCase.getFriendsStatistics(),
          ).thenAnswer((_) async => testStatistics);

          // Act
          final provider = container.read(friendsStatisticsProvider);

          // Assert
          await expectLater(provider, completion(testStatistics));
          verify(mockAddFriendUseCase.getFriendsStatistics()).called(1);
        });

        testWidgets('should refresh statistics successfully', (tester) async {
          // Arrange
          final initialStats = TestDataBuilders.createFriendsStatistics(
            totalFriends: 5,
          );
          final updatedStats = TestDataBuilders.createFriendsStatistics(
            totalFriends: 6,
          );

          when(mockAddFriendUseCase.getFriendsStatistics())
              .thenAnswer((_) async => initialStats)
              .thenAnswer((_) async => updatedStats);

          // Act
          final notifier = container.read(friendsStatisticsProvider.notifier);
          await container.read(
            friendsStatisticsProvider.future,
          ); // Initial load
          await notifier.refresh();

          // Assert
          final result = await container.read(friendsStatisticsProvider.future);
          expect(result, equals(updatedStats));
          verify(mockAddFriendUseCase.getFriendsStatistics()).called(2);
        });
      });

      group('Error Cases', () {
        testWidgets('should handle statistics loading error', (tester) async {
          // Arrange
          when(
            mockAddFriendUseCase.getFriendsStatistics(),
          ).thenThrow(Exception('Network error'));

          // Act & Assert
          final provider = container.read(friendsStatisticsProvider);
          await expectLater(provider, throwsException);
          verify(mockAddFriendUseCase.getFriendsStatistics()).called(1);
        });
      });

      group('Edge Cases', () {
        testWidgets('should handle empty statistics', (tester) async {
          // Arrange
          final emptyStats = <String, dynamic>{};
          when(
            mockAddFriendUseCase.getFriendsStatistics(),
          ).thenAnswer((_) async => emptyStats);

          // Act
          final provider = container.read(friendsStatisticsProvider);

          // Assert
          await expectLater(provider, completion(emptyStats));
          verify(mockAddFriendUseCase.getFriendsStatistics()).called(1);
        });
      });
    });

    group('CurrentFriendsCount Provider Tests', () {
      testWidgets('should return current friends count', (tester) async {
        // Arrange
        const expectedCount = 5;
        when(
          mockAddFriendUseCase.getCurrentFriendsCount(),
        ).thenAnswer((_) async => expectedCount);

        // Act
        final provider = container.read(currentFriendsCountProvider);

        // Assert
        await expectLater(provider, completion(expectedCount));
        verify(mockAddFriendUseCase.getCurrentFriendsCount()).called(1);
      });

      testWidgets('should handle error', (tester) async {
        // Arrange
        when(
          mockAddFriendUseCase.getCurrentFriendsCount(),
        ).thenThrow(Exception('Network error'));

        // Act & Assert
        final provider = container.read(currentFriendsCountProvider);
        await expectLater(provider, throwsException);
        verify(mockAddFriendUseCase.getCurrentFriendsCount()).called(1);
      });
    });

    group('CanAddMoreFriends Provider Tests', () {
      testWidgets('should return true when can add more friends', (
        tester,
      ) async {
        // Arrange
        when(
          mockAddFriendUseCase.canAddMoreFriends(),
        ).thenAnswer((_) async => true);

        // Act
        final provider = container.read(canAddMoreFriendsProvider);

        // Assert
        await expectLater(provider, completion(isTrue));
        verify(mockAddFriendUseCase.canAddMoreFriends()).called(1);
      });

      testWidgets('should return false when cannot add more friends', (
        tester,
      ) async {
        // Arrange
        when(
          mockAddFriendUseCase.canAddMoreFriends(),
        ).thenAnswer((_) async => false);

        // Act
        final provider = container.read(canAddMoreFriendsProvider);

        // Assert
        await expectLater(provider, completion(isFalse));
        verify(mockAddFriendUseCase.canAddMoreFriends()).called(1);
      });

      testWidgets('should handle error', (tester) async {
        // Arrange
        when(
          mockAddFriendUseCase.canAddMoreFriends(),
        ).thenThrow(Exception('Network error'));

        // Act & Assert
        final provider = container.read(canAddMoreFriendsProvider);
        await expectLater(provider, throwsException);
        verify(mockAddFriendUseCase.canAddMoreFriends()).called(1);
      });
    });

    group('FriendActivityData Provider Tests', () {
      group('Success Cases', () {
        testWidgets('should load friend activity data successfully', (
          tester,
        ) async {
          // Arrange
          const friendId = 'friend1';
          final startDate = DateTime(2024, 1, 1);
          final endDate = DateTime(2024, 1, 7);
          final testData = [TestDataBuilders.createHealthData()];

          when(
            mockGetFriendsRankingUseCase.getFriendActivityData(
              friendId: friendId,
              startDate: startDate,
              endDate: endDate,
            ),
          ).thenAnswer((_) async => testData);

          // Act
          final provider = container.read(
            friendActivityDataProvider(
              friendId: friendId,
              startDate: startDate,
              endDate: endDate,
            ),
          );

          // Assert
          await expectLater(provider, completion(testData));
          verify(
            mockGetFriendsRankingUseCase.getFriendActivityData(
              friendId: friendId,
              startDate: startDate,
              endDate: endDate,
            ),
          ).called(1);
        });

        testWidgets('should refresh activity data successfully', (
          tester,
        ) async {
          // Arrange
          const friendId = 'friend1';
          final startDate = DateTime(2024, 1, 1);
          final endDate = DateTime(2024, 1, 7);
          final initialData = [
            TestDataBuilders.createHealthData(stepCount: 5000),
          ];
          final updatedData = [
            TestDataBuilders.createHealthData(stepCount: 6000),
          ];

          when(
                mockGetFriendsRankingUseCase.getFriendActivityData(
                  friendId: friendId,
                  startDate: startDate,
                  endDate: endDate,
                ),
              )
              .thenAnswer((_) async => initialData)
              .thenAnswer((_) async => updatedData);

          // Act
          final notifier = container.read(
            friendActivityDataProvider(
              friendId: friendId,
              startDate: startDate,
              endDate: endDate,
            ).notifier,
          );
          await container.read(
            friendActivityDataProvider(
              friendId: friendId,
              startDate: startDate,
              endDate: endDate,
            ).future,
          ); // Initial load
          await notifier.refresh();

          // Assert
          final result = await container.read(
            friendActivityDataProvider(
              friendId: friendId,
              startDate: startDate,
              endDate: endDate,
            ).future,
          );
          expect(result, equals(updatedData));
          verify(
            mockGetFriendsRankingUseCase.getFriendActivityData(
              friendId: friendId,
              startDate: startDate,
              endDate: endDate,
            ),
          ).called(2);
        });
      });

      group('Error Cases', () {
        testWidgets('should handle activity data loading error', (
          tester,
        ) async {
          // Arrange
          const friendId = 'friend1';
          final startDate = DateTime(2024, 1, 1);
          final endDate = DateTime(2024, 1, 7);

          when(
            mockGetFriendsRankingUseCase.getFriendActivityData(
              friendId: friendId,
              startDate: startDate,
              endDate: endDate,
            ),
          ).thenThrow(Exception('Network error'));

          // Act & Assert
          final provider = container.read(
            friendActivityDataProvider(
              friendId: friendId,
              startDate: startDate,
              endDate: endDate,
            ),
          );
          await expectLater(provider, throwsException);
        });
      });

      group('Edge Cases', () {
        testWidgets('should handle empty activity data', (tester) async {
          // Arrange
          const friendId = 'friend1';
          final startDate = DateTime(2024, 1, 1);
          final endDate = DateTime(2024, 1, 7);

          when(
            mockGetFriendsRankingUseCase.getFriendActivityData(
              friendId: friendId,
              startDate: startDate,
              endDate: endDate,
            ),
          ).thenAnswer((_) async => []);

          // Act
          final provider = container.read(
            friendActivityDataProvider(
              friendId: friendId,
              startDate: startDate,
              endDate: endDate,
            ),
          );

          // Assert
          await expectLater(provider, completion(isEmpty));
        });
      });
    });

    group('FriendComparison Provider Tests', () {
      group('Success Cases', () {
        testWidgets('should load friend comparison data successfully', (
          tester,
        ) async {
          // Arrange
          const friendId = 'friend1';
          const period = RankingPeriod.weekly;
          final testComparison = TestDataBuilders.createFriendComparison();

          when(
            mockGetFriendsRankingUseCase.compareWithFriend(
              friendId: friendId,
              period: period,
            ),
          ).thenAnswer((_) async => testComparison);

          // Act
          final provider = container.read(
            friendComparisonProvider(friendId: friendId, period: period),
          );

          // Assert
          await expectLater(provider, completion(testComparison));
          verify(
            mockGetFriendsRankingUseCase.compareWithFriend(
              friendId: friendId,
              period: period,
            ),
          ).called(1);
        });

        testWidgets('should refresh comparison data successfully', (
          tester,
        ) async {
          // Arrange
          const friendId = 'friend1';
          const period = RankingPeriod.monthly;
          final initialComparison = TestDataBuilders.createFriendComparison(
            isAhead: false,
          );
          final updatedComparison = TestDataBuilders.createFriendComparison(
            isAhead: true,
          );

          when(
                mockGetFriendsRankingUseCase.compareWithFriend(
                  friendId: friendId,
                  period: period,
                ),
              )
              .thenAnswer((_) async => initialComparison)
              .thenAnswer((_) async => updatedComparison);

          // Act
          final notifier = container.read(
            friendComparisonProvider(
              friendId: friendId,
              period: period,
            ).notifier,
          );
          await container.read(
            friendComparisonProvider(friendId: friendId, period: period).future,
          ); // Initial load
          await notifier.refresh();

          // Assert
          final result = await container.read(
            friendComparisonProvider(friendId: friendId, period: period).future,
          );
          expect(result, equals(updatedComparison));
          verify(
            mockGetFriendsRankingUseCase.compareWithFriend(
              friendId: friendId,
              period: period,
            ),
          ).called(2);
        });
      });

      group('Error Cases', () {
        testWidgets('should handle comparison data loading error', (
          tester,
        ) async {
          // Arrange
          const friendId = 'friend1';
          const period = RankingPeriod.weekly;

          when(
            mockGetFriendsRankingUseCase.compareWithFriend(
              friendId: friendId,
              period: period,
            ),
          ).thenThrow(Exception('Network error'));

          // Act & Assert
          final provider = container.read(
            friendComparisonProvider(friendId: friendId, period: period),
          );
          await expectLater(provider, throwsException);
        });
      });
    });

    group('SocialManager Provider Tests', () {
      group('Success Cases', () {
        testWidgets('should load integrated social data successfully', (
          tester,
        ) async {
          // Arrange
          final testFriends = [
            TestDataBuilders.createUserProfile(id: 'friend1'),
          ];
          final testInvitations = {
            'received': [TestDataBuilders.createFriendInvitation(id: 'inv1')],
            'sent': [TestDataBuilders.createFriendInvitation(id: 'inv2')],
          };
          final testStatistics = TestDataBuilders.createFriendsStatistics();
          const canAddMore = true;

          when(
            mockAddFriendUseCase.getFriends(),
          ).thenAnswer((_) async => testFriends);
          when(
            mockAddFriendUseCase.getReceivedInvitations(),
          ).thenAnswer((_) async => testInvitations['received']!);
          when(
            mockAddFriendUseCase.getSentInvitations(),
          ).thenAnswer((_) async => testInvitations['sent']!);
          when(
            mockAddFriendUseCase.getFriendsStatistics(),
          ).thenAnswer((_) async => testStatistics);
          when(
            mockAddFriendUseCase.canAddMoreFriends(),
          ).thenAnswer((_) async => canAddMore);

          // Act
          final provider = container.read(socialManagerProvider);

          // Assert
          final result = await provider;
          expect(result['friends'], equals(testFriends));
          expect(result['invitations'], equals(testInvitations));
          expect(result['statistics'], equals(testStatistics));
          expect(result['canAddMoreFriends'], equals(canAddMore));

          verify(mockAddFriendUseCase.getFriends()).called(1);
          verify(mockAddFriendUseCase.getReceivedInvitations()).called(1);
          verify(mockAddFriendUseCase.getSentInvitations()).called(1);
          verify(mockAddFriendUseCase.getFriendsStatistics()).called(1);
          verify(mockAddFriendUseCase.canAddMoreFriends()).called(1);
        });

        testWidgets('should refresh integrated social data successfully', (
          tester,
        ) async {
          // Arrange
          final initialFriends = [
            TestDataBuilders.createUserProfile(id: 'friend1'),
          ];
          final updatedFriends = [
            TestDataBuilders.createUserProfile(id: 'friend1'),
            TestDataBuilders.createUserProfile(id: 'friend2'),
          ];
          final testInvitations = {
            'received': [TestDataBuilders.createFriendInvitation(id: 'inv1')],
            'sent': [TestDataBuilders.createFriendInvitation(id: 'inv2')],
          };
          final testStatistics = TestDataBuilders.createFriendsStatistics();
          const canAddMore = true;

          when(mockAddFriendUseCase.getFriends())
              .thenAnswer((_) async => initialFriends)
              .thenAnswer((_) async => updatedFriends);
          when(
            mockAddFriendUseCase.getReceivedInvitations(),
          ).thenAnswer((_) async => testInvitations['received']!);
          when(
            mockAddFriendUseCase.getSentInvitations(),
          ).thenAnswer((_) async => testInvitations['sent']!);
          when(
            mockAddFriendUseCase.getFriendsStatistics(),
          ).thenAnswer((_) async => testStatistics);
          when(
            mockAddFriendUseCase.canAddMoreFriends(),
          ).thenAnswer((_) async => canAddMore);

          // Act
          final notifier = container.read(socialManagerProvider.notifier);
          await container.read(socialManagerProvider.future); // Initial load
          await notifier.refresh();

          // Assert
          final result = await container.read(socialManagerProvider.future);
          expect(result['friends'], equals(updatedFriends));
          verify(mockAddFriendUseCase.getFriends()).called(2);
        });
      });

      group('Error Cases', () {
        testWidgets('should handle integrated data loading error', (
          tester,
        ) async {
          // Arrange
          when(
            mockAddFriendUseCase.getFriends(),
          ).thenThrow(Exception('Network error'));
          when(
            mockAddFriendUseCase.getReceivedInvitations(),
          ).thenAnswer((_) async => []);
          when(
            mockAddFriendUseCase.getSentInvitations(),
          ).thenAnswer((_) async => []);
          when(
            mockAddFriendUseCase.getFriendsStatistics(),
          ).thenAnswer((_) async => {});
          when(
            mockAddFriendUseCase.canAddMoreFriends(),
          ).thenAnswer((_) async => false);

          // Act & Assert
          final provider = container.read(socialManagerProvider);
          await expectLater(provider, throwsException);
        });
      });

      group('Edge Cases', () {
        testWidgets('should handle empty social data', (tester) async {
          // Arrange
          final emptyFriends = <UserProfile>[];
          final emptyInvitations = {
            'received': <FriendInvitation>[],
            'sent': <FriendInvitation>[],
          };
          final emptyStatistics = <String, dynamic>{};
          const canAddMore = true;

          when(
            mockAddFriendUseCase.getFriends(),
          ).thenAnswer((_) async => emptyFriends);
          when(
            mockAddFriendUseCase.getReceivedInvitations(),
          ).thenAnswer((_) async => emptyInvitations['received']!);
          when(
            mockAddFriendUseCase.getSentInvitations(),
          ).thenAnswer((_) async => emptyInvitations['sent']!);
          when(
            mockAddFriendUseCase.getFriendsStatistics(),
          ).thenAnswer((_) async => emptyStatistics);
          when(
            mockAddFriendUseCase.canAddMoreFriends(),
          ).thenAnswer((_) async => canAddMore);

          // Act
          final provider = container.read(socialManagerProvider);

          // Assert
          final result = await provider;
          expect(result['friends'], isEmpty);
          expect(result['invitations']['received'], isEmpty);
          expect(result['invitations']['sent'], isEmpty);
          expect(result['statistics'], isEmpty);
          expect(result['canAddMoreFriends'], isTrue);
        });
      });
    });

    group('Provider Integration Tests', () {
      testWidgets(
        'should invalidate related providers when accepting invitation',
        (tester) async {
          // Arrange
          final initialFriends = [
            TestDataBuilders.createUserProfile(id: 'friend1'),
          ];
          final updatedFriends = [
            TestDataBuilders.createUserProfile(id: 'friend1'),
            TestDataBuilders.createUserProfile(id: 'friend2'),
          ];
          final initialInvitations = {
            'received': [TestDataBuilders.createFriendInvitation(id: 'inv1')],
            'sent': <FriendInvitation>[],
          };
          final updatedInvitations = {
            'received': <FriendInvitation>[],
            'sent': <FriendInvitation>[],
          };

          when(mockAddFriendUseCase.getFriends())
              .thenAnswer((_) async => initialFriends)
              .thenAnswer((_) async => updatedFriends);
          when(mockAddFriendUseCase.getReceivedInvitations())
              .thenAnswer((_) async => initialInvitations['received']!)
              .thenAnswer((_) async => updatedInvitations['received']!);
          when(mockAddFriendUseCase.getSentInvitations())
              .thenAnswer((_) async => initialInvitations['sent']!)
              .thenAnswer((_) async => updatedInvitations['sent']!);
          when(
            mockAddFriendUseCase.acceptInvitation('inv1'),
          ).thenAnswer((_) async => true);

          // Act
          final friendsNotifier = container.read(friendsListProvider.notifier);
          final invitationsNotifier = container.read(
            friendInvitationsProvider.notifier,
          );

          await container.read(friendsListProvider.future); // Initial load
          await container.read(
            friendInvitationsProvider.future,
          ); // Initial load

          final success = await invitationsNotifier.acceptInvitation('inv1');

          // Assert
          expect(success, isTrue);

          // Verify friends list is updated
          final friendsResult = await container.read(
            friendsListProvider.future,
          );
          expect(friendsResult, equals(updatedFriends));

          // Verify invitations list is updated
          final invitationsResult = await container.read(
            friendInvitationsProvider.future,
          );
          expect(invitationsResult['received'], isEmpty);

          verify(mockAddFriendUseCase.acceptInvitation('inv1')).called(1);
        },
      );

      testWidgets('should handle concurrent provider operations', (
        tester,
      ) async {
        // Arrange
        final testFriends = [TestDataBuilders.createUserProfile(id: 'friend1')];
        final testInvitations = {
          'received': [TestDataBuilders.createFriendInvitation(id: 'inv1')],
          'sent': <FriendInvitation>[],
        };
        final testStatistics = TestDataBuilders.createFriendsStatistics();

        when(
          mockAddFriendUseCase.getFriends(),
        ).thenAnswer((_) async => testFriends);
        when(
          mockAddFriendUseCase.getReceivedInvitations(),
        ).thenAnswer((_) async => testInvitations['received']!);
        when(
          mockAddFriendUseCase.getSentInvitations(),
        ).thenAnswer((_) async => testInvitations['sent']!);
        when(
          mockAddFriendUseCase.getFriendsStatistics(),
        ).thenAnswer((_) async => testStatistics);

        // Act - Load multiple providers concurrently
        final futures = await Future.wait([
          container.read(friendsListProvider.future),
          container.read(friendInvitationsProvider.future),
          container.read(friendsStatisticsProvider.future),
        ]);

        // Assert
        expect(futures[0], equals(testFriends));
        expect(futures[1], equals(testInvitations));
        expect(futures[2], equals(testStatistics));

        verify(mockAddFriendUseCase.getFriends()).called(1);
        verify(mockAddFriendUseCase.getReceivedInvitations()).called(1);
        verify(mockAddFriendUseCase.getSentInvitations()).called(1);
        verify(mockAddFriendUseCase.getFriendsStatistics()).called(1);
      });
    });
  });
}
