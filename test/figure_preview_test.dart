import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mathspring/main.dart';
import 'package:mathspring/models/question.dart';

/// 把題庫的圖渲染成 PNG，讓人真的看一眼。
///
/// 用 `scripts/dump_figure_previews.py` 驅動；也可以自己準備一個資料夾，
/// 放 `figspec.json`（`[{"id":…, "kind":…, "params":…}]`）再帶 `FIG_DIR` 執行。
/// 沒帶 `FIG_DIR` 會自動跳過（testWidgets 的 skip 只吃 bool，理由寫在這裡）。
///
/// kind 到 painter 的對應直接問 app 自己的 `buildFigureRenderSpec`，不另外抄一份，
/// 所以畫出來的東西跟 app 裡看到的一致，五種 kind 也都畫得出來——以前這支只認得
/// GeometryScenePainter，composite_grid_shape 那些圖從來沒有人看過畫面。
///
/// 用 PictureRecorder 直接跑 painter，而不是 pump 一棵 widget tree：
/// widget 那條路要等引擎真的把 RepaintBoundary 光柵化，在 flutter_test 裡
/// 第二張圖就會卡住不回來。
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final String? figDir = Platform.environment['FIG_DIR'];

  test('dump figure previews', () async {
    final String dir = figDir!;
    // 題庫的標籤有中文（「長比寬多5公尺」之類），Arial 沒有漢字字符，
    // 只用它會把中文標籤畫成一排空方塊——看圖等於白看。
    // 先載中文字型，Arial 當備援。
    const List<String> fontCandidates = <String>[
      '/System/Library/Fonts/Hiragino Sans GB.ttc',
      '/System/Library/Fonts/STHeiti Medium.ttc',
      '/System/Library/Fonts/Supplemental/Songti.ttc',
      '/System/Library/Fonts/Supplemental/Arial.ttf',
    ];
    final FontLoader loader = FontLoader('PreviewFont');
    int loaded = 0;
    for (final String path in fontCandidates) {
      final File file = File(path);
      if (!file.existsSync()) {
        continue;
      }
      loader.addFont(
          Future<ByteData>.value(ByteData.view(file.readAsBytesSync().buffer)));
      loaded++;
    }
    expect(loaded, greaterThan(0), reason: '找不到任何可用的預覽字型');
    await loader.load();

    final List<dynamic> specs =
        jsonDecode(File('$dir/figspec.json').readAsStringSync()) as List<dynamic>;

    final List<String> failures = <String>[];
    for (final dynamic raw in specs) {
      final Map<String, dynamic> spec = Map<String, dynamic>.from(raw as Map);
      final String id = spec['id'] as String;
      final QuestionFigure figure = QuestionFigure(
        type: FigureType.custom,
        kind: spec['kind'] as String? ?? 'geometry_scene',
        params: Map<String, dynamic>.from(spec['params'] as Map),
      );

      final FigureRenderSpec? render =
          buildFigureRenderSpec(figure, labelFontFamily: 'PreviewFont');
      if (render == null) {
        failures.add('$id: renderer 認不得 kind「${figure.kind}」');
        continue;
      }
      final Widget child = render.child;
      if (child is! CustomPaint || child.painter == null) {
        failures.add('$id: ${figure.kind} 不是 CustomPaint，這支工具畫不了');
        continue;
      }

      const double width = 560;
      final double height = (width / render.aspectRatio).clamp(240.0, 720.0);
      final Size size = Size(width, height);

      final ui.PictureRecorder recorder = ui.PictureRecorder();
      final Canvas canvas = Canvas(recorder);
      canvas.drawRect(
          Offset.zero & size, Paint()..color = const Color(0xFFFFFFFF));
      // 留白，免得標籤貼著邊被切掉——跟 app 裡 padding: EdgeInsets.all(16) 一致
      const double pad = 16;
      canvas.save();
      canvas.translate(pad, pad);
      child.painter!.paint(canvas, Size(size.width - pad * 2, size.height - pad * 2));
      canvas.restore();

      final ui.Image img = await recorder
          .endRecording()
          .toImage(size.width.round(), size.height.round());
      final ByteData? png = await img.toByteData(format: ui.ImageByteFormat.png);
      File('$dir/$id.png').writeAsBytesSync(png!.buffer.asUint8List());
    }

    expect(failures, isEmpty, reason: failures.join('\n'));
  }, skip: figDir == null ? 'set FIG_DIR to dump figure previews as PNG' : false);
}
