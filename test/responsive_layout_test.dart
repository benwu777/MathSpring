import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mathspring/data/local/app_services.dart';
import 'package:mathspring/main.dart';
import 'package:mathspring/models/learner_profile.dart';
import 'package:mathspring/ui/layout_spec.dart';

/// 三種寬度下把每個主要畫面 pump 一次，確認版面沒有爆掉。
///
/// Flutter 在 debug 期會對 RenderFlex overflow 丟例外，`takeException()` 是
/// 唯一自動抓得到「版面爆掉」的手段——測試抓得到爆版，抓不到醜。
///
/// **一定要用 `tester.view.physicalSize` 而不是 `setSurfaceSize`**：
/// 後者不會改變 MediaQuery（實測設 390 之後仍回報 800），
/// 用它寫的寬度測試等於什麼都沒測到。
void main() {
  const List<(String, Size)> viewports = <(String, Size)>[
    ('iPhone 390', Size(390, 844)),
    ('iPad 直式 820', Size(820, 1180)),
    ('iPad 橫式 1180', Size(1180, 820)),
  ];

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

  Future<void> pumpAt(WidgetTester tester, Size size) async {
    await tester.binding.setSurfaceSize(null);
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = size;
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
  }

  for (final (String name, Size size) in viewports) {
    group(name, () {
      testWidgets('四個主要分頁都不會爆版', (WidgetTester tester) async {
        await pumpAt(tester, size);
        expect(tester.takeException(), isNull, reason: '$name 首頁就爆版了');

        for (final String tab in <String>['Quiz', 'Review', 'Settings', 'Practice']) {
          final Finder f = find.text(tab);
          if (f.evaluate().isEmpty) continue;
          await tester.tap(f.first);
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 300));
          expect(tester.takeException(), isNull, reason: '$name 的「$tab」分頁爆版');
        }
      });

      testWidgets('讀到正確的寬度級別', (WidgetTester tester) async {
        await pumpAt(tester, size);
        final BuildContext context =
            tester.element(find.byType(Scaffold).first);
        expect(LayoutSpec.of(context).widthClass,
            LayoutSpec.forWidth(size.width).widthClass);
      });
    });
  }

  // 分頁內容撐滿高度：外殼的 fill 只把分頁內容變成 Expanded，
  // 分頁自己沒有指定哪一塊撐開的話，空間會空在 Expanded 裡面，
  // 畫面下半部整片空白（iPad 上特別明顯）。
  testWidgets('測驗分頁的主卡片撐滿剩餘高度', (WidgetTester tester) async {
    await pumpAt(tester, const Size(820, 1180));
    await tester.tap(find.text('Quiz').last);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    final Finder card = find.byKey(const ValueKey<String>('section_card_Quiz'));
    expect(card, findsOneWidget);
    final double cardBottom = tester.getRect(card).bottom;
    final double navTop = tester.getRect(find.byType(NavigationBar)).top;

    // 卡片底部要貼近底部導覽列，而不是停在自然高度。
    expect(navTop - cardBottom, lessThan(60),
        reason: '卡片只有自然高度 ${tester.getSize(card).height}，'
            '下方空了 ${navTop - cardBottom} 沒撐開');
  });
}
