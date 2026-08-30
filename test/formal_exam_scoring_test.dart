import 'package:flutter_test/flutter_test.dart';
import 'package:mathspring/models/question.dart';
import 'package:mathspring/services/formal_exam_scoring.dart';

void main() {
  Question question(String id, int grade) {
    return Question(
      id: id,
      topic: 'geometry',
      difficulty: 'foundation',
      levelStage: 'grade$grade',
      challengeTier: 'foundation',
      prompt: const <String, String>{'en': 'Prompt'},
      answer: const <String, String>{'en': 'Answer'},
      solutionSteps: const <String, List<String>>{'en': <String>[]},
      figure: const QuestionFigure(
        type: FigureType.custom,
        kind: 'none',
        params: <String, dynamic>{},
      ),
      answerMode: AnswerMode.multipleChoice,
      correctAnswer: const CorrectAnswer(type: 'choice', value: 'A'),
    );
  }

  test('allocates integer points totaling 100 from question grades', () {
    final List<FormalExamQuestionScore> scores =
        FormalExamScoring.allocate(<Question>[
      question('grade1', 1),
      question('grade6', 6),
      question('grade12', 12),
    ]);

    expect(scores.map((FormalExamQuestionScore item) => item.maxScore),
        everyElement(isA<int>()));
    expect(scores.fold<int>(0, (int total, item) => total + item.maxScore),
        100);
    expect(scores[0].maxScore, lessThan(scores[1].maxScore));
    expect(scores[1].maxScore, lessThan(scores[2].maxScore));
  });

  test('uses paper order to break equal fractional remainders', () {
    final List<FormalExamQuestionScore> scores =
        FormalExamScoring.allocate(<Question>[
      question('first', 1),
      question('second', 1),
      question('third', 1),
    ]);

    expect(scores.map((FormalExamQuestionScore item) => item.maxScore),
        <int>[34, 33, 33]);
  });
}
