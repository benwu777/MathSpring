import 'dart:io';

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
      final List<(String, double, double, double)> scales =
          <(String, double, double, double)>[
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

    test('版面留白也隨寬度遞增（或持平）', () {
      for (final (String name, double a, double b, double d)
          in <(String, double, double, double)>[
        ('pagePadding', c.pagePadding, m.pagePadding, e.pagePadding),
        ('sectionGap', c.sectionGap, m.sectionGap, e.sectionGap),
        ('cardPadding', c.cardPadding, m.cardPadding, e.cardPadding),
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

    test('compact 保持答題資訊緊湊', () {
      expect(c.sectionGap, 12);
      expect(c.cardPadding, 16);
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
  });

  group('scaleText', () {
    test('compact 原樣回傳，iPhone 的零散字級一個像素都不變', () {
      final LayoutSpec c = LayoutSpec.forWidth(390);
      for (final double n in <double>[
        11,
        12,
        13,
        14,
        15,
        18,
        19,
        20,
        22,
        24,
        28,
        32,
        34
      ]) {
        expect(c.scaleText(n), n);
      }
    });

    test('medium 與 expanded 依序放大，且回傳整數點數', () {
      final LayoutSpec m = LayoutSpec.forWidth(820);
      final LayoutSpec e = LayoutSpec.forWidth(1180);
      for (final double n in <double>[11, 14, 20, 24, 34]) {
        expect(m.scaleText(n), greaterThan(n));
        expect(e.scaleText(n), greaterThan(m.scaleText(n)));
        expect(m.scaleText(n), m.scaleText(n).roundToDouble());
        expect(e.scaleText(n), e.scaleText(n).roundToDouble());
      }
    });

    test('放大幅度與語意代號一致，不會出現內文比標題大', () {
      final LayoutSpec e = LayoutSpec.forWidth(1180);
      // 零散字級 20（介於 title 18 與 heading 22 之間）放大後仍要落在兩者之間
      expect(e.scaleText(20), greaterThan(e.titleText));
      expect(e.scaleText(20), lessThan(e.headingText + 1));
    });
  });

  group('textThemeFrom', () {
    test('把該級的字級套進既有的 TextTheme，但保留顏色與字重', () {
      const TextTheme base = TextTheme(
        displaySmall: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0F172A)),
        headlineSmall: TextStyle(fontSize: 22, color: Color(0xFF0F172A)),
        titleLarge: TextStyle(fontSize: 18, color: Color(0xFF0F172A)),
        bodyLarge:
            TextStyle(fontSize: 15, height: 1.5, color: Color(0xFF334155)),
        bodyMedium:
            TextStyle(fontSize: 13, height: 1.4, color: Color(0xFF475569)),
        bodySmall:
            TextStyle(fontSize: 11, height: 1.35, color: Color(0xFF64748B)),
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

  group('代號不可以定義了卻沒用', () {
    // 2026-09-04 實際犯過：cardPadding / optionGap / minTapTarget 三個代號
    // 定義在 LayoutSpec 上但一處都沒套用，等於死碼——iPad 的卡片內距與觸控目標
    // 其實跟 iPhone 一樣。這條測試掃 lib/ 的原始碼防止再發生。
    late final String libSource = Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((File f) =>
            f.path.endsWith('.dart') && !f.path.endsWith('layout_spec.dart'))
        .map((File f) => f.readAsStringSync())
        .join('\n');

    const List<String> tokens = <String>[
      'displayText',
      'headingText',
      'titleText',
      'promptText',
      'bodyText',
      'captionText',
      'microText',
      'contentMaxWidth',
      'pagePadding',
      'sectionGap',
      'cardPadding',
    ];

    test('每個代號都至少被 lib/ 底下的程式用到一次', () {
      final List<String> unused = <String>[
        for (final String t in tokens)
          if (!libSource.contains('.$t')) t,
      ];
      expect(unused, isEmpty, reason: '這些代號定義了卻沒有套用：${unused.join("、")}');
    });

    test('偵測方式本身有效：不存在的代號會被判定為沒用到', () {
      // 沒有這一條的話，上面那條可能因為比對方式寫錯而永遠通過
      expect(libSource.contains('.thisTokenDoesNotExist'), isFalse);
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
