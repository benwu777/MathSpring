import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mathspring/services/math_text_formatter.dart';

/// 選項的數學排版一直沒有被驗過。題幹與詳解用 √ 的有一百多題，
/// 但選項裡出現 √ 是後來才有的事，而 `normalizeMathText` 會做指數上標轉換，
/// 誰也沒確認過它不會把 `2√5 / 5`、`(9 - √17) / 5` 這種字串改壞。
///
/// 這裡直接拿題庫裡真實的選項字串來跑，不自己編樣本——編出來的樣本只會
/// 涵蓋想得到的情形。
void main() {
  final List<String> mathOptions = <String>[];

  setUpAll(() {
    for (final FileSystemEntity topic
        in Directory('assets/questions').listSync()) {
      if (topic is! Directory) {
        continue;
      }
      for (final FileSystemEntity file in topic.listSync()) {
        if (file is! File || !file.path.endsWith('.json')) {
          continue;
        }
        final Map<String, dynamic> pack =
            jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
        for (final dynamic raw in pack['questions'] as List<dynamic>) {
          final Map<String, dynamic> q = raw as Map<String, dynamic>;
          final Map<String, dynamic>? options =
              q['options'] as Map<String, dynamic>?;
          if (options == null) {
            continue;
          }
          for (final dynamic option in options.values) {
            for (final String lang in <String>['zh-Hant', 'zh-Hans', 'en', 'ja']) {
              final String text =
                  (option as Map<String, dynamic>)[lang] as String;
              if (RegExp(r'[√^≤≥]').hasMatch(text)) {
                mathOptions.add(text);
              }
            }
          }
        }
      }
    }
  });

  test('題庫裡真的有帶數學符號的選項可以檢查', () {
    expect(mathOptions, isNotEmpty);
  });

  test('normalizeMathText 不會弄丟選項裡的根號', () {
    for (final String text in mathOptions) {
      final int before = '√'.allMatches(text).length;
      final int after = '√'.allMatches(normalizeMathText(text)).length;
      expect(after, before, reason: '「$text」正規化後根號數量變了');
    }
  });

  test('normalizeMathText 不會在根號選項裡留下 ^ 或半形不等號', () {
    for (final String text in mathOptions) {
      final String normalized = normalizeMathText(text);
      expect(normalized.contains('<='), isFalse, reason: text);
      expect(normalized.contains('>='), isFalse, reason: text);
    }
  });

  test('splitEmphasis 走完之後選項的可見文字一字不差', () {
    for (final String text in mathOptions) {
      final String normalized = normalizeMathText(text);
      final String rebuilt = splitEmphasis(normalized)
          .map((MathTextSegment s) => s.text)
          .join();
      expect(rebuilt, normalized, reason: '「$text」拆解後拼不回來');
      expect(rebuilt.contains('*'), isFalse, reason: '「$text」殘留星號');
    }
  });
}
