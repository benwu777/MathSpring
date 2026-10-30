part of '../main.dart';

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final LayoutSpec layoutSpec = LayoutSpec.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: const Color(0xFF4B5563),
          fontSize: layoutSpec.captionText,
        ),
      ),
    );
  }
}

/// 題庫文字用 `**…**` 標記強調片段。app 沒有 markdown renderer，
/// 這裡把標記拆掉、改用字重呈現，避免星號直接顯示在畫面上。
Text _emphasisText(
  String text, {
  required TextStyle? style,
  required FontWeight emphasisWeight,
  TextAlign? textAlign,
}) {
  final List<MathTextSegment> segments = splitEmphasis(normalizeMathText(text));
  if (segments.length == 1 && !segments.single.emphasized) {
    return Text(
      segments.single.text,
      softWrap: true,
      textAlign: textAlign,
      style: style,
    );
  }
  return Text.rich(
    TextSpan(
      children: <InlineSpan>[
        for (final MathTextSegment segment in segments)
          TextSpan(
            text: segment.text,
            style: segment.emphasized
                ? (style ?? const TextStyle())
                    .copyWith(fontWeight: emphasisWeight)
                : style,
          ),
      ],
    ),
    softWrap: true,
    textAlign: textAlign,
    style: style,
  );
}

class _QuestionPromptText extends StatelessWidget {
  const _QuestionPromptText({
    super.key,
    required this.text,
    required this.localeCode,
  });

  final String text;
  final String localeCode;

  @override
  Widget build(BuildContext context) {
    final bool denseScript = _isDenseScriptLocale(localeCode);
    // 題幹用 promptText（18 / 21 / 22）。選項走 bodyText（15 / 17 / 18），
    // 三級都比題幹小，維持「選項略小於題幹」的關係。
    return _emphasisText(
      text,
      emphasisWeight: FontWeight.w800,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontSize: LayoutSpec.of(context).promptText,
            height: denseScript ? 1.65 : 1.5,
            fontWeight: FontWeight.w600,
            color: AppVisualTokens.ink,
          ),
    );
  }
}

class _QuestionBodyText extends StatelessWidget {
  const _QuestionBodyText({
    required this.text,
    required this.localeCode,
  });

  final String text;
  final String localeCode;

  @override
  Widget build(BuildContext context) {
    final LayoutSpec layoutSpec = LayoutSpec.of(context);
    final bool denseScript = _isDenseScriptLocale(localeCode);
    return _emphasisText(
      text,
      emphasisWeight: FontWeight.w700,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: layoutSpec.bodyText,
            height: denseScript ? 1.7 : 1.55,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF34423E),
          ),
    );
  }
}

class _QuestionSourceText extends StatelessWidget {
  const _QuestionSourceText({
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    final LayoutSpec layoutSpec = LayoutSpec.of(context);
    return Text(
      '${AppStrings.of(context).questionSourcePrefix}$text',
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: layoutSpec.scaleText(12),
            height: 1.5,
            color: AppVisualTokens.inkMuted,
            fontWeight: FontWeight.w500,
          ),
    );
  }
}

class _QuestionOptionText extends StatelessWidget {
  const _QuestionOptionText({
    super.key,
    required this.text,
    required this.localeCode,
  });

  final String text;
  final String localeCode;

  @override
  Widget build(BuildContext context) {
    final LayoutSpec layoutSpec = LayoutSpec.of(context);
    final bool denseScript = _isDenseScriptLocale(localeCode);
    return _emphasisText(
      text,
      textAlign: TextAlign.left,
      emphasisWeight: FontWeight.w700,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontSize: layoutSpec.bodyText,
            height: denseScript ? 1.6 : 1.45,
            fontWeight: FontWeight.w400,
            color: AppVisualTokens.ink,
          ),
    );
  }
}
