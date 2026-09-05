import 'package:flutter/material.dart';
import 'package:mathspring/models/avatar_configuration.dart';
import 'package:mathspring/services/avatar_asset_catalog.dart';
import 'package:mathspring/services/avatar_catalog.dart';
import 'package:mathspring/widgets/avatar_preview.dart';

class AvatarEditor extends StatefulWidget {
  const AvatarEditor({super.key, this.initialConfiguration, this.onChanged});
  final AvatarConfiguration? initialConfiguration;
  final ValueChanged<AvatarConfiguration>? onChanged;
  @override
  State<AvatarEditor> createState() => _AvatarEditorState();
}

class _AvatarEditorState extends State<AvatarEditor> {
  int _step = 0;
  late AvatarConfiguration _configuration;
  static const List<String> _titles = <String>[
    'Choose avatar',
    'Skin tone',
    'Face shape',
    'Hairstyle',
    'Eyes / glasses',
    'Nose',
    'Mouth',
  ];
  @override
  void initState() {
    super.initState();
    _configuration = widget.initialConfiguration ??
        AvatarCatalog.defaultFor(AvatarPresentation.girl);
  }

  void _set(AvatarConfiguration value) {
    setState(() => _configuration = value);
    widget.onChanged?.call(value);
  }

  List<String> get _options {
    switch (_step) {
      case 1:
        return AvatarCatalog.skinOptionsFor(_configuration.presentation);
      case 2:
        return AvatarCatalog.faceOptionsFor(_configuration.presentation);
      case 3:
        return AvatarCatalog.hairOptionsFor(_configuration.presentation);
      case 4:
        return AvatarCatalog.eyeOptionsFor(_configuration.presentation);
      case 5:
        return AvatarCatalog.noseOptionsFor(_configuration.presentation);
      default:
        return AvatarCatalog.mouthOptionsFor(_configuration.presentation);
    }
  }

  String _selected() {
    switch (_step) {
      case 1:
        return _configuration.skinId;
      case 2:
        return _configuration.faceId;
      case 3:
        return _configuration.hairId;
      case 4:
        return _configuration.eyesId;
      case 5:
        return _configuration.noseId;
      default:
        return _configuration.mouthId;
    }
  }

  int get _gridColumnCount {
    switch (_step) {
      case 4:
        return 4;
      case 5:
      case 6:
        return 5;
      default:
        return 3;
    }
  }

  void _choose(String id) {
    switch (_step) {
      case 1:
        _set(_configuration.copyWith(skinId: id));
        break;
      case 2:
        _set(_configuration.copyWith(faceId: id));
        break;
      case 3:
        _set(_configuration.copyWith(hairId: id));
        break;
      case 4:
        _set(_configuration.copyWith(eyesId: id));
        break;
      case 5:
        _set(_configuration.copyWith(noseId: id));
        break;
      default:
        _set(_configuration.copyWith(mouthId: id));
    }
  }

  @override
  Widget build(BuildContext context) => SizedBox(
      width: 320,
      child: Column(children: [
        AvatarPreview(configuration: _configuration, size: 170),
        const SizedBox(height: 12),
        Text(_titles[_step], style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        if (_step == 0)
          Wrap(
              spacing: 10,
              children: AvatarPresentation.values
                  .map((p) => ChoiceChip(
                      key: ValueKey<String>('avatar_presentation_${p.name}'),
                      label: Text(p == AvatarPresentation.boy ? 'Boy' : 'Girl'),
                      selected: _configuration.presentation == p,
                      onSelected: (_) => _set(AvatarCatalog.defaultFor(p))))
                  .toList())
        else
          GridView.count(
            crossAxisCount: _gridColumnCount,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1,
            children: _options.map(_optionTile).toList(),
          ),
        const SizedBox(height: 12),
        Row(mainAxisSize: MainAxisSize.min, children: [
          SizedBox(
              width: 88,
              child: TextButton(
                  onPressed: _step == 0 ? null : () => setState(() => _step--),
                  child: const Text('Back'))),
          const SizedBox(width: 80),
          SizedBox(
              width: 88,
              child: FilledButton(
                  key: const ValueKey<String>('avatar_next_button'),
                  onPressed: _step == _titles.length - 1
                      ? null
                      : () => setState(() => _step++),
                  child: const Text('Next')))
        ]),
      ]));

  Widget _optionTile(String id) {
    final bool selected = _selected() == id;
    final bool isMouth = id.contains('_mouth_');
    final Color accent = Theme.of(context).colorScheme.primary;
    return Semantics(
      label: id.replaceAll('_', ' '),
      selected: selected,
      button: true,
      child: InkWell(
        key: ValueKey<String>('avatar_option_$id'),
        borderRadius: BorderRadius.circular(12),
        onTap: () => _choose(id),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: selected ? accent : Colors.transparent, width: 2),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(4),
                child: _optionTreatment(
                  id,
                  Transform.scale(
                    key: ValueKey<String>('avatar_option_image_$id'),
                    scale: isMouth ? 3 : 1,
                    child: Image.asset(
                      AvatarAssetCatalog.optionAssetFor(
                          _configuration.presentation, id),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              if (selected)
                Align(
                  alignment: Alignment.topRight,
                  child: DecoratedBox(
                    decoration:
                        BoxDecoration(color: accent, shape: BoxShape.circle),
                    child: const Padding(
                      padding: EdgeInsets.all(3),
                      child: Icon(Icons.check, color: Colors.white, size: 14),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _optionTreatment(String id, Widget child) {
    final AvatarOptionTreatment treatment = AvatarAssetCatalog.treatmentFor(id);
    if (treatment.isNeutral) {
      return child;
    }

    final Key key = ValueKey<String>('avatar_option_treatment_$id');
    if (treatment.tint case final Color tint) {
      return ColorFiltered(
        key: key,
        colorFilter: ColorFilter.mode(tint, BlendMode.srcATop),
        child: child,
      );
    }
    return Transform.scale(
      key: key,
      scaleX: treatment.scale * treatment.scaleX,
      scaleY: treatment.scale * treatment.scaleY,
      child: child,
    );
  }
}
