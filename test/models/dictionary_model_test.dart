import 'package:flutter_test/flutter_test.dart';
import 'package:chat_module/data/model/dictionary_model.dart';

void main() {
  group('DictionaryModel Tests', () {
    test('should deserialize full response correctly', () {
      final json = {
        'word': 'test',
        'phonetic': '/test/',
        'phonetics': [
          {'text': '/test/', 'audio': 'https://example.com/audio.mp3'},
        ],
        'meanings': [
          {
            'partOfSpeech': 'noun',
            'definitions': [
              {
                'definition': 'A procedure to establish quality',
                'synonyms': ['trial', 'examination'],
                'antonyms': [],
                'example': 'This is a test',
              },
            ],
            'synonyms': ['trial'],
            'antonyms': [],
          },
        ],
        'sourceUrls': ['https://example.com'],
      };

      final response = DictionaryResponse.fromJson(json);

      expect(response.word, 'test');
      expect(response.phonetic, '/test/');
      expect(response.meanings.length, 1);
      expect(response.meanings.first.partOfSpeech, 'noun');
      expect(response.meanings.first.definitions.length, 1);
    });

    test('should serialize to JSON correctly', () {
      final response = DictionaryResponse(
        word: 'test',
        phonetic: '/test/',
        phonetics: [],
        meanings: [
          Meaning(
            partOfSpeech: 'noun',
            definitions: [
              Definition(
                definition: 'A test definition',
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

      final json = response.toJson();

      expect(json['word'], 'test');
      expect(json['phonetic'], '/test/');
      expect(json['meanings'], isList);
    });

    test('should handle missing phonetic', () {
      final json = {
        'word': 'test',
        'phonetics': [],
        'meanings': [],
        'sourceUrls': [],
      };

      final response = DictionaryResponse.fromJson(json);

      expect(response.word, 'test');
      expect(response.phonetic, isNull);
    });
  });

  group('Definition Tests', () {
    test('should deserialize definition correctly', () {
      final json = {
        'definition': 'Test definition',
        'synonyms': ['synonym1'],
        'antonyms': ['antonym1'],
        'example': 'Example sentence',
      };

      final definition = Definition.fromJson(json);

      expect(definition.definition, 'Test definition');
      expect(definition.synonyms.length, 1);
      expect(definition.antonyms.length, 1);
      expect(definition.example, 'Example sentence');
    });
  });
}
