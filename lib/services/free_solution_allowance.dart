import 'dart:convert';

/// 免費版每天可看的完整詳解題數。
///
/// 由學生自己挑要看哪一題；同一題當天重開不再扣次數。以裝置本機日期換日。
class FreeSolutionAllowance {
  const FreeSolutionAllowance._({
    required this.day,
    required this.unlockedQuestionIds,
  });

  static const int dailyLimit = 3;

  final DateTime day;
  final Set<String> unlockedQuestionIds;

  factory FreeSolutionAllowance.decode(String? raw, {required DateTime now}) {
    final DateTime today = _dayKey(now);
    final FreeSolutionAllowance fresh = FreeSolutionAllowance._(
      day: today,
      unlockedQuestionIds: const <String>{},
    );
    if (raw == null) {
      return fresh;
    }
    try {
      final Map<String, dynamic> json = jsonDecode(raw) as Map<String, dynamic>;
      if (json['day'] != _dayToken(today)) {
        return fresh;
      }
      return FreeSolutionAllowance._(
        day: today,
        unlockedQuestionIds: Set<String>.unmodifiable(
          (json['questionIds'] as List<dynamic>).cast<String>(),
        ),
      );
    } on Object {
      return fresh;
    }
  }

  int get remaining => dailyLimit - unlockedQuestionIds.length;

  bool isUnlocked(String questionId) =>
      unlockedQuestionIds.contains(questionId);

  /// 回傳解鎖後的狀態；今天的額度用完且這題還沒解鎖過時回傳 null。
  FreeSolutionAllowance? unlock(String questionId) {
    if (isUnlocked(questionId)) {
      return this;
    }
    if (remaining <= 0) {
      return null;
    }
    return FreeSolutionAllowance._(
      day: day,
      unlockedQuestionIds: Set<String>.unmodifiable(
          <String>{...unlockedQuestionIds, questionId}),
    );
  }

  String encode() => jsonEncode(<String, Object>{
        'day': _dayToken(day),
        'questionIds': unlockedQuestionIds.toList()..sort(),
      });

  static DateTime _dayKey(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  static String _dayToken(DateTime day) =>
      '${day.year.toString().padLeft(4, '0')}-'
      '${day.month.toString().padLeft(2, '0')}-'
      '${day.day.toString().padLeft(2, '0')}';
}
