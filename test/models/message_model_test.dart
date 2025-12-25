import 'package:chat_module/data/model/message_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MessageModel Tests', () {
    test('should create sent message correctly', () {
      final message = MessageModel.createSentMessage('Hello');

      expect(message.message, 'Hello');
      expect(message.isSender, true);
      expect(message.id, isNotEmpty);
      expect(message.timestamp, isNotNull);
    });

    test('should create received message correctly', () {
      final message = MessageModel.createReceivedMessage('Hi there');

      expect(message.message, 'Hi there');
      expect(message.isSender, false);
      expect(message.id, isNotEmpty);
      expect(message.timestamp, isNotNull);
    });

    test('should generate unique IDs for messages', () {
      final message1 = MessageModel.createSentMessage('First');
      final message2 = MessageModel.createSentMessage('Second');

      expect(message1.id, isNot(equals(message2.id)));
    });

    test('should serialize to JSON correctly', () {
      final message = MessageModel.createSentMessage('Test message');
      final json = message.toJson();

      expect(json['id'], message.id);
      expect(json['message'], 'Test message');
      expect(json['isSender'], true);
      expect(json['timestamp'], isNotNull);
    });

    test('should deserialize from JSON correctly', () {
      final now = DateTime.now();
      final json = {
        'id': 'test-id',
        'message': 'Test message',
        'timestamp': now.toIso8601String(),
        'isSender': true,
      };

      final message = MessageModel.fromJson(json);

      expect(message.id, 'test-id');
      expect(message.message, 'Test message');
      expect(message.isSender, true);
    });
  });
}
