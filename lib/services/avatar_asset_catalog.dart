import 'package:flutter/material.dart';
import 'package:mathspring/models/avatar_configuration.dart';

/// Maps an avatar selection to aligned, transparent illustration layers.
///
/// Every image uses the same square canvas.  New artwork can therefore be
/// added independently without changing the widget layout code.
class AvatarAssetBundle {
  const AvatarAssetBundle({
    required this.baseAsset,
    required this.hairFrontAsset,
    this.hairBackAsset,
    this.eyesAsset,
    this.noseAsset,
    this.mouthAsset,
    this.hairScale = 1,
    this.hairScaleX = 1,
    this.hairScaleY = 1,
    this.hairOffsetX = 0,
    this.hairOffsetY = 0,
    this.eyesOffsetY = 0,
    this.eyesScaleX = 1,
    this.eyesScaleY = 1,
    this.skinTint,
    this.noseTint,
    this.hairTint,
    this.noseScale = 1,
    this.noseOffsetY = 0,
    this.mouthOffsetY = 0,
    this.mouthScaleX = 1,
  });

  final String baseAsset;

  /// 瀏海與頭頂：畫在臉之後（蓋住額頭）。
  final String hairFrontAsset;

  /// 垂在臉後面的部分（雙馬尾、長髮）：畫在臉之前，所以會被臉頰蓋住。
  /// 短髮造型沒有這一層，值為 null。
  final String? hairBackAsset;

  final String? eyesAsset;
  final String? noseAsset;
  final String? mouthAsset;
  final double hairScale;
  final double hairScaleX;
  final double hairScaleY;
  final double hairOffsetX;
  final double hairOffsetY;
  final double eyesOffsetY;
  final double eyesScaleX;
  final double eyesScaleY;
  final Color? skinTint;
  final Color? noseTint;

  /// Girls share neutral hairstyle artwork; this tint supplies the selected
  /// hair colour while keeping the image's transparent pixels and highlights.
  final Color? hairTint;
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
    this.offsetX = 0,
    this.offsetY = 0,
    this.assetOverride,
    this.tint,
  });

  final double scale;
  final double scaleX;
  final double scaleY;
  final double offsetX;
  final double offsetY;
  final String? assetOverride;
  final Color? tint;

  bool get isNeutral =>
      scale == 1 &&
      scaleX == 1 &&
      scaleY == 1 &&
      offsetX == 0 &&
      offsetY == 0 &&
      assetOverride == null &&
      tint == null;
}

class AvatarAssetCatalog {
  const AvatarAssetCatalog._();

  static const AvatarOptionTreatment _neutral = AvatarOptionTreatment();

  /// Crown lifts for the rebuilt boy hair layers.  The compact styles need a
  /// little more lift than the longer first three styles to hide the scalp.
  static const Map<String, double> _boyHairCrownLifts = <String, double>{
    'boy_hair_01': -.075,
    'boy_hair_02': -.05,
    'boy_hair_03': -.05,
    'boy_hair_04': -.075,
    'boy_hair_05': -.075,
    'boy_hair_07': -.075,
    'boy_hair_08': -.10,
    'boy_hair_09': -.09,
    'boy_hair_10': -.07,
  };

  /// Fixed display swatches and runtime tints for the shared hair colours.
  static const Map<String, Color> girlHairColors = <String, Color>{
    'girl_hair_color_01': Color(0xFF1B1B1B),
    'girl_hair_color_02': Color(0xFF3A2418),
    'girl_hair_color_03': Color(0xFF7B3F20),
    'girl_hair_color_04': Color(0xFFA97142),
    'girl_hair_color_05': Color(0xFF6F1D1B),
    'girl_hair_color_06': Color(0xFF9EA3A8),
  };

  /// Skin is never only a base swap: the nose layer receives the same tint so
  /// a deeper skin tone never carries a pale nose.
  /// 膚色色階。原本四個色票都是 0x33（20% 不透明度）的褐色系、以 srcATop
  /// 整片覆蓋，結果是既分不出深淺、又把腮紅與鼻尖高光壓平。
  ///
  /// 改用**相乘**（[BlendMode.multiply]）：相乘只會讓底圖變暗，原圖的明暗
  /// 層次因此完整保留，而色票本身用不透明色去描述「這個膚色有多深」。
  ///   01 = 底圖原色（最淺），不套色
  static const Map<String, Color> _skinTints = <String, Color>{
    'skin_02': Color(0xFFF2D9BE),
    'skin_03': Color(0xFFE0AE7C),
    'skin_04': Color(0xFFB77B49),
    'skin_05': Color(0xFF7E4B2A),
  };

  /// 有後層的髮型：值是後層圖檔（垂在臉後面的部分）。
  static const Map<String, String> _hairBackAssets = <String, String>{
    'girl_hair_06': 'assets/avatars/girl/hair/hair-06-back.png',
  };

  static String? hairBackAssetFor(String hairId) => _hairBackAssets[hairId];

  /// Original full-head layers were painted lower than the face landmarks.
  /// Scale them down and raise them within the common canvas instead of
  /// replacing their artwork; this preserves the original paper-doll style
  /// while keeping pupils visible.
  static const Map<String, AvatarOptionTreatment> _treatments =
      <String, AvatarOptionTreatment>{
    // The high updo owns the same canonical canvas as face_01.  Keep it near
    // the crown rather than shrinking it so far upward that it visibly floats.
    'girl_hair_07': AvatarOptionTreatment(scale: .9, offsetY: -.05),
    'girl_hair_10': AvatarOptionTreatment(scaleX: .9),
  };

  /// Fit records for the first three boy hairstyle samples.  Keys deliberately
  /// include both the face and hair ID: a single scale cannot fit every head
  /// outline, and this data is shared by the editor tile and main preview.
  static const Map<String, AvatarOptionTreatment> _boyHairFits =
      <String, AvatarOptionTreatment>{
    'boy_face_01|boy_hair_01': AvatarOptionTreatment(),
    'boy_face_02|boy_hair_01': AvatarOptionTreatment(),
    'boy_face_03|boy_hair_01': AvatarOptionTreatment(),
    'boy_face_04|boy_hair_01': AvatarOptionTreatment(),
    'boy_face_05|boy_hair_01': AvatarOptionTreatment(),
    'boy_face_01|boy_hair_04': AvatarOptionTreatment(),
    'boy_face_02|boy_hair_04': AvatarOptionTreatment(
      scaleX: 1.05,
      scaleY: 1.02,
      offsetX: .005,
      offsetY: .005,
    ),
    'boy_face_03|boy_hair_04': AvatarOptionTreatment(
      scale: .98,
      scaleX: 1.02,
      offsetX: -.004,
      offsetY: .01,
    ),
    'boy_face_04|boy_hair_04': AvatarOptionTreatment(
      scale: 1.02,
      scaleX: 1.06,
      offsetY: -.008,
    ),
    'boy_face_05|boy_hair_04': AvatarOptionTreatment(
      scale: 1.03,
      scaleX: 1.04,
      offsetY: -.01,
    ),
    'boy_face_01|boy_hair_08': AvatarOptionTreatment(),
    'boy_face_02|boy_hair_08': AvatarOptionTreatment(
      scale: 1.01,
      scaleX: 1.04,
      offsetY: .006,
    ),
    'boy_face_03|boy_hair_08': AvatarOptionTreatment(
      scale: .99,
      scaleX: 1.01,
      offsetY: .008,
    ),
    'boy_face_04|boy_hair_08': AvatarOptionTreatment(
      scale: 1.02,
      scaleX: 1.05,
      offsetY: -.005,
    ),
    'boy_face_05|boy_hair_08': AvatarOptionTreatment(
      scale: 1.04,
      scaleX: 1.03,
      offsetY: -.012,
    ),
  };

  /// Returns a face-aware treatment when this pair has been visually fitted.
  /// A null value means callers should use the option-level fallback.
  static AvatarOptionTreatment? hairTreatmentFor(
          String faceId, String hairId) =>
      _boyHairFits['$faceId|$hairId'];

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
    final Color? hairTint = girlHairColors[configuration.hairColorId] ??
        girlHairColors['girl_hair_color_02'];
    final AvatarOptionTreatment skin = treatmentFor(configuration.skinId);
    final AvatarOptionTreatment hair = isBoy
        ? hairTreatmentFor(configuration.faceId, configuration.hairId) ??
            treatmentFor(configuration.hairId)
        : treatmentFor(configuration.hairId);
    final AvatarOptionTreatment eyes = treatmentFor(configuration.eyesId);
    final AvatarOptionTreatment nose = treatmentFor(configuration.noseId);
    final AvatarOptionTreatment mouth = treatmentFor(configuration.mouthId);

    final String noseAsset = optionAssetFor(presentation, configuration.noseId);
    // The girl eye pair is drawn slightly toward the face center.
    const double girlEyeSpread = .92;

    return AvatarAssetBundle(
      baseAsset: optionAssetFor(presentation, configuration.faceId),
      hairFrontAsset: hair.assetOverride ??
          optionAssetFor(presentation, configuration.hairId),
      hairBackAsset: hairBackAssetFor(configuration.hairId),
      hairScale: hair.scale,
      hairScaleX: hair.scaleX,
      hairScaleY: hair.scaleY,
      hairOffsetX: hair.offsetX,
      hairOffsetY: hair.offsetY +
          (isBoy ? _boyHairCrownLifts[configuration.hairId] ?? 0 : 0),
      eyesAsset: optionAssetFor(presentation, configuration.eyesId),
      eyesScaleX: (isBoy ? 1 : girlEyeSpread) * eyes.scaleX,
      eyesScaleY: eyes.scaleY,
      skinTint: skin.tint,
      noseTint: skin.tint,
      hairTint: hairTint,
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
