import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mathspring/data/local/app_services.dart';
import 'package:mathspring/main.dart';
import 'package:mathspring/models/learner_profile.dart';

/// 首頁外殼要能套用滿版模式，唯一的阻礙是學習回顧裡的月曆用了 `GridView`。
///
/// viewport **無法回報 intrinsic 高度**，而滿版模式靠 `IntrinsicHeight` 讓
/// `Expanded` 在捲動區裡運作，兩者相衝：
/// `RenderShrinkWrappingViewport does not support returning intrinsic dimensions`。
///
/// 一個月最多 6×7 = 42 格，完全不需要延遲建構，用一般的 Column/Row 排即可。
void main() {
  AppServices services() => AppServices.forTesting(
        learnerProfiles: const <LearnerProfile>[
          LearnerProfile(
            id: 'learner_allen',
            displayName: 'Allen',
            levelStage: 'grade4',
            challengeTier: 'advanced',
            createdAtIso: '2026-07-16T00:00:00Z',
          ),
        ],
        currentLearnerId: 'learner_allen',
      );

  Future<void> openReview(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(null);
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(820, 1180);
    addTearDown(tester.view.reset);
    TestWidgetsFlutterBinding.ensureInitialized()
        .platformDispatcher
        .localeTestValue = const Locale('en');
    await tester.pumpWidget(MathSpringApp(services: services()));
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 50));
    });
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.text('Review').first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  }

  testWidgets('學習回顧的月曆不使用 lazy viewport', (WidgetTester tester) async {
    await openReview(tester);
    expect(tester.takeException(), isNull);
    expect(find.byType(GridView), findsNothing,
        reason: 'GridView 是 viewport，會擋住首頁的滿版模式');
  });

  testWidgets('月曆有星期標題列，且從週日起算', (WidgetTester tester) async {
    // 排版用 firstDay.weekday % 7 算前置空格（週日 = 7 → 0），
    // 所以標題列必須是「日一二三四五六」，否則日期會對錯欄。
    await openReview(tester);
    for (final String w in <String>['Sun', 'Mon', 'Sat']) {
      expect(find.text(w), findsOneWidget, reason: '缺少星期標題 $w');
    }
    // 標題列在日期之上
    final double sunTop = tester.getRect(find.text('Sun')).top;
    final double firstDayTop = tester.getRect(find.text('1')).top;
    expect(sunTop, lessThan(firstDayTop));
  });

  testWidgets('星期標題與日期欄位對齊', (WidgetTester tester) async {
    await openReview(tester);
    // 月曆顯示的是當月，所以要用當月 1 號實際的星期來對欄；
    // 寫死某一天（例如「9/1 是週二」）會在換月後失敗。
    const List<String> headers = <String>[
      'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat',
    ];
    final DateTime now = DateTime.now();
    final String expected =
        headers[DateTime(now.year, now.month, 1).weekday % 7];
    final double headerCenter = tester.getRect(find.text(expected)).center.dx;
    final double day1Center = tester.getRect(find.text('1')).center.dx;
    expect(day1Center, closeTo(headerCenter, 2.0),
        reason: '${now.month}/1 是 $expected，應對齊 $expected 欄');
  });

  testWidgets('月曆的日期仍然完整顯示且可點', (WidgetTester tester) async {
    await openReview(tester);
    final DateTime now = DateTime.now();
    final String key =
        'calendar_day_${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    expect(find.byKey(ValueKey<String>(key)), findsOneWidget,
        reason: '今天那一格應該在');
    await tester.tap(find.byKey(ValueKey<String>(key)));
    await tester.pump();
    expect(tester.takeException(), isNull);
  });
}
