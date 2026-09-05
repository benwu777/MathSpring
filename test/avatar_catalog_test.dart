import 'package:flutter_test/flutter_test.dart';
import 'package:mathspring/models/avatar_configuration.dart';
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
    ]);
    expect(AvatarCatalog.eyeOptionsFor(AvatarPresentation.girl), <String>[
      'girl_eyes_01',
      'girl_eyes_02',
      'girl_eyes_03',
      'girl_eyes_04',
      'girl_eyes_05',
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
    ]);
    expect(AvatarCatalog.eyeOptionsFor(AvatarPresentation.boy), <String>[
      'boy_eyes_01',
      'boy_eyes_02',
      'boy_eyes_03',
      'boy_eyes_04',
      'boy_eyes_05',
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
}
