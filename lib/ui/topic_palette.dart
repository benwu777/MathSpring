import 'package:flutter/material.dart';

/// Accent colour per maths topic, used only for small marks — the thin stripe
/// on a card's left edge, a topic chip's text and border, a topic badge's
/// outline. Each colour must stay readable as text on white (≥ 4.5:1); the
/// palette test enforces that.
abstract final class TopicPalette {
  static const Color mixed = Color(0xFF4A5D7A);

  static const Map<String, Color> _byCode = <String, Color>{
    'geometry': Color(0xFF1F5FBF),
    'arithmetic': Color(0xFF1E7F4F),
    'algebra': Color(0xFFB0306A),
    'logic': Color(0xFFA86200),
    'combinatorics': Color(0xFF6B3FB3),
    'number_theory': Color(0xFF0E7C86),
    'mixed': mixed,
  };

  static Color accentOf(String? topicCode) => _byCode[topicCode] ?? mixed;
}
