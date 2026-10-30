part of '../main.dart';

class _QuestionFigureView extends StatelessWidget {
  const _QuestionFigureView({required this.question});

  final Question question;

  @override
  Widget build(BuildContext context) {
    final FigureRenderSpec? spec = buildFigureRenderSpec(question.figure);
    if (spec == null) {
      return const SizedBox.shrink();
    }

    return AspectRatio(
      aspectRatio: spec.aspectRatio,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          key: ValueKey<String>('figure_${question.figure.kind}'),
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            showDialog<void>(
              context: context,
              barrierColor: const Color(0xE6111827),
              builder: (_) => _FigurePreviewDialog(
                question: question,
                spec: spec,
              ),
            );
          },
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            padding: const EdgeInsets.all(16),
            child: spec.child,
          ),
        ),
      ),
    );
  }
}

/// 一張圖要怎麼畫：畫布本身，加上它該用的長寬比。
class FigureRenderSpec {
  const FigureRenderSpec({
    required this.child,
    required this.aspectRatio,
  });

  final Widget child;
  final double aspectRatio;
}

/// 把 figure 的 kind 與 params 對應到實際的 painter。
///
/// 認不得的 kind 回傳 null，呼叫端就不畫圖——這是刻意的：題庫那一側已經有
/// 驗證器的 KINDS 白名單擋著，真的漏進來時寧可少一張圖，也不要讓整題開不起來。
/// 但過去它是完全靜默的，畫面一片空白而沒有任何線索，所以這裡留一行 log。
FigureRenderSpec? buildFigureRenderSpec(QuestionFigure figure,
    {String? labelFontFamily}) {
  final String kind = figure.kind;
  final Widget? figureChild = switch (kind) {
    'trig_plane' => CustomPaint(
        painter: TrigGraphPainter(),
        child: const SizedBox.expand(),
      ),
    'shape_diagram' => CustomPaint(
        painter: ShapeDiagramPainter(
          shape: figure.params['shape'] as String? ?? 'rectangle',
          labels: _stringMapFromDynamic(figure.params['labels']),
          labelFontFamily: labelFontFamily,
        ),
        child: const SizedBox.expand(),
      ),
    'coordinate_plane' => CustomPaint(
        painter: CoordinatePlanePainter(
          minX: _intFromDynamic(figure.params['minX'], fallback: 0),
          maxX: _intFromDynamic(figure.params['maxX'], fallback: 6),
          minY: _intFromDynamic(figure.params['minY'], fallback: 0),
          maxY: _intFromDynamic(figure.params['maxY'], fallback: 6),
          showGrid: figure.params['showGrid'] as bool? ?? true,
          points: _pointListFromDynamic(figure.params['points']),
          pathPoints: _pointListFromDynamic(figure.params['path']),
          highlightPoint: _pointFromDynamic(
            figure.params['highlightPoint'],
          ),
          labelFontFamily: labelFontFamily,
        ),
        child: const SizedBox.expand(),
      ),
    'geometry_scene' => CustomPaint(
        painter: GeometryScenePainter(
          scene: GeometryScene.fromParams(figure.params),
          labelFontFamily: labelFontFamily,
        ),
        child: const SizedBox.expand(),
      ),
    'composite_grid_shape' => CustomPaint(
        painter: CompositeGridShapePainter(
          rows: _intFromDynamic(figure.params['rows'], fallback: 3),
          cols: _intFromDynamic(figure.params['cols'], fallback: 3),
          filledCells: _cellListFromDynamic(figure.params['filledCells']),
          cellLabels: _stringMapFromDynamic(figure.params['cellLabels']),
          labelFontFamily: labelFontFamily,
        ),
        child: const SizedBox.expand(),
      ),
    'circle_quadrants_point' => CustomPaint(
        painter: CircleQuadrantsPointPainter(
          regionLabels: _stringMapFromDynamic(
            figure.params['regionLabels'],
          ),
          pointLabel: figure.params['pointLabel'] as String? ?? 'P',
          shadedRegion: figure.params['shadedRegion'] as String? ?? 'topRight',
          labelFontFamily: labelFontFamily,
        ),
        child: const SizedBox.expand(),
      ),
    _ => null,
  };

  if (figureChild == null) {
    if (kind != 'none' && kind.isNotEmpty) {
      debugPrint('buildFigureRenderSpec: 認不得的 figure kind「$kind」，這題不畫圖');
    }
    return null;
  }

  final double aspectRatio = switch (kind) {
    'shape_diagram' => 1.25,
    'coordinate_plane' => _coordinatePlaneAspectRatio(figure.params),
    'composite_grid_shape' => _compositeGridAspectRatio(figure.params),
    'circle_quadrants_point' => 1.15,
    'geometry_scene' => _geometrySceneAspectRatio(figure.params),
    _ => 1.55,
  };

  return FigureRenderSpec(
    child: figureChild,
    aspectRatio: aspectRatio,
  );
}

class _FigurePreviewDialog extends StatelessWidget {
  const _FigurePreviewDialog({
    required this.question,
    required this.spec,
  });

  final Question question;
  final FigureRenderSpec spec;

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      key: const ValueKey<String>('figure_preview_dialog'),
      backgroundColor: const Color(0xFFF8FAFC),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              child: Row(
                children: [
                  IconButton(
                    key: const ValueKey<String>('figure_preview_close'),
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      AppStrings.of(context).viewFigure,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: InteractiveViewer(
                minScale: 1,
                maxScale: 4,
                panEnabled: true,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: AspectRatio(
                      aspectRatio: spec.aspectRatio,
                      child: Container(
                        key: ValueKey<String>(
                          'figure_preview_canvas_${question.figure.kind}',
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        padding: const EdgeInsets.all(20),
                        child: buildFigureRenderSpec(question.figure)!.child,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 長寬比的上下限：再怎麼細長的圖，塞進題目版面時也不能變成一條線或一根柱子。
const double _minFigureAspect = 0.5;
const double _maxFigureAspect = 3.0;

/// 格線圖的長寬比跟著 rows / cols 走。
///
/// 以前這裡固定 1.1，於是 1×17 的座位圖被塞進接近正方形的框裡，
/// 畫成一條幾乎看不見的細線；2×7 的「兩種拼法並排」也一樣被壓小。
double _compositeGridAspectRatio(Map<String, dynamic> params) {
  final int rows = _intFromDynamic(params['rows'], fallback: 3);
  final int cols = _intFromDynamic(params['cols'], fallback: 3);
  if (rows <= 0 || cols <= 0) {
    return 1.0;
  }
  return (cols / rows).clamp(_minFigureAspect, _maxFigureAspect);
}

/// 座標圖的長寬比跟著座標範圍走，否則 x 0..6、y -8..8 這種直立的圖會被壓成橫的。
double _coordinatePlaneAspectRatio(Map<String, dynamic> params) {
  final int minX = _intFromDynamic(params['minX'], fallback: 0);
  final int maxX = _intFromDynamic(params['maxX'], fallback: 6);
  final int minY = _intFromDynamic(params['minY'], fallback: 0);
  final int maxY = _intFromDynamic(params['maxY'], fallback: 6);
  final int spanX = maxX - minX;
  final int spanY = maxY - minY;
  if (spanX <= 0 || spanY <= 0) {
    return 1.0;
  }
  return (spanX / spanY).clamp(_minFigureAspect, _maxFigureAspect);
}

double _geometrySceneAspectRatio(Map<String, dynamic> params) {
  final Map<String, dynamic> b =
      Map<String, dynamic>.from(params['bounds'] as Map? ?? const {});
  final double spanX = ((b['maxX'] ?? 1) as num).toDouble() -
      ((b['minX'] ?? 0) as num).toDouble();
  final double spanY = ((b['maxY'] ?? 1) as num).toDouble() -
      ((b['minY'] ?? 0) as num).toDouble();
  if (spanY <= 0) return 1.2;
  return (spanX / spanY).clamp(0.75, 1.7).toDouble();
}

/// 依 [GeometryScene] 宣告式規格畫向量幾何圖（點/線段/陰影多邊形/圓弧/角度/直角/等長記號）。
class GeometryScenePainter extends CustomPainter {
  const GeometryScenePainter({required this.scene, this.labelFontFamily});

  final GeometryScene scene;

  /// 標籤字型；app 端不傳（用系統預設字型），僅供無頭渲染指定字型使用。
  final String? labelFontFamily;

  static const double _pad = 18;
  static const Color _ink = Color(0xFF1F2937);
  static const Color _accent = Color(0xFF2B5FA6);
  static const Color _shadeFill = Color(0x1FE47855);
  static const Color _shadeStroke = Color(0xFFC65B3C);

  Offset _p(String name, Size size) =>
      scene.pointToScreen(name, size, padding: _pad);
  Offset _m(Offset math, Size size) =>
      scene.toScreen(math, size, padding: _pad);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePaint = Paint()
      ..color = _ink
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    final Paint constrPaint = Paint()
      ..color = _accent
      ..strokeWidth = 1.7
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final Paint markPaint = Paint()
      ..color = _accent
      ..strokeWidth = 1.7
      ..style = PaintingStyle.stroke;
    final Paint tickPaint = Paint()
      ..color = _ink
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke;
    final Paint shadeFillPaint = Paint()
      ..color = _shadeFill
      ..style = PaintingStyle.fill;
    final Paint shadeStrokePaint = Paint()
      ..color = _shadeStroke
      ..strokeWidth = 1.6
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    // 1) 陰影多邊形
    for (final GeometryPolygon poly in scene.polygons) {
      final Path path = Path();
      for (int i = 0; i < poly.vertices.length; i++) {
        final Offset o = _p(poly.vertices[i], size);
        if (i == 0) {
          path.moveTo(o.dx, o.dy);
        } else {
          path.lineTo(o.dx, o.dy);
        }
      }
      path.close();
      canvas.drawPath(path, shadeFillPaint);
      canvas.drawPath(path, shadeStrokePaint);
    }

    // 2) 圓弧（沿數學弧取樣後轉螢幕座標，避免翻轉方向混淆）
    for (final GeometryArc arc in scene.arcs) {
      final Path path = Path();
      const int steps = 48;
      for (int i = 0; i <= steps; i++) {
        final double deg = arc.from + (arc.to - arc.from) * i / steps;
        final double rad = deg * math.pi / 180;
        final Offset sp = _m(
          Offset(
              arc.cx + arc.r * math.cos(rad), arc.cy + arc.r * math.sin(rad)),
          size,
        );
        if (i == 0) {
          path.moveTo(sp.dx, sp.dy);
        } else {
          path.lineTo(sp.dx, sp.dy);
        }
      }
      canvas.drawPath(path, linePaint);
    }

    // 3) 線段（實線 / 虛線輔助線）
    for (final GeometrySegment seg in scene.segments) {
      final Offset a = _p(seg.from, size);
      final Offset b = _p(seg.to, size);
      if (seg.style == GeometryLineStyle.construction) {
        _dashedLine(canvas, a, b, constrPaint);
      } else {
        canvas.drawLine(a, b, linePaint);
      }
    }

    // 4) 直角小方塊
    for (final GeometryRightAngle ra in scene.rightAngles) {
      final Offset v = _p(ra.at, size);
      final Offset d1 = _unit(_p(ra.from, size) - v);
      final Offset d2 = _unit(_p(ra.to, size) - v);
      const double k = 12;
      final Path path = Path()
        ..moveTo(v.dx + d1.dx * k, v.dy + d1.dy * k)
        ..lineTo(v.dx + (d1.dx + d2.dx) * k, v.dy + (d1.dy + d2.dy) * k)
        ..lineTo(v.dx + d2.dx * k, v.dy + d2.dy * k);
      canvas.drawPath(path, markPaint);
    }

    // 5) 角度弧＋數值
    for (final GeometryAngleMark am in scene.angleMarks) {
      final Offset v = _p(am.at, size);
      final Offset d1 = _unit(_p(am.from, size) - v);
      final Offset d2 = _unit(_p(am.to, size) - v);
      final double a1 = math.atan2(d1.dy, d1.dx);
      double sweep = math.atan2(d2.dy, d2.dx) - a1;
      while (sweep <= -math.pi) {
        sweep += 2 * math.pi;
      }
      while (sweep > math.pi) {
        sweep -= 2 * math.pi;
      }
      const double r = 22;
      canvas.drawArc(
          Rect.fromCircle(center: v, radius: r), a1, sweep, false, markPaint);
      if (am.label != null && am.label!.isNotEmpty) {
        final double midA = a1 + sweep / 2;
        final Offset lblAt =
            v + Offset(math.cos(midA), math.sin(midA)) * (r + 12);
        _text(canvas, am.label!, lblAt, size, color: _accent, sizePx: 13);
      }
    }

    // 6) 等長邊記號
    for (final GeometryEqualTick et in scene.equalTicks) {
      for (final List<String> seg in et.segments) {
        if (seg.length < 2) continue;
        final Offset a = _p(seg[0], size);
        final Offset b = _p(seg[1], size);
        final Offset mid = (a + b) / 2;
        final Offset dir = _unit(b - a);
        final Offset perp = Offset(-dir.dy, dir.dx);
        for (int i = 0; i < et.count; i++) {
          final double along = (i - (et.count - 1) / 2) * 5;
          final Offset c = mid + dir * along;
          canvas.drawLine(c - perp * 6, c + perp * 6, tickPaint);
        }
      }
    }

    // 7) 點與標籤（畫最上層）
    final Paint ptFill = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final Paint ptStroke = Paint()
      ..color = _ink
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    scene.points.forEach((String name, Offset _) {
      final Offset o = _p(name, size);
      final Offset dir = _labelDir(scene.pointLabelPos[name] ?? 'r');
      final String label = scene.pointLabels[name] ?? name;
      if (scene.pointIsVisible[name] == false) {
        // 隱藏的輔助點只有明確給了 label 才畫文字（例如圖上標「AP = 3」）。
        if (!scene.pointLabels.containsKey(name)) return;
        _text(
          canvas,
          label,
          o + dir * 11,
          size,
          color: _accent,
          sizePx: 13,
        );
        return;
      }
      canvas.drawCircle(o, 4.5, ptFill);
      canvas.drawCircle(o, 4.5, ptStroke);
      _text(
        canvas,
        label,
        o + dir * 15,
        size,
        color: _ink,
        sizePx: 14,
        bold: true,
      );
    });
  }

  void _dashedLine(Canvas canvas, Offset a, Offset b, Paint paint,
      {double dash = 6, double gap = 5}) {
    final double total = (b - a).distance;
    if (total == 0) return;
    final Offset dir = (b - a) / total;
    double d = 0;
    while (d < total) {
      final Offset s = a + dir * d;
      final Offset e = a + dir * math.min(d + dash, total);
      canvas.drawLine(s, e, paint);
      d += dash + gap;
    }
  }

  Offset _unit(Offset v) {
    final double len = v.distance;
    return len == 0 ? Offset.zero : v / len;
  }

  Offset _labelDir(String pos) => switch (pos) {
        't' => const Offset(0, -1),
        'b' => const Offset(0, 1),
        'l' => const Offset(-1, 0),
        'r' => const Offset(1, 0),
        'tl' => const Offset(-0.7, -0.7),
        'tr' => const Offset(0.7, -0.7),
        'bl' => const Offset(-0.7, 0.7),
        'br' => const Offset(0.7, 0.7),
        _ => const Offset(1, 0),
      };

  void _text(
    Canvas canvas,
    String text,
    Offset center,
    Size bounds, {
    required Color color,
    double sizePx = 13,
    bool bold = false,
  }) {
    final TextPainter tp = TextPainter(
      text: TextSpan(
        text: normalizeMathText(text),
        style: TextStyle(
          color: color,
          fontSize: sizePx,
          fontFamily: labelFontFamily,
          fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
          fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    const double edgePadding = 4;
    final double halfWidth = tp.width / 2;
    final double halfHeight = tp.height / 2;
    final double clampedX = center.dx.clamp(
      halfWidth + edgePadding,
      bounds.width - halfWidth - edgePadding,
    );
    final double clampedY = center.dy.clamp(
      halfHeight + edgePadding,
      bounds.height - halfHeight - edgePadding,
    );
    tp.paint(canvas, Offset(clampedX - halfWidth, clampedY - halfHeight));
  }

  @override
  bool shouldRepaint(covariant GeometryScenePainter oldDelegate) =>
      oldDelegate.scene != scene;
}
