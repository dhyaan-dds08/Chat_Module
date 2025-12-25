import 'package:chat_module/core/dio/dio_error.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/message_service.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final MessageService _messageService;

  ChatBloc({required MessageService messageService})
    : _messageService = messageService,
      super(ChatInitial()) {
    on<LoadChatMessages>(_onLoadChatMessages);
    on<SendMessage>(_onSendMessage);
    on<ReceiveMessage>(_onReceiveMessage);
    on<DeleteMessage>(_onDeleteMessage);
  }

  Future<void> _onLoadChatMessages(
    LoadChatMessages event,
    Emitter<ChatState> emit,
  ) async {
    try {
      emit(ChatLoading());

      final messages = _messageService.getMessagesForUser(event.userId);

      if (messages.isEmpty) {
        emit(ChatEmpty(event.userId));
      } else {
        emit(ChatLoaded(messages: messages, userId: event.userId));
      }
    } catch (e) {
      emit(ChatError('Failed to load messages: ${e.toString()}'));
    }
  }

  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<ChatState> emit,
  ) async {
    try {
      await _messageService.sendMessage(
        userId: event.userId,
        message: event.message,
      );

      final updatedMessages = _messageService.getMessagesForUser(event.userId);
      emit(ChatLoaded(messages: updatedMessages, userId: event.userId));

      try {
        final apiMessage = await _messageService.fetchApiReply();
        await Future.delayed(const Duration(milliseconds: 500));

        await _messageService.receiveMessage(
          userId: event.userId,
          message: apiMessage,
        );

        final finalMessages = _messageService.getMessagesForUser(event.userId);
        emit(ChatLoaded(messages: finalMessages, userId: event.userId));
      } on DioException catch (e) {
        final errorMessage = DioErrorHandler.handleError(e);
        emit(ChatError('API Error: $errorMessage'));
      } catch (e) {
        emit(ChatError('Failed to fetch API reply'));
      }
    } catch (e) {
      emit(ChatError('Failed to send message: ${e.toString()}'));
    }
  }

  Future<void> _onReceiveMessage(
    ReceiveMessage event,
    Emitter<ChatState> emit,
  ) async {
    try {
      await _messageService.receiveMessage(
        userId: event.userId,
        message: event.message,
      );

      final updatedMessages = _messageService.getMessagesForUser(event.userId);
      emit(ChatLoaded(messages: updatedMessages, userId: event.userId));
    } catch (e) {
      emit(ChatError('Failed to receive message: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteMessage(
    DeleteMessage event,
    Emitter<ChatState> emit,
  ) async {
    try {
      await _messageService.deleteMessage(event.userId, event.messageId);

      final updatedMessages = _messageService.getMessagesForUser(event.userId);

      if (updatedMessages.isEmpty) {
        emit(ChatEmpty(event.userId));
      } else {
        emit(ChatLoaded(messages: updatedMessages, userId: event.userId));
      }
    } catch (e) {
      emit(ChatError('Failed to delete message: ${e.toString()}'));
    }
  }
}
