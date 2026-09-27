import 'package:mathspring/models/favorite_question.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class MathSpringDatabase {
  static const String databaseName = 'mathspring.db';
  static const int schemaVersion = 8;

  static Future<Database> openDefault() async {
    final String databasesPath = await getDatabasesPath();
    final String path = p.join(databasesPath, databaseName);
    return openAtPath(path);
  }

  /// Opens the database at [path], upgrading resiliently if a prior app build
  /// added columns without recording the matching schema version.
  static Future<Database> openAtPath(String path) {
    return openDatabase(
      path,
      version: schemaVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  static Future<Database> openInMemory() {
    return openAtPath(inMemoryDatabasePath);
  }

  static Future<void> _onCreate(Database db, int version) async {
    await _createLearnerProfilesTable(db);
    await _createAnswerSessionsTable(db);
    await _createSessionAnswerRecordsTable(db);
    await _createQuestionProgressTable(db);
    await _createAppPreferencesTable(db);
    await _createFavoriteQuestionTables(db);
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
      await _addColumnIfMissing(
        db,
        table: 'learner_profiles',
        column: 'min_level_stage',
        definition: 'TEXT',
      );
      await _addColumnIfMissing(
        db,
        table: 'learner_profiles',
        column: 'max_level_stage',
        definition: 'TEXT',
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
      await _addColumnIfMissing(
        db,
        table: 'answer_sessions',
        column: 'time_limit_seconds',
        definition: 'INTEGER',
      );
      await _addColumnIfMissing(
        db,
        table: 'answer_sessions',
        column: 'max_score',
        definition: 'INTEGER',
      );
      await _addColumnIfMissing(
        db,
        table: 'answer_sessions',
        column: 'earned_score',
        definition: 'INTEGER',
      );
      await _addColumnIfMissing(
        db,
        table: 'session_answer_records',
        column: 'max_score',
        definition: 'INTEGER',
      );
      await _addColumnIfMissing(
        db,
        table: 'session_answer_records',
        column: 'earned_score',
        definition: 'INTEGER',
      );
    }
    if (oldVersion < 5) {
      for (final String column in <String>[
        'avatar_presentation',
        'avatar_skin_id',
        'avatar_face_id',
        'avatar_hair_id',
        'avatar_eyes_id',
        'avatar_nose_id',
        'avatar_mouth_id',
      ]) {
        await _addColumnIfMissing(
          db,
          table: 'learner_profiles',
          column: column,
          definition: 'TEXT',
        );
      }
    }
    if (oldVersion < 6) {
      for (final String column in <String>[
        'avatar_eye_color_id',
        'avatar_accessory_id',
      ]) {
        await _addColumnIfMissing(
          db,
          table: 'learner_profiles',
          column: column,
          definition: 'TEXT',
        );
      }
    }
    if (oldVersion < 7) await _createFavoriteQuestionTables(db);
    if (oldVersion < 8) await _addFavoriteCollectionColors(db);
  }

  /// Adds collection colors and gives each learner's existing custom
  /// collections palette colors in their display order.
  static Future<void> _addFavoriteCollectionColors(Database db) async {
    await _addColumnIfMissing(
      db,
      table: 'favorite_question_collections',
      column: 'color_key',
      definition: 'TEXT',
    );
    final List<Map<String, Object?>> rows = await db.query(
      'favorite_question_collections',
      columns: <String>['id', 'learner_id'],
      where: 'is_default = 0 AND color_key IS NULL',
      orderBy: 'learner_id, sort_order',
    );
    final Map<String, int> colored = <String, int>{};
    for (final Map<String, Object?> row in rows) {
      final String learnerId = row['learner_id']! as String;
      final int index = colored[learnerId] ?? 0;
      colored[learnerId] = index + 1;
      await db.update(
        'favorite_question_collections',
        <String, Object?>{
          'color_key': FavoriteCollectionColors
              .keys[index % FavoriteCollectionColors.keys.length],
        },
        where: 'id = ?',
        whereArgs: <Object?>[row['id']],
      );
    }
  }

  static Future<void> _addColumnIfMissing(
    Database db, {
    required String table,
    required String column,
    required String definition,
  }) async {
    final List<Map<String, Object?>> columns = await db.rawQuery(
      'PRAGMA table_info($table)',
    );
    final bool exists = columns.any(
      (Map<String, Object?> item) => item['name'] == column,
    );
    if (!exists) {
      await db.execute('ALTER TABLE $table ADD COLUMN $column $definition');
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
        avatar_mouth_id TEXT,
        avatar_eye_color_id TEXT,
        avatar_accessory_id TEXT
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

  static Future<void> _createFavoriteQuestionTables(Database db) async {
    await db
        .execute('''CREATE TABLE IF NOT EXISTS favorite_question_collections(
      id TEXT PRIMARY KEY, learner_id TEXT NOT NULL, name TEXT NOT NULL,
      sort_order INTEGER NOT NULL, is_default INTEGER NOT NULL, created_at TEXT NOT NULL,
      color_key TEXT
    )''');
    await db.execute('''CREATE TABLE IF NOT EXISTS favorite_questions(
      learner_id TEXT NOT NULL, question_id TEXT NOT NULL, note TEXT NOT NULL,
      tags_json TEXT NOT NULL, created_at TEXT NOT NULL, updated_at TEXT NOT NULL,
      PRIMARY KEY (learner_id, question_id)
    )''');
    await db.execute(
        '''CREATE TABLE IF NOT EXISTS favorite_question_collection_memberships(
      learner_id TEXT NOT NULL, question_id TEXT NOT NULL, collection_id TEXT NOT NULL,
      PRIMARY KEY (learner_id, question_id, collection_id)
    )''');
  }
}
