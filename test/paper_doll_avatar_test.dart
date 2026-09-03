import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('both avatar presentations ship five image layers per face category', () {
    const List<String> presentations = <String>['boy', 'girl'];
    const List<String> categories = <String>[
      'skin_tone',
      'face_shape',
      'hairstyle',
      'eyes',
      'nose',
      'mouth',
    ];

    for (final String presentation in presentations) {
      for (final String category in categories) {
        final Directory directory =
            Directory('assets/avatars/$presentation/$category');
        final List<FileSystemEntity> files = directory.existsSync()
            ? directory
                .listSync()
                .where((FileSystemEntity entity) => entity.path.endsWith('.png'))
                .toList()
            : <FileSystemEntity>[];

        expect(
          files.length,
          greaterThanOrEqualTo(5),
          reason: '$presentation/$category needs at least five PNG layers',
        );
      }
    }
  });

  test('paper-doll layers are registered as Flutter assets', () async {
    await expectLater(
      rootBundle.load('assets/avatars/boy/skin_tone/skin_tone_0.png'),
      completes,
    );
    await expectLater(
      rootBundle.load('assets/avatars/girl/mouth/mouth_4.png'),
      completes,
    );
  });

  test('face-shape layers contain visible, composable detail', () async {
    const List<String> presentations = <String>['boy', 'girl'];

    for (final String presentation in presentations) {
      for (int index = 0; index < 5; index++) {
        final ByteData bytes = await rootBundle.load(
          'assets/avatars/$presentation/face_shape/face_shape_$index.png',
        );
        final ui.Codec codec = await ui.instantiateImageCodec(
          bytes.buffer.asUint8List(),
        );
        final ui.FrameInfo frame = await codec.getNextFrame();
        final ByteData? rgba = await frame.image.toByteData(
          format: ui.ImageByteFormat.rawRgba,
        );
        frame.image.dispose();
        codec.dispose();

        expect(
          rgba!.buffer.asUint8List().where((int value) => value > 0).length,
          greaterThan(0),
          reason: '$presentation face shape $index must not be transparent',
        );
      }
    }
  });
}
