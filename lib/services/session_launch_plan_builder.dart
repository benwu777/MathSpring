import 'package:mathspring/competition_profiles.dart';
import 'package:mathspring/data/bundled/bundled_question_bank_repository.dart';
import 'package:mathspring/models/learner_profile.dart';

class SessionLaunchPlanBuilder {
  static List<BundledQuestionPackInfo> pickEligiblePacks(
    List<BundledQuestionPackInfo> packs,
    LearnerProfile? learner, {
    String? topicCode,
  }) {
    if (topicCode == null) {
      final BundledQuestionPackInfo? dedicatedMixedPack =
          _findDedicatedMixedPack(packs, learner);
      if (dedicatedMixedPack != null) {
        return <BundledQuestionPackInfo>[dedicatedMixedPack];
      }
    }

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

  static BundledQuestionPackInfo? _findDedicatedMixedPack(
    List<BundledQuestionPackInfo> packs,
    LearnerProfile? learner,
  ) {
    final String targetLevelStage = learner == null
        ? packs.first.levelStage
        : representativeLevelStageForCompetitionProfile(
            competitionProfileIdForLevelStage(learner.levelStage),
          );

    for (final BundledQuestionPackInfo pack in packs) {
      if (pack.topicCode == 'mixed' &&
          pack.levelStage == targetLevelStage &&
          pack.challengeTier == 'foundation') {
        return pack;
      }
    }
    return null;
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
}
