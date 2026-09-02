import 'package:flutter_test/flutter_test.dart';
import 'package:mathspring/services/math_text_formatter.dart';

void main() {
  test('splits bold markers into emphasized and plain segments', () {
    final List<MathTextSegment> segments = splitEmphasis('求 **7** 元');

    expect(segments.length, 3);
    expect(segments[0].text, '求 ');
    expect(segments[0].emphasized, isFalse);
    expect(segments[1].text, '7');
    expect(segments[1].emphasized, isTrue);
    expect(segments[2].text, ' 元');
    expect(segments[2].emphasized, isFalse);
  });

  test('keeps plain text as a single unemphasized segment', () {
    final List<MathTextSegment> segments = splitEmphasis('沒有任何標記');

    expect(segments.length, 1);
    expect(segments.single.text, '沒有任何標記');
    expect(segments.single.emphasized, isFalse);
  });

  test('never leaves asterisks in the rendered text', () {
    for (final String source in <String>[
      '把 **2520** 做質因數分解。求它有多少個**不同的**質因數。',
      '**最小三位數**',
      '未閉合的 **標記',
      '空的 **** 標記',
    ]) {
      final String joined =
          splitEmphasis(source).map((MathTextSegment s) => s.text).join();
      expect(joined, isNot(contains('**')), reason: source);
    }
  });

  test('preserves the original characters apart from the markers', () {
    const String source = '求同時滿足下列兩個條件的**最小三位數**：各位數字之和是 15。';

    final String joined =
        splitEmphasis(source).map((MathTextSegment s) => s.text).join();

    expect(joined, '求同時滿足下列兩個條件的最小三位數：各位數字之和是 15。');
  });
}
