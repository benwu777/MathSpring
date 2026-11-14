import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mathspring/ui/figure_label_layout.dart';

/// 附圖文字在 iPhone 上被線壓住、擠在一起的修正規則（2026-11-14 模擬器實測 240 題有 61 題）。
void main() {
  group('hidden label anchor', () {
    test('a hidden label without an explicit position sits on its point', () {
      // 出題時把隱藏點放在「字要出現的位置」（方框中心、軸旁），不該再往右偏。
      expect(FigureLabelLayout.hiddenLabelDirection(null), Offset.zero);
    });

    test('an explicit position still pushes the label off the point', () {
      expect(FigureLabelLayout.hiddenLabelDirection('t'), const Offset(0, -1));
      expect(FigureLabelLayout.hiddenLabelDirection('r'), const Offset(1, 0));
    });
  });

  group('fit inside a cell', () {
    test('text that fits keeps its size', () {
      expect(FigureLabelLayout.fitScale(textWidth: 20, maxWidth: 40), 1.0);
    });

    test('text wider than the cell shrinks to fit', () {
      expect(FigureLabelLayout.fitScale(textWidth: 60, maxWidth: 30), 0.5);
    });
  });

  group('axis tick label stride', () {
    test('roomy axes label every unit', () {
      expect(
          FigureLabelLayout.tickStride(unitPx: 40, labelWidthPx: 18), 1);
    });

    test('crowded axes skip labels so neighbours never touch', () {
      // 「9101112」：每格 14px、兩位數字約 16px 寬。
      expect(
          FigureLabelLayout.tickStride(unitPx: 14, labelWidthPx: 16), 2);
      expect(FigureLabelLayout.tickStride(unitPx: 8, labelWidthPx: 16), 3);
    });
  });

  group('visible point label distance', () {
    test('a wide label beside a point clears the point by its half width', () {
      // 「10」放在點右邊：距離要大於點半徑＋半個字寬，不能讀成「100」。
      final double d = FigureLabelLayout.visibleLabelDistance(
          direction: const Offset(1, 0), textSize: const Size(20, 16));
      expect(d, greaterThanOrEqualTo(4.5 + 10 + 3));
    });

    test('a label above a point clears it by half its height', () {
      final double d = FigureLabelLayout.visibleLabelDistance(
          direction: const Offset(0, -1), textSize: const Size(40, 16));
      expect(d, greaterThanOrEqualTo(4.5 + 8 + 3));
      expect(d, lessThan(4.5 + 20));
    });
  });

  test('labels get a white halo so lines running through stay readable', () {
    final Paint halo = FigureLabelLayout.haloPaint();
    expect(halo.style, PaintingStyle.stroke);
    expect(halo.color, Colors.white);
    expect(halo.strokeWidth, greaterThanOrEqualTo(3));
  });
}
