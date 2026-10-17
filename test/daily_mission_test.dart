import 'package:flutter_test/flutter_test.dart';
import 'package:mathspring/models/answer_session.dart';
import 'package:mathspring/models/session_answer_record.dart';
import 'package:mathspring/services/daily_mission.dart';

void main() {
  const AnswerSession practice = AnswerSession(
    id: 'practice_today',
    learnerId: 'learner_1',
    mode: 'practice',
    topicCode: 'mixed',
    levelStage: 'grade4',
    challengeTier: 'foundation',
    startedAtIso: '2026-08-27T00:00:00Z',
    endedAtIso: '2026-08-27T00:10:00Z',
    elapsedSeconds: 600,
    totalQuestions: 5,
    correctCount: 2,
  );
  const AnswerSession quiz = AnswerSession(
    id: 'quiz_today',
    learnerId: 'learner_1',
    mode: 'quiz',
    topicCode: 'mixed',
    levelStage: 'grade4',
    challengeTier: 'foundation',
    startedAtIso: '2026-08-27T00:00:00Z',
    endedAtIso: '2026-08-27T00:10:00Z',
    elapsedSeconds: 600,
    totalQuestions: 5,
    correctCount: 5,
  );

  test('counts only today practice answers regardless of correctness', () {
    final DateTime today = DateTime(2026, 8, 27);
    final DailyMissionProgress progress = DailyMission.calculate(
      learnerId: 'learner_1',
      date: today,
      sessions: const <AnswerSession>[practice, quiz],
      recordsBySessionId: <String, List<SessionAnswerRecord>>{
        'practice_today': <SessionAnswerRecord>[
          _record('practice_today', 1, true, today),
          _record('practice_today', 2, false, today),
          _record('practice_today', 3, true, today),
          _record('practice_today', 4, false, today),
          _record('practice_today', 5, true, today),
        ],
        'quiz_today': <SessionAnswerRecord>[
          _record('quiz_today', 1, true, today),
        ],
      },
    );

    expect(progress.answeredCount, 5);
    expect(progress.targetCount, 5);
    expect(progress.isComplete, isTrue);
  });

  test('chooses a stable encouragement for the learner and day', () {
    final int first = DailyMission.encouragementIndexFor(
      learnerId: 'learner_1',
      date: DateTime(2026, 8, 27),
      optionCount: 4,
    );
    final int second = DailyMission.encouragementIndexFor(
      learnerId: 'learner_1',
      date: DateTime(2026, 8, 27),
      optionCount: 4,
    );

    expect(first, second);
    expect(first, inInclusiveRange(0, 3));
  });
}

SessionAnswerRecord _record(
  String sessionId,
  int sequence,
  bool isCorrect,
  DateTime date,
) {
  return SessionAnswerRecord(
    sessionId: sessionId,
    questionId: 'question_$sequence',
    sequence: sequence,
    submittedAnswer: isCorrect ? 'A' : 'B',
    isCorrect: isCorrect,
    answeredAtIso:
        date.add(Duration(minutes: sequence)).toUtc().toIso8601String(),
  );
}
