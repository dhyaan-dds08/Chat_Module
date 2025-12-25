import 'package:flutter_test/flutter_test.dart';
import 'package:chat_module/data/model/quote_model.dart';

void main() {
  group('QuoteModel Tests', () {
    test('should deserialize from API response correctly', () {
      final json = {
        'id': 62,
        'quote':
            'It Is Always Consoling To Think Of Suicide: In That Way One Gets Through Many A Bad Night.',
        'author': 'Friedrich Nietzsche',
      };

      final quote = QuoteModel.fromJson(json);

      expect(quote.id, 62);
      expect(
        quote.quote,
        'It Is Always Consoling To Think Of Suicide: In That Way One Gets Through Many A Bad Night.',
      );
      expect(quote.author, 'Friedrich Nietzsche');
    });

    test('should serialize to JSON correctly', () {
      final quote = QuoteModel(
        id: 1,
        quote: 'Test quote',
        author: 'Author Name',
      );

      final json = quote.toJson();

      expect(json['id'], 1);
      expect(json['quote'], 'Test quote');
      expect(json['author'], 'Author Name');
    });

    test('should handle different id types', () {
      final json = {
        'id': 999,
        'quote': 'Another quote',
        'author': 'Another Author',
      };

      final quote = QuoteModel.fromJson(json);

      expect(quote.id, 999);
      expect(quote.quote, 'Another quote');
      expect(quote.author, 'Another Author');
    });

    test('should create model correctly', () {
      final quote = QuoteModel(
        id: 42,
        quote: 'Life is beautiful',
        author: 'Anonymous',
      );

      expect(quote.id, 42);
      expect(quote.quote, 'Life is beautiful');
      expect(quote.author, 'Anonymous');
    });

    test('should convert toString correctly', () {
      final quote = QuoteModel(id: 1, quote: 'Test', author: 'Tester');

      final string = quote.toString();

      expect(string, contains('id: 1'));
      expect(string, contains('quote: "Test"'));
      expect(string, contains('author: Tester'));
    });
  });
}
