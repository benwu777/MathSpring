import 'package:mathspring/models/answer_session.dart';
import 'package:mathspring/models/question_progress.dart';
import 'package:mathspring/models/session_answer_record.dart';

class LearningDataSnapshot {
  const LearningDataSnapshot({
    required this.sessions,
    required this.recordsBySessionId,
    required this.progress,
  });

  final List<AnswerSession> sessions;
  final Map<String, List<SessionAnswerRecord>> recordsBySessionId;
  final List<QuestionProgress> progress;

  factory LearningDataSnapshot.fromJson(Map<String, Object?> json) {
    final List<Object?> sessionValues = json['sessions']! as List<Object?>;
    final Map<String, Object?> recordValues =
        Map<String, Object?>.from(json['recordsBySessionId']! as Map);
    final List<Object?> progressValues = json['progress']! as List<Object?>;
    return LearningDataSnapshot(
      sessions: sessionValues
          .map(
            (Object? value) => AnswerSession.fromMap(
              Map<String, Object?>.from(value! as Map),
            ),
          )
          .toList(),
      recordsBySessionId: recordValues.map(
        (String sessionId, Object? value) => MapEntry(
          sessionId,
          (value! as List<Object?>)
              .map(
                (Object? record) => SessionAnswerRecord.fromMap(
                  Map<String, Object?>.from(record! as Map),
                ),
              )
              .toList(),
        ),
      ),
      progress: progressValues
          .map(
            (Object? value) => QuestionProgress.fromMap(
              Map<String, Object?>.from(value! as Map),
            ),
          )
          .toList(),
    );
  }

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'sessions':
          sessions.map((AnswerSession session) => session.toMap()).toList(),
      'recordsBySessionId': recordsBySessionId.map(
        (String sessionId, List<SessionAnswerRecord> records) => MapEntry(
          sessionId,
          records.map((SessionAnswerRecord record) => record.toMap()).toList(),
        ),
      ),
      'progress': progress
          .map((QuestionProgress progressItem) => progressItem.toMap())
          .toList(),
    };
  }

  static LearningDataSnapshot merge(
    LearningDataSnapshot first,
    LearningDataSnapshot second,
  ) {
    final Map<String, AnswerSession> sessionsById = <String, AnswerSession>{
      for (final AnswerSession session in first.sessions) session.id: session,
      for (final AnswerSession session in second.sessions) session.id: session,
    };
    final List<AnswerSession> sessions = sessionsById.values.toList()
      ..sort(
        (AnswerSession left, AnswerSession right) =>
            left.endedAtIso.compareTo(right.endedAtIso),
      );
    final Map<String, List<SessionAnswerRecord>> recordsBySessionId =
        <String, List<SessionAnswerRecord>>{};
    for (final AnswerSession session in sessions) {
      final Map<String, SessionAnswerRecord> recordsById =
          <String, SessionAnswerRecord>{};
      for (final SessionAnswerRecord record in [
        ...first.recordsBySessionId[session.id] ??
            const <SessionAnswerRecord>[],
        ...second.recordsBySessionId[session.id] ??
            const <SessionAnswerRecord>[],
      ]) {
        recordsById['${record.questionId}:${record.sequence}'] = record;
      }
      final List<SessionAnswerRecord> records = recordsById.values.toList()
        ..sort(
          (SessionAnswerRecord left, SessionAnswerRecord right) =>
              left.sequence.compareTo(right.sequence),
        );
      recordsBySessionId[session.id] = records;
    }
    final Map<String, QuestionProgress> progressByKey =
        <String, QuestionProgress>{};
    for (final QuestionProgress item in [
      ...first.progress,
      ...second.progress
    ]) {
      final String key = '${item.learnerId}:${item.questionId}';
      final QuestionProgress? existing = progressByKey[key];
      if (existing == null ||
          item.updatedAtIso.compareTo(existing.updatedAtIso) > 0) {
        progressByKey[key] = item;
      }
    }
    return LearningDataSnapshot(
      sessions: sessions,
      recordsBySessionId: recordsBySessionId,
      progress: progressByKey.values.toList(),
    );
  }
}
