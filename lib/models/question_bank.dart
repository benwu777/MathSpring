import 'question.dart';

class QuestionBank {
  const QuestionBank({
    required this.version,
    required this.languages,
    required this.questions,
  });

  final int version;
  final List<String> languages;
  final List<Question> questions;

  factory QuestionBank.fromJson(Map<String, dynamic> json) {
    final List<dynamic> rawQuestions = json['questions'] as List<dynamic>? ?? const [];

    return QuestionBank(
      version: json['version'] as int? ?? 1,
      languages: List<String>.from(json['languages'] as List<dynamic>? ?? const []),
      questions: rawQuestions
          .map((item) => Question.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList(),
    );
  }
}
