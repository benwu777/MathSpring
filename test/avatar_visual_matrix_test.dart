import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mathspring/models/avatar_configuration.dart';
import 'package:mathspring/services/avatar_asset_catalog.dart';

/// The visual sheets are composed from the same PNG layers under
/// `/private/tmp`, where they can be inspected without making a binary golden
/// part of source control. These checks keep their input assets and placement
/// contract safe to render in every matrix cell.
const int _matrixCanvasSize = 251;

void main() {
  test(
      'composes real avatar layers into inspectable skin and hair matrix pages',
      () async {
    final Directory outputDirectory = Directory(
      '/private/tmp/mathspring-avatar-rendered-matrix',
    );
    await outputDirectory.create(recursive: true);

    final List<String> knownEyeOverlaps = <String>[];
    for (final AvatarPresentation presentation in AvatarPresentation.values) {
      final List<File> composites = <File>[];
      final List<String> skinOptions =
          AvatarConfiguration.optionsFor(presentation, 'skin');
      final String defaultHair =
          AvatarConfiguration.optionsFor(presentation, 'hair').first;
      for (final String hairId
          in AvatarConfiguration.optionsFor(presentation, 'hair')) {
        for (final String skinId in skinOptions) {
          // This bounded contact matrix still contains every hairstyle and
          // every skin: the default skin compares all hair, while the default
          // hair compares all skin. A full 95-cell Cartesian product belongs
          // to final visual acceptance, not the quick regression test.
          if (hairId != defaultHair && skinId != skinOptions.first) {
            continue;
          }
          final AvatarConfiguration configuration =
              AvatarConfiguration.defaultFor(presentation).copyWith(
            hairId: hairId,
            skinId: skinId,
          );
          final File composite = File(
            '${outputDirectory.path}/${presentation.name}-$hairId-$skinId.png',
          );
          await _composeAvatar(configuration, composite);
          expect(await composite.length(), greaterThan(1000),
              reason: '$hairId / $skinId must produce a real PNG');
          composites.add(composite);

          final double overlap =
              hairId == defaultHair || skinId == skinOptions.first
                  ? await _criticalEyeOverlap(configuration)
                  : 0;
          if (overlap > .01) {
            knownEyeOverlaps
                .add('$hairId/$skinId=${overlap.toStringAsFixed(3)}');
          }
        }
      }

      for (int pageStart = 0; pageStart < composites.length; pageStart += 25) {
        final int page = pageStart ~/ 25 + 1;
        final File sheet = File(
          '${outputDirectory.path}/${presentation.name}-matrix-page-$page.png',
        );
        await _runMagick(<String>[
          'montage',
          ...composites
              .sublist(pageStart, (pageStart + 25).clamp(0, composites.length))
              .map((File file) => file.path),
          '-tile',
          '5x',
          '-geometry',
          '130x130+4+18',
          '-label',
          '%t',
          '-background',
          'white',
          sheet.path,
        ]);
        expect(await sheet.length(), greaterThan(1000),
            reason: '${presentation.name} page $page must be non-empty');
      }
    }

    expect(
      knownEyeOverlaps,
      isEmpty,
      reason: 'every hairstyle must leave the eye artwork unobstructed; '
          'found ${knownEyeOverlaps.join(', ')}',
    );
    await File('${outputDirectory.path}/known-eye-overlaps.txt').writeAsString(
      '${knownEyeOverlaps.join('\n')}\n',
    );
  });

  test('every preview hair layer has a transparent canonical canvas', () async {
    for (final AvatarPresentation presentation in AvatarPresentation.values) {
      for (final String hairId
          in AvatarConfiguration.optionsFor(presentation, 'hair')) {
        final AvatarAssetBundle assets = AvatarAssetCatalog.resolve(
          AvatarConfiguration.defaultFor(presentation).copyWith(
            hairId: hairId,
          ),
        );
        final Uint8List header = await File(assets.hairFrontAsset)
            .openRead(0, 26)
            .fold<BytesBuilder>(BytesBuilder(), (BytesBuilder buffer, data) {
          buffer.add(data);
          return buffer;
        }).then((BytesBuilder buffer) => buffer.takeBytes());

        expect(header.length, greaterThanOrEqualTo(26), reason: hairId);
        expect(
          header.sublist(0, 8),
          <int>[137, 80, 78, 71, 13, 10, 26, 10],
          reason: '$hairId 必須是 PNG',
        );
        expect(
          _readUint32(header, 16),
          1254,
          reason: '$hairId 必須與臉部共用 1254px 寬畫布',
        );
        expect(
          _readUint32(header, 20),
          1254,
          reason: '$hairId 必須與臉部共用 1254px 高畫布',
        );
        expect(
          header[25],
          6,
          reason: '$hairId 必須有 alpha 通道，避免方形背景覆蓋臉部',
        );
      }
    }
  });

  test('composes every eye option into an inspectable reviewer sheet',
      () async {
    final Directory outputDirectory = Directory(
      '/private/tmp/mathspring-avatar-eye-matrix',
    );
    await outputDirectory.create(recursive: true);

    for (final AvatarPresentation presentation in AvatarPresentation.values) {
      final List<File> composites = <File>[];
      for (final String eyesId
          in AvatarConfiguration.optionsFor(presentation, 'eyes')) {
        final AvatarConfiguration configuration =
            AvatarConfiguration.defaultFor(presentation).copyWith(
          eyesId: eyesId,
        );
        final File composite = File(
          '${outputDirectory.path}/${presentation.name}-$eyesId.png',
        );
        await _composeAvatar(configuration, composite);
        expect(await composite.length(), greaterThan(1000), reason: eyesId);
        composites.add(composite);
      }
      final File sheet = File(
        '${outputDirectory.path}/${presentation.name}-eyes.png',
      );
      await _runMagick(<String>[
        'montage',
        ...composites.map((File file) => file.path),
        '-tile',
        '4x',
        '-geometry',
        '130x130+4+18',
        '-label',
        '%t',
        '-background',
        'white',
        sheet.path,
      ]);
      expect(await sheet.length(), greaterThan(1000),
          reason: '${presentation.name} eye matrix must be non-empty');
    }
  });

  test(
      'every non-default skin keeps the composed canvas background transparent',
      () async {
    final Directory outputDirectory = Directory(
      '/private/tmp/mathspring-avatar-skin-alpha',
    );
    await outputDirectory.create(recursive: true);

    for (final AvatarPresentation presentation in AvatarPresentation.values) {
      final List<String> skinOptions =
          AvatarConfiguration.optionsFor(presentation, 'skin');
      for (final String skinId in skinOptions.skip(1)) {
        final AvatarConfiguration configuration =
            AvatarConfiguration.defaultFor(presentation).copyWith(
          skinId: skinId,
        );
        final File composite = File(
          '${outputDirectory.path}/${presentation.name}-$skinId.png',
        );
        await _composeAvatar(configuration, composite);

        final ProcessResult pixel = await Process.run('magick', <String>[
          composite.path,
          '-alpha',
          'extract',
          '-format',
          '%[fx:p{0,0}],%[fx:p{125,125}]',
          'info:',
        ]);
        expect(pixel.exitCode, 0, reason: pixel.stderr);
        expect(
          double.parse((pixel.stdout as String).trim().split(',').first),
          0,
          reason: '$skinId must not tint the transparent canvas background',
        );
        expect(
          double.parse((pixel.stdout as String).trim().split(',').last),
          greaterThan(.9),
          reason: '$skinId must retain the opaque face at the canvas center',
        );
      }
    }
  });

  test('hair placement transforms remain bounded inside an avatar preview', () {
    for (final AvatarPresentation presentation in AvatarPresentation.values) {
      for (final String hairId
          in AvatarConfiguration.optionsFor(presentation, 'hair')) {
        final AvatarAssetBundle assets = AvatarAssetCatalog.resolve(
          AvatarConfiguration.defaultFor(presentation).copyWith(
            hairId: hairId,
          ),
        );

        expect(assets.hairScale, inInclusiveRange(.8, 1.1), reason: hairId);
        expect(
          assets.hairScaleX.abs(),
          inInclusiveRange(.8, 1.1),
          reason: '$hairId 不得被過度水平拉伸',
        );
        expect(
          assets.hairOffsetX.abs(),
          lessThanOrEqualTo(.1),
          reason: '$hairId 不得偏離預覽中央超過 10%',
        );
        expect(
          assets.hairOffsetY.abs(),
          lessThanOrEqualTo(.12),
          reason: '$hairId 不得偏離預覽上下安全範圍超過 12%',
        );
      }
    }
  });
}

int _readUint32(Uint8List bytes, int offset) =>
    ByteData.sublistView(bytes).getUint32(offset, Endian.big);

Future<void> _composeAvatar(
  AvatarConfiguration configuration,
  File output,
) async {
  final AvatarAssetBundle assets = AvatarAssetCatalog.resolve(configuration);
  final List<String> args = <String>[];
  if (assets.hairBackAsset case final String hairBackAsset) {
    args.addAll(_hairLayerArgs(hairBackAsset, assets));
  }
  args.addAll(_faceLayerArgs(assets));
  if (assets.eyesAsset case final String eyesAsset) {
    args.addAll(<String>['(', eyesAsset, '-resize', '251x251!', ')']);
  }
  if (assets.noseAsset case final String noseAsset) {
    args.addAll(_noseLayerArgs(noseAsset, assets));
  }
  if (assets.mouthAsset case final String mouthAsset) {
    args.addAll(<String>['(', mouthAsset, '-resize', '251x251!', ')']);
  }
  args.addAll(_hairLayerArgs(assets.hairFrontAsset, assets));
  args.addAll(<String>[
    '-background',
    'none',
    '-layers',
    'merge',
    output.path,
  ]);
  await _runMagick(args);
}

List<String> _noseLayerArgs(String asset, AvatarAssetBundle assets) {
  final String? tint = assets.noseTint == null
      ? null
      : '#${assets.noseTint!.toARGB32().toRadixString(16).padLeft(8, '0').substring(2)}';
  return <String>[
    '(',
    asset,
    '-resize',
    '${_matrixCanvasSize}x$_matrixCanvasSize!',
    if (tint != null) ...<String>[
      '-fill',
      tint,
      '-colorize',
      '35%',
    ],
    ')',
  ];
}

List<String> _faceLayerArgs(AvatarAssetBundle assets) {
  if (assets.skinTint == null) {
    return <String>[
      '(',
      assets.baseAsset,
      '-resize',
      '${_matrixCanvasSize}x$_matrixCanvasSize!',
      ')',
    ];
  }
  final String tint =
      '#${assets.skinTint!.toARGB32().toRadixString(16).padLeft(8, '0').substring(2)}';
  return <String>[
    '(',
    assets.baseAsset,
    '-resize',
    '${_matrixCanvasSize}x$_matrixCanvasSize!',
    '-fill',
    tint,
    '-colorize',
    '35%',
    ')',
  ];
}

List<String> _hairLayerArgs(String asset, AvatarAssetBundle assets) {
  final int width =
      (_matrixCanvasSize * assets.hairScale * assets.hairScaleX.abs()).round();
  final int height = (_matrixCanvasSize * assets.hairScale).round();
  final int offsetX = (_matrixCanvasSize * assets.hairOffsetX).round();
  final int offsetY = (_matrixCanvasSize * assets.hairOffsetY).round();
  return <String>[
    '(',
    asset,
    '-resize',
    '${width}x$height!',
    if (assets.hairScaleX.isNegative) '-flop',
    '-gravity',
    'North',
    '-geometry',
    '${offsetX >= 0 ? '+' : ''}$offsetX${offsetY >= 0 ? '+' : ''}$offsetY',
    '-background',
    'none',
    '-extent',
    '${_matrixCanvasSize}x$_matrixCanvasSize',
    ')',
  ];
}

/// Hair may naturally touch eyebrow or eyelash pixels, so the full alpha masks
/// are too broad to decide whether a learner can see the eyes.  These two
/// windows cover the pupil/iris zone on each side of the shared 1254px canvas.
/// A non-transparent hair pixel there is an actual eye obstruction.
Future<double> _criticalEyeOverlap(AvatarConfiguration configuration) async {
  final AvatarAssetBundle assets = AvatarAssetCatalog.resolve(configuration);
  const List<String> eyeWindows = <String>[
    '20x40+415+605',
    '20x40+815+605',
  ];
  double greatestOverlap = 0;
  final int hairWidth =
      (1254 * assets.hairScale * assets.hairScaleX.abs()).round();
  final int hairHeight = (1254 * assets.hairScale).round();
  final int hairOffsetX = (1254 * assets.hairOffsetX).round();
  final int hairOffsetY = (1254 * assets.hairOffsetY).round();
  for (final String window in eyeWindows) {
    final ProcessResult result = await Process.run('magick', <String>[
      '(',
      assets.hairFrontAsset,
      '-resize',
      '${hairWidth}x$hairHeight!',
      if (assets.hairScaleX.isNegative) '-flop',
      '-gravity',
      'North',
      '-geometry',
      '${hairOffsetX >= 0 ? '+' : ''}$hairOffsetX${hairOffsetY >= 0 ? '+' : ''}$hairOffsetY',
      '-background',
      'none',
      '-extent',
      '1254x1254',
      '-alpha',
      'extract',
      ')',
      '(',
      assets.eyesAsset!,
      '-alpha',
      'extract',
      ')',
      '-compose',
      'Multiply',
      '-composite',
      '-crop',
      window,
      '-format',
      '%[fx:mean]',
      'info:',
    ]);
    expect(result.exitCode, 0, reason: result.stderr);
    greatestOverlap =
        greatestOverlap > double.parse((result.stdout as String).trim())
            ? greatestOverlap
            : double.parse((result.stdout as String).trim());
  }
  return greatestOverlap;
}

Future<void> _runMagick(List<String> args) async {
  final ProcessResult result = await Process.run('magick', args);
  expect(result.exitCode, 0,
      reason: '${result.stderr}\nmagick ${args.join(' ')}');
}
