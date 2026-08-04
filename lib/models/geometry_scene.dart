import 'dart:math' as math;
import 'dart:ui';

/// 線段樣式：實體邊 (solid) 或輔助線 (construction，畫虛線)。
enum GeometryLineStyle { solid, construction }

GeometryLineStyle _parseStyle(Object? raw) =>
    raw == 'construction' ? GeometryLineStyle.construction : GeometryLineStyle.solid;

double _toDouble(Object? v) => (v as num).toDouble();

class GeometrySegment {
  const GeometrySegment({required this.from, required this.to, required this.style});
  final String from;
  final String to;
  final GeometryLineStyle style;
}

class GeometryPolygon {
  const GeometryPolygon({required this.vertices, required this.fill});
  final List<String> vertices;
  final String fill;
}

class GeometryArc {
  const GeometryArc({
    required this.cx,
    required this.cy,
    required this.r,
    required this.from,
    required this.to,
  });
  final double cx;
  final double cy;
  final double r;
  final double from; // 起始角(度)，逆時針為正
  final double to; // 終止角(度)
}

class GeometryAngleMark {
  const GeometryAngleMark({
    required this.at,
    required this.from,
    required this.to,
    this.label,
  });
  final String at;
  final String from;
  final String to;
  final String? label;
}

class GeometryRightAngle {
  const GeometryRightAngle({required this.at, required this.from, required this.to});
  final String at;
  final String from;
  final String to;
}

class GeometryEqualTick {
  const GeometryEqualTick({required this.segments, required this.count});
  final List<List<String>> segments;
  final int count;
}

/// 幾何場景：宣告式圖形規格 `figure.kind = "geometry_scene"` 的解析與座標轉換。
///
/// 座標採數學慣例（y 向上）；[toScreen] 依畫布尺寸做 y 翻轉、等比縮放與置中。
class GeometryScene {
  GeometryScene({
    required this.points,
    required this.pointLabelPos,
    required this.segments,
    required this.polygons,
    required this.arcs,
    required this.angleMarks,
    required this.rightAngles,
    required this.equalTicks,
    required this.minX,
    required this.minY,
    required this.maxX,
    required this.maxY,
  });

  final Map<String, Offset> points; // 數學座標
  final Map<String, String> pointLabelPos; // 標籤方位 t/b/l/r/tl/...
  final List<GeometrySegment> segments;
  final List<GeometryPolygon> polygons;
  final List<GeometryArc> arcs;
  final List<GeometryAngleMark> angleMarks;
  final List<GeometryRightAngle> rightAngles;
  final List<GeometryEqualTick> equalTicks;
  final double minX;
  final double minY;
  final double maxX;
  final double maxY;

  factory GeometryScene.fromParams(Map<String, dynamic> params) {
    final Map<String, dynamic> bounds =
        Map<String, dynamic>.from(params['bounds'] as Map? ?? const {});
    final Map<String, Offset> pts = <String, Offset>{};
    final Map<String, String> labelPos = <String, String>{};
    for (final Object? raw in (params['points'] as List? ?? const [])) {
      final Map<String, dynamic> p = Map<String, dynamic>.from(raw as Map);
      final String name = p['name'] as String;
      pts[name] = Offset(_toDouble(p['x']), _toDouble(p['y']));
      labelPos[name] = (p['pos'] as String?) ?? 'r';
    }

    List<Map<String, dynamic>> maps(String key) =>
        ((params[key] as List?) ?? const [])
            .map((Object? e) => Map<String, dynamic>.from(e as Map))
            .toList();

    return GeometryScene(
      points: pts,
      pointLabelPos: labelPos,
      segments: maps('segments')
          .map((m) => GeometrySegment(
                from: m['from'] as String,
                to: m['to'] as String,
                style: _parseStyle(m['style']),
              ))
          .toList(),
      polygons: maps('polygons')
          .map((m) => GeometryPolygon(
                vertices: (m['vertices'] as List).cast<String>(),
                fill: (m['fill'] as String?) ?? 'shaded',
              ))
          .toList(),
      arcs: maps('arcs')
          .map((m) => GeometryArc(
                cx: _toDouble(m['cx']),
                cy: _toDouble(m['cy']),
                r: _toDouble(m['r']),
                from: _toDouble(m['from']),
                to: _toDouble(m['to']),
              ))
          .toList(),
      angleMarks: maps('angleMarks')
          .map((m) => GeometryAngleMark(
                at: m['at'] as String,
                from: m['from'] as String,
                to: m['to'] as String,
                label: m['label'] as String?,
              ))
          .toList(),
      rightAngles: maps('rightAngles')
          .map((m) => GeometryRightAngle(
                at: m['at'] as String,
                from: m['from'] as String,
                to: m['to'] as String,
              ))
          .toList(),
      equalTicks: maps('equalTicks')
          .map((m) => GeometryEqualTick(
                segments: (m['segments'] as List)
                    .map((Object? s) => (s as List).cast<String>())
                    .toList(),
                count: (m['count'] as num?)?.toInt() ?? 1,
              ))
          .toList(),
      minX: _toDouble(bounds['minX'] ?? 0),
      minY: _toDouble(bounds['minY'] ?? 0),
      maxX: _toDouble(bounds['maxX'] ?? 1),
      maxY: _toDouble(bounds['maxY'] ?? 1),
    );
  }

  /// 把數學座標點轉成畫布螢幕座標：等比縮放、置中、y 翻轉。
  Offset toScreen(Offset p, Size size, {double padding = 12}) {
    final double availW = math.max(size.width - 2 * padding, 1);
    final double availH = math.max(size.height - 2 * padding, 1);
    final double spanX = math.max(maxX - minX, 1e-9);
    final double spanY = math.max(maxY - minY, 1e-9);
    final double scale = math.min(availW / spanX, availH / spanY);
    final double contentW = spanX * scale;
    final double contentH = spanY * scale;
    final double offsetX = padding + (availW - contentW) / 2;
    final double offsetY = padding + (availH - contentH) / 2;
    return Offset(
      offsetX + (p.dx - minX) * scale,
      offsetY + (maxY - p.dy) * scale,
    );
  }

  Offset pointToScreen(String name, Size size, {double padding = 12}) =>
      toScreen(points[name]!, size, padding: padding);
}
