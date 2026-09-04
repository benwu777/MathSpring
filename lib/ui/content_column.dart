import 'package:flutter/material.dart';

import 'layout_spec.dart';

/// 頁面內容欄：置中 + 最大寬度 + 頁面留白。
///
/// 大螢幕上單欄版面最重要的一件事就是**限制行寬**。不限制的話，
/// iPad 橫式上一行文字會跨越 1100pt，眼睛從行尾回到下一行行首很容易跑錯行。
/// compact 不設上限——手機本來就窄，再加側邊留白只會更窄。
///
/// 收斂成一個 widget 而不是每頁各寫一次，是為了讓 10 個頁面的留白與行寬
/// 不會隨時間漂移；要調整只改 [LayoutSpec]。
class ContentColumn extends StatelessWidget {
  const ContentColumn({
    super.key,
    required this.child,
    this.applyPadding = true,
  });

  final Widget child;

  /// 頁面自己已經處理過 padding 時設 false（例如需要讓背景色延伸到邊緣的清單）。
  final bool applyPadding;

  @override
  Widget build(BuildContext context) {
    final LayoutSpec layout = LayoutSpec.of(context);
    // padding 在約束外面：contentMaxWidth 指的是「一行文字最多多寬」，
    // 不是含留白的外框寬度。放進去的話 medium 只會得到 680 − 64 = 616。
    final Widget constrained = ConstrainedBox(
      constraints: BoxConstraints(maxWidth: layout.contentMaxWidth),
      child: child,
    );
    return Center(
      child: applyPadding
          ? Padding(
              padding: EdgeInsets.symmetric(horizontal: layout.pagePadding),
              child: constrained,
            )
          : constrained,
    );
  }
}
