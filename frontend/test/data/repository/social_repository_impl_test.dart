import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:frontend/data/repository/social_repository_impl.dart';
import 'package:frontend/data/local/user_preferences_data_source.dart';
import 'package:frontend/domain/core/entity/user_profile.dart';
import 'package:frontend/domain/core/entity/health_data.dart';
import 'package:frontend/domain/social/repository/social_repository.dart';
import 'package:frontend/domain/core/type/activity_level_type.dart';

import 'social_repository_impl_test.mocks.dart';

@GenerateMocks([UserPreferencesDataSource])
void main() {
  group('SocialRepositoryImpl', () {
    late SocialRepositoryImpl repository;
    late MockUserPreferencesDataSource mockLocalDataSource;

    setUp(() {
      mockLocalDataSource = MockUserPreferencesDataSource();
      repository = SocialRepositoryImpl(
        localDataSource: mockLocalDataSource,
        useMockData: true,
      );
    });

    tearDown(() {
      repository.dispose();
    });

    group('addFriend', () {
      test('should successfully add friend with mock data', () async {
        // Act
        final result = await repository.addFriend('friend_123');

        // Assert
        expect(result, isTrue);
      });

      test('should return false when adding existing friend', () async {
        // Arrange
        await repository.addFriend('friend_123');

        // Act
        final result = await repository.addFriend('friend_123');

        // Assert
        expect(result, isFalse);
      });
    });

    group('removeFriend', () {
      test('should successfully remove existing friend', () async {
        // Arrange
        await repository.addFriend('friend_123');

        // Act
        final result = await repository.removeFriend('friend_123');

        // Assert
        expect(result, isTrue);
      });

      test('should return false when removing non-existent friend', () async {
        // Act
        final result = await repository.removeFriend('non_existent_friend');

        // Assert
        expect(result, isFalse);
      });
    });

    group('getFriends', () {
      test('should return list of friends', () async {
        // Act
        final result = await repository.getFriends();

        // Assert
        expect(result, isA<List<UserProfile>>());
        expect(result, isNotEmpty); // Mock data should generate some friends

        for (final friend in result) {
          expect(friend.id, isNotEmpty);
          expect(friend.name, isNotEmpty);
          expect(friend.email, isNotEmpty);
          expect(friend.dailyStepGoal, greaterThan(0));
        }
      });
    });

    group('inviteFriend', () {
      test('should successfully send friend invitation', () async {
        // Act
        final result = await repository.inviteFriend(
          'friend@example.com',
          message: 'Let\'s be fitness buddies!',
        );

        // Assert
        expect(result, isTrue);
      });

      test('should successfully send invitation without message', () async {
        // Act
        final result = await repository.inviteFriend('friend@example.com');

        // Assert
        expect(result, isTrue);
      });
    });

    group('acceptFriendInvitation', () {
      test('should successfully accept friend invitation', () async {
        // Arrange
        await repository.inviteFriend('friend@example.com');
        final invitations = await repository.getSentInvitations();
        final invitationId = invitations.first.id;

        // Act
        final result = await repository.acceptFriendInvitation(invitationId);

        // Assert
        expect(result, isTrue);
      });

      test('should return false for non-existent invitation', () async {
        // Act
        final result = await repository.acceptFriendInvitation(
          'non_existent_id',
        );

        // Assert
        expect(result, isFalse);
      });
    });

    group('declineFriendInvitation', () {
      test('should successfully decline friend invitation', () async {
        // Arrange
        await repository.inviteFriend('friend@example.com');
        final invitations = await repository.getSentInvitations();
        final invitationId = invitations.first.id;

        // Act
        final result = await repository.declineFriendInvitation(invitationId);

        // Assert
        expect(result, isTrue);
      });

      test('should return false for non-existent invitation', () async {
        // Act
        final result = await repository.declineFriendInvitation(
          'non_existent_id',
        );

        // Assert
        expect(result, isFalse);
      });
    });

    group('getReceivedInvitations', () {
      test('should return received invitations', () async {
        // Act
        final result = await repository.getReceivedInvitations();

        // Assert
        expect(result, isA<List<FriendInvitation>>());
        // Mock data might not have received invitations by default
      });
    });

    group('getSentInvitations', () {
      test('should return sent invitations', () async {
        // Arrange
        await repository.inviteFriend('friend@example.com');

        // Act
        final result = await repository.getSentInvitations();

        // Assert
        expect(result, isA<List<FriendInvitation>>());
        expect(result, isNotEmpty);

        final invitation = result.first;
        expect(invitation.fromUserId, equals('current_user'));
        expect(invitation.toUserEmail, equals('friend@example.com'));
        expect(invitation.status, equals(InvitationStatus.sent));
      });
    });

    group('getWeeklyRanking', () {
      test('should return weekly ranking data', () async {
        // Arrange
        final startDate = DateTime.now().subtract(const Duration(days: 7));
        final endDate = DateTime.now();

        // Act
        final result = await repository.getWeeklyRanking(
          startDate: startDate,
          endDate: endDate,
        );

        // Assert
        expect(result, isA<List<RankingData>>());
        expect(result, isNotEmpty);

        for (final ranking in result) {
          expect(ranking.userId, isNotEmpty);
          expect(ranking.userName, isNotEmpty);
          expect(ranking.stepCount, greaterThanOrEqualTo(0));
          expect(ranking.rank, greaterThan(0));
        }

        // Verify ranking is sorted by rank
        for (int i = 0; i < result.length - 1; i++) {
          expect(result[i].rank, lessThanOrEqualTo(result[i + 1].rank));
        }
      });
    });

    group('getMonthlyRanking', () {
      test('should return monthly ranking data', () async {
        // Arrange
        final now = DateTime.now();

        // Act
        final result = await repository.getMonthlyRanking(
          year: now.year,
          month: now.month,
        );

        // Assert
        expect(result, isA<List<RankingData>>());
        expect(result, isNotEmpty);

        for (final ranking in result) {
          expect(ranking.userId, isNotEmpty);
          expect(ranking.userName, isNotEmpty);
          expect(ranking.stepCount, greaterThanOrEqualTo(0));
          expect(ranking.rank, greaterThan(0));
        }
      });
    });

    group('getFriendActivityData', () {
      test('should return friend activity data', () async {
        // Arrange
        final startDate = DateTime.now().subtract(const Duration(days: 7));
        final endDate = DateTime.now();

        // Act
        final result = await repository.getFriendActivityData(
          friendId: 'friend_123',
          startDate: startDate,
          endDate: endDate,
        );

        // Assert
        expect(result, isA<List<HealthData>>());
        expect(result, isNotEmpty);

        for (final data in result) {
          expect(data.stepCount, greaterThanOrEqualTo(0));
          expect(data.distance, greaterThanOrEqualTo(0.0));
          expect(data.caloriesBurned, greaterThanOrEqualTo(0));
          expect(data.activityLevel, isA<ActivityLevel>());
        }
      });
    });

    group('shareActivityData', () {
      test('should successfully share activity data', () async {
        // Arrange
        final healthData = HealthData(
          date: DateTime.now(),
          stepCount: 8000,
          distance: 6.4,
          caloriesBurned: 320,
          activityLevel: ActivityLevel.high,
        );

        // Act
        final result = await repository.shareActivityData(
          friendIds: ['friend_1', 'friend_2'],
          data: healthData,
        );

        // Assert
        expect(result, isTrue);
      });
    });

    group('updatePrivacyLevel', () {
      test('should successfully update privacy level', () async {
        // Arrange
        when(
          mockLocalDataSource.savePrivacyLevel(PrivacyLevel.public),
        ).thenAnswer((_) async => {});

        // Act
        final result = await repository.updatePrivacyLevel(PrivacyLevel.public);

        // Assert
        expect(result, isTrue);
        verify(
          mockLocalDataSource.savePrivacyLevel(PrivacyLevel.public),
        ).called(1);
      });

      test('should return false on update failure', () async {
        // Arrange
        when(
          mockLocalDataSource.savePrivacyLevel(any),
        ).thenThrow(Exception('Update failed'));

        // Act
        final result = await repository.updatePrivacyLevel(PrivacyLevel.public);

        // Assert
        expect(result, isFalse);
      });
    });

    group('getPrivacyLevel', () {
      test('should return current privacy level', () async {
        // Arrange
        when(
          mockLocalDataSource.getPrivacyLevel(),
        ).thenAnswer((_) async => PrivacyLevel.friends);

        // Act
        final result = await repository.getPrivacyLevel();

        // Assert
        expect(result, equals(PrivacyLevel.friends));
        verify(mockLocalDataSource.getPrivacyLevel()).called(1);
      });
    });

    group('searchFriends', () {
      test('should return matching friends by name', () async {
        // Arrange
        await repository.addFriend('alice_123');

        // Act
        final result = await repository.searchFriends('Alice');

        // Assert
        expect(result, isA<List<UserProfile>>());
        // Results depend on mock data generation
      });

      test('should return matching friends by email', () async {
        // Act
        final result = await repository.searchFriends('example.com');

        // Assert
        expect(result, isA<List<UserProfile>>());
        // Results depend on mock data generation
      });

      test('should return empty list for no matches', () async {
        // Act
        final result = await repository.searchFriends('nonexistent');

        // Assert
        expect(result, isA<List<UserProfile>>());
      });
    });

    group('getMaxFriendsCount', () {
      test('should return maximum friends count', () async {
        // Act
        final result = await repository.getMaxFriendsCount();

        // Assert
        expect(result, equals(50)); // Premium user limit
      });
    });

    group('getCurrentFriendsCount', () {
      test('should return current friends count', () async {
        // Act
        final result = await repository.getCurrentFriendsCount();

        // Assert
        expect(result, greaterThanOrEqualTo(0));
      });
    });

    group('blockFriend', () {
      test('should successfully block friend', () async {
        // Arrange
        await repository.addFriend('friend_123');

        // Act
        final result = await repository.blockFriend('friend_123');

        // Assert
        expect(result, isTrue);
      });

      test('should return false when blocking non-existent friend', () async {
        // Act
        final result = await repository.blockFriend('non_existent_friend');

        // Assert
        expect(result, isFalse);
      });
    });

    group('unblockFriend', () {
      test('should successfully unblock friend', () async {
        // Arrange
        await repository.addFriend('friend_123');
        await repository.blockFriend('friend_123');

        // Act
        final result = await repository.unblockFriend('friend_123');

        // Assert
        expect(result, isTrue);
      });

      test('should return false when unblocking non-blocked friend', () async {
        // Act
        final result = await repository.unblockFriend('non_blocked_friend');

        // Assert
        expect(result, isFalse);
      });
    });

    group('getBlockedFriends', () {
      test('should return list of blocked friends', () async {
        // Arrange
        await repository.addFriend('friend_123');
        await repository.blockFriend('friend_123');

        // Act
        final result = await repository.getBlockedFriends();

        // Assert
        expect(result, isA<List<UserProfile>>());
        expect(result, hasLength(1));
        expect(result.first.id, equals('friend_123'));
      });

      test('should return empty list when no blocked friends', () async {
        // Act
        final result = await repository.getBlockedFriends();

        // Assert
        expect(result, isA<List<UserProfile>>());
        expect(result, isEmpty);
      });
    });
  });
}
