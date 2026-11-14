import 'package:flutter/material.dart';

/// Rules that keep figure text readable on a phone: labels sit where the
/// author put them, shrink to fit their cell, skip crowded axis ticks, and are
/// drawn over a white halo so lines running through them stay legible.
abstract final class FigureLabelLayout {
  /// Where a hidden point's label goes relative to the point. Authors place
  /// hidden points exactly where the text should appear (a box centre, beside
  /// an axis), so without an explicit `pos` the text is centred on the point.
  static Offset hiddenLabelDirection(String? pos) => switch (pos) {
        't' => const Offset(0, -1),
        'b' => const Offset(0, 1),
        'l' => const Offset(-1, 0),
        'r' => const Offset(1, 0),
        'tl' => const Offset(-0.7, -0.7),
        'tr' => const Offset(0.7, -0.7),
        'bl' => const Offset(-0.7, 0.7),
        'br' => const Offset(0.7, 0.7),
        _ => Offset.zero,
      };

  /// Scale factor (≤ 1) that makes [textWidth] fit within [maxWidth].
  static double fitScale({required double textWidth, required double maxWidth}) {
    if (textWidth <= maxWidth || textWidth <= 0) return 1.0;
    return maxWidth / textWidth;
  }

  /// Label every n-th tick so neighbouring labels keep at least a small gap.
  static int tickStride({required double unitPx, required double labelWidthPx}) {
    const double gap = 4;
    if (unitPx <= 0) return 1;
    return ((labelWidthPx + gap) / unitPx).ceil().clamp(1, 1000);
  }

  /// Stroke painted under each label before the text itself.
  static Paint haloPaint() => Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3.5
    ..strokeJoin = StrokeJoin.round
    ..color = Colors.white;

  /// Paints [span] at [topLeft] twice: a white outline first, then the text.
  static void paintWithHalo(Canvas canvas, TextSpan span, Offset topLeft) {
    final TextStyle style = span.style ?? const TextStyle();
    final TextPainter halo = TextPainter(
      text: TextSpan(
          text: span.text,
          // TextStyle 不能同時有 color 與 foreground，所以重建一份只留字形相關的設定。
          style: TextStyle(
            fontSize: style.fontSize,
            fontFamily: style.fontFamily,
            fontWeight: style.fontWeight,
            fontFeatures: style.fontFeatures,
            foreground: haloPaint(),
          )),
      textDirection: TextDirection.ltr,
    )..layout();
    final TextPainter fill = TextPainter(
      text: span,
      textDirection: TextDirection.ltr,
    )..layout();
    halo.paint(canvas, topLeft);
    fill.paint(canvas, topLeft);
  }
}
