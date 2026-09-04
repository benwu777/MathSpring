import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mathspring/main.dart';
import 'package:mathspring/models/question.dart';

/// 驗證器的 KINDS 白名單擋住了題庫那一側，但 renderer 這一側過去完全沒有測試。
/// 未列在 switch 裡的 kind 會回傳 null，`_QuestionFigureView` 就 SizedBox.shrink()
/// ——不報錯、不留 log、畫面一片空白。
const List<String> whitelistedKinds = <String>[
  'geometry_scene',
  'shape_diagram',
  'coordinate_plane',
  'composite_grid_shape',
  'circle_quadrants_point',
];

QuestionFigure _figure(String kind, [Map<String, dynamic> params = const {}]) {
  return QuestionFigure(type: FigureType.custom, kind: kind, params: params);
}

const Map<String, Map<String, dynamic>> minimalParams = <String, Map<String, dynamic>>{
  'geometry_scene': <String, dynamic>{
    'bounds': <String, dynamic>{'minX': 0, 'minY': 0, 'maxX': 4, 'maxY': 3},
    'points': <dynamic>[
      <String, dynamic>{'name': 'A', 'x': 0, 'y': 0},
      <String, dynamic>{'name': 'B', 'x': 4, 'y': 0},
    ],
    'segments': <dynamic>[
      <String, dynamic>{'from': 'A', 'to': 'B'},
    ],
  },
  'shape_diagram': <String, dynamic>{
    'shape': 'trapezoid',
    'labels': <String, dynamic>{'top': '4', 'bottom': '10'},
  },
  'coordinate_plane': <String, dynamic>{
    'minX': -2, 'maxX': 6, 'minY': -2, 'maxY': 6,
    'showGrid': true,
    'points': <dynamic>[
      <String, dynamic>{'x': 1, 'y': 2, 'label': 'A'},
    ],
  },
  'composite_grid_shape': <String, dynamic>{
    'rows': 2,
    'cols': 3,
    'filledCells': <dynamic>[
      <dynamic>[0, 0],
      <dynamic>[1, 2],
    ],
  },
  'circle_quadrants_point': <String, dynamic>{
    'shadedRegion': 'topRight',
    'pointLabel': 'P',
  },
};

/// 各 painter 的 labelFontFamily 沒有共同介面，測試裡直接分支問。
String? labelFontFamilyOf(CustomPainter painter) {
  return switch (painter) {
    GeometryScenePainter p => p.labelFontFamily,
    ShapeDiagramPainter p => p.labelFontFamily,
    CoordinatePlanePainter p => p.labelFontFamily,
    CompositeGridShapePainter p => p.labelFontFamily,
    CircleQuadrantsPointPainter p => p.labelFontFamily,
    _ => null,
  };
}

void main() {
  group('buildFigureRenderSpec', () {
    for (final String kind in whitelistedKinds) {
      test('$kind renders a spec with a positive aspect ratio', () {
        final FigureRenderSpec? spec =
            buildFigureRenderSpec(_figure(kind, minimalParams[kind]!));
        expect(spec, isNotNull, reason: '$kind 在驗證器白名單裡，renderer 必須畫得出來');
        expect(spec!.aspectRatio, greaterThan(0));
      });
    }

    test('trig_plane 畫得出來，但刻意不在題庫白名單裡', () {
      // TrigGraphPainter 完全不讀 params，畫的是寫死的 sin / cos 曲線，
      // 只給 app 內建的展示畫面用。放進題庫白名單會讓起草代理以為
      // 可以用它畫任意三角函數圖，實際上參數全部會被忽略。
      expect(buildFigureRenderSpec(_figure('trig_plane')), isNotNull);
      expect(whitelistedKinds, isNot(contains('trig_plane')));
    });

    test('每個 painter 都收得到 labelFontFamily，預覽工具才畫得出文字', () {
      // 預覽工具在測試環境裡沒有系統字型，painter 若把 TextStyle 寫死，
      // 座標軸刻度與格子標籤會全部畫成黑方塊——看圖等於白看。
      // GeometryScenePainter 本來就有這個參數，其餘四個 painter 沒有。
      for (final String kind in whitelistedKinds) {
        final FigureRenderSpec spec = buildFigureRenderSpec(
            _figure(kind, minimalParams[kind]!),
            labelFontFamily: 'PreviewFont')!;
        final CustomPainter painter = (spec.child as CustomPaint).painter!;
        expect(labelFontFamilyOf(painter), 'PreviewFont', reason: '$kind 沒有把字型傳下去');
      }
    });

    test('an unknown kind returns null instead of throwing', () {
      expect(buildFigureRenderSpec(_figure('spirograph')), isNull);
    });

    test('kind none returns null so the question renders without a figure', () {
      expect(buildFigureRenderSpec(_figure('none')), isNull);
    });

    test('composite_grid_shape 的長寬比要跟著格線的形狀走', () {
      // 固定 1.1 的話，1×17 的座位圖會被塞進一個接近正方形的框裡，
      // 畫成一條幾乎看不見的細線。
      double ratio(int rows, int cols) => buildFigureRenderSpec(_figure(
            'composite_grid_shape',
            <String, dynamic>{'rows': rows, 'cols': cols, 'filledCells': <dynamic>[]},
          ))!.aspectRatio;
      // 1×17 與 2×7 都超過上限，會一起被夾到 3.0——寬的不可以比窄的還窄就好
      expect(ratio(1, 17), greaterThanOrEqualTo(ratio(2, 7)));
      expect(ratio(2, 7), greaterThan(ratio(3, 3)));
      expect(ratio(3, 3), closeTo(1.0, 0.001));
      expect(ratio(5, 2), lessThan(1.0));
    });

    test('composite_grid_shape 的長寬比有上下限，不會被極端格線拉爆', () {
      final double extreme = buildFigureRenderSpec(_figure(
        'composite_grid_shape',
        <String, dynamic>{'rows': 1, 'cols': 40, 'filledCells': <dynamic>[]},
      ))!.aspectRatio;
      expect(extreme, lessThanOrEqualTo(3.0));
      final double tall = buildFigureRenderSpec(_figure(
        'composite_grid_shape',
        <String, dynamic>{'rows': 40, 'cols': 1, 'filledCells': <dynamic>[]},
      ))!.aspectRatio;
      expect(tall, greaterThanOrEqualTo(0.5));
    });

    test('coordinate_plane 的長寬比要跟著座標範圍走', () {
      // grade5_044 的範圍是 x 0..6、y -8..8，明顯是直立的，
      // 固定 1.35 會把它壓成橫的。
      double ratio(int minX, int maxX, int minY, int maxY) =>
          buildFigureRenderSpec(_figure('coordinate_plane', <String, dynamic>{
            'minX': minX, 'maxX': maxX, 'minY': minY, 'maxY': maxY,
            'points': <dynamic>[],
          }))!.aspectRatio;
      expect(ratio(0, 6, -8, 8), lessThan(1.0));
      expect(ratio(0, 20, 0, 5), greaterThan(ratio(0, 6, 0, 6)));
    });

    test('coordinate_plane 省略範圍時仍有可用的長寬比', () {
      final FigureRenderSpec spec = buildFigureRenderSpec(
          _figure('coordinate_plane', <String, dynamic>{'points': <dynamic>[]}))!;
      expect(spec.aspectRatio, closeTo(1.0, 0.001));
    });

    test('geometry_scene aspect ratio follows the declared bounds', () {
      final FigureRenderSpec? wide = buildFigureRenderSpec(_figure(
        'geometry_scene',
        <String, dynamic>{
          'bounds': <String, dynamic>{'minX': 0, 'minY': 0, 'maxX': 10, 'maxY': 2},
          'points': <dynamic>[],
        },
      ));
      final FigureRenderSpec? tall = buildFigureRenderSpec(_figure(
        'geometry_scene',
        <String, dynamic>{
          'bounds': <String, dynamic>{'minX': 0, 'minY': 0, 'maxX': 2, 'maxY': 10},
          'points': <dynamic>[],
        },
      ));
      expect(wide!.aspectRatio, greaterThan(tall!.aspectRatio));
    });
  });

  group('每張圖都畫得出來', () {
    testWidgets('每個白名單 kind 都能實際 paint 一次而不丟例外', (WidgetTester tester) async {
      for (final String kind in whitelistedKinds) {
        final FigureRenderSpec spec =
            buildFigureRenderSpec(_figure(kind, minimalParams[kind]!))!;
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 320,
                height: 320 / spec.aspectRatio,
                child: spec.child,
              ),
            ),
          ),
        ));
        expect(tester.takeException(), isNull, reason: '$kind paint 時丟了例外');
      }
    });
  });
}
