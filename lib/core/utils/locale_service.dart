import 'package:flutter/material.dart';

/// Servicio para manejar el idioma de la aplicación
class LocaleService {
  static Locale _currentLocale = const Locale('es');
  
  /// Idioma actual
  static Locale get currentLocale => _currentLocale;
  
  /// Código de idioma actual
  static String get languageCode => _currentLocale.languageCode;
  
  /// Establecer idioma
  static void setLocale(Locale locale) {
    _currentLocale = locale;
  }
  
  /// Lista de idiomas soportados
  static const List<Locale> supportedLocales = [
    Locale('es'),
    Locale('en'),
  ];
  
  /// Verificar si el idioma es soportado
  static bool isSupported(Locale locale) {
    return supportedLocales.any((l) => l.languageCode == locale.languageCode);
  }
}

/// Extension para obtener el Locale desde BuildContext
extension LocaleExtension on BuildContext {
  Locale get locale => Localizations.localeOf(this);
}
