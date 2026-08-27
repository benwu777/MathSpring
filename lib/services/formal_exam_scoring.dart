import 'package:mathspring/models/question.dart';

class FormalExamQuestionScore {
  const FormalExamQuestionScore({
    required this.questionId,
    required this.maxScore,
  });

  final String questionId;
  final int maxScore;
}

class FormalExamScoring {
  const FormalExamScoring._();

  static List<FormalExamQuestionScore> allocate(List<Question> questions) {
    if (questions.isEmpty) {
      return const <FormalExamQuestionScore>[];
    }

    final List<double> weights = questions
        .map((Question question) => _weightForGrade(_gradeFor(question)))
        .toList(growable: false);
    final double totalWeight = weights.fold<double>(
      0,
      (double total, double weight) => total + weight,
    );
    final List<_Allocation> allocations = <_Allocation>[
      for (int index = 0; index < questions.length; index += 1)
        _Allocation(
          index: index,
          questionId: questions[index].id,
          exactScore: 100 * weights[index] / totalWeight,
        ),
    ];
    int remaining = 100;
    for (final _Allocation allocation in allocations) {
      allocation.score = allocation.exactScore.floor();
      remaining -= allocation.score;
    }
    final List<_Allocation> byRemainder = List<_Allocation>.from(allocations)
      ..sort((_Allocation left, _Allocation right) {
        final int remainderOrder = right.remainder.compareTo(left.remainder);
        return remainderOrder != 0 ? remainderOrder : left.index - right.index;
      });
    for (int index = 0; index < remaining; index += 1) {
      byRemainder[index].score += 1;
    }
    return allocations
        .map(
          (_Allocation allocation) => FormalExamQuestionScore(
            questionId: allocation.questionId,
            maxScore: allocation.score,
          ),
        )
        .toList(growable: false);
  }

  static int _gradeFor(Question question) {
    final int? grade = int.tryParse(question.levelStage.replaceFirst('grade', ''));
    if (grade == null || grade < 1 || grade > 12) {
      throw ArgumentError.value(question.levelStage, 'levelStage');
    }
    return grade;
  }

  static double _weightForGrade(int grade) => 60 + (grade - 1) * 60 / 11;
}

class _Allocation {
  _Allocation({
    required this.index,
    required this.questionId,
    required this.exactScore,
  });

  final int index;
  final String questionId;
  final double exactScore;
  int score = 0;

  double get remainder => exactScore - exactScore.floor();
}
