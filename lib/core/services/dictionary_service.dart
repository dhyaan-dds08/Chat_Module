import 'package:chat_module/core/config/constants/api_url.dart';
import 'package:dio/dio.dart';
import '../../data/model/dictionary_model.dart';
import '../dio/api_client.dart';
import '../dio/dio_error.dart';
import '../utils/result.dart';

class DictionaryService {
  Future<Result<DictionaryResponse>> lookupWord(String word) async {
    try {
      final cleanWord = word.trim().toLowerCase();

      if (cleanWord.isEmpty) {
        return Result.error('Please enter a word to look up');
      }

      if (!RegExp(r'^[a-zA-Z]+$').hasMatch(cleanWord)) {
        return Result.error('Please enter a valid word (letters only)');
      }

      final client = await ApiClient.getApiClient();
      final response = await client.get('${ApiUrl.dictionaryBase}$cleanWord');

      if (response.statusCode == 200) {
        if (response.data is! List) {
          return Result.error('Invalid response format from dictionary API');
        }

        final List<dynamic> data = response.data;

        if (data.isEmpty) {
          return Result.error('No definition found for "$cleanWord"');
        }

        try {
          final dictionaryData = DictionaryResponse.fromJson(
            data[0] as Map<String, dynamic>,
          );
          return Result.success(dictionaryData);
        } catch (parseError) {
          return Result.error('Failed to parse dictionary data');
        }
      } else {
        return Result.error(
          'Dictionary API returned error: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return Result.error('No definition found for "$word"');
      }

      final errorMessage = DioErrorHandler.handleError(e);
      return Result.error(errorMessage);
    } catch (e) {
      return Result.error('An unexpected error occurred: ${e.toString()}');
    }
  }

  List<String> getDefinitions(DictionaryResponse response, {int limit = 3}) {
    final definitions = <String>[];
    try {
      for (final meaning in response.meanings) {
        for (final def in meaning.definitions) {
          if (definitions.length < limit) {
            definitions.add(def.definition);
          }
        }
      }

      return definitions.isNotEmpty ? definitions : ['No definition available'];
    } catch (e) {
      return ['No definition available'];
    }
  }

  String? getExample(DictionaryResponse response) {
    try {
      for (final meaning in response.meanings) {
        for (final def in meaning.definitions) {
          if (def.example != null && def.example!.trim().isNotEmpty) {
            return def.example;
          }
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  String getFirstDefinition(DictionaryResponse response) {
    try {
      if (response.meanings.isNotEmpty) {
        final meaning = response.meanings.first;
        if (meaning.definitions.isNotEmpty) {
          return meaning.definitions.first.definition;
        }
      }
      return 'No definition found';
    } catch (e) {
      return 'No definition found';
    }
  }

  String? getAudioUrl(DictionaryResponse response) {
    try {
      for (final phonetic in response.phonetics) {
        if (phonetic.audio != null && phonetic.audio!.isNotEmpty) {
          return phonetic.audio;
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  List<String> getSynonyms(DictionaryResponse response, {int limit = 5}) {
    final synonyms = <String>{};
    try {
      for (final meaning in response.meanings) {
        synonyms.addAll(meaning.synonyms);
        for (final def in meaning.definitions) {
          synonyms.addAll(def.synonyms);
        }
      }
      return synonyms.take(limit).toList();
    } catch (e) {
      return [];
    }
  }

  List<String> getAntonyms(DictionaryResponse response, {int limit = 5}) {
    final antonyms = <String>{};
    try {
      for (final meaning in response.meanings) {
        antonyms.addAll(meaning.antonyms);
        for (final def in meaning.definitions) {
          antonyms.addAll(def.antonyms);
        }
      }
      return antonyms.take(limit).toList();
    } catch (e) {
      return [];
    }
  }
}
