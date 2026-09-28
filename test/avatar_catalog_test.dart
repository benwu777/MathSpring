import 'package:flutter_test/flutter_test.dart';
import 'package:mathspring/models/avatar_configuration.dart';
import 'package:mathspring/services/avatar_asset_catalog.dart';
import 'package:mathspring/services/avatar_catalog.dart';

void main() {
  test('exposes five or more options for every part of both presentations', () {
    for (final AvatarPresentation presentation in AvatarPresentation.values) {
      for (final String category in <String>[
        'skin',
        'face',
        'hair',
        'eyes',
        'nose',
        'mouth',
      ]) {
        final List<String> options =
            AvatarConfiguration.optionsFor(presentation, category);
        expect(options.length, greaterThanOrEqualTo(5),
            reason: '$presentation $category needs at least five options');
        expect(options.toSet().length, options.length,
            reason: '$presentation $category has duplicate ids');
      }
    }
  });

  test('only exposes avatar options with an available asset layer', () {
    expect(AvatarCatalog.skinOptionsFor(AvatarPresentation.girl), <String>[
      'girl_skin_01',
      'girl_skin_02',
      'girl_skin_03',
      'girl_skin_04',
      'girl_skin_05',
    ]);
    expect(AvatarCatalog.faceOptionsFor(AvatarPresentation.girl), <String>[
      'girl_face_01',
      'girl_face_02',
      'girl_face_03',
      'girl_face_04',
      'girl_face_05',
    ]);
    expect(AvatarCatalog.hairOptionsFor(AvatarPresentation.girl), <String>[
      'girl_hair_01',
      'girl_hair_02',
      'girl_hair_03',
      'girl_hair_04',
      'girl_hair_05',
      'girl_hair_06',
      'girl_hair_07',
      'girl_hair_08',
      'girl_hair_09',
      'girl_hair_10',
    ]);
    expect(AvatarCatalog.eyeOptionsFor(AvatarPresentation.girl), <String>[
      'girl_eyes_01',
      'girl_eyes_02',
      'girl_eyes_03',
      'girl_eyes_04',
      'girl_eyes_05',
      'girl_eyes_06',
      'girl_eyes_07',
      'girl_eyes_08',
    ]);
    expect(AvatarCatalog.noseOptionsFor(AvatarPresentation.girl), <String>[
      'girl_nose_01',
      'girl_nose_02',
      'girl_nose_03',
      'girl_nose_04',
      'girl_nose_05',
    ]);
    expect(AvatarCatalog.mouthOptionsFor(AvatarPresentation.girl), <String>[
      'girl_mouth_01',
      'girl_mouth_02',
      'girl_mouth_03',
      'girl_mouth_04',
      'girl_mouth_05',
      'girl_mouth_06',
      'girl_mouth_07',
    ]);

    expect(AvatarCatalog.skinOptionsFor(AvatarPresentation.boy), <String>[
      'boy_skin_01',
      'boy_skin_02',
      'boy_skin_03',
      'boy_skin_04',
      'boy_skin_05',
    ]);
    expect(AvatarCatalog.faceOptionsFor(AvatarPresentation.boy), <String>[
      'boy_face_01',
      'boy_face_02',
      'boy_face_03',
      'boy_face_04',
      'boy_face_05',
    ]);
    expect(AvatarCatalog.hairOptionsFor(AvatarPresentation.boy), <String>[
      'boy_hair_01',
      'boy_hair_02',
      'boy_hair_03',
      'boy_hair_04',
      'boy_hair_05',
      'boy_hair_06',
      'boy_hair_07',
      'boy_hair_08',
      'boy_hair_09',
      'boy_hair_10',
    ]);
    expect(AvatarCatalog.eyeOptionsFor(AvatarPresentation.boy), <String>[
      'boy_eyes_01',
      'boy_eyes_02',
      'boy_eyes_03',
      'boy_eyes_04',
      'boy_eyes_05',
      'boy_eyes_06',
      'boy_eyes_07',
      'boy_eyes_08',
    ]);
    expect(AvatarCatalog.noseOptionsFor(AvatarPresentation.boy), <String>[
      'boy_nose_01',
      'boy_nose_02',
      'boy_nose_03',
      'boy_nose_04',
      'boy_nose_05',
    ]);
    expect(AvatarCatalog.mouthOptionsFor(AvatarPresentation.boy), <String>[
      'boy_mouth_01',
      'boy_mouth_02',
      'boy_mouth_03',
      'boy_mouth_04',
      'boy_mouth_05',
    ]);
  });

  test('legacy and invalid avatar values resolve to presentation defaults', () {
    final AvatarConfiguration restored = AvatarConfiguration.fromMap(
      const <String, Object?>{
        'avatar_presentation': 'boy',
        'avatar_skin_id': 'missing-skin',
        'avatar_face_id': null,
      },
    );

    expect(restored.presentation, AvatarPresentation.boy);
    expect(restored.skinId,
        AvatarCatalog.defaultFor(AvatarPresentation.boy).skinId);
    expect(restored.faceId,
        AvatarCatalog.defaultFor(AvatarPresentation.boy).faceId);
  });

  test('girl hair colours use a deep brown default and validate persisted ids',
      () {
    const List<String> hairColorIds = <String>[
      'girl_hair_color_01',
      'girl_hair_color_02',
      'girl_hair_color_03',
      'girl_hair_color_04',
      'girl_hair_color_05',
      'girl_hair_color_06',
    ];

    expect(
      AvatarConfiguration.defaultFor(AvatarPresentation.girl).hairColorId,
      'girl_hair_color_02',
    );
    expect(
      AvatarConfiguration.optionsFor(AvatarPresentation.girl, 'hair_color'),
      hairColorIds,
    );
    for (final String hairColorId in hairColorIds) {
      final AvatarConfiguration restored = AvatarConfiguration.fromMap(
        <String, Object?>{
          'avatar_presentation': 'girl',
          'avatar_hair_color_id': hairColorId,
        },
      );
      expect(restored.hairColorId, hairColorId);
      expect(restored.toMap()['avatar_hair_color_id'], hairColorId);
    }
    expect(
      AvatarConfiguration.fromMap(
        const <String, Object?>{'avatar_presentation': 'girl'},
      ).hairColorId,
      'girl_hair_color_02',
    );
    expect(
      AvatarConfiguration.fromMap(const <String, Object?>{
        'avatar_presentation': 'girl',
        'avatar_hair_color_id': 'unknown',
      }).hairColorId,
      'girl_hair_color_02',
    );
    expect(
      AvatarConfiguration.defaultFor(AvatarPresentation.boy).hairColorId,
      'girl_hair_color_02',
    );
    expect(
      AvatarConfiguration.optionsFor(AvatarPresentation.boy, 'hair_color'),
      hairColorIds,
    );
    expect(
      AvatarConfiguration.defaultFor(AvatarPresentation.girl)
          .copyWith(hairColorId: 'unknown')
          .hairColorId,
      'girl_hair_color_02',
    );
    expect(
      () => AvatarConfiguration(
        presentation: AvatarPresentation.girl,
        skinId: 'girl_skin_01',
        faceId: 'girl_face_01',
        hairId: 'girl_hair_01',
        hairColorId: 'unknown',
        eyesId: 'girl_eyes_01',
        noseId: 'girl_nose_01',
        mouthId: 'girl_mouth_01',
      ),
      throwsAssertionError,
    );
    const AvatarConfiguration boyWithPersistedGirlColour = AvatarConfiguration(
      presentation: AvatarPresentation.boy,
      skinId: 'boy_skin_01',
      faceId: 'boy_face_01',
      hairId: 'boy_hair_01',
      hairColorId: 'girl_hair_color_03',
      eyesId: 'boy_eyes_01',
      noseId: 'boy_nose_01',
      mouthId: 'boy_mouth_01',
    );
    expect(boyWithPersistedGirlColour.hairColorId, 'girl_hair_color_03');
    expect(
      boyWithPersistedGirlColour.toMap()['avatar_hair_color_id'],
      'girl_hair_color_03',
    );
  });

  test('keeps a persisted eye colour for compatibility without exposing it',
      () {
    final AvatarConfiguration restored = AvatarConfiguration.fromMap(
      const <String, Object?>{
        'avatar_presentation': 'girl',
        'avatar_eye_color_id': 'eye_color_04',
      },
    );

    expect(restored.eyeColorId, 'eye_color_04');
    expect(
      () => AvatarConfiguration.optionsFor(AvatarPresentation.girl, 'eyeColor'),
      throwsArgumentError,
      reason: '眼色不再是可供編輯的紙娃娃選項',
    );
  });

  test(
      'keeps a legacy glasses selection without offering a separate editor option',
      () {
    final AvatarConfiguration restored = AvatarConfiguration.fromMap(
      const <String, Object?>{
        'avatar_presentation': 'girl',
        'avatar_accessory_id': 'accessory_glasses_01',
      },
    );

    expect(restored.accessoryId, 'accessory_glasses_01');
    expect(
      () =>
          AvatarConfiguration.optionsFor(AvatarPresentation.girl, 'accessory'),
      throwsArgumentError,
      reason: '眼鏡改為眼睛圖稿的一部分，不能再獨立編輯',
    );
  });

  test('keeps the non-lifted redesigned boy hair layers safely aligned', () {
    for (final String hairId in <String>[
      'boy_hair_06',
    ]) {
      final AvatarAssetBundle assets = AvatarAssetCatalog.resolve(
        AvatarConfiguration.defaultFor(AvatarPresentation.boy).copyWith(
          hairId: hairId,
        ),
      );

      expect(assets.hairOffsetY, 0,
          reason: '$hairId must not use the old upward hair correction');
      expect(assets.hairScale, 1,
          reason: '$hairId is safely positioned within its own canvas');
      expect(assets.hairScaleX, 1,
          reason: '$hairId must not inherit a mirrored legacy parting');
    }
  });
}
