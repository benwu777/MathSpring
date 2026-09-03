import 'package:flutter/material.dart';
import 'package:mathspring/models/avatar_configuration.dart';
import 'package:mathspring/services/avatar_asset_catalog.dart';

/// Renders production illustration layers rather than procedural geometry.
class AvatarPreview extends StatelessWidget {
  const AvatarPreview(
      {super.key, required this.configuration, this.size = 180});

  final AvatarConfiguration configuration;
  final double size;

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
              Transform.scale(
                scaleX: assets.faceScaleX,
                child: assets.skinTint == null
                    ? _layer(assets.baseAsset)
                    : ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          assets.skinTint!,
                          BlendMode.srcATop,
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
                            BlendMode.srcATop,
                          ),
                          child: _layer(path, offsetY: assets.noseOffsetY),
                        ),
                ),
              if (assets.mouthAsset case final String path)
                Transform.scale(
                  scaleX: assets.mouthScaleX,
                  child: _layer(path, offsetY: assets.mouthOffsetY),
                ),
              _hairLayer(assets),
            ],
          ),
        ),
      ),
    );
  }

  Widget _layer(String asset, {double offsetY = 0}) => FractionalTranslation(
        translation: Offset(0, offsetY),
        child: Image.asset(asset, fit: BoxFit.contain),
      );

  Widget _hairLayer(AvatarAssetBundle assets) => FractionalTranslation(
        translation: Offset(assets.hairOffsetX, assets.hairOffsetY),
        child: Transform.scale(
          scaleX: assets.hairScale * assets.hairScaleX,
          scaleY: assets.hairScale,
          alignment: Alignment.topCenter,
          child: _layer(assets.hairAsset),
        ),
      );
}
