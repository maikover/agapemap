import 'package:uuid/uuid.dart';
import '../../domain/entities/prayer_location.dart';
import '../../domain/repositories/prayer_repository.dart';

/// Caso de uso: Guardar oración geolocalizada
class SavePrayerLocation {
  final PrayerRepository repository;
  final Uuid _uuid = const Uuid();

  SavePrayerLocation(this.repository);

  Future<void> call({
    required double latitude,
    required double longitude,
    String? verseText,
    String? verseReference,
    required String prayerText,
    String? emotionId,
  }) async {
    final prayer = PrayerLocation(
      id: _uuid.v4(),
      latitude: latitude,
      longitude: longitude,
      verseText: verseText,
      verseReference: verseReference,
      prayerText: prayerText,
      createdAt: DateTime.now(),
      emotionId: emotionId,
    );

    await repository.savePrayer(prayer);
  }
}

/// Caso de uso: Obtener oraciones cercanas
class GetNearbyPrayers {
  final PrayerRepository repository;

  GetNearbyPrayers(this.repository);

  Future<List<PrayerLocation>> call({
    required double latitude,
    required double longitude,
    double radiusInMeters = 100,
  }) async {
    return await repository.getNearbyPrayers(
      latitude, longitude, radiusInMeters,
    );
  }
}

/// Caso de uso: Obtener todas las oraciones
class GetAllPrayers {
  final PrayerRepository repository;

  GetAllPrayers(this.repository);

  Future<List<PrayerLocation>> call() async {
    return await repository.getAllPrayers();
  }
}

/// Caso de uso: Eliminar oración
class DeletePrayer {
  final PrayerRepository repository;

  DeletePrayer(this.repository);

  Future<void> call(String id) async {
    await repository.deletePrayer(id);
  }
}

/// Caso de uso: Obtener cantidad de oraciones
class GetPrayerCount {
  final PrayerRepository repository;

  GetPrayerCount(this.repository);

  Future<int> call() async {
    return await repository.getPrayerCount();
  }
}
