import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mathspring/ui/content_column.dart';
import 'package:mathspring/ui/content_scroll_view.dart';
import 'package:mathspring/ui/layout_spec.dart';

/// 內容欄：把「置中 + 最大寬度 + 頁面留白」收斂成一個 widget，
/// 10 個頁面共用，避免每頁各寫一次而漂移。
void main() {
  group('ContentScrollView 滿版模式', _fillTests);

  group('ContentScrollView', _scrollViewTests);

  Future<Size> childSizeAt(WidgetTester tester, Size view) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = view;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ContentColumn(
          child: Container(key: const ValueKey<String>('probe')),
        ),
      ),
    ));
    return tester.getSize(find.byKey(const ValueKey<String>('probe')));
  }

  testWidgets('compact 不限制寬度，內容用滿扣掉留白的空間', (WidgetTester tester) async {
    final LayoutSpec l = LayoutSpec.forWidth(390);
    final Size size = await childSizeAt(tester, const Size(390, 844));
    expect(size.width, 390 - l.pagePadding * 2);
  });

  testWidgets('medium 把內容限制在 contentMaxWidth', (WidgetTester tester) async {
    final LayoutSpec l = LayoutSpec.forWidth(820);
    final Size size = await childSizeAt(tester, const Size(820, 1180));
    // 820 - 32*2 = 756，超過上限 680，所以應被夾住
    expect(size.width, l.contentMaxWidth);
  });

  testWidgets('expanded 也夾在自己的上限，不會跟著螢幕一路變寬',
      (WidgetTester tester) async {
    final LayoutSpec l = LayoutSpec.forWidth(1180);
    final Size wide = await childSizeAt(tester, const Size(1180, 820));
    expect(wide.width, l.contentMaxWidth);

    // 螢幕再寬一倍，內容寬度不該跟著長——這正是「不是 iPhone 放大版」的重點
    final Size wider = await childSizeAt(tester, const Size(2400, 1400));
    expect(wider.width, l.contentMaxWidth);
  });

  testWidgets('內容置中，兩側留白相等', (WidgetTester tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(1180, 820);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ContentColumn(
          child: Container(key: const ValueKey<String>('probe')),
        ),
      ),
    ));
    final Rect r = tester.getRect(find.byKey(const ValueKey<String>('probe')));
    expect(r.left, closeTo(1180 - r.right, 0.5));
  });

  testWidgets('留白可以關掉，給本來就自己處理 padding 的頁面用',
      (WidgetTester tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ContentColumn(
          applyPadding: false,
          child: Container(key: const ValueKey<String>('probe')),
        ),
      ),
    ));
    expect(tester.getSize(find.byKey(const ValueKey<String>('probe'))).width,
        390);
  });
}

/// 內容短於視窗時垂直置中，超過時自動回到靠上對齊。
///
/// 這是標準的 `ConstrainedBox(minHeight: 視窗高) + Center` 慣用法：
/// 只有在有多餘空間時才置中，內容變長就回到一般捲動行為，不影響捲動手感。
void _scrollViewTests() {
  Future<void> pump(WidgetTester tester, Size view, double contentHeight) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = view;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ContentScrollView(
          child: Container(
            key: const ValueKey<String>('probe'),
            height: contentHeight,
            color: const Color(0xFF000000),
          ),
        ),
      ),
    ));
  }

  testWidgets('內容起點固定在上方，不隨內容長度移動', (WidgetTester tester) async {
    // 一度改成「內容短時垂直置中」，但那在連續作答時是錯的：每題文字長度不同，
    // 卡片會在題目之間上下跳。位置必須穩定，空白由滿版模式處理。
    await pump(tester, const Size(820, 1180), 200);
    final double shortTop =
        tester.getRect(find.byKey(const ValueKey<String>('probe'))).top;
    await pump(tester, const Size(820, 1180), 600);
    final double longTop =
        tester.getRect(find.byKey(const ValueKey<String>('probe'))).top;
    expect(shortTop, longTop,
        reason: '短內容起點 $shortTop 與長內容起點 $longTop 應該相同');
  });

  testWidgets('內容超過視窗高度時回到靠上對齊，不會被推到中間',
      (WidgetTester tester) async {
    await pump(tester, const Size(820, 1180), 3000);
    final Rect r = tester.getRect(find.byKey(const ValueKey<String>('probe')));
    expect(r.top, lessThan(100), reason: '內容比視窗長時應該靠上');
  });

  testWidgets('內容過長時仍然可以捲動', (WidgetTester tester) async {
    await pump(tester, const Size(820, 1180), 3000);
    final double before =
        tester.getRect(find.byKey(const ValueKey<String>('probe'))).top;
    await tester.drag(find.byType(ContentScrollView), const Offset(0, -400));
    await tester.pump();
    final double after =
        tester.getRect(find.byKey(const ValueKey<String>('probe'))).top;
    expect(after, lessThan(before));
  });

  testWidgets('仍然套用內容欄的行寬上限', (WidgetTester tester) async {
    await pump(tester, const Size(1180, 820), 200);
    final double w =
        tester.getSize(find.byKey(const ValueKey<String>('probe'))).width;
    expect(w, LayoutSpec.forWidth(1180).contentMaxWidth);
  });
}

/// 滿版模式：內容區撐滿可用高度，讓區塊的位置與大小不隨文字長度變動。
///
/// 起因：作答時每題文字長度不同，若用垂直置中，卡片會在題目之間上下跳、
/// 忽大忽小。連續作答的畫面必須穩定。
void _fillTests() {
  Future<void> pump(WidgetTester tester, Size view, double textHeight) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = view;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ContentScrollView(
          fill: true,
          child: Column(
            children: <Widget>[
              Container(
                  key: const ValueKey<String>('header'),
                  height: 60,
                  color: const Color(0xFFEEEEEE)),
              Expanded(
                child: Container(
                  key: const ValueKey<String>('card'),
                  color: const Color(0xFFCCCCCC),
                  child: SizedBox(height: textHeight),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  testWidgets('文字少時卡片仍然撐滿，不會縮成一小塊',
      (WidgetTester tester) async {
    await pump(tester, const Size(820, 1180), 100);
    final double h =
        tester.getSize(find.byKey(const ValueKey<String>('card'))).height;
    expect(h, greaterThan(800), reason: '卡片應撐滿剩餘高度，實際 $h');
  });

  testWidgets('文字多寡不影響卡片高度，畫面不會呼大呼小',
      (WidgetTester tester) async {
    await pump(tester, const Size(820, 1180), 100);
    final double short =
        tester.getSize(find.byKey(const ValueKey<String>('card'))).height;
    await pump(tester, const Size(820, 1180), 400);
    final double long =
        tester.getSize(find.byKey(const ValueKey<String>('card'))).height;
    expect(long, short, reason: '短文字 $short 與長文字 $long 應該一樣高');
  });

  testWidgets('compact 也一樣撐滿：iPhone 上換題同樣不會忽大忽小',
      (WidgetTester tester) async {
    // fill 模式刻意不分寬度級別。iPhone 螢幕短，多數題目本來就接近滿版，
    // 但短題目在長螢幕（例如 Pro Max）上仍會有落差，一樣需要穩定。
    await pump(tester, const Size(390, 844), 100);
    final double short =
        tester.getSize(find.byKey(const ValueKey<String>('card'))).height;
    await pump(tester, const Size(390, 844), 300);
    final double long =
        tester.getSize(find.byKey(const ValueKey<String>('card'))).height;
    expect(short, long);
    expect(short, greaterThan(600), reason: '應撐滿而非自然高度，實際 $short');
  });

  testWidgets('內容超過視窗時仍可捲動，不會被硬壓在一頁裡',
      (WidgetTester tester) async {
    await pump(tester, const Size(820, 600), 2000);
    expect(tester.takeException(), isNull);
    final double before =
        tester.getRect(find.byKey(const ValueKey<String>('header'))).top;
    await tester.drag(find.byType(ContentScrollView), const Offset(0, -300));
    await tester.pump();
    final double after =
        tester.getRect(find.byKey(const ValueKey<String>('header'))).top;
    expect(after, lessThan(before));
  });
}
