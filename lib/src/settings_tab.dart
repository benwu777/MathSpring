part of '../main.dart';

class _SettingsTab extends StatelessWidget {
  const _SettingsTab({
    super.key,
    required this.services,
    required this.onChanged,
    required this.currentLocale,
    required this.onLocaleChanged,
    required this.monetization,
  });

  final AppServices services;
  final VoidCallback onChanged;
  final Locale currentLocale;
  final ValueChanged<Locale> onLocaleChanged;
  final MonetizationService monetization;

  @override
  Widget build(BuildContext context) {
    final AppStrings strings = AppStrings.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CompactHeroBanner(
          title: strings.settingsTitle,
          subtitle: strings.settingsSubtitle,
          icon: Icons.tune_rounded,
        ),
        const SizedBox(height: 18),
        _LearnerProfilesSection(
          title: strings.settingsTitle,
          subtitle: strings.settingsSubtitle,
          services: services,
          onChanged: onChanged,
          maxLearnerProfiles: monetization.value.maxLearnerProfiles,
          hasFullUnlock: monetization.value.hasFullUnlock,
          onProfileLimitReached: () => showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            builder: (_) => _FullUnlockSheet(monetization: monetization),
          ),
        ),
        const SizedBox(height: 16),
        _FullUnlockSection(monetization: monetization),
        const SizedBox(height: 16),
        _LocaleSettingsSection(
          currentLocale: currentLocale,
          onLocaleChanged: onLocaleChanged,
        ),
        const SizedBox(height: 16),
        _ProgressSection(
          title: strings.progressTitle,
          subtitle: strings.progressSubtitle,
          services: services,
        ),
        const SizedBox(height: 16),
        const _SupportAndPrivacySection(),
      ],
    );
  }
}

class _FullUnlockSection extends StatelessWidget {
  const _FullUnlockSection({required this.monetization});

  final MonetizationService monetization;

  Future<void> _showPaywall(BuildContext context) => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (_) => _FullUnlockSheet(monetization: monetization),
      );

  @override
  Widget build(BuildContext context) {
    final AppStrings strings = AppStrings.of(context);
    return ValueListenableBuilder<MonetizationState>(
      valueListenable: monetization,
      builder: (BuildContext context, MonetizationState state, _) =>
          _SectionCard(
        title: state.hasFullUnlock
            ? strings.fullUnlockUnlockedTitle
            : strings.fullUnlockTitle,
        subtitle: state.hasFullUnlock
            ? strings.fullUnlockUnlockedSubtitle
            : strings.fullUnlockSubtitle,
        trailing: state.hasFullUnlock
            ? const Icon(Icons.verified_rounded, color: AppVisualTokens.brand)
            : TextButton(
                key: const ValueKey<String>('open_full_unlock'),
                onPressed: state.status == MonetizationStatus.unavailable
                    ? null
                    : () => _showPaywall(context),
                child:
                    Text(state.product?.price ?? strings.purchaseUnavailable),
              ),
        child: const SizedBox.shrink(),
      ),
    );
  }
}

class _LockedSolutionSteps extends StatelessWidget {
  const _LockedSolutionSteps();

  @override
  Widget build(BuildContext context) {
    final MonetizationService monetization = MonetizationScope.of(context);
    final AppStrings strings = AppStrings.of(context);
    return Align(
      alignment: Alignment.centerLeft,
      child: OutlinedButton.icon(
        key: const ValueKey<String>('unlock_solution_steps'),
        onPressed: () => showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          builder: (_) => _FullUnlockSheet(monetization: monetization),
        ),
        icon: const Icon(Icons.lock_outline),
        label: Text(strings.unlockSolutionSteps),
      ),
    );
  }
}

class _FullUnlockSheet extends StatelessWidget {
  const _FullUnlockSheet({required this.monetization});

  final MonetizationService monetization;

  @override
  Widget build(BuildContext context) {
    final AppStrings strings = AppStrings.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
        child: ValueListenableBuilder<MonetizationState>(
          valueListenable: monetization,
          builder: (BuildContext context, MonetizationState state, _) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(strings.fullUnlockTitle,
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 12),
              Text(strings.fullUnlockDescription),
              const SizedBox(height: 20),
              if (state.errorMessage != null) ...[
                Text(state.errorMessage!,
                    style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 12),
              ],
              if (state.hasFullUnlock)
                Text(strings.fullUnlockAlreadyPurchased)
              else if (state.product == null)
                Text(strings.fullUnlockProductUnavailable)
              else ...[
                FilledButton(
                  key: const ValueKey<String>('purchase_full_unlock'),
                  onPressed: state.status == MonetizationStatus.purchasing ||
                          state.status == MonetizationStatus.restoring
                      ? null
                      : monetization.purchaseFullUnlock,
                  child: Text(strings.purchaseFullUnlock(state.product!.price)),
                ),
                const SizedBox(height: 8),
                TextButton(
                  key: const ValueKey<String>('restore_purchases'),
                  onPressed: state.status == MonetizationStatus.purchasing ||
                          state.status == MonetizationStatus.restoring
                      ? null
                      : monetization.restorePurchases,
                  child: Text(strings.restorePurchases),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SupportAndPrivacySection extends StatelessWidget {
  const _SupportAndPrivacySection();

  static final Uri _supportUrl = Uri.parse(appSupportUrl);
  static final Uri _privacyUrl = Uri.parse(appPrivacyPolicyUrl);

  Future<void> _open(BuildContext context, Uri url) async {
    if (await launchUrl(url, mode: LaunchMode.externalApplication)) {
      return;
    }
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppStrings.of(context).linkOpenFailed)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppStrings strings = AppStrings.of(context);
    return _SectionCard(
      title: strings.helpAndPrivacyTitle,
      subtitle: strings.helpAndPrivacySubtitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OutlinedButton.icon(
            key: const ValueKey<String>('open_support_link'),
            onPressed: () => _open(context, _supportUrl),
            icon: const Icon(Icons.support_agent_outlined),
            label: Text(strings.supportLinkLabel),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            key: const ValueKey<String>('open_privacy_link'),
            onPressed: () => _open(context, _privacyUrl),
            icon: const Icon(Icons.privacy_tip_outlined),
            label: Text(strings.privacyLinkLabel),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.title,
    required this.learner,
  });

  final String title;
  final LearnerProfile? learner;

  @override
  Widget build(BuildContext context) {
    final LayoutSpec layoutSpec = LayoutSpec.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 品牌 chip 必須可壓縮：英文的 appSubtitle 比中文長很多，
        // 在 390pt 寬的 iPhone 上會把整條 Row 撐爆 29px。
        Flexible(
          child: Container(
            key: const ValueKey<String>('top_bar_brand_chip'),
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFDFEFF),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: const Color(0xFFE6EBF2)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0A0F172A),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              AppStrings.of(context).appSubtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: layoutSpec.microText,
                color: const Color(0xFF64748B),
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: layoutSpec.scaleText(20),
                      letterSpacing: -0.6,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                AppStrings.of(context).heroSubtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: layoutSpec.microText,
                  color: const Color(0xFF94A3B8),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        if (learner != null) ...[
          const SizedBox(width: 12),
          SizedBox(
            width: 124,
            child: _CurrentLearnerIdentity(learner: learner!),
          ),
        ],
      ],
    );
  }
}

class _CurrentLearnerIdentity extends StatelessWidget {
  const _CurrentLearnerIdentity({required this.learner});

  final LearnerProfile learner;

  @override
  Widget build(BuildContext context) {
    final AppStrings strings = AppStrings.of(context);
    final LayoutSpec layoutSpec = LayoutSpec.of(context);
    return Semantics(
      label:
          '${learner.displayName}, ${_learnerGradeRangeLabel(learner, strings)}',
      child: Row(
        key: const ValueKey<String>('current_learner_identity'),
        mainAxisSize: MainAxisSize.min,
        children: [
          AvatarPreview(configuration: learner.avatar, size: 36),
          const SizedBox(width: 7),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  learner.displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontSize: layoutSpec.scaleText(13),
                        fontWeight: FontWeight.w700,
                      ),
                ),
                Text(
                  _learnerGradeRangeLabel(learner, strings),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontSize: layoutSpec.microText,
                        color: const Color(0xFF64748B),
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LocaleSettingsSection extends StatelessWidget {
  const _LocaleSettingsSection({
    required this.currentLocale,
    required this.onLocaleChanged,
  });

  final Locale currentLocale;
  final ValueChanged<Locale> onLocaleChanged;

  @override
  Widget build(BuildContext context) {
    final AppStrings strings = AppStrings.of(context);
    return _SectionCard(
      title: strings.languageSettingsTitle,
      subtitle: strings.languageSettingsSubtitle,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          _LanguageButton(
            buttonKey: const ValueKey<String>('locale_option_zh'),
            label: strings.languageTraditionalChinese,
            selected: currentLocale.languageCode == 'zh' &&
                currentLocale.countryCode != 'CN',
            onPressed: () => onLocaleChanged(const Locale('zh', 'TW')),
          ),
          _LanguageButton(
            buttonKey: const ValueKey<String>('locale_option_zh_hans'),
            label: strings.languageSimplifiedChinese,
            selected: currentLocale.languageCode == 'zh' &&
                currentLocale.countryCode == 'CN',
            onPressed: () => onLocaleChanged(const Locale('zh', 'CN')),
          ),
          _LanguageButton(
            buttonKey: const ValueKey<String>('locale_option_en'),
            label: strings.languageEnglish,
            selected: currentLocale.languageCode == 'en',
            onPressed: () => onLocaleChanged(const Locale('en')),
          ),
          _LanguageButton(
            buttonKey: const ValueKey<String>('locale_option_ja'),
            label: strings.languageJapanese,
            selected: currentLocale.languageCode == 'ja',
            onPressed: () => onLocaleChanged(const Locale('ja')),
          ),
        ],
      ),
    );
  }
}

class _LanguageButton extends StatelessWidget {
  const _LanguageButton({
    this.buttonKey,
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final Key? buttonKey;
  final String label;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      key: buttonKey,
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor:
            selected ? const Color(0xFF111827) : Colors.transparent,
        foregroundColor: selected ? Colors.white : const Color(0xFF4B5563),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(label),
    );
  }
}
