import 'dart:convert';
import 'dart:io';

import 'package:mathspring/services/question_bank_duplicate_audit.dart';

void main(List<String> arguments) {
  String rootPath = Directory.current.path;
  String? inputPath;

  for (int index = 0; index < arguments.length; index += 1) {
    final String argument = arguments[index];
    if (argument == '--input' && index + 1 < arguments.length) {
      inputPath = arguments[index + 1];
      index += 1;
    } else if (argument == '--root' && index + 1 < arguments.length) {
      rootPath = arguments[index + 1];
      index += 1;
    }
  }

  final List<DuplicateAuditQuestion> questions =
      QuestionBankDuplicateAudit.loadQuestions(
    rootPath: rootPath,
    inputPath: inputPath,
  );
  final List<DuplicateReviewDecision> decisions =
      QuestionBankDuplicateAudit.loadDecisions(rootPath);
  final QuestionDuplicateAuditResult result =
      QuestionBankDuplicateAudit.analyze(questions, decisions);

  stdout.writeln(const JsonEncoder.withIndent('  ').convert(result.toJson()));
}
