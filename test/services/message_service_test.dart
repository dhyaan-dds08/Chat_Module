import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:chat_module/core/services/message_service.dart';

void main() {
  const testPath = './test_data_message_service';

  setUpAll(() async {
    Hive.init(testPath);
    await Hive.openBox('chats');
  });

  setUp(() async {
    await Hive.box('chats').clear();
  });

  tearDownAll(() async {
    if (Hive.isBoxOpen('chats')) await Hive.box('chats').close();
    await Hive.deleteFromDisk();
  });

  group('MessageService CRUD Tests', () {
    const testUserId = 'test-user-id';

    test('should get empty list for user with no messages', () {
      final service = MessageService();
      final messages = service.getMessagesForUser(testUserId);
      expect(messages, isEmpty);
    });

    test('should send message successfully', () async {
      final service = MessageService();

      await service.sendMessage(userId: testUserId, message: 'Hello');
      final messages = service.getMessagesForUser(testUserId);

      expect(messages.length, 1);
      expect(messages.first.message, 'Hello');
      expect(messages.first.isSender, true);
    });

    test('should receive message successfully', () async {
      final service = MessageService();

      await service.receiveMessage(userId: testUserId, message: 'Reply');
      final messages = service.getMessagesForUser(testUserId);

      expect(messages.length, 1);
      expect(messages.first.message, 'Reply');
      expect(messages.first.isSender, false);
    });

    test('should maintain message order', () async {
      final service = MessageService();

      await service.sendMessage(userId: testUserId, message: 'First');
      await service.receiveMessage(userId: testUserId, message: 'Second');
      await service.sendMessage(userId: testUserId, message: 'Third');

      final messages = service.getMessagesForUser(testUserId);

      expect(messages.length, 3);
      expect(messages[0].message, 'First');
      expect(messages[1].message, 'Second');
      expect(messages[2].message, 'Third');
    });

    test('should get last message correctly', () async {
      final service = MessageService();

      await service.sendMessage(userId: testUserId, message: 'First');
      await service.sendMessage(userId: testUserId, message: 'Last');

      final lastMessage = service.getLastMessage(testUserId);

      expect(lastMessage, isNotNull);
      expect(lastMessage!.message, 'Last');
    });

    test('should return null for user with no messages', () {
      final service = MessageService();
      final lastMessage = service.getLastMessage('no-messages-user');
      expect(lastMessage, isNull);
    });

    test('should get all chat user IDs', () async {
      final service = MessageService();

      await service.sendMessage(userId: 'user1', message: 'Hello');
      await service.sendMessage(userId: 'user2', message: 'Hi');

      final userIds = service.getAllChatUserIds();

      expect(userIds.length, 2);
      expect(userIds, contains('user1'));
      expect(userIds, contains('user2'));
    });

    test('should check if user has messages', () async {
      final service = MessageService();

      expect(service.hasMessages(testUserId), false);

      await service.sendMessage(userId: testUserId, message: 'Test');

      expect(service.hasMessages(testUserId), true);
    });
  });
}
