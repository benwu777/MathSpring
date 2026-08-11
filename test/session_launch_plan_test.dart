import 'package:flutter_test/flutter_test.dart';
import 'package:mathspring/data/bundled/bundled_question_bank_repository.dart';
import 'package:mathspring/models/learner_profile.dart';
import 'package:mathspring/models/question.dart';
import 'package:mathspring/services/session_launch_plan_builder.dart';

void main() {
  const List<BundledQuestionPackInfo> packs = <BundledQuestionPackInfo>[
    BundledQuestionPackInfo(
      path: 'assets/questions/geometry/grade1_foundation.geometry.v1.json',
      topic: 'Geometry',
      topicCode: 'geometry',
      levelStage: 'grade1',
      challengeTier: 'foundation',
      questionCount: 10,
    ),
    BundledQuestionPackInfo(
      path: 'assets/questions/geometry/grade2_foundation.geometry.v1.json',
      topic: 'Geometry',
      topicCode: 'geometry',
      levelStage: 'grade2',
      challengeTier: 'foundation',
      questionCount: 10,
    ),
    BundledQuestionPackInfo(
      path: 'assets/questions/geometry/grade4_foundation.geometry.v1.json',
      topic: 'Geometry',
      topicCode: 'geometry',
      levelStage: 'grade4',
      challengeTier: 'foundation',
      questionCount: 10,
    ),
    BundledQuestionPackInfo(
      path: 'assets/questions/logic/grade4_foundation.logic.v1.json',
      topic: 'Logic',
      topicCode: 'logic',
      levelStage: 'grade4',
      challengeTier: 'foundation',
      questionCount: 4,
    ),
    BundledQuestionPackInfo(
      path: 'assets/questions/geometry/grade4_competition.geometry.v1.json',
      topic: 'Geometry',
      topicCode: 'geometry',
      levelStage: 'grade4',
      challengeTier: 'competition',
      questionCount: 5,
    ),
    BundledQuestionPackInfo(
      path: 'assets/questions/geometry/grade5_foundation.geometry.v1.json',
      topic: 'Geometry',
      topicCode: 'geometry',
      levelStage: 'grade5',
      challengeTier: 'foundation',
      questionCount: 10,
    ),
    BundledQuestionPackInfo(
      path: 'assets/questions/logic/grade6_foundation.logic.v1.json',
      topic: 'Logic',
      topicCode: 'logic',
      levelStage: 'grade6',
      challengeTier: 'foundation',
      questionCount: 10,
    ),
    BundledQuestionPackInfo(
      path: 'assets/questions/mixed/grade5_foundation.mixed.v1.json',
      topic: 'Mixed',
      topicCode: 'mixed',
      levelStage: 'grade5',
      challengeTier: 'foundation',
      questionCount: 7,
    ),
    BundledQuestionPackInfo(
      path: 'assets/questions/mixed/grade6_foundation.mixed.v1.json',
      topic: 'Mixed',
      topicCode: 'mixed',
      levelStage: 'grade6',
      challengeTier: 'foundation',
      questionCount: 5,
    ),
    BundledQuestionPackInfo(
      path: 'assets/questions/algebra/grade7_foundation.algebra.v1.json',
      topic: 'Algebra',
      topicCode: 'algebra',
      levelStage: 'grade7',
      challengeTier: 'foundation',
      questionCount: 4,
    ),
  ];

  test('selects only foundation packs for anonymous launch', () {
    final List<BundledQuestionPackInfo> selected =
        SessionLaunchPlanBuilder.pickEligiblePacks(
      packs,
      null,
      topicCode: 'geometry',
    );

    expect(selected, hasLength(4));
    expect(selected.every((pack) => pack.challengeTier == 'foundation'), isTrue);
    expect(selected.every((pack) => pack.topicCode == 'geometry'), isTrue);
  });

  test('learner launch supports grade7+ packs inside the selected range',
      () {
    const LearnerProfile learner = LearnerProfile(
      id: 'learner_senior',
      displayName: 'Senior',
      levelStage: 'grade12',
      minLevelStage: 'grade7',
      maxLevelStage: 'grade12',
      challengeTier: 'foundation',
      createdAtIso: '2026-08-02T00:00:00Z',
    );

    final List<BundledQuestionPackInfo> selected =
        SessionLaunchPlanBuilder.pickEligiblePacks(
      packs,
      learner,
      topicCode: 'algebra',
    );

    expect(selected, hasLength(1));
    expect(selected.first.levelStage, 'grade7');
  });

  test('selects competition-profile-matched packs for learner launch', () {
    const LearnerProfile learner = LearnerProfile(
      id: 'learner_1',
      displayName: 'Allen',
      levelStage: 'grade4',
      challengeTier: 'foundation',
      createdAtIso: '2026-07-19T00:00:00Z',
    );

    final List<BundledQuestionPackInfo> selected =
        SessionLaunchPlanBuilder.pickEligiblePacks(
      packs,
      learner,
      topicCode: 'geometry',
    );

    expect(selected, hasLength(1));
    expect(selected.first.levelStage, 'grade4');
    expect(selected.first.challengeTier, 'foundation');
  });

  test('builds mixed launch pack with merged question count and representative level',
      () {
    const LearnerProfile learner = LearnerProfile(
      id: 'learner_2',
      displayName: 'Mia',
      levelStage: 'grade2',
      minLevelStage: 'grade1',
      maxLevelStage: 'grade2',
      challengeTier: 'foundation',
      createdAtIso: '2026-07-19T00:00:00Z',
    );

    final BundledQuestionPackInfo launchPack =
        SessionLaunchPlanBuilder.buildLaunchPack(
      selectedPacks: packs.take(2).toList(),
      learner: learner,
      mergedQuestionCount: 20,
      topicCode: null,
    );

    expect(launchPack.topicCode, 'mixed');
    expect(launchPack.levelStage, 'grade2');
    expect(launchPack.challengeTier, 'foundation');
    expect(launchPack.questionCount, 20);
  });

  test('builds 5-6 mixed launches from existing grade 5 and grade 6 packs', () {
    const LearnerProfile learner = LearnerProfile(
      id: 'learner_3',
      displayName: 'Kai',
      levelStage: 'grade6',
      challengeTier: 'foundation',
      createdAtIso: '2026-07-19T00:00:00Z',
    );

    final List<BundledQuestionPackInfo> selected =
        SessionLaunchPlanBuilder.pickEligiblePacks(
      packs,
      learner,
      topicCode: null,
    );

    expect(selected, hasLength(4));
    expect(selected.map((pack) => pack.topicCode).toSet(), equals(<String>{
      'geometry',
      'logic',
      'mixed',
    }));
    expect(selected.map((pack) => pack.levelStage).toSet(), equals(<String>{
      'grade5',
      'grade6',
    }));
    expect(selected.where((pack) => pack.topicCode == 'mixed'), hasLength(2));
  });

  test('randomizes question order once per launched session', () {
    Question buildQuestion(String id) {
      return Question.fromJson({
        'id': id,
        'topic': 'geometry',
        'difficulty': 'foundation',
        'levelStage': 'grade4',
        'challengeTier': 'foundation',
        'prompt': {'en': 'Prompt $id'},
        'answer': {'en': 'Answer $id'},
        'solutionSteps': {
          'en': ['Step $id'],
        },
        'figure': {
          'type': 'custom',
          'kind': 'none',
          'params': <String, dynamic>{},
        },
        'answerMode': 'integer_input',
        'correctAnswer': {
          'type': 'integer',
          'value': '1',
        },
        'reviewStatus': 'ok',
      });
    }

    final List<Question> questions = <Question>[
      buildQuestion('q1'),
      buildQuestion('q2'),
      buildQuestion('q3'),
      buildQuestion('q4'),
      buildQuestion('q5'),
    ];

    final List<Question> randomized =
        SessionLaunchPlanBuilder.randomizeQuestionOrderForSession(
      questions,
      seed: 7,
    );

    expect(randomized.map((question) => question.id), isNot(equals([
      'q1',
      'q2',
      'q3',
      'q4',
      'q5',
    ])));
    expect(
      randomized.map((question) => question.id).toSet(),
      equals(<String>{'q1', 'q2', 'q3', 'q4', 'q5'}),
    );
  });

  test('launch question filtering keeps only review-approved questions', () {
    Question buildQuestion(String id, String reviewStatus) {
      return Question.fromJson({
        'id': id,
        'topic': 'geometry',
        'difficulty': 'foundation',
        'levelStage': 'grade7',
        'challengeTier': 'foundation',
        'prompt': {'en': 'Prompt $id'},
        'answer': {'en': 'Answer $id'},
        'solutionSteps': {
          'en': ['Step $id'],
        },
        'figure': {
          'type': 'custom',
          'kind': 'none',
          'params': <String, dynamic>{},
        },
        'answerMode': 'integer_input',
        'correctAnswer': {
          'type': 'integer',
          'value': '1',
        },
        'reviewStatus': reviewStatus,
      });
    }

    final List<Question> filtered =
        SessionLaunchPlanBuilder.filterApprovedQuestionsForLaunch(<Question>[
      buildQuestion('q_ok_1', 'ok'),
      buildQuestion('q_pending', 'pending'),
      buildQuestion('q_fix', 'needs_fix'),
      buildQuestion('q_ok_2', 'ok'),
    ]);

    expect(filtered.map((item) => item.id), <String>['q_ok_1', 'q_ok_2']);
  });

  test('question parser preserves review status', () {
    final Question question = Question.fromJson({
      'id': 'geometry_grade7_foundation_approved',
      'topic': 'geometry',
      'difficulty': 'foundation',
      'levelStage': 'grade7',
      'challengeTier': 'foundation',
      'prompt': {'en': 'Prompt'},
      'answer': {'en': 'Answer'},
      'solutionSteps': {
        'en': ['Step'],
      },
      'figure': {
        'type': 'custom',
        'kind': 'none',
        'params': <String, dynamic>{},
      },
      'answerMode': 'integer_input',
      'correctAnswer': {
        'type': 'integer',
        'value': '1',
      },
      'reviewStatus': 'ok',
    });

    expect(question.reviewStatus, 'ok');
    expect(question.isReviewApproved, isTrue);
  });
}
