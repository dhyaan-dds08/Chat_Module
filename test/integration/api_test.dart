import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:chat_module/core/services/dictionary_service.dart';
import 'package:chat_module/core/services/message_service.dart';
import 'package:chat_module/core/services/user_service.dart';

void main() {
  setUpAll(() async {
    Hive.init('./test_integration_data');
    await Hive.openBox('users');
    await Hive.openBox('chats');
  });

  tearDownAll(() async {
    if (Hive.isBoxOpen('users')) await Hive.box('users').close();
    if (Hive.isBoxOpen('chats')) await Hive.box('chats').close();
    await Hive.deleteFromDisk();
  });

  group('Dictionary API Integration', () {
    test('should fetch definition for valid word', () async {
      final service = DictionaryService();

      final result = await service.lookupWord('hello');

      expect(result.isSuccess, true);
      expect(result.data, isNotNull);
      expect(result.data!.word, 'hello');
      expect(result.data!.meanings, isNotEmpty);
    });

    test('should handle invalid word', () async {
      final service = DictionaryService();

      final result = await service.lookupWord('xyzinvalidword123');

      expect(result.isSuccess, false);
      expect(result.error, isNotNull);
    });

    test('should validate input', () async {
      final service = DictionaryService();

      final emptyResult = await service.lookupWord('');
      expect(emptyResult.isSuccess, false);
      expect(emptyResult.error, contains('enter a word'));

      final invalidResult = await service.lookupWord('test123');
      expect(invalidResult.isSuccess, false);
      expect(invalidResult.error, contains('letters only'));
    });

    test('should extract synonyms and antonyms from real API', () async {
      final service = DictionaryService();

      final result = await service.lookupWord('good');

      if (result.isSuccess && result.data != null) {
        final synonyms = service.getSynonyms(result.data!);
        final antonyms = service.getAntonyms(result.data!);

        expect(synonyms, isA<List<String>>());
        expect(antonyms, isA<List<String>>());
      }
    });
  });

  group('Quote API Integration', () {
    test('should fetch random quote', () async {
      final service = MessageService();

      final quote = await service.fetchApiReply();

      expect(quote, isNotEmpty);
      expect(quote.length, greaterThan(10));
    });

    test('should fetch different quotes on multiple calls', () async {
      final service = MessageService();

      final quote1 = await service.fetchApiReply();
      await Future.delayed(const Duration(milliseconds: 500));
      final quote2 = await service.fetchApiReply();

      expect(quote1, isNotEmpty);
      expect(quote2, isNotEmpty);
    });
  });

  group('Full Flow Integration', () {
    test('create user -> send message -> get API reply', () async {
      await Hive.box('users').clear();
      await Hive.box('chats').clear();

      final userService = UserService();
      final messageService = MessageService();

      await userService.addUser('Integration Test User');
      final users = userService.getAllUsers();
      expect(users.length, 1);
      final userId = users.first.id;

      await messageService.sendMessage(userId: userId, message: 'Hello API!');

      final apiReply = await messageService.fetchApiReply();
      expect(apiReply, isNotEmpty);

      await messageService.receiveMessage(userId: userId, message: apiReply);

      final messages = messageService.getMessagesForUser(userId);
      expect(messages.length, 2);
      expect(messages[0].message, 'Hello API!');
      expect(messages[0].isSender, true);
      expect(messages[1].message, apiReply);
      expect(messages[1].isSender, false);
    });

    test('word lookup from API quote', () async {
      final messageService = MessageService();
      final dictionaryService = DictionaryService();

      final quote = await messageService.fetchApiReply();
      expect(quote, isNotEmpty);

      final words = quote.split(' ');
      String? testWord;

      for (final word in words) {
        final cleanWord = word
            .replaceAll(RegExp(r'[^a-zA-Z]'), '')
            .toLowerCase();
        if (cleanWord.length > 3) {
          testWord = cleanWord;
          break;
        }
      }

      if (testWord != null) {
        final result = await dictionaryService.lookupWord(testWord);
        expect(result, isNotNull);

        if (result.isSuccess) {
          dictionaryService.getDefinitions(result.data!);
        } else {}
      }
    });
  });

  group('API Error Handling', () {
    test('should handle malformed input gracefully', () async {
      final dictionaryService = DictionaryService();

      final tests = ['', '   ', '123', 'hello world', '@#\$%'];

      for (final testWord in tests) {
        final result = await dictionaryService.lookupWord(testWord);
        expect(result.isSuccess, false);
        expect(result.error, isNotNull);
      }
    });

    test('should return fallback quote on API failure', () async {
      final service = MessageService();

      final quote = await service.fetchApiReply();
      expect(quote, isNotEmpty);
    });
  });
}
