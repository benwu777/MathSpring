import 'package:flutter/material.dart';

import 'content_column.dart';
import 'layout_spec.dart';

/// 可捲動的頁面內容：行寬上限 + 置中 + 大螢幕上的垂直處理。
///
/// 為什麼不把這些做進 [ContentColumn]：垂直方向的處理需要知道**視窗高度**，
/// 而 [ContentColumn] 放在捲動區裡面，那裡的高度約束是無限大，拿不到。
class ContentScrollView extends StatelessWidget {
  const ContentScrollView({
    super.key,
    required this.child,
    this.controller,
    this.fill = false,
  });

  final Widget child;
  final ScrollController? controller;

  /// 讓內容撐滿可用高度。
  ///
  /// **連續作答的畫面一定要開這個。**每一題的文字長度不同，若讓卡片只佔
  /// 自然高度（不管是靠上還是置中），卡片會在題目之間上下跳、忽大忽小。
  /// 撐滿之後位置與大小固定，換題時畫面是穩定的。
  ///
  /// 開啟時 [child] 必須是 `Column`，並且把要撐開的那一段包在 `Expanded` 裡。
  final bool fill;

  @override
  Widget build(BuildContext context) {
    final double vertical = LayoutSpec.of(context).sectionGap;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double available = constraints.maxHeight.isFinite
            ? (constraints.maxHeight - vertical * 2).clamp(0.0, double.infinity)
            : 0.0;
        // 高度約束必須直接包住 IntrinsicHeight，不能隔著 ContentColumn——
        // ContentColumn 內部有 Center，它會把高度約束放鬆掉，
        // Expanded 就拿不到可撐開的高度（實測卡片只會是自然高度）。
        //
        // IntrinsicHeight 是讓 Expanded 在捲動區裡運作的標準手段：捲動區高度
        // 無限，Expanded 需要有界高度。代價是多一次 layout pass，
        // 這幾頁結構很淺，可以接受。
        final Widget content = fill
            ? ConstrainedBox(
                constraints: BoxConstraints(minHeight: available),
                child: IntrinsicHeight(child: child),
              )
            : child;
        return SingleChildScrollView(
          controller: controller,
          padding: EdgeInsets.symmetric(vertical: vertical),
          child: ContentColumn(child: content),
        );
      },
    );
  }
}
