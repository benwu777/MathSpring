import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mathspring/ui/topic_palette.dart';

double _contrastOnWhite(Color c) {
  double channel(double v) =>
      v <= 0.03928 ? v / 12.92 : math.pow((v + 0.055) / 1.055, 2.4).toDouble();
  final double l =
      0.2126 * channel(c.r) + 0.7152 * channel(c.g) + 0.0722 * channel(c.b);
  return 1.05 / (l + 0.05);
}

void main() {
  const Map<String, Color> expected = <String, Color>{
    'geometry': Color(0xFF1F5FBF),
    'arithmetic': Color(0xFF1E7F4F),
    'algebra': Color(0xFFB0306A),
    'logic': Color(0xFFA86200),
    'combinatorics': Color(0xFF6B3FB3),
    'number_theory': Color(0xFF0E7C86),
    'mixed': Color(0xFF4A5D7A),
  };

  test('every topic has its own accent colour', () {
    expected.forEach((String code, Color color) {
      expect(TopicPalette.accentOf(code), color, reason: code);
    });
    expect(expected.values.toSet().length, expected.length);
  });

  test('an unknown topic falls back to the mixed colour', () {
    expect(TopicPalette.accentOf('probability'), expected['mixed']);
    expect(TopicPalette.accentOf(null), expected['mixed']);
  });

  test('every accent stays readable as text on white (WCAG AA 4.5:1)', () {
    for (final String code in expected.keys) {
      expect(_contrastOnWhite(TopicPalette.accentOf(code)),
          greaterThanOrEqualTo(4.5),
          reason: '$code 的主題色太淡，當標籤文字會看不清楚');
    }
  });
}
