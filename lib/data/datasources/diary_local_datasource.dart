import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/saved_verse_model.dart';

/// DataSource local para el diario (SQLite)
class DiaryLocalDataSource {
  static Database? _database;
  static const String _tableName = 'saved_verses';

  /// Obtener instancia de la base de datos
  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  /// Inicializar base de datos
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'agapemap.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            id TEXT PRIMARY KEY,
            verse_id TEXT NOT NULL,
            book TEXT NOT NULL,
            chapter INTEGER NOT NULL,
            verse INTEGER NOT NULL,
            text TEXT NOT NULL,
            emotion_id TEXT NOT NULL,
            saved_at TEXT NOT NULL,
            note TEXT
          )
        ''');
      },
    );
  }

  /// Guardar un versículo
  Future<void> saveVerse(SavedVerseModel verse) async {
    final db = await database;
    await db.insert(
      _tableName,
      verse.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Obtener todos los versículos guardados
  Future<List<SavedVerseModel>> getSavedVerses() async {
    final db = await database;
    final maps = await db.query(
      _tableName,
      orderBy: 'saved_at DESC',
    );
    return maps.map((map) => SavedVerseModel.fromMap(map)).toList();
  }

  /// Obtener un versículo por ID
  Future<SavedVerseModel?> getVerseById(String id) async {
    final db = await database;
    final maps = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return SavedVerseModel.fromMap(maps.first);
  }

  /// Eliminar un versículo
  Future<void> deleteVerse(String id) async {
    final db = await database;
    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Actualizar nota de un versículo
  Future<void> updateNote(String id, String note) async {
    final db = await database;
    await db.update(
      _tableName,
      {'note': note},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Obtener count de versículos guardados
  Future<int> getSavedCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM $_tableName');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Obtener versículos por emoción
  Future<List<SavedVerseModel>> getVersesByEmotion(String emotionId) async {
    final db = await database;
    final maps = await db.query(
      _tableName,
      where: 'emotion_id = ?',
      whereArgs: [emotionId],
      orderBy: 'saved_at DESC',
    );
    return maps.map((map) => SavedVerseModel.fromMap(map)).toList();
  }

  /// Cerrar base de datos
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
