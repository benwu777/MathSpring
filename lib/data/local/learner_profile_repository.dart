import 'package:mathspring/models/learner_profile.dart';
import 'package:sqflite/sqflite.dart';

class LearnerProfileRepository {
  const LearnerProfileRepository(this._database);

  final Database _database;

  Future<void> save(LearnerProfile profile) {
    return _database.insert(
      'learner_profiles',
      profile.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<LearnerProfile>> fetchAll() async {
    final List<Map<String, Object?>> rows = await _database.query(
      'learner_profiles',
      orderBy: 'created_at ASC',
    );
    return rows.map(LearnerProfile.fromMap).toList();
  }

  Future<void> deleteById(String learnerId) {
    return _database.delete(
      'learner_profiles',
      where: 'id = ?',
      whereArgs: [learnerId],
    );
  }
}
