import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Helper para acceder a las localizaciones
class L10n {
  static AppLocalizations of(BuildContext context) {
    return AppLocalizations.of(context)!;
  }
  
  /// Idioma actual del dispositivo
  static Locale getCurrentLocale(BuildContext context) {
    return Localizations.localeOf(context);
  }
  
  /// Verificar si el idioma actual es español
  static bool isSpanish(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'es';
  }
}

/// Extensiones para Widgets
extension LocalizationExtension on BuildContext {
  AppLocalizations get l10n => L10n.of(this);
}
