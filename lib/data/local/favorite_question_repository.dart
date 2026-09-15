import 'package:mathspring/models/favorite_question.dart';
import 'package:sqflite/sqflite.dart';

class FavoriteQuestionRepository {
  const FavoriteQuestionRepository(this._database);
  static const int maxCollections = 6;
  final Database _database;

  Future<List<FavoriteQuestionCollection>> ensureDefaultCollections(
      String learnerId) async {
    final List<FavoriteQuestionCollection> existing =
        await fetchCollections(learnerId);
    if (existing.isNotEmpty) return existing;
    final String now = DateTime.now().toUtc().toIso8601String();
    await _database.insert('favorite_question_collections', <String, Object?>{
      'id': 'favorites_all_$learnerId',
      'learner_id': learnerId,
      'name': 'All favorites',
      'sort_order': 0,
      'is_default': 1,
      'created_at': now,
    });
    return fetchCollections(learnerId);
  }

  Future<List<FavoriteQuestionCollection>> fetchCollections(
          String learnerId) async =>
      (await _database.query('favorite_question_collections',
              where: 'learner_id = ?',
              whereArgs: <Object?>[learnerId],
              orderBy: 'sort_order ASC'))
          .map(FavoriteQuestionCollection.fromMap)
          .toList();

  Future<FavoriteQuestionCollection> createCollection(
      {required String learnerId, required String name}) async {
    final List<FavoriteQuestionCollection> collections =
        await ensureDefaultCollections(learnerId);
    if (collections.length >= maxCollections)
      throw FavoriteCollectionLimitReached(maxCollections);
    final String now = DateTime.now().toUtc().toIso8601String();
    final FavoriteQuestionCollection collection = FavoriteQuestionCollection(
      id: 'favorite_collection_${DateTime.now().toUtc().microsecondsSinceEpoch}',
      learnerId: learnerId,
      name: name.trim(),
      sortOrder: collections.length,
      isDefault: false,
      createdAtIso: now,
    );
    await _database.insert('favorite_question_collections', <String, Object?>{
      'id': collection.id,
      'learner_id': collection.learnerId,
      'name': collection.name,
      'sort_order': collection.sortOrder,
      'is_default': 0,
      'created_at': collection.createdAtIso,
    });
    return collection;
  }

  Future<void> saveFavorite(FavoriteQuestion favorite) async {
    await ensureDefaultCollections(favorite.learnerId);
    await _database.insert('favorite_questions', favorite.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<FavoriteQuestion?> fetchFavorite(
      {required String learnerId, required String questionId}) async {
    final List<Map<String, Object?>> rows = await _database.query(
        'favorite_questions',
        where: 'learner_id = ? AND question_id = ?',
        whereArgs: <Object?>[learnerId, questionId],
        limit: 1);
    return rows.isEmpty ? null : FavoriteQuestion.fromMap(rows.single);
  }

  Future<List<FavoriteQuestion>> fetchFavorites(String learnerId) async =>
      (await _database.query(
        'favorite_questions',
        where: 'learner_id = ?',
        whereArgs: <Object?>[learnerId],
        orderBy: 'updated_at DESC',
      ))
          .map(FavoriteQuestion.fromMap)
          .toList();

  Future<void> updateFavoriteDetails({
    required String learnerId,
    required String questionId,
    required String note,
    required List<String> tags,
  }) async {
    final FavoriteQuestion? favorite = await fetchFavorite(
      learnerId: learnerId,
      questionId: questionId,
    );
    if (favorite == null) return;
    await saveFavorite(FavoriteQuestion(
      learnerId: learnerId,
      questionId: questionId,
      note: note.trim(),
      tags: tags,
      createdAtIso: favorite.createdAtIso,
      updatedAtIso: DateTime.now().toUtc().toIso8601String(),
    ));
  }

  Future<void> addToCollection(
          {required String learnerId,
          required String questionId,
          required String collectionId}) =>
      _database.insert(
          'favorite_question_collection_memberships',
          <String, Object?>{
            'learner_id': learnerId,
            'question_id': questionId,
            'collection_id': collectionId
          },
          conflictAlgorithm: ConflictAlgorithm.ignore);

  Future<void> deleteCollection(FavoriteQuestionCollection collection) async {
    if (collection.isDefault) return;
    await _database.transaction((Transaction transaction) async {
      await transaction.delete('favorite_question_collection_memberships',
          where: 'collection_id = ?', whereArgs: <Object?>[collection.id]);
      await transaction.delete('favorite_question_collections',
          where: 'id = ?', whereArgs: <Object?>[collection.id]);
    });
  }
}

class FavoriteCollectionLimitReached implements Exception {
  const FavoriteCollectionLimitReached(this.maxCollections);
  final int maxCollections;
}
