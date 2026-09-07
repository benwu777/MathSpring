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
  static const int _sectionCount = 7;
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
      case 6:
        return AvatarCatalog.mouthOptionsFor(_configuration.presentation);
      default:
        throw StateError('Unexpected avatar editor step: $_step');
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
      case 6:
        return _configuration.mouthId;
      default:
        throw StateError('Unexpected avatar editor step: $_step');
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
      case 6:
        _set(_configuration.copyWith(mouthId: id));
        break;
      default:
        throw StateError('Unexpected avatar editor step: $_step');
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
              AvatarPreview(configuration: _configuration, size: 170),
              const SizedBox(height: 12),
              _SectionSelector(
                labels: labels.sectionTitles,
                selectedIndex: _step,
                onSelected: (int step) => setState(() => _step = step),
              ),
              const SizedBox(height: 8),
              if (_step == 0)
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
              else
                SizedBox(
                  // Ten hairstyle tiles need four rows.  Keep navigation in the
                  // editor viewport and let the choices themselves scroll.
                  height: 260,
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
                      onPressed: _step == _sectionCount - 1
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

class _SectionSelector extends StatelessWidget {
  const _SectionSelector({
    required this.labels,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final Color selectedColor = Theme.of(context).colorScheme.primary;
    return SizedBox(
      key: const ValueKey<String>('avatar_section_selector'),
      height: 40,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List<Widget>.generate(labels.length, (int index) {
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
                  backgroundColor:
                      selected ? selectedColor.withValues(alpha: .12) : null,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  minimumSize: const Size(0, 40),
                ),
                child: Text(labels[index]),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _AvatarEditorLabels {
  const _AvatarEditorLabels({
    required this.sectionTitles,
    required this.boy,
    required this.girl,
    required this.back,
    required this.next,
  });

  final List<String> sectionTitles;
  final String boy;
  final String girl;
  final String back;
  final String next;

  factory _AvatarEditorLabels.of(BuildContext context) {
    final Locale locale = Localizations.localeOf(context);
    if (locale.languageCode == 'zh' && locale.countryCode == 'CN') {
      return const _AvatarEditorLabels(
        sectionTitles: <String>['角色', '肤色', '脸型', '发型', '眼睛', '鼻子', '嘴巴'],
        boy: '男孩',
        girl: '女孩',
        back: '上一步',
        next: '下一步',
      );
    }
    if (locale.languageCode == 'zh') {
      return const _AvatarEditorLabels(
        sectionTitles: <String>['角色', '膚色', '臉型', '髮型', '眼睛', '鼻子', '嘴巴'],
        boy: '男生',
        girl: '女生',
        back: '上一步',
        next: '下一步',
      );
    }
    if (locale.languageCode == 'ja') {
      return const _AvatarEditorLabels(
        sectionTitles: <String>['アバター', '肌色', '顔', '髪型', '目', '鼻', '口'],
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
      boy: 'Boy',
      girl: 'Girl',
      back: 'Back',
      next: 'Next',
    );
  }
}
