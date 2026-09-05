import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class MathSpringDatabase {
  static const String databaseName = 'mathspring.db';
  static const int schemaVersion = 5;

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
    if (oldVersion < 3) {
      await db.execute(
        'ALTER TABLE learner_profiles ADD COLUMN min_level_stage TEXT',
      );
      await db.execute(
        'ALTER TABLE learner_profiles ADD COLUMN max_level_stage TEXT',
      );
      await db.execute('''
        UPDATE learner_profiles
        SET
          min_level_stage = COALESCE(
            min_level_stage,
            CASE level_stage
              WHEN 'grade2' THEN 'grade1'
              WHEN 'grade4' THEN 'grade3'
              WHEN 'grade6' THEN 'grade5'
              ELSE level_stage
            END
          ),
          max_level_stage = COALESCE(
            max_level_stage,
            CASE level_stage
              WHEN 'grade2' THEN 'grade2'
              WHEN 'grade4' THEN 'grade4'
              WHEN 'grade6' THEN 'grade6'
              ELSE level_stage
            END
          )
      ''');
    }
    if (oldVersion < 4) {
      await db.execute(
        'ALTER TABLE answer_sessions ADD COLUMN time_limit_seconds INTEGER',
      );
      await db.execute('ALTER TABLE answer_sessions ADD COLUMN max_score INTEGER');
      await db.execute(
        'ALTER TABLE answer_sessions ADD COLUMN earned_score INTEGER',
      );
      await db.execute(
        'ALTER TABLE session_answer_records ADD COLUMN max_score INTEGER',
      );
      await db.execute(
        'ALTER TABLE session_answer_records ADD COLUMN earned_score INTEGER',
      );
    }
    if (oldVersion < 5) {
      await db.execute(
        'ALTER TABLE learner_profiles ADD COLUMN avatar_presentation TEXT',
      );
      await db.execute(
        'ALTER TABLE learner_profiles ADD COLUMN avatar_skin_id TEXT',
      );
      await db.execute(
        'ALTER TABLE learner_profiles ADD COLUMN avatar_face_id TEXT',
      );
      await db.execute(
        'ALTER TABLE learner_profiles ADD COLUMN avatar_hair_id TEXT',
      );
      await db.execute(
        'ALTER TABLE learner_profiles ADD COLUMN avatar_eyes_id TEXT',
      );
      await db.execute(
        'ALTER TABLE learner_profiles ADD COLUMN avatar_nose_id TEXT',
      );
      await db.execute(
        'ALTER TABLE learner_profiles ADD COLUMN avatar_mouth_id TEXT',
      );
    }
  }

  static Future<void> _createLearnerProfilesTable(Database db) async {
    await db.execute('''
      CREATE TABLE learner_profiles(
        id TEXT PRIMARY KEY,
        display_name TEXT NOT NULL,
        level_stage TEXT NOT NULL,
        min_level_stage TEXT NOT NULL,
        max_level_stage TEXT NOT NULL,
        challenge_tier TEXT NOT NULL,
        created_at TEXT NOT NULL,
        avatar_presentation TEXT,
        avatar_skin_id TEXT,
        avatar_face_id TEXT,
        avatar_hair_id TEXT,
        avatar_eyes_id TEXT,
        avatar_nose_id TEXT,
        avatar_mouth_id TEXT
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
        correct_count INTEGER NOT NULL,
        time_limit_seconds INTEGER,
        max_score INTEGER,
        earned_score INTEGER
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
        max_score INTEGER,
        earned_score INTEGER,
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
