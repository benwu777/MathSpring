import 'package:flutter_test/flutter_test.dart';
import 'package:mathspring/models/avatar_configuration.dart';
import 'package:mathspring/services/avatar_catalog.dart';

void main() {
  test('only exposes avatar options with an available asset layer', () {
    expect(AvatarCatalog.skinOptionsFor(AvatarPresentation.girl),
        <String>['girl_skin_01', 'girl_skin_02', 'girl_skin_03']);
    expect(AvatarCatalog.faceOptionsFor(AvatarPresentation.girl),
        <String>['girl_face_01', 'girl_face_02', 'girl_face_03']);
    expect(AvatarCatalog.hairOptionsFor(AvatarPresentation.girl), <String>[
      'girl_hair_01',
      'girl_hair_03',
      'girl_hair_04',
      'girl_hair_05'
    ]);
    expect(AvatarCatalog.eyeOptionsFor(AvatarPresentation.girl),
        <String>['girl_eyes_01', 'girl_eyes_02', 'girl_eyes_03']);
    expect(AvatarCatalog.noseOptionsFor(AvatarPresentation.girl),
        <String>['girl_nose_01', 'girl_nose_02', 'girl_nose_03']);
    expect(AvatarCatalog.mouthOptionsFor(AvatarPresentation.girl), <String>[
      'girl_mouth_01',
      'girl_mouth_02',
      'girl_mouth_03',
      'girl_mouth_04',
      'girl_mouth_05',
      'girl_mouth_06',
      'girl_mouth_07',
    ]);

    expect(AvatarCatalog.skinOptionsFor(AvatarPresentation.boy),
        <String>['boy_skin_01', 'boy_skin_02', 'boy_skin_03']);
    expect(AvatarCatalog.faceOptionsFor(AvatarPresentation.boy),
        <String>['boy_face_01', 'boy_face_02', 'boy_face_03']);
    expect(AvatarCatalog.hairOptionsFor(AvatarPresentation.boy),
        <String>['boy_hair_01', 'boy_hair_02', 'boy_hair_03']);
    expect(AvatarCatalog.eyeOptionsFor(AvatarPresentation.boy),
        <String>['boy_eyes_01', 'boy_eyes_02', 'boy_eyes_03']);
    expect(AvatarCatalog.noseOptionsFor(AvatarPresentation.boy),
        <String>['boy_nose_01', 'boy_nose_02', 'boy_nose_03']);
    expect(AvatarCatalog.mouthOptionsFor(AvatarPresentation.boy),
        <String>['boy_mouth_01', 'boy_mouth_02', 'boy_mouth_03']);
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
