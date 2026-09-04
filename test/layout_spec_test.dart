import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mathspring/ui/layout_spec.dart';

/// 版面分級的唯一真實來源。這一層是純函式，最便宜也最該釘死：
/// 斷點的 off-by-one 與「調值時不小心讓 iPad 比 iPhone 還小」都在這裡擋。
void main() {
  group('斷點', () {
    test('599 是 compact，600 進 medium', () {
      expect(LayoutSpec.forWidth(599).widthClass, WidthClass.compact);
      expect(LayoutSpec.forWidth(600).widthClass, WidthClass.medium);
    });

    test('999 仍是 medium，1000 進 expanded', () {
      expect(LayoutSpec.forWidth(999).widthClass, WidthClass.medium);
      expect(LayoutSpec.forWidth(1000).widthClass, WidthClass.expanded);
    });

    test('實際裝置寬度落在預期的級別', () {
      expect(LayoutSpec.forWidth(390).widthClass, WidthClass.compact,
          reason: 'iPhone 14/15');
      expect(LayoutSpec.forWidth(430).widthClass, WidthClass.compact,
          reason: 'iPhone Pro Max');
      expect(LayoutSpec.forWidth(820).widthClass, WidthClass.medium,
          reason: 'iPad 直式');
      expect(LayoutSpec.forWidth(1180).widthClass, WidthClass.expanded,
          reason: 'iPad 橫式');
    });
  });

  group('三級數值', () {
    final LayoutSpec c = LayoutSpec.forWidth(390);
    final LayoutSpec m = LayoutSpec.forWidth(820);
    final LayoutSpec e = LayoutSpec.forWidth(1180);

    test('每個字級代號都必須隨寬度遞增', () {
      // 這條擋的是「調某一級時讓 iPad 比 iPhone 還小」——最容易犯又最難目視發現
      final List<(String, double, double, double)> scales = <(String, double, double, double)>[
        ('displayText', c.displayText, m.displayText, e.displayText),
        ('headingText', c.headingText, m.headingText, e.headingText),
        ('titleText', c.titleText, m.titleText, e.titleText),
        ('promptText', c.promptText, m.promptText, e.promptText),
        ('bodyText', c.bodyText, m.bodyText, e.bodyText),
        ('captionText', c.captionText, m.captionText, e.captionText),
        ('microText', c.microText, m.microText, e.microText),
      ];
      for (final (String name, double a, double b, double d) in scales) {
        expect(a < b, isTrue, reason: '$name: compact($a) 應小於 medium($b)');
        expect(b < d, isTrue, reason: '$name: medium($b) 應小於 expanded($d)');
      }
    });

    test('版面留白與觸控目標也隨寬度遞增（或持平）', () {
      for (final (String name, double a, double b, double d) in <(String, double, double, double)>[
        ('pagePadding', c.pagePadding, m.pagePadding, e.pagePadding),
        ('sectionGap', c.sectionGap, m.sectionGap, e.sectionGap),
        ('cardPadding', c.cardPadding, m.cardPadding, e.cardPadding),
        ('optionGap', c.optionGap, m.optionGap, e.optionGap),
        ('minTapTarget', c.minTapTarget, m.minTapTarget, e.minTapTarget),
      ]) {
        expect(a <= b, isTrue, reason: '$name: compact($a) 不應大於 medium($b)');
        expect(b <= d, isTrue, reason: '$name: medium($b) 不應大於 expanded($d)');
      }
    });

    test('compact 不設內容寬度上限，大螢幕才有', () {
      // 手機上加側邊留白只會讓本來就窄的畫面更窄
      expect(c.contentMaxWidth, double.infinity);
      expect(m.contentMaxWidth, lessThan(double.infinity));
      expect(e.contentMaxWidth, greaterThan(m.contentMaxWidth));
    });

    test('compact 的字級與現況完全相同，iPhone 一個像素都不變', () {
      expect(c.displayText, 32);
      expect(c.headingText, 22);
      expect(c.titleText, 18);
      expect(c.bodyText, 15);
      expect(c.captionText, 13);
      expect(c.microText, 11);
      expect(c.promptText, 18);
    });

    test('題幹永遠不小於內文', () {
      for (final LayoutSpec l in <LayoutSpec>[c, m, e]) {
        expect(l.promptText, greaterThanOrEqualTo(l.bodyText));
      }
    });

    test('觸控目標不低於 Apple HIG 的 44pt', () {
      for (final LayoutSpec l in <LayoutSpec>[c, m, e]) {
        expect(l.minTapTarget, greaterThanOrEqualTo(44));
      }
    });
  });

  group('textThemeFrom', () {
    test('把該級的字級套進既有的 TextTheme，但保留顏色與字重', () {
      const TextTheme base = TextTheme(
        displaySmall: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
        headlineSmall: TextStyle(fontSize: 22, color: Color(0xFF0F172A)),
        titleLarge: TextStyle(fontSize: 18, color: Color(0xFF0F172A)),
        bodyLarge: TextStyle(fontSize: 15, height: 1.5, color: Color(0xFF334155)),
        bodyMedium: TextStyle(fontSize: 13, height: 1.4, color: Color(0xFF475569)),
        bodySmall: TextStyle(fontSize: 11, height: 1.35, color: Color(0xFF64748B)),
      );
      final LayoutSpec e = LayoutSpec.forWidth(1180);
      final TextTheme scaled = e.textThemeFrom(base);

      expect(scaled.displaySmall?.fontSize, e.displayText);
      expect(scaled.bodyLarge?.fontSize, e.bodyText);
      // 只換字級，其餘視覺屬性不可被吃掉
      expect(scaled.displaySmall?.fontWeight, FontWeight.w700);
      expect(scaled.bodyLarge?.height, 1.5);
      expect(scaled.bodyMedium?.color, const Color(0xFF475569));
    });

    test('compact 套用後與原本的 TextTheme 完全相同', () {
      const TextTheme base = TextTheme(
        displaySmall: TextStyle(fontSize: 32),
        bodyLarge: TextStyle(fontSize: 15),
      );
      final TextTheme same = LayoutSpec.forWidth(390).textThemeFrom(base);
      expect(same.displaySmall?.fontSize, 32);
      expect(same.bodyLarge?.fontSize, 15);
    });
  });

  group('of(context)', () {
    testWidgets('依 MediaQuery 的寬度取級別', (WidgetTester tester) async {
      late LayoutSpec seen;
      await tester.pumpWidget(MediaQuery(
        data: const MediaQueryData(size: Size(820, 1180)),
        child: Builder(builder: (BuildContext context) {
          seen = LayoutSpec.of(context);
          return const SizedBox();
        }),
      ));
      expect(seen.widthClass, WidthClass.medium);
    });
  });
}
