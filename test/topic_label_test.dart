import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mathspring/main.dart';

void main() {
  const Locale zhHant = Locale('zh', 'TW');
  const Locale ja = Locale('ja');
  const Locale en = Locale('en');

  test('olympiad pack topics have localized labels instead of raw codes', () {
    final AppStrings zh = AppStrings(zhHant);
    expect(displayTopicCode('algebra', zh), '代數');
    expect(displayTopicCode('combinatorics', zh), '組合');
    expect(displayTopicCode('number_theory', zh), '數論');

    final AppStrings jp = AppStrings(ja);
    expect(displayTopicCode('algebra', jp), isNot('algebra'));
    expect(displayTopicCode('combinatorics', jp), isNot('combinatorics'));
    expect(displayTopicCode('number_theory', jp), isNot('number_theory'));

    final AppStrings eng = AppStrings(en);
    expect(displayTopicCode('algebra', eng), 'Algebra');
    expect(displayTopicCode('combinatorics', eng), 'Combinatorics');
    expect(displayTopicCode('number_theory', eng), 'Number Theory');
  });

  test('existing four topics keep their labels', () {
    final AppStrings zh = AppStrings(zhHant);
    expect(displayTopicCode('arithmetic', zh), '計算');
    expect(displayTopicCode('geometry', zh), '幾何');
    expect(displayTopicCode('logic', zh), '邏輯');
    expect(displayTopicCode('mixed', zh), '綜合');
  });

  test('every shipped pack topicCode resolves to a localized label', () {
    final AppStrings zh = AppStrings(zhHant);
    for (final String code in <String>[
      'arithmetic', 'geometry', 'logic', 'mixed',
      'algebra', 'combinatorics', 'number_theory',
    ]) {
      expect(displayTopicCode(code, zh), isNot(code),
          reason: '$code 仍顯示英文原字串');
    }
  });
}
