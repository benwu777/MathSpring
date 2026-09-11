import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mathspring/models/avatar_configuration.dart';
import 'package:mathspring/services/avatar_asset_catalog.dart';
import 'package:mathspring/widgets/avatar_preview.dart';

void main() {
  testWidgets('renders a labelled girl avatar preview',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AvatarPreview(
            configuration: AvatarConfiguration(
              presentation: AvatarPresentation.girl,
              skinId: 'girl_skin_01',
              faceId: 'girl_face_01',
              hairId: 'girl_hair_01',
              eyesId: 'girl_eyes_01',
              noseId: 'girl_nose_01',
              mouthId: 'girl_mouth_01',
            ),
          ),
        ),
      ),
    );

    expect(
        find.byKey(const ValueKey<String>('avatar_preview')), findsOneWidget);
    expect(find.bySemanticsLabel('Girl avatar: girl_hair_01'), findsOneWidget);
  });

  testWidgets('changes semantics when a boy hairstyle changes', (
    WidgetTester tester,
  ) async {
    const AvatarConfiguration first = AvatarConfiguration(
      presentation: AvatarPresentation.boy,
      skinId: 'boy_skin_01',
      faceId: 'boy_face_01',
      hairId: 'boy_hair_01',
      eyesId: 'boy_eyes_01',
      noseId: 'boy_nose_01',
      mouthId: 'boy_mouth_01',
    );
    await tester.pumpWidget(
      const MaterialApp(
          home: Scaffold(body: AvatarPreview(configuration: first))),
    );
    expect(find.bySemanticsLabel('Boy avatar: boy_hair_01'), findsOneWidget);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AvatarPreview(
            configuration: AvatarConfiguration(
              presentation: AvatarPresentation.boy,
              skinId: 'boy_skin_01',
              faceId: 'boy_face_01',
              hairId: 'boy_hair_04',
              eyesId: 'boy_eyes_01',
              noseId: 'boy_nose_01',
              mouthId: 'boy_mouth_01',
            ),
          ),
        ),
      ),
    );
    expect(find.bySemanticsLabel('Boy avatar: boy_hair_04'), findsOneWidget);
  });

  test('resolves a polished bitmap base and hair layer for each presentation',
      () {
    final AvatarAssetBundle girl = AvatarAssetCatalog.resolve(
      AvatarConfiguration.defaultFor(AvatarPresentation.girl),
    );
    final AvatarAssetBundle boy = AvatarAssetCatalog.resolve(
      AvatarConfiguration.defaultFor(AvatarPresentation.boy),
    );

    expect(girl.baseAsset, 'assets/avatars/girl/base/face-01.png');
    expect(girl.hairFrontAsset, 'assets/avatars/girl/hair/hair-01.png');
    expect(boy.baseAsset, 'assets/avatars/boy/base/base-01.png');
    expect(boy.hairFrontAsset, 'assets/avatars/boy/hair/hair-01.png');
    expect(boy.noseAsset, 'assets/avatars/boy/nose/nose-01.png');
    expect(boy.mouthAsset, 'assets/avatars/boy/mouth/mouth-01.png');
  });

  test('resolves the selected boy hairstyle instead of a fixed layer', () {
    const AvatarConfiguration firstHair = AvatarConfiguration(
      presentation: AvatarPresentation.boy,
      skinId: 'boy_skin_01',
      faceId: 'boy_face_01',
      hairId: 'boy_hair_01',
      eyesId: 'boy_eyes_01',
      noseId: 'boy_nose_01',
      mouthId: 'boy_mouth_01',
    );

    expect(
      AvatarAssetCatalog.resolve(firstHair).hairFrontAsset,
      'assets/avatars/boy/hair/hair-01.png',
    );
  });

  test('resolves the selected boy nose instead of a fixed layer', () {
    const AvatarConfiguration secondNose = AvatarConfiguration(
      presentation: AvatarPresentation.boy,
      skinId: 'boy_skin_01',
      faceId: 'boy_face_01',
      hairId: 'boy_hair_01',
      eyesId: 'boy_eyes_01',
      noseId: 'boy_nose_02',
      mouthId: 'boy_mouth_01',
    );

    expect(
      AvatarAssetCatalog.resolve(secondNose).noseAsset,
      'assets/avatars/boy/nose/nose-02.png',
    );
    expect(AvatarAssetCatalog.resolve(secondNose).mouthOffsetY, .20);
  });

  test('tints a boy nose with the selected deeper skin tone', () {
    final AvatarAssetBundle assets = AvatarAssetCatalog.resolve(
      const AvatarConfiguration(
        presentation: AvatarPresentation.boy,
        skinId: 'boy_skin_02',
        faceId: 'boy_face_01',
        hairId: 'boy_hair_01',
        eyesId: 'boy_eyes_01',
        noseId: 'boy_nose_02',
        mouthId: 'boy_mouth_01',
      ),
    );

    expect(assets.skinTint, isNotNull);
    expect(assets.noseTint, assets.skinTint);
  });

  testWidgets(
      'applies skin colour only to skin layers, not a persisted eye colour',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AvatarPreview(
            configuration: AvatarConfiguration.defaultFor(
              AvatarPresentation.girl,
            ).copyWith(
              skinId: 'girl_skin_04',
              eyeColorId: 'eye_color_04',
            ),
          ),
        ),
      ),
    );

    expect(
      find.byType(ColorFiltered),
      findsNWidgets(2),
      reason: '只有臉部與鼻子皮膚圖層可以套用膚色濾鏡',
    );
    final List<ColorFiltered> skinFilters =
        tester.widgetList<ColorFiltered>(find.byType(ColorFiltered)).toList();
    expect(
      skinFilters.map((ColorFiltered filter) => filter.colorFilter),
      everyElement(
        const ColorFilter.mode(Color(0xFFB77B49), BlendMode.modulate),
      ),
      reason: '臉部與鼻子都必須保留透明畫布，不能用 multiply 填滿背景',
    );
  });

  testWidgets('renders glasses as part of the selected eyes layer',
      (WidgetTester tester) async {
    final AvatarConfiguration glassesEyes = AvatarConfiguration.defaultFor(
      AvatarPresentation.girl,
    ).copyWith(
      eyesId: 'girl_eyes_06',
      accessoryId: 'accessory_glasses_01',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: AvatarPreview(configuration: glassesEyes)),
      ),
    );

    expect(
      AvatarAssetCatalog.resolve(glassesEyes).eyesAsset,
      'assets/avatars/girl/eyes/eyes-06.png',
    );
    expect(find.byKey(const ValueKey<String>('avatar_eyes_layer')),
        findsOneWidget);
    expect(find.byKey(const ValueKey<String>('avatar_accessory_layer')),
        findsNothing);
  });

  test('resolves the accepted boy toothy-smile mouth', () {
    const AvatarConfiguration toothySmile = AvatarConfiguration(
      presentation: AvatarPresentation.boy,
      skinId: 'boy_skin_01',
      faceId: 'boy_face_01',
      hairId: 'boy_hair_01',
      eyesId: 'boy_eyes_01',
      noseId: 'boy_nose_01',
      mouthId: 'boy_mouth_02',
    );

    expect(
      AvatarAssetCatalog.resolve(toothySmile).mouthAsset,
      'assets/avatars/boy/mouth/mouth-02.png',
    );
  });

  test('resolves the selected girl curly hairstyle', () {
    const AvatarConfiguration curlyHair = AvatarConfiguration(
      presentation: AvatarPresentation.girl,
      skinId: 'girl_skin_01',
      faceId: 'girl_face_01',
      hairId: 'girl_hair_03',
      eyesId: 'girl_eyes_01',
      noseId: 'girl_nose_01',
      mouthId: 'girl_mouth_01',
    );

    expect(
      AvatarAssetCatalog.resolve(curlyHair).hairFrontAsset,
      'assets/avatars/girl/hair/hair-03.png',
    );
  });

  test('resolves the accepted girl round-eye variation', () {
    const AvatarConfiguration roundEyes = AvatarConfiguration(
      presentation: AvatarPresentation.girl,
      skinId: 'girl_skin_01',
      faceId: 'girl_face_01',
      hairId: 'girl_hair_01',
      eyesId: 'girl_eyes_02',
      noseId: 'girl_nose_01',
      mouthId: 'girl_mouth_01',
    );

    expect(
      AvatarAssetCatalog.resolve(roundEyes).eyesAsset,
      'assets/avatars/girl/eyes/eyes-02.png',
    );
  });

  test('resolves the accepted girl upturned-nose variation', () {
    const AvatarConfiguration upturnedNose = AvatarConfiguration(
      presentation: AvatarPresentation.girl,
      skinId: 'girl_skin_01',
      faceId: 'girl_face_01',
      hairId: 'girl_hair_01',
      eyesId: 'girl_eyes_01',
      noseId: 'girl_nose_02',
      mouthId: 'girl_mouth_01',
    );

    expect(
      AvatarAssetCatalog.resolve(upturnedNose).noseAsset,
      'assets/avatars/girl/nose/nose-02.png',
    );
  });

  test('resolves the accepted girl bob hairstyle', () {
    const AvatarConfiguration bobHair = AvatarConfiguration(
      presentation: AvatarPresentation.girl,
      skinId: 'girl_skin_01',
      faceId: 'girl_face_01',
      hairId: 'girl_hair_04',
      eyesId: 'girl_eyes_01',
      noseId: 'girl_nose_01',
      mouthId: 'girl_mouth_01',
    );

    expect(
      AvatarAssetCatalog.resolve(bobHair).hairFrontAsset,
      'assets/avatars/girl/hair/hair-04.png',
    );
  });

  test('resolves the accepted girl low ponytail hairstyle', () {
    const AvatarConfiguration ponytailHair = AvatarConfiguration(
      presentation: AvatarPresentation.girl,
      skinId: 'girl_skin_01',
      faceId: 'girl_face_01',
      hairId: 'girl_hair_05',
      eyesId: 'girl_eyes_01',
      noseId: 'girl_nose_01',
      mouthId: 'girl_mouth_01',
    );

    expect(
      AvatarAssetCatalog.resolve(ponytailHair).hairFrontAsset,
      'assets/avatars/girl/hair/hair-05.png',
    );
  });

  test('resolves the accepted girl small-smile mouth', () {
    const AvatarConfiguration smallSmile = AvatarConfiguration(
      presentation: AvatarPresentation.girl,
      skinId: 'girl_skin_01',
      faceId: 'girl_face_01',
      hairId: 'girl_hair_01',
      eyesId: 'girl_eyes_01',
      noseId: 'girl_nose_01',
      mouthId: 'girl_mouth_02',
    );

    expect(
      AvatarAssetCatalog.resolve(smallSmile).mouthAsset,
      'assets/avatars/girl/mouth/mouth-02.png',
    );
  });

  test('resolves the accepted girl neutral mouth', () {
    const AvatarConfiguration neutralMouth = AvatarConfiguration(
      presentation: AvatarPresentation.girl,
      skinId: 'girl_skin_01',
      faceId: 'girl_face_01',
      hairId: 'girl_hair_01',
      eyesId: 'girl_eyes_01',
      noseId: 'girl_nose_01',
      mouthId: 'girl_mouth_03',
    );

    expect(
      AvatarAssetCatalog.resolve(neutralMouth).mouthAsset,
      'assets/avatars/girl/mouth/mouth-03.png',
    );
  });

  test('resolves the accepted girl toothy-smile mouth', () {
    const AvatarConfiguration toothySmile = AvatarConfiguration(
      presentation: AvatarPresentation.girl,
      skinId: 'girl_skin_01',
      faceId: 'girl_face_01',
      hairId: 'girl_hair_01',
      eyesId: 'girl_eyes_01',
      noseId: 'girl_nose_01',
      mouthId: 'girl_mouth_04',
    );

    expect(
      AvatarAssetCatalog.resolve(toothySmile).mouthAsset,
      'assets/avatars/girl/mouth/mouth-04.png',
    );
  });

  test('resolves the accepted girl surprised and smirk mouths', () {
    const AvatarConfiguration surprised = AvatarConfiguration(
      presentation: AvatarPresentation.girl,
      skinId: 'girl_skin_01',
      faceId: 'girl_face_01',
      hairId: 'girl_hair_01',
      eyesId: 'girl_eyes_01',
      noseId: 'girl_nose_01',
      mouthId: 'girl_mouth_05',
    );
    const AvatarConfiguration smirk = AvatarConfiguration(
      presentation: AvatarPresentation.girl,
      skinId: 'girl_skin_01',
      faceId: 'girl_face_01',
      hairId: 'girl_hair_01',
      eyesId: 'girl_eyes_01',
      noseId: 'girl_nose_01',
      mouthId: 'girl_mouth_06',
    );

    expect(AvatarAssetCatalog.resolve(surprised).mouthAsset,
        'assets/avatars/girl/mouth/mouth-05.png');
    expect(AvatarAssetCatalog.resolve(smirk).mouthAsset,
        'assets/avatars/girl/mouth/mouth-06.png');
  });

  test('resolves the accepted girl pursed-pout mouth', () {
    const AvatarConfiguration pursedPout = AvatarConfiguration(
      presentation: AvatarPresentation.girl,
      skinId: 'girl_skin_01',
      faceId: 'girl_face_01',
      hairId: 'girl_hair_01',
      eyesId: 'girl_eyes_01',
      noseId: 'girl_nose_01',
      mouthId: 'girl_mouth_07',
    );

    expect(AvatarAssetCatalog.resolve(pursedPout).mouthAsset,
        'assets/avatars/girl/mouth/mouth-07.png');
  });

  test('keeps the boy baseline hair on the shared face canvas', () {
    final AvatarAssetBundle assets = AvatarAssetCatalog.resolve(
      AvatarConfiguration.defaultFor(AvatarPresentation.boy),
    );

    expect(assets.hairScale, 1);
    expect(assets.hairOffsetY, 0);
  });

  test('keeps the new boy hairstyle artwork on its aligned canvas', () {
    for (final String hairId in <String>[
      'boy_hair_06',
      'boy_hair_07',
      'boy_hair_08',
      'boy_hair_09',
    ]) {
      final AvatarAssetBundle assets = AvatarAssetCatalog.resolve(
        _withOption(AvatarPresentation.boy, 'hair', hairId),
      );

      expect(assets.hairOffsetY, 0, reason: '$hairId is already aligned');
    }
  });

  test('narrows the girl braided hairstyle by ten percent', () {
    final AvatarAssetBundle assets = AvatarAssetCatalog.resolve(
      _withOption(AvatarPresentation.girl, 'hair', 'girl_hair_10'),
    );

    expect(assets.hairScaleX, .9);
  });

  test('calibrates boy nose and mouth to their facial landmarks', () {
    final AvatarAssetBundle assets = AvatarAssetCatalog.resolve(
      AvatarConfiguration.defaultFor(AvatarPresentation.boy),
    );

    expect(assets.noseOffsetY, .092);
    expect(assets.mouthOffsetY, .168);
  });

  test('calibrates girl nose and mouth below the eye line', () {
    final AvatarAssetBundle assets = AvatarAssetCatalog.resolve(
      AvatarConfiguration.defaultFor(AvatarPresentation.girl),
    );

    expect(assets.eyesOffsetY, 0);
    expect(assets.noseOffsetY, .1);
    expect(assets.mouthOffsetY, .08);
  });

  test('tints the skin without replacing the chosen face layer', () {
    const AvatarConfiguration girl = AvatarConfiguration(
      presentation: AvatarPresentation.girl,
      skinId: 'girl_skin_02',
      faceId: 'girl_face_04',
      hairId: 'girl_hair_01',
      eyesId: 'girl_eyes_01',
      noseId: 'girl_nose_01',
      mouthId: 'girl_mouth_01',
    );

    final AvatarAssetBundle assets = AvatarAssetCatalog.resolve(girl);

    expect(assets.skinTint, isNotNull);
    expect(assets.noseTint, assets.skinTint);
    expect(assets.baseAsset, 'assets/avatars/girl/base/face-04.png');
  });

  testWidgets('brings the girl eye pair slightly toward the face center',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AvatarPreview(
            configuration: AvatarConfiguration.defaultFor(
              AvatarPresentation.girl,
            ),
          ),
        ),
      ),
    );

    final Transform eyeTransform = tester.widget<Transform>(
      find.byKey(const ValueKey<String>('avatar_eyes_layer')),
    );
    expect(eyeTransform.transform.storage[0], .92);
  });

  test('the boy cropped hairstyle owns a distinct, aligned artwork layer', () {
    final AvatarAssetBundle assets = AvatarAssetCatalog.resolve(
      _withOption(AvatarPresentation.boy, 'hair', 'boy_hair_05'),
    );

    expect(assets.hairFrontAsset, 'assets/avatars/boy/hair/hair-05.png');
    expect(assets.hairScale, 1);
    expect(assets.hairScaleX, 1);
  });

  test('face, eyes, nose, and mouth options each own a separate layer', () {
    // Skin is a tint of one base and hair still shares two partings; every
    // other part must ship real artwork per option instead of a runtime
    // scale of its neighbour.
    for (final AvatarPresentation presentation in AvatarPresentation.values) {
      for (final String category in <String>['face', 'eyes', 'nose', 'mouth']) {
        final List<String> options =
            AvatarConfiguration.optionsFor(presentation, category);
        final Set<String> layers = options
            .map((String id) =>
                AvatarAssetCatalog.optionAssetFor(presentation, id))
            .toSet();

        expect(layers.length, options.length,
            reason: '$presentation $category options share a layer: $layers');
        for (final String id in options) {
          expect(AvatarAssetCatalog.treatmentFor(id).isNeutral, isTrue,
              reason: '$id still fakes its shape with a runtime transform');
        }
      }
    }
  });

  test('every catalog option maps to an asset file that exists', () {
    for (final AvatarPresentation presentation in AvatarPresentation.values) {
      for (final String category in _categories) {
        for (final String id
            in AvatarConfiguration.optionsFor(presentation, category)) {
          final String path =
              AvatarAssetCatalog.optionAssetFor(presentation, id);
          expect(File(path).existsSync(), isTrue,
              reason: '$id points at a missing layer: $path');
        }
      }
    }
  });

  test('every option in a category renders differently from its siblings', () {
    for (final AvatarPresentation presentation in AvatarPresentation.values) {
      for (final String category in _categories) {
        final Map<String, String> signatures = <String, String>{};
        for (final String id
            in AvatarConfiguration.optionsFor(presentation, category)) {
          final String signature = _signature(
            AvatarAssetCatalog.resolve(_withOption(presentation, category, id)),
          );
          expect(signatures.containsKey(signature), isFalse,
              reason: '$id renders identically to ${signatures[signature]}');
          signatures[signature] = id;
        }
      }
    }
  });

  test(
      'keeps the boy small-nose mouth calibration for every nose that '
      'uses the small-nose layer', () {
    for (final String id
        in AvatarConfiguration.optionsFor(AvatarPresentation.boy, 'nose')) {
      final AvatarAssetBundle assets = AvatarAssetCatalog.resolve(
        _withOption(AvatarPresentation.boy, 'nose', id),
      );
      final bool usesSmallNose =
          assets.noseAsset == 'assets/avatars/boy/nose/nose-02.png';
      expect(assets.mouthOffsetY, usesSmallNose ? .20 : .168, reason: id);
    }
  });
}

const List<String> _categories = <String>[
  'skin',
  'face',
  'hair',
  'eyes',
  'nose',
  'mouth',
];

AvatarConfiguration _withOption(
  AvatarPresentation presentation,
  String category,
  String id,
) {
  final AvatarConfiguration base = AvatarConfiguration.defaultFor(presentation);
  return switch (category) {
    'skin' => base.copyWith(skinId: id),
    'face' => base.copyWith(faceId: id),
    'hair' => base.copyWith(hairId: id),
    'eyes' => base.copyWith(eyesId: id),
    'nose' => base.copyWith(noseId: id),
    'mouth' => base.copyWith(mouthId: id),
    _ => throw ArgumentError.value(category),
  };
}

String _signature(AvatarAssetBundle assets) => <Object?>[
      assets.baseAsset,
      assets.hairFrontAsset,
      assets.eyesAsset,
      assets.noseAsset,
      assets.mouthAsset,
      assets.hairScale,
      assets.hairScaleX,
      assets.hairOffsetX,
      assets.hairOffsetY,
      assets.eyesOffsetY,
      assets.eyesScaleX,
      assets.eyesScaleY,
      assets.skinTint,
      assets.noseTint,
      assets.noseScale,
      assets.noseOffsetY,
      assets.mouthOffsetY,
      assets.mouthScaleX,
    ].join('|');
