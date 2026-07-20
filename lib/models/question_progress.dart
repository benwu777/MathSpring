class QuestionProgress {
  const QuestionProgress({
    required this.learnerId,
    required this.questionId,
    required this.status,
    required this.lastResult,
    required this.updatedAtIso,
  });

  final String learnerId;
  final String questionId;
  final String status;
  final String lastResult;
  final String updatedAtIso;

  QuestionProgress copyWith({
    String? learnerId,
    String? questionId,
    String? status,
    String? lastResult,
    String? updatedAtIso,
  }) {
    return QuestionProgress(
      learnerId: learnerId ?? this.learnerId,
      questionId: questionId ?? this.questionId,
      status: status ?? this.status,
      lastResult: lastResult ?? this.lastResult,
      updatedAtIso: updatedAtIso ?? this.updatedAtIso,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'learner_id': learnerId,
      'question_id': questionId,
      'status': status,
      'last_result': lastResult,
      'updated_at': updatedAtIso,
    };
  }

  factory QuestionProgress.fromMap(Map<String, Object?> map) {
    return QuestionProgress(
      learnerId: map['learner_id']! as String,
      questionId: map['question_id']! as String,
      status: map['status']! as String,
      lastResult: map['last_result']! as String,
      updatedAtIso: map['updated_at']! as String,
    );
  }
}
