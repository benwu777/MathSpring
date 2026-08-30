import 'package:flutter_test/flutter_test.dart';
import 'package:mathspring/services/formal_exam_preset.dart';

void main() {
  test('offers the agreed fixed formal exam presets', () {
    expect(FormalExamPreset.standard, hasLength(3));
    expect(
      FormalExamPreset.standard
          .map((FormalExamPreset preset) => <int>[
                preset.questionCount,
                preset.timeLimit.inMinutes,
              ])
          .toList(),
      <List<int>>[
        <int>[5, 10],
        <int>[10, 20],
        <int>[15, 30],
      ],
    );
  });
}
