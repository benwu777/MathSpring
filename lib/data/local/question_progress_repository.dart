import 'package:mathspring/models/question_progress.dart';
import 'package:sqflite/sqflite.dart';

class QuestionProgressRepository {
  const QuestionProgressRepository(this._database);

  final Database _database;

  Future<void> upsert(QuestionProgress progress) {
    return _database.insert(
      'question_progress',
      progress.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<QuestionProgress?> fetchOne({
    required String learnerId,
    required String questionId,
  }) async {
    final List<Map<String, Object?>> rows = await _database.query(
      'question_progress',
      where: 'learner_id = ? AND question_id = ?',
      whereArgs: [learnerId, questionId],
      limit: 1,
    );

    if (rows.isEmpty) {
      return null;
    }

    return QuestionProgress.fromMap(rows.first);
  }

  Future<List<QuestionProgress>> fetchByLearnerId(String learnerId) async {
    final List<Map<String, Object?>> rows = await _database.query(
      'question_progress',
      where: 'learner_id = ?',
      whereArgs: [learnerId],
      orderBy: 'updated_at DESC',
    );
    return rows.map(QuestionProgress.fromMap).toList();
  }

  Future<void> deleteByLearnerId(String learnerId) {
    return _database.delete(
      'question_progress',
      where: 'learner_id = ?',
      whereArgs: [learnerId],
    );
  }
}
