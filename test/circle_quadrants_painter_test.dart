import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mathspring/main.dart';

/// `shadedRegion` 過去只有 `topRight` 有作用，填其他三個值靜默不上色——
/// 不報錯、不留 log，出題的人只會看到一張沒有陰影的圖。
///
/// 這裡真的把圖畫出來再取樣像素，不是去比對參數：靜默不上色這種缺陷
/// 只有看畫出來的東西才抓得到。
const double canvasSize = 400;
const Color shadeColor = Color(0xFFE0E7FF);

/// 四個區域各取一個代表點（畫布座標）。半徑是 400 * 0.34 = 136，
/// 圓心在 (200, 200)，所以中心往外 0.5 個半徑仍在圓內。
const Map<String, Offset> probes = <String, Offset>{
  'topRight': Offset(268, 132),
  'bottomRight': Offset(268, 268),
  'bottomLeft': Offset(132, 268),
  'topLeft': Offset(132, 132),
};

Future<ByteData> _render(String shadedRegion) async {
  final ui.PictureRecorder recorder = ui.PictureRecorder();
  final Canvas canvas = Canvas(recorder);
  const Size size = Size(canvasSize, canvasSize);
  canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0xFFFFFFFF));
  CircleQuadrantsPointPainter(
    regionLabels: const <String, String>{},
    pointLabel: 'P',
    shadedRegion: shadedRegion,
  ).paint(canvas, size);
  final ui.Image img =
      await recorder.endRecording().toImage(canvasSize.round(), canvasSize.round());
  return (await img.toByteData(format: ui.ImageByteFormat.rawRgba))!;
}

Color _pixelAt(ByteData data, Offset at) {
  final int offset = ((at.dy.round() * canvasSize.round()) + at.dx.round()) * 4;
  return Color.fromARGB(
    data.getUint8(offset + 3),
    data.getUint8(offset),
    data.getUint8(offset + 1),
    data.getUint8(offset + 2),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CircleQuadrantsPointPainter 的 shadedRegion', () {
    for (final String region in probes.keys) {
      test('$region 真的會上色，而且只上那一區', () async {
        final ByteData pixels = await _render(region);
        final List<String> shaded = <String>[
          for (final MapEntry<String, Offset> e in probes.entries)
            if (_pixelAt(pixels, e.value) == shadeColor) e.key,
        ];
        expect(shaded, <String>[region]);
      });
    }

    test('認不得的 shadedRegion 不上色，也不丟例外', () async {
      final ByteData pixels = await _render('middle');
      for (final Offset probe in probes.values) {
        expect(_pixelAt(pixels, probe), isNot(shadeColor));
      }
    });
  });
}
