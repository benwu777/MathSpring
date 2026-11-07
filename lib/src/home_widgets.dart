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
          topicCode: 'geometry',
          label: strings.topicGeometry,
          onPressed: () async => onTopicSelected('geometry'),
        ),
        _TopicActionButton(
          buttonKey: const ValueKey<String>('topic_action_arithmetic'),
          topicCode: 'arithmetic',
          label: strings.topicArithmetic,
          onPressed: () async => onTopicSelected('arithmetic'),
        ),
        _TopicActionButton(
          buttonKey: const ValueKey<String>('topic_action_logic'),
          topicCode: 'logic',
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
    required this.topicCode,
    required this.label,
    required this.onPressed,
  });

  final Key buttonKey;
  final String topicCode;
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
          foregroundColor: TopicPalette.accentOf(topicCode),
          minimumSize: const Size.fromHeight(52),
          side: BorderSide(color: TopicPalette.accentOf(topicCode), width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(label),
      ),
    );
  }
}

/// 練習頁頂端的精簡標題列：App 名稱加一行標語。
///
/// 2026-11-01 前這裡是半個螢幕高的大卡片，裡面「今日重點」「目前路徑」與宣傳標籤
/// 都是寫死的文字，不是學習者的真實資料；目前學習者與年級範圍在下方的
/// [_LearnerSummaryBanner] 已經有了。
class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.strings});

  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    final LayoutSpec layoutSpec = LayoutSpec.of(context);
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
      key: const ValueKey<String>('home_hero_surface'),
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            strings.heroTitle,
            style: textTheme.headlineMedium?.copyWith(
              fontSize: layoutSpec.headingText,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.6,
              color: AppVisualTokens.ink,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            strings.heroSubtitle,
            style: textTheme.bodyMedium?.copyWith(
              color: AppVisualTokens.inkMuted,
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
    this.subtitle,
    this.info,
    required this.icon,
  });

  final String title;

  /// 常駐畫面的短句（例如每日鼓勵語）；說明性的文字請放 [info]。
  final String? subtitle;

  /// 點標題旁 ⓘ 才顯示的說明。
  final String? info;
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
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        style: textTheme.titleLarge?.copyWith(
                          fontSize: layoutSpec.scaleText(20),
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.4,
                        ),
                      ),
                    ),
                    if (info != null) _InfoButton(title: title, body: info!),
                  ],
                ),
                if (subtitle != null && subtitle!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppVisualTokens.inkMuted,
                    ),
                  ),
                ],
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
    this.subtitle,
    this.info,
    required this.child,
    this.trailing,
    this.cardKey,
  });

  final String title;

  /// 常駐畫面的資訊（數據、購買條件等）；說明性的文字請放 [info]。
  final String? subtitle;

  /// 點標題旁 ⓘ 才顯示的說明。
  final String? info;
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
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontSize: layoutSpec.titleText,
                                letterSpacing: -0.3,
                              ),
                        ),
                      ),
                      if (info != null) _InfoButton(title: title, body: info!),
                    ],
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: 12),
                  trailing!,
                ],
              ],
            ),
            if (subtitle != null && subtitle!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF64748B),
                      height: 1.45,
                    ),
              ),
            ],
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

/// 標題旁的 ⓘ：點了在畫面中央開對話框顯示 [body]。
///
/// 說明文字不常駐畫面（2026-11-01 使用者回饋說明佔太多版面），
/// 收進對話框後可以寫得比較完整。
class _InfoButton extends StatelessWidget {
  const _InfoButton({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final AppStrings strings = AppStrings.of(context);
    return IconButton(
      key: ValueKey<String>('info_$title'),
      tooltip: strings.infoTooltip,
      icon: const Icon(Icons.info_outline, size: 20),
      color: AppVisualTokens.inkMuted,
      visualDensity: VisualDensity.compact,
      onPressed: () => showDialog<void>(
        context: context,
        builder: (BuildContext dialogContext) => AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Text(body, style: const TextStyle(height: 1.6)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(strings.gotIt),
            ),
          ],
        ),
      ),
    );
  }
}

/// 卡片左側的主題色細條：只是標記，卡片本體維持白底。
class _TopicAccentStripe extends StatelessWidget {
  const _TopicAccentStripe({required this.topicCode});

  final String topicCode;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      key: ValueKey<String>('topic_accent_$topicCode'),
      color: TopicPalette.accentOf(topicCode),
      child: const SizedBox(width: 5),
    );
  }
}

/// 把內容包成「左側主題色條＋原本的卡片」，圓角與外框不變。
class _TopicAccentFrame extends StatelessWidget {
  const _TopicAccentFrame({
    required this.topicCode,
    required this.decoration,
    required this.padding,
    required this.child,
  });

  final String topicCode;
  final BoxDecoration decoration;
  final EdgeInsetsGeometry padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius =
        (decoration.borderRadius as BorderRadius?) ?? BorderRadius.zero;
    return Container(
      width: double.infinity,
      decoration: decoration,
      child: ClipRRect(
        borderRadius: radius,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _TopicAccentStripe(topicCode: topicCode),
              Expanded(child: Padding(padding: padding, child: child)),
            ],
          ),
        ),
      ),
    );
  }
}

/// 主題名稱的小標籤：白底，文字與外框用主題色。
class _TopicChip extends StatelessWidget {
  const _TopicChip({required this.topicCode, required this.label});

  final String topicCode;
  final String label;

  @override
  Widget build(BuildContext context) {
    final Color accent = TopicPalette.accentOf(topicCode);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: accent, width: 1.5),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: accent,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}
