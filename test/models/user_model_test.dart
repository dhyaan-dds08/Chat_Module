import 'package:flutter_test/flutter_test.dart';
import 'package:chat_module/data/model/user_model.dart';

void main() {
  group('UserModel Tests', () {
    test('should generate correct initial from name', () {
      expect(UserModel.getInitial('John Doe'), 'J');
      expect(UserModel.getInitial('alice'), 'A');
      expect(UserModel.getInitial(''), 'U');
      expect(UserModel.getInitial('  '), 'U');
    });

    test('should create user with correct properties', () {
      final user = UserModel(id: '123', name: 'Test User', initial: 'T');

      expect(user.id, '123');
      expect(user.name, 'Test User');
      expect(user.initial, 'T');
      expect(user.isOnline, true);
    });

    test('should serialize to JSON correctly', () {
      final user = UserModel(id: '123', name: 'Test User', initial: 'T');

      final json = user.toJson();

      expect(json['id'], '123');
      expect(json['name'], 'Test User');
      expect(json['initial'], 'T');
      expect(json['lastOnline'], isNotNull);
      expect(json['createdAt'], isNotNull);
    });

    test('should deserialize from JSON correctly', () {
      final now = DateTime.now();
      final json = {
        'id': '123',
        'name': 'Test User',
        'initial': 'T',
        'lastOnline': now.toIso8601String(),
        'createdAt': now.toIso8601String(),
      };

      final user = UserModel.fromJson(json);

      expect(user.id, '123');
      expect(user.name, 'Test User');
      expect(user.initial, 'T');
    });

    test('should detect online status correctly', () {
      final recentUser = UserModel(id: '1', name: 'Recent', initial: 'R');
      expect(recentUser.isOnline, true);

      final oldUser = UserModel(
        id: '2',
        name: 'Old',
        initial: 'O',
        lastOnline: DateTime.now().subtract(const Duration(minutes: 10)),
      );
      expect(oldUser.isOnline, false);
    });

    test('should generate correct lastSeenText', () {
      final onlineUser = UserModel(id: '1', name: 'Online', initial: 'O');
      expect(onlineUser.lastSeenText, 'Online');

      final tenMinsAgo = UserModel(
        id: '2',
        name: 'TenMins',
        initial: 'T',
        lastOnline: DateTime.now().subtract(const Duration(minutes: 10)),
      );
      expect(tenMinsAgo.lastSeenText, '10 mins ago');

      final oneMinAgo = UserModel(
        id: '3',
        name: 'OneMin',
        initial: 'O',
        lastOnline: DateTime.now().subtract(const Duration(minutes: 1)),
      );
      expect(oneMinAgo.lastSeenText, '1 min ago');

      final twoHoursAgo = UserModel(
        id: '4',
        name: 'TwoHours',
        initial: 'T',
        lastOnline: DateTime.now().subtract(const Duration(hours: 2)),
      );
      expect(twoHoursAgo.lastSeenText, '2 hours ago');

      final threeDaysAgo = UserModel(
        id: '5',
        name: 'ThreeDays',
        initial: 'T',
        lastOnline: DateTime.now().subtract(const Duration(days: 3)),
      );
      expect(threeDaysAgo.lastSeenText, '3 days ago');

      final tenDaysAgo = UserModel(
        id: '6',
        name: 'TenDays',
        initial: 'T',
        lastOnline: DateTime.now().subtract(const Duration(days: 10)),
      );
      expect(tenDaysAgo.lastSeenText, 'A while ago');
    });

    test('should copyWith correctly', () {
      final original = UserModel(id: '1', name: 'Original', initial: 'O');

      final updated = original.copyWith(name: 'Updated');

      expect(updated.id, '1');
      expect(updated.name, 'Updated');
      expect(updated.initial, 'O');
    });

    test('should generate unique IDs', () {
      final id1 = UserModel.generateId();
      final id2 = UserModel.generateId();

      expect(id1, isNot(equals(id2)));
      expect(id1, isNotEmpty);
    });
  });
}
