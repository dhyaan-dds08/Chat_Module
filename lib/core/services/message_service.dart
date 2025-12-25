import 'package:chat_module/core/dio/api_client.dart';
import 'package:chat_module/data/model/message_model.dart';
import 'package:chat_module/data/model/quote_model.dart';
import 'package:dio/dio.dart';
import 'package:hive_ce/hive.dart';

import '../config/constants/api_url.dart';
import '../dio/dio_error.dart';

class MessageService {
  static const String _boxName = 'chats';

  Box get _box => Hive.box(_boxName);

  List<MessageModel> getMessagesForUser(String userId) {
    try {
      final messagesData = _box.get(userId);
      if (messagesData == null) return [];

      final messagesList = (messagesData as List)
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList();

      return messagesList.map((json) => MessageModel.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<String> fetchApiReply() async {
    try {
      final client = await ApiClient.getApiClient();
      final response = await client.get(ApiUrl.randomReply);

      if (response.statusCode == 200) {
        final quote = QuoteModel.fromJson(response.data);
        return quote.quote;
      } else {
        throw Exception('Failed to load reply: ${response.statusCode}');
      }
    } on DioException catch (e) {
      DioErrorHandler.handleError(e);

      return _getFallbackMessage();
    } catch (e) {
      return _getFallbackMessage();
    }
  }

  String _getFallbackMessage() {
    final fallbackMessages = [
      'Hey there!',
      'How are you doing?',
      'That\'s interesting!',
      'Tell me more!',
      'I see what you mean.',
    ];
    fallbackMessages.shuffle();
    return fallbackMessages.first;
  }

  Future<void> sendMessage({
    required String userId,
    required String message,
  }) async {
    try {
      final messages = getMessagesForUser(userId);
      messages.add(MessageModel.createSentMessage(message));

      await _box.put(userId, messages.map((m) => m.toJson()).toList());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> receiveMessage({
    required String userId,
    required String message,
  }) async {
    try {
      final messages = getMessagesForUser(userId);
      messages.add(MessageModel.createReceivedMessage(message));

      await _box.put(userId, messages.map((m) => m.toJson()).toList());
    } catch (e) {
      rethrow;
    }
  }

  MessageModel? getLastMessage(String userId) {
    try {
      final messages = getMessagesForUser(userId);
      if (messages.isEmpty) return null;
      return messages.last;
    } catch (e) {
      return null;
    }
  }

  List<String> getAllChatUserIds() {
    return _box.keys.cast<String>().toList();
  }

  bool hasMessages(String userId) {
    return _box.containsKey(userId);
  }

  MessageModel? getMessageById(String userId, String messageId) {
    try {
      final messages = getMessagesForUser(userId);
      return messages.firstWhere(
        (msg) => msg.id == messageId,
        orElse: () => throw Exception('Message not found'),
      );
    } catch (e) {
      return null;
    }
  }
}
