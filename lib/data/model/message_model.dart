import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'message_model.g.dart';

@JsonSerializable()
class MessageModel {
  final String id;
  final String message;
  final DateTime timestamp;
  final bool isSender;

  MessageModel({
    required this.id,
    required this.message,
    required this.isSender,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessageModelToJson(this);

  static String generateId() {
    const uuid = Uuid();
    return uuid.v4();
  }

  static MessageModel createSentMessage(String message) {
    return MessageModel(id: generateId(), message: message, isSender: true);
  }

  static MessageModel createReceivedMessage(String message) {
    return MessageModel(id: generateId(), message: message, isSender: false);
  }
}
