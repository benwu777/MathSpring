import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mathspring/models/avatar_configuration.dart';
import 'package:mathspring/services/avatar_asset_catalog.dart';
import 'package:mathspring/widgets/avatar_preview.dart';

/// 頭髮必須拆成前後兩層。
///
/// 之前整顆頭髮都畫在最前面，所以雙馬尾、長髮這種本來垂在臉「後面」的部分
/// 會蓋住臉頰與耳朵。後層要畫在臉之前（也就是被臉蓋住），前層（瀏海、頭頂）
/// 才畫在臉之後。
void main() {
  AvatarConfiguration girl({String hair = 'girl_hair_01'}) =>
      AvatarConfiguration(
        presentation: AvatarPresentation.girl,
        skinId: 'girl_skin_01',
        faceId: 'girl_face_01',
        hairId: hair,
        eyesId: 'girl_eyes_01',
        noseId: 'girl_nose_01',
        mouthId: 'girl_mouth_01',
      );

  group('圖層堆疊順序', () {
    testWidgets('後層頭髮畫在臉之前，前層頭髮畫在臉之後', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
            home: Scaffold(
                body:
                    AvatarPreview(configuration: girl(hair: 'girl_hair_06')))),
      );

      final Stack stack = tester.widget<Stack>(
        find
            .descendant(
              of: find.byKey(const ValueKey<String>('avatar_preview')),
              matching: find.byType(Stack),
            )
            .first,
      );
      final List<Key?> keys = stack.children.map((Widget w) => w.key).toList();

      int indexOf(String name) =>
          keys.indexWhere((Key? k) => k == ValueKey<String>(name));

      final int back = indexOf('avatar_hair_back_layer');
      final int face = indexOf('avatar_face_layer');
      final int front = indexOf('avatar_hair_front_layer');

      expect(back, isNonNegative, reason: '找不到後層頭髮');
      expect(face, isNonNegative, reason: '找不到臉部圖層');
      expect(front, isNonNegative, reason: '找不到前層頭髮');
      expect(back, lessThan(face), reason: '後層頭髮必須在臉之前繪製');
      expect(face, lessThan(front), reason: '前層頭髮必須在臉之後繪製');
    });
  });

  group('資產解析', () {
    test('每個髮型都要能查到前層，後層可以為 null', () {
      for (final AvatarPresentation p in AvatarPresentation.values) {
        for (final String hair in AvatarConfiguration.optionsFor(p, 'hair')) {
          final AvatarAssetBundle b = AvatarAssetCatalog.resolve(
            AvatarConfiguration.defaultFor(p).copyWith(hairId: hair),
          );
          expect(b.hairFrontAsset, isNotEmpty, reason: '$hair 沒有前層');
        }
      }
    });

    test('長髮造型必須有後層，短髮造型不需要', () {
      final AvatarAssetBundle longHair = AvatarAssetCatalog.resolve(
        AvatarConfiguration.defaultFor(AvatarPresentation.girl)
            .copyWith(hairId: 'girl_hair_06'),
      );
      expect(longHair.hairBackAsset, isNotNull,
          reason: 'girl_hair_06（雙馬尾）應該要有後層');
    });

    test('每款髮型都要從透明基準素材套用安全定位', () {
      for (final AvatarPresentation presentation in AvatarPresentation.values) {
        for (final String hair
            in AvatarConfiguration.optionsFor(presentation, 'hair')) {
          final AvatarAssetBundle bundle = AvatarAssetCatalog.resolve(
            AvatarConfiguration.defaultFor(presentation).copyWith(hairId: hair),
          );
          expect(bundle.hairFrontAsset, contains('/hair/'), reason: '$hair 必須有髮型素材');
          expect(bundle.hairScale, inInclusiveRange(.8, 1),
              reason: '$hair 不得放大而跑出頭部');
          expect(bundle.hairScaleX.abs(), inInclusiveRange(.8, 1),
              reason: '$hair 不得水平放大而遮住臉');
          expect(bundle.hairOffsetX, 0, reason: '$hair 不可偏離畫布中心');
          expect(bundle.hairOffsetY, inInclusiveRange(-.12, 0),
              reason: '$hair 只可上移至眼睛安全範圍');
        }
      }
    });

    test('第一款男生髮型以共用畫布對齊基準臉', () {
      final AvatarAssetBundle reference = AvatarAssetCatalog.resolve(
        AvatarConfiguration.defaultFor(AvatarPresentation.boy),
      );

      expect(reference.hairFrontAsset,
          'assets/avatars/boy/hair/hair-01.png');
      expect(reference.hairScale, 1);
      expect(reference.hairScaleX, 1);
      expect(reference.hairOffsetX, 0);
      expect(reference.hairOffsetY, 0);
    });
  });

  group('眼睛與眼鏡', () {
    test('眼鏡款是眼睛選項的一部分，且仍保留一般眼睛款', () {
      final List<String> options =
          AvatarConfiguration.optionsFor(AvatarPresentation.girl, 'eyes');
      expect(
          options,
          containsAll(<String>[
            'girl_eyes_01',
            'girl_eyes_06',
            'girl_eyes_07',
            'girl_eyes_08',
          ]));
      expect(
        () => AvatarConfiguration.optionsFor(
            AvatarPresentation.girl, 'accessory'),
        throwsArgumentError,
      );
    });

    testWidgets('legacy glasses values cannot add a second overlay',
        (WidgetTester tester) async {
      final AvatarConfiguration glassesEyes = girl().copyWith(
          eyesId: 'girl_eyes_06', accessoryId: 'accessory_glasses_01');
      await tester.pumpWidget(
        MaterialApp(
            home: Scaffold(body: AvatarPreview(configuration: glassesEyes))),
      );
      expect(find.byKey(const ValueKey<String>('avatar_eyes_layer')),
          findsOneWidget);
      expect(find.byKey(const ValueKey<String>('avatar_accessory_layer')),
          findsNothing);
    });
  });

  group('膚色與眼色', () {
    test('膚色要涵蓋明顯不同的色階，不能全部擠在同一個色相', () {
      final List<Color> tints = <Color>[
        for (final String skin
            in AvatarConfiguration.optionsFor(AvatarPresentation.girl, 'skin'))
          AvatarAssetCatalog.resolve(
                AvatarConfiguration.defaultFor(AvatarPresentation.girl)
                    .copyWith(skinId: skin),
              ).skinTint ??
              const Color(0x00000000),
      ];
      final List<double> lums = <double>[
        for (final Color c in tints)
          if (c.a > 0) (0.299 * c.r + 0.587 * c.g + 0.114 * c.b) * 255 * c.a,
      ];
      lums.sort();
      expect(lums.length, greaterThanOrEqualTo(4));
      expect(lums.last - lums.first, greaterThan(40),
          reason: '最淺與最深的膚色差距太小，看起來會像同一個顏色');
    });

    test('眼色不再是可選的造型維度', () {
      expect(
        () => AvatarConfiguration.optionsFor(
          AvatarPresentation.girl,
          'eyeColor',
        ),
        throwsArgumentError,
      );
    });
  });
}
