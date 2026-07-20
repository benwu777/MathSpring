import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class MathSpringDatabase {
  static const String databaseName = 'mathspring.db';
  static const int schemaVersion = 2;

  static Future<Database> openDefault() async {
    final String databasesPath = await getDatabasesPath();
    final String path = p.join(databasesPath, databaseName);
    return openDatabase(
      path,
      version: schemaVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  static Future<Database> openInMemory() {
    return openDatabase(
      inMemoryDatabasePath,
      version: schemaVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    await _createLearnerProfilesTable(db);
    await _createAnswerSessionsTable(db);
    await _createSessionAnswerRecordsTable(db);
    await _createQuestionProgressTable(db);
    await _createAppPreferencesTable(db);
  }

  static Future<void> _onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    if (oldVersion < 2) {
      await _createAnswerSessionsTable(db);
      await _createSessionAnswerRecordsTable(db);
    }
  }

  static Future<void> _createLearnerProfilesTable(Database db) async {
    await db.execute('''
      CREATE TABLE learner_profiles(
        id TEXT PRIMARY KEY,
        display_name TEXT NOT NULL,
        level_stage TEXT NOT NULL,
        challenge_tier TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');
  }

  static Future<void> _createAnswerSessionsTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS answer_sessions(
        id TEXT PRIMARY KEY,
        learner_id TEXT NOT NULL,
        mode TEXT NOT NULL,
        topic_code TEXT NOT NULL,
        level_stage TEXT NOT NULL,
        challenge_tier TEXT NOT NULL,
        started_at TEXT NOT NULL,
        ended_at TEXT NOT NULL,
        elapsed_seconds INTEGER NOT NULL,
        total_questions INTEGER NOT NULL,
        correct_count INTEGER NOT NULL
      )
    ''');
  }

  static Future<void> _createSessionAnswerRecordsTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS session_answer_records(
        session_id TEXT NOT NULL,
        question_id TEXT NOT NULL,
        sequence_number INTEGER NOT NULL,
        submitted_answer TEXT NOT NULL,
        is_correct INTEGER NOT NULL,
        answered_at TEXT NOT NULL,
        PRIMARY KEY (session_id, sequence_number)
      )
    ''');
  }

  static Future<void> _createQuestionProgressTable(Database db) async {
    await db.execute('''
      CREATE TABLE question_progress(
        learner_id TEXT NOT NULL,
        question_id TEXT NOT NULL,
        status TEXT NOT NULL,
        last_result TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        PRIMARY KEY (learner_id, question_id)
      )
    ''');
  }

  static Future<void> _createAppPreferencesTable(Database db) async {
    await db.execute('''
      CREATE TABLE app_preferences(
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL
      )
    ''');
  }
}
