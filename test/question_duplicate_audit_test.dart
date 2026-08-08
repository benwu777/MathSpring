import 'package:flutter_test/flutter_test.dart';
import 'package:mathspring/services/question_bank_duplicate_audit.dart';

void main() {
  test('duplicate audit fingerprint ignores raw caret-vs-superscript notation differences', () {
    final DuplicateAuditQuestion caretQuestion = DuplicateAuditQuestion(
      id: 'algebra-001',
      topic: 'algebra',
      subtopic: 'quadratic_vertex',
      levelStage: 'grade10',
      promptZhHant: '設 f(x) = x^2 - 4x + 7，求最小值。',
      sourcePath: 'assets/questions/algebra/a.json',
    );
    final DuplicateAuditQuestion superscriptQuestion = DuplicateAuditQuestion(
      id: 'algebra-002',
      topic: 'algebra',
      subtopic: 'quadratic_vertex',
      levelStage: 'grade10',
      promptZhHant: '設 f(x) = x² - 4x + 7，求最小值。',
      sourcePath: 'assets/questions/algebra/b.json',
    );

    expect(
      QuestionBankDuplicateAudit.buildFingerprint(caretQuestion),
      QuestionBankDuplicateAudit.buildFingerprint(superscriptQuestion),
    );
  });
}
