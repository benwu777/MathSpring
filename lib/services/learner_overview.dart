import 'package:mathspring/models/session_answer_record.dart';
import 'package:mathspring/services/concept_mastery.dart';

/// 給家長看的單一學習者摘要：近 7 天的練習量與答對率，加上最弱的概念。
class LearnerOverview {
  const LearnerOverview._({
    required this.practiceDays,
    required this.answeredCount,
    required this.correctCount,
    required this.weakestConcept,
  });

  /// 含今天往回算幾天（以裝置本機日期為準）。
  static const int windowDays = 7;

  final int practiceDays;
  final int answeredCount;
  final int correctCount;

  /// 依全部作答紀錄判斷；沒有弱概念時為 null。
  final String? weakestConcept;

  factory LearnerOverview.fromRecords(
    List<SessionAnswerRecord> records, {
    required DateTime now,
    required Map<String, List<String>> conceptTagsByQuestionId,
  }) {
    final DateTime firstDay = DateTime(now.year, now.month, now.day)
        .subtract(const Duration(days: windowDays - 1));
    final Set<DateTime> days = <DateTime>{};
    int answered = 0;
    int correct = 0;
    for (final SessionAnswerRecord record in records) {
      final DateTime answeredAt =
          DateTime.parse(record.answeredAtIso).toLocal();
      final DateTime day =
          DateTime(answeredAt.year, answeredAt.month, answeredAt.day);
      if (day.isBefore(firstDay)) {
        continue;
      }
      days.add(day);
      answered += 1;
      if (record.isCorrect) {
        correct += 1;
      }
    }
    final List<String> weak = ConceptMastery.fromRecords(
      records,
      conceptTagsByQuestionId: conceptTagsByQuestionId,
    ).weakConcepts;
    return LearnerOverview._(
      practiceDays: days.length,
      answeredCount: answered,
      correctCount: correct,
      weakestConcept: weak.isEmpty ? null : weak.first,
    );
  }
}
