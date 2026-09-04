import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mathspring/ui/content_column.dart';
import 'package:mathspring/ui/content_scroll_view.dart';
import 'package:mathspring/ui/layout_spec.dart';

/// 內容欄：把「置中 + 最大寬度 + 頁面留白」收斂成一個 widget，
/// 10 個頁面共用，避免每頁各寫一次而漂移。
void main() {
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

  testWidgets('內容遠短於視窗時垂直置中', (WidgetTester tester) async {
    await pump(tester, const Size(820, 1180), 200);
    final Rect r = tester.getRect(find.byKey(const ValueKey<String>('probe')));
    // 上下留白應該接近相等
    final double above = r.top;
    final double below = 1180 - r.bottom;
    expect(above, closeTo(below, 2.0),
        reason: '上方留白 $above 與下方留白 $below 應該接近');
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
