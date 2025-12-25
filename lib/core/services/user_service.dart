import 'dart:math';

import 'package:chat_module/data/model/user_model.dart';
import 'package:hive_ce/hive.dart';

import '../../data/model/chat_history_item.dart';
import 'message_service.dart';

class UserService {
  static const String _boxName = 'users';

  Box get _box => Hive.box(_boxName);

  List<UserModel> getAllUsers() {
    try {
      final usersMap = _box.toMap();
      final users = usersMap.values
          .map((json) => UserModel.fromJson(Map<String, dynamic>.from(json)))
          .toList();

      users.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return users;
    } catch (e) {
      return [];
    }
  }

  Future<void> addUser(String name) async {
    try {
      final user = UserModel(
        id: UserModel.generateId(),
        name: name,
        initial: UserModel.getInitial(name),
      );
      await _box.put(user.id, user.toJson());
    } catch (e) {
      rethrow;
    }
  }

  UserModel? getUserById(String id) {
    try {
      final json = _box.get(id);
      if (json == null) return null;
      return UserModel.fromJson(Map<String, dynamic>.from(json));
    } catch (e) {
      return null;
    }
  }

  Future<void> updateLastOnline(String userId) async {
    try {
      final user = getUserById(userId);
      if (user != null) {
        final updatedUser = user.copyWith(lastOnline: DateTime.now());
        await updateUser(updatedUser);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      await _box.put(user.id, user.toJson());
    } catch (e) {
      rethrow;
    }
  }

  List<ChatHistoryItem> getChatHistory() {
    try {
      final messageService = MessageService();
      final userIdsWithChats = messageService.getAllChatUserIds();
      final random = Random();
      if (userIdsWithChats.isEmpty) return [];

      final chatHistory = <ChatHistoryItem>[];

      for (final userId in userIdsWithChats) {
        final user = getUserById(userId);
        if (user != null) {
          final lastMessage = messageService.getLastMessage(userId);
          chatHistory.add(
            ChatHistoryItem(
              user: user,
              lastMessage: lastMessage,
              unreadCount: random.nextInt(3),
            ),
          );
        }
      }

      chatHistory.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      return chatHistory;
    } catch (e) {
      return [];
    }
  }
}
