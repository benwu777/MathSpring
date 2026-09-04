import 'package:flutter/material.dart';

import 'content_column.dart';
import 'layout_spec.dart';

/// 可捲動的頁面內容：行寬上限 + 置中 + 內容短於視窗時垂直置中。
///
/// 為什麼不把置中做進 [ContentColumn]：垂直置中需要知道**視窗高度**，
/// 而 [ContentColumn] 放在捲動區裡面，那裡的高度約束是無限大，拿不到。
///
/// 用 `ConstrainedBox(minHeight: 視窗高) + Center` 這個標準慣用法：
/// **只有在有多餘空間時才置中**，內容一旦長過視窗就自動回到靠上對齊、正常捲動。
class ContentScrollView extends StatelessWidget {
  const ContentScrollView({
    super.key,
    required this.child,
    this.controller,
  });

  final Widget child;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    final double vertical = LayoutSpec.of(context).sectionGap;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double available = constraints.maxHeight.isFinite
            ? (constraints.maxHeight - vertical * 2).clamp(0.0, double.infinity)
            : 0.0;
        return SingleChildScrollView(
          controller: controller,
          padding: EdgeInsets.symmetric(vertical: vertical),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: available),
            child: Center(child: ContentColumn(child: child)),
          ),
        );
      },
    );
  }
}
