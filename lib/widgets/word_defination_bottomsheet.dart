import 'package:flutter/material.dart';

import '../core/config/app_config.dart';
import '../core/services/dictionary_service.dart';
import '../data/model/dictionary_model.dart';

class WordDefinitionSheet extends StatefulWidget {
  final String word;

  const WordDefinitionSheet({super.key, required this.word});

  @override
  State<WordDefinitionSheet> createState() => _WordDefinitionSheetState();
}

class _WordDefinitionSheetState extends State<WordDefinitionSheet> {
  final DictionaryService _dictionaryService = DictionaryService();

  final ValueNotifier<bool> _isLoading = ValueNotifier(true);
  final ValueNotifier<DictionaryResponse?> _response = ValueNotifier(null);
  final ValueNotifier<String?> _errorMessage = ValueNotifier(null);

  late AppConfig config;

  @override
  void initState() {
    super.initState();
    _fetchDefinition();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    config = AppConfig(context);
  }

  @override
  void dispose() {
    _isLoading.dispose();
    _response.dispose();
    _errorMessage.dispose();
    super.dispose();
  }

  Future<void> _fetchDefinition() async {
    _isLoading.value = true;
    _errorMessage.value = null;

    final result = await _dictionaryService.lookupWord(widget.word);

    _isLoading.value = false;

    if (result.isSuccess) {
      _response.value = result.data;
      _errorMessage.value = null;
    } else {
      _response.value = null;
      _errorMessage.value = result.error ?? 'Unknown error occurred';
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          padding: EdgeInsets.all(AppConfig.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: EdgeInsets.only(bottom: AppConfig.mediumSpacing),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurfaceVariant.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.word,
                      style: config.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),

              SizedBox(height: AppConfig.mediumSpacing),

              ValueListenableBuilder<bool>(
                valueListenable: _isLoading,
                builder: (context, isLoading, child) {
                  if (isLoading) {
                    return Column(
                      children: [
                        SizedBox(height: config.h(10)),
                        const Center(child: CircularProgressIndicator()),
                        SizedBox(height: AppConfig.mediumSpacing),
                        Center(
                          child: Text(
                            'Looking up definition...',
                            style: config.bodyMedium,
                          ),
                        ),
                        SizedBox(height: config.h(10)),
                      ],
                    );
                  }

                  return ValueListenableBuilder<String?>(
                    valueListenable: _errorMessage,
                    builder: (context, errorMessage, child) {
                      if (errorMessage != null) {
                        return Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.search_off,
                                size: config.h(8),
                                color: Theme.of(context).colorScheme.error,
                              ),
                              SizedBox(height: AppConfig.mediumSpacing),
                              Text(
                                'No definition found',
                                style: config.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: AppConfig.smallSpacing),
                              Text(
                                errorMessage,
                                style: config.bodySmall?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: AppConfig.mediumSpacing),
                              FilledButton(
                                onPressed: _fetchDefinition,
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        );
                      }

                      return ValueListenableBuilder<DictionaryResponse?>(
                        valueListenable: _response,
                        builder: (context, response, child) {
                          if (response != null) {
                            return _buildDefinitionContent(response);
                          }
                          return const SizedBox.shrink();
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDefinitionContent(DictionaryResponse response) {
    final definitions = _dictionaryService.getDefinitions(response, limit: 3);
    final example = _dictionaryService.getExample(response);
    final synonyms = _dictionaryService.getSynonyms(response, limit: 5);
    final antonyms = _dictionaryService.getAntonyms(response, limit: 5);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (response.phonetic != null) ...[
          Text(
            response.phonetic!,
            style: config.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontStyle: FontStyle.italic,
            ),
          ),
          SizedBox(height: AppConfig.smallSpacing),
        ],

        if (response.meanings.isNotEmpty) ...[
          Wrap(
            spacing: AppConfig.smallPadding,
            children: response.meanings.map((meaning) {
              return Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppConfig.mediumPadding,
                  vertical: AppConfig.smallPadding,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(AppConfig.smallRadius),
                ),
                child: Text(
                  meaning.partOfSpeech,
                  style: config.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              );
            }).toList(),
          ),
        ],

        SizedBox(height: AppConfig.mediumSpacing),
        Divider(
          color: Theme.of(
            context,
          ).colorScheme.onSurfaceVariant.withOpacity(0.2),
        ),
        SizedBox(height: AppConfig.mediumSpacing),

        Text(
          'Definitions',
          style: config.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: AppConfig.smallSpacing),
        ...definitions.asMap().entries.map((entry) {
          return Padding(
            padding: EdgeInsets.only(bottom: AppConfig.smallSpacing),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${entry.key + 1}. ',
                  style: config.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(child: Text(entry.value, style: config.bodyMedium)),
              ],
            ),
          );
        }),

        if (example != null) ...[
          SizedBox(height: AppConfig.mediumSpacing),
          Text(
            'Example',
            style: config.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: AppConfig.smallSpacing),
          Container(
            padding: EdgeInsets.all(AppConfig.mediumPadding),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppConfig.mediumRadius),
            ),
            child: Text(
              '"$example"',
              style: config.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
            ),
          ),
        ],

        if (synonyms.isNotEmpty) ...[
          SizedBox(height: AppConfig.mediumSpacing),
          Text(
            'Synonyms',
            style: config.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: AppConfig.smallSpacing),
          Wrap(
            spacing: AppConfig.smallPadding,
            runSpacing: AppConfig.smallPadding,
            children: synonyms.map((syn) {
              return Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppConfig.mediumPadding,
                  vertical: AppConfig.smallPadding / 2,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(AppConfig.pillRadius),
                ),
                child: Text(
                  syn,
                  style: config.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                ),
              );
            }).toList(),
          ),
        ],

        if (antonyms.isNotEmpty) ...[
          SizedBox(height: AppConfig.mediumSpacing),
          Text(
            'Antonyms',
            style: config.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: AppConfig.smallSpacing),
          Wrap(
            spacing: AppConfig.smallPadding,
            runSpacing: AppConfig.smallPadding,
            children: antonyms.map((ant) {
              return Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppConfig.mediumPadding,
                  vertical: AppConfig.smallPadding / 2,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiaryContainer,
                  borderRadius: BorderRadius.circular(AppConfig.pillRadius),
                ),
                child: Text(
                  ant,
                  style: config.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onTertiaryContainer,
                  ),
                ),
              );
            }).toList(),
          ),
        ],

        SizedBox(height: AppConfig.mediumSpacing),
      ],
    );
  }
}
