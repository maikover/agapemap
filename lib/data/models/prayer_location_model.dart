import '../../domain/entities/prayer_location.dart';

/// Modelo para base de datos local
class PrayerLocationModel extends PrayerLocation {
  const PrayerLocationModel({
    required super.id,
    required super.latitude,
    required super.longitude,
    super.verseText,
    super.verseReference,
    required super.prayerText,
    required super.createdAt,
    super.emotionId,
  });

  /// Crear desde entidad
  factory PrayerLocationModel.fromEntity(PrayerLocation entity) {
    return PrayerLocationModel(
      id: entity.id,
      latitude: entity.latitude,
      longitude: entity.longitude,
      verseText: entity.verseText,
      verseReference: entity.verseReference,
      prayerText: entity.prayerText,
      createdAt: entity.createdAt,
      emotionId: entity.emotionId,
    );
  }

  /// Crear desde DB
  factory PrayerLocationModel.fromMap(Map<String, dynamic> map) {
    return PrayerLocationModel(
      id: map['id'] as String,
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
      verseText: map['verse_text'] as String?,
      verseReference: map['verse_reference'] as String?,
      prayerText: map['prayer_text'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      emotionId: map['emotion_id'] as String?,
    );
  }

  /// Convertir a Map para DB
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'verse_text': verseText,
      'verse_reference': verseReference,
      'prayer_text': prayerText,
      'created_at': createdAt.toIso8601String(),
      'emotion_id': emotionId,
    };
  }

  /// Convertir a entidad
  PrayerLocation toEntity() {
    return PrayerLocation(
      id: id,
      latitude: latitude,
      longitude: longitude,
      verseText: verseText,
      verseReference: verseReference,
      prayerText: prayerText,
      createdAt: createdAt,
      emotionId: emotionId,
    );
  }
}
