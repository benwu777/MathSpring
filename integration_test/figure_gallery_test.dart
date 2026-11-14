import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mathspring/data/bundled/bundled_question_bank_repository.dart';
import 'package:mathspring/main.dart';
import 'package:mathspring/models/question.dart';
import 'package:mathspring/models/question_bank.dart';

/// 在模擬器上用 iOS 的字型把題目附圖畫出來，一頁 3 張截圖（題號在每張圖上方）。
///
///   flutter drive --driver=test_driver/integration_test.dart \
///     --target=integration_test/figure_gallery_test.dart -d <simulator> \
///     --dart-define=IDS_FILE=/絕對路徑/ids.json
///
/// IDS_FILE 是題號的 JSON 陣列；模擬器讀得到 Mac 上的檔案。沒給就畫全部有圖的題。
/// DRAFT_FILE 則直接畫草稿檔裡的題（修圖時用）。
void main() {
  final IntegrationTestWidgetsFlutterBinding binding =
      IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('figure gallery', (WidgetTester tester) async {
    const String idsFile = String.fromEnvironment('IDS_FILE');
    final Set<String>? wanted = idsFile.isEmpty
        ? null
        : (jsonDecode(File(idsFile).readAsStringSync()) as List<dynamic>)
            .cast<String>()
            .toSet();

    // DRAFT_FILE：修圖用的草稿（[{"key":…, "question":{…}}]），直接畫草稿裡的圖，
    // 不必先寫回題庫。
    const String draftFile = String.fromEnvironment('DRAFT_FILE');
    final List<Question> questions;
    if (draftFile.isNotEmpty) {
      questions = <Question>[
        for (final dynamic d
            in jsonDecode(File(draftFile).readAsStringSync()) as List<dynamic>)
          Question.fromJson(<String, dynamic>{
            ...Map<String, dynamic>.from(
                (d as Map<String, dynamic>)['question'] as Map),
            'id': d['key'],
          }),
      ];
    } else {
      final List<QuestionBank> packs =
          await BundledQuestionBankRepository().loadAllPacks();
      questions = <Question>[
        for (final QuestionBank pack in packs)
          for (final Question q in pack.questions)
            if ((wanted == null || wanted.contains(q.id)) &&
                buildFigureRenderSpec(q.figure) != null)
              q,
      ]..sort((Question a, Question b) => a.id.compareTo(b.id));
    }

    await binding.convertFlutterSurfaceToImage();
    const int perPage = 3;
    for (int start = 0; start < questions.length; start += perPage) {
      final List<Question> page = questions.sublist(
          start, (start + perPage).clamp(0, questions.length));
      await tester.pumpWidget(MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: const Color(0xFFF8F8F5),
          body: SafeArea(
            // 一欄、寬度和題目頁的內容欄差不多，才看得出真實大小下標籤擠不擠。
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: <Widget>[
                for (final Question q in page)
                  Container(
                    height: 250,
                    margin: const EdgeInsets.only(bottom: 12),
                    color: Colors.white,
                    padding: const EdgeInsets.all(6),
                    child: Column(
                      children: <Widget>[
                        Text(q.id,
                            style: const TextStyle(
                                fontSize: 10, color: Color(0xFF5E6E69))),
                        const SizedBox(height: 4),
                        Expanded(
                          child: Center(
                            child: AspectRatio(
                              aspectRatio:
                                  buildFigureRenderSpec(q.figure)!.aspectRatio,
                              child: buildFigureRenderSpec(q.figure)!.child,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      await binding.takeScreenshot(
          'figs_${(start ~/ perPage + 1).toString().padLeft(2, '0')}');
    }
  });
}
