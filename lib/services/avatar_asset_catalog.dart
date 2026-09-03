import 'package:flutter/material.dart';
import 'package:mathspring/models/avatar_configuration.dart';

/// Maps an avatar selection to aligned, transparent illustration layers.
///
/// Every image uses the same square canvas.  New artwork can therefore be
/// added independently without changing the widget layout code.
class AvatarAssetBundle {
  const AvatarAssetBundle({
    required this.baseAsset,
    required this.hairAsset,
    this.eyesAsset,
    this.noseAsset,
    this.mouthAsset,
    this.hairScale = 1,
    this.hairScaleX = 1,
    this.hairOffsetX = 0,
    this.hairOffsetY = 0,
    this.eyesOffsetY = 0,
    this.eyesScaleX = 1,
    this.eyesScaleY = 1,
    this.faceScaleX = 1,
    this.skinTint,
    this.noseTint,
    this.noseScale = 1,
    this.noseOffsetY = 0,
    this.mouthOffsetY = 0,
    this.mouthScaleX = 1,
  });

  final String baseAsset;
  final String hairAsset;
  final String? eyesAsset;
  final String? noseAsset;
  final String? mouthAsset;
  final double hairScale;
  final double hairScaleX;
  final double hairOffsetX;
  final double hairOffsetY;
  final double eyesOffsetY;
  final double eyesScaleX;
  final double eyesScaleY;
  final double faceScaleX;
  final Color? skinTint;
  final Color? noseTint;
  final double noseScale;
  final double noseOffsetY;
  final double mouthOffsetY;
  final double mouthScaleX;
}

class AvatarAssetCatalog {
  const AvatarAssetCatalog._();

  static String optionAssetFor(
    AvatarPresentation presentation,
    String optionId,
  ) {
    final String prefix =
        presentation == AvatarPresentation.boy ? 'boy' : 'girl';
    final List<String> parts = optionId.split('_');
    final String category = parts[1];
    final String index = parts.last.split('-').last;

    switch (category) {
      case 'hair':
        if (presentation == AvatarPresentation.boy &&
            optionId == 'boy_hair_03') {
          return 'assets/avatars/boy/hair/hair-01.png';
        }
        return 'assets/avatars/$prefix/hair/hair-$index.png';
      case 'eyes':
        if (optionId.endsWith('_eyes_03') ||
            (presentation == AvatarPresentation.boy &&
                optionId == 'boy_eyes_02')) {
          return 'assets/avatars/$prefix/eyes/eyes-01.png';
        }
        return 'assets/avatars/$prefix/eyes/eyes-$index.png';
      case 'nose':
        if (optionId.endsWith('_nose_03')) {
          return 'assets/avatars/$prefix/nose/nose-01.png';
        }
        return 'assets/avatars/$prefix/nose/nose-$index.png';
      case 'mouth':
        if (presentation == AvatarPresentation.boy &&
            optionId == 'boy_mouth_03') {
          return 'assets/avatars/boy/mouth/mouth-01.png';
        }
        return 'assets/avatars/$prefix/mouth/mouth-$index.png';
      case 'skin':
      case 'face':
        return presentation == AvatarPresentation.boy
            ? 'assets/avatars/boy/base/base-01.png'
            : 'assets/avatars/girl/base/face-01.png';
      default:
        throw ArgumentError.value(
            optionId, 'optionId', 'Unknown avatar option');
    }
  }

  static AvatarAssetBundle resolve(AvatarConfiguration configuration) {
    if (configuration.presentation == AvatarPresentation.boy) {
      return AvatarAssetBundle(
        baseAsset: 'assets/avatars/boy/base/base-01.png',
        hairAsset: configuration.hairId == 'boy_hair_02'
            ? 'assets/avatars/boy/hair/hair-02.png'
            : 'assets/avatars/boy/hair/hair-01.png',
        hairScaleX: configuration.hairId == 'boy_hair_03' ? -1 : 1,
        eyesAsset: 'assets/avatars/boy/eyes/eyes-01.png',
        eyesScaleX: configuration.eyesId == 'boy_eyes_03' ? .88 : 1,
        eyesScaleY: configuration.eyesId == 'boy_eyes_02' ? 1.13 : 1,
        faceScaleX: switch (configuration.faceId) {
          'boy_face_02' => .94,
          'boy_face_03' => 1.06,
          _ => 1,
        },
        skinTint: switch (configuration.skinId) {
          'boy_skin_02' => const Color(0x33703A20),
          'boy_skin_03' => const Color(0x33974F2C),
          _ => null,
        },
        noseTint: switch (configuration.skinId) {
          'boy_skin_02' => const Color(0x33703A20),
          'boy_skin_03' => const Color(0x33974F2C),
          _ => null,
        },
        noseAsset: configuration.noseId == 'boy_nose_02'
            ? 'assets/avatars/boy/nose/nose-02.png'
            : 'assets/avatars/boy/nose/nose-01.png',
        noseScale: configuration.noseId == 'boy_nose_03' ? 1.18 : 1,
        mouthAsset: configuration.mouthId == 'boy_mouth_02'
            ? 'assets/avatars/boy/mouth/mouth-02.png'
            : 'assets/avatars/boy/mouth/mouth-01.png',
        mouthScaleX: configuration.mouthId == 'boy_mouth_03' ? 1.22 : 1,
        // The source artwork's canvas is lower than the face canvas. Move it
        // up by 10% so the fringe stays above both eyes at every preview size.
        hairOffsetY: -.1,
        noseOffsetY: .092,
        mouthOffsetY: configuration.noseId == 'boy_nose_02' ? .20 : .168,
      );
    }

    return AvatarAssetBundle(
      baseAsset: 'assets/avatars/girl/base/face-01.png',
      hairAsset: switch (configuration.hairId) {
        'girl_hair_03' => 'assets/avatars/girl/hair/hair-03.png',
        'girl_hair_04' => 'assets/avatars/girl/hair/hair-04.png',
        'girl_hair_05' => 'assets/avatars/girl/hair/hair-05.png',
        _ => 'assets/avatars/girl/hair/hair-01.png',
      },
      eyesAsset: configuration.eyesId == 'girl_eyes_02'
          ? 'assets/avatars/girl/eyes/eyes-02.png'
          : 'assets/avatars/girl/eyes/eyes-01.png',
      eyesScaleX: .92,
      eyesScaleY: configuration.eyesId == 'girl_eyes_03' ? .86 : 1,
      faceScaleX: switch (configuration.faceId) {
        'girl_face_02' => .94,
        'girl_face_03' => 1.06,
        _ => 1,
      },
      skinTint: switch (configuration.skinId) {
        'girl_skin_02' => const Color(0x33703A20),
        'girl_skin_03' => const Color(0x33974F2C),
        _ => null,
      },
      noseTint: switch (configuration.skinId) {
        'girl_skin_02' => const Color(0x33703A20),
        'girl_skin_03' => const Color(0x33974F2C),
        _ => null,
      },
      noseAsset: configuration.noseId == 'girl_nose_02'
          ? 'assets/avatars/girl/nose/nose-02.png'
          : 'assets/avatars/girl/nose/nose-01.png',
      noseScale: configuration.noseId == 'girl_nose_03' ? 1.16 : 1,
      mouthAsset: switch (configuration.mouthId) {
        'girl_mouth_02' => 'assets/avatars/girl/mouth/mouth-02.png',
        'girl_mouth_03' => 'assets/avatars/girl/mouth/mouth-03.png',
        'girl_mouth_04' => 'assets/avatars/girl/mouth/mouth-04.png',
        'girl_mouth_05' => 'assets/avatars/girl/mouth/mouth-05.png',
        'girl_mouth_06' => 'assets/avatars/girl/mouth/mouth-06.png',
        'girl_mouth_07' => 'assets/avatars/girl/mouth/mouth-07.png',
        _ => 'assets/avatars/girl/mouth/mouth-01.png',
      },
      noseOffsetY: .1,
      mouthOffsetY: .08,
    );
  }
}
