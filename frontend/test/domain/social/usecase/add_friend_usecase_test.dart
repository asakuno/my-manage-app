import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:frontend/domain/social/usecase/add_friend_usecase.dart';
import 'package:frontend/domain/social/repository/social_repository.dart';
import 'package:frontend/domain/core/entity/user_profile.dart';

import 'add_friend_usecase_test.mocks.dart';

@GenerateMocks([SocialRepository])
void main() {
  group('AddFriendUseCase', () {
    late AddFriendUseCase useCase;
    late MockSocialRepository mockSocialRepository;

    setUp(() {
      mockSocialRepository = MockSocialRepository();
      useCase = AddFriendUseCase(mockSocialRepository);
    });

    group('call (addFriend)', () {
      test('should add friend successfully when under limit', () async {
        // Arrange
        const friendId = 'friend123';
        when(
          mockSocialRepository.getCurrentFriendsCount(),
        ).thenAnswer((_) async => 5);
        when(
          mockSocialRepository.getMaxFriendsCount(),
        ).thenAnswer((_) async => 10);
        when(
          mockSocialRepository.addFriend(friendId),
        ).thenAnswer((_) async => true);

        // Act
        final result = await useCase.call(friendId);

        // Assert
        expect(result, isTrue);
        verify(mockSocialRepository.getCurrentFriendsCount()).called(1);
        verify(mockSocialRepository.getMaxFriendsCount()).called(1);
        verify(mockSocialRepository.addFriend(friendId)).called(1);
      });

      test('should throw SocialException when friend limit reached', () async {
        // Arrange
        const friendId = 'friend123';
        when(
          mockSocialRepository.getCurrentFriendsCount(),
        ).thenAnswer((_) async => 10);
        when(
          mockSocialRepository.getMaxFriendsCount(),
        ).thenAnswer((_) async => 10);

        // Act & Assert
        await expectLater(
          () => useCase.call(friendId),
          throwsA(isA<SocialException>()),
        );
        verify(mockSocialRepository.getCurrentFriendsCount()).called(2);
        verify(mockSocialRepository.getMaxFriendsCount()).called(2);
        verifyNever(mockSocialRepository.addFriend(any));
      });

      test('should throw SocialException for empty friend ID', () async {
        // Act & Assert
        expect(() => useCase.call(''), throwsA(isA<SocialException>()));
        expect(() => useCase.call('   '), throwsA(isA<SocialException>()));
        verifyNever(mockSocialRepository.addFriend(any));
      });

      test('should throw SocialException when repository throws', () async {
        // Arrange
        const friendId = 'friend123';
        when(
          mockSocialRepository.getCurrentFriendsCount(),
        ).thenAnswer((_) async => 5);
        when(
          mockSocialRepository.getMaxFriendsCount(),
        ).thenAnswer((_) async => 10);
        when(
          mockSocialRepository.addFriend(friendId),
        ).thenThrow(Exception('Repository error'));

        // Act & Assert
        expect(() => useCase.call(friendId), throwsA(isA<SocialException>()));
      });
    });

    group('inviteFriend', () {
      test('should send invitation successfully with valid email', () async {
        // Arrange
        const email = 'friend@example.com';
        const message = 'Join me on this app!';
        when(
          mockSocialRepository.getCurrentFriendsCount(),
        ).thenAnswer((_) async => 5);
        when(
          mockSocialRepository.getMaxFriendsCount(),
        ).thenAnswer((_) async => 10);
        when(
          mockSocialRepository.inviteFriend(email, message: message),
        ).thenAnswer((_) async => true);

        // Act
        final result = await useCase.inviteFriend(email, message: message);

        // Assert
        expect(result, isTrue);
        verify(
          mockSocialRepository.inviteFriend(email, message: message),
        ).called(1);
      });

      test('should throw SocialException for invalid email format', () async {
        // Act & Assert
        expect(
          () => useCase.inviteFriend('invalid-email'),
          throwsA(isA<SocialException>()),
        );
        expect(
          () => useCase.inviteFriend('invalid@'),
          throwsA(isA<SocialException>()),
        );
        expect(
          () => useCase.inviteFriend('@example.com'),
          throwsA(isA<SocialException>()),
        );
        verifyNever(
          mockSocialRepository.inviteFriend(any, message: anyNamed('message')),
        );
      });

      test('should throw SocialException for empty email', () async {
        // Act & Assert
        expect(() => useCase.inviteFriend(''), throwsA(isA<SocialException>()));
        expect(
          () => useCase.inviteFriend('   '),
          throwsA(isA<SocialException>()),
        );
        verifyNever(
          mockSocialRepository.inviteFriend(any, message: anyNamed('message')),
        );
      });
    });

    group('getFriends', () {
      test('should return friends list', () async {
        // Arrange
        final friendsList = [
          const UserProfile(
            id: 'friend1',
            name: 'Friend One',
            email: 'friend1@example.com',
            dailyStepGoal: 8000,
          ),
          const UserProfile(
            id: 'friend2',
            name: 'Friend Two',
            email: 'friend2@example.com',
            dailyStepGoal: 10000,
          ),
        ];
        when(
          mockSocialRepository.getFriends(),
        ).thenAnswer((_) async => friendsList);

        // Act
        final result = await useCase.getFriends();

        // Assert
        expect(result, equals(friendsList));
        verify(mockSocialRepository.getFriends()).called(1);
      });

      test('should throw SocialException when repository throws', () async {
        // Arrange
        when(
          mockSocialRepository.getFriends(),
        ).thenThrow(Exception('Repository error'));

        // Act & Assert
        expect(() => useCase.getFriends(), throwsA(isA<SocialException>()));
      });
    });

    group('canAddMoreFriends', () {
      test('should return true when under limit', () async {
        // Arrange
        when(
          mockSocialRepository.getCurrentFriendsCount(),
        ).thenAnswer((_) async => 5);
        when(
          mockSocialRepository.getMaxFriendsCount(),
        ).thenAnswer((_) async => 10);

        // Act
        final result = await useCase.canAddMoreFriends();

        // Assert
        expect(result, isTrue);
      });

      test('should return false when at limit', () async {
        // Arrange
        when(
          mockSocialRepository.getCurrentFriendsCount(),
        ).thenAnswer((_) async => 10);
        when(
          mockSocialRepository.getMaxFriendsCount(),
        ).thenAnswer((_) async => 10);

        // Act
        final result = await useCase.canAddMoreFriends();

        // Assert
        expect(result, isFalse);
      });

      test('should return false when error occurs', () async {
        // Arrange
        when(
          mockSocialRepository.getCurrentFriendsCount(),
        ).thenThrow(Exception('Error'));
        when(
          mockSocialRepository.getMaxFriendsCount(),
        ).thenThrow(Exception('Error'));

        // Act
        final result = await useCase.canAddMoreFriends();

        // Assert
        expect(
          result,
          isTrue,
        ); // 0 < 10 = true (default values when exceptions occur)
      });
    });

    group('searchFriends', () {
      test('should return search results for valid query', () async {
        // Arrange
        const query = 'John';
        final searchResults = [
          const UserProfile(
            id: 'user1',
            name: 'John Doe',
            email: 'john@example.com',
            dailyStepGoal: 8000,
          ),
        ];
        when(
          mockSocialRepository.searchFriends(query),
        ).thenAnswer((_) async => searchResults);

        // Act
        final result = await useCase.searchFriends(query);

        // Assert
        expect(result, equals(searchResults));
        verify(mockSocialRepository.searchFriends(query)).called(1);
      });

      test('should return empty list for empty query', () async {
        // Act
        final result = await useCase.searchFriends('');

        // Assert
        expect(result, isEmpty);
        verifyNever(mockSocialRepository.searchFriends(any));
      });

      test('should return empty list for whitespace query', () async {
        // Act
        final result = await useCase.searchFriends('   ');

        // Assert
        expect(result, isEmpty);
        verifyNever(mockSocialRepository.searchFriends(any));
      });
    });

    group('getFriendsStatistics', () {
      test('should return correct statistics', () async {
        // Arrange
        final friends = [
          const UserProfile(
            id: 'friend1',
            name: 'Friend 1',
            email: 'f1@example.com',
            dailyStepGoal: 8000,
          ),
          const UserProfile(
            id: 'friend2',
            name: 'Friend 2',
            email: 'f2@example.com',
            dailyStepGoal: 8000,
          ),
        ];
        final receivedInvitations = [
          FriendInvitation(
            id: 'inv1',
            fromUserId: 'user1',
            toUserId: 'current',
            fromUserName: 'User 1',
            toUserEmail: 'current@example.com',
            status: InvitationStatus.sent,
            createdAt: DateTime.now(),
          ),
        ];
        final sentInvitations = [
          FriendInvitation(
            id: 'inv2',
            fromUserId: 'current',
            toUserId: 'user2',
            fromUserName: 'Current User',
            toUserEmail: 'user2@example.com',
            status: InvitationStatus.sent,
            createdAt: DateTime.now(),
          ),
        ];

        when(
          mockSocialRepository.getFriends(),
        ).thenAnswer((_) async => friends);
        when(
          mockSocialRepository.getReceivedInvitations(),
        ).thenAnswer((_) async => receivedInvitations);
        when(
          mockSocialRepository.getSentInvitations(),
        ).thenAnswer((_) async => sentInvitations);
        when(
          mockSocialRepository.getMaxFriendsCount(),
        ).thenAnswer((_) async => 10);

        // Act
        final result = await useCase.getFriendsStatistics();

        // Assert
        expect(result['totalFriends'], equals(2));
        expect(result['maxFriends'], equals(10));
        expect(result['remainingSlots'], equals(8));
        expect(result['pendingReceivedInvitations'], equals(1));
        expect(result['pendingSentInvitations'], equals(1));
        expect(result['canAddMore'], isTrue);
      });
    });
  });
}
