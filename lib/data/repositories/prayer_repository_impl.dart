import '../../domain/entities/prayer_location.dart';
import '../../domain/repositories/prayer_repository.dart';
import '../datasources/prayer_local_datasource.dart';
import '../models/prayer_location_model.dart';

/// Implementación del repositorio de oraciones
class PrayerRepositoryImpl implements PrayerRepository {
  final PrayerLocalDataSource localDataSource;

  PrayerRepositoryImpl({required this.localDataSource});

  @override
  Future<void> savePrayer(PrayerLocation prayer) async {
    final model = PrayerLocationModel.fromEntity(prayer);
    await localDataSource.savePrayer(model);
  }

  @override
  Future<List<PrayerLocation>> getAllPrayers() async {
    final models = await localDataSource.getAllPrayers();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<PrayerLocation>> getNearbyPrayers(
    double latitude,
    double longitude,
    double radiusInMeters,
  ) async {
    final models = await localDataSource.getNearbyPrayers(
      latitude, longitude, radiusInMeters,
    );
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> deletePrayer(String id) async {
    await localDataSource.deletePrayer(id);
  }

  @override
  Future<int> getPrayerCount() async {
    return await localDataSource.getPrayerCount();
  }

  @override
  Future<PrayerLocation?> getPrayerById(String id) async {
    final model = await localDataSource.getPrayerById(id);
    return model?.toEntity();
  }
}
