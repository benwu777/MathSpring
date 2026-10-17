import 'package:flutter_test/flutter_test.dart';
import 'package:mathspring/data/bundled/bundled_question_bank_repository.dart';
import 'package:mathspring/models/question.dart';
import 'package:mathspring/services/session_launch_plan_builder.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('loads bundled questions by id in the requested order', () async {
    final List<Question> questions =
        await BundledQuestionBankRepository().loadQuestionsByIds(<String>[
      'logic_grade5_foundation_003',
      'arithmetic_grade2_foundation_010',
      'no_such_question',
    ]);

    expect(questions.map((Question q) => q.id), <String>[
      'logic_grade5_foundation_003',
      'arithmetic_grade2_foundation_010',
    ]);
  });

  group('daily mission review mix', () {
    late List<Question> fresh;
    late List<Question> mistakes;

    setUpAll(() async {
      final BundledQuestionBankRepository repository =
          BundledQuestionBankRepository();
      fresh = (await repository.loadPack(
              'assets/questions/arithmetic/grade3_foundation.arithmetic.v1.json'))
          .questions
          .take(8)
          .toList();
      mistakes = await repository.loadQuestionsByIds(<String>[
        'logic_grade5_foundation_003',
        'arithmetic_grade2_foundation_010',
      ]);
    });

    test('puts one earlier mistake into a five-question mission', () {
      final List<Question> mission =
          SessionLaunchPlanBuilder.mixInReviewQuestions(
        fresh,
        reviewQuestions: mistakes,
        limit: 5,
        reviewCount: 1,
      );

      expect(mission, hasLength(5));
      expect(
          mission.where((Question q) => q.id == 'logic_grade5_foundation_003'),
          hasLength(1));
      expect(
          mission.where(
              (Question q) => q.id == 'arithmetic_grade2_foundation_010'),
          isEmpty);
    });

    test('never repeats a mistake that is also in the fresh pool', () {
      final List<Question> mission =
          SessionLaunchPlanBuilder.mixInReviewQuestions(
        <Question>[...mistakes.take(1), ...fresh],
        reviewQuestions: mistakes,
        limit: 5,
        reviewCount: 1,
      );

      expect(mission.map((Question q) => q.id).toSet(), hasLength(5));
    });

    test('without mistakes the mission is the first fresh questions', () {
      final List<Question> mission =
          SessionLaunchPlanBuilder.mixInReviewQuestions(
        fresh,
        reviewQuestions: const <Question>[],
        limit: 5,
        reviewCount: 1,
      );

      expect(mission.map((Question q) => q.id),
          fresh.take(5).map((Question q) => q.id));
    });
  });
}
