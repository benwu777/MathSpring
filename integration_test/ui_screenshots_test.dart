import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mathspring/data/local/app_services.dart';
import 'package:mathspring/main.dart';
import 'package:mathspring/models/answer_session.dart';
import 'package:mathspring/models/learner_profile.dart';
import 'package:mathspring/models/session_answer_record.dart';
import 'package:mathspring/services/monetization_service.dart';

/// 在真機或模擬器上拍介面截圖（設計確認、商店截圖用）。
///
///   flutter drive --driver=test_driver/integration_test.dart \
///     --target=integration_test/ui_screenshots_test.dart -d <device>
///
/// 學習紀錄用 [AppServices.forTesting] 的記憶體資料，不寫進裝置上的資料庫。
void main() {
  final IntegrationTestWidgetsFlutterBinding binding =
      IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  AnswerSession session(String id, String topic, String grade, int total,
          int correct, String day) =>
      AnswerSession(
        id: id,
        learnerId: 'learner_demo',
        mode: 'practice',
        topicCode: topic,
        levelStage: grade,
        challengeTier: 'foundation',
        startedAtIso: '${day}T09:00:00Z',
        endedAtIso: '${day}T09:20:00Z',
        elapsedSeconds: 1200,
        totalQuestions: total,
        correctCount: correct,
      );

  List<SessionAnswerRecord> records(String id, String day, int n, int wrong) =>
      List<SessionAnswerRecord>.generate(
        n,
        (int i) => SessionAnswerRecord(
          sessionId: id,
          questionId: '${id}_q$i',
          sequence: i + 1,
          submittedAnswer: 'A',
          isCorrect: i >= wrong,
          answeredAtIso:
              '${day}T09:${(i + 1).toString().padLeft(2, '0')}:00Z',
        ),
      );

  AppServices demoServices() {
    final String today =
        DateTime.now().toUtc().toIso8601String().substring(0, 10);
    final List<AnswerSession> sessions = <AnswerSession>[
      session('s_geo', 'geometry', 'grade5', 24, 21, today),
      session('s_alg', 'arithmetic', 'grade5', 22, 18, today),
      session('s_log', 'logic', 'grade5', 10, 8, today),
    ];
    return AppServices.forTesting(
      learnerProfiles: <LearnerProfile>[
        LearnerProfile(
          id: 'learner_demo',
          displayName: '小安',
          levelStage: 'grade5',
          minLevelStage: 'grade5',
          maxLevelStage: 'grade6',
          challengeTier: 'foundation',
          createdAtIso: '2026-09-01T00:00:00Z',
        ),
      ],
      currentLearnerId: 'learner_demo',
      initialSessions: sessions,
      initialSessionRecords: <String, List<SessionAnswerRecord>>{
        's_geo': records('s_geo', today, 24, 3),
        's_alg': records('s_alg', today, 22, 4),
        's_log': records('s_log', today, 10, 2),
      },
    );
  }

  Future<void> settle(WidgetTester tester) async {
    await tester.pumpAndSettle(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 400));
  }

  testWidgets('ui screenshots', (WidgetTester tester) async {
    binding.platformDispatcher.localeTestValue = const Locale('zh', 'TW');
    binding.platformDispatcher.localesTestValue = const <Locale>[
      Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant', countryCode: 'TW'),
    ];
    await tester.pumpWidget(MathSpringApp(
      services: demoServices(),
      monetizationService: NoopMonetizationService(),
      showWelcome: false,
    ));
    await settle(tester);
    await binding.convertFlutterSurfaceToImage();
    await settle(tester);
    await binding.takeScreenshot('01_home');

    await tester.tap(find.byKey(const ValueKey<String>('open_topic_practice')));
    await settle(tester);
    await binding.takeScreenshot('02_topic_picker');

    await tester.tap(find.byKey(const ValueKey<String>('topic_action_geometry')));
    await settle(tester);
    await binding.takeScreenshot('03_selected_topic');

    await tester.tap(find.byTooltip('學習回顧').first);
    await settle(tester);
    await binding.takeScreenshot('04_review');

    final Finder history = find.text('查看紀錄');
    await tester.scrollUntilVisible(history, 200,
        scrollable: find.byType(Scrollable).first);
    await settle(tester);
    await binding.takeScreenshot('05_review_scrolled');
    await tester.tap(history);
    await settle(tester);
    await binding.takeScreenshot('06_history');
  });
}
