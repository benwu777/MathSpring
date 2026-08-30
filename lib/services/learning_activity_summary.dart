import 'package:mathspring/models/answer_session.dart';
import 'package:mathspring/models/session_answer_record.dart';

class LearningActivitySummary {
  const LearningActivitySummary._({
    required this.days,
    required this.topicQuestionCounts,
    required this.recoveredWrongAnswerCount,
    required this.currentStreak,
    required this.longestStreak,
  });

  final Map<DateTime, LearningDaySummary> days;
  final Map<String, int> topicQuestionCounts;
  final int recoveredWrongAnswerCount;
  final int currentStreak;
  final int longestStreak;

  factory LearningActivitySummary.fromSessions({
    required List<AnswerSession> sessions,
    required Map<String, List<SessionAnswerRecord>> recordsBySessionId,
  }) {
    final Map<DateTime, LearningDaySummary> days =
        <DateTime, LearningDaySummary>{};
    final Map<String, int> topicQuestionCounts = <String, int>{};
    final List<_AnsweredRecord> answeredRecords = <_AnsweredRecord>[];

    for (final AnswerSession session in sessions) {
      final List<SessionAnswerRecord> records =
          recordsBySessionId[session.id] ?? const <SessionAnswerRecord>[];
      for (final SessionAnswerRecord record in records) {
        final DateTime answeredAt =
            DateTime.parse(record.answeredAtIso).toLocal();
        final DateTime day = _dayKey(answeredAt);
        final LearningDaySummary existing =
            days[day] ?? LearningDaySummary(date: day);
        days[day] = existing.addAnswer(isCorrect: record.isCorrect);
        topicQuestionCounts.update(
          session.topicCode,
          (int count) => count + 1,
          ifAbsent: () => 1,
        );
        answeredRecords.add(
          _AnsweredRecord(
            record: record,
            answeredAt: answeredAt,
          ),
        );
      }
    }

    answeredRecords.sort(
      (_AnsweredRecord left, _AnsweredRecord right) =>
          left.answeredAt.compareTo(right.answeredAt),
    );
    final Map<String, bool> lastResultByQuestion = <String, bool>{};
    int recoveredWrongAnswerCount = 0;
    for (final _AnsweredRecord item in answeredRecords) {
      if (item.record.isCorrect &&
          lastResultByQuestion[item.record.questionId] == false) {
        recoveredWrongAnswerCount += 1;
      }
      lastResultByQuestion[item.record.questionId] = item.record.isCorrect;
    }

    final List<DateTime> practicedDays = days.keys.toList()..sort();
    return LearningActivitySummary._(
      days: Map<DateTime, LearningDaySummary>.unmodifiable(days),
      topicQuestionCounts: Map<String, int>.unmodifiable(topicQuestionCounts),
      recoveredWrongAnswerCount: recoveredWrongAnswerCount,
      currentStreak: _currentStreak(practicedDays),
      longestStreak: _longestStreak(practicedDays),
    );
  }

  LearningDaySummary dayFor(DateTime date) {
    return days[_dayKey(date)] ?? LearningDaySummary(date: _dayKey(date));
  }

  List<int> reachedTopicMilestones(String topicCode) {
    const List<int> milestones = <int>[20, 50, 100];
    final int count = topicQuestionCounts[topicCode] ?? 0;
    return milestones.where((int milestone) => count >= milestone).toList();
  }

  static DateTime _dayKey(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  static int _currentStreak(List<DateTime> practicedDays) {
    if (practicedDays.isEmpty) {
      return 0;
    }
    int streak = 1;
    for (int index = practicedDays.length - 1; index > 0; index -= 1) {
      if (practicedDays[index].difference(practicedDays[index - 1]).inDays !=
          1) {
        break;
      }
      streak += 1;
    }
    return streak;
  }

  static int _longestStreak(List<DateTime> practicedDays) {
    int longest = 0;
    int streak = 0;
    DateTime? previous;
    for (final DateTime day in practicedDays) {
      streak = previous != null && day.difference(previous).inDays == 1
          ? streak + 1
          : 1;
      if (streak > longest) {
        longest = streak;
      }
      previous = day;
    }
    return longest;
  }
}

class LearningDaySummary {
  const LearningDaySummary({
    required this.date,
    this.questionCount = 0,
    this.correctCount = 0,
  });

  final DateTime date;
  final int questionCount;
  final int correctCount;

  double get accuracyRate =>
      questionCount == 0 ? 0 : correctCount / questionCount;

  LearningDaySummary addAnswer({required bool isCorrect}) {
    return LearningDaySummary(
      date: date,
      questionCount: questionCount + 1,
      correctCount: correctCount + (isCorrect ? 1 : 0),
    );
  }
}

class _AnsweredRecord {
  const _AnsweredRecord({required this.record, required this.answeredAt});

  final SessionAnswerRecord record;
  final DateTime answeredAt;
}
