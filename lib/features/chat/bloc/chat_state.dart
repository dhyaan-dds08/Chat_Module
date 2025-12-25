import 'package:equatable/equatable.dart';
import '../../../data/model/message_model.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<MessageModel> messages;
  final String userId;

  const ChatLoaded({required this.messages, required this.userId});

  @override
  List<Object?> get props => [messages, userId];
}

class ChatEmpty extends ChatState {
  final String userId;

  const ChatEmpty(this.userId);

  @override
  List<Object?> get props => [userId];
}

class ChatError extends ChatState {
  final String message;

  const ChatError(this.message);

  @override
  List<Object?> get props => [message];
}

class MessageSending extends ChatState {
  final List<MessageModel> messages;

  const MessageSending(this.messages);

  @override
  List<Object?> get props => [messages];
}
