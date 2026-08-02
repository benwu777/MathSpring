int levelStageNumber(String levelStage) {
  return int.parse(levelStage.replaceFirst('grade', ''));
}

String levelStageFromNumber(int grade) {
  return 'grade$grade';
}

bool isLevelStageWithinRange(
  String levelStage, {
  required String minLevelStage,
  required String maxLevelStage,
}) {
  final int grade = levelStageNumber(levelStage);
  final int lower = levelStageNumber(minLevelStage);
  final int upper = levelStageNumber(maxLevelStage);
  return grade >= lower && grade <= upper;
}

List<String> levelStagesInRange({
  required String minLevelStage,
  required String maxLevelStage,
}) {
  final int lower = levelStageNumber(minLevelStage);
  final int upper = levelStageNumber(maxLevelStage);
  return List<String>.generate(
    upper - lower + 1,
    (index) => levelStageFromNumber(lower + index),
  );
}
