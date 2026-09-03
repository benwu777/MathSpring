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
    expect(girl.hairAsset, 'assets/avatars/girl/hair/hair-01.png');
    expect(boy.baseAsset, 'assets/avatars/boy/base/base-01.png');
    expect(boy.hairAsset, 'assets/avatars/boy/hair/hair-01.png');
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
      AvatarAssetCatalog.resolve(firstHair).hairAsset,
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

  test('uses the existing boy eye layer for the second eye thumbnail', () {
    expect(
      AvatarAssetCatalog.optionAssetFor(
        AvatarPresentation.boy,
        'boy_eyes_02',
      ),
      'assets/avatars/boy/eyes/eyes-01.png',
    );
  });

  test('uses the matching presentation eye layer for third eye thumbnails', () {
    expect(
      AvatarAssetCatalog.optionAssetFor(
        AvatarPresentation.girl,
        'girl_eyes_03',
      ),
      'assets/avatars/girl/eyes/eyes-01.png',
    );
  });

  test('tints a boy nose with the selected deeper skin tone', () {
    final AvatarAssetBundle assets = AvatarAssetCatalog.resolve(
      AvatarConfiguration(
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
      AvatarAssetCatalog.resolve(curlyHair).hairAsset,
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
      AvatarAssetCatalog.resolve(bobHair).hairAsset,
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
      AvatarAssetCatalog.resolve(ponytailHair).hairAsset,
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

  test('calibrates the boy hair layer above the eye line', () {
    final AvatarAssetBundle assets = AvatarAssetCatalog.resolve(
      AvatarConfiguration.defaultFor(AvatarPresentation.boy),
    );

    expect(assets.hairScale, 1);
    expect(assets.hairOffsetY, -.1);
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

  test('applies the second skin, face, and boy eye treatments independently',
      () {
    const AvatarConfiguration girl = AvatarConfiguration(
      presentation: AvatarPresentation.girl,
      skinId: 'girl_skin_02',
      faceId: 'girl_face_02',
      hairId: 'girl_hair_01',
      eyesId: 'girl_eyes_01',
      noseId: 'girl_nose_01',
      mouthId: 'girl_mouth_01',
    );
    const AvatarConfiguration boy = AvatarConfiguration(
      presentation: AvatarPresentation.boy,
      skinId: 'boy_skin_02',
      faceId: 'boy_face_02',
      hairId: 'boy_hair_01',
      eyesId: 'boy_eyes_02',
      noseId: 'boy_nose_01',
      mouthId: 'boy_mouth_01',
    );

    expect(AvatarAssetCatalog.resolve(girl).skinTint, isNotNull);
    expect(AvatarAssetCatalog.resolve(girl).faceScaleX, lessThan(1));
    expect(AvatarAssetCatalog.resolve(boy).skinTint, isNotNull);
    expect(AvatarAssetCatalog.resolve(boy).faceScaleX, lessThan(1));
    expect(AvatarAssetCatalog.resolve(boy).eyesScaleY, greaterThan(1));
  });

  test('gives every third option a distinct aligned treatment', () {
    const AvatarConfiguration girl = AvatarConfiguration(
      presentation: AvatarPresentation.girl,
      skinId: 'girl_skin_03',
      faceId: 'girl_face_03',
      hairId: 'girl_hair_01',
      eyesId: 'girl_eyes_03',
      noseId: 'girl_nose_03',
      mouthId: 'girl_mouth_01',
    );
    const AvatarConfiguration boy = AvatarConfiguration(
      presentation: AvatarPresentation.boy,
      skinId: 'boy_skin_03',
      faceId: 'boy_face_03',
      hairId: 'boy_hair_03',
      eyesId: 'boy_eyes_03',
      noseId: 'boy_nose_03',
      mouthId: 'boy_mouth_03',
    );

    final AvatarAssetBundle girlAssets = AvatarAssetCatalog.resolve(girl);
    final AvatarAssetBundle boyAssets = AvatarAssetCatalog.resolve(boy);

    expect(girlAssets.skinTint, isNotNull);
    expect(girlAssets.noseTint, girlAssets.skinTint);
    expect(girlAssets.faceScaleX, greaterThan(1));
    expect(girlAssets.eyesScaleY, lessThan(1));
    expect(girlAssets.noseScale, greaterThan(1));
    expect(boyAssets.skinTint, isNotNull);
    expect(boyAssets.noseTint, boyAssets.skinTint);
    expect(boyAssets.faceScaleX, greaterThan(1));
    expect(boyAssets.hairScaleX, lessThan(0));
    expect(boyAssets.eyesScaleX, lessThan(1));
    expect(boyAssets.noseScale, greaterThan(1));
    expect(boyAssets.mouthScaleX, greaterThan(1));
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
}
