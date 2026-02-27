/// Traducciones bíblicas disponibles
class BibleTranslations {
  static const Map<String, String> translations = {
    'es': 'nvi',    // Nueva Versión Internacional (Español)
    'en': 'kjv',    // King James Version (Inglés)
  };
  
  static String getTranslation(String languageCode) {
    return translations[languageCode] ?? translations['es']!;
  }
  
  static String getTranslationName(String translationCode) {
    final names = {
      'nvi': 'Nueva Versión Internacional',
      'kjv': 'King James Version',
    };
    return names[translationCode] ?? translationCode;
  }
}

/// Endpoints y URLs de la API
class ApiConstants {
  // Free Use Bible API (sin API key necesaria)
  static const String bibleApiBaseUrl = 'https://bible-api.com';
  
  // Endpoints
  static const String verse = '/verse';
  static const String verses = '/verses';
  static const String books = '/books';
  static const String search = '/search';
}

/// Categorías bíblicas por emoción
class EmotionCategories {
  // Español
  static const Map<String, List<String>> emotionToCategoriesEs = {
    'peace': ['salmos', 'isaias', 'mateo', 'filipenses'],
    'redemption': ['mateo', 'romanos', '2corintios', 'galatas'],
    'strength': ['josue', 'salmos', 'efesios', 'hebreos'],
    'renewal': ['2corintios', 'romanos', 'ezequiel', 'salmos'],
    'wisdom': ['proverbios', 'salmos', '1reyes', 'sabiduria'],
    'holiness': ['hebreos', '1juan', '1pedro', 'salmos'],
  };
  
  // Inglés
  static const Map<String, List<String>> emotionToCategoriesEn = {
    'peace': ['psalms', 'isaiah', 'matthew', 'philippians'],
    'redemption': ['matthew', 'romans', '2corinthians', 'galatians'],
    'strength': ['joshua', 'psalms', 'ephesians', 'hebrews'],
    'renewal': ['2corinthians', 'romans', 'ezekiel', 'psalms'],
    'wisdom': ['proverbs', 'psalms', '1kings', 'wisdom'],
    'holiness': ['hebrews', '1john', '1peter', 'psalms'],
  };
  
  static List<String> getCategoriesForEmotion(String emotion, String languageCode) {
    if (languageCode == 'en') {
      return emotionToCategoriesEn[emotion] ?? emotionToCategoriesEn['peace']!;
    }
    return emotionToCategoriesEs[emotion] ?? emotionToCategoriesEs['peace']!;
  }
}
