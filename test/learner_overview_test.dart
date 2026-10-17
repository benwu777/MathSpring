import 'package:flutter_test/flutter_test.dart';
import 'package:mathspring/models/session_answer_record.dart';
import 'package:mathspring/services/learner_overview.dart';

SessionAnswerRecord _answer(String questionId, bool isCorrect, DateTime at) =>
    SessionAnswerRecord(
      sessionId: 's1',
      questionId: questionId,
      sequence: 1,
      submittedAnswer: '1',
      isCorrect: isCorrect,
      answeredAtIso: at.toUtc().toIso8601String(),
    );

void main() {
  final DateTime now = DateTime(2026, 10, 17, 20);
  const Map<String, List<String>> tags = <String, List<String>>{
    'f1': <String>['c:fraction'],
    'f2': <String>['c:fraction'],
    'a1': <String>['c:area'],
  };

  test('summarises only the last seven local days', () {
    final LearnerOverview overview = LearnerOverview.fromRecords(
      <SessionAnswerRecord>[
        _answer('a1', true, DateTime(2026, 10, 17, 9)),
        _answer('a1', false, DateTime(2026, 10, 17, 10)),
        _answer('f1', true, DateTime(2026, 10, 11, 8)),
        _answer('f2', true, DateTime(2026, 10, 10, 23)),
      ],
      now: now,
      conceptTagsByQuestionId: tags,
    );

    expect(overview.practiceDays, 2, reason: '10/11 是 7 天內最早的一天，10/10 不算');
    expect(overview.answeredCount, 3);
    expect(overview.correctCount, 2);
  });

  test('names the weakest concept from all history', () {
    final LearnerOverview overview = LearnerOverview.fromRecords(
      <SessionAnswerRecord>[
        _answer('f1', false, DateTime(2026, 9, 1)),
        _answer('f2', false, DateTime(2026, 9, 2)),
        _answer('f1', false, DateTime(2026, 9, 3)),
        _answer('a1', true, DateTime(2026, 9, 4)),
      ],
      now: now,
      conceptTagsByQuestionId: tags,
    );

    expect(overview.answeredCount, 0);
    expect(overview.weakestConcept, 'c:fraction');
  });

  test('a learner without answers has an empty overview', () {
    final LearnerOverview overview = LearnerOverview.fromRecords(
      const <SessionAnswerRecord>[],
      now: now,
      conceptTagsByQuestionId: tags,
    );

    expect(overview.practiceDays, 0);
    expect(overview.answeredCount, 0);
    expect(overview.weakestConcept, isNull);
  });
}
