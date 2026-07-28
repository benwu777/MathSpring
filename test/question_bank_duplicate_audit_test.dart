import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('duplicate audit tool groups obvious numeric and story reskins together', () async {
    final Directory tempDir = await Directory.systemTemp.createTemp('mathspring-duplicate-audit-');
    addTearDown(() => tempDir.delete(recursive: true));

    final File fixture = File('${tempDir.path}/sample_questions.json');
    await fixture.writeAsString(jsonEncode({
      'questions': [
        {
          'id': 'q1',
          'topic': 'arithmetic',
          'subtopic': 'work_backwards',
          'levelStage': 'grade2',
          'prompt': {
            'zh-Hant': '一個數先乘以 3，再加上 5，結果比原來的數多 21。原來的數是多少？',
          },
        },
        {
          'id': 'q2',
          'topic': 'arithmetic',
          'subtopic': 'work_backwards',
          'levelStage': 'grade2',
          'prompt': {
            'zh-Hant': '某個數先乘以 4，再加上 6，結果比原來的數多 24。原來的數是多少？',
          },
        },
        {
          'id': 'q3',
          'topic': 'arithmetic',
          'subtopic': 'balance_transfer',
          'levelStage': 'grade1',
          'prompt': {
            'zh-Hant': '哥哥和妹妹一共有 20 張貼紙。若妹妹送給哥哥 4 張後，兩人的貼紙就一樣多。妹妹原本有幾張貼紙？',
          },
        },
        {
          'id': 'q4',
          'topic': 'arithmetic',
          'subtopic': 'balance_transfer',
          'levelStage': 'grade1',
          'prompt': {
            'zh-Hant': '小安和小美一共有 24 顆糖果。若小美給小安 3 顆後，兩人就一樣多。小美原本有幾顆糖果？',
          },
        },
      ],
    }));

    final ProcessResult result = await Process.run(
      'dart',
      [
        'run',
        'tool/question_bank_duplicate_audit.dart',
        '--input',
        fixture.path,
      ],
      workingDirectory: Directory.current.path,
    );

    expect(result.exitCode, 0, reason: result.stderr.toString());

    final Map<String, dynamic> payload =
        jsonDecode(result.stdout.toString()) as Map<String, dynamic>;
    final List<dynamic> groups = payload['candidateGroups'] as List<dynamic>;

    final bool hasWorkBackwardsGroup = groups.any((dynamic group) {
      final List<dynamic> ids = (group as Map<String, dynamic>)['questionIds'] as List<dynamic>;
      return ids.length == 2 && ids.contains('q1') && ids.contains('q2');
    });

    final bool hasBalanceTransferGroup = groups.any((dynamic group) {
      final List<dynamic> ids = (group as Map<String, dynamic>)['questionIds'] as List<dynamic>;
      return ids.length == 2 && ids.contains('q3') && ids.contains('q4');
    });

    expect(hasWorkBackwardsGroup, isTrue);
    expect(hasBalanceTransferGroup, isTrue);
  });

  test('duplicate audit tool only scans packs listed in manifest by default', () async {
    final Directory tempDir =
        await Directory.systemTemp.createTemp('mathspring-duplicate-manifest-');
    addTearDown(() => tempDir.delete(recursive: true));

    final Directory assetsDir = Directory('${tempDir.path}/assets/questions');
    await assetsDir.create(recursive: true);
    final Directory mixedDir = Directory('${assetsDir.path}/mixed');
    await mixedDir.create(recursive: true);

    final File manifest = File('${assetsDir.path}/manifest.json');
    await manifest.writeAsString(jsonEncode({
      'version': 1,
      'packs': [
        {
          'path': 'assets/questions/mixed/grade5_foundation.mixed.v1.json',
          'topicCode': 'mixed',
          'levelStage': 'grade5',
          'challengeTier': 'foundation',
          'questionCount': 1,
        },
      ],
    }));

    final Map<String, dynamic> duplicatePromptQuestion = {
      'id': 'shared_question',
      'topic': 'mixed',
      'subtopic': 'truth_statements',
      'levelStage': 'grade5',
      'prompt': {
        'zh-Hant': '四個盒子 A、B、C、D 只有一個有硬幣。標籤寫著：A「硬幣在 D」，B「硬幣不在 A」，C「硬幣不在 D」，D「硬幣在 B」。已知恰好只有一句真話，硬幣在哪裡？',
      },
    };

    await File('${mixedDir.path}/grade5_foundation.mixed.v1.json')
        .writeAsString(jsonEncode({'questions': [duplicatePromptQuestion]}));
    await File('${mixedDir.path}/kangaroo56_foundation.mixed.v1.json')
        .writeAsString(jsonEncode({'questions': [duplicatePromptQuestion]}));

    final ProcessResult result = await Process.run(
      'dart',
      [
        'run',
        'tool/question_bank_duplicate_audit.dart',
        '--root',
        tempDir.path,
      ],
      workingDirectory: Directory.current.path,
    );

    expect(result.exitCode, 0, reason: result.stderr.toString());

    final Map<String, dynamic> payload =
        jsonDecode(result.stdout.toString()) as Map<String, dynamic>;
    expect(payload['scannedQuestions'], 1);
    expect(payload['candidateGroups'], isEmpty);
  });

  test('duplicate audit tool skips groups marked as acceptable variants', () async {
    final Directory tempDir =
        await Directory.systemTemp.createTemp('mathspring-duplicate-decisions-');
    addTearDown(() => tempDir.delete(recursive: true));

    final Directory assetsDir = Directory('${tempDir.path}/assets/questions/arithmetic');
    await assetsDir.create(recursive: true);
    final Directory docsDir = Directory('${tempDir.path}/docs');
    await docsDir.create(recursive: true);

    await File('${tempDir.path}/assets/questions/manifest.json')
        .writeAsString(jsonEncode({
      'version': 1,
      'packs': [
        {
          'path': 'assets/questions/arithmetic/sample.json',
          'topicCode': 'arithmetic',
          'levelStage': 'grade5',
          'challengeTier': 'foundation',
          'questionCount': 2,
        },
      ],
    }));

    await File('${assetsDir.path}/sample.json').writeAsString(jsonEncode({
      'questions': [
        {
          'id': 'age_a',
          'topic': 'arithmetic',
          'subtopic': 'age_problem',
          'levelStage': 'grade5',
          'prompt': {
            'zh-Hant': '爸爸和小華今年年齡合起來是 42 歲。6 年後，爸爸的年齡會是小華的 2 倍。小華今年幾歲？',
          },
        },
        {
          'id': 'age_b',
          'topic': 'arithmetic',
          'subtopic': 'age_problem',
          'levelStage': 'grade6',
          'prompt': {
            'zh-Hant': '媽媽比小明大 24 歲。3 年後，媽媽的年齡會是小明的 3 倍。小明今年幾歲？',
          },
        },
      ],
    }));

    await File('${docsDir.path}/question-bank-duplicate-decisions.json')
        .writeAsString(jsonEncode({
      'groups': [
        {
          'status': 'acceptable_variant',
          'topic': 'arithmetic',
          'subtopic': 'age_problem',
          'questionIds': ['age_a', 'age_b'],
        },
      ],
    }));

    final ProcessResult result = await Process.run(
      'dart',
      [
        'run',
        'tool/question_bank_duplicate_audit.dart',
        '--root',
        tempDir.path,
      ],
      workingDirectory: Directory.current.path,
    );

    expect(result.exitCode, 0, reason: result.stderr.toString());

    final Map<String, dynamic> payload =
        jsonDecode(result.stdout.toString()) as Map<String, dynamic>;
    expect(payload['candidateGroups'], isEmpty);
  });

  test('duplicate audit tool separates clearly different perimeter-area structures', () async {
    final Directory tempDir =
        await Directory.systemTemp.createTemp('mathspring-duplicate-perimeter-');
    addTearDown(() => tempDir.delete(recursive: true));

    final File fixture = File('${tempDir.path}/sample_questions.json');
    await fixture.writeAsString(jsonEncode({
      'questions': [
        {
          'id': 'p1',
          'topic': 'geometry',
          'subtopic': 'perimeter_area',
          'levelStage': 'grade3',
          'prompt': {
            'zh-Hant': '5 個邊長 1 的小正方形排成一直線。新圖形的周長是多少？',
          },
        },
        {
          'id': 'p2',
          'topic': 'geometry',
          'subtopic': 'perimeter_area',
          'levelStage': 'grade3',
          'prompt': {
            'zh-Hant': '一個長方形的周長是 20，其中一條長邊長 6。這個長方形的面積是多少？',
          },
        },
      ],
    }));

    final ProcessResult result = await Process.run(
      'dart',
      [
        'run',
        'tool/question_bank_duplicate_audit.dart',
        '--input',
        fixture.path,
      ],
      workingDirectory: Directory.current.path,
    );

    expect(result.exitCode, 0, reason: result.stderr.toString());

    final Map<String, dynamic> payload =
        jsonDecode(result.stdout.toString()) as Map<String, dynamic>;
    expect(payload['candidateGroups'], isEmpty);
  });

  test('duplicate audit tool separates clearly different trapezoid-area structures', () async {
    final Directory tempDir =
        await Directory.systemTemp.createTemp('mathspring-duplicate-trapezoid-');
    addTearDown(() => tempDir.delete(recursive: true));

    final File fixture = File('${tempDir.path}/sample_questions.json');
    await fixture.writeAsString(jsonEncode({
      'questions': [
        {
          'id': 't1',
          'topic': 'geometry',
          'subtopic': 'trapezoid_area',
          'levelStage': 'grade5',
          'prompt': {
            'zh-Hant': '兩個完全一樣的梯形可以拼成一個平行四邊形。若每個梯形的上底是 8 公分、下底是 14 公分、高是 5 公分，拼成的平行四邊形面積是多少平方公分？',
          },
        },
        {
          'id': 't2',
          'topic': 'geometry',
          'subtopic': 'trapezoid_area',
          'levelStage': 'grade5',
          'prompt': {
            'zh-Hant': '一個梯形的中位線長 11 公分，高是 8 公分。已知下底比上底長 6 公分。這個梯形的下底是多少公分？',
          },
        },
      ],
    }));

    final ProcessResult result = await Process.run(
      'dart',
      [
        'run',
        'tool/question_bank_duplicate_audit.dart',
        '--input',
        fixture.path,
      ],
      workingDirectory: Directory.current.path,
    );

    expect(result.exitCode, 0, reason: result.stderr.toString());

    final Map<String, dynamic> payload =
        jsonDecode(result.stdout.toString()) as Map<String, dynamic>;
    expect(payload['candidateGroups'], isEmpty);
  });

  test('duplicate audit tool separates different arrangement constraint structures', () async {
    final Directory tempDir =
        await Directory.systemTemp.createTemp('mathspring-duplicate-arrangements-');
    addTearDown(() => tempDir.delete(recursive: true));

    final File fixture = File('${tempDir.path}/sample_questions.json');
    await fixture.writeAsString(jsonEncode({
      'questions': [
        {
          'id': 'a1',
          'topic': 'arithmetic',
          'subtopic': 'arrangements',
          'levelStage': 'grade1',
          'prompt': {
            'zh-Hant': '3 位小朋友排成一列，共有幾種不同排法？',
          },
        },
        {
          'id': 'a2',
          'topic': 'arithmetic',
          'subtopic': 'arrangements',
          'levelStage': 'grade4',
          'prompt': {
            'zh-Hant': '6 位好朋友排成一排拍照，其中甲和乙兩人堅持要排在相鄰的位置。共有幾種不同的排法？',
          },
        },
      ],
    }));

    final ProcessResult result = await Process.run(
      'dart',
      [
        'run',
        'tool/question_bank_duplicate_audit.dart',
        '--input',
        fixture.path,
      ],
      workingDirectory: Directory.current.path,
    );

    expect(result.exitCode, 0, reason: result.stderr.toString());

    final Map<String, dynamic> payload =
        jsonDecode(result.stdout.toString()) as Map<String, dynamic>;
    expect(payload['candidateGroups'], isEmpty);
  });

  test('duplicate audit tool separates different ordering query structures', () async {
    final Directory tempDir =
        await Directory.systemTemp.createTemp('mathspring-duplicate-ordering-');
    addTearDown(() => tempDir.delete(recursive: true));

    final File fixture = File('${tempDir.path}/sample_questions.json');
    await fixture.writeAsString(jsonEncode({
      'questions': [
        {
          'id': 'o1',
          'topic': 'logic',
          'subtopic': 'ordering',
          'levelStage': 'grade1',
          'prompt': {
            'zh-Hant': '小安排在小貝前面，小貝排在小可前面。誰排在中間？',
          },
        },
        {
          'id': 'o2',
          'topic': 'logic',
          'subtopic': 'ordering',
          'levelStage': 'grade5',
          'prompt': {
            'zh-Hant': 'Q 在最左邊，R 在 S 左邊，S 在 T 左邊，U 在最右邊。誰排第三個？',
          },
        },
      ],
    }));

    final ProcessResult result = await Process.run(
      'dart',
      [
        'run',
        'tool/question_bank_duplicate_audit.dart',
        '--input',
        fixture.path,
      ],
      workingDirectory: Directory.current.path,
    );

    expect(result.exitCode, 0, reason: result.stderr.toString());

    final Map<String, dynamic> payload =
        jsonDecode(result.stdout.toString()) as Map<String, dynamic>;
    expect(payload['candidateGroups'], isEmpty);
  });

  test('duplicate audit tool separates position-direction concept families', () async {
    final Directory tempDir =
        await Directory.systemTemp.createTemp('mathspring-duplicate-position-direction-');
    addTearDown(() => tempDir.delete(recursive: true));

    final File fixture = File('${tempDir.path}/sample_questions.json');
    await fixture.writeAsString(jsonEncode({
      'questions': [
        {
          'id': 'pd1',
          'topic': 'geometry',
          'subtopic': 'position_direction',
          'levelStage': 'grade1',
          'prompt': {
            'zh-Hant': '小球在盒子的裡面，哪一個詞最適合描述它的位置？',
          },
        },
        {
          'id': 'pd2',
          'topic': 'geometry',
          'subtopic': 'position_direction',
          'levelStage': 'grade2',
          'prompt': {
            'zh-Hant': '小明面向北方，先向右轉，再向後轉。現在他面向哪個方向？',
          },
        },
      ],
    }));

    final ProcessResult result = await Process.run(
      'dart',
      [
        'run',
        'tool/question_bank_duplicate_audit.dart',
        '--input',
        fixture.path,
      ],
      workingDirectory: Directory.current.path,
    );

    expect(result.exitCode, 0, reason: result.stderr.toString());

    final Map<String, dynamic> payload =
        jsonDecode(result.stdout.toString()) as Map<String, dynamic>;
    expect(payload['candidateGroups'], isEmpty);
  });

  test('duplicate audit tool separates different shape-property reasoning structures', () async {
    final Directory tempDir =
        await Directory.systemTemp.createTemp('mathspring-duplicate-shapes-properties-');
    addTearDown(() => tempDir.delete(recursive: true));

    final File fixture = File('${tempDir.path}/sample_questions.json');
    await fixture.writeAsString(jsonEncode({
      'questions': [
        {
          'id': 'sp1',
          'topic': 'geometry',
          'subtopic': 'shapes_properties',
          'levelStage': 'grade1',
          'prompt': {
            'zh-Hant': '哪一個圖形沒有角？',
          },
        },
        {
          'id': 'sp2',
          'topic': 'geometry',
          'subtopic': 'shapes_properties',
          'levelStage': 'grade1',
          'prompt': {
            'zh-Hant': '老師說：「一個圖形只要四個角都一樣大，四條邊也一定會一樣長。」小恩想找一個圖形來反駁老師，他應該選下面哪一個？',
          },
        },
      ],
    }));

    final ProcessResult result = await Process.run(
      'dart',
      [
        'run',
        'tool/question_bank_duplicate_audit.dart',
        '--input',
        fixture.path,
      ],
      workingDirectory: Directory.current.path,
    );

    expect(result.exitCode, 0, reason: result.stderr.toString());

    final Map<String, dynamic> payload =
        jsonDecode(result.stdout.toString()) as Map<String, dynamic>;
    expect(payload['candidateGroups'], isEmpty);
  });

  test('duplicate audit tool separates border total from side-recovery prompts', () async {
    final Directory tempDir =
        await Directory.systemTemp.createTemp('mathspring-duplicate-border-counting-');
    addTearDown(() => tempDir.delete(recursive: true));

    final File fixture = File('${tempDir.path}/sample_questions.json');
    await fixture.writeAsString(jsonEncode({
      'questions': [
        {
          'id': 'b1',
          'topic': 'geometry',
          'subtopic': 'border_counting',
          'levelStage': 'grade3',
          'prompt': {
            'zh-Hant': '一個長方形棋盤，沿著邊框排棋子：長的一邊（含兩端的角）排 7 顆，寬的一邊（含兩端的角）排 5 顆，四個角上的棋子由相鄰兩邊共用，不重複算。整個邊框一共排了幾顆棋子？',
          },
        },
        {
          'id': 'b2',
          'topic': 'geometry',
          'subtopic': 'border_counting',
          'levelStage': 'grade2',
          'prompt': {
            'zh-Hant': '一個長方形花壇，沿著邊框排磚：長邊（含兩端的角）排的磚，比短邊（含兩端的角）排的磚多 3 顆；四個角上的磚由相鄰兩邊共用，不重複算。已知整個邊框一共排了 34 顆磚，長邊排了幾顆？',
          },
        },
      ],
    }));

    final ProcessResult result = await Process.run(
      'dart',
      [
        'run',
        'tool/question_bank_duplicate_audit.dart',
        '--input',
        fixture.path,
      ],
      workingDirectory: Directory.current.path,
    );

    expect(result.exitCode, 0, reason: result.stderr.toString());

    final Map<String, dynamic> payload =
        jsonDecode(result.stdout.toString()) as Map<String, dynamic>;
    expect(payload['candidateGroups'], isEmpty);
  });

  test('duplicate audit tool separates different pigeonhole bucket families', () async {
    final Directory tempDir =
        await Directory.systemTemp.createTemp('mathspring-duplicate-pigeonhole-');
    addTearDown(() => tempDir.delete(recursive: true));

    final File fixture = File('${tempDir.path}/sample_questions.json');
    await fixture.writeAsString(jsonEncode({
      'questions': [
        {
          'id': 'p1',
          'topic': 'logic',
          'subtopic': 'pigeonhole',
          'levelStage': 'grade4',
          'prompt': {
            'zh-Hant': '只有星期一到星期日這 7 種星期幾。最少要選幾個日期，才能保證其中至少兩個日期是同一個星期幾？',
          },
        },
        {
          'id': 'p2',
          'topic': 'logic',
          'subtopic': 'pigeonhole',
          'levelStage': 'grade6',
          'prompt': {
            'zh-Hant': '最少要有幾個整數，才能保證其中至少有兩個數除以 9 的餘數相同？',
          },
        },
      ],
    }));

    final ProcessResult result = await Process.run(
      'dart',
      [
        'run',
        'tool/question_bank_duplicate_audit.dart',
        '--input',
        fixture.path,
      ],
      workingDirectory: Directory.current.path,
    );

    expect(result.exitCode, 0, reason: result.stderr.toString());

    final Map<String, dynamic> payload =
        jsonDecode(result.stdout.toString()) as Map<String, dynamic>;
    expect(payload['candidateGroups'], isEmpty);
  });

  test('duplicate audit tool separates different logical comparison query types', () async {
    final Directory tempDir =
        await Directory.systemTemp.createTemp('mathspring-duplicate-logic-comparison-');
    addTearDown(() => tempDir.delete(recursive: true));

    final File fixture = File('${tempDir.path}/sample_questions.json');
    await fixture.writeAsString(jsonEncode({
      'questions': [
        {
          'id': 'c1',
          'topic': 'logic',
          'subtopic': 'comparison',
          'levelStage': 'grade1',
          'prompt': {
            'zh-Hant': '阿吉比阿寶高。誰比較矮？',
          },
        },
        {
          'id': 'c2',
          'topic': 'logic',
          'subtopic': 'comparison',
          'levelStage': 'grade2',
          'prompt': {
            'zh-Hant': '小船比汽車慢，腳踏車比小船快。三者中誰最快？',
          },
        },
      ],
    }));

    final ProcessResult result = await Process.run(
      'dart',
      [
        'run',
        'tool/question_bank_duplicate_audit.dart',
        '--input',
        fixture.path,
      ],
      workingDirectory: Directory.current.path,
    );

    expect(result.exitCode, 0, reason: result.stderr.toString());

    final Map<String, dynamic> payload =
        jsonDecode(result.stdout.toString()) as Map<String, dynamic>;
    expect(payload['candidateGroups'], isEmpty);
  });
}
