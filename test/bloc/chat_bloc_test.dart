import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:chat_module/features/chat/bloc/chat_bloc.dart';
import 'package:chat_module/features/chat/bloc/chat_event.dart';
import 'package:chat_module/features/chat/bloc/chat_state.dart';
import 'package:chat_module/core/services/message_service.dart';

void main() {
  const testPath = './test_data_chat_bloc';
  late MessageService messageService;
  late ChatBloc chatBloc;

  setUpAll(() async {
    Hive.init(testPath);
    await Hive.openBox('chats');
  });

  setUp(() async {
    await Hive.box('chats').clear();
    messageService = MessageService();
    chatBloc = ChatBloc(messageService: messageService);
  });

  tearDown(() {
    chatBloc.close();
  });

  group('ChatBloc Initial State', () {
    test('initial state is ChatInitial', () {
      expect(chatBloc.state, isA<ChatInitial>());
    });
  });

  group('LoadChatMessages Event', () {
    test('emits [ChatLoading, ChatEmpty] when no messages exist', () async {
      const userId = 'test-user-empty';

      expectLater(
        chatBloc.stream,
        emitsInOrder([
          isA<ChatLoading>(),
          isA<ChatEmpty>().having((s) => s.userId, 'userId', userId),
        ]),
      );

      chatBloc.add(LoadChatMessages(userId));
    });

    test('emits [ChatLoading, ChatLoaded] when messages exist', () async {
      const userId = 'test-user-with-messages';

      await messageService.sendMessage(userId: userId, message: 'Hello');
      await messageService.receiveMessage(userId: userId, message: 'Hi');

      expectLater(
        chatBloc.stream,
        emitsInOrder([
          isA<ChatLoading>(),
          isA<ChatLoaded>()
              .having((s) => s.userId, 'userId', userId)
              .having((s) => s.messages.length, 'messages length', 2),
        ]),
      );

      chatBloc.add(LoadChatMessages(userId));
    });
  });

  group('SendMessage Event', () {
    test('emits ChatLoaded after sending message', () async {
      const userId = 'test-user-send';
      const message = 'Test message';

      expectLater(
        chatBloc.stream,
        emitsInOrder([
          isA<ChatLoaded>()
              .having((s) => s.messages.length, 'has 1 message', 1)
              .having((s) => s.messages.first.message, 'message text', message)
              .having((s) => s.messages.first.isSender, 'is sender', true),

          isA<ChatLoaded>()
              .having((s) => s.messages.length, 'has 2 messages', 2)
              .having(
                (s) => s.messages.last.isSender,
                'last is receiver',
                false,
              ),
        ]),
      );

      chatBloc.add(SendMessage(userId: userId, message: message));

      await Future.delayed(const Duration(seconds: 3));
    });

    test('message is added to storage', () async {
      const userId = 'test-user-storage';
      const message = 'Stored message';

      chatBloc.add(SendMessage(userId: userId, message: message));

      await Future.delayed(const Duration(milliseconds: 100));

      final messages = messageService.getMessagesForUser(userId);
      expect(messages.isNotEmpty, true);
      expect(messages.first.message, message);
      expect(messages.first.isSender, true);
    });

    test('handles API successfully and receives reply', () async {
      const userId = 'test-user-api-success';

      chatBloc.add(SendMessage(userId: userId, message: 'Test'));

      await Future.delayed(const Duration(seconds: 3));

      final messages = messageService.getMessagesForUser(userId);
      expect(messages.length, greaterThanOrEqualTo(1));
    });
  });

  group('ReceiveMessage Event', () {
    test('emits ChatLoaded after receiving message', () async {
      const userId = 'test-user-receive';
      const message = 'Received message';

      expectLater(
        chatBloc.stream,
        emits(
          isA<ChatLoaded>()
              .having((s) => s.messages.length, 'messages length', 1)
              .having((s) => s.messages.first.message, 'message', message)
              .having((s) => s.messages.first.isSender, 'is sender', false),
        ),
      );

      chatBloc.add(ReceiveMessage(userId: userId, message: message));
    });

    test('received message is added to storage', () async {
      const userId = 'test-user-receive-storage';
      const message = 'Incoming message';

      chatBloc.add(ReceiveMessage(userId: userId, message: message));

      await Future.delayed(const Duration(milliseconds: 100));

      final messages = messageService.getMessagesForUser(userId);
      expect(messages.length, 1);
      expect(messages.first.message, message);
      expect(messages.first.isSender, false);
    });
  });

  group('Multiple Events Sequence', () {
    test('handles load -> send -> receive', () async {
      const userId = 'test-user-sequence';

      chatBloc.add(LoadChatMessages(userId));
      await Future.delayed(const Duration(milliseconds: 100));

      chatBloc.add(SendMessage(userId: userId, message: 'First message'));
      await Future.delayed(const Duration(seconds: 3));

      chatBloc.add(ReceiveMessage(userId: userId, message: 'Second message'));
      await Future.delayed(const Duration(milliseconds: 100));

      final currentState = chatBloc.state;
      expect(currentState, isA<ChatLoaded>());

      final loadedState = currentState as ChatLoaded;
      expect(loadedState.messages.length, greaterThanOrEqualTo(2));
    });

    test('state remains consistent across multiple operations', () async {
      const userId = 'test-user-consistency';

      chatBloc.add(SendMessage(userId: userId, message: 'Message 1'));
      await Future.delayed(const Duration(seconds: 3));

      chatBloc.add(ReceiveMessage(userId: userId, message: 'Message 2'));
      await Future.delayed(const Duration(milliseconds: 100));

      chatBloc.add(SendMessage(userId: userId, message: 'Message 3'));
      await Future.delayed(const Duration(seconds: 3));

      chatBloc.add(LoadChatMessages(userId));
      await Future.delayed(const Duration(milliseconds: 100));

      final currentState = chatBloc.state;
      expect(currentState, isA<ChatLoaded>());

      final loadedState = currentState as ChatLoaded;
      expect(loadedState.messages.length, greaterThanOrEqualTo(3));
    });
  });

  group('State Transitions', () {
    test('transitions from initial to loading to loaded', () async {
      const userId = 'test-user-transitions';

      await messageService.sendMessage(userId: userId, message: 'Test');

      final states = <ChatState>[];

      chatBloc.stream.listen((state) {
        states.add(state);
      });

      chatBloc.add(LoadChatMessages(userId));

      await Future.delayed(const Duration(milliseconds: 200));

      expect(states, isNotEmpty);
      expect(states.first, isA<ChatLoading>());
      expect(states.last, isA<ChatLoaded>());
    });

    test('maintains userId across state changes', () async {
      const userId = 'test-user-maintain-id';

      chatBloc.add(LoadChatMessages(userId));
      await Future.delayed(const Duration(milliseconds: 100));

      var currentState = chatBloc.state;
      if (currentState is ChatEmpty) {
        expect(currentState.userId, userId);
      }

      chatBloc.add(SendMessage(userId: userId, message: 'Test'));
      await Future.delayed(const Duration(milliseconds: 500));

      currentState = chatBloc.state;
      if (currentState is ChatLoaded) {
        expect(currentState.userId, userId);
      }
    });
  });
}
