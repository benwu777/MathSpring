part of '../main.dart';

class _LearnerProfilesSection extends StatefulWidget {
  const _LearnerProfilesSection({
    required this.title,
    required this.subtitle,
    required this.services,
    required this.onChanged,
    this.maxLearnerProfiles = 1,
    this.onProfileLimitReached,
    this.hasFullUnlock = false,
  });

  final String title;
  final String subtitle;
  final AppServices services;
  final VoidCallback onChanged;
  final int maxLearnerProfiles;
  final VoidCallback? onProfileLimitReached;
  final bool hasFullUnlock;

  @override
  State<_LearnerProfilesSection> createState() =>
      _LearnerProfilesSectionState();
}

class _LearnerProfilesSectionState extends State<_LearnerProfilesSection> {
  Future<void> _openCreateLearnerDialog(BuildContext context) async {
    if (widget.services.learnerProfiles.length >= widget.maxLearnerProfiles) {
      widget.onProfileLimitReached?.call();
      return;
    }
    final AppStrings strings = AppStrings.of(context);
    final _LearnerDraft? draft = await showDialog<_LearnerDraft>(
      context: context,
      builder: (_) => _CreateLearnerDialog(
        strings: strings,
        hasFullUnlock: widget.hasFullUnlock,
        onLockedOptionSelected: widget.onProfileLimitReached,
      ),
    );
    if (draft == null) {
      return;
    }

    final LearnerProfile profile = await widget.services.createLearner(
      displayName: draft.displayName,
      minLevelStage: draft.minLevelStage,
      maxLevelStage: draft.maxLevelStage,
      challengeTier: 'foundation',
      avatar: draft.avatar,
      maxLearnerProfiles: widget.maxLearnerProfiles,
    );
    await widget.services.setCurrentLearner(profile.id);
    widget.onChanged();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _openEditLearnerPage(
    BuildContext context,
    LearnerProfile learner,
  ) async {
    final bool? changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => LearnerEditPage(
          services: widget.services,
          learner: learner,
          hasFullUnlock: widget.hasFullUnlock,
          onLockedOptionSelected: widget.onProfileLimitReached,
        ),
      ),
    );
    if (changed == true) {
      widget.onChanged();
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future<void> _deleteLearner(String learnerId) async {
    await widget.services.deleteLearner(learnerId);
    widget.onChanged();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _confirmDeleteLearner(LearnerProfile learner) async {
    final AppStrings strings = AppStrings.of(context);
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: Text(strings.deleteLearner),
        content: Text(strings.deleteLearnerConfirmation(learner.displayName)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(strings.cancel)),
          FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(strings.deleteConfirmLabel)),
        ],
      ),
    );
    if (confirmed == true) await _deleteLearner(learner.id);
  }

  @override
  Widget build(BuildContext context) {
    final AppStrings strings = AppStrings.of(context);
    final List<LearnerProfile> profiles = widget.services.learnerProfiles;
    return _SectionCard(
      title: widget.title,
      subtitle: widget.subtitle,
      trailing: TextButton.icon(
        onPressed: () => _openCreateLearnerDialog(context),
        icon: const Icon(Icons.add, size: 18),
        label: Text(strings.addLearner),
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFF111827),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _LearnerSummaryBanner(
            learner: profiles.isEmpty
                ? null
                : profiles.firstWhere(
                    (profile) => profile.id == widget.services.currentLearnerId,
                    orElse: () => profiles.first,
                  ),
            primaryLabel: strings.currentLearnerLabel,
            secondaryLabel: strings.gradeRangeLabel,
          ),
          const SizedBox(height: 16),
          for (int index = 0; index < profiles.length; index++) ...[
            _ProfileTile(
              tileKey: ValueKey<String>('profile_tile_${profiles[index].id}'),
              onTap: () async {
                await widget.services.setCurrentLearner(profiles[index].id);
                widget.onChanged();
                if (mounted) {
                  setState(() {});
                }
              },
              name: profiles[index].displayName,
              avatar: profiles[index].avatar,
              level: _learnerGradeRangeLabel(profiles[index], strings),
              accent: index.isEven
                  ? AppVisualTokens.brand
                  : const Color(0xFF3B82F6),
              isCurrent: profiles[index].id == widget.services.currentLearnerId,
              currentLabel: strings.currentLearner,
              editTooltip: strings.editLearner,
              onEdit: () => _openEditLearnerPage(context, profiles[index]),
              editKey: ValueKey<String>('edit_learner_${profiles[index].id}'),
              deleteTooltip: strings.deleteLearner,
              onDelete: profiles.length <= 1
                  ? null
                  : () => _confirmDeleteLearner(profiles[index]),
              deleteKey: ValueKey<String>(
                'delete_learner_${profiles[index].id}',
              ),
            ),
            if (index != profiles.length - 1) const SizedBox(height: 14),
          ],
        ],
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({
    this.tileKey,
    required this.onTap,
    required this.name,
    required this.avatar,
    required this.level,
    required this.accent,
    required this.isCurrent,
    required this.currentLabel,
    required this.editTooltip,
    required this.deleteTooltip,
    this.editKey,
    this.onEdit,
    this.onDelete,
    this.deleteKey,
  });

  final Key? tileKey;
  final Future<void> Function() onTap;
  final String name;
  final AvatarConfiguration avatar;
  final String level;
  final Color accent;
  final bool isCurrent;
  final String currentLabel;
  final String editTooltip;
  final Key? editKey;
  final String deleteTooltip;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final Key? deleteKey;

  @override
  Widget build(BuildContext context) {
    final LayoutSpec layoutSpec = LayoutSpec.of(context);
    final TextTheme textTheme = Theme.of(context).textTheme;
    return InkWell(
      key: tileKey,
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isCurrent ? AppVisualTokens.brand : const Color(0xFFE2E8F0),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A0F172A),
              blurRadius: 18,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            AvatarPreview(configuration: avatar, size: 54),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.titleLarge?.copyWith(
                            fontSize: layoutSpec.titleText,
                            letterSpacing: -0.2,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (isCurrent)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAF2FF),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(color: const Color(0xFFCFE0FF)),
                          ),
                          child: Text(
                            currentLabel,
                            style: textTheme.bodySmall?.copyWith(
                              fontSize: layoutSpec.microText,
                              fontWeight: FontWeight.w700,
                              color: AppVisualTokens.brand,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    level,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodyMedium?.copyWith(
                      fontSize: layoutSpec.scaleText(14),
                      color: const Color(0xFF475569),
                    ),
                  ),
                ],
              ),
            ),
            if (onEdit != null)
              IconButton(
                key: editKey,
                onPressed: onEdit,
                tooltip: editTooltip,
                icon: const Icon(
                  Icons.edit_outlined,
                  color: Color(0xFF94A3B8),
                ),
              ),
            if (onDelete != null)
              IconButton(
                key: deleteKey,
                onPressed: onDelete,
                tooltip: deleteTooltip,
                icon: const Icon(
                  Icons.delete_outline,
                  color: Color(0xFF94A3B8),
                ),
              ),
            const Icon(Icons.chevron_right, color: Color(0xFF94A3B8)),
          ],
        ),
      ),
    );
  }
}

class _ProgressSection extends StatelessWidget {
  const _ProgressSection({
    required this.title,
    required this.subtitle,
    required this.services,
  });

  final String title;
  final String subtitle;
  final AppServices services;

  @override
  Widget build(BuildContext context) {
    final String? learnerId = services.currentLearnerId;
    return FutureBuilder<LearnerProgressSummary>(
      future: learnerId == null
          ? Future<LearnerProgressSummary>.value(
              const LearnerProgressSummary(solvedCount: 0, correctCount: 0),
            )
          : services.getLearnerProgressSummary(learnerId),
      builder: (context, snapshot) {
        final LearnerProgressSummary summary = snapshot.data ??
            const LearnerProgressSummary(solvedCount: 0, correctCount: 0);
        return _SectionCard(
          title: title,
          subtitle: subtitle,
          child: _StatRow(
            leftValue: '${summary.solvedCount}',
            leftLabel: AppStrings.of(context).solvedLabel,
            rightValue: '${(summary.accuracyRate * 100).round()}%',
            rightLabel: AppStrings.of(context).accuracyLabel,
          ),
        );
      },
    );
  }
}

class _LearnerDraft {
  const _LearnerDraft({
    required this.displayName,
    required this.minLevelStage,
    required this.maxLevelStage,
    required this.avatar,
  });

  final String displayName;
  final String minLevelStage;
  final String maxLevelStage;
  final AvatarConfiguration avatar;
}

class _CreateLearnerDialog extends StatefulWidget {
  const _CreateLearnerDialog({
    required this.strings,
    required this.hasFullUnlock,
    this.onLockedOptionSelected,
  });

  final AppStrings strings;
  final bool hasFullUnlock;
  final VoidCallback? onLockedOptionSelected;

  @override
  State<_CreateLearnerDialog> createState() => _CreateLearnerDialogState();
}

class _CreateLearnerDialogState extends State<_CreateLearnerDialog> {
  final TextEditingController _nameController = TextEditingController();
  RangeValues _gradeRange = const RangeValues(1, 2);
  AvatarConfiguration _avatar =
      AvatarConfiguration.defaultFor(AvatarPresentation.girl);

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(widget.strings.addLearner),
      content: SizedBox(
        width: 360,
        height: 430,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                key: const ValueKey<String>('learner_name_field'),
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: widget.strings.learnerName,
                ),
              ),
              const SizedBox(height: 16),
              _LearnerGradeRangeSelector(
                strings: widget.strings,
                values: _gradeRange,
                onChanged: (value) {
                  setState(() {
                    _gradeRange = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              AvatarEditor(
                onChanged: (value) => _avatar = value,
                hasFullUnlock: widget.hasFullUnlock,
                onLockedOptionSelected: (_) =>
                    widget.onLockedOptionSelected?.call(),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(widget.strings.cancel),
        ),
        FilledButton(
          key: const ValueKey<String>('save_learner_button'),
          onPressed: () {
            final String name = _nameController.text.trim();
            if (name.isEmpty) {
              return;
            }
            Navigator.of(context).pop(
              _LearnerDraft(
                displayName: name,
                minLevelStage: levelStageFromNumber(_gradeRange.start.round()),
                maxLevelStage: levelStageFromNumber(_gradeRange.end.round()),
                avatar: _avatar,
              ),
            );
          },
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF111827),
          ),
          child: Text(widget.strings.saveLearner),
        ),
      ],
    );
  }
}

class LearnerEditPage extends StatefulWidget {
  const LearnerEditPage({
    super.key,
    required this.services,
    required this.learner,
    required this.hasFullUnlock,
    this.onLockedOptionSelected,
  });

  final AppServices services;
  final LearnerProfile learner;
  final bool hasFullUnlock;
  final VoidCallback? onLockedOptionSelected;

  @override
  State<LearnerEditPage> createState() => _LearnerEditPageState();
}

class _LearnerEditPageState extends State<LearnerEditPage> {
  late final TextEditingController _nameController;
  late RangeValues _gradeRange;
  late AvatarConfiguration _avatar;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.learner.displayName);
    _gradeRange = RangeValues(
      levelStageNumber(widget.learner.effectiveMinLevelStage).toDouble(),
      levelStageNumber(widget.learner.effectiveMaxLevelStage).toDouble(),
    );
    _avatar = widget.learner.avatar;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final String name = _nameController.text.trim();
    if (name.isEmpty) {
      return;
    }
    await widget.services.updateLearner(
      LearnerProfile(
        id: widget.learner.id,
        displayName: name,
        levelStage: levelStageFromNumber(_gradeRange.end.round()),
        minLevelStage: levelStageFromNumber(_gradeRange.start.round()),
        maxLevelStage: levelStageFromNumber(_gradeRange.end.round()),
        challengeTier: widget.learner.challengeTier,
        createdAtIso: widget.learner.createdAtIso,
        avatar: _avatar,
      ),
    );
    if (!mounted) {
      return;
    }
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final AppStrings strings = AppStrings.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.editLearner),
        surfaceTintColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            key: const ValueKey<String>('edit_learner_name_field'),
            controller: _nameController,
            decoration: InputDecoration(
              labelText: strings.learnerName,
            ),
          ),
          const SizedBox(height: 20),
          _LearnerGradeRangeSelector(
            strings: strings,
            values: _gradeRange,
            onChanged: (value) {
              setState(() {
                _gradeRange = value;
              });
            },
          ),
          const SizedBox(height: 20),
          AvatarEditor(
            initialConfiguration: _avatar,
            onChanged: (value) => _avatar = value,
            hasFullUnlock: widget.hasFullUnlock,
            onLockedOptionSelected: (_) =>
                widget.onLockedOptionSelected?.call(),
          ),
          const SizedBox(height: 16),
          FilledButton(
            key: const ValueKey<String>('save_learner_profile_button'),
            onPressed: _save,
            child: Text(strings.saveLearner),
          ),
        ],
      ),
    );
  }
}

class _LearnerGradeRangeSelector extends StatelessWidget {
  const _LearnerGradeRangeSelector({
    required this.strings,
    required this.values,
    required this.onChanged,
  });

  final AppStrings strings;
  final RangeValues values;
  final ValueChanged<RangeValues> onChanged;

  @override
  Widget build(BuildContext context) {
    final int startGrade = values.start.round();
    final int endGrade = values.end.round();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          strings.gradeRangeLabel,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Text(
          strings.gradeRangeHint,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 14),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          decoration: BoxDecoration(
            color: AppVisualTokens.surfaceMuted,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppVisualTokens.outline),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                strings.gradeRangeDisplay(startGrade, endGrade),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              RangeSlider(
                key: const ValueKey<String>('learner_grade_range_slider'),
                min: 1,
                max: 12,
                divisions: 11,
                values: values,
                labels: RangeLabels('$startGrade', '$endGrade'),
                onChanged: onChanged,
              ),
              Row(
                children: [
                  Text('1', style: Theme.of(context).textTheme.bodySmall),
                  const Spacer(),
                  Text('12', style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.leftValue,
    required this.leftLabel,
    required this.rightValue,
    required this.rightLabel,
  });

  final String leftValue;
  final String leftLabel;
  final String rightValue;
  final String rightLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _StatCard(value: leftValue, label: leftLabel)),
        const SizedBox(width: 14),
        Expanded(child: _StatCard(value: rightValue, label: rightLabel)),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final LayoutSpec layoutSpec = LayoutSpec.of(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppVisualTokens.surfaceMuted,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppVisualTokens.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: layoutSpec.scaleText(28),
              fontWeight: FontWeight.w700,
              color: AppVisualTokens.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }
}
