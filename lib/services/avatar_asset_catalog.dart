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
  /// Only hair still shares a layer: the two accepted boy partings are also
  /// used mirrored.  Every other part ships one layer per option.
  static const Map<String, String> _sharedLayerSource = <String, String>{
    'boy_hair_03': 'boy/hair/hair-01.png',
    'boy_hair_04': 'boy/hair/hair-02.png',
    'boy_hair_05': 'boy/hair/hair-01.png',
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
    // Mirrored partings keep the fringe line, so no eye is newly covered.
    'boy_hair_03': AvatarOptionTreatment(scaleX: -1),
    'boy_hair_04': AvatarOptionTreatment(scaleX: -1),
    // A cropped cut: the same parting drawn smaller so the ears show and the
    // fringe sits higher.  Lowered by the amount the layer shrinks upward.
    'boy_hair_05': AvatarOptionTreatment(scale: .92, offsetY: .02),
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
      case 'face':
        return presentation == AvatarPresentation.boy
            ? 'assets/avatars/boy/base/base-$index.png'
            : 'assets/avatars/girl/base/face-$index.png';
      case 'skin':
        // Skin tints the face layer the learner already picked, so its own
        // thumbnail shows the default face.
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
    final AvatarOptionTreatment hair = treatmentFor(configuration.hairId);
    final AvatarOptionTreatment eyes = treatmentFor(configuration.eyesId);
    final AvatarOptionTreatment nose = treatmentFor(configuration.noseId);
    final AvatarOptionTreatment mouth = treatmentFor(configuration.mouthId);

    final String noseAsset = optionAssetFor(presentation, configuration.noseId);
    // The girl eye pair is drawn slightly toward the face center.
    const double girlEyeSpread = .92;

    return AvatarAssetBundle(
      baseAsset: optionAssetFor(presentation, configuration.faceId),
      hairAsset: optionAssetFor(presentation, configuration.hairId),
      hairScale: hair.scale,
      hairScaleX: hair.scaleX,
      // The boy source artwork's canvas sits lower than the face canvas, so
      // every boy hairstyle is lifted to keep the fringe above both eyes.
      hairOffsetY: (isBoy ? -.1 : 0) + hair.offsetY,
      eyesAsset: optionAssetFor(presentation, configuration.eyesId),
      eyesScaleX: (isBoy ? 1 : girlEyeSpread) * eyes.scaleX,
      eyesScaleY: eyes.scaleY,
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
