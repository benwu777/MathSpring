const Map<String, String> _superscriptMap = <String, String>{
  '0': '⁰',
  '1': '¹',
  '2': '²',
  '3': '³',
  '4': '⁴',
  '5': '⁵',
  '6': '⁶',
  '7': '⁷',
  '8': '⁸',
  '9': '⁹',
  '+': '⁺',
  '-': '⁻',
  '=': '⁼',
  '(': '⁽',
  ')': '⁾',
  'n': 'ⁿ',
  'i': 'ⁱ',
  'x': 'ˣ',
  'y': 'ʸ',
  'z': 'ᶻ',
  'a': 'ᵃ',
  'b': 'ᵇ',
  'c': 'ᶜ',
  'd': 'ᵈ',
  'e': 'ᵉ',
  'f': 'ᶠ',
  'g': 'ᵍ',
  'h': 'ʰ',
  'l': 'ˡ',
  'o': 'ᵒ',
  'j': 'ʲ',
  'k': 'ᵏ',
  'm': 'ᵐ',
  'p': 'ᵖ',
  'r': 'ʳ',
  's': 'ˢ',
  't': 'ᵗ',
  'u': 'ᵘ',
  'v': 'ᵛ',
  'w': 'ʷ',
  ' ': '',
};

final RegExp _numericExponentPattern = RegExp(
  r'(\([^()]+\)|[A-Za-z0-9.π]+)\^([+-]?\d+)',
);
final RegExp _symbolExponentPattern = RegExp(
  r'(\([^()]+\)|[A-Za-z0-9.π]+)\^([A-Za-z])',
);
final RegExp _groupedExponentPattern = RegExp(
  r'(\([^()]+\)|[A-Za-z0-9.π]+)\^\(([^()]+)\)',
);

String normalizeMathText(String text) {
  if (text.isEmpty) {
    return text;
  }

  String normalized = text
      .replaceAll('<=', '≤')
      .replaceAll('>=', '≥');

  normalized = _replaceExponentPattern(normalized, _numericExponentPattern);
  normalized = _replaceExponentPattern(normalized, _symbolExponentPattern);
  normalized = normalized.replaceAllMapped(_groupedExponentPattern, (match) {
    final String base = match.group(1) ?? '';
    final String exponent = match.group(2) ?? '';
    final String superscript = _toSuperscript('($exponent)');
    if (superscript.isEmpty) {
      return match.group(0) ?? '';
    }
    return '$base$superscript';
  });

  return normalized;
}

String _replaceExponentPattern(String text, RegExp pattern) {
  return text.replaceAllMapped(pattern, (match) {
    final String base = match.group(1) ?? '';
    final String exponent = match.group(2) ?? '';
    final String superscript = _toSuperscript(exponent);
    if (superscript.isEmpty) {
      return match.group(0) ?? '';
    }
    return '$base$superscript';
  });
}

String _toSuperscript(String exponent) {
  final StringBuffer buffer = StringBuffer();
  for (final String char in exponent.split('')) {
    final String? mapped =
        _superscriptMap[char] ?? _superscriptMap[char.toLowerCase()];
    if (mapped == null) {
      return '';
    }
    buffer.write(mapped);
  }
  return buffer.toString();
}

/// 題庫文字用 `**…**` 標記需要強調的片段（多半是詳解裡的關鍵數字）。
/// app 沒有 markdown renderer，直接顯示會露出星號，因此由 UI 端拆成片段後自行套字重。
class MathTextSegment {
  const MathTextSegment(this.text, {required this.emphasized});

  final String text;
  final bool emphasized;
}

/// 依 `**` 標記把文字拆成一般片段與強調片段，標記本身不會保留在結果中。
List<MathTextSegment> splitEmphasis(String text) {
  if (!text.contains('**')) {
    return <MathTextSegment>[MathTextSegment(text, emphasized: false)];
  }

  final List<String> parts = text.split('**');
  final List<MathTextSegment> segments = <MathTextSegment>[];
  for (int i = 0; i < parts.length; i++) {
    if (parts[i].isEmpty) {
      continue;
    }
    segments.add(MathTextSegment(parts[i], emphasized: i.isOdd));
  }
  return segments;
}
