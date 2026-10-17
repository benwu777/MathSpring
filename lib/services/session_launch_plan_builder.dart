import 'dart:math' as math;

import 'package:mathspring/competition_profiles.dart';
import 'package:mathspring/data/bundled/bundled_question_bank_repository.dart';
import 'package:mathspring/models/learner_profile.dart';
import 'package:mathspring/models/question.dart';

class SessionLaunchPlanBuilder {
  static const Set<String> _currentlySupportedLaunchLevels = <String>{
    'grade1',
    'grade2',
    'grade3',
    'grade4',
    'grade5',
    'grade6',
    'grade7',
    'grade8',
    'grade9',
    'grade10',
    'grade11',
    'grade12',
  };

  static List<BundledQuestionPackInfo> pickEligiblePacks(
    List<BundledQuestionPackInfo> packs,
    LearnerProfile? learner, {
    String? topicCode,
  }) {
    if (learner == null) {
      return packs.where((pack) {
        if (!_currentlySupportedLaunchLevels.contains(pack.levelStage)) {
          return false;
        }
        if (topicCode != null && pack.topicCode != topicCode) {
          return false;
        }
        return pack.challengeTier == 'foundation';
      }).toList();
    }

    return packs.where((pack) {
      if (!_currentlySupportedLaunchLevels.contains(pack.levelStage)) {
        return false;
      }
      if (!isLevelStageWithinRange(
        pack.levelStage,
        minLevelStage: learner.effectiveMinLevelStage,
        maxLevelStage: learner.effectiveMaxLevelStage,
      )) {
        return false;
      }
      if (topicCode != null && pack.topicCode != topicCode) {
        return false;
      }
      return pack.challengeTier == 'foundation';
    }).toList();
  }

  static BundledQuestionPackInfo buildLaunchPack({
    required List<BundledQuestionPackInfo> selectedPacks,
    required int mergedQuestionCount,
    LearnerProfile? learner,
    String? topicCode,
  }) {
    final BundledQuestionPackInfo firstPack = selectedPacks.first;

    return BundledQuestionPackInfo(
      path: firstPack.path,
      topic: firstPack.topic,
      topicCode: topicCode ?? 'mixed',
      levelStage: learner == null
          ? firstPack.levelStage
          : learner.effectiveMaxLevelStage,
      challengeTier: 'foundation',
      questionCount: mergedQuestionCount,
    );
  }

  static List<Question> randomizeQuestionOrderForSession(
    List<Question> questions, {
    int? seed,
  }) {
    if (questions.length < 2) {
      return List<Question>.from(questions);
    }

    final List<Question> shuffled = List<Question>.from(questions);
    shuffled.shuffle(seed == null ? math.Random() : math.Random(seed));
    return shuffled;
  }

  /// Prefer questions this learner has not yet answered. Once the eligible
  /// pool is exhausted, retain every question so sessions can continue as
  /// randomized review.
  static List<Question> preferUnansweredQuestionsForLaunch(
    List<Question> questions, {
    required Set<String> answeredQuestionIds,
  }) {
    final List<Question> unanswered = questions
        .where(
            (Question question) => !answeredQuestionIds.contains(question.id))
        .toList(growable: false);
    return unanswered.isEmpty ? List<Question>.from(questions) : unanswered;
  }

  /// Takes up to [reviewCount] questions from [reviewQuestions] (earlier
  /// mistakes, most recent first) and fills the rest of [limit] from
  /// [freshQuestions], skipping any question already chosen for review.
  /// Review questions go last.
  static List<Question> mixInReviewQuestions(
    List<Question> freshQuestions, {
    required List<Question> reviewQuestions,
    required int limit,
    required int reviewCount,
  }) {
    final List<Question> review =
        reviewQuestions.take(math.min(reviewCount, limit)).toList();
    final Set<String> reviewIds =
        review.map((Question question) => question.id).toSet();
    // 錯題放在最後，先用新題暖身
    return <Question>[
      ...freshQuestions
          .where((Question question) => !reviewIds.contains(question.id))
          .take(limit - review.length),
      ...review,
    ];
  }

  /// 弱概念題目被抽中的權重（一般題目是 1）。
  static const double weakConceptWeight = 3;

  /// Weighted random order (Efraimidis–Spirakis): a question touching any of
  /// [weakConcepts] is [weakConceptWeight] times as likely to come earlier.
  static List<Question> randomizeWithConceptWeights(
    List<Question> questions, {
    required Set<String> weakConcepts,
    math.Random? random,
  }) {
    final math.Random rng = random ?? math.Random();
    final List<(double, Question)> keyed = <(double, Question)>[
      for (final Question question in questions)
        (
          math
              .pow(
                1 - rng.nextDouble(),
                1 /
                    (question.conceptTags.any(weakConcepts.contains)
                        ? weakConceptWeight
                        : 1),
              )
              .toDouble(),
          question,
        ),
    ]..sort(((double, Question) left, (double, Question) right) =>
        right.$1.compareTo(left.$1));
    return <Question>[for (final (double, Question) item in keyed) item.$2];
  }

  static List<Question> filterApprovedQuestionsForLaunch(
    List<Question> questions,
  ) {
    return questions
        .where((question) => question.isReviewApproved)
        .toList(growable: false);
  }
}
