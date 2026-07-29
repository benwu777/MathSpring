import 'dart:math' as math;

import 'package:mathspring/competition_profiles.dart';
import 'package:mathspring/data/bundled/bundled_question_bank_repository.dart';
import 'package:mathspring/models/learner_profile.dart';
import 'package:mathspring/models/question.dart';

class SessionLaunchPlanBuilder {
  static List<BundledQuestionPackInfo> pickEligiblePacks(
    List<BundledQuestionPackInfo> packs,
    LearnerProfile? learner, {
    String? topicCode,
  }) {
    if (learner == null) {
      return packs.where((pack) {
        if (topicCode != null && pack.topicCode != topicCode) {
          return false;
        }
        return pack.challengeTier == 'foundation';
      }).toList();
    }

    return filterPacksForCompetitionProfile(
      packs,
      competitionProfileId: competitionProfileIdForLevelStage(
        learner.levelStage,
      ),
      topicCode: topicCode,
      challengeTier: 'foundation',
    );
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
          : representativeLevelStageForCompetitionProfile(
              competitionProfileIdForLevelStage(learner.levelStage),
            ),
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
}
