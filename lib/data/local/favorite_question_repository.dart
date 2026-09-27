import 'package:mathspring/models/favorite_question.dart';
import 'package:sqflite/sqflite.dart';

class FavoriteQuestionRepository {
  const FavoriteQuestionRepository(this._database);
  static const int maxCustomCollections = 5;
  static const int maxCollections = maxCustomCollections + 1;
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

  Future<FavoriteQuestionCollection> createCollection({
    required String learnerId,
    required String name,
    String? colorKey,
  }) async {
    final List<FavoriteQuestionCollection> collections =
        await ensureDefaultCollections(learnerId);
    final String validName = validateFavoriteCollectionName(name,
        existingNames:
            collections.map((FavoriteQuestionCollection c) => c.name));
    if (collections.length >= maxCollections)
      throw FavoriteCollectionLimitReached(maxCollections);
    final String now = DateTime.now().toUtc().toIso8601String();
    final FavoriteQuestionCollection collection = FavoriteQuestionCollection(
      id: 'favorite_collection_${DateTime.now().toUtc().microsecondsSinceEpoch}',
      learnerId: learnerId,
      name: validName,
      sortOrder: collections.length,
      isDefault: false,
      createdAtIso: now,
      colorKey: colorKey ?? nextFavoriteCollectionColor(collections),
    );
    await _database.insert('favorite_question_collections', <String, Object?>{
      'id': collection.id,
      'learner_id': collection.learnerId,
      'name': collection.name,
      'sort_order': collection.sortOrder,
      'is_default': 0,
      'created_at': collection.createdAtIso,
      'color_key': collection.colorKey,
    });
    return collection;
  }

  Future<void> updateCollection({
    required FavoriteQuestionCollection collection,
    required String name,
    required String colorKey,
  }) async {
    if (collection.isDefault) return;
    final String validName = validateFavoriteCollectionName(name,
        existingNames: (await fetchCollections(collection.learnerId))
            .where((FavoriteQuestionCollection c) => c.id != collection.id)
            .map((FavoriteQuestionCollection c) => c.name));
    await _database.update(
      'favorite_question_collections',
      <String, Object?>{'name': validName, 'color_key': colorKey},
      where: 'id = ?',
      whereArgs: <Object?>[collection.id],
    );
  }

  /// Question counts keyed by collection id, including all favorites.
  Future<Map<String, int>> fetchCollectionCounts(String learnerId) async {
    final List<Map<String, Object?>> rows = await _database.rawQuery(
      'SELECT collection_id, COUNT(*) AS total '
      'FROM favorite_question_collection_memberships '
      'WHERE learner_id = ? GROUP BY collection_id',
      <Object?>[learnerId],
    );
    final int all = Sqflite.firstIntValue(await _database.rawQuery(
          'SELECT COUNT(*) FROM favorite_questions WHERE learner_id = ?',
          <Object?>[learnerId],
        )) ??
        0;
    return <String, int>{
      'favorites_all_$learnerId': all,
      for (final Map<String, Object?> row in rows)
        row['collection_id']! as String: row['total']! as int,
    };
  }

  Future<List<String>> fetchUsedTags(String learnerId) async =>
      rankFavoriteTags(await fetchFavorites(learnerId));

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

  Future<List<FavoriteQuestion>> fetchFavoritesInCollection({
    required String learnerId,
    required String collectionId,
  }) async {
    if (collectionId == 'favorites_all_$learnerId') {
      return fetchFavorites(learnerId);
    }
    return (await _database.rawQuery('''
      SELECT favorite_questions.* FROM favorite_questions
      INNER JOIN favorite_question_collection_memberships memberships
        ON memberships.learner_id = favorite_questions.learner_id
        AND memberships.question_id = favorite_questions.question_id
      WHERE favorite_questions.learner_id = ? AND memberships.collection_id = ?
      ORDER BY favorite_questions.updated_at DESC
    ''', <Object?>[learnerId, collectionId]))
        .map(FavoriteQuestion.fromMap)
        .toList();
  }

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
      note: normalizeFavoriteNote(note),
      tags: normalizeFavoriteTags(tags),
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

  Future<Set<String>> fetchCollectionIdsForFavorite({
    required String learnerId,
    required String questionId,
  }) async {
    final List<Map<String, Object?>> rows = await _database.query(
      'favorite_question_collection_memberships',
      columns: <String>['collection_id'],
      where: 'learner_id = ? AND question_id = ?',
      whereArgs: <Object?>[learnerId, questionId],
    );
    return rows
        .map((Map<String, Object?> row) => row['collection_id']! as String)
        .toSet();
  }

  Future<void> removeFromCollection({
    required String learnerId,
    required String questionId,
    required String collectionId,
  }) =>
      _database.delete('favorite_question_collection_memberships',
          where: 'learner_id = ? AND question_id = ? AND collection_id = ?',
          whereArgs: <Object?>[learnerId, questionId, collectionId]);

  Future<void> deleteFavorite({
    required String learnerId,
    required String questionId,
  }) async {
    await _database.transaction((Transaction transaction) async {
      await transaction.delete('favorite_question_collection_memberships',
          where: 'learner_id = ? AND question_id = ?',
          whereArgs: <Object?>[learnerId, questionId]);
      await transaction.delete('favorite_questions',
          where: 'learner_id = ? AND question_id = ?',
          whereArgs: <Object?>[learnerId, questionId]);
    });
  }

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

enum FavoriteCollectionNameProblem { empty, tooLong, duplicate }

class FavoriteCollectionNameInvalid implements Exception {
  const FavoriteCollectionNameInvalid(this.reason);
  final FavoriteCollectionNameProblem reason;
}

const int maxFavoriteCollectionNameLength = 20;

/// Returns the trimmed [name], or throws when it is blank, too long or
/// already used by one of [existingNames].
String validateFavoriteCollectionName(String name,
    {required Iterable<String> existingNames}) {
  final String trimmed = name.trim();
  if (trimmed.isEmpty) {
    throw const FavoriteCollectionNameInvalid(
        FavoriteCollectionNameProblem.empty);
  }
  if (trimmed.runes.length > maxFavoriteCollectionNameLength) {
    throw const FavoriteCollectionNameInvalid(
        FavoriteCollectionNameProblem.tooLong);
  }
  if (existingNames.contains(trimmed)) {
    throw const FavoriteCollectionNameInvalid(
        FavoriteCollectionNameProblem.duplicate);
  }
  return trimmed;
}

String nextFavoriteCollectionColor(
        List<FavoriteQuestionCollection> collections) =>
    FavoriteCollectionColors.next(collections
        .where((FavoriteQuestionCollection c) => !c.isDefault)
        .map((FavoriteQuestionCollection c) => c.colorKey));

/// Ranks tags by use count. [favorites] must be ordered newest first, so ties
/// keep the most recently used tag first.
List<String> rankFavoriteTags(List<FavoriteQuestion> favorites) {
  final Map<String, int> counts = <String, int>{};
  for (final FavoriteQuestion favorite in favorites) {
    for (final String tag in favorite.tags) {
      counts[tag] = (counts[tag] ?? 0) + 1;
    }
  }
  final List<String> firstSeen = counts.keys.toList();
  return firstSeen.toList()
    ..sort((String a, String b) {
      final int byCount = counts[b]!.compareTo(counts[a]!);
      return byCount != 0
          ? byCount
          : firstSeen.indexOf(a).compareTo(firstSeen.indexOf(b));
    });
}
