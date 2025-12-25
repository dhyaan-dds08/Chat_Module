import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String id;
  final String name;
  final String initial;
  final DateTime lastOnline;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.initial,
    DateTime? lastOnline,
    DateTime? createdAt,
  }) : lastOnline = lastOnline ?? DateTime.now(),
       createdAt = createdAt ?? DateTime.now();

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  bool get isOnline {
    final now = DateTime.now();
    final difference = now.difference(lastOnline);
    return difference.inMinutes < 1;
  }

  String get lastSeenText {
    if (isOnline) return 'Online';

    final now = DateTime.now();
    final difference = now.difference(lastOnline);

    if (difference.inHours < 1) {
      return difference.inMinutes == 1
          ? '1 min ago'
          : '${difference.inMinutes} mins ago';
    } else if (difference.inDays < 1) {
      return difference.inHours == 1
          ? '1 hour ago'
          : '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return 'A while ago';
    }
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? initial,
    DateTime? lastOnline,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      initial: initial ?? this.initial,
      lastOnline: lastOnline ?? this.lastOnline,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  static String generateId() {
    const uuid = Uuid();
    return uuid.v4();
  }

  static String getInitial(String name) {
    return name.trim().isNotEmpty ? name.trim()[0].toUpperCase() : 'U';
  }
}
