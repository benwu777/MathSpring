import 'package:flutter/material.dart';
import 'package:mathspring/models/avatar_configuration.dart';
import 'package:mathspring/services/avatar_asset_catalog.dart';
import 'package:mathspring/services/avatar_catalog.dart';
import 'package:mathspring/widgets/avatar_preview.dart';

enum AvatarSectionSelectorLayout { scrollable, wrap }

enum _AvatarEditorSection {
  presentation,
  skin,
  face,
  hair,
  hairColor,
  eyes,
  nose,
  mouth,
}

class AvatarEditor extends StatefulWidget {
  const AvatarEditor({
    super.key,
    this.initialConfiguration,
    this.onChanged,
    this.assetPackage,
    this.sectionSelectorLayout = AvatarSectionSelectorLayout.scrollable,
    this.showOptionIds = false,
    this.hasFullUnlock = true,
    this.onLockedOptionSelected,
  });
  final AvatarConfiguration? initialConfiguration;
  final ValueChanged<AvatarConfiguration>? onChanged;
  final String? assetPackage;
  final AvatarSectionSelectorLayout sectionSelectorLayout;

  /// Used by the reviewer tool so artwork can be identified unambiguously.
  final bool showOptionIds;

  /// Existing choices always remain visible; only choosing a new non-basic
  /// option requires the full unlock.
  final bool hasFullUnlock;
  final ValueChanged<String>? onLockedOptionSelected;
  @override
  State<AvatarEditor> createState() => _AvatarEditorState();
}

class _AvatarEditorState extends State<AvatarEditor> {
  int _step = 0;
  late AvatarConfiguration _configuration;
  @override
  void initState() {
    super.initState();
    _configuration = widget.initialConfiguration ??
        AvatarCatalog.defaultFor(AvatarPresentation.girl);
  }

  void _set(AvatarConfiguration value) {
    if (value.hairColorId != _configuration.hairColorId) {
      debugPrint('[hair-color] state ${_configuration.hairColorId} -> '
          '${value.hairColorId}');
    }
    setState(() => _configuration = value);
    widget.onChanged?.call(value);
  }

  List<_AvatarEditorSection> get _sections => <_AvatarEditorSection>[
        _AvatarEditorSection.presentation,
        _AvatarEditorSection.skin,
        _AvatarEditorSection.face,
        _AvatarEditorSection.hair,
        _AvatarEditorSection.hairColor,
        _AvatarEditorSection.eyes,
        _AvatarEditorSection.nose,
        _AvatarEditorSection.mouth,
      ];

  _AvatarEditorSection get _section => _sections[_step];

  List<String> get _options {
    switch (_section) {
      case _AvatarEditorSection.skin:
        return AvatarCatalog.skinOptionsFor(_configuration.presentation);
      case _AvatarEditorSection.face:
        return AvatarCatalog.faceOptionsFor(_configuration.presentation);
      case _AvatarEditorSection.hair:
        return AvatarCatalog.hairOptionsFor(_configuration.presentation);
      case _AvatarEditorSection.hairColor:
        return AvatarConfiguration.optionsFor(
          _configuration.presentation,
          'hair_color',
        );
      case _AvatarEditorSection.eyes:
        return AvatarCatalog.eyeOptionsFor(_configuration.presentation);
      case _AvatarEditorSection.nose:
        return AvatarCatalog.noseOptionsFor(_configuration.presentation);
      case _AvatarEditorSection.mouth:
        return AvatarCatalog.mouthOptionsFor(_configuration.presentation);
      default:
        throw StateError('Unexpected avatar editor section: $_section');
    }
  }

  String _selected() {
    switch (_section) {
      case _AvatarEditorSection.skin:
        return _configuration.skinId;
      case _AvatarEditorSection.face:
        return _configuration.faceId;
      case _AvatarEditorSection.hair:
        return _configuration.hairId;
      case _AvatarEditorSection.hairColor:
        return _configuration.hairColorId;
      case _AvatarEditorSection.eyes:
        return _configuration.eyesId;
      case _AvatarEditorSection.nose:
        return _configuration.noseId;
      case _AvatarEditorSection.mouth:
        return _configuration.mouthId;
      default:
        throw StateError('Unexpected avatar editor section: $_section');
    }
  }

  int get _gridColumnCount {
    switch (_section) {
      case _AvatarEditorSection.eyes:
        return 4;
      case _AvatarEditorSection.nose:
      case _AvatarEditorSection.mouth:
        return 5;
      default:
        return 3;
    }
  }

  void _choose(String id) {
    switch (_section) {
      case _AvatarEditorSection.skin:
        _set(_configuration.copyWith(skinId: id));
        break;
      case _AvatarEditorSection.face:
        _set(_configuration.copyWith(faceId: id));
        break;
      case _AvatarEditorSection.hair:
        _set(_configuration.copyWith(hairId: id));
        break;
      case _AvatarEditorSection.hairColor:
        _set(_configuration.copyWith(hairColorId: id));
        break;
      case _AvatarEditorSection.eyes:
        _set(_configuration.copyWith(eyesId: id));
        break;
      case _AvatarEditorSection.nose:
        _set(_configuration.copyWith(noseId: id));
        break;
      case _AvatarEditorSection.mouth:
        _set(_configuration.copyWith(mouthId: id));
        break;
      default:
        throw StateError('Unexpected avatar editor section: $_section');
    }
  }

  @override
  Widget build(BuildContext context) {
    final _AvatarEditorLabels labels = _AvatarEditorLabels.of(context);
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double editorWidth = constraints.hasBoundedWidth
            ? constraints.maxWidth.clamp(0, 320).toDouble()
            : 320;
        return Center(
          child: SizedBox(
            width: editorWidth,
            child: Column(children: [
              AvatarPreview(
                configuration: _configuration,
                size: 160,
                assetPackage: widget.assetPackage,
              ),
              const SizedBox(height: 12),
              _SectionSelector(
                labels: labels.sectionTitlesFor(_configuration.presentation),
                selectedIndex: _step,
                onSelected: (int step) => setState(() => _step = step),
                layout: widget.sectionSelectorLayout,
              ),
              const SizedBox(height: 8),
              if (_section == _AvatarEditorSection.presentation)
                Wrap(
                    spacing: 10,
                    children: AvatarPresentation.values
                        .map((p) => ChoiceChip(
                            key: ValueKey<String>(
                                'avatar_presentation_${p.name}'),
                            label: Text(p == AvatarPresentation.boy
                                ? labels.boy
                                : labels.girl),
                            selected: _configuration.presentation == p,
                            onSelected: (_) =>
                                _set(AvatarCatalog.defaultFor(p))))
                        .toList())
              else if (_section == _AvatarEditorSection.hairColor)
                SizedBox(
                  height: 248,
                  child: Center(
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      alignment: WrapAlignment.center,
                      children: _options.map(_hairColorSwatch).toList(),
                    ),
                  ),
                )
              else
                SizedBox(
                  // Ten hairstyle tiles need four rows.  Keep navigation in the
                  // editor viewport and let the choices themselves scroll.
                  height: 248,
                  child: GridView.count(
                    crossAxisCount: _gridColumnCount,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 1,
                    children: _options.map(_optionTile).toList(),
                  ),
                ),
              const SizedBox(height: 12),
              SafeArea(
                top: false,
                minimum: const EdgeInsets.only(bottom: 12),
                child: Row(children: [
                  Expanded(
                    child: TextButton(
                      key: const ValueKey<String>('avatar_back_button'),
                      onPressed:
                          _step == 0 ? null : () => setState(() => _step--),
                      child: Text(labels.back),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      key: const ValueKey<String>('avatar_next_button'),
                      onPressed: _step == _sections.length - 1
                          ? null
                          : () => setState(() => _step++),
                      child: Text(labels.next),
                    ),
                  ),
                ]),
              ),
            ]),
          ),
        );
      },
    );
  }

  Widget _optionTile(String id) {
    final bool selected = _selected() == id;
    final bool locked =
        !widget.hasFullUnlock && !selected && !_isBasicOption(id);
    final bool isMouth = id.contains('_mouth_');
    final bool isHair = id.contains('_hair_');
    final Color accent = Theme.of(context).colorScheme.primary;
    return Semantics(
      label: id.replaceAll('_', ' '),
      selected: selected,
      button: true,
      child: InkWell(
        key: ValueKey<String>('avatar_option_$id'),
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          debugPrint(
              '[hair-color] tap id=$id selected=$selected locked=$locked '
              'hasFullUnlock=${widget.hasFullUnlock}');
          if (locked) {
            widget.onLockedOptionSelected?.call(id);
            return;
          }
          _choose(id);
        },
        child: Container(
          key: ValueKey<String>('avatar_option_surface_$id'),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? accent : Theme.of(context).colorScheme.outline,
              width: selected ? 2 : 1,
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(4),
                child: isHair
                    ? AvatarPreview(
                        configuration: _configuration.copyWith(hairId: id),
                        size: double.infinity,
                        assetPackage: widget.assetPackage,
                      )
                    : _optionTreatment(
                        id,
                        Transform.scale(
                          key: ValueKey<String>('avatar_option_image_$id'),
                          scale: isMouth ? 3 : 1,
                          child: Image.asset(
                            AvatarAssetCatalog.optionAssetFor(
                                _configuration.presentation, id),
                            package: widget.assetPackage,
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
              if (locked)
                Align(
                  key: ValueKey<String>('avatar_locked_option_$id'),
                  alignment: Alignment.topRight,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: .58),
                      shape: BoxShape.circle,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(Icons.lock, color: Colors.white, size: 14),
                    ),
                  ),
                ),
              if (widget.showOptionIds)
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: .68),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        child: Text(
                          id,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _hairColorSwatch(String id) {
    final bool selected = _selected() == id;
    // Hair colour is a visual preference, not premium avatar artwork.  Keep
    // all six swatches available in the standard learner flow.
    const bool locked = false;
    final Color accent = Theme.of(context).colorScheme.primary;
    final Color swatchColor = AvatarAssetCatalog.girlHairColors[id]!;
    return Semantics(
      label: 'Hair colour ${id.replaceAll('_', ' ')}',
      selected: selected,
      button: true,
      child: InkWell(
        key: ValueKey<String>('avatar_option_$id'),
        customBorder: const CircleBorder(),
        onTap: () {
          debugPrint('[hair-color] swatch tap id=$id selected=$selected '
              'locked=$locked hasFullUnlock=${widget.hasFullUnlock}');
          if (locked) {
            widget.onLockedOptionSelected?.call(id);
            return;
          }
          _choose(id);
        },
        child: Container(
          key: ValueKey<String>('avatar_option_surface_$id'),
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: swatchColor,
            shape: BoxShape.circle,
            border: Border.all(
              color: selected ? accent : Theme.of(context).colorScheme.outline,
              width: selected ? 4 : 1,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              if (selected)
                const Icon(Icons.check, color: Colors.white, size: 24),
              if (locked) const Icon(Icons.lock, color: Colors.white, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  bool _isBasicOption(String id) => id.endsWith('_01');

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

class _SectionSelector extends StatelessWidget {
  const _SectionSelector({
    required this.labels,
    required this.selectedIndex,
    required this.onSelected,
    required this.layout,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final AvatarSectionSelectorLayout layout;

  @override
  Widget build(BuildContext context) {
    final Color selectedColor = Theme.of(context).colorScheme.primary;
    final List<Widget> tabs = List<Widget>.generate(labels.length, (
      int index,
    ) {
      final bool selected = selectedIndex == index;
      return Padding(
        padding: EdgeInsetsDirectional.only(
          end: index == labels.length - 1 ? 0 : 4,
        ),
        child: TextButton(
          key: ValueKey<String>('avatar_section_tab_$index'),
          onPressed: () => onSelected(index),
          style: TextButton.styleFrom(
            foregroundColor: selected ? selectedColor : null,
            backgroundColor: selected
                ? Theme.of(context).colorScheme.primaryContainer
                : null,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            minimumSize: const Size(0, 40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(labels[index]),
        ),
      );
    });
    if (layout == AvatarSectionSelectorLayout.wrap) {
      return Wrap(
        key: const ValueKey<String>('avatar_section_selector'),
        alignment: WrapAlignment.center,
        spacing: 4,
        runSpacing: 4,
        children: tabs,
      );
    }
    return SizedBox(
      key: const ValueKey<String>('avatar_section_selector'),
      height: 40,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: tabs),
      ),
    );
  }
}

class _AvatarEditorLabels {
  const _AvatarEditorLabels({
    required this.sectionTitles,
    required this.hairColor,
    required this.boy,
    required this.girl,
    required this.back,
    required this.next,
  });

  final List<String> sectionTitles;
  final String hairColor;
  final String boy;
  final String girl;
  final String back;
  final String next;

  factory _AvatarEditorLabels.of(BuildContext context) {
    final Locale locale = Localizations.localeOf(context);
    if (locale.languageCode == 'zh' && locale.countryCode == 'CN') {
      return const _AvatarEditorLabels(
        sectionTitles: <String>['角色', '肤色', '脸型', '发型', '眼睛', '鼻子', '嘴巴'],
        hairColor: '发色',
        boy: '男孩',
        girl: '女孩',
        back: '上一步',
        next: '下一步',
      );
    }
    if (locale.languageCode == 'zh') {
      return const _AvatarEditorLabels(
        sectionTitles: <String>['角色', '膚色', '臉型', '髮型', '眼睛', '鼻子', '嘴巴'],
        hairColor: '髮色',
        boy: '男生',
        girl: '女生',
        back: '上一步',
        next: '下一步',
      );
    }
    if (locale.languageCode == 'ja') {
      return const _AvatarEditorLabels(
        sectionTitles: <String>['アバター', '肌色', '顔', '髪型', '目', '鼻', '口'],
        hairColor: '髪の色',
        boy: '男の子',
        girl: '女の子',
        back: '戻る',
        next: '次へ',
      );
    }
    return const _AvatarEditorLabels(
      sectionTitles: <String>[
        'Choose avatar',
        'Skin tone',
        'Face shape',
        'Hairstyle',
        'Eyes',
        'Nose',
        'Mouth',
      ],
      hairColor: 'Hair colour',
      boy: 'Boy',
      girl: 'Girl',
      back: 'Back',
      next: 'Next',
    );
  }

  List<String> sectionTitlesFor(AvatarPresentation presentation) => <String>[
      ...sectionTitles.take(4),
      hairColor,
      ...sectionTitles.skip(4),
    ];
}
