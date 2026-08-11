class LearnerProfile {
  const LearnerProfile({
    required this.id,
    required this.displayName,
    required this.levelStage,
    this.minLevelStage,
    this.maxLevelStage,
    required this.challengeTier,
    required this.createdAtIso,
  });

  final String id;
  final String displayName;
  final String levelStage;
  final String? minLevelStage;
  final String? maxLevelStage;
  final String challengeTier;
  final String createdAtIso;

  String get effectiveMinLevelStage {
    return minLevelStage ?? _legacyMinLevelStage(levelStage);
  }

  String get effectiveMaxLevelStage {
    return maxLevelStage ?? _legacyMaxLevelStage(levelStage);
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'display_name': displayName,
      'level_stage': levelStage,
      'min_level_stage': effectiveMinLevelStage,
      'max_level_stage': effectiveMaxLevelStage,
      'challenge_tier': challengeTier,
      'created_at': createdAtIso,
    };
  }

  factory LearnerProfile.fromMap(Map<String, Object?> map) {
    return LearnerProfile(
      id: map['id']! as String,
      displayName: map['display_name']! as String,
      levelStage: map['level_stage']! as String,
      minLevelStage: map['min_level_stage'] as String?,
      maxLevelStage: map['max_level_stage'] as String?,
      challengeTier: map['challenge_tier']! as String,
      createdAtIso: map['created_at']! as String,
    );
  }
}

String _legacyMinLevelStage(String levelStage) {
  switch (levelStage) {
    case 'grade2':
      return 'grade1';
    case 'grade4':
      return 'grade3';
    case 'grade6':
      return 'grade5';
    default:
      return levelStage;
  }
}

String _legacyMaxLevelStage(String levelStage) {
  switch (levelStage) {
    case 'grade2':
      return 'grade2';
    case 'grade4':
      return 'grade4';
    case 'grade6':
      return 'grade6';
    default:
      return levelStage;
  }
}
