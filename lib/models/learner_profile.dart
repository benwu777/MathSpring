class LearnerProfile {
  const LearnerProfile({
    required this.id,
    required this.displayName,
    required this.levelStage,
    required this.challengeTier,
    required this.createdAtIso,
  });

  final String id;
  final String displayName;
  final String levelStage;
  final String challengeTier;
  final String createdAtIso;

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'display_name': displayName,
      'level_stage': levelStage,
      'challenge_tier': challengeTier,
      'created_at': createdAtIso,
    };
  }

  factory LearnerProfile.fromMap(Map<String, Object?> map) {
    return LearnerProfile(
      id: map['id']! as String,
      displayName: map['display_name']! as String,
      levelStage: map['level_stage']! as String,
      challengeTier: map['challenge_tier']! as String,
      createdAtIso: map['created_at']! as String,
    );
  }
}
