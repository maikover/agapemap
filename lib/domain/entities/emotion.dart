import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../core/constants/art_pattern.dart';

/// Entidad de dominio: Emoción bíblica
class Emotion extends Equatable {
  final String id;
  final String Function(AppLocalizations) name;
  final String Function(AppLocalizations) description;
  final Color color;
  final List<String> bibleCategories;
  final IconData icon;
  final ArtPattern artPattern;
  
  const Emotion({
    required this.id,
    required this.name,
    required this.description,
    required this.color,
    required this.bibleCategories,
    required this.icon,
    this.artPattern = ArtPattern.mandala,
  });
  
  /// Obtener nombre en el idioma actual
  String getName(AppLocalizations l10n) => name(l10n);
  
  /// Obtener descripción en el idioma actual
  String getDescription(AppLocalizations l10n) => description(l10n);
  
  @override
  List<Object?> get props => [id, color, bibleCategories];
}

/// Emociones predefinidas
class Emotions {
  static List<Emotion> get all => [
    Emotion(
      id: 'peace',
      name: (l10n) => l10n.peace,
      description: (l10n) => l10n.peaceDescription,
      color: const Color(0xFF4A90D9),
      bibleCategories: ['salmos', 'isaias', 'mateo', 'filipenses'],
      icon: Icons.water_drop,
      artPattern: ArtPattern.waves, // Ondas suaves para paz
    ),
    Emotion(
      id: 'redemption',
      name: (l10n) => l10n.redemption,
      description: (l10n) => l10n.redemptionDescription,
      color: const Color(0xFFE57373),
      bibleCategories: ['mateo', 'romanos', '2corintios', 'galatas'],
      icon: Icons.favorite,
      artPattern: ArtPattern.particles, // Partículas para redención
    ),
    Emotion(
      id: 'strength',
      name: (l10n) => l10n.strength,
      description: (l10n) => l10n.strengthDescription,
      color: const Color(0xFFFFB74D),
      bibleCategories: ['josue', 'salmos', 'efesios', 'hebreos'],
      icon: Icons.local_fire_department,
      artPattern: ArtPattern.spiral, // Espiral dinámica para fortaleza
    ),
    Emotion(
      id: 'renewal',
      name: (l10n) => l10n.renewal,
      description: (l10n) => l10n.renewalDescription,
      color: const Color(0xFF81C784),
      bibleCategories: ['2corintios', 'romanos', 'ezequiel', 'salmos'],
      icon: Icons.eco,
      artPattern: ArtPattern.mandala, // Mandala para renovación
    ),
    Emotion(
      id: 'wisdom',
      name: (l10n) => l10n.wisdom,
      description: (l10n) => l10n.wisdomDescription,
      color: const Color(0xFFBA68C8),
      bibleCategories: ['proverbios', 'salmos', '1reyes', 'sabiduria'],
      icon: Icons.lightbulb,
      artPattern: ArtPattern.spiral, // Espiral para sabiduría
    ),
    Emotion(
      id: 'holiness',
      name: (l10n) => l10n.holiness,
      description: (l10n) => l10n.holinessDescription,
      color: const Color(0xFFF5F5F5),
      bibleCategories: ['hebreos', '1juan', '1pedro', 'salmos'],
      icon: Icons.auto_awesome,
      artPattern: ArtPattern.mandala, // Mandala para santidad
    ),
  ];
  
  static Emotion getById(String id) {
    return all.firstWhere(
      (e) => e.id == id,
      orElse: () => all.first,
    );
  }
}
