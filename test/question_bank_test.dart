import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mathspring/competition_profiles.dart';
import 'package:mathspring/data/bundled/bundled_olympiad_template_repository.dart';
import 'package:mathspring/data/bundled/bundled_question_bank_repository.dart';
import 'package:mathspring/models/olympiad_template.dart';
import 'package:mathspring/models/question.dart';
import 'package:mathspring/models/question_bank.dart';

void main() {
  test('parses a custom figure question with multilingual fields', () {
    final Map<String, dynamic> json = {
      'id': 'trig_001',
      'topic': 'trigonometry',
      'difficulty': 'advanced',
      'levelStage': 'grade6',
      'challengeTier': 'competition',
      'prompt': {
        'zh-Hant': '觀察圖形，在 0 到 2π 間，sin(x) 與 cos(x) 在哪裡達到最大值？',
        'en': 'On 0 to 2π, where do sin(x) and cos(x) reach their maximum values?',
      },
      'answer': {
        'zh-Hant': 'sin(x) 在 π/2 達最大值 1，cos(x) 在 0 達最大值 1。',
        'en': 'sin(x) reaches 1 at π/2, and cos(x) reaches 1 at 0.',
      },
      'solutionSteps': {
        'zh-Hant': ['找出兩條曲線的最高點。', '讀取對應的 x 座標。'],
        'en': ['Find the peaks of both curves.', 'Read the corresponding x-values.'],
      },
      'figure': {
        'type': 'custom',
        'kind': 'trig_plane',
        'params': {
          'showGrid': true,
          'showLegend': true,
          'highlightInterval': ['pi/2', 'pi'],
        },
      },
      'answerMode': 'integer_input',
      'correctAnswer': {
        'type': 'integer',
        'value': '42',
      },
      'inputConstraints': {
        'allowNegative': false,
        'maxDigits': 3,
      },
      'source': {
        'type': 'rewritten_olympiad_style',
        'name': 'MathSpring Editorial',
        'reference': 'kangaroo-style geometry',
        'displayText': 'Math Kangaroo USA 2025, Grades 3-4, Problem 12',
        'notes': 'Rewritten from competition-style structure without protected wording.',
      },
    };

    final Question question = Question.fromJson(json);

    expect(question.id, 'trig_001');
    expect(question.figure.type, FigureType.custom);
    expect(question.figure.kind, 'trig_plane');
    expect(question.localizedPrompt('zh-Hant'), contains('sin(x)'));
    expect(question.localizedAnswer('en'), contains('π/2'));
    expect(question.localizedSolutionSteps('zh-Hant').length, 2);
    expect(question.answerMode, AnswerMode.integerInput);
    expect(question.correctAnswer.value, '42');
    expect(question.inputConstraints?.maxDigits, 3);
    expect(question.source?.type, 'rewritten_olympiad_style');
    expect(question.source?.name, 'MathSpring Editorial');
    expect(
      question.source?.displayText,
      'Math Kangaroo USA 2025, Grades 3-4, Problem 12',
    );
  });

  test('matches Traditional Chinese question content for zh-TW locale codes', () {
    final Question question = Question.fromJson({
      'id': 'locale_test_001',
      'topic': 'geometry',
      'difficulty': 'foundation',
      'levelStage': 'grade1',
      'challengeTier': 'foundation',
      'prompt': {
        'zh-Hant': '這是繁體中文題目。',
        'en': 'This is the English prompt.',
      },
      'answer': {
        'zh-Hant': '這是繁體中文答案。',
        'en': 'This is the English answer.',
      },
      'solutionSteps': {
        'zh-Hant': ['步驟一'],
        'en': ['Step one'],
      },
      'figure': {
        'type': 'custom',
        'kind': 'none',
        'params': <String, dynamic>{},
      },
      'answerMode': 'integer_input',
      'correctAnswer': {
        'type': 'integer',
        'value': '1',
      },
      'inputConstraints': {
        'allowNegative': false,
        'maxDigits': 1,
      },
    });

    expect(question.localizedPrompt('zh-TW'), '這是繁體中文題目。');
    expect(question.localizedAnswer('zh_TW'), '這是繁體中文答案。');
    expect(question.localizedSolutionSteps('zh-TW'), ['步驟一']);
  });

  test('parses structured official source metadata for display and intake', () {
    final QuestionSource source = QuestionSource.fromJson({
      'type': 'official_reference',
      'name': 'Math Kangaroo USA',
      'contest': 'Math Kangaroo USA',
      'year': '2025',
      'round': 'Final Round',
      'division': 'Grades 3-4',
      'problemNumber': '12',
      'reference': '2025 Grades 3-4 Problem 12',
      'displayText': 'Math Kangaroo USA 2025, Grades 3-4, Problem 12',
      'sourceUrl': 'https://mathkangaroo.org/mks/practice/pdf-exams/',
      'rightsStatus': 'needs_review',
    });

    expect(source.type, 'official_reference');
    expect(source.contest, 'Math Kangaroo USA');
    expect(source.year, '2025');
    expect(source.round, 'Final Round');
    expect(source.division, 'Grades 3-4');
    expect(source.problemNumber, '12');
    expect(source.sourceUrl, 'https://mathkangaroo.org/mks/practice/pdf-exams/');
    expect(source.rightsStatus, 'needs_review');
    expect(source.displayLabel, 'Math Kangaroo USA 2025, Grades 3-4, Problem 12');
  });

  test('matches Simplified Chinese and Japanese locale fallbacks', () {
    final Question question = Question.fromJson({
      'id': 'locale_test_002',
      'topic': 'logic',
      'difficulty': 'foundation',
      'levelStage': 'grade3',
      'challengeTier': 'foundation',
      'prompt': {
        'zh-Hant': '這是繁體題目。',
        'zh-Hans': '这是简体题目。',
        'en': 'This is the English prompt.',
        'ja': 'これは日本語の問題です。',
      },
      'answer': {
        'zh-Hant': '這是繁體答案。',
        'zh-Hans': '这是简体答案。',
        'en': 'This is the English answer.',
        'ja': 'これは日本語の答えです。',
      },
      'solutionSteps': {
        'zh-Hant': ['繁體步驟'],
        'zh-Hans': ['简体步骤'],
        'en': ['English step'],
        'ja': ['日本語の手順'],
      },
      'figure': {
        'type': 'custom',
        'kind': 'none',
        'params': <String, dynamic>{},
      },
      'answerMode': 'integer_input',
      'correctAnswer': {
        'type': 'integer',
        'value': '7',
      },
    });

    expect(question.localizedPrompt('zh-CN'), '这是简体题目。');
    expect(question.localizedAnswer('zh-SG'), '这是简体答案。');
    expect(question.localizedSolutionSteps('ja-JP'), ['日本語の手順']);
  });

  test('grade range helpers expand and filter matching packs', () async {
    TestWidgetsFlutterBinding.ensureInitialized();

    expect(levelStagesInRange(minLevelStage: 'grade1', maxLevelStage: 'grade2'), [
      'grade1',
      'grade2',
    ]);
    expect(levelStagesInRange(minLevelStage: 'grade3', maxLevelStage: 'grade4'), [
      'grade3',
      'grade4',
    ]);
    expect(isLevelStageWithinRange('grade4', minLevelStage: 'grade3', maxLevelStage: 'grade6'), isTrue);
    expect(isLevelStageWithinRange('grade7', minLevelStage: 'grade3', maxLevelStage: 'grade6'), isFalse);

    final BundledQuestionBankRepository repository = BundledQuestionBankRepository();
    final BundledQuestionManifest manifest = await repository.loadManifest();
    final List<BundledQuestionPackInfo> groupedPacks = manifest.packs
        .where(
          (pack) =>
              pack.topicCode == 'geometry' &&
              pack.challengeTier == 'foundation' &&
              isLevelStageWithinRange(
                pack.levelStage,
                minLevelStage: 'grade3',
                maxLevelStage: 'grade4',
              ),
        )
        .toList();

    expect(groupedPacks, hasLength(2));
    expect(
      groupedPacks.map((pack) => pack.levelStage).toSet(),
      {'grade3', 'grade4'},
    );
  });

  test('loads bundled question manifest and pack metadata', () async {
    TestWidgetsFlutterBinding.ensureInitialized();

    const String manifestAssetPath = 'assets/questions/manifest.json';
    final String rawJson = await rootBundle.loadString(manifestAssetPath);
    final Map<String, dynamic> decoded = jsonDecode(rawJson) as Map<String, dynamic>;

    final BundledQuestionManifest manifest = BundledQuestionManifest.fromJson(decoded);

    expect(manifest.version, 1);
    expect(manifest.packs, hasLength(50));
    expect(manifest.packs.first.topicCode, 'geometry');
    expect(manifest.packs.first.levelStage, 'grade4');
    expect(manifest.packs.first.questionCount, greaterThanOrEqualTo(10));
    final List<BundledQuestionPackInfo> upperAlgebraPacks = manifest.packs
        .where((pack) => pack.topicCode == 'algebra')
        .toList();
    final List<BundledQuestionPackInfo> upperGeometryPacks = manifest.packs
        .where(
          (pack) => pack.topicCode == 'geometry' &&
              pack.levelStage.startsWith('grade') &&
              {'grade7', 'grade8', 'grade9', 'grade10', 'grade11', 'grade12'}
                  .contains(pack.levelStage),
        )
        .toList();
    final List<BundledQuestionPackInfo> upperNumberTheoryPacks = manifest.packs
        .where(
          (pack) => pack.topicCode == 'number_theory' &&
              {'grade7', 'grade8', 'grade9', 'grade10', 'grade11', 'grade12'}
                  .contains(pack.levelStage),
        )
        .toList();
    final List<BundledQuestionPackInfo> upperCombinatoricsPacks = manifest.packs
        .where(
          (pack) => pack.topicCode == 'combinatorics' &&
              {'grade7', 'grade8', 'grade9', 'grade10', 'grade11', 'grade12'}
                  .contains(pack.levelStage),
        )
        .toList();
    final List<BundledQuestionPackInfo> upperLogicPacks = manifest.packs
        .where(
          (pack) => pack.topicCode == 'logic' &&
              {'grade7', 'grade8', 'grade9', 'grade10', 'grade11', 'grade12'}
                  .contains(pack.levelStage),
        )
        .toList();
    expect(upperAlgebraPacks, hasLength(6));
    expect(upperGeometryPacks, hasLength(6));
    expect(upperNumberTheoryPacks, hasLength(6));
    expect(upperCombinatoricsPacks, hasLength(6));
    expect(upperLogicPacks, hasLength(6));
    expect(
      upperAlgebraPacks.map((pack) => pack.levelStage).toSet(),
      {'grade7', 'grade8', 'grade9', 'grade10', 'grade11', 'grade12'},
    );
    expect(
      upperGeometryPacks.map((pack) => pack.levelStage).toSet(),
      {'grade7', 'grade8', 'grade9', 'grade10', 'grade11', 'grade12'},
    );
    expect(
      upperAlgebraPacks.every((pack) => pack.questionCount == 9),
      isTrue,
    );
    expect(
      upperGeometryPacks.every((pack) => pack.questionCount == 10),
      isTrue,
    );
    expect(
      upperNumberTheoryPacks.every((pack) => pack.questionCount == 10),
      isTrue,
    );
    expect(
      upperCombinatoricsPacks.every((pack) => pack.questionCount == 9),
      isTrue,
    );
    expect(
      upperLogicPacks.every((pack) => pack.questionCount == 9),
      isTrue,
    );
    expect(
      manifest.packs
          .where(
            (pack) =>
                pack.topicCode != 'algebra' &&
                pack.topicCode != 'geometry' &&
                pack.topicCode != 'number_theory' &&
                pack.topicCode != 'combinatorics' &&
                !({'grade7', 'grade8', 'grade9', 'grade10', 'grade11', 'grade12'}
                        .contains(pack.levelStage) &&
                    pack.topicCode == 'logic'),
          )
          .every((pack) => pack.questionCount >= 10),
      isTrue,
    );
  });

  test('question bank does not contain draft placeholder content', () async {
    final Directory questionRoot = Directory('assets/questions');
    final List<FileSystemEntity> files = questionRoot
        .listSync(recursive: true)
        .where(
          (entity) =>
              entity is File &&
              entity.path.endsWith('.json') &&
              !entity.path.endsWith('manifest.json'),
        )
        .toList();
    final List<String> violations = <String>[];
    final List<String> bannedMarkers = <String>[
      'This draft',
      'should not be used',
      '此題不採用',
      '使うべきではありません',
    ];

    for (final FileSystemEntity entity in files) {
      final File file = entity as File;
      final Map<String, dynamic> payload =
          jsonDecode(await file.readAsString()) as Map<String, dynamic>;
      final List<dynamic> questions = payload['questions'] as List<dynamic>? ?? <dynamic>[];

      for (final dynamic question in questions) {
        final Map<String, dynamic> record = question as Map<String, dynamic>;
        final Map<String, dynamic> solutionSteps =
            record['solutionSteps'] as Map<String, dynamic>? ?? <String, dynamic>{};
        final List<String> texts = <String>[
          jsonEncode(record['prompt']),
          jsonEncode(record['answer']),
          jsonEncode(solutionSteps),
        ];

        final bool hasDraftMarker = bannedMarkers.any(
          (marker) => texts.any((text) => text.contains(marker)),
        );
        if (hasDraftMarker) {
          violations.add(record['id'] as String);
        }
      }
    }

    expect(violations, isEmpty);
  });

  test('olympiad template registry documents 36 core templates', () async {
    final File registryFile = File('docs/olympiad-template-registry.md');

    expect(await registryFile.exists(), isTrue);

    final String content = await registryFile.readAsString();
    expect(content, contains('Total core templates: 36'));
    expect(content, contains('Skill families covered: 6'));
    expect(content, contains('Difficulty layers per family: 2'));
    expect(
      RegExp(r'^### arithmetic$', multiLine: true).hasMatch(content),
      isTrue,
    );
    expect(
      RegExp(r'^### number_theory$', multiLine: true).hasMatch(content),
      isTrue,
    );
    expect(
      RegExp(r'^### algebra$', multiLine: true).hasMatch(content),
      isTrue,
    );
    expect(
      RegExp(r'^### geometry$', multiLine: true).hasMatch(content),
      isTrue,
    );
    expect(
      RegExp(r'^### combinatorics$', multiLine: true).hasMatch(content),
      isTrue,
    );
    expect(
      RegExp(r'^### logic$', multiLine: true).hasMatch(content),
      isTrue,
    );
  });

  test('olympiad template examples document one worked sample per topic', () async {
    final File examplesFile = File('docs/olympiad-template-examples.md');

    expect(await examplesFile.exists(), isTrue);

    final String content = await examplesFile.readAsString();
    expect(content, contains('Worked samples: 6'));
    expect(
      RegExp(r'^## arithmetic sample$', multiLine: true).hasMatch(content),
      isTrue,
    );
    expect(
      RegExp(r'^## number_theory sample$', multiLine: true).hasMatch(content),
      isTrue,
    );
    expect(
      RegExp(r'^## algebra sample$', multiLine: true).hasMatch(content),
      isTrue,
    );
    expect(
      RegExp(r'^## geometry sample$', multiLine: true).hasMatch(content),
      isTrue,
    );
    expect(
      RegExp(r'^## combinatorics sample$', multiLine: true).hasMatch(content),
      isTrue,
    );
    expect(
      RegExp(r'^## logic sample$', multiLine: true).hasMatch(content),
      isTrue,
    );
    expect(content, contains('"answerMode": "multiple_choice"'));
    expect(content, contains('"answerMode": "integer_input"'));
  });

  test('olympiad template registry json defines 36 templates across 6 topics',
      () async {
    final File registryFile = File(
      'assets/question_templates/olympiad_template_registry.v1.json',
    );

    expect(await registryFile.exists(), isTrue);

    final Map<String, dynamic> decoded = jsonDecode(
      await registryFile.readAsString(),
    ) as Map<String, dynamic>;

    expect(decoded['version'], 1);
    final List<dynamic> templates = decoded['templates'] as List<dynamic>;
    expect(templates, hasLength(36));

    final Set<String> topics = templates
        .map((template) => (template as Map<String, dynamic>)['topicCode'] as String)
        .toSet();
    expect(
      topics,
      {
        'arithmetic',
        'number_theory',
        'algebra',
        'geometry',
        'combinatorics',
        'logic',
      },
    );
  });

  test('parses olympiad template registry entries into typed records', () async {
    final File registryFile = File(
      'assets/question_templates/olympiad_template_registry.v1.json',
    );

    final Map<String, dynamic> decoded = jsonDecode(
      await registryFile.readAsString(),
    ) as Map<String, dynamic>;
    final List<dynamic> templates = decoded['templates'] as List<dynamic>;

    final OlympiadTemplateRegistry registry = OlympiadTemplateRegistry.fromJson(
      decoded,
    );

    expect(registry.version, 1);
    expect(registry.generatedAt, '2026-07-19');
    expect(registry.templates, hasLength(36));
    expect(
      registry.templates.first.templateId,
      'arithmetic_foundation_sum_difference_and_multiple_relations_v1',
    );
    expect(registry.templates.first.topicCode, 'arithmetic');
    expect(
      registry.templates.first.allowedAnswerModes,
      ['multiple_choice', 'integer_input'],
    );
    expect(registry.templates.first.requiresFigure, 'none');
    expect(
      registry.templates.last.templateId,
      'logic_competition_ordering_and_matching_v1',
    );
    expect(registry.templates.last.requiresFigure, 'none');
    expect(templates.length, registry.templates.length);
  });

  test('loads olympiad template registry through bundled repository', () async {
    TestWidgetsFlutterBinding.ensureInitialized();

    final BundledOlympiadTemplateRepository repository =
        BundledOlympiadTemplateRepository();
    final OlympiadTemplateRegistry registry = await repository.loadRegistry();

    expect(registry.version, 1);
    expect(registry.templates, hasLength(36));
    expect(
      repository.templatesForTopic('geometry', registry),
      hasLength(6),
    );
    expect(
      repository.templatesForTier('competition', registry),
      hasLength(18),
    );
  });

  test('loads all bundled question packs through manifest indexing', () async {
    TestWidgetsFlutterBinding.ensureInitialized();

    final BundledQuestionBankRepository repository = BundledQuestionBankRepository();
    final List<QuestionBank> packs = await repository.loadAllPacks();
    final Map<String, dynamic> manifestJson = jsonDecode(
      await rootBundle.loadString('assets/questions/manifest.json'),
    ) as Map<String, dynamic>;
    final BundledQuestionManifest manifest = BundledQuestionManifest.fromJson(
      manifestJson,
    );
    final int expectedTotalQuestions = manifest.packs
        .map((pack) => pack.questionCount)
        .fold(0, (sum, count) => sum + count);

    expect(packs, hasLength(50));
    expect(packs.first.questions, isNotEmpty);
    expect(packs.last.questions, isNotEmpty);
    final int totalQuestions = packs
        .map((pack) => pack.questions.length)
        .fold(0, (sum, count) => sum + count);
    expect(totalQuestions, expectedTotalQuestions);
    expect(
      packs.every(
        (pack) {
          final bool isUpperOlympiadPack = pack.questions.isNotEmpty &&
              {'algebra', 'geometry'}.contains(pack.questions.first.topic) &&
              {
                'grade7',
                'grade8',
                'grade9',
                'grade10',
                'grade11',
                'grade12',
              }.contains(pack.questions.first.levelStage) ||
              (pack.questions.isNotEmpty &&
                  pack.questions.first.topic == 'number_theory' &&
                  {
                    'grade7',
                    'grade8',
                    'grade9',
                    'grade10',
                    'grade11',
                    'grade12',
                  }.contains(pack.questions.first.levelStage)) ||
              (pack.questions.isNotEmpty &&
                  pack.questions.first.topic == 'combinatorics' &&
                  {
                    'grade7',
                    'grade8',
                    'grade9',
                    'grade10',
                    'grade11',
                    'grade12',
                  }.contains(pack.questions.first.levelStage)) ||
              (pack.questions.isNotEmpty &&
                  pack.questions.first.topic == 'logic' &&
                  {
                    'grade7',
                    'grade8',
                    'grade9',
                    'grade10',
                    'grade11',
                    'grade12',
                  }.contains(pack.questions.first.levelStage)) &&
              {
                'grade7',
                'grade8',
                'grade9',
                'grade10',
                'grade11',
                'grade12',
              }.contains(pack.questions.first.levelStage);
          if (!isUpperOlympiadPack) {
            return pack.questions.length >= 10;
          }
          if (pack.questions.first.topic == 'logic') {
            return pack.questions.length == 9;
          }
          if (pack.questions.first.topic == 'combinatorics') {
            return pack.questions.length == 9;
          }
          if (pack.questions.first.topic == 'geometry') {
            return pack.questions.length == 10;
          }
          if (pack.questions.first.topic == 'number_theory') {
            return pack.questions.length == 10;
          }
          if (pack.questions.first.topic == 'algebra') {
            return pack.questions.length == 9;
          }
          return pack.questions.length == 3;
        },
      ),
      isTrue,
    );
    final List<QuestionBank> geometryPacks = packs
        .where(
          (pack) => pack.questions.isNotEmpty &&
              pack.questions.every((question) => question.topic == 'geometry'),
        )
        .toList();
    expect(geometryPacks, hasLength(12));
    expect(
      geometryPacks.every(
        (pack) => {
          'grade7',
          'grade8',
          'grade9',
          'grade10',
          'grade11',
          'grade12',
        }.contains(pack.questions.first.levelStage)
            ? pack.questions.length == 10
            : pack.questions.length >= 10,
      ),
      isTrue,
    );
    final int totalGeometryQuestions = geometryPacks
        .map((pack) => pack.questions.length)
        .fold(0, (sum, count) => sum + count);
    final int expectedGeometryQuestions = manifest.packs
        .where((pack) => pack.topicCode == 'geometry')
        .map((pack) => pack.questionCount)
        .fold(0, (sum, count) => sum + count);
    expect(totalGeometryQuestions, expectedGeometryQuestions);
    expect(packs.first.questions.first.figure.type, FigureType.custom);
    expect(packs.first.questions.first.answerMode, isNotNull);
    expect(packs.first.questions.first.source?.type, 'rewritten_olympiad_style');
    expect(packs.last.questions.first.answerMode, isNotNull);
    expect(
      packs.every(
        (pack) => pack.questions.every((question) => question.source != null),
      ),
      isTrue,
    );
  });

  test('bundled geometry packs include demo-ready shape and coordinate figures',
      () async {
    TestWidgetsFlutterBinding.ensureInitialized();

    final BundledQuestionBankRepository repository = BundledQuestionBankRepository();
    final QuestionBank grade2Pack = await repository.loadPack(
      'assets/questions/geometry/grade2_foundation.geometry.v1.json',
    );
    final QuestionBank grade4Pack = await repository.loadPack(
      'assets/questions/geometry/grade4_foundation.geometry.v1.json',
    );

    expect(grade2Pack.questions.first.figure.kind, 'shape_diagram');
    expect(grade4Pack.questions[3].figure.kind, 'coordinate_plane');
    expect(grade4Pack.questions.first.figure.kind, isNot('trig_plane'));
  });

  test('upper logic packs are no longer mostly duplicated across grades', () async {
    TestWidgetsFlutterBinding.ensureInitialized();

    final BundledQuestionBankRepository repository = BundledQuestionBankRepository();
    final List<QuestionBank> logicPacks = <QuestionBank>[
      await repository.loadPack('assets/questions/logic/grade3_foundation.logic.v1.json'),
      await repository.loadPack('assets/questions/logic/grade4_foundation.logic.v1.json'),
      await repository.loadPack('assets/questions/logic/grade5_foundation.logic.v1.json'),
      await repository.loadPack('assets/questions/logic/grade6_foundation.logic.v1.json'),
    ];

    for (int i = 0; i < logicPacks.length; i++) {
      for (int j = i + 1; j < logicPacks.length; j++) {
        final Set<String> promptsA = logicPacks[i].questions
            .map((question) => question.localizedPrompt('zh-Hant'))
            .toSet();
        final Set<String> promptsB = logicPacks[j].questions
            .map((question) => question.localizedPrompt('zh-Hant'))
            .toSet();
        final Set<String> overlap = promptsA.intersection(promptsB);
        expect(
          overlap.length,
          lessThanOrEqualTo(1),
          reason: 'logic packs ${i + 3} and ${j + 3} should not share large prompt sets',
        );
      }
    }
  });

  test('audited logic questions stay internally consistent and uniquely solvable',
      () async {
    TestWidgetsFlutterBinding.ensureInitialized();

    final BundledQuestionBankRepository repository = BundledQuestionBankRepository();
    final QuestionBank grade2Pack = await repository.loadPack(
      'assets/questions/logic/grade2_foundation.logic.v1.json',
    );
    final QuestionBank grade3Pack = await repository.loadPack(
      'assets/questions/logic/grade3_foundation.logic.v1.json',
    );
    final QuestionBank grade4Pack = await repository.loadPack(
      'assets/questions/logic/grade4_foundation.logic.v1.json',
    );
    final QuestionBank grade5Pack = await repository.loadPack(
      'assets/questions/logic/grade5_foundation.logic.v1.json',
    );
    final QuestionBank grade6Pack = await repository.loadPack(
      'assets/questions/logic/grade6_foundation.logic.v1.json',
    );
    final QuestionBank arithmeticGrade4Pack = await repository.loadPack(
      'assets/questions/arithmetic/grade4_foundation.arithmetic.v1.json',
    );

    Question findQuestion(QuestionBank pack, String id) =>
        pack.questions.firstWhere((Question question) => question.id == id);

    final Question grade2SeatQuestion =
        findQuestion(grade2Pack, 'logic_grade2_foundation_003');
    expect(grade2SeatQuestion.correctAnswer.value, 'C');
    expect(
      grade2SeatQuestion.localizedAnswer('zh-Hant'),
      '答案是 3。',
    );

    final Question grade2BagQuestion =
        findQuestion(grade2Pack, 'logic_grade2_foundation_005');
    expect(grade2BagQuestion.correctAnswer.value, 'C');
    expect(
      grade2BagQuestion.localizedPrompt('zh-Hant'),
      isNot(contains('顏色深')),
    );

    final Question grade3TruthQuestion =
        findQuestion(grade3Pack, 'logic_grade3_foundation_002');
    expect(grade3TruthQuestion.localizedAnswer('zh-Hant'), '答案是紅盒。');
    expect(grade3TruthQuestion.correctAnswer.value, 'A');

    final Question grade3GridQuestion =
        findQuestion(grade3Pack, 'logic_grade3_foundation_003');
    expect(
      grade3GridQuestion.localizedPrompt('zh-Hant'),
      contains('阿平不坐左邊欄'),
    );
    expect(grade3GridQuestion.correctAnswer.value, 'B');

    final Question grade3CaseQuestion =
        findQuestion(grade3Pack, 'logic_grade3_foundation_004');
    expect(grade3CaseQuestion.correctAnswer.value, 'B');
    expect(
      grade3CaseQuestion.localizedAnswer('zh-Hant'),
      '答案是 15。',
    );
    expect(
      grade3CaseQuestion.localizedPrompt('zh-Hant'),
      '在 12、15、18 中，哪一個數不是最大的，也不是最小的 3 的倍數，而且是奇數？',
    );

    final Question grade3MatchingQuestion =
        findQuestion(grade3Pack, 'logic_grade3_foundation_006');
    expect(
      grade3MatchingQuestion.localizedAnswer('zh-Hant'),
      isNot(contains('矛盾')),
    );
    expect(grade3MatchingQuestion.correctAnswer.value, 'B');

    final Question grade4ArrangementQuestion =
        findQuestion(grade4Pack, 'logic_grade4_foundation_001');
    expect(grade4ArrangementQuestion.correctAnswer.value, 'C');
    expect(
      grade4ArrangementQuestion.localizedAnswer('zh-Hant'),
      '答案是 C。',
    );

    final Question grade4TruthQuestion =
        findQuestion(grade4Pack, 'logic_grade4_foundation_002');
    expect(grade4TruthQuestion.correctAnswer.value, 'A');
    expect(
      grade4TruthQuestion.localizedSolutionSteps('zh-Hant').join(''),
      isNot(contains('無解')),
    );

    final Question grade4CalendarQuestion =
        findQuestion(grade4Pack, 'logic_grade4_foundation_004');
    expect(grade4CalendarQuestion.correctAnswer.value, 'B');
    expect(
      grade4CalendarQuestion.localizedPrompt('zh-Hant'),
      contains('第 15 天'),
    );

    final Question grade4ScheduleQuestion =
        findQuestion(grade4Pack, 'logic_grade4_foundation_005');
    expect(grade4ScheduleQuestion.correctAnswer.value, 'B');
    expect(
      grade4ScheduleQuestion.localizedPrompt('zh-Hant'),
      contains('英文在星期四'),
    );

    final Question grade5ConsistencyQuestion =
        findQuestion(grade5Pack, 'logic_grade5_foundation_007');
    expect(grade5ConsistencyQuestion.correctAnswer.value, 'D');
    expect(
      grade5ConsistencyQuestion.localizedAnswer('zh-Hant'),
      '答案是丙和丁。',
    );

    final Question grade5ScheduleQuestion =
        findQuestion(grade5Pack, 'logic_grade5_foundation_009');
    expect(grade5ScheduleQuestion.correctAnswer.value, 'B');
    expect(
      grade5ScheduleQuestion.localizedAnswer('zh-Hant'),
      '答案是麵。',
    );

    final Question grade6ArrangementQuestion =
        findQuestion(grade6Pack, 'logic_grade6_foundation_001');
    expect(grade6ArrangementQuestion.correctAnswer.value, 'A');
    expect(
      grade6ArrangementQuestion.localizedAnswer('zh-Hant'),
      '答案是 A。',
    );

    final Question grade6MinimalCaseQuestion =
        findQuestion(grade6Pack, 'logic_grade6_foundation_005');
    expect(grade6MinimalCaseQuestion.correctAnswer.value, '13');
    expect(
      grade6MinimalCaseQuestion.localizedAnswer('zh-Hant'),
      '答案是 13。',
    );

    final Question grade6OrderQuestion =
        findQuestion(grade6Pack, 'logic_grade6_foundation_008');
    expect(grade6OrderQuestion.correctAnswer.value, 'A');
    expect(
      grade6OrderQuestion.localizedPrompt('zh-Hant'),
      contains('A 比 C 薄，C 比 D 薄，A 比 E 薄'),
    );

    final Question arithmeticTypoQuestion =
        findQuestion(arithmeticGrade4Pack, 'arithmetic_grade4_foundation_004');
    expect(
      arithmeticTypoQuestion.localizedPrompt('zh-Hant'),
      '有一些貼紙。若平均分給 6 人，會多 2 張；若平均分給 7 人，剛好還差 5 張。共有幾張貼紙？',
    );
  });

  test('split mixed packs stay competition-like and multi-topic', () async {
    TestWidgetsFlutterBinding.ensureInitialized();

    final BundledQuestionBankRepository repository = BundledQuestionBankRepository();
    for (final String path in <String>[
      'assets/questions/mixed/grade5_foundation.mixed.v1.json',
      'assets/questions/mixed/grade6_foundation.mixed.v1.json',
    ]) {
      final QuestionBank mixedPack = await repository.loadPack(path);

      expect(mixedPack.questions.length, greaterThanOrEqualTo(10));
      expect(
        mixedPack.questions.first.prompt.keys,
        containsAll(<String>['zh-Hant', 'zh-Hans', 'en', 'ja']),
      );

      final Set<String> topics = mixedPack.questions
          .map((question) => question.topic)
          .toSet();
      expect(topics.length, greaterThanOrEqualTo(4));
      expect(
        mixedPack.questions.every(
          (question) => question.solutionSteps['zh-Hant']!.length >= 2,
        ),
        isTrue,
      );
    }
  });

  test('phase 1 ships a single foundation tier (no difficulty layering)', () async {
    TestWidgetsFlutterBinding.ensureInitialized();

    final BundledQuestionBankRepository repository = BundledQuestionBankRepository();
    for (final String path in <String>[
      'assets/questions/arithmetic/grade6_foundation.arithmetic.v1.json',
      'assets/questions/geometry/grade6_foundation.geometry.v1.json',
      'assets/questions/logic/grade6_foundation.logic.v1.json',
      'assets/questions/mixed/grade5_foundation.mixed.v1.json',
      'assets/questions/mixed/grade6_foundation.mixed.v1.json',
    ]) {
      final QuestionBank pack = await repository.loadPack(path);
      // Grade is the only difficulty axis in phase 1; every question is foundation.
      expect(
        pack.questions.map((q) => q.difficulty).toSet(),
        <String>{'foundation'},
        reason: '$path should not use advanced/competition tiers',
      );
      expect(
        pack.questions.map((q) => q.challengeTier).toSet(),
        <String>{'foundation'},
        reason: '$path challengeTier must stay foundation',
      );
    }
  });

  test('grade6 geometry official figure questions expose direct-drawing kinds',
      () async {
    TestWidgetsFlutterBinding.ensureInitialized();

    final BundledQuestionBankRepository repository = BundledQuestionBankRepository();
    final QuestionBank geometryPack = await repository.loadPack(
      'assets/questions/geometry/grade6_foundation.geometry.v1.json',
    );
    Question findQuestion(QuestionBank pack, String id) {
      return pack.questions.firstWhere((question) => question.id == id);
    }

    final Question circleSquareQuestion =
        findQuestion(geometryPack, 'geometry_grade6_foundation_013');
    final Question circleRegionQuestion =
        findQuestion(geometryPack, 'geometry_grade6_foundation_014');

    expect(circleSquareQuestion.figure.kind, 'shape_diagram');
    expect(circleSquareQuestion.source?.type, 'official_reference');
    expect(circleRegionQuestion.figure.kind, 'circle_quadrants_point');
    expect(circleRegionQuestion.correctAnswer.value, '23');
    expect(
      circleRegionQuestion.localizedPrompt('zh-Hant'),
      contains('三部分的面積為 12、15、20'),
    );
  });

  test('selected geometry packs include four-language olympiad-style content',
      () async {
    TestWidgetsFlutterBinding.ensureInitialized();

    final BundledQuestionBankRepository repository = BundledQuestionBankRepository();
    final QuestionBank grade3Pack = await repository.loadPack(
      'assets/questions/geometry/grade3_foundation.geometry.v1.json',
    );
    final QuestionBank grade5Pack = await repository.loadPack(
      'assets/questions/geometry/grade5_foundation.geometry.v1.json',
    );

    expect(
      grade3Pack.questions.first.prompt.keys,
      containsAll(<String>['zh-Hant', 'zh-Hans', 'en', 'ja']),
    );
    expect(
      grade5Pack.questions.first.prompt.keys,
      containsAll(<String>['zh-Hant', 'zh-Hans', 'en', 'ja']),
    );
    expect(
      grade3Pack.questions.first.source?.type,
      'rewritten_olympiad_style',
    );
    expect(
      grade5Pack.questions.first.source?.type,
      'rewritten_olympiad_style',
    );
    expect(
      grade3Pack.questions[1].prompt.keys,
      containsAll(<String>['zh-Hant', 'zh-Hans', 'en', 'ja']),
    );
    expect(
      grade5Pack.questions[1].prompt.keys,
      containsAll(<String>['zh-Hant', 'zh-Hans', 'en', 'ja']),
    );
  });

  test('geometry packs include the 2026-07-28 second mixed expansion batch',
      () async {
    TestWidgetsFlutterBinding.ensureInitialized();

    final BundledQuestionBankRepository repository = BundledQuestionBankRepository();
    final QuestionBank grade1Pack = await repository.loadPack(
      'assets/questions/geometry/grade1_foundation.geometry.v1.json',
    );
    final QuestionBank grade2Pack = await repository.loadPack(
      'assets/questions/geometry/grade2_foundation.geometry.v1.json',
    );
    final QuestionBank grade3Pack = await repository.loadPack(
      'assets/questions/geometry/grade3_foundation.geometry.v1.json',
    );
    final QuestionBank grade4Pack = await repository.loadPack(
      'assets/questions/geometry/grade4_foundation.geometry.v1.json',
    );
    final QuestionBank grade5Pack = await repository.loadPack(
      'assets/questions/geometry/grade5_foundation.geometry.v1.json',
    );
    final QuestionBank grade6Pack = await repository.loadPack(
      'assets/questions/geometry/grade6_foundation.geometry.v1.json',
    );

    expect(
      grade1Pack.questions.any(
        (question) => question.id == 'geometry_grade1_foundation_043',
      ),
      isTrue,
    );
    expect(
      grade2Pack.questions.any(
        (question) => question.id == 'geometry_grade2_foundation_043',
      ),
      isTrue,
    );
    expect(
      grade3Pack.questions.any(
        (question) => question.id == 'geometry_grade3_foundation_045',
      ),
      isTrue,
    );
    expect(
      grade4Pack.questions.any(
        (question) => question.id == 'geometry_grade4_foundation_043',
      ),
      isTrue,
    );
    expect(
      grade5Pack.questions.any(
        (question) => question.id == 'geometry_grade5_foundation_043',
      ),
      isTrue,
    );
    expect(
      grade6Pack.questions.any(
        (question) => question.id == 'geometry_grade6_foundation_045',
      ),
      isTrue,
    );
  });

  test('geometry packs include the 2026-07-28 third mixed expansion batch',
      () async {
    TestWidgetsFlutterBinding.ensureInitialized();

    final BundledQuestionBankRepository repository = BundledQuestionBankRepository();
    final QuestionBank grade1Pack = await repository.loadPack(
      'assets/questions/geometry/grade1_foundation.geometry.v1.json',
    );
    final QuestionBank grade2Pack = await repository.loadPack(
      'assets/questions/geometry/grade2_foundation.geometry.v1.json',
    );
    final QuestionBank grade3Pack = await repository.loadPack(
      'assets/questions/geometry/grade3_foundation.geometry.v1.json',
    );
    final QuestionBank grade4Pack = await repository.loadPack(
      'assets/questions/geometry/grade4_foundation.geometry.v1.json',
    );
    final QuestionBank grade5Pack = await repository.loadPack(
      'assets/questions/geometry/grade5_foundation.geometry.v1.json',
    );
    final QuestionBank grade6Pack = await repository.loadPack(
      'assets/questions/geometry/grade6_foundation.geometry.v1.json',
    );

    expect(
      grade1Pack.questions.any(
        (question) => question.id == 'geometry_grade1_foundation_044',
      ),
      isTrue,
    );
    expect(
      grade2Pack.questions.any(
        (question) => question.id == 'geometry_grade2_foundation_044',
      ),
      isTrue,
    );
    expect(
      grade3Pack.questions.any(
        (question) => question.id == 'geometry_grade3_foundation_046',
      ),
      isTrue,
    );
    expect(
      grade4Pack.questions.any(
        (question) => question.id == 'geometry_grade4_foundation_044',
      ),
      isTrue,
    );
    expect(
      grade5Pack.questions.any(
        (question) => question.id == 'geometry_grade5_foundation_044',
      ),
      isTrue,
    );
    expect(
      grade6Pack.questions.any(
        (question) => question.id == 'geometry_grade6_foundation_046',
      ),
      isTrue,
    );
  });

  test('grade4 arithmetic pack includes multiple four-language olympiad-style questions',
      () async {
    TestWidgetsFlutterBinding.ensureInitialized();

    final BundledQuestionBankRepository repository = BundledQuestionBankRepository();
    final QuestionBank grade4Pack = await repository.loadPack(
      'assets/questions/arithmetic/grade4_foundation.arithmetic.v1.json',
    );

    expect(grade4Pack.questions.length, greaterThanOrEqualTo(10));
    expect(
      grade4Pack.questions.first.prompt.keys,
      containsAll(<String>['zh-Hant', 'zh-Hans', 'en', 'ja']),
    );
    expect(
      grade4Pack.questions[1].prompt.keys,
      containsAll(<String>['zh-Hant', 'zh-Hans', 'en', 'ja']),
    );
    expect(
      grade4Pack.questions.first.source?.type,
      'rewritten_olympiad_style',
    );
  });

  test('grade3 arithmetic pack includes multiple four-language olympiad-style questions',
      () async {
    TestWidgetsFlutterBinding.ensureInitialized();

    final BundledQuestionBankRepository repository = BundledQuestionBankRepository();
    final QuestionBank grade3Pack = await repository.loadPack(
      'assets/questions/arithmetic/grade3_foundation.arithmetic.v1.json',
    );

    expect(grade3Pack.questions.length, greaterThanOrEqualTo(10));
    expect(
      grade3Pack.questions.first.prompt.keys,
      containsAll(<String>['zh-Hant', 'zh-Hans', 'en', 'ja']),
    );
    expect(
      grade3Pack.questions[1].prompt.keys,
      containsAll(<String>['zh-Hant', 'zh-Hans', 'en', 'ja']),
    );
    expect(
      grade3Pack.questions.first.source?.type,
      'rewritten_olympiad_style',
    );
  });

  test('grade1 arithmetic pack includes multiple four-language olympiad-style questions',
      () async {
    TestWidgetsFlutterBinding.ensureInitialized();

    final BundledQuestionBankRepository repository = BundledQuestionBankRepository();
    final QuestionBank grade1Pack = await repository.loadPack(
      'assets/questions/arithmetic/grade1_foundation.arithmetic.v1.json',
    );

    expect(grade1Pack.questions.length, greaterThanOrEqualTo(10));
    expect(
      grade1Pack.questions.first.prompt.keys,
      containsAll(<String>['zh-Hant', 'zh-Hans', 'en', 'ja']),
    );
    expect(
      grade1Pack.questions[1].prompt.keys,
      containsAll(<String>['zh-Hant', 'zh-Hans', 'en', 'ja']),
    );
    expect(
      grade1Pack.questions.first.source?.type,
      'rewritten_olympiad_style',
    );
  });

  test('grade2 arithmetic pack includes multiple four-language olympiad-style questions',
      () async {
    TestWidgetsFlutterBinding.ensureInitialized();

    final BundledQuestionBankRepository repository = BundledQuestionBankRepository();
    final QuestionBank grade2Pack = await repository.loadPack(
      'assets/questions/arithmetic/grade2_foundation.arithmetic.v1.json',
    );

    expect(grade2Pack.questions.length, greaterThanOrEqualTo(10));
    expect(
      grade2Pack.questions.first.prompt.keys,
      containsAll(<String>['zh-Hant', 'zh-Hans', 'en', 'ja']),
    );
    expect(
      grade2Pack.questions[1].prompt.keys,
      containsAll(<String>['zh-Hant', 'zh-Hans', 'en', 'ja']),
    );
    expect(
      grade2Pack.questions.first.source?.type,
      'rewritten_olympiad_style',
    );
  });

  test('grade5 arithmetic pack includes multiple four-language olympiad-style questions',
      () async {
    TestWidgetsFlutterBinding.ensureInitialized();

    final BundledQuestionBankRepository repository = BundledQuestionBankRepository();
    final QuestionBank grade5Pack = await repository.loadPack(
      'assets/questions/arithmetic/grade5_foundation.arithmetic.v1.json',
    );

    expect(grade5Pack.questions.length, greaterThanOrEqualTo(10));
    expect(
      grade5Pack.questions.first.prompt.keys,
      containsAll(<String>['zh-Hant', 'zh-Hans', 'en', 'ja']),
    );
    expect(
      grade5Pack.questions[1].prompt.keys,
      containsAll(<String>['zh-Hant', 'zh-Hans', 'en', 'ja']),
    );
    expect(
      grade5Pack.questions.first.source?.type,
      'rewritten_olympiad_style',
    );
  });

  test('grade6 arithmetic pack includes multiple four-language olympiad-style questions',
      () async {
    TestWidgetsFlutterBinding.ensureInitialized();

    final BundledQuestionBankRepository repository = BundledQuestionBankRepository();
    final QuestionBank grade6Pack = await repository.loadPack(
      'assets/questions/arithmetic/grade6_foundation.arithmetic.v1.json',
    );

    expect(grade6Pack.questions.length, greaterThanOrEqualTo(10));
    expect(
      grade6Pack.questions.first.prompt.keys,
      containsAll(<String>['zh-Hant', 'zh-Hans', 'en', 'ja']),
    );
    expect(
      grade6Pack.questions[1].prompt.keys,
      containsAll(<String>['zh-Hant', 'zh-Hans', 'en', 'ja']),
    );
    expect(
      grade6Pack.questions.first.source?.type,
      'rewritten_olympiad_style',
    );
  });

  test('all logic packs include multiple four-language olympiad-style questions',
      () async {
    TestWidgetsFlutterBinding.ensureInitialized();

    final BundledQuestionBankRepository repository = BundledQuestionBankRepository();
    const List<String> logicPaths = <String>[
      'assets/questions/logic/grade1_foundation.logic.v1.json',
      'assets/questions/logic/grade2_foundation.logic.v1.json',
      'assets/questions/logic/grade3_foundation.logic.v1.json',
      'assets/questions/logic/grade4_foundation.logic.v1.json',
      'assets/questions/logic/grade5_foundation.logic.v1.json',
      'assets/questions/logic/grade6_foundation.logic.v1.json',
    ];

    for (final String path in logicPaths) {
      final QuestionBank pack = await repository.loadPack(path);

      expect(pack.questions.length, greaterThanOrEqualTo(10), reason: path);
      expect(
        pack.questions.first.prompt.keys,
        containsAll(<String>['zh-Hant', 'zh-Hans', 'en', 'ja']),
        reason: path,
      );
      expect(
        pack.questions[1].prompt.keys,
        containsAll(<String>['zh-Hant', 'zh-Hans', 'en', 'ja']),
        reason: path,
      );
      expect(
        pack.questions.first.source?.type,
        'rewritten_olympiad_style',
        reason: path,
      );
    }
  });

  test('logic packs provide expanded practice depth across grades', () async {
    TestWidgetsFlutterBinding.ensureInitialized();

    const Map<String, int> minimumCounts = <String, int>{
      'assets/questions/logic/grade1_foundation.logic.v1.json': 22,
      'assets/questions/logic/grade2_foundation.logic.v1.json': 22,
      'assets/questions/logic/grade3_foundation.logic.v1.json': 24,
      'assets/questions/logic/grade4_foundation.logic.v1.json': 22,
      'assets/questions/logic/grade5_foundation.logic.v1.json': 22,
      'assets/questions/logic/grade6_foundation.logic.v1.json': 25,
    };

    for (final MapEntry<String, int> entry in minimumCounts.entries) {
      final String rawJson = await rootBundle.loadString(entry.key);
      final Map<String, dynamic> decoded = jsonDecode(rawJson) as Map<String, dynamic>;
      final QuestionBank bank = QuestionBank.fromJson(decoded);

      expect(
        bank.questions.length,
        greaterThanOrEqualTo(entry.value),
        reason: '${entry.key} should contain at least ${entry.value} logic questions',
      );
    }
  });

  test('arithmetic packs provide expanded olympiad-style depth across grades',
      () async {
    TestWidgetsFlutterBinding.ensureInitialized();

    const Map<String, int> minimumCounts = <String, int>{
      'assets/questions/arithmetic/grade1_foundation.arithmetic.v1.json': 32,
      'assets/questions/arithmetic/grade2_foundation.arithmetic.v1.json': 32,
      'assets/questions/arithmetic/grade3_foundation.arithmetic.v1.json': 35,
      'assets/questions/arithmetic/grade4_foundation.arithmetic.v1.json': 32,
      'assets/questions/arithmetic/grade5_foundation.arithmetic.v1.json': 32,
      'assets/questions/arithmetic/grade6_foundation.arithmetic.v1.json': 36,
    };

    for (final MapEntry<String, int> entry in minimumCounts.entries) {
      final String rawJson = await rootBundle.loadString(entry.key);
      final Map<String, dynamic> decoded = jsonDecode(rawJson) as Map<String, dynamic>;
      final QuestionBank bank = QuestionBank.fromJson(decoded);

      expect(
        bank.questions.length,
        greaterThanOrEqualTo(entry.value),
        reason: '${entry.key} should contain at least ${entry.value} arithmetic questions',
      );
    }
  });

  test('grade1 packs include the first official IMC 2015 preliminary batch',
      () async {
    TestWidgetsFlutterBinding.ensureInitialized();

    final BundledQuestionBankRepository repository = BundledQuestionBankRepository();
    final QuestionBank arithmeticPack = await repository.loadPack(
      'assets/questions/arithmetic/grade1_foundation.arithmetic.v1.json',
    );
    final QuestionBank logicPack = await repository.loadPack(
      'assets/questions/logic/grade1_foundation.logic.v1.json',
    );

    Question findQuestion(QuestionBank pack, String id) =>
        pack.questions.firstWhere((Question question) => question.id == id);

    final Question arithmeticQuestion = findQuestion(
      arithmeticPack,
      'arithmetic_grade1_foundation_051',
    );
    final Question logicQuestion = findQuestion(
      logicPack,
      'logic_grade1_foundation_041',
    );

    expect(arithmeticQuestion.source?.type, 'official_reference');
    expect(
      arithmeticQuestion.source?.contest,
      '第16屆IMC國際數學競賽台灣區初賽',
    );
    expect(arithmeticQuestion.source?.year, '2015');
    expect(arithmeticQuestion.source?.problemNumber, '選擇 3');
    expect(logicQuestion.source?.type, 'official_reference');
    expect(logicQuestion.source?.division, '國小一年級');
    expect(
      logicQuestion.source?.sourceUrl,
      'https://www.imcct.net/UserFiles/files/%E4%B8%80%E5%B9%B4%E7%B4%9A%E8%A9%A6%E9%A1%8C+%E8%A7%A3%E7%AD%94%E5%8D%B7.pdf',
    );
  });

  test('grade1 packs include the second official IMC 2015 preliminary batch',
      () async {
    TestWidgetsFlutterBinding.ensureInitialized();

    final BundledQuestionBankRepository repository = BundledQuestionBankRepository();
    final QuestionBank arithmeticPack = await repository.loadPack(
      'assets/questions/arithmetic/grade1_foundation.arithmetic.v1.json',
    );
    final QuestionBank logicPack = await repository.loadPack(
      'assets/questions/logic/grade1_foundation.logic.v1.json',
    );

    Question findQuestion(QuestionBank pack, String id) =>
        pack.questions.firstWhere((Question question) => question.id == id);

    final Question arithmeticQuestion = findQuestion(
      arithmeticPack,
      'arithmetic_grade1_foundation_058',
    );
    final Question logicQuestion = findQuestion(
      logicPack,
      'logic_grade1_foundation_044',
    );

    expect(arithmeticQuestion.source?.type, 'official_reference');
    expect(arithmeticQuestion.source?.problemNumber, '計算 2');
    expect(logicQuestion.source?.type, 'official_reference');
    expect(logicQuestion.source?.problemNumber, '計算 4');
    expect(logicQuestion.source?.year, '2015');
  });

  test('grade1 packs include the third official IMC 2015 preliminary batch',
      () async {
    TestWidgetsFlutterBinding.ensureInitialized();

    final BundledQuestionBankRepository repository = BundledQuestionBankRepository();
    final QuestionBank arithmeticPack = await repository.loadPack(
      'assets/questions/arithmetic/grade1_foundation.arithmetic.v1.json',
    );
    final QuestionBank logicPack = await repository.loadPack(
      'assets/questions/logic/grade1_foundation.logic.v1.json',
    );

    Question findQuestion(QuestionBank pack, String id) =>
        pack.questions.firstWhere((Question question) => question.id == id);

    final Question arithmeticQuestion = findQuestion(
      arithmeticPack,
      'arithmetic_grade1_foundation_062',
    );
    final Question logicQuestion = findQuestion(
      logicPack,
      'logic_grade1_foundation_047',
    );

    expect(arithmeticQuestion.source?.type, 'official_reference');
    expect(arithmeticQuestion.source?.problemNumber, '挑戰 3');
    expect(logicQuestion.source?.type, 'official_reference');
    expect(logicQuestion.source?.problemNumber, '計算 8(2)');
  });

  test('grade2 packs include the first official IMC 2015 preliminary batch',
      () async {
    TestWidgetsFlutterBinding.ensureInitialized();

    final BundledQuestionBankRepository repository = BundledQuestionBankRepository();
    final QuestionBank arithmeticPack = await repository.loadPack(
      'assets/questions/arithmetic/grade2_foundation.arithmetic.v1.json',
    );
    final QuestionBank logicPack = await repository.loadPack(
      'assets/questions/logic/grade2_foundation.logic.v1.json',
    );

    Question findQuestion(QuestionBank pack, String id) =>
        pack.questions.firstWhere((Question question) => question.id == id);

    final Question arithmeticQuestion = findQuestion(
      arithmeticPack,
      'arithmetic_grade2_foundation_051',
    );
    final Question arithmeticQuestion2 = findQuestion(
      arithmeticPack,
      'arithmetic_grade2_foundation_068',
    );
    final Question logicQuestion = findQuestion(
      logicPack,
      'logic_grade2_foundation_041',
    );

    expect(arithmeticQuestion.source?.type, 'official_reference');
    expect(arithmeticQuestion.source?.problemNumber, '選擇 1');
    expect(arithmeticQuestion2.source?.problemNumber, '選擇 25');
    expect(logicQuestion.source?.type, 'official_reference');
    expect(logicQuestion.source?.problemNumber, '計算 2');
    expect(logicQuestion.source?.year, '2015');
  });

  test('grade3 packs include the first official IMC 2015 preliminary batch',
      () async {
    TestWidgetsFlutterBinding.ensureInitialized();

    final BundledQuestionBankRepository repository = BundledQuestionBankRepository();
    final QuestionBank arithmeticPack = await repository.loadPack(
      'assets/questions/arithmetic/grade3_foundation.arithmetic.v1.json',
    );
    final QuestionBank logicPack = await repository.loadPack(
      'assets/questions/logic/grade3_foundation.logic.v1.json',
    );

    Question findQuestion(QuestionBank pack, String id) =>
        pack.questions.firstWhere((Question question) => question.id == id);

    final Question arithmeticQuestion = findQuestion(
      arithmeticPack,
      'arithmetic_grade3_foundation_054',
    );
    final Question arithmeticQuestion2 = findQuestion(
      arithmeticPack,
      'arithmetic_grade3_foundation_072',
    );
    final Question logicQuestion = findQuestion(
      logicPack,
      'logic_grade3_foundation_043',
    );

    expect(arithmeticQuestion.source?.type, 'official_reference');
    expect(arithmeticQuestion.source?.problemNumber, '選擇 1');
    expect(arithmeticQuestion2.source?.problemNumber, '計算 3');
    expect(logicQuestion.source?.type, 'official_reference');
    expect(logicQuestion.source?.problemNumber, '選擇 23');
    expect(logicQuestion.source?.year, '2015');
  });

  test('grade4 packs include the first official IMC 2015 preliminary batch',
      () async {
    TestWidgetsFlutterBinding.ensureInitialized();

    final BundledQuestionBankRepository repository = BundledQuestionBankRepository();
    final QuestionBank arithmeticPack = await repository.loadPack(
      'assets/questions/arithmetic/grade4_foundation.arithmetic.v1.json',
    );

    Question findQuestion(QuestionBank pack, String id) =>
        pack.questions.firstWhere((Question question) => question.id == id);

    final Question arithmeticQuestion = findQuestion(
      arithmeticPack,
      'arithmetic_grade4_foundation_051',
    );
    final Question arithmeticQuestion2 = findQuestion(
      arithmeticPack,
      'arithmetic_grade4_foundation_071',
    );

    expect(arithmeticQuestion.source?.type, 'official_reference');
    expect(arithmeticQuestion.source?.problemNumber, '選擇 1');
    expect(arithmeticQuestion2.source?.problemNumber, '選擇 25');
    expect(arithmeticQuestion.source?.year, '2015');
  });

  test('grade5 packs include the first official IMC 2015 preliminary batch',
      () async {
    TestWidgetsFlutterBinding.ensureInitialized();

    final BundledQuestionBankRepository repository = BundledQuestionBankRepository();
    final QuestionBank arithmeticPack = await repository.loadPack(
      'assets/questions/arithmetic/grade5_foundation.arithmetic.v1.json',
    );
    final QuestionBank logicPack = await repository.loadPack(
      'assets/questions/logic/grade5_foundation.logic.v1.json',
    );

    Question findQuestion(QuestionBank pack, String id) =>
        pack.questions.firstWhere((Question question) => question.id == id);

    final Question arithmeticQuestion = findQuestion(
      arithmeticPack,
      'arithmetic_grade5_foundation_051',
    );
    final Question arithmeticQuestion2 = findQuestion(
      arithmeticPack,
      'arithmetic_grade5_foundation_062',
    );
    final Question logicQuestion = findQuestion(
      logicPack,
      'logic_grade5_foundation_041',
    );

    expect(arithmeticQuestion.source?.type, 'official_reference');
    expect(arithmeticQuestion.source?.problemNumber, '選擇 1');
    expect(arithmeticQuestion2.source?.problemNumber, '選擇 21');
    expect(logicQuestion.source?.type, 'official_reference');
    expect(logicQuestion.source?.problemNumber, '選擇 24');
    expect(logicQuestion.source?.year, '2015');
  });

  test('grade6 packs include the next official IMC 2015 preliminary batch',
      () async {
    TestWidgetsFlutterBinding.ensureInitialized();

    final BundledQuestionBankRepository repository = BundledQuestionBankRepository();
    final QuestionBank arithmeticPack = await repository.loadPack(
      'assets/questions/arithmetic/grade6_foundation.arithmetic.v1.json',
    );
    final QuestionBank logicPack = await repository.loadPack(
      'assets/questions/logic/grade6_foundation.logic.v1.json',
    );

    Question findQuestion(QuestionBank pack, String id) =>
        pack.questions.firstWhere((Question question) => question.id == id);

    final Question arithmeticQuestion = findQuestion(
      arithmeticPack,
      'arithmetic_grade6_foundation_055',
    );
    final Question arithmeticQuestion2 = findQuestion(
      arithmeticPack,
      'arithmetic_grade6_foundation_061',
    );
    final Question logicQuestion = findQuestion(
      logicPack,
      'logic_grade6_foundation_045',
    );

    expect(arithmeticQuestion.source?.type, 'official_reference');
    expect(arithmeticQuestion.source?.problemNumber, '選擇 5');
    expect(arithmeticQuestion2.source?.problemNumber, '選擇 20');
    expect(logicQuestion.source?.type, 'official_reference');
    expect(logicQuestion.source?.problemNumber, '選擇 3');
    expect(logicQuestion.source?.year, '2015');
  });

  test('grade6 packs include the follow-up official IMC 2015 preliminary batch',
      () async {
    TestWidgetsFlutterBinding.ensureInitialized();

    final BundledQuestionBankRepository repository = BundledQuestionBankRepository();
    final QuestionBank arithmeticPack = await repository.loadPack(
      'assets/questions/arithmetic/grade6_foundation.arithmetic.v1.json',
    );
    final QuestionBank logicPack = await repository.loadPack(
      'assets/questions/logic/grade6_foundation.logic.v1.json',
    );

    Question findQuestion(QuestionBank pack, String id) =>
        pack.questions.firstWhere((Question question) => question.id == id);

    final Question arithmeticQuestion = findQuestion(
      arithmeticPack,
      'arithmetic_grade6_foundation_062',
    );
    final Question arithmeticQuestion2 = findQuestion(
      arithmeticPack,
      'arithmetic_grade6_foundation_063',
    );
    final Question logicQuestion = findQuestion(
      logicPack,
      'logic_grade6_foundation_047',
    );
    final Question logicQuestion2 = findQuestion(
      logicPack,
      'logic_grade6_foundation_048',
    );

    expect(arithmeticQuestion.source?.type, 'official_reference');
    expect(arithmeticQuestion.source?.problemNumber, '選擇 1');
    expect(arithmeticQuestion2.source?.problemNumber, '選擇 22');
    expect(logicQuestion.source?.problemNumber, '選擇 21');
    expect(logicQuestion2.source?.problemNumber, '選擇 24');
    expect(logicQuestion2.source?.year, '2015');
  });

  test('grade6 arithmetic pack includes official IMC 2015 calculation input question',
      () async {
    TestWidgetsFlutterBinding.ensureInitialized();

    final BundledQuestionBankRepository repository = BundledQuestionBankRepository();
    final QuestionBank arithmeticPack = await repository.loadPack(
      'assets/questions/arithmetic/grade6_foundation.arithmetic.v1.json',
    );

    final Question question = arithmeticPack.questions.firstWhere(
      (Question item) => item.id == 'arithmetic_grade6_foundation_064',
    );

    expect(question.source?.type, 'official_reference');
    expect(question.source?.problemNumber, '計算 1');
    expect(question.answerMode, AnswerMode.integerInput);
    expect(question.correctAnswer.type, 'integer');
    expect(question.correctAnswer.value, '145');
  });

  test('grade7 packs load with olympiad taxonomy metadata', () async {
    TestWidgetsFlutterBinding.ensureInitialized();

    final BundledQuestionBankRepository repository = BundledQuestionBankRepository();
    final BundledQuestionManifest manifest = await repository.loadManifest();

    final BundledQuestionPackInfo grade7AlgebraPack = manifest.packs.firstWhere(
      (BundledQuestionPackInfo pack) =>
          pack.path == 'assets/questions/algebra/grade7_foundation.algebra.v1.json',
    );

    final String rawGrade7Pack = await rootBundle.loadString(
      grade7AlgebraPack.path,
    );
    final Map<String, dynamic> decodedGrade7Pack =
        jsonDecode(rawGrade7Pack) as Map<String, dynamic>;
    final String rawLegacyPack = await rootBundle.loadString(
      'assets/questions/arithmetic/grade1_foundation.arithmetic.v1.json',
    );
    final Map<String, dynamic> decodedLegacyPack =
        jsonDecode(rawLegacyPack) as Map<String, dynamic>;
    final Map<String, dynamic> legacyQuestion = Map<String, dynamic>.from(
      (decodedLegacyPack['questions'] as List<dynamic>).first as Map,
    );

    expect(grade7AlgebraPack.levelStage, 'grade7');
    expect(decodedGrade7Pack['topicCode'], 'algebra');
    expect(decodedGrade7Pack['olympiadTopicCode'], 'algebra');
    expect(decodedGrade7Pack['olympiadTopic'], '代數');
    expect(legacyQuestion['olympiadTaxonomy'], isA<Map<String, dynamic>>());
  });

  test('algebra packs include rewritten public competition sources', () async {
    TestWidgetsFlutterBinding.ensureInitialized();

    final BundledQuestionBankRepository repository = BundledQuestionBankRepository();
    final QuestionBank grade7Pack = await repository.loadPack(
      'assets/questions/algebra/grade7_foundation.algebra.v1.json',
    );
    final QuestionBank grade10Pack = await repository.loadPack(
      'assets/questions/algebra/grade10_foundation.algebra.v1.json',
    );
    final QuestionBank grade12Pack = await repository.loadPack(
      'assets/questions/algebra/grade12_foundation.algebra.v1.json',
    );

    // 002 為官方 IMC 填充 3；原本此處指向 009，但 009 與 002 完全重複，
    // 複審時已將 009 去重改寫為原創（rewritten_olympiad_style），故改用 002 驗證官方題源。
    final Question grade7Question = grade7Pack.questions.firstWhere(
      (Question item) => item.id == 'algebra_grade7_foundation_002',
    );
    // 007 為官方 IMC 選擇 6；原本此處指向 009，但 009 與 007 為同一題（只是答題方式不同），
    // 複審時已將 009 去重改寫為原創（rewritten_olympiad_style），故改用 007 驗證官方題源。
    final Question grade10Question = grade10Pack.questions.firstWhere(
      (Question item) => item.id == 'algebra_grade10_foundation_007',
    );
    final Question grade12Question = grade12Pack.questions.firstWhere(
      (Question item) => item.id == 'algebra_grade12_foundation_009',
    );

    expect(grade7Question.source?.type, 'official_reference');
    expect(grade7Question.source?.contest, contains('IMC Taiwan'));
    expect(grade7Question.source?.year, '2026');
    expect(grade7Question.source?.problemNumber, '填充 3');
    expect(grade7Question.localizedPrompt('zh-Hant'), isNotEmpty);

    expect(grade10Question.source?.type, 'official_reference');
    expect(grade10Question.source?.contest, contains('IMC Taiwan'));
    expect(grade10Question.source?.year, '2026');
    expect(grade10Question.source?.problemNumber, '選擇 6');

    expect(grade12Question.source?.type, 'official_reference');
    expect(grade12Question.source?.contest, contains('AMC 12'));
    expect(grade12Question.source?.year, '2000');
    expect(grade12Question.source?.problemNumber, 'Problem 12');
    expect(grade12Question.localizedPrompt('en'), isNotEmpty);
  });

  test('geometry packs upgrade high-value condition diagrams to geometry_scene',
      () async {
    TestWidgetsFlutterBinding.ensureInitialized();

    final BundledQuestionBankRepository repository = BundledQuestionBankRepository();
    final QuestionBank grade9Pack = await repository.loadPack(
      'assets/questions/geometry/grade9_foundation.geometry.v1.json',
    );
    final QuestionBank grade7Pack = await repository.loadPack(
      'assets/questions/geometry/grade7_foundation.geometry.v1.json',
    );
    final QuestionBank grade10Pack = await repository.loadPack(
      'assets/questions/geometry/grade10_foundation.geometry.v1.json',
    );
    final QuestionBank grade12Pack = await repository.loadPack(
      'assets/questions/geometry/grade12_foundation.geometry.v1.json',
    );

    final Question grade9Question = grade9Pack.questions.firstWhere(
      (Question item) => item.id == 'geometry_grade9_foundation_001',
    );
    final Question grade7Question = grade7Pack.questions.firstWhere(
      (Question item) => item.id == 'geometry_grade7_foundation_009',
    );
    final Question grade10CircleQuestion = grade10Pack.questions.firstWhere(
      (Question item) => item.id == 'geometry_grade10_foundation_004',
    );
    final Question grade10MedianQuestion = grade10Pack.questions.firstWhere(
      (Question item) => item.id == 'geometry_grade10_foundation_006',
    );
    final Question grade12InscribedAngleQuestion = grade12Pack.questions.firstWhere(
      (Question item) => item.id == 'geometry_grade12_foundation_004',
    );
    final Question grade12ChordQuestion = grade12Pack.questions.firstWhere(
      (Question item) => item.id == 'geometry_grade12_foundation_006',
    );

    expect(grade9Question.source?.type, 'official_reference');
    expect(grade9Question.figure.kind, 'geometry_scene');

    expect(grade7Question.source?.type, 'official_reference');
    expect(grade7Question.source?.contest, contains('AMC 8'));
    // Q009 已把舊的 shape_diagram（形狀＋貼字）換成宣告式 geometry_scene 向量圖。
    expect(grade7Question.figure.kind, 'geometry_scene');
    expect(grade7Question.source?.year, '2018');
    expect(grade7Question.source?.problemNumber, 'Problem 22');

    expect(grade10CircleQuestion.figure.kind, 'geometry_scene');

    expect(grade10MedianQuestion.figure.kind, 'geometry_scene');

    expect(grade12InscribedAngleQuestion.figure.kind, 'geometry_scene');

    expect(grade12ChordQuestion.figure.kind, 'geometry_scene');
  });

  test('geometry packs upgrade the next condition-heavy diagrams to geometry_scene',
      () async {
    TestWidgetsFlutterBinding.ensureInitialized();

    final BundledQuestionBankRepository repository = BundledQuestionBankRepository();
    final QuestionBank grade9Pack = await repository.loadPack(
      'assets/questions/geometry/grade9_foundation.geometry.v1.json',
    );
    final QuestionBank grade10Pack = await repository.loadPack(
      'assets/questions/geometry/grade10_foundation.geometry.v1.json',
    );

    final Question grade9CircumradiusQuestion = grade9Pack.questions.firstWhere(
      (Question item) => item.id == 'geometry_grade9_foundation_005',
    );
    final Question grade9MedianQuestion = grade9Pack.questions.firstWhere(
      (Question item) => item.id == 'geometry_grade9_foundation_006',
    );
    final Question grade9ExternalPointQuestion = grade9Pack.questions.firstWhere(
      (Question item) => item.id == 'geometry_grade9_foundation_007',
    );
    final Question grade10PowerQuestion = grade10Pack.questions.firstWhere(
      (Question item) => item.id == 'geometry_grade10_foundation_005',
    );

    expect(grade9CircumradiusQuestion.figure.kind, 'geometry_scene');
    expect(grade9MedianQuestion.figure.kind, 'geometry_scene');
    expect(grade9ExternalPointQuestion.figure.kind, 'geometry_scene');
    expect(grade10PowerQuestion.figure.kind, 'geometry_scene');
  });

  test('geometry packs upgrade advanced circle and polygon condition diagrams',
      () async {
    TestWidgetsFlutterBinding.ensureInitialized();

    final BundledQuestionBankRepository repository = BundledQuestionBankRepository();
    final QuestionBank grade10Pack = await repository.loadPack(
      'assets/questions/geometry/grade10_foundation.geometry.v1.json',
    );
    final QuestionBank grade11Pack = await repository.loadPack(
      'assets/questions/geometry/grade11_foundation.geometry.v1.json',
    );

    final Question grade10IncenterCircumcenterQuestion =
        grade10Pack.questions.firstWhere(
      (Question item) => item.id == 'geometry_grade10_foundation_009',
    );
    final Question grade10SquareEquilateralQuestion =
        grade10Pack.questions.firstWhere(
      (Question item) => item.id == 'geometry_grade10_foundation_010',
    );
    final Question grade11TangentArcAngleQuestion =
        grade11Pack.questions.firstWhere(
      (Question item) => item.id == 'geometry_grade11_foundation_008',
    );

    expect(grade10IncenterCircumcenterQuestion.figure.kind, 'geometry_scene');
    expect(grade10SquareEquilateralQuestion.figure.kind, 'geometry_scene');
    expect(grade11TangentArcAngleQuestion.figure.kind, 'geometry_scene');
  });

  test('geometry packs upgrade nested square and tangent-circle diagrams',
      () async {
    TestWidgetsFlutterBinding.ensureInitialized();

    final BundledQuestionBankRepository repository = BundledQuestionBankRepository();
    final QuestionBank grade11Pack = await repository.loadPack(
      'assets/questions/geometry/grade11_foundation.geometry.v1.json',
    );
    final QuestionBank grade12Pack = await repository.loadPack(
      'assets/questions/geometry/grade12_foundation.geometry.v1.json',
    );

    final Question grade11ConcentricSquareQuestion =
        grade11Pack.questions.firstWhere(
      (Question item) => item.id == 'geometry_grade11_foundation_007',
    );
    final Question grade12NestedSquareQuestion =
        grade12Pack.questions.firstWhere(
      (Question item) => item.id == 'geometry_grade12_foundation_007',
    );
    final Question grade12SectorCircleQuestion =
        grade12Pack.questions.firstWhere(
      (Question item) => item.id == 'geometry_grade12_foundation_009',
    );

    expect(grade11ConcentricSquareQuestion.figure.kind, 'geometry_scene');
    expect(grade12NestedSquareQuestion.figure.kind, 'geometry_scene');
    expect(grade12SectorCircleQuestion.figure.kind, 'geometry_scene');
  });

  test('geometry packs upgrade the final directly-renderable olympiad diagrams',
      () async {
    TestWidgetsFlutterBinding.ensureInitialized();

    final BundledQuestionBankRepository repository = BundledQuestionBankRepository();
    final QuestionBank grade9Pack = await repository.loadPack(
      'assets/questions/geometry/grade9_foundation.geometry.v1.json',
    );
    final QuestionBank grade12Pack = await repository.loadPack(
      'assets/questions/geometry/grade12_foundation.geometry.v1.json',
    );

    final Question grade9CircleTriangleQuestion =
        grade9Pack.questions.firstWhere(
      (Question item) => item.id == 'geometry_grade9_foundation_002',
    );
    final Question grade12ArcTangentCircleQuestion =
        grade12Pack.questions.firstWhere(
      (Question item) => item.id == 'geometry_grade12_foundation_008',
    );
    final Question grade12PentagonAreaQuestion =
        grade12Pack.questions.firstWhere(
      (Question item) => item.id == 'geometry_grade12_foundation_010',
    );

    expect(grade9CircleTriangleQuestion.figure.kind, 'geometry_scene');
    expect(grade12ArcTangentCircleQuestion.figure.kind, 'geometry_scene');
    expect(grade12PentagonAreaQuestion.figure.kind, 'geometry_scene');
  });

  test('geometry packs upgrade the remaining trapezoid-condition diagrams',
      () async {
    TestWidgetsFlutterBinding.ensureInitialized();

    final BundledQuestionBankRepository repository = BundledQuestionBankRepository();
    final QuestionBank grade12Pack = await repository.loadPack(
      'assets/questions/geometry/grade12_foundation.geometry.v1.json',
    );

    final Question grade12TrapezoidLineQuestion =
        grade12Pack.questions.firstWhere(
      (Question item) => item.id == 'geometry_grade12_foundation_002',
    );
    final Question grade12TrapezoidDiagonalQuestion =
        grade12Pack.questions.firstWhere(
      (Question item) => item.id == 'geometry_grade12_foundation_003',
    );

    expect(grade12TrapezoidLineQuestion.figure.kind, 'geometry_scene');
    expect(grade12TrapezoidDiagonalQuestion.figure.kind, 'geometry_scene');
  });

  test('number theory packs include rewritten public competition sources',
      () async {
    TestWidgetsFlutterBinding.ensureInitialized();

    final BundledQuestionBankRepository repository = BundledQuestionBankRepository();
    final QuestionBank grade7Pack = await repository.loadPack(
      'assets/questions/number_theory/grade7_foundation.number_theory.v1.json',
    );
    final QuestionBank grade10Pack = await repository.loadPack(
      'assets/questions/number_theory/grade10_foundation.number_theory.v1.json',
    );
    final QuestionBank grade12Pack = await repository.loadPack(
      'assets/questions/number_theory/grade12_foundation.number_theory.v1.json',
    );

    final Question grade7Question = grade7Pack.questions.firstWhere(
      (Question item) => item.id == 'number_theory_grade7_foundation_010',
    );
    final Question grade10Question = grade10Pack.questions.firstWhere(
      (Question item) => item.id == 'number_theory_grade10_foundation_010',
    );
    final Question grade12Question = grade12Pack.questions.firstWhere(
      (Question item) => item.id == 'number_theory_grade12_foundation_010',
    );

    expect(grade7Question.source?.type, 'official_reference');
    expect(grade7Question.source?.contest, contains('IMC'));
    expect(grade7Question.source?.year, '2026');
    expect(grade7Question.source?.problemNumber, '選擇 8');

    expect(grade10Question.source?.type, 'official_reference');
    expect(grade10Question.source?.contest, contains('AMC 10'));
    expect(grade10Question.source?.year, '2014');
    expect(grade10Question.source?.problemNumber, 'Problem 20');

    expect(grade12Question.source?.type, 'official_reference');
    expect(grade12Question.source?.contest, contains('AMC 12'));
    expect(grade12Question.source?.year, '2021');
    expect(grade12Question.source?.problemNumber, 'Problem 25');
    expect(grade12Question.localizedPrompt('en'), isNotEmpty);
  });

  test('combinatorics packs include rewritten public competition sources',
      () async {
    TestWidgetsFlutterBinding.ensureInitialized();

    final BundledQuestionBankRepository repository = BundledQuestionBankRepository();
    final QuestionBank grade7Pack = await repository.loadPack(
      'assets/questions/combinatorics/grade7_foundation.combinatorics.v1.json',
    );
    final QuestionBank grade10Pack = await repository.loadPack(
      'assets/questions/combinatorics/grade10_foundation.combinatorics.v1.json',
    );
    final QuestionBank grade12Pack = await repository.loadPack(
      'assets/questions/combinatorics/grade12_foundation.combinatorics.v1.json',
    );

    final Question grade7Question = grade7Pack.questions.firstWhere(
      (Question item) => item.id == 'combinatorics_grade7_foundation_009',
    );
    final Question grade10Question = grade10Pack.questions.firstWhere(
      (Question item) => item.id == 'combinatorics_grade10_foundation_009',
    );
    final Question grade12Question = grade12Pack.questions.firstWhere(
      (Question item) => item.id == 'combinatorics_grade12_foundation_009',
    );

    expect(grade7Question.source?.type, 'official_reference');
    expect(grade7Question.source?.contest, contains('AMC 8'));
    expect(grade7Question.source?.year, '2020');
    expect(grade7Question.source?.problemNumber, 'Problem 10');

    expect(grade10Question.source?.type, 'official_reference');
    expect(grade10Question.source?.contest, contains('AMC 10'));
    expect(grade10Question.source?.year, '2021');
    expect(grade10Question.source?.problemNumber, 'Problem 21');

    expect(grade12Question.source?.type, 'official_reference');
    expect(grade12Question.source?.contest, contains('AMC 12'));
    expect(grade12Question.source?.year, '2008');
    expect(grade12Question.source?.problemNumber, 'Problem 21');
    expect(grade12Question.localizedPrompt('en'), isNotEmpty);
  });

  test('logic packs include rewritten public competition sources', () async {
    TestWidgetsFlutterBinding.ensureInitialized();

    final BundledQuestionBankRepository repository = BundledQuestionBankRepository();
    final QuestionBank grade7Pack = await repository.loadPack(
      'assets/questions/logic/grade7_foundation.logic.v1.json',
    );
    final QuestionBank grade10Pack = await repository.loadPack(
      'assets/questions/logic/grade10_foundation.logic.v1.json',
    );
    final QuestionBank grade12Pack = await repository.loadPack(
      'assets/questions/logic/grade12_foundation.logic.v1.json',
    );

    final Question grade7Question = grade7Pack.questions.firstWhere(
      (Question item) => item.id == 'logic_grade7_foundation_009',
    );
    final Question grade10Question = grade10Pack.questions.firstWhere(
      (Question item) => item.id == 'logic_grade10_foundation_009',
    );
    final Question grade12Question = grade12Pack.questions.firstWhere(
      (Question item) => item.id == 'logic_grade12_foundation_009',
    );

    expect(grade7Question.source?.type, 'official_reference');
    expect(grade7Question.source?.contest, contains('AMC 8'));
    expect(grade7Question.source?.year, '2004');
    expect(grade7Question.source?.problemNumber, 'Problem 13');

    expect(grade10Question.source?.type, 'official_reference');
    expect(grade10Question.source?.contest, contains('AMC 10'));
    expect(grade10Question.source?.year, '2010');
    expect(grade10Question.source?.problemNumber, 'Problem 15');

    expect(grade12Question.source?.type, 'official_reference');
    expect(grade12Question.source?.contest, contains('AMC 12'));
    expect(grade12Question.source?.year, '2021');
    expect(grade12Question.source?.problemNumber, 'Problem 22');
    expect(grade12Question.localizedPrompt('en'), isNotEmpty);
  });

  test('parses olympiad taxonomy metadata on packs and questions', () {
    final BundledQuestionPackInfo packInfo = BundledQuestionPackInfo.fromJson({
      'path': 'assets/questions/algebra/grade7_foundation.algebra.v1.json',
      'topic': '代數',
      'topicCode': 'algebra',
      'olympiadTopic': '代數',
      'olympiadTopicCode': 'algebra',
      'levelStage': 'grade7',
      'challengeTier': 'foundation',
      'questionCount': 5,
    });

    final Question question = Question.fromJson({
      'id': 'algebra_grade7_foundation_001',
      'topic': 'algebra',
      'difficulty': 'foundation',
      'levelStage': 'grade7',
      'challengeTier': 'foundation',
      'prompt': {
        'zh-Hant': '若 2x + 3 = 11，求 x。',
        'en': 'If 2x + 3 = 11, find x.',
      },
      'answer': {
        'zh-Hant': '答案是 4。',
        'en': 'The answer is 4.',
      },
      'solutionSteps': {
        'zh-Hant': ['先移項得到 2x = 8。', '再除以 2，所以 x = 4。'],
        'en': ['Move terms to get 2x = 8.', 'Divide by 2, so x = 4.'],
      },
      'figure': {
        'type': 'custom',
        'kind': 'none',
        'params': <String, dynamic>{},
      },
      'answerMode': 'integer_input',
      'correctAnswer': {
        'type': 'integer',
        'value': '4',
      },
      'olympiadTaxonomy': {
        'topic': '代數',
        'topicCode': 'algebra',
        'subtopic': '一元一次方程',
        'subtopicCode': 'linear_equation',
      },
    });

    expect(packInfo.olympiadTopic, '代數');
    expect(packInfo.olympiadTopicCode, 'algebra');
    expect(question.olympiadTaxonomy?.topic, '代數');
    expect(question.olympiadTaxonomy?.topicCode, 'algebra');
    expect(question.olympiadTaxonomy?.subtopicCode, 'linear_equation');
  });
}
