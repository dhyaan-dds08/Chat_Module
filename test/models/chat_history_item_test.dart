import 'package:flutter_test/flutter_test.dart';
import 'package:chat_module/data/model/chat_history_item.dart';
import 'package:chat_module/data/model/user_model.dart';
import 'package:chat_module/data/model/message_model.dart';

void main() {
  group('ChatHistoryItem Tests', () {
    test('should create chat history item correctly', () {
      final user = UserModel(id: '1', name: 'Test User', initial: 'T');
      final message = MessageModel.createSentMessage('Last message');

      final chatItem = ChatHistoryItem(
        user: user,
        lastMessage: message,
        unreadCount: 3,
      );

      expect(chatItem.user.name, 'Test User');
      expect(chatItem.lastMessage?.message, 'Last message');
      expect(chatItem.unreadCount, 3);
      expect(chatItem.timestamp, message.timestamp);
    });

    test('should use message timestamp', () {
      final user = UserModel(id: '1', name: 'Test', initial: 'T');
      final message = MessageModel.createSentMessage('Test');

      final chatItem = ChatHistoryItem(user: user, lastMessage: message);

      expect(chatItem.timestamp, equals(message.timestamp));
    });

    test('should handle zero unread count', () {
      final user = UserModel(id: '1', name: 'Test', initial: 'T');
      final message = MessageModel.createSentMessage('Test');

      final chatItem = ChatHistoryItem(
        user: user,
        lastMessage: message,
        unreadCount: 0,
      );

      expect(chatItem.unreadCount, 0);
    });
  });
}
