import 'package:mathspring/data/bundled/bundled_question_bank_repository.dart';

const String kangaroo12ProfileId = 'kangaroo_1_2';
const String kangaroo34ProfileId = 'kangaroo_3_4';
const String kangaroo56ProfileId = 'kangaroo_5_6';

String competitionProfileIdForLevelStage(String levelStage) {
  switch (levelStage) {
    case 'grade1':
    case 'grade2':
      return kangaroo12ProfileId;
    case 'grade3':
    case 'grade4':
      return kangaroo34ProfileId;
    case 'grade5':
    case 'grade6':
    default:
      return kangaroo56ProfileId;
  }
}

List<String> levelStagesForCompetitionProfile(String competitionProfileId) {
  switch (competitionProfileId) {
    case kangaroo12ProfileId:
      return const ['grade1', 'grade2'];
    case kangaroo34ProfileId:
      return const ['grade3', 'grade4'];
    case kangaroo56ProfileId:
    default:
      return const ['grade5', 'grade6'];
  }
}

String representativeLevelStageForCompetitionProfile(String competitionProfileId) {
  switch (competitionProfileId) {
    case kangaroo12ProfileId:
      return 'grade2';
    case kangaroo34ProfileId:
      return 'grade4';
    case kangaroo56ProfileId:
    default:
      return 'grade6';
  }
}

List<BundledQuestionPackInfo> filterPacksForCompetitionProfile(
  List<BundledQuestionPackInfo> packs, {
  required String competitionProfileId,
  String? topicCode,
  String? challengeTier,
}) {
  final Set<String> allowedLevels = levelStagesForCompetitionProfile(
    competitionProfileId,
  ).toSet();
  return packs.where((pack) {
    if (!allowedLevels.contains(pack.levelStage)) {
      return false;
    }
    if (topicCode != null && pack.topicCode != topicCode) {
      return false;
    }
    if (challengeTier != null && pack.challengeTier != challengeTier) {
      return false;
    }
    return true;
  }).toList();
}
