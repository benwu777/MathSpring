part of '../main.dart';

class DiagramPoint {
  const DiagramPoint({
    required this.x,
    required this.y,
    this.label,
  });

  final int x;
  final int y;
  final String? label;
}

class TrigGraphPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const double leftPad = 56;
    const double rightPad = 28;
    const double topPad = 28;
    const double bottomPad = 40;
    final Rect plot = Rect.fromLTWH(
      leftPad,
      topPad,
      size.width - leftPad - rightPad,
      size.height - topPad - bottomPad,
    );

    final Paint gridPaint = Paint()
      ..color = const Color(0xFFE2E8F0)
      ..strokeWidth = 1;
    final Paint axisPaint = Paint()
      ..color = const Color(0xFF334155)
      ..strokeWidth = 1.6;
    final Paint sinPaint = Paint()
      ..color = const Color(0xFF2563EB)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    final Paint cosPaint = Paint()
      ..color = const Color(0xFFDC2626)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    final Paint bandPaint = Paint()
      ..color = const Color(0xFF0F766E).withValues(alpha: 0.10)
      ..style = PaintingStyle.fill;
    final Paint markerPaint = Paint()
      ..color = const Color(0xFF0F172A)
      ..style = PaintingStyle.fill;

    const double xMin = 0;
    const double xMax = math.pi * 2;
    const double yMin = -1.25;
    const double yMax = 1.25;

    double mapX(double x) =>
        plot.left + (x - xMin) / (xMax - xMin) * plot.width;
    double mapY(double y) =>
        plot.bottom - (y - yMin) / (yMax - yMin) * plot.height;

    final Rect focusBand = Rect.fromLTRB(
      mapX(math.pi / 2),
      plot.top,
      mapX(math.pi),
      plot.bottom,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(focusBand, const Radius.circular(12)),
      bandPaint,
    );

    for (int i = 0; i <= 8; i++) {
      final double y = plot.top + plot.height / 8 * i;
      canvas.drawLine(Offset(plot.left, y), Offset(plot.right, y), gridPaint);
    }

    for (int i = 0; i <= 8; i++) {
      final double x = plot.left + plot.width / 8 * i;
      canvas.drawLine(Offset(x, plot.top), Offset(x, plot.bottom), gridPaint);
    }

    canvas.drawLine(
      Offset(plot.left, mapY(0)),
      Offset(plot.right, mapY(0)),
      axisPaint,
    );
    canvas.drawLine(
      Offset(plot.left, plot.bottom),
      Offset(plot.left, plot.top),
      axisPaint,
    );

    final Path sinPath = Path();
    final Path cosPath = Path();
    const int samples = 480;
    for (int i = 0; i <= samples; i++) {
      final double t = xMin + (xMax - xMin) * i / samples;
      final Offset sinPoint = Offset(mapX(t), mapY(math.sin(t)));
      final Offset cosPoint = Offset(mapX(t), mapY(math.cos(t)));
      if (i == 0) {
        sinPath.moveTo(sinPoint.dx, sinPoint.dy);
        cosPath.moveTo(cosPoint.dx, cosPoint.dy);
      } else {
        sinPath.lineTo(sinPoint.dx, sinPoint.dy);
        cosPath.lineTo(cosPoint.dx, cosPoint.dy);
      }
    }

    canvas.drawPath(sinPath, sinPaint);
    canvas.drawPath(cosPath, cosPaint);

    final List<double> keyXs = [
      0,
      math.pi / 2,
      math.pi,
      math.pi * 3 / 2,
      math.pi * 2,
    ];
    final List<String> xLabels = ['0', 'π/2', 'π', '3π/2', '2π'];
    const TextStyle textStyle = TextStyle(
      color: Color(0xFF475569),
      fontSize: 12,
      fontWeight: FontWeight.w500,
    );

    for (int i = 0; i < keyXs.length; i++) {
      final double x = mapX(keyXs[i]);
      canvas.drawLine(
        Offset(x, mapY(0) - 6),
        Offset(x, mapY(0) + 6),
        axisPaint,
      );
      _paintText(
        canvas,
        xLabels[i],
        Offset(x - 12, plot.bottom + 10),
        textStyle,
      );
    }

    const List<double> yTicks = [-1, 0, 1];
    for (final double yValue in yTicks) {
      final double y = mapY(yValue);
      canvas.drawLine(
        Offset(plot.left - 6, y),
        Offset(plot.left + 6, y),
        axisPaint,
      );
      _paintText(
        canvas,
        yValue.toStringAsFixed(yValue == 0 ? 0 : 0),
        Offset(14, y - 9),
        textStyle,
      );
    }

    final List<Offset> highlights = [
      Offset(mapX(math.pi / 2), mapY(1)),
      Offset(mapX(0), mapY(1)),
      Offset(mapX(math.pi), mapY(-1)),
      Offset(mapX(math.pi * 3 / 2), mapY(-1)),
    ];
    for (final point in highlights) {
      canvas.drawCircle(point, 4.5, markerPaint);
    }

    _paintText(
      canvas,
      'x',
      Offset(plot.right + 6, mapY(0) - 8),
      const TextStyle(
        color: Color(0xFF334155),
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
    );
    _paintText(
      canvas,
      'y',
      Offset(plot.left - 6, plot.top - 18),
      const TextStyle(
        color: Color(0xFF334155),
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  void _paintText(
    Canvas canvas,
    String text,
    Offset offset,
    TextStyle style,
  ) {
    final TextPainter painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ShapeDiagramPainter extends CustomPainter {
  const ShapeDiagramPainter({
    required this.shape,
    required this.labels,
    this.labelFontFamily,
  });

  final String shape;
  final Map<String, String> labels;

  /// 預覽工具會塞自己載進來的字型；app 裡是 null，用預設字型。
  final String? labelFontFamily;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint outlinePaint = Paint()
      ..color = const Color(0xFF111827)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    final Paint fillPaint = Paint()
      ..color = const Color(0xFFE0E7FF)
      ..style = PaintingStyle.fill;

    final Rect rect = Rect.fromLTWH(
      size.width * 0.18,
      size.height * 0.18,
      size.width * 0.64,
      size.height * 0.48,
    );

    switch (shape) {
      case 'compass':
        final Offset center = Offset(size.width / 2, size.height / 2);
        final Paint linePaint = Paint()
          ..color = const Color(0xFF111827)
          ..strokeWidth = 3
          ..style = PaintingStyle.stroke;
        final double arm = math.min(size.width, size.height) * 0.24;
        canvas.drawLine(
          Offset(center.dx, center.dy - arm),
          Offset(center.dx, center.dy + arm),
          linePaint,
        );
        canvas.drawLine(
          Offset(center.dx - arm, center.dy),
          Offset(center.dx + arm, center.dy),
          linePaint,
        );
        _paintText(canvas, labels['top'] ?? 'N',
            Offset(center.dx, center.dy - arm - 22),
            fontFamily: labelFontFamily);
        _paintText(canvas, labels['right'] ?? 'E',
            Offset(center.dx + arm + 22, center.dy),
            fontFamily: labelFontFamily);
        _paintText(canvas, labels['bottom'] ?? 'S',
            Offset(center.dx, center.dy + arm + 22),
            fontFamily: labelFontFamily);
        _paintText(canvas, labels['left'] ?? 'W',
            Offset(center.dx - arm - 22, center.dy),
            fontFamily: labelFontFamily);
        _paintText(canvas, labels['center'], center,
            fontFamily: labelFontFamily);
        break;
      case 'square':
        final double side = math.min(rect.width, rect.height);
        final Rect square = Rect.fromCenter(
          center: rect.center,
          width: side,
          height: side,
        );
        canvas.drawRect(square, fillPaint);
        canvas.drawRect(square, outlinePaint);
        _paintShapeLabels(canvas, square);
        break;
      case 'triangle':
        final Path triangle = Path()
          ..moveTo(size.width * 0.5, size.height * 0.16)
          ..lineTo(size.width * 0.22, size.height * 0.7)
          ..lineTo(size.width * 0.78, size.height * 0.7)
          ..close();
        canvas.drawPath(triangle, fillPaint);
        canvas.drawPath(triangle, outlinePaint);
        _paintText(
            canvas, labels['top'], Offset(size.width * 0.5, size.height * 0.1),
            fontFamily: labelFontFamily);
        _paintText(canvas, labels['left'],
            Offset(size.width * 0.18, size.height * 0.48),
            fontFamily: labelFontFamily);
        _paintText(canvas, labels['right'],
            Offset(size.width * 0.82, size.height * 0.48),
            fontFamily: labelFontFamily);
        _paintText(canvas, labels['bottom'],
            Offset(size.width * 0.5, size.height * 0.76),
            fontFamily: labelFontFamily);
        break;
      case 'trapezoid':
        final Path trapezoid = Path()
          ..moveTo(size.width * 0.34, size.height * 0.22)
          ..lineTo(size.width * 0.66, size.height * 0.22)
          ..lineTo(size.width * 0.8, size.height * 0.7)
          ..lineTo(size.width * 0.2, size.height * 0.7)
          ..close();
        canvas.drawPath(trapezoid, fillPaint);
        canvas.drawPath(trapezoid, outlinePaint);
        _paintText(
            canvas, labels['top'], Offset(size.width * 0.5, size.height * 0.14),
            fontFamily: labelFontFamily);
        _paintText(canvas, labels['bottom'],
            Offset(size.width * 0.5, size.height * 0.78),
            fontFamily: labelFontFamily);
        _paintText(canvas, labels['left'],
            Offset(size.width * 0.16, size.height * 0.46),
            fontFamily: labelFontFamily);
        _paintText(canvas, labels['right'],
            Offset(size.width * 0.84, size.height * 0.46),
            fontFamily: labelFontFamily);
        _paintText(canvas, labels['center'],
            Offset(size.width * 0.5, size.height * 0.48),
            fontFamily: labelFontFamily);
        break;
      case 'parallelogram':
        final Path parallelogram = Path()
          ..moveTo(size.width * 0.3, size.height * 0.22)
          ..lineTo(size.width * 0.76, size.height * 0.22)
          ..lineTo(size.width * 0.64, size.height * 0.7)
          ..lineTo(size.width * 0.18, size.height * 0.7)
          ..close();
        canvas.drawPath(parallelogram, fillPaint);
        canvas.drawPath(parallelogram, outlinePaint);
        _paintText(canvas, labels['top'],
            Offset(size.width * 0.53, size.height * 0.14),
            fontFamily: labelFontFamily);
        _paintText(canvas, labels['bottom'],
            Offset(size.width * 0.41, size.height * 0.78),
            fontFamily: labelFontFamily);
        _paintText(canvas, labels['left'],
            Offset(size.width * 0.14, size.height * 0.48),
            fontFamily: labelFontFamily);
        _paintText(canvas, labels['right'],
            Offset(size.width * 0.8, size.height * 0.48),
            fontFamily: labelFontFamily);
        _paintText(canvas, labels['center'],
            Offset(size.width * 0.47, size.height * 0.46),
            fontFamily: labelFontFamily);
        break;
      case 'pentagon':
        final Path pentagon = Path()
          ..moveTo(size.width * 0.5, size.height * 0.14)
          ..lineTo(size.width * 0.78, size.height * 0.34)
          ..lineTo(size.width * 0.68, size.height * 0.7)
          ..lineTo(size.width * 0.32, size.height * 0.7)
          ..lineTo(size.width * 0.22, size.height * 0.34)
          ..close();
        canvas.drawPath(pentagon, fillPaint);
        canvas.drawPath(pentagon, outlinePaint);
        _paintText(
            canvas, labels['top'], Offset(size.width * 0.5, size.height * 0.08),
            fontFamily: labelFontFamily);
        _paintText(canvas, labels['left'],
            Offset(size.width * 0.16, size.height * 0.44),
            fontFamily: labelFontFamily);
        _paintText(canvas, labels['right'],
            Offset(size.width * 0.84, size.height * 0.44),
            fontFamily: labelFontFamily);
        _paintText(canvas, labels['bottom'],
            Offset(size.width * 0.5, size.height * 0.78),
            fontFamily: labelFontFamily);
        _paintText(canvas, labels['center'],
            Offset(size.width * 0.5, size.height * 0.46),
            fontFamily: labelFontFamily);
        break;
      case 'hexagon':
        final Path hexagon = Path()
          ..moveTo(size.width * 0.34, size.height * 0.18)
          ..lineTo(size.width * 0.66, size.height * 0.18)
          ..lineTo(size.width * 0.82, size.height * 0.44)
          ..lineTo(size.width * 0.66, size.height * 0.7)
          ..lineTo(size.width * 0.34, size.height * 0.7)
          ..lineTo(size.width * 0.18, size.height * 0.44)
          ..close();
        canvas.drawPath(hexagon, fillPaint);
        canvas.drawPath(hexagon, outlinePaint);
        _paintText(
            canvas, labels['top'], Offset(size.width * 0.5, size.height * 0.1),
            fontFamily: labelFontFamily);
        _paintText(canvas, labels['left'],
            Offset(size.width * 0.14, size.height * 0.44),
            fontFamily: labelFontFamily);
        _paintText(canvas, labels['right'],
            Offset(size.width * 0.86, size.height * 0.44),
            fontFamily: labelFontFamily);
        _paintText(canvas, labels['bottom'],
            Offset(size.width * 0.5, size.height * 0.78),
            fontFamily: labelFontFamily);
        _paintText(canvas, labels['center'],
            Offset(size.width * 0.5, size.height * 0.44),
            fontFamily: labelFontFamily);
        break;
      case 'circle':
        final Offset center = Offset(size.width / 2, size.height / 2);
        final double radius = math.min(size.width, size.height) * 0.24;
        canvas.drawCircle(center, radius, fillPaint);
        canvas.drawCircle(center, radius, outlinePaint);
        _paintText(canvas, labels['center'], center,
            fontFamily: labelFontFamily);
        _paintText(
            canvas, labels['top'], Offset(center.dx, center.dy - radius - 18),
            fontFamily: labelFontFamily);
        _paintText(
            canvas, labels['right'], Offset(center.dx + radius + 18, center.dy),
            fontFamily: labelFontFamily);
        break;
      case 'oval':
        final Rect oval = Rect.fromCenter(
          center: rect.center,
          width: rect.width * 0.92,
          height: rect.height * 0.86,
        );
        canvas.drawOval(oval, fillPaint);
        canvas.drawOval(oval, outlinePaint);
        _paintShapeLabels(canvas, oval);
        break;
      case 'rectangle':
      default:
        canvas.drawRect(rect, fillPaint);
        canvas.drawRect(rect, outlinePaint);
        _paintShapeLabels(canvas, rect);
        break;
    }
  }

  void _paintShapeLabels(Canvas canvas, Rect rect) {
    _paintText(canvas, labels['top'], Offset(rect.center.dx, rect.top - 18),
        fontFamily: labelFontFamily);
    _paintText(
        canvas, labels['bottom'], Offset(rect.center.dx, rect.bottom + 18),
        fontFamily: labelFontFamily);
    _paintText(canvas, labels['left'], Offset(rect.left - 18, rect.center.dy),
        fontFamily: labelFontFamily);
    _paintText(canvas, labels['right'], Offset(rect.right + 18, rect.center.dy),
        fontFamily: labelFontFamily);
    _paintText(canvas, labels['center'], rect.center,
        fontFamily: labelFontFamily);
  }

  @override
  bool shouldRepaint(covariant ShapeDiagramPainter oldDelegate) {
    return oldDelegate.shape != shape ||
        oldDelegate.labels.toString() != labels.toString();
  }
}

class CircleQuadrantsPointPainter extends CustomPainter {
  const CircleQuadrantsPointPainter({
    required this.regionLabels,
    required this.pointLabel,
    required this.shadedRegion,
    this.labelFontFamily,
  });

  final Map<String, String> regionLabels;
  final String pointLabel;
  final String shadedRegion;

  /// 預覽工具會塞自己載進來的字型；app 裡是 null，用預設字型。
  final String? labelFontFamily;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint outlinePaint = Paint()
      ..color = const Color(0xFF111827)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    final Paint connectorPaint = Paint()
      ..color = const Color(0xFF334155)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    final Paint fillPaint = Paint()
      ..color = const Color(0xFFE0E7FF)
      ..style = PaintingStyle.fill;
    final Paint pointPaint = Paint()
      ..color = const Color(0xFFDC2626)
      ..style = PaintingStyle.fill;

    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = math.min(size.width, size.height) * 0.34;
    final Offset top = Offset(center.dx, center.dy - radius);
    final Offset right = Offset(center.dx + radius, center.dy);
    final Offset bottom = Offset(center.dx, center.dy + radius);
    final Offset left = Offset(center.dx - radius, center.dy);
    final Offset pointP =
        Offset(center.dx - radius * 0.18, center.dy + radius * 0.1);

    // 四個區域都是「從某個等分點沿圓弧走 90 度到下一個等分點，再拉回 P」。
    // 以前只寫死了 topRight 一支，填其他三個值靜默不上色。
    // 畫布角度 0 是正右方、順時針increasing（y 向下）。
    final Map<String, (Offset, double)> quadrants = <String, (Offset, double)>{
      'topRight': (top, -math.pi / 2),
      'bottomRight': (right, 0),
      'bottomLeft': (bottom, math.pi / 2),
      'topLeft': (left, math.pi),
    };
    final (Offset, double)? quadrant = quadrants[shadedRegion];
    if (quadrant != null) {
      final (Offset start, double startAngle) = quadrant;
      final Path shadedPath = Path()
        ..moveTo(start.dx, start.dy)
        ..arcTo(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          math.pi / 2,
          false,
        )
        ..lineTo(pointP.dx, pointP.dy)
        ..close();
      canvas.drawPath(shadedPath, fillPaint);
    }

    canvas.drawCircle(center, radius, outlinePaint);
    canvas.drawLine(top, pointP, connectorPaint);
    canvas.drawLine(right, pointP, connectorPaint);
    canvas.drawLine(bottom, pointP, connectorPaint);
    canvas.drawLine(left, pointP, connectorPaint);

    canvas.drawCircle(pointP, 4.5, pointPaint);

    _paintText(canvas, 'A', Offset(top.dx - 6, top.dy - 24),
        fontFamily: labelFontFamily);
    _paintText(canvas, 'B', Offset(right.dx + 18, right.dy - 8),
        fontFamily: labelFontFamily);
    _paintText(canvas, 'C', Offset(bottom.dx - 6, bottom.dy + 12),
        fontFamily: labelFontFamily);
    _paintText(canvas, 'D', Offset(left.dx - 24, left.dy - 8),
        fontFamily: labelFontFamily);
    _paintText(canvas, pointLabel, pointP + const Offset(-6, -22),
        fontFamily: labelFontFamily);

    _paintText(
      canvas,
      regionLabels['topLeft'],
      Offset(center.dx - radius * 0.34, center.dy - radius * 0.28),
      fontFamily: labelFontFamily,
    );
    _paintText(
      canvas,
      regionLabels['topRight'],
      Offset(center.dx + radius * 0.28, center.dy - radius * 0.26),
      fontFamily: labelFontFamily,
    );
    _paintText(
      canvas,
      regionLabels['bottomLeft'],
      Offset(center.dx - radius * 0.38, center.dy + radius * 0.3),
      fontFamily: labelFontFamily,
    );
    _paintText(
      canvas,
      regionLabels['bottomRight'],
      Offset(center.dx + radius * 0.26, center.dy + radius * 0.3),
      fontFamily: labelFontFamily,
    );
  }

  @override
  bool shouldRepaint(covariant CircleQuadrantsPointPainter oldDelegate) {
    return oldDelegate.regionLabels.toString() != regionLabels.toString() ||
        oldDelegate.pointLabel != pointLabel ||
        oldDelegate.shadedRegion != shadedRegion;
  }
}

class CoordinatePlanePainter extends CustomPainter {
  const CoordinatePlanePainter({
    required this.minX,
    required this.maxX,
    required this.minY,
    required this.maxY,
    required this.showGrid,
    required this.points,
    required this.pathPoints,
    required this.highlightPoint,
    this.labelFontFamily,
  });

  final int minX;
  final int maxX;
  final int minY;
  final int maxY;
  final bool showGrid;
  final List<DiagramPoint> points;
  final List<DiagramPoint> pathPoints;
  final DiagramPoint? highlightPoint;

  /// 預覽工具會塞自己載進來的字型；app 裡是 null，用預設字型。
  final String? labelFontFamily;

  @override
  void paint(Canvas canvas, Size size) {
    const double leftPad = 42;
    const double rightPad = 22;
    const double topPad = 20;
    const double bottomPad = 34;
    final Rect plot = Rect.fromLTWH(
      leftPad,
      topPad,
      size.width - leftPad - rightPad,
      size.height - topPad - bottomPad,
    );
    final Paint gridPaint = Paint()
      ..color = const Color(0xFFE5E7EB)
      ..strokeWidth = 1;
    final Paint axisPaint = Paint()
      ..color = const Color(0xFF334155)
      ..strokeWidth = 1.6;
    final Paint pointPaint = Paint()
      ..color = const Color(0xFF1D4ED8)
      ..style = PaintingStyle.fill;
    final Paint highlightPaint = Paint()
      ..color = const Color(0xFFDC2626)
      ..style = PaintingStyle.fill;
    final Paint pathPaint = Paint()
      ..color = const Color(0xFF0F766E)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final int xSpan = math.max(maxX - minX, 1);
    final int ySpan = math.max(maxY - minY, 1);
    double mapX(int x) => plot.left + (x - minX) / xSpan * plot.width;
    double mapY(int y) => plot.bottom - (y - minY) / ySpan * plot.height;

    if (showGrid) {
      for (int x = minX; x <= maxX; x++) {
        final double dx = mapX(x);
        canvas.drawLine(
            Offset(dx, plot.top), Offset(dx, plot.bottom), gridPaint);
        _paintText(canvas, '$x', Offset(dx, plot.bottom + 14),
            fontFamily: labelFontFamily);
      }
      for (int y = minY; y <= maxY; y++) {
        final double dy = mapY(y);
        canvas.drawLine(
            Offset(plot.left, dy), Offset(plot.right, dy), gridPaint);
        if (y != 0) {
          _paintText(canvas, '$y', Offset(plot.left - 14, dy),
              fontFamily: labelFontFamily);
        }
      }
    }

    final double axisX = minX <= 0 && 0 <= maxX ? mapX(0) : plot.left;
    final double axisY = minY <= 0 && 0 <= maxY ? mapY(0) : plot.bottom;
    canvas.drawLine(
        Offset(plot.left, axisY), Offset(plot.right, axisY), axisPaint);
    canvas.drawLine(
        Offset(axisX, plot.bottom), Offset(axisX, plot.top), axisPaint);

    if (pathPoints.length >= 2) {
      final Path path = Path()
        ..moveTo(mapX(pathPoints.first.x), mapY(pathPoints.first.y));
      for (final DiagramPoint point in pathPoints.skip(1)) {
        path.lineTo(mapX(point.x), mapY(point.y));
      }
      canvas.drawPath(path, pathPaint);
    }

    for (final DiagramPoint point in points) {
      final Offset offset = Offset(mapX(point.x), mapY(point.y));
      final bool isHighlighted = highlightPoint != null &&
          point.x == highlightPoint!.x &&
          point.y == highlightPoint!.y;
      canvas.drawCircle(offset, 5, isHighlighted ? highlightPaint : pointPaint);
      if (point.label != null && point.label!.isNotEmpty) {
        _paintText(canvas, point.label, offset + const Offset(0, -16),
            fontFamily: labelFontFamily);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CoordinatePlanePainter oldDelegate) {
    return oldDelegate.minX != minX ||
        oldDelegate.maxX != maxX ||
        oldDelegate.minY != minY ||
        oldDelegate.maxY != maxY ||
        oldDelegate.showGrid != showGrid ||
        oldDelegate.points.length != points.length ||
        oldDelegate.pathPoints.length != pathPoints.length ||
        oldDelegate.highlightPoint?.x != highlightPoint?.x ||
        oldDelegate.highlightPoint?.y != highlightPoint?.y;
  }
}

class CompositeGridShapePainter extends CustomPainter {
  const CompositeGridShapePainter({
    required this.rows,
    required this.cols,
    required this.filledCells,
    required this.cellLabels,
    this.labelFontFamily,
  });

  final int rows;
  final int cols;
  final List<GridCell> filledCells;
  final Map<String, String> cellLabels;

  /// 預覽工具會塞自己載進來的字型；app 裡是 null，用預設字型。
  final String? labelFontFamily;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint fillPaint = Paint()
      ..color = const Color(0xFFE0E7FF)
      ..style = PaintingStyle.fill;
    final Paint emptyPaint = Paint()
      ..color = const Color(0xFFF8FAFC)
      ..style = PaintingStyle.fill;
    final Paint gridPaint = Paint()
      ..color = const Color(0xFFCBD5E1)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    final Paint outlinePaint = Paint()
      ..color = const Color(0xFF111827)
      ..strokeWidth = 2.6
      ..style = PaintingStyle.stroke;

    final Set<String> filledKeys =
        filledCells.map((cell) => '${cell.row},${cell.col}').toSet();

    final double cellSize = math.min(
      (size.width * 0.72) / cols,
      (size.height * 0.72) / rows,
    );
    final double gridWidth = cols * cellSize;
    final double gridHeight = rows * cellSize;
    final double startX = (size.width - gridWidth) / 2;
    final double startY = (size.height - gridHeight) / 2;

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        final Rect cellRect = Rect.fromLTWH(
          startX + col * cellSize,
          startY + row * cellSize,
          cellSize,
          cellSize,
        );
        final String key = '$row,$col';
        canvas.drawRect(
            cellRect, filledKeys.contains(key) ? fillPaint : emptyPaint);
        canvas.drawRect(cellRect, gridPaint);
        _paintText(canvas, cellLabels[key], cellRect.center,
            fontFamily: labelFontFamily);
      }
    }

    for (final GridCell cell in filledCells) {
      final Rect cellRect = Rect.fromLTWH(
        startX + cell.col * cellSize,
        startY + cell.row * cellSize,
        cellSize,
        cellSize,
      );

      if (!filledKeys.contains('${cell.row - 1},${cell.col}')) {
        canvas.drawLine(cellRect.topLeft, cellRect.topRight, outlinePaint);
      }
      if (!filledKeys.contains('${cell.row + 1},${cell.col}')) {
        canvas.drawLine(
            cellRect.bottomLeft, cellRect.bottomRight, outlinePaint);
      }
      if (!filledKeys.contains('${cell.row},${cell.col - 1}')) {
        canvas.drawLine(cellRect.topLeft, cellRect.bottomLeft, outlinePaint);
      }
      if (!filledKeys.contains('${cell.row},${cell.col + 1}')) {
        canvas.drawLine(cellRect.topRight, cellRect.bottomRight, outlinePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CompositeGridShapePainter oldDelegate) {
    return oldDelegate.rows != rows ||
        oldDelegate.cols != cols ||
        oldDelegate.filledCells.toString() != filledCells.toString() ||
        oldDelegate.cellLabels.toString() != cellLabels.toString();
  }
}

void _paintText(Canvas canvas, String? text, Offset center,
    {String? fontFamily}) {
  if (text == null || text.isEmpty) {
    return;
  }
  final TextPainter painter = TextPainter(
    text: TextSpan(
      text: text,
      style: TextStyle(
        color: const Color(0xFF0F172A),
        fontSize: 13,
        fontWeight: FontWeight.w600,
        // 預設 null，用 app 的字型；預覽工具會塞自己載進來的字型，
        // 否則測試環境沒有系統字型，文字全部畫成黑方塊。
        fontFamily: fontFamily,
      ),
    ),
    textDirection: TextDirection.ltr,
  )..layout();
  painter.paint(
    canvas,
    Offset(center.dx - painter.width / 2, center.dy - painter.height / 2),
  );
}

class GridCell {
  const GridCell({required this.row, required this.col});

  final int row;
  final int col;

  @override
  String toString() => 'GridCell(row: $row, col: $col)';
}

List<GridCell> _cellListFromDynamic(dynamic value) {
  if (value is! List) {
    return const <GridCell>[];
  }
  return value.whereType<List>().map((entry) {
    final int row =
        entry.isNotEmpty ? _intFromDynamic(entry[0], fallback: 0) : 0;
    final int col =
        entry.length > 1 ? _intFromDynamic(entry[1], fallback: 0) : 0;
    return GridCell(row: row, col: col);
  }).toList();
}

Map<String, String> _stringMapFromDynamic(dynamic raw) {
  if (raw is! Map) {
    return const {};
  }
  return Map<String, String>.from(
    raw.map((key, value) => MapEntry(key.toString(), value.toString())),
  );
}

int _intFromDynamic(dynamic raw, {required int fallback}) {
  if (raw is int) {
    return raw;
  }
  return int.tryParse(raw?.toString() ?? '') ?? fallback;
}

DiagramPoint? _pointFromDynamic(dynamic raw) {
  if (raw is! Map) {
    return null;
  }
  return DiagramPoint(
    x: _intFromDynamic(raw['x'], fallback: 0),
    y: _intFromDynamic(raw['y'], fallback: 0),
    label: raw['label']?.toString(),
  );
}

List<DiagramPoint> _pointListFromDynamic(dynamic raw) {
  if (raw is! List) {
    return const [];
  }
  return raw
      .whereType<Map>()
      .map(
        (item) => DiagramPoint(
          x: _intFromDynamic(item['x'], fallback: 0),
          y: _intFromDynamic(item['y'], fallback: 0),
          label: item['label']?.toString(),
        ),
      )
      .toList();
}
