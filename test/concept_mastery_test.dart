import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mathspring/data/bundled/bundled_question_bank_repository.dart';
import 'package:mathspring/models/question.dart';
import 'package:mathspring/models/session_answer_record.dart';
import 'package:mathspring/services/concept_labels.dart';
import 'package:mathspring/services/concept_mastery.dart';
import 'package:mathspring/services/session_launch_plan_builder.dart';

SessionAnswerRecord _answer(String questionId, bool isCorrect, int sequence) =>
    SessionAnswerRecord(
      sessionId: 's1',
      questionId: questionId,
      sequence: sequence,
      submittedAnswer: '1',
      isCorrect: isCorrect,
      answeredAtIso: '2026-10-17T08:00:00Z',
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('questions expose only their concept tags', () async {
    final List<Question> questions = await BundledQuestionBankRepository()
        .loadQuestionsByIds(<String>['arithmetic_grade3_foundation_001']);

    expect(questions.single.conceptTags,
        <String>['c:modular', 'c:basic_counting']);
  });

  group('ConceptMastery', () {
    final Map<String, List<String>> tags = <String, List<String>>{
      'q1': <String>['c:fraction'],
      'q2': <String>['c:fraction', 'c:area'],
      'q3': <String>['c:area'],
      'q4': <String>['c:fraction'],
    };

    test('counts every attempt per concept', () {
      final ConceptMastery mastery = ConceptMastery.fromRecords(
        <SessionAnswerRecord>[
          _answer('q1', false, 1),
          _answer('q2', false, 2),
          _answer('q3', true, 3),
          _answer('q1', true, 4),
          _answer('unknown', false, 5),
        ],
        conceptTagsByQuestionId: tags,
      );

      expect(mastery.statsFor('c:fraction')!.attempts, 3);
      expect(mastery.statsFor('c:fraction')!.correct, 1);
      expect(mastery.statsFor('c:area')!.attempts, 2);
    });

    test('a concept is weak only after enough attempts with low accuracy', () {
      final ConceptMastery mastery = ConceptMastery.fromRecords(
        <SessionAnswerRecord>[
          _answer('q1', false, 1),
          _answer('q4', false, 2),
          _answer('q1', false, 3),
          _answer('q3', false, 4),
          _answer('q3', false, 5),
        ],
        conceptTagsByQuestionId: tags,
      );

      expect(mastery.weakConcepts, <String>['c:fraction'],
          reason: 'c:area 只答過 2 次，樣本不夠');
    });

    test('weak concepts are ordered by accuracy, lowest first', () {
      final ConceptMastery mastery = ConceptMastery.fromRecords(
        <SessionAnswerRecord>[
          for (int i = 0; i < 4; i += 1) _answer('q3', false, i),
          for (int i = 0; i < 4; i += 1) _answer('q1', i == 0, 10 + i),
        ],
        conceptTagsByQuestionId: tags,
      );

      expect(mastery.weakConcepts, <String>['c:area', 'c:fraction']);
    });

    test('a concept answered mostly right is not weak', () {
      final ConceptMastery mastery = ConceptMastery.fromRecords(
        <SessionAnswerRecord>[
          for (int i = 0; i < 5; i += 1) _answer('q1', i != 0, i),
        ],
        conceptTagsByQuestionId: tags,
      );

      expect(mastery.weakConcepts, isEmpty);
    });
  });

  test('weak-concept questions come up first more often', () async {
    final List<Question> pool = (await BundledQuestionBankRepository().loadPack(
            'assets/questions/arithmetic/grade3_foundation.arithmetic.v1.json'))
        .questions;
    const String weak = 'c:fraction';
    final List<Question> weakOnes =
        pool.where((Question q) => q.conceptTags.contains(weak)).toList();
    final List<Question> others =
        pool.where((Question q) => !q.conceptTags.contains(weak)).toList();
    final List<Question> sample = <Question>[
      ...weakOnes.take(2),
      ...others.take(8),
    ];

    int weakFirst = 0;
    const int trials = 2000;
    final math.Random random = math.Random(7);
    for (int i = 0; i < trials; i += 1) {
      final List<Question> ordered =
          SessionLaunchPlanBuilder.randomizeWithConceptWeights(
        sample,
        weakConcepts: const <String>{weak},
        random: random,
      );
      expect(ordered.toSet(), sample.toSet());
      if (ordered.first.conceptTags.contains(weak)) {
        weakFirst += 1;
      }
    }

    // 權重 3:1 時理論值 6/14 ≈ 0.43，沒加權時是 0.2
    expect(weakFirst / trials, closeTo(6 / 14, 0.05));
  });

  test('every concept tag in the vocabulary has four-language labels', () {
    final Map<String, dynamic> vocabulary =
        jsonDecode(File('docs/question-bank-tags.json').readAsStringSync())
            as Map<String, dynamic>;
    final Iterable<String> concepts =
        (vocabulary['tags'] as Map<String, dynamic>)
            .entries
            .where((MapEntry<String, dynamic> e) =>
                (e.value as Map<String, dynamic>)['facet'] == 'c')
            .map((MapEntry<String, dynamic> e) => e.key);

    for (final String concept in concepts) {
      for (final Locale locale in const <Locale>[
        Locale('zh', 'TW'),
        Locale('zh', 'CN'),
        Locale('en'),
        Locale('ja'),
      ]) {
        expect(conceptLabel(concept, locale), isNot(concept),
            reason: '$concept 缺 $locale 名稱');
      }
    }
    expect(conceptLabel('c:fraction', const Locale('en')), 'Fractions');
  });
}
