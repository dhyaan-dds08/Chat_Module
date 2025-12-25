import 'package:flutter_test/flutter_test.dart';
import 'package:chat_module/core/services/dictionary_service.dart';
import 'package:chat_module/data/model/dictionary_model.dart';

void main() {
  group('DictionaryService Validation Tests', () {
    test('should return error for empty word', () async {
      final service = DictionaryService();

      final result = await service.lookupWord('');

      expect(result.isSuccess, false);
      expect(result.error, contains('enter a word'));
    });

    test('should return error for invalid characters', () async {
      final service = DictionaryService();

      final result = await service.lookupWord('test123');

      expect(result.isSuccess, false);
      expect(result.error, contains('letters only'));
    });

    test('should return error for word with spaces', () async {
      final service = DictionaryService();

      final result = await service.lookupWord('hello world');

      expect(result.isSuccess, false);
      expect(result.error, contains('letters only'));
    });
  });

  group('DictionaryService Helper Methods Tests', () {
    test('getDefinitions should extract definitions correctly', () {
      final service = DictionaryService();
      final mockResponse = DictionaryResponse(
        word: 'test',
        phonetics: [],
        meanings: [
          Meaning(
            partOfSpeech: 'noun',
            definitions: [
              Definition(
                definition: 'First definition',
                synonyms: [],
                antonyms: [],
              ),
              Definition(
                definition: 'Second definition',
                synonyms: [],
                antonyms: [],
              ),
            ],
            synonyms: [],
            antonyms: [],
          ),
        ],
        sourceUrls: [],
      );

      final definitions = service.getDefinitions(mockResponse, limit: 3);

      expect(definitions.length, 2);
      expect(definitions[0], 'First definition');
      expect(definitions[1], 'Second definition');
    });

    test('getExample should extract example correctly', () {
      final service = DictionaryService();
      final mockResponse = DictionaryResponse(
        word: 'test',
        phonetics: [],
        meanings: [
          Meaning(
            partOfSpeech: 'noun',
            definitions: [
              Definition(
                definition: 'A definition',
                synonyms: [],
                antonyms: [],
                example: 'This is an example',
              ),
            ],
            synonyms: [],
            antonyms: [],
          ),
        ],
        sourceUrls: [],
      );

      final example = service.getExample(mockResponse);

      expect(example, 'This is an example');
    });

    test('getSynonyms should extract synonyms correctly', () {
      final service = DictionaryService();
      final mockResponse = DictionaryResponse(
        word: 'test',
        phonetics: [],
        meanings: [
          Meaning(
            partOfSpeech: 'noun',
            definitions: [
              Definition(
                definition: 'A definition',
                synonyms: ['synonym1', 'synonym2'],
                antonyms: [],
              ),
            ],
            synonyms: ['synonym3'],
            antonyms: [],
          ),
        ],
        sourceUrls: [],
      );

      final synonyms = service.getSynonyms(mockResponse, limit: 5);

      expect(synonyms.length, 3);
      expect(synonyms, contains('synonym1'));
      expect(synonyms, contains('synonym2'));
      expect(synonyms, contains('synonym3'));
    });

    test('getAntonyms should extract antonyms correctly', () {
      final service = DictionaryService();
      final mockResponse = DictionaryResponse(
        word: 'test',
        phonetics: [],
        meanings: [
          Meaning(
            partOfSpeech: 'adjective',
            definitions: [
              Definition(
                definition: 'A definition',
                synonyms: [],
                antonyms: ['antonym1'],
              ),
            ],
            synonyms: [],
            antonyms: ['antonym2'],
          ),
        ],
        sourceUrls: [],
      );

      final antonyms = service.getAntonyms(mockResponse, limit: 5);

      expect(antonyms.length, 2);
      expect(antonyms, contains('antonym1'));
      expect(antonyms, contains('antonym2'));
    });
  });
}
