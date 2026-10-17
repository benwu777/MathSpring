import 'package:mathspring/models/session_answer_record.dart';

class ConceptStats {
  const ConceptStats({required this.attempts, required this.correct});

  final int attempts;
  final int correct;

  /// 加一平滑後的答對率，避免答 1 題錯 1 題就被判成 0%。
  double get smoothedAccuracy => (correct + 1) / (attempts + 2);

  double get accuracy => attempts == 0 ? 0 : correct / attempts;
}

/// 依作答紀錄統計每個概念（`c:` 標籤）的答對率。
class ConceptMastery {
  const ConceptMastery._(this._stats);

  /// 至少答過幾次才判斷強弱。
  static const int minAttempts = 3;

  /// 平滑答對率低於這個值就算弱概念。
  static const double weakThreshold = 0.5;

  final Map<String, ConceptStats> _stats;

  factory ConceptMastery.fromRecords(
    Iterable<SessionAnswerRecord> records, {
    required Map<String, List<String>> conceptTagsByQuestionId,
  }) {
    final Map<String, (int, int)> counts = <String, (int, int)>{};
    for (final SessionAnswerRecord record in records) {
      for (final String concept
          in conceptTagsByQuestionId[record.questionId] ?? const <String>[]) {
        final (int attempts, int correct) = counts[concept] ?? (0, 0);
        counts[concept] = (attempts + 1, correct + (record.isCorrect ? 1 : 0));
      }
    }
    return ConceptMastery._(<String, ConceptStats>{
      for (final MapEntry<String, (int, int)> entry in counts.entries)
        entry.key: ConceptStats(
          attempts: entry.value.$1,
          correct: entry.value.$2,
        ),
    });
  }

  ConceptStats? statsFor(String concept) => _stats[concept];

  /// 弱概念，答對率最低的排前面。
  List<String> get weakConcepts {
    final List<MapEntry<String, ConceptStats>> weak = _stats.entries
        .where((MapEntry<String, ConceptStats> entry) =>
            entry.value.attempts >= minAttempts &&
            entry.value.smoothedAccuracy < weakThreshold)
        .toList()
      ..sort((MapEntry<String, ConceptStats> left,
              MapEntry<String, ConceptStats> right) =>
          left.value.smoothedAccuracy.compareTo(right.value.smoothedAccuracy));
    return weak
        .map((MapEntry<String, ConceptStats> entry) => entry.key)
        .toList(growable: false);
  }
}
