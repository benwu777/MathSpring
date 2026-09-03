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
    this.faceScaleY = 1,
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
  final double faceScaleY;
  final Color? skinTint;
  final Color? noseTint;
  final double noseScale;
  final double noseOffsetY;
  final double mouthOffsetY;
  final double mouthScaleX;
}

/// The part-limited visual change that turns one shared layer into a distinct
/// option.  Options backed by their own artwork keep the neutral treatment.
class AvatarOptionTreatment {
  const AvatarOptionTreatment({
    this.scale = 1,
    this.scaleX = 1,
    this.scaleY = 1,
    this.offsetY = 0,
    this.tint,
  });

  final double scale;
  final double scaleX;
  final double scaleY;
  final double offsetY;
  final Color? tint;

  bool get isNeutral =>
      scale == 1 && scaleX == 1 && scaleY == 1 && offsetY == 0 && tint == null;
}

class AvatarAssetCatalog {
  const AvatarAssetCatalog._();

  static const AvatarOptionTreatment _neutral = AvatarOptionTreatment();

  /// Options without dedicated artwork reuse an aligned layer from the same
  /// part.  The value is the path below `assets/avatars/`.
  static const Map<String, String> _sharedLayerSource = <String, String>{
    'girl_eyes_03': 'girl/eyes/eyes-01.png',
    'girl_eyes_04': 'girl/eyes/eyes-02.png',
    'girl_eyes_05': 'girl/eyes/eyes-01.png',
    'girl_nose_03': 'girl/nose/nose-01.png',
    'girl_nose_04': 'girl/nose/nose-02.png',
    'girl_nose_05': 'girl/nose/nose-01.png',
    'boy_hair_03': 'boy/hair/hair-01.png',
    'boy_hair_04': 'boy/hair/hair-02.png',
    'boy_hair_05': 'boy/hair/hair-01.png',
    'boy_eyes_02': 'boy/eyes/eyes-01.png',
    'boy_eyes_03': 'boy/eyes/eyes-01.png',
    'boy_eyes_04': 'boy/eyes/eyes-01.png',
    'boy_eyes_05': 'boy/eyes/eyes-01.png',
    'boy_nose_03': 'boy/nose/nose-01.png',
    'boy_nose_04': 'boy/nose/nose-02.png',
    'boy_nose_05': 'boy/nose/nose-01.png',
    'boy_mouth_03': 'boy/mouth/mouth-01.png',
    'boy_mouth_04': 'boy/mouth/mouth-01.png',
    'boy_mouth_05': 'boy/mouth/mouth-02.png',
  };

  /// Skin is never only a base swap: the nose layer receives the same tint so
  /// a deeper skin tone never carries a pale nose.
  static const Map<String, Color> _skinTints = <String, Color>{
    'skin_02': Color(0x33703A20),
    'skin_03': Color(0x33974F2C),
    'skin_04': Color(0x33D9925B),
    'skin_05': Color(0x33472616),
  };

  static const Map<String, AvatarOptionTreatment> _treatments =
      <String, AvatarOptionTreatment>{
    // Face keeps a shared vertical geometry so the eyes, nose, and mouth stay
    // registered; only the width changes.
    'girl_face_02': AvatarOptionTreatment(scaleX: .94),
    'girl_face_03': AvatarOptionTreatment(scaleX: 1.06),
    'girl_face_04': AvatarOptionTreatment(scaleX: .88),
    // A rounder face is shortened rather than widened: past 1.1x the cheeks
    // reach outside the hairline.
    'girl_face_05': AvatarOptionTreatment(scaleY: .94),
    'boy_face_02': AvatarOptionTreatment(scaleX: .94),
    'boy_face_03': AvatarOptionTreatment(scaleX: 1.06),
    'boy_face_04': AvatarOptionTreatment(scaleX: .88),
    'boy_face_05': AvatarOptionTreatment(scaleY: .94),
    // Mirrored partings keep the fringe line, so no eye is newly covered.
    'boy_hair_03': AvatarOptionTreatment(scaleX: -1),
    'boy_hair_04': AvatarOptionTreatment(scaleX: -1),
    // A cropped cut: the same parting drawn smaller so the ears show and the
    // fringe sits higher.  Lowered by the amount the layer shrinks upward.
    'boy_hair_05': AvatarOptionTreatment(scale: .92, offsetY: .02),
    'girl_eyes_03': AvatarOptionTreatment(scaleY: .86),
    'girl_eyes_04': AvatarOptionTreatment(scaleY: .86),
    'girl_eyes_05': AvatarOptionTreatment(scaleY: 1.14),
    'boy_eyes_02': AvatarOptionTreatment(scaleY: 1.13),
    'boy_eyes_03': AvatarOptionTreatment(scaleX: .88),
    'boy_eyes_04': AvatarOptionTreatment(scaleY: .87),
    'boy_eyes_05': AvatarOptionTreatment(scaleX: .88, scaleY: 1.15),
    'girl_nose_03': AvatarOptionTreatment(scale: 1.16),
    'girl_nose_04': AvatarOptionTreatment(scale: 1.16),
    'girl_nose_05': AvatarOptionTreatment(scale: .86),
    'boy_nose_03': AvatarOptionTreatment(scale: 1.18),
    'boy_nose_04': AvatarOptionTreatment(scale: 1.18),
    'boy_nose_05': AvatarOptionTreatment(scale: .88),
    // The smile width stays at or below the natural smile layer.
    'boy_mouth_03': AvatarOptionTreatment(scaleX: 1.22),
    'boy_mouth_04': AvatarOptionTreatment(scaleX: .82),
    'boy_mouth_05': AvatarOptionTreatment(scaleX: 1.18),
  };

  static AvatarOptionTreatment treatmentFor(String optionId) {
    if (optionId.contains('_skin_')) {
      final Color? tint = _skinTints[optionId.substring(optionId.length - 7)];
      return tint == null ? _neutral : AvatarOptionTreatment(tint: tint);
    }
    return _treatments[optionId] ?? _neutral;
  }

  static String optionAssetFor(
    AvatarPresentation presentation,
    String optionId,
  ) {
    final String prefix =
        presentation == AvatarPresentation.boy ? 'boy' : 'girl';
    final List<String> parts = optionId.split('_');
    final String category = parts[1];
    final String index = parts.last;

    final String? shared = _sharedLayerSource[optionId];
    if (shared != null) {
      return 'assets/avatars/$shared';
    }

    switch (category) {
      case 'hair':
      case 'eyes':
      case 'nose':
      case 'mouth':
        return 'assets/avatars/$prefix/$category/$category-$index.png';
      case 'skin':
      case 'face':
        return _baseAssetFor(presentation);
      default:
        throw ArgumentError.value(
            optionId, 'optionId', 'Unknown avatar option');
    }
  }

  static String _baseAssetFor(AvatarPresentation presentation) =>
      presentation == AvatarPresentation.boy
          ? 'assets/avatars/boy/base/base-01.png'
          : 'assets/avatars/girl/base/face-01.png';

  static AvatarAssetBundle resolve(AvatarConfiguration configuration) {
    final AvatarPresentation presentation = configuration.presentation;
    final bool isBoy = presentation == AvatarPresentation.boy;
    final AvatarOptionTreatment skin = treatmentFor(configuration.skinId);
    final AvatarOptionTreatment face = treatmentFor(configuration.faceId);
    final AvatarOptionTreatment hair = treatmentFor(configuration.hairId);
    final AvatarOptionTreatment eyes = treatmentFor(configuration.eyesId);
    final AvatarOptionTreatment nose = treatmentFor(configuration.noseId);
    final AvatarOptionTreatment mouth = treatmentFor(configuration.mouthId);

    final String noseAsset = optionAssetFor(presentation, configuration.noseId);
    // The girl eye pair is drawn slightly toward the face center.
    const double girlEyeSpread = .92;

    return AvatarAssetBundle(
      baseAsset: _baseAssetFor(presentation),
      hairAsset: optionAssetFor(presentation, configuration.hairId),
      hairScale: hair.scale,
      hairScaleX: hair.scaleX,
      // The boy source artwork's canvas sits lower than the face canvas, so
      // every boy hairstyle is lifted to keep the fringe above both eyes.
      hairOffsetY: (isBoy ? -.1 : 0) + hair.offsetY,
      eyesAsset: optionAssetFor(presentation, configuration.eyesId),
      eyesScaleX: (isBoy ? 1 : girlEyeSpread) * eyes.scaleX,
      eyesScaleY: eyes.scaleY,
      faceScaleX: face.scaleX,
      faceScaleY: face.scaleY,
      skinTint: skin.tint,
      noseTint: skin.tint,
      noseAsset: noseAsset,
      noseScale: nose.scale,
      noseOffsetY: isBoy ? .092 : .1,
      mouthAsset: optionAssetFor(presentation, configuration.mouthId),
      mouthScaleX: mouth.scaleX,
      // The small boy nose leaves a gap above the mouth; move the mouth down
      // just enough to close it.
      mouthOffsetY: isBoy
          ? (noseAsset == 'assets/avatars/boy/nose/nose-02.png' ? .20 : .168)
          : .08,
    );
  }
}
