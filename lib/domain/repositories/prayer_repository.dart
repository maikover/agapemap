import '../../domain/entities/prayer_location.dart';

/// Interfaz del repositorio de oraciones
abstract class PrayerRepository {
  /// Guardar una oración
  Future<void> savePrayer(PrayerLocation prayer);
  
  /// Obtener todas las oraciones
  Future<List<PrayerLocation>> getAllPrayers();
  
  /// Obtener oraciones cercanas
  Future<List<PrayerLocation>> getNearbyPrayers(
    double latitude,
    double longitude,
    double radiusInMeters,
  );
  
  /// Eliminar una oración
  Future<void> deletePrayer(String id);
  
  /// Obtener cantidad de oraciones
  Future<int> getPrayerCount();
  
  /// Obtener oración por ID
  Future<PrayerLocation?> getPrayerById(String id);
}
