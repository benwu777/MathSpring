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

  static List<Question> filterApprovedQuestionsForLaunch(
    List<Question> questions,
  ) {
    return questions
        .where((question) => question.isReviewApproved)
        .toList(growable: false);
  }
}
