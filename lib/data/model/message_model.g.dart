// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageModel _$MessageModelFromJson(Map<String, dynamic> json) => MessageModel(
  id: json['id'] as String,
  message: json['message'] as String,
  isSender: json['isSender'] as bool,
  timestamp: json['timestamp'] == null
      ? null
      : DateTime.parse(json['timestamp'] as String),
);

Map<String, dynamic> _$MessageModelToJson(MessageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'message': instance.message,
      'timestamp': instance.timestamp.toIso8601String(),
      'isSender': instance.isSender,
    };
