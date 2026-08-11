enum AnswerMode { multipleChoice, integerInput, selfCheck }

enum FigureType { custom, svg }

class QuestionOlympiadTaxonomy {
  const QuestionOlympiadTaxonomy({
    required this.topic,
    required this.topicCode,
    this.subtopic,
    this.subtopicCode,
  });

  final String topic;
  final String topicCode;
  final String? subtopic;
  final String? subtopicCode;

  factory QuestionOlympiadTaxonomy.fromJson(Map<String, dynamic> json) {
    return QuestionOlympiadTaxonomy(
      topic: json['topic'] as String? ?? '',
      topicCode: json['topicCode'] as String? ?? '',
      subtopic: json['subtopic'] as String?,
      subtopicCode: json['subtopicCode'] as String?,
    );
  }
}

class QuestionSource {
  const QuestionSource({
    required this.type,
    this.name,
    this.contest,
    this.year,
    this.round,
    this.division,
    this.problemNumber,
    this.reference,
    this.displayText,
    this.sourceUrl,
    this.rightsStatus,
    this.notes,
  });

  final String type;
  final String? name;
  final String? contest;
  final String? year;
  final String? round;
  final String? division;
  final String? problemNumber;
  final String? reference;
  final String? displayText;
  final String? sourceUrl;
  final String? rightsStatus;
  final String? notes;

  String? get displayLabel {
    if (type == 'rewritten_olympiad_style') {
      return null;
    }
    if (displayText != null && displayText!.trim().isNotEmpty) {
      return displayText;
    }

    final List<String> officialParts = <String>[
      if (contest != null && contest!.trim().isNotEmpty) contest!,
      if (year != null && year!.trim().isNotEmpty) year!,
      if (round != null && round!.trim().isNotEmpty) round!,
      if (division != null && division!.trim().isNotEmpty) division!,
      if (problemNumber != null && problemNumber!.trim().isNotEmpty)
        problemNumber!,
    ];
    if (officialParts.isNotEmpty) {
      return officialParts.join(', ');
    }

    final List<String> parts = <String>[
      if (name != null && name!.trim().isNotEmpty) name!,
      if (reference != null && reference!.trim().isNotEmpty) reference!,
    ];
    if (parts.isEmpty) {
      return null;
    }
    return parts.join(' · ');
  }

  factory QuestionSource.fromJson(Map<String, dynamic> json) {
    return QuestionSource(
      type: json['type'] as String? ?? 'rewritten_olympiad_style',
      name: json['name'] as String?,
      contest: json['contest'] as String?,
      year: json['year'] as String?,
      round: json['round'] as String?,
      division: json['division'] as String?,
      problemNumber: json['problemNumber'] as String?,
      reference: json['reference'] as String?,
      displayText: json['displayText'] as String?,
      sourceUrl: json['sourceUrl'] as String?,
      rightsStatus: json['rightsStatus'] as String?,
      notes: json['notes'] as String?,
    );
  }
}

class CorrectAnswer {
  const CorrectAnswer({
    required this.type,
    required this.value,
  });

  final String type;
  final String value;

  factory CorrectAnswer.fromJson(Map<String, dynamic> json) {
    return CorrectAnswer(
      type: json['type'] as String? ?? '',
      value: json['value'] as String? ?? '',
    );
  }
}

class InputConstraints {
  const InputConstraints({
    required this.allowNegative,
    required this.maxDigits,
  });

  final bool allowNegative;
  final int maxDigits;

  factory InputConstraints.fromJson(Map<String, dynamic> json) {
    return InputConstraints(
      allowNegative: json['allowNegative'] as bool? ?? false,
      maxDigits: json['maxDigits'] as int? ?? 0,
    );
  }
}

class QuestionOption {
  const QuestionOption({
    required this.key,
    required this.labels,
  });

  final String key;
  final Map<String, String> labels;

  factory QuestionOption.fromJson(String key, Map<String, dynamic> json) {
    return QuestionOption(
      key: key,
      labels: json.map((locale, value) => MapEntry(locale, value as String)),
    );
  }
}

class QuestionFigure {
  const QuestionFigure({
    required this.type,
    required this.kind,
    required this.params,
    this.assetPath,
  });

  final FigureType type;
  final String kind;
  final Map<String, dynamic> params;
  final String? assetPath;

  factory QuestionFigure.fromJson(Map<String, dynamic> json) {
    final String rawType = json['type'] as String? ?? 'custom';
    return QuestionFigure(
      type: rawType == 'svg' ? FigureType.svg : FigureType.custom,
      kind: json['kind'] as String? ?? '',
      params: Map<String, dynamic>.from(
        json['params'] as Map<String, dynamic>? ?? const {},
      ),
      assetPath: json['assetPath'] as String?,
    );
  }
}

class Question {
  const Question({
    required this.id,
    required this.topic,
    required this.difficulty,
    required this.levelStage,
    required this.challengeTier,
    required this.prompt,
    required this.answer,
    required this.solutionSteps,
    required this.figure,
    required this.answerMode,
    required this.correctAnswer,
    this.options,
    this.inputConstraints,
    this.source,
    this.olympiadTaxonomy,
    this.reviewStatus,
  });

  final String id;
  final String topic;
  final String difficulty;
  final String levelStage;
  final String challengeTier;
  final Map<String, String> prompt;
  final Map<String, String> answer;
  final Map<String, List<String>> solutionSteps;
  final QuestionFigure figure;
  final AnswerMode answerMode;
  final CorrectAnswer correctAnswer;
  final Map<String, QuestionOption>? options;
  final InputConstraints? inputConstraints;
  final QuestionSource? source;
  final QuestionOlympiadTaxonomy? olympiadTaxonomy;
  final String? reviewStatus;

  bool get isReviewApproved {
    if (reviewStatus == null || reviewStatus!.trim().isEmpty) {
      return true;
    }
    return reviewStatus == 'ok';
  }

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as String,
      topic: json['topic'] as String,
      difficulty: json['difficulty'] as String,
      levelStage: json['levelStage'] as String,
      challengeTier: json['challengeTier'] as String,
      prompt: _readLocalizedStringMap(json['prompt']),
      answer: _readLocalizedStringMap(json['answer']),
      solutionSteps: _readLocalizedStringListMap(json['solutionSteps']),
      figure: QuestionFigure.fromJson(
        Map<String, dynamic>.from(json['figure'] as Map<String, dynamic>),
      ),
      answerMode: _readAnswerMode(json['answerMode'] as String?),
      correctAnswer: CorrectAnswer.fromJson(
        Map<String, dynamic>.from(
          json['correctAnswer'] as Map<String, dynamic>? ?? const {},
        ),
      ),
      options: _readOptions(json['options']),
      inputConstraints: json['inputConstraints'] == null
          ? null
          : InputConstraints.fromJson(
              Map<String, dynamic>.from(
                json['inputConstraints'] as Map<String, dynamic>,
              ),
            ),
      source: json['source'] == null
          ? null
          : QuestionSource.fromJson(
              Map<String, dynamic>.from(
                json['source'] as Map<String, dynamic>,
              ),
            ),
      olympiadTaxonomy: json['olympiadTaxonomy'] == null
          ? null
          : QuestionOlympiadTaxonomy.fromJson(
              Map<String, dynamic>.from(
                json['olympiadTaxonomy'] as Map<String, dynamic>,
              ),
            ),
      reviewStatus: json['reviewStatus'] as String?,
    );
  }

  String localizedPrompt(String localeCode) {
    return _lookupLocalizedString(prompt, localeCode);
  }

  String localizedAnswer(String localeCode) {
    return _lookupLocalizedString(answer, localeCode);
  }

  List<String> localizedSolutionSteps(String localeCode) {
    return _lookupLocalizedList(solutionSteps, localeCode);
  }

  String localizedOptionLabel(String optionKey, String localeCode) {
    final QuestionOption? option = options?[optionKey];
    if (option == null) {
      return optionKey;
    }
    return _lookupLocalizedString(option.labels, localeCode);
  }

  static Map<String, String> _readLocalizedStringMap(dynamic value) {
    final Map<String, dynamic> raw = Map<String, dynamic>.from(value as Map);
    return raw.map((key, value) => MapEntry(key, value as String));
  }

  static Map<String, List<String>> _readLocalizedStringListMap(dynamic value) {
    final Map<String, dynamic> raw = Map<String, dynamic>.from(value as Map);
    return raw.map(
      (key, value) => MapEntry(
        key,
        List<String>.from(value as List<dynamic>),
      ),
    );
  }

  static AnswerMode _readAnswerMode(String? value) {
    switch (value) {
      case 'integer_input':
        return AnswerMode.integerInput;
      case 'self_check':
        return AnswerMode.selfCheck;
      case 'multiple_choice':
      default:
        return AnswerMode.multipleChoice;
    }
  }

  static Map<String, QuestionOption>? _readOptions(dynamic value) {
    if (value == null) {
      return null;
    }
    final Map<String, dynamic> raw = Map<String, dynamic>.from(value as Map);
    return raw.map(
      (key, optionValue) => MapEntry(
        key,
        QuestionOption.fromJson(
          key,
          Map<String, dynamic>.from(optionValue as Map),
        ),
      ),
    );
  }

  static String _lookupLocalizedString(
    Map<String, String> localizedMap,
    String localeCode,
  ) {
    for (final String candidate in _localeCandidates(localeCode)) {
      final String? value = localizedMap[candidate];
      if (value != null) {
        return value;
      }
    }
    return localizedMap['en'] ?? localizedMap.values.first;
  }

  static List<String> _lookupLocalizedList(
    Map<String, List<String>> localizedMap,
    String localeCode,
  ) {
    for (final String candidate in _localeCandidates(localeCode)) {
      final List<String>? value = localizedMap[candidate];
      if (value != null) {
        return value;
      }
    }
    return localizedMap['en'] ?? localizedMap.values.first;
  }

  static String _languageFallback(String localeCode) {
    if (localeCode.contains('-')) {
      return localeCode.split('-').first;
    }
    if (localeCode.contains('_')) {
      return localeCode.split('_').first;
    }
    return localeCode;
  }

  static List<String> _localeCandidates(String localeCode) {
    final String normalized = localeCode.replaceAll('_', '-');
    final List<String> candidates = <String>[
      normalized,
      _languageFallback(normalized),
    ];

    if (normalized == 'zh-TW' || normalized == 'zh-HK' || normalized == 'zh-MO') {
      candidates.insert(1, 'zh-Hant');
    }
    if (normalized == 'zh-CN' || normalized == 'zh-SG') {
      candidates.insert(1, 'zh-Hans');
    }
    if (normalized == 'zh-Hant' || normalized == 'zh-Hans') {
      candidates.add('zh');
    }

    return candidates.toSet().toList();
  }
}
