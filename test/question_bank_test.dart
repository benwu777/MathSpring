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

  test('competition profile groups grade ranges and filters matching packs', () async {
    TestWidgetsFlutterBinding.ensureInitialized();

    expect(competitionProfileIdForLevelStage('grade1'), kangaroo12ProfileId);
    expect(competitionProfileIdForLevelStage('grade4'), kangaroo34ProfileId);
    expect(competitionProfileIdForLevelStage('grade6'), kangaroo56ProfileId);

    final BundledQuestionBankRepository repository = BundledQuestionBankRepository();
    final BundledQuestionManifest manifest = await repository.loadManifest();
    final List<BundledQuestionPackInfo> groupedPacks =
        filterPacksForCompetitionProfile(
      manifest.packs,
      competitionProfileId: kangaroo34ProfileId,
      topicCode: 'geometry',
      challengeTier: 'foundation',
    );

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
    expect(manifest.packs, hasLength(20));
    expect(manifest.packs.first.topicCode, 'geometry');
    expect(manifest.packs.first.levelStage, 'grade4');
    expect(manifest.packs.first.questionCount, greaterThanOrEqualTo(10));
    expect(
      manifest.packs.every((pack) => pack.questionCount >= 10),
      isTrue,
    );
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

    expect(packs, hasLength(20));
    expect(packs.first.questions, isNotEmpty);
    expect(packs.last.questions, isNotEmpty);
    final int totalQuestions = packs
        .map((pack) => pack.questions.length)
        .fold(0, (sum, count) => sum + count);
    expect(totalQuestions, expectedTotalQuestions);
    expect(
      packs.every((pack) => pack.questions.length >= 10),
      isTrue,
    );
    final List<QuestionBank> geometryPacks = packs
        .where(
          (pack) => pack.questions.isNotEmpty &&
              pack.questions.every((question) => question.topic == 'geometry'),
        )
        .toList();
    expect(geometryPacks, hasLength(6));
    expect(
      geometryPacks.every((pack) => pack.questions.length >= 10),
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
}
