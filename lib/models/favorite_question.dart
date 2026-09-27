import 'dart:convert';

class FavoriteQuestion {
  const FavoriteQuestion({
    required this.learnerId,
    required this.questionId,
    required this.note,
    required this.tags,
    required this.createdAtIso,
    required this.updatedAtIso,
  });

  final String learnerId;
  final String questionId;
  final String note;
  final List<String> tags;
  final String createdAtIso;
  final String updatedAtIso;

  Map<String, Object?> toMap() => <String, Object?>{
        'learner_id': learnerId,
        'question_id': questionId,
        'note': note,
        'tags_json': jsonEncode(tags),
        'created_at': createdAtIso,
        'updated_at': updatedAtIso,
      };

  factory FavoriteQuestion.fromMap(Map<String, Object?> map) =>
      FavoriteQuestion(
        learnerId: map['learner_id']! as String,
        questionId: map['question_id']! as String,
        note: map['note']! as String,
        tags: List<String>.from(jsonDecode(map['tags_json']! as String)),
        createdAtIso: map['created_at']! as String,
        updatedAtIso: map['updated_at']! as String,
      );
}

class FavoriteQuestionCollection {
  const FavoriteQuestionCollection({
    required this.id,
    required this.learnerId,
    required this.name,
    required this.sortOrder,
    required this.isDefault,
    required this.createdAtIso,
    this.colorKey,
  });

  final String id;
  final String learnerId;
  final String name;
  final int sortOrder;
  final bool isDefault;
  final String createdAtIso;

  /// Palette key from [FavoriteCollectionColors]; null for all favorites.
  final String? colorKey;

  factory FavoriteQuestionCollection.fromMap(Map<String, Object?> map) =>
      FavoriteQuestionCollection(
        id: map['id']! as String,
        learnerId: map['learner_id']! as String,
        name: map['name']! as String,
        sortOrder: map['sort_order']! as int,
        isDefault: (map['is_default']! as int) == 1,
        createdAtIso: map['created_at']! as String,
        colorKey: map['color_key'] as String?,
      );
}

class FavoriteCollectionColors {
  const FavoriteCollectionColors._();

  static const List<String> keys = <String>[
    'sage',
    'teal',
    'sky',
    'lavender',
    'rose',
    'apricot',
    'sand',
    'slate',
  ];

  /// The first palette color no existing collection uses, cycling once all
  /// eight are taken.
  static String next(Iterable<String?> usedKeys) {
    final List<String?> used = usedKeys.toList();
    for (final String key in keys) {
      if (!used.contains(key)) return key;
    }
    return keys[used.length % keys.length];
  }
}

const int maxFavoriteTags = 8;
const int maxFavoriteTagLength = 12;
const int maxFavoriteNoteLength = 200;

List<String> normalizeFavoriteTags(Iterable<String> tags) {
  final List<String> normalized = <String>[];
  for (final String tag in tags) {
    final String trimmed = _truncate(tag.trim(), maxFavoriteTagLength);
    if (trimmed.isEmpty || normalized.contains(trimmed)) continue;
    normalized.add(trimmed);
    if (normalized.length == maxFavoriteTags) break;
  }
  return normalized;
}

String normalizeFavoriteNote(String note) =>
    _truncate(note.trim(), maxFavoriteNoteLength);

String _truncate(String text, int maxLength) =>
    String.fromCharCodes(text.runes.take(maxLength));
