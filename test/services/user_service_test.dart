import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:chat_module/core/services/user_service.dart';

void main() {
  const testPath = './test_data_user_service';

  setUpAll(() async {
    Hive.init(testPath);
    await Hive.openBox('users');
    await Hive.openBox('chats');
  });

  setUp(() async {
    await Hive.box('users').clear();
    await Hive.box('chats').clear();
  });

  tearDownAll(() async {
    if (Hive.isBoxOpen('users')) await Hive.box('users').close();
    if (Hive.isBoxOpen('chats')) await Hive.box('chats').close();
    await Hive.deleteFromDisk();
  });

  group('UserService CRUD Tests', () {
    test('should add user successfully', () async {
      final service = UserService();

      await service.addUser('Test User');
      final users = service.getAllUsers();

      expect(users.length, 1);
      expect(users.first.name, 'Test User');
      expect(users.first.initial, 'T');
    });

    test('should get user by id', () async {
      final service = UserService();

      await service.addUser('Test User');
      final userId = service.getAllUsers().first.id;

      final user = service.getUserById(userId);

      expect(user, isNotNull);
      expect(user!.name, 'Test User');
    });

    test('should return null for non-existent user', () {
      final service = UserService();

      final user = service.getUserById('invalid-id');

      expect(user, isNull);
    });

    test('should get all users sorted by creation date', () async {
      final service = UserService();

      await service.addUser('First User');
      await Future.delayed(const Duration(milliseconds: 10));
      await service.addUser('Second User');
      await Future.delayed(const Duration(milliseconds: 10));
      await service.addUser('Third User');

      final users = service.getAllUsers();

      expect(users.length, 3);

      expect(users[0].name, 'Third User');
      expect(users[1].name, 'Second User');
      expect(users[2].name, 'First User');
    });

    test('should update last online timestamp', () async {
      final service = UserService();

      await service.addUser('Test User');
      final userId = service.getAllUsers().first.id;
      final originalLastOnline = service.getUserById(userId)!.lastOnline;

      await Future.delayed(const Duration(milliseconds: 100));
      await service.updateLastOnline(userId);

      final updatedUser = service.getUserById(userId);
      expect(updatedUser!.lastOnline.isAfter(originalLastOnline), true);
    });

    test('should update user information', () async {
      final service = UserService();

      await service.addUser('Original Name');
      final user = service.getAllUsers().first;

      final updatedUser = user.copyWith(name: 'Updated Name');
      await service.updateUser(updatedUser);

      final retrieved = service.getUserById(user.id);
      expect(retrieved!.name, 'Updated Name');
    });

    test('should get chat history', () async {
      final userService = UserService();
      final chatHistory = userService.getChatHistory();

      expect(chatHistory, isEmpty);
    });
  });
}
