import 'package:mathspring/models/answer_session.dart';
import 'package:mathspring/models/session_answer_record.dart';

class DailyMissionProgress {
  const DailyMissionProgress({
    required this.date,
    required this.answeredCount,
    this.targetCount = DailyMission.targetCount,
  });

  final DateTime date;
  final int answeredCount;
  final int targetCount;

  bool get isComplete => answeredCount >= targetCount;
}

class DailyMission {
  const DailyMission._();

  static const int targetCount = 5;
  static DailyMissionProgress calculate({
    required String learnerId,
    required DateTime date,
    required List<AnswerSession> sessions,
    required Map<String, List<SessionAnswerRecord>> recordsBySessionId,
  }) {
    final DateTime day = _dayKey(date);
    int answeredCount = 0;
    for (final AnswerSession session in sessions) {
      if (session.mode != 'practice') {
        continue;
      }
      for (final SessionAnswerRecord record
          in recordsBySessionId[session.id] ?? const <SessionAnswerRecord>[]) {
        if (_dayKey(DateTime.parse(record.answeredAtIso).toLocal()) == day) {
          answeredCount += 1;
        }
      }
    }
    return DailyMissionProgress(date: day, answeredCount: answeredCount);
  }

  /// Picks which encouragement line to show, stable for one learner and day.
  static int encouragementIndexFor({
    required String learnerId,
    required DateTime date,
    required int optionCount,
  }) {
    final String seed = '$learnerId-${_dayKey(date).toIso8601String()}';
    int hash = 0;
    for (final int codeUnit in seed.codeUnits) {
      hash = (hash * 31 + codeUnit) & 0x7fffffff;
    }
    return hash % optionCount;
  }

  static DateTime _dayKey(DateTime date) =>
      DateTime(date.year, date.month, date.day);
}
