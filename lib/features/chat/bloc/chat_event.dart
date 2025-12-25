import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class LoadChatMessages extends ChatEvent {
  final String userId;

  const LoadChatMessages(this.userId);

  @override
  List<Object?> get props => [userId];
}

class SendMessage extends ChatEvent {
  final String userId;
  final String message;

  const SendMessage({required this.userId, required this.message});

  @override
  List<Object?> get props => [userId, message];
}

class ReceiveMessage extends ChatEvent {
  final String userId;
  final String message;

  const ReceiveMessage({required this.userId, required this.message});

  @override
  List<Object?> get props => [userId, message];
}
