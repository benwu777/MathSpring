import 'package:flutter_test/flutter_test.dart';
import 'package:mathspring/models/answer_session.dart';
import 'package:mathspring/models/question_progress.dart';
import 'package:mathspring/models/session_answer_record.dart';
import 'package:mathspring/services/learning_data_snapshot.dart';

void main() {
  test('merges distinct answer sessions and keeps the latest mutable progress',
      () {
    const AnswerSession firstSession = AnswerSession(
      id: 'session-one',
      learnerId: 'learner',
      mode: 'practice',
      topicCode: 'geometry',
      levelStage: 'grade4',
      challengeTier: 'foundation',
      startedAtIso: '2026-08-20T09:00:00Z',
      endedAtIso: '2026-08-20T09:05:00Z',
      elapsedSeconds: 300,
      totalQuestions: 1,
      correctCount: 1,
    );
    const AnswerSession secondSession = AnswerSession(
      id: 'session-two',
      learnerId: 'learner',
      mode: 'quiz',
      topicCode: 'algebra',
      levelStage: 'grade4',
      challengeTier: 'foundation',
      startedAtIso: '2026-08-21T09:00:00Z',
      endedAtIso: '2026-08-21T09:05:00Z',
      elapsedSeconds: 300,
      totalQuestions: 1,
      correctCount: 1,
    );
    final LearningDataSnapshot merged = LearningDataSnapshot.merge(
      LearningDataSnapshot(
        sessions: const [firstSession],
        recordsBySessionId: const {
          'session-one': [
            SessionAnswerRecord(
              sessionId: 'session-one',
              questionId: 'q1',
              sequence: 1,
              submittedAnswer: 'A',
              isCorrect: true,
              answeredAtIso: '2026-08-20T09:02:00Z',
            ),
          ],
        },
        progress: const [
          QuestionProgress(
            learnerId: 'learner',
            questionId: 'q1',
            status: 'incorrect',
            lastResult: 'A',
            updatedAtIso: '2026-08-20T09:02:00Z',
          ),
        ],
      ),
      LearningDataSnapshot(
        sessions: const [secondSession],
        recordsBySessionId: const {
          'session-two': [
            SessionAnswerRecord(
              sessionId: 'session-two',
              questionId: 'q2',
              sequence: 1,
              submittedAnswer: 'B',
              isCorrect: true,
              answeredAtIso: '2026-08-21T09:02:00Z',
            ),
          ],
        },
        progress: const [
          QuestionProgress(
            learnerId: 'learner',
            questionId: 'q1',
            status: 'correct',
            lastResult: 'B',
            updatedAtIso: '2026-08-21T09:02:00Z',
          ),
        ],
      ),
    );

    expect(merged.sessions.map((AnswerSession session) => session.id),
        ['session-one', 'session-two']);
    expect(merged.recordsBySessionId.keys,
        containsAll(['session-one', 'session-two']));
    expect(merged.progress, hasLength(1));
    expect(merged.progress.single.status, 'correct');
    expect(merged.progress.single.updatedAtIso, '2026-08-21T09:02:00Z');
  });
}
