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
  static const List<String> _encouragements = <String>[
    '今天的任務做了嗎？從一題開始吧。',
    '花一點時間，讓今天多一點進步。',
    '準備好了嗎？完成今天的五題挑戰！',
    '每一題都是新的思考練習，現在開始吧。',
  ];

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

  static String encouragementFor({
    required String learnerId,
    required DateTime date,
  }) {
    final String seed = '$learnerId-${_dayKey(date).toIso8601String()}';
    int hash = 0;
    for (final int codeUnit in seed.codeUnits) {
      hash = (hash * 31 + codeUnit) & 0x7fffffff;
    }
    return _encouragements[hash % _encouragements.length];
  }

  static DateTime _dayKey(DateTime date) =>
      DateTime(date.year, date.month, date.day);
}
