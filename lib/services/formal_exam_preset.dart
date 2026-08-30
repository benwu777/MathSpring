class FormalExamPreset {
  const FormalExamPreset({
    required this.questionCount,
    required this.timeLimit,
  });

  static const List<FormalExamPreset> standard = <FormalExamPreset>[
    FormalExamPreset(questionCount: 5, timeLimit: Duration(minutes: 10)),
    FormalExamPreset(questionCount: 10, timeLimit: Duration(minutes: 20)),
    FormalExamPreset(questionCount: 15, timeLimit: Duration(minutes: 30)),
  ];

  final int questionCount;
  final Duration timeLimit;
}
