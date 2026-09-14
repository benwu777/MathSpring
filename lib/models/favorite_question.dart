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
  });

  final String id;
  final String learnerId;
  final String name;
  final int sortOrder;
  final bool isDefault;
  final String createdAtIso;

  factory FavoriteQuestionCollection.fromMap(Map<String, Object?> map) =>
      FavoriteQuestionCollection(
        id: map['id']! as String,
        learnerId: map['learner_id']! as String,
        name: map['name']! as String,
        sortOrder: map['sort_order']! as int,
        isDefault: (map['is_default']! as int) == 1,
        createdAtIso: map['created_at']! as String,
      );
}
