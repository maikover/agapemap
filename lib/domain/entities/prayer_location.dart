import 'package:equatable/equatable.dart';

/// Entidad: Oración geolocalizada
class PrayerLocation extends Equatable {
  final String id;
  final double latitude;
  final double longitude;
  final String? verseText;
  final String? verseReference;
  final String prayerText;
  final DateTime createdAt;
  final String? emotionId;

  const PrayerLocation({
    required this.id,
    required this.latitude,
    required this.longitude,
    this.verseText,
    this.verseReference,
    required this.prayerText,
    required this.createdAt,
    this.emotionId,
  });

  @override
  List<Object?> get props => [
        id,
        latitude,
        longitude,
        verseText,
        prayerText,
        createdAt,
      ];
}
