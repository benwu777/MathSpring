class AnswerSession {
  const AnswerSession({
    required this.id,
    required this.learnerId,
    required this.mode,
    required this.topicCode,
    required this.levelStage,
    required this.challengeTier,
    required this.startedAtIso,
    required this.endedAtIso,
    required this.elapsedSeconds,
    required this.totalQuestions,
    required this.correctCount,
  });

  final String id;
  final String learnerId;
  final String mode;
  final String topicCode;
  final String levelStage;
  final String challengeTier;
  final String startedAtIso;
  final String endedAtIso;
  final int elapsedSeconds;
  final int totalQuestions;
  final int correctCount;

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'learner_id': learnerId,
      'mode': mode,
      'topic_code': topicCode,
      'level_stage': levelStage,
      'challenge_tier': challengeTier,
      'started_at': startedAtIso,
      'ended_at': endedAtIso,
      'elapsed_seconds': elapsedSeconds,
      'total_questions': totalQuestions,
      'correct_count': correctCount,
    };
  }

  factory AnswerSession.fromMap(Map<String, Object?> map) {
    return AnswerSession(
      id: map['id']! as String,
      learnerId: map['learner_id']! as String,
      mode: map['mode']! as String,
      topicCode: map['topic_code']! as String,
      levelStage: map['level_stage']! as String,
      challengeTier: map['challenge_tier']! as String,
      startedAtIso: map['started_at']! as String,
      endedAtIso: map['ended_at']! as String,
      elapsedSeconds: map['elapsed_seconds']! as int,
      totalQuestions: map['total_questions']! as int,
      correctCount: map['correct_count']! as int,
    );
  }
}
