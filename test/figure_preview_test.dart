import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mathspring/main.dart';
import 'package:mathspring/models/geometry_scene.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final String? figDir = Platform.environment['FIG_DIR'];

  test('dump geometry_scene previews', () async {
    final String dir = figDir!;
    final Uint8List fontBytes =
        File('/System/Library/Fonts/Supplemental/Arial.ttf').readAsBytesSync();
    final FontLoader loader = FontLoader('PreviewFont')
      ..addFont(Future<ByteData>.value(ByteData.view(fontBytes.buffer)));
    await loader.load();

    final List<dynamic> specs =
        jsonDecode(File('$dir/figspec.json').readAsStringSync()) as List<dynamic>;

    for (final dynamic raw in specs) {
      final Map<String, dynamic> spec = Map<String, dynamic>.from(raw as Map);
      final Map<String, dynamic> params =
          Map<String, dynamic>.from(spec['params'] as Map);
      final GeometryScene scene = GeometryScene.fromParams(params);

      final double spanX = scene.maxX - scene.minX;
      final double spanY = scene.maxY - scene.minY;
      const double base = 560;
      final double w = base;
      final double h = (base * (spanY / spanX)).clamp(240.0, 720.0);
      final Size size = Size(w, h);

      final ui.PictureRecorder recorder = ui.PictureRecorder();
      final Canvas canvas = Canvas(recorder);
      canvas.drawRect(
          Offset.zero & size, Paint()..color = const Color(0xFFFFFFFF));
      GeometryScenePainter(scene: scene, labelFontFamily: 'PreviewFont')
          .paint(canvas, size);
      final ui.Image img = await recorder
          .endRecording()
          .toImage(size.width.round(), size.height.round());
      final ByteData? png = await img.toByteData(format: ui.ImageByteFormat.png);
      File('$dir/${spec['id']}.png').writeAsBytesSync(png!.buffer.asUint8List());
    }
  }, skip: figDir == null ? 'set FIG_DIR to dump geometry_scene previews as PNG' : false);
}
