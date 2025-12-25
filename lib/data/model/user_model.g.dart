// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: json['id'] as String,
  name: json['name'] as String,
  initial: json['initial'] as String,
  lastOnline: json['lastOnline'] == null
      ? null
      : DateTime.parse(json['lastOnline'] as String),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'initial': instance.initial,
  'lastOnline': instance.lastOnline.toIso8601String(),
  'createdAt': instance.createdAt.toIso8601String(),
};
