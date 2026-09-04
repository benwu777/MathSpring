import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mathspring/ui/content_column.dart';
import 'package:mathspring/ui/layout_spec.dart';

/// 內容欄：把「置中 + 最大寬度 + 頁面留白」收斂成一個 widget，
/// 10 個頁面共用，避免每頁各寫一次而漂移。
void main() {
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
