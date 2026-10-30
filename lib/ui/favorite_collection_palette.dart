import 'package:flutter/material.dart';

/// Colors for favorite collections, keyed by the palette keys stored with
/// each collection. Soft fills keep the quiet reading surface; strong colors
/// are used for dots and chip text and read clearly on their soft fill.
class FavoriteCollectionPalette {
  const FavoriteCollectionPalette({required this.soft, required this.strong});

  final Color soft;
  final Color strong;

  static const FavoriteCollectionPalette neutral = FavoriteCollectionPalette(
    soft: Color(0xFFF1F3F1),
    strong: Color(0xFF5E6E69),
  );

  static const Map<String, FavoriteCollectionPalette> _byKey =
      <String, FavoriteCollectionPalette>{
    'sage': FavoriteCollectionPalette(
        soft: Color(0xFFE6EFE7), strong: Color(0xFF4A7556)),
    'teal': FavoriteCollectionPalette(
        soft: Color(0xFFDDF1EE), strong: Color(0xFF17716A)),
    'sky': FavoriteCollectionPalette(
        soft: Color(0xFFE1EDF7), strong: Color(0xFF356A94)),
    'lavender': FavoriteCollectionPalette(
        soft: Color(0xFFECE7F5), strong: Color(0xFF65559A)),
    'rose': FavoriteCollectionPalette(
        soft: Color(0xFFF6E4E8), strong: Color(0xFF9C4A5E)),
    'apricot': FavoriteCollectionPalette(
        soft: Color(0xFFFAE9DC), strong: Color(0xFF9A5829)),
    'sand': FavoriteCollectionPalette(
        soft: Color(0xFFF4EDD6), strong: Color(0xFF766326)),
    'slate': FavoriteCollectionPalette(
        soft: Color(0xFFE6E9EE), strong: Color(0xFF4C5868)),
  };

  static FavoriteCollectionPalette of(String? key) => _byKey[key] ?? neutral;
}
