class SessionAnswerRecord {
  const SessionAnswerRecord({
    required this.sessionId,
    required this.questionId,
    required this.sequence,
    required this.submittedAnswer,
    required this.isCorrect,
    required this.answeredAtIso,
  });

  final String sessionId;
  final String questionId;
  final int sequence;
  final String submittedAnswer;
  final bool isCorrect;
  final String answeredAtIso;

  Map<String, Object?> toMap() {
    return {
      'session_id': sessionId,
      'question_id': questionId,
      'sequence_number': sequence,
      'submitted_answer': submittedAnswer,
      'is_correct': isCorrect ? 1 : 0,
      'answered_at': answeredAtIso,
    };
  }

  factory SessionAnswerRecord.fromMap(Map<String, Object?> map) {
    return SessionAnswerRecord(
      sessionId: map['session_id']! as String,
      questionId: map['question_id']! as String,
      sequence: map['sequence_number']! as int,
      submittedAnswer: map['submitted_answer']! as String,
      isCorrect: (map['is_correct']! as int) == 1,
      answeredAtIso: map['answered_at']! as String,
    );
  }
}
