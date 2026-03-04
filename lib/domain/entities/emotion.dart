import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:agapemap/l10n/app_localizations.dart';
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
          color: const Color(0xFF3B82F6), // blue-500
          bibleCategories: ['salmos', 'isaias', 'mateo', 'filipenses'],
          icon: Icons.spa,
          artPattern: ArtPattern.waves,
        ),
        Emotion(
          id: 'anxiety', // Cambiado a ansiedad para el nuevo diseño
          name: (l10n) => 'Ansiedad', // Harcoded temporarily for the design
          description: (l10n) => 'Encuentra calma en la tormenta',
          color: const Color(0xFFF97316), // orange-500
          bibleCategories: ['mateo', 'romanos', 'salmos', 'filipenses'],
          icon: Icons.waves,
          artPattern: ArtPattern.particles,
        ),
        Emotion(
          id: 'strength',
          name: (l10n) => l10n.strength,
          description: (l10n) => l10n.strengthDescription,
          color: const Color(0xFFEF4444), // red-500
          bibleCategories: ['josue', 'salmos', 'efesios', 'hebreos'],
          icon: Icons.fitness_center,
          artPattern: ArtPattern.spiral,
        ),
        Emotion(
          id: 'renewal',
          name: (l10n) => l10n.renewal,
          description: (l10n) => l10n.renewalDescription,
          color: const Color(0xFF10B981), // emerald-500
          bibleCategories: ['2corintios', 'romanos', 'ezequiel', 'salmos'],
          icon: Icons.water_drop,
          artPattern: ArtPattern.mandala,
        ),
        Emotion(
          id: 'wisdom',
          name: (l10n) => l10n.wisdom,
          description: (l10n) => l10n.wisdomDescription,
          color: const Color(0xFFA855F7), // purple-500
          bibleCategories: ['proverbios', 'salmos', '1reyes', 'sabiduria'],
          icon: Icons.lightbulb,
          artPattern: ArtPattern.spiral,
        ),
        Emotion(
          id: 'holiness',
          name: (l10n) => l10n.holiness,
          description: (l10n) => l10n.holinessDescription,
          color: const Color(0xFFEAB308), // yellow-500
          bibleCategories: ['hebreos', '1juan', '1pedro', 'salmos'],
          icon: Icons.auto_awesome,
          artPattern: ArtPattern.mandala,
        ),
      ];

  static Emotion getById(String id) {
    if (id == 'redemption') {
      return all.firstWhere((e) => e.id == 'anxiety'); // Fallback for old saves
    }
    return all.firstWhere(
      (e) => e.id == id,
      orElse: () => all.first,
    );
  }
}
