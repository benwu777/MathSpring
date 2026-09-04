import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mathspring/models/question.dart';

/// 選項在畫面上要顯示成「代號 + 內容」，但有 11 題的內容本身就是代號
/// （例如「四顆蘋果 A、B、C、D，哪一顆比較重」的選項就是 A / B / C / D），
/// 直接串接會變成「A  A」。
Question _question(Map<String, String> labels) {
  return Question.fromJson(<String, dynamic>{
    'id': 'logic_grade4_foundation_999',
    'topic': 'logic',
    'difficulty': 'foundation',
    'levelStage': 'grade4',
    'challengeTier': 'foundation',
    'prompt': <String, String>{'zh-Hant': '題', 'zh-Hans': '题', 'en': 'q', 'ja': '問'},
    'answer': <String, String>{'zh-Hant': '答', 'zh-Hans': '答', 'en': 'a', 'ja': '答'},
    'solutionSteps': <String, dynamic>{
      'zh-Hant': <String>['步'], 'zh-Hans': <String>['步'],
      'en': <String>['s'], 'ja': <String>['ス'],
    },
    'figure': <String, dynamic>{'type': 'custom', 'kind': 'none', 'params': <String, dynamic>{}},
    'answerMode': 'multiple_choice',
    'correctAnswer': <String, String>{'type': 'choice', 'value': 'A'},
    'options': <String, dynamic>{
      for (final MapEntry<String, String> e in labels.entries)
        e.key: <String, String>{
          'zh-Hant': e.value, 'zh-Hans': e.value, 'en': e.value, 'ja': e.value,
        },
    },
  });
}

void main() {
  group('真實題庫', _realPackTests);

  test('一般選項顯示成「代號 + 內容」', () {
    final Question q = _question(<String, String>{'A': '星期一', 'B': '星期二'});
    expect(q.optionDisplayLabel('A', 'zh-Hant'), 'A  星期一');
  });

  test('內容本身就是代號時不重複顯示', () {
    // 修之前畫面上是「A  A」
    final Question q = _question(<String, String>{'A': 'A', 'B': 'B'});
    expect(q.optionDisplayLabel('A', 'zh-Hant'), 'A');
    expect(q.optionDisplayLabel('B', 'zh-Hant'), 'B');
  });

  test('前後空白不影響判斷', () {
    final Question q = _question(<String, String>{'A': ' A ', 'B': 'B'});
    expect(q.optionDisplayLabel('A', 'zh-Hant'), 'A');
  });

  test('內容只是以代號開頭時仍要顯示完整內容', () {
    // 「A 隊」不是重複，不可以被吃掉
    final Question q = _question(<String, String>{'A': 'A 隊', 'B': 'B 隊'});
    expect(q.optionDisplayLabel('A', 'zh-Hant'), 'A  A 隊');
  });

  test('找不到選項時回傳代號本身', () {
    final Question q = _question(<String, String>{'A': '甲', 'B': '乙'});
    expect(q.optionDisplayLabel('Z', 'zh-Hant'), 'Z');
  });
}

/// 整合測試：真實題庫裡沒有任何選項會顯示成重複的代號。
void _realPackTests() {
  test('全庫沒有選項顯示成「A  A」這種重複', () {
    final List<String> offenders = <String>[];
    int checked = 0;
    for (final FileSystemEntity topic
        in Directory('assets/questions').listSync()) {
      if (topic is! Directory) continue;
      for (final FileSystemEntity file in topic.listSync()) {
        if (file is! File || !file.path.endsWith('.json')) continue;
        final Map<String, dynamic> pack =
            jsonDecode((file).readAsStringSync()) as Map<String, dynamic>;
        for (final dynamic raw in pack['questions'] as List<dynamic>) {
          final Question q =
              Question.fromJson(Map<String, dynamic>.from(raw as Map));
          final Map<String, QuestionOption>? options = q.options;
          if (options == null) continue;
          for (final String key in options.keys) {
            checked++;
            final String shown = q.optionDisplayLabel(key, 'zh-Hant');
            if (shown == '$key  $key') {
              offenders.add('${q.id} 的選項 $key');
            }
          }
        }
      }
    }
    expect(checked, greaterThan(1000), reason: '應該檢查到大量選項');
    expect(offenders, isEmpty, reason: offenders.join('、'));
  });

  test('選項內容就是代號的那些題，顯示成單一代號', () {
    // 全庫有 11 題屬於此類，抽一題實際確認
    final File f = File(
        'assets/questions/logic/grade4_foundation.logic.v1.json');
    final Map<String, dynamic> pack =
        jsonDecode(f.readAsStringSync()) as Map<String, dynamic>;
    final Question q = (pack['questions'] as List<dynamic>)
        .map((dynamic r) => Question.fromJson(Map<String, dynamic>.from(r as Map)))
        .firstWhere((Question x) => x.id == 'logic_grade4_foundation_032');
    expect(q.optionDisplayLabel('A', 'zh-Hant'), 'A');
    expect(q.optionDisplayLabel('C', 'zh-Hant'), 'C');
  });
}
