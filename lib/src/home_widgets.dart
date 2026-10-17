part of '../main.dart';

enum _SessionLaunchMode { practice, quiz }

class _LearnerSummaryBanner extends StatelessWidget {
  const _LearnerSummaryBanner({
    required this.learner,
    required this.primaryLabel,
    required this.secondaryLabel,
  });

  final LearnerProfile? learner;
  final String primaryLabel;
  final String secondaryLabel;

  @override
  Widget build(BuildContext context) {
    final LayoutSpec layoutSpec = LayoutSpec.of(context);
    final AppStrings strings = AppStrings.of(context);
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      key: const ValueKey<String>('learner_summary_banner'),
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FBFF),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            primaryLabel,
            style: textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
              color: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            learner?.displayName ?? strings.noLearnerSelected,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.headlineSmall?.copyWith(
              fontSize: layoutSpec.scaleText(24),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            secondaryLabel,
            style: textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
              color: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            learner == null ? '-' : _learnerGradeRangeLabel(learner!, strings),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.titleLarge?.copyWith(
              fontSize: layoutSpec.scaleText(19),
              color: const Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopicActionGrid extends StatelessWidget {
  const _TopicActionGrid({
    required this.strings,
    required this.onTopicSelected,
  });

  final AppStrings strings;
  final Future<void> Function(String topicCode) onTopicSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _TopicActionButton(
          buttonKey: const ValueKey<String>('topic_action_geometry'),
          label: strings.topicGeometry,
          onPressed: () async => onTopicSelected('geometry'),
        ),
        _TopicActionButton(
          buttonKey: const ValueKey<String>('topic_action_arithmetic'),
          label: strings.topicArithmetic,
          onPressed: () async => onTopicSelected('arithmetic'),
        ),
        _TopicActionButton(
          buttonKey: const ValueKey<String>('topic_action_logic'),
          label: strings.topicLogic,
          onPressed: () async => onTopicSelected('logic'),
        ),
      ],
    );
  }
}

class _TopicActionButton extends StatelessWidget {
  const _TopicActionButton({
    required this.buttonKey,
    required this.label,
    required this.onPressed,
  });

  final Key buttonKey;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: OutlinedButton(
        key: buttonKey,
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF111827),
          minimumSize: const Size.fromHeight(52),
          side: const BorderSide(color: Color(0xFFE5E7EB)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(label),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.strings});

  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    final bool isWideLayout =
        LayoutSpec.of(context).widthClass != WidthClass.compact;

    return Container(
      key: const ValueKey<String>('home_hero_surface'),
      decoration: BoxDecoration(
        color: AppVisualTokens.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppVisualTokens.outline),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1217201D),
            blurRadius: 14,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: isWideLayout
            ? Row(
                children: [
                  Expanded(
                    child: _HeroCopy(
                      strings: strings,
                    ),
                  ),
                  const SizedBox(width: 24),
                  const Expanded(child: _HeroPanel()),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HeroCopy(strings: strings),
                  const SizedBox(height: 24),
                  const _HeroPanel(),
                ],
              ),
      ),
    );
  }
}

class _HeroCopy extends StatelessWidget {
  const _HeroCopy({required this.strings});

  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    final LayoutSpec layoutSpec = LayoutSpec.of(context);
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppVisualTokens.primarySoft,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            strings.heroBadge,
            style: TextStyle(
              color: AppVisualTokens.primary,
              fontWeight: FontWeight.w700,
              fontSize: layoutSpec.scaleText(12),
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          strings.heroTitle,
          style: textTheme.displaySmall?.copyWith(
            fontSize: layoutSpec.scaleText(34),
            height: 1.05,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          strings.heroSubtitle,
          style: textTheme.bodyLarge?.copyWith(
            color: AppVisualTokens.inkMuted,
          ),
        ),
        const SizedBox(height: 18),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _InfoPill(label: strings.pillAdaptive),
            _InfoPill(label: strings.pillProfiles),
            _InfoPill(label: strings.pillBilingual),
          ],
        ),
      ],
    );
  }
}

class _HeroPanel extends StatelessWidget {
  const _HeroPanel();

  @override
  Widget build(BuildContext context) {
    final LayoutSpec layoutSpec = LayoutSpec.of(context);
    final AppStrings strings = AppStrings.of(context);
    return Container(
      constraints: const BoxConstraints(minHeight: 220),
      decoration: BoxDecoration(
        color: AppVisualTokens.primary,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26177C87),
            blurRadius: 12,
            offset: Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            strings.dashboardFocusTitle,
            style: TextStyle(
              color: const Color(0xB3FFFFFF),
              fontSize: layoutSpec.scaleText(12),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            strings.dashboardFocusBody,
            style: TextStyle(
              color: Colors.white,
              fontSize: layoutSpec.headingText,
              height: 1.4,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0x1FFFFFFF),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0x2FFFFFFF)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${strings.dashboardPathTitle}\n${strings.dashboardPathValue}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: layoutSpec.captionText,
                      height: 1.5,
                    ),
                  ),
                ),
                const Icon(Icons.arrow_outward, color: Colors.white, size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CompactHeroBanner extends StatelessWidget {
  const _CompactHeroBanner({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final LayoutSpec layoutSpec = LayoutSpec.of(context);
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      decoration: BoxDecoration(
        color: AppVisualTokens.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppVisualTokens.outline),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppVisualTokens.primarySoft,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppVisualTokens.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.titleLarge?.copyWith(
                    fontSize: layoutSpec.scaleText(20),
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppVisualTokens.inkMuted,
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

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.subtitle,
    required this.child,
    this.trailing,
    this.cardKey,
  });

  final String title;
  final String subtitle;
  final Widget child;
  final Widget? trailing;
  final Key? cardKey;

  @override
  Widget build(BuildContext context) {
    final LayoutSpec layoutSpec = LayoutSpec.of(context);
    return Card(
      key: cardKey ?? ValueKey<String>('section_card_$title'),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          layoutSpec.cardPadding,
          layoutSpec.cardPadding,
          layoutSpec.cardPadding,
          layoutSpec.cardPadding - 2,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontSize: layoutSpec.titleText,
                          letterSpacing: -0.3,
                        ),
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: 12),
                  trailing!,
                ],
              ],
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF64748B),
                    height: 1.45,
                  ),
            ),
            const SizedBox(height: 20),
            child,
          ],
        ),
      ),
    );
  }
}
