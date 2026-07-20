import 'package:sqflite/sqflite.dart';

class AppPreferencesRepository {
  const AppPreferencesRepository(this._database);

  final Database _database;

  Future<void> setValue(String key, String value) {
    return _database.insert(
      'app_preferences',
      {
        'key': key,
        'value': value,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getValue(String key) async {
    final List<Map<String, Object?>> rows = await _database.query(
      'app_preferences',
      where: 'key = ?',
      whereArgs: [key],
      limit: 1,
    );

    if (rows.isEmpty) {
      return null;
    }

    return rows.first['value'] as String;
  }
}
