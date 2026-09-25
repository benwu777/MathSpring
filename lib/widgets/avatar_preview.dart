import 'package:flutter/material.dart';
import 'package:mathspring/models/avatar_configuration.dart';
import 'package:mathspring/services/avatar_asset_catalog.dart';

/// Renders production illustration layers rather than procedural geometry.
class AvatarPreview extends StatelessWidget {
  const AvatarPreview({
    super.key,
    required this.configuration,
    this.size = 180,
    this.assetPackage,
  });

  final AvatarConfiguration configuration;
  final double size;
  final String? assetPackage;

  @override
  Widget build(BuildContext context) {
    final String presentation =
        configuration.presentation == AvatarPresentation.boy ? 'Boy' : 'Girl';
    final AvatarAssetBundle assets = AvatarAssetCatalog.resolve(configuration);
    return Semantics(
      label: '$presentation avatar: ${configuration.hairId}',
      child: SizedBox(
        key: const ValueKey<String>('avatar_preview'),
        width: size,
        height: size,
        child: ClipRect(
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              // 垂在臉後面的頭髮（雙馬尾、長髮）必須先畫，才會被臉頰蓋住。
              if (assets.hairBackAsset case final String path)
                KeyedSubtree(
                  key: const ValueKey<String>('avatar_hair_back_layer'),
                  child: _hairLayer(assets, path, isBack: true),
                ),
              KeyedSubtree(
                key: const ValueKey<String>('avatar_face_layer'),
                child: assets.skinTint == null
                    ? _layer(assets.baseAsset)
                    : ColorFiltered(
                        // Modulate 保留底圖的明暗與腮紅，同時不會把不透明
                        // 色票合成到透明畫布，避免膚色染到背景。
                        colorFilter: ColorFilter.mode(
                          assets.skinTint!,
                          BlendMode.modulate,
                        ),
                        child: _layer(assets.baseAsset),
                      ),
              ),
              if (assets.eyesAsset case final String path)
                Transform.scale(
                  key: const ValueKey<String>('avatar_eyes_layer'),
                  scaleX: assets.eyesScaleX,
                  scaleY: assets.eyesScaleY,
                  child: _layer(path, offsetY: assets.eyesOffsetY),
                ),
              if (assets.noseAsset case final String path)
                Transform.scale(
                  scale: assets.noseScale,
                  child: assets.noseTint == null
                      ? _layer(path, offsetY: assets.noseOffsetY)
                      : ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            assets.noseTint!,
                            BlendMode.modulate,
                          ),
                          child: _layer(path, offsetY: assets.noseOffsetY),
                        ),
                ),
              if (assets.mouthAsset case final String path)
                Transform.scale(
                  scaleX: assets.mouthScaleX,
                  child: _layer(path, offsetY: assets.mouthOffsetY),
                ),
              KeyedSubtree(
                key: const ValueKey<String>('avatar_hair_front_layer'),
                child: _hairLayer(assets, assets.hairFrontAsset),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _layer(String asset, {double offsetY = 0}) => FractionalTranslation(
        translation: Offset(0, offsetY),
        child: Image.asset(
          asset,
          package: assetPackage,
          fit: BoxFit.contain,
        ),
      );

  Widget _hairLayer(
    AvatarAssetBundle assets,
    String asset, {
    bool isBack = false,
  }) {
    final Widget layer = FractionalTranslation(
      translation: Offset(assets.hairOffsetX, assets.hairOffsetY),
      child: Transform.scale(
        scaleX: assets.hairScale * assets.hairScaleX,
        scaleY: assets.hairScale,
        alignment: Alignment.topCenter,
        child: _layer(asset),
      ),
    );
    final Color? hairTint = assets.hairTint;
    if (hairTint == null) {
      return layer;
    }
    return ColorFiltered(
      key: ValueKey<String>(
        isBack ? 'avatar_hair_back_tint' : 'avatar_hair_front_tint',
      ),
      // The matrix only transforms RGB; its alpha row passes source alpha
      // through unchanged, preserving transparent canvas pixels and strands.
      colorFilter: _hairTintFilter(hairTint),
      child: layer,
    );
  }

  ColorFilter _hairTintFilter(Color tint) {
    // Rebuild RGB from the original luminance.  Multiplying the original
    // brown channels only darkens/lightens brown, while this preserves strand
    // shading yet gives every swatch its own visible hue.  Alpha passes
    // through unchanged.
    const double redLuma = .2126;
    const double greenLuma = .7152;
    const double blueLuma = .0722;
    List<double> channel(double target) => <double>[
          redLuma * target,
          greenLuma * target,
          blueLuma * target,
          0,
          0,
        ];
    return ColorFilter.matrix(<double>[
      ...channel(tint.r),
      ...channel(tint.g),
      ...channel(tint.b),
      0,
      0,
      0,
      1,
      0,
    ]);
  }
}
