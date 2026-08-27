import 'package:flutter_test/flutter_test.dart';
import 'package:mathspring/models/answer_session.dart';
import 'package:mathspring/models/session_answer_record.dart';
import 'package:mathspring/services/learning_activity_summary.dart';

void main() {
  test('groups answers by local day and calculates current and best streaks',
      () {
    final LearningActivitySummary summary =
        LearningActivitySummary.fromSessions(
      sessions: const [
        AnswerSession(
          id: 'first',
          learnerId: 'learner',
          mode: 'practice',
          topicCode: 'geometry',
          levelStage: 'grade4',
          challengeTier: 'foundation',
          startedAtIso: '2026-08-20T09:00:00Z',
          endedAtIso: '2026-08-20T09:05:00Z',
          elapsedSeconds: 300,
          totalQuestions: 2,
          correctCount: 1,
        ),
        AnswerSession(
          id: 'second',
          learnerId: 'learner',
          mode: 'quiz',
          topicCode: 'geometry',
          levelStage: 'grade4',
          challengeTier: 'foundation',
          startedAtIso: '2026-08-21T09:00:00Z',
          endedAtIso: '2026-08-21T09:05:00Z',
          elapsedSeconds: 300,
          totalQuestions: 1,
          correctCount: 1,
        ),
        AnswerSession(
          id: 'third',
          learnerId: 'learner',
          mode: 'practice',
          topicCode: 'algebra',
          levelStage: 'grade4',
          challengeTier: 'foundation',
          startedAtIso: '2026-08-23T09:00:00Z',
          endedAtIso: '2026-08-23T09:05:00Z',
          elapsedSeconds: 300,
          totalQuestions: 1,
          correctCount: 1,
        ),
      ],
      recordsBySessionId: const {
        'first': [
          SessionAnswerRecord(
            sessionId: 'first',
            questionId: 'q1',
            sequence: 1,
            submittedAnswer: 'A',
            isCorrect: true,
            answeredAtIso: '2026-08-20T09:01:00Z',
          ),
          SessionAnswerRecord(
            sessionId: 'first',
            questionId: 'q2',
            sequence: 2,
            submittedAnswer: 'B',
            isCorrect: false,
            answeredAtIso: '2026-08-20T09:02:00Z',
          ),
        ],
        'second': [
          SessionAnswerRecord(
            sessionId: 'second',
            questionId: 'q2',
            sequence: 1,
            submittedAnswer: 'C',
            isCorrect: true,
            answeredAtIso: '2026-08-21T09:02:00Z',
          ),
        ],
        'third': [
          SessionAnswerRecord(
            sessionId: 'third',
            questionId: 'q3',
            sequence: 1,
            submittedAnswer: 'D',
            isCorrect: true,
            answeredAtIso: '2026-08-23T09:02:00Z',
          ),
        ],
      },
    );

    expect(summary.dayFor(DateTime(2026, 8, 20)).questionCount, 2);
    expect(summary.dayFor(DateTime(2026, 8, 20)).correctCount, 1);
    expect(summary.dayFor(DateTime(2026, 8, 20)).accuracyRate, 0.5);
    expect(summary.currentStreak, 1);
    expect(summary.longestStreak, 2);
    expect(summary.recoveredWrongAnswerCount, 1);
  });

  test('awards every reached topic milestone', () {
    const AnswerSession session = AnswerSession(
      id: 'geometry-session',
      learnerId: 'learner',
      mode: 'practice',
      topicCode: 'geometry',
      levelStage: 'grade4',
      challengeTier: 'foundation',
      startedAtIso: '2026-08-20T09:00:00Z',
      endedAtIso: '2026-08-20T09:05:00Z',
      elapsedSeconds: 300,
      totalQuestions: 50,
      correctCount: 50,
    );
    final List<SessionAnswerRecord> records =
        List<SessionAnswerRecord>.generate(
      50,
      (int index) => SessionAnswerRecord(
        sessionId: session.id,
        questionId: 'q$index',
        sequence: index + 1,
        submittedAnswer: 'A',
        isCorrect: true,
        answeredAtIso:
            '2026-08-20T09:${(index % 60).toString().padLeft(2, '0')}:00Z',
      ),
    );

    final LearningActivitySummary summary =
        LearningActivitySummary.fromSessions(
      sessions: const [session],
      recordsBySessionId: {session.id: records},
    );

    expect(summary.topicQuestionCounts, {'geometry': 50});
    expect(summary.reachedTopicMilestones('geometry'), [20, 50]);
  });
}
