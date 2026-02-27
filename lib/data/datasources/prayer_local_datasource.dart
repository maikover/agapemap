import 'dart:math' as math;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/prayer_location_model.dart';

/// DataSource local para oraciones geolocalizadas (SQLite)
class PrayerLocalDataSource {
  static Database? _database;
  static const String _tableName = 'prayer_locations';
  static const double _defaultRadius = 100; // metros

  /// Obtener instancia de la base de datos
  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  /// Inicializar base de datos
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'agapemap_prayers.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            id TEXT PRIMARY KEY,
            latitude REAL NOT NULL,
            longitude REAL NOT NULL,
            verse_text TEXT,
            verse_reference TEXT,
            prayer_text TEXT NOT NULL,
            created_at TEXT NOT NULL,
            emotion_id TEXT
          )
        ''');
      },
    );
  }

  /// Guardar una oración
  Future<void> savePrayer(PrayerLocationModel prayer) async {
    final db = await database;
    await db.insert(
      _tableName,
      prayer.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Obtener todas las oraciones
  Future<List<PrayerLocationModel>> getAllPrayers() async {
    final db = await database;
    final maps = await db.query(
      _tableName,
      orderBy: 'created_at DESC',
    );
    return maps.map((map) => PrayerLocationModel.fromMap(map)).toList();
  }

  /// Obtener oraciones cercanas (dentro del radio)
  Future<List<PrayerLocationModel>> getNearbyPrayers(
    double latitude,
    double longitude,
    double radiusInMeters,
  ) async {
    final db = await database;
    
    // Calcular bounding box para la query inicial
    final latDelta = radiusInMeters / 111000; // 1 grado ≈ 111km
    final lngDelta = radiusInMeters / (111000 * math.cos(latitude * math.pi / 180));

    final maps = await db.query(
      _tableName,
      where: 'latitude BETWEEN ? AND ? AND longitude BETWEEN ? AND ?',
      whereArgs: [
        latitude - latDelta,
        latitude + latDelta,
        longitude - lngDelta,
        longitude + lngDelta,
      ],
      orderBy: 'created_at DESC',
    );

    // Filtrar por distancia exacta (más preciso)
    final prayers = maps.map((map) => PrayerLocationModel.fromMap(map)).toList();
    
    return prayers.where((prayer) {
      return _calculateDistance(
        latitude, longitude,
        prayer.latitude, prayer.longitude,
      ) <= radiusInMeters;
    }).toList();
  }

  /// Eliminar una oración
  Future<void> deletePrayer(String id) async {
    final db = await database;
    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Obtener cantidad de oraciones
  Future<int> getPrayerCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM $_tableName');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Obtener oración por ID
  Future<PrayerLocationModel?> getPrayerById(String id) async {
    final db = await database;
    final maps = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return PrayerLocationModel.fromMap(maps.first);
  }

  /// Calcular distancia entre dos puntos (fórmula Haversine)
  double _calculateDistance(
    double lat1, double lon1,
    double lat2, double lon2,
  ) {
    const earthRadius = 6371000.0; // metros
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);
    
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(lat1)) * math.cos(_toRadians(lat2)) *
        math.sin(dLon / 2) * math.sin(dLon / 2);
    
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadius * c;
  }

  double _toRadians(double degrees) => degrees * math.pi / 180;

  /// Cerrar base de datos
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
