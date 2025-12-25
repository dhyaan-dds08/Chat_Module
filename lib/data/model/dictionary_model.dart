import 'package:json_annotation/json_annotation.dart';

part 'dictionary_model.g.dart';

@JsonSerializable()
class DictionaryResponse {
  final String word;
  final String? phonetic;
  final List<Phonetic> phonetics;
  final List<Meaning> meanings;
  final License? license;
  final List<String> sourceUrls;

  DictionaryResponse({
    required this.word,
    this.phonetic,
    required this.phonetics,
    required this.meanings,
    this.license,
    required this.sourceUrls,
  });

  factory DictionaryResponse.fromJson(Map<String, dynamic> json) =>
      _$DictionaryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DictionaryResponseToJson(this);
}

@JsonSerializable()
class Phonetic {
  final String? text;
  final String? audio;
  final String? sourceUrl;
  final License? license;

  Phonetic({this.text, this.audio, this.sourceUrl, this.license});

  factory Phonetic.fromJson(Map<String, dynamic> json) =>
      _$PhoneticFromJson(json);

  Map<String, dynamic> toJson() => _$PhoneticToJson(this);
}

@JsonSerializable()
class Meaning {
  final String partOfSpeech;
  final List<Definition> definitions;
  final List<String> synonyms;
  final List<String> antonyms;

  Meaning({
    required this.partOfSpeech,
    required this.definitions,
    required this.synonyms,
    required this.antonyms,
  });

  factory Meaning.fromJson(Map<String, dynamic> json) =>
      _$MeaningFromJson(json);

  Map<String, dynamic> toJson() => _$MeaningToJson(this);
}

@JsonSerializable()
class Definition {
  final String definition;
  final List<String> synonyms;
  final List<String> antonyms;
  final String? example;

  Definition({
    required this.definition,
    required this.synonyms,
    required this.antonyms,
    this.example,
  });

  factory Definition.fromJson(Map<String, dynamic> json) =>
      _$DefinitionFromJson(json);

  Map<String, dynamic> toJson() => _$DefinitionToJson(this);
}

@JsonSerializable()
class License {
  final String name;
  final String url;

  License({required this.name, required this.url});

  factory License.fromJson(Map<String, dynamic> json) =>
      _$LicenseFromJson(json);

  Map<String, dynamic> toJson() => _$LicenseToJson(this);
}
