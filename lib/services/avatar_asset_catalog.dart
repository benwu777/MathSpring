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
    this.accessoryAsset,
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

  /// 瀏海與頭頂：畫在臉之後（蓋住額頭）。
  final String hairFrontAsset;

  /// 垂在臉後面的部分（雙馬尾、長髮）：畫在臉之前，所以會被臉頰蓋住。
  /// 短髮造型沒有這一層，值為 null。
  final String? hairBackAsset;

  /// 眼鏡或墨鏡。不戴時為 null。
  final String? accessoryAsset;

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

  /// 配件圖層。`accessory_none` 不在表內，解析結果為 null。
  static const Map<String, String> _accessoryAssets = <String, String>{
    'accessory_glasses_01': 'assets/avatars/shared/accessory/glasses-round.png',
    'accessory_glasses_02':
        'assets/avatars/shared/accessory/glasses-square.png',
    'accessory_sunglasses_01': 'assets/avatars/shared/accessory/sunglasses.png',
  };

  /// 有後層的髮型：值是後層圖檔（垂在臉後面的部分）。
  static const Map<String, String> _hairBackAssets = <String, String>{
    'girl_hair_06': 'assets/avatars/girl/hair/hair-06-back.png',
  };

  static String? accessoryAssetFor(String accessoryId) =>
      _accessoryAssets[accessoryId];

  static String? hairBackAssetFor(String hairId) => _hairBackAssets[hairId];

  static const Map<String, AvatarOptionTreatment> _treatments =
      <String, AvatarOptionTreatment>{
    // Mirrored partings keep the fringe line, so no eye is newly covered.
    'boy_hair_03': AvatarOptionTreatment(scaleX: -1),
    'boy_hair_04': AvatarOptionTreatment(scaleX: -1),
    // A cropped cut: the same parting drawn smaller so the ears show and the
    // fringe sits higher.  Lowered by the amount the layer shrinks upward.
    'boy_hair_05': AvatarOptionTreatment(scale: .92, offsetY: .02),
  };

  /// These source layers predate the aligned generated artwork and sit lower
  /// in their canvases, so only they need the legacy upward correction.
  static const Set<String> _legacyBoyHair = <String>{
    'boy_hair_01',
    'boy_hair_02',
    'boy_hair_03',
    'boy_hair_04',
    'boy_hair_05',
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

    // 配件不是「一個選項一張圖」的部位；不戴時縮圖借用既有眼睛。
    if (optionId.startsWith('accessory_')) {
      return _accessoryAssets[optionId] ??
          'assets/avatars/$prefix/eyes/eyes-01.png';
    }

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
      hairFrontAsset: optionAssetFor(presentation, configuration.hairId),
      hairBackAsset: hairBackAssetFor(configuration.hairId),
      accessoryAsset: accessoryAssetFor(configuration.accessoryId),
      hairScale: hair.scale,
      hairScaleX: hair.scaleX,
      // The original boy layers sit lower than the face canvas. New hair
      // artwork is already aligned, so it must not inherit that correction.
      hairOffsetY:
          (isBoy && _legacyBoyHair.contains(configuration.hairId) ? -.1 : 0) +
              hair.offsetY,
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
