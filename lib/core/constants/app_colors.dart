import 'package:flutter/material.dart';

/// Colores bíblicos para el sistema de emociones
class AppColors {
  // Colores primarios (emociones bíblicas)
  static const Color peaceBlue = Color(0xFF4A90D9);      // Paz/Esperanza
  static const Color redemptionRed = Color(0xFFE57373);  // Ansiedad/Redención
  static const Color strengthAmber = Color(0xFFFFB74D);  // Fuerza/Gloria
  static const Color renewalGreen = Color(0xFF81C784);   // Renovación/Crecimiento
  static const Color wisdomPurple = Color(0xFFBA68C8);  // Sabiduría/Realeza
  static const Color holinessWhite = Color(0xFFF5F5F5); // Limpieza/Santidad
  
  // Colores de la app
  static const Color primary = Color(0xFF6B4EFF);
  static const Color primaryDark = Color(0xFF4A35B2);
  static const Color accent = Color(0xFFFFD93D);
  static const Color background = Color(0xFF1A1A2E);
  static const Color surface = Color(0xFF16213E);
  static const Color cardBackground = Color(0xFF0F3460);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0B0);
  
  // Gradientes
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

/// Mapping de emociones a colores
class EmotionColors {
  static const Map<String, Color> emotions = {
    'peace': AppColors.peaceBlue,
    'redemption': AppColors.redemptionRed,
    'strength': AppColors.strengthAmber,
    'renewal': AppColors.renewalGreen,
    'wisdom': AppColors.wisdomPurple,
    'holiness': AppColors.holinessWhite,
  };
  
  static Color getColor(String emotionKey) {
    return emotions[emotionKey] ?? AppColors.peaceBlue;
  }
}
