import 'user_model.dart';
import 'message_model.dart';

class ChatHistoryItem {
  final UserModel user;
  final MessageModel? lastMessage;
  final int unreadCount;

  ChatHistoryItem({required this.user, this.lastMessage, this.unreadCount = 0});

  DateTime get timestamp {
    return lastMessage?.timestamp ?? user.createdAt;
  }

  String get timeText {
    if (lastMessage == null) return '';

    final now = DateTime.now();
    final difference = now.difference(lastMessage!.timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return difference.inMinutes == 1
          ? '1 min ago'
          : '${difference.inMinutes} mins ago';
    } else if (difference.inDays < 1) {
      return difference.inHours == 1
          ? '1 hour ago'
          : '${difference.inHours} hours ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return 'A while ago';
    }
  }
}
