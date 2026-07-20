import 'package:mathspring/models/answer_session.dart';
import 'package:mathspring/models/session_answer_record.dart';
import 'package:sqflite/sqflite.dart';

class AnswerSessionRepository {
  const AnswerSessionRepository(this._database);

  final Database _database;

  Future<void> saveSession({
    required AnswerSession session,
    required List<SessionAnswerRecord> records,
  }) async {
    await _database.transaction((transaction) async {
      await transaction.insert(
        'answer_sessions',
        session.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      await transaction.delete(
        'session_answer_records',
        where: 'session_id = ?',
        whereArgs: [session.id],
      );
      for (final SessionAnswerRecord record in records) {
        await transaction.insert(
          'session_answer_records',
          record.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }

  Future<List<AnswerSession>> fetchByLearnerId(String learnerId) async {
    final List<Map<String, Object?>> rows = await _database.query(
      'answer_sessions',
      where: 'learner_id = ?',
      whereArgs: [learnerId],
      orderBy: 'ended_at DESC',
    );
    return rows.map(AnswerSession.fromMap).toList();
  }

  Future<List<SessionAnswerRecord>> fetchAnswerRecords(String sessionId) async {
    final List<Map<String, Object?>> rows = await _database.query(
      'session_answer_records',
      where: 'session_id = ?',
      whereArgs: [sessionId],
      orderBy: 'sequence_number ASC',
    );
    return rows.map(SessionAnswerRecord.fromMap).toList();
  }

  Future<void> deleteAnswerRecordsByLearnerId(String learnerId) {
    return _database.delete(
      'session_answer_records',
      where: 'session_id IN (SELECT id FROM answer_sessions WHERE learner_id = ?)',
      whereArgs: [learnerId],
    );
  }

  Future<void> deleteSessionsByLearnerId(String learnerId) {
    return _database.delete(
      'answer_sessions',
      where: 'learner_id = ?',
      whereArgs: [learnerId],
    );
  }
}
