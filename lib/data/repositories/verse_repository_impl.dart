import '../../domain/entities/verse.dart';
import '../../domain/repositories/verse_repository.dart';
import '../../core/constants/api_constants.dart';
import '../datasources/bible_remote_datasource.dart';

/// Implementación del repositorio de versículos
class VerseRepositoryImpl implements VerseRepository {
  final BibleRemoteDataSource remoteDataSource;
  String _currentLanguage = 'es';
  
  // Cache simple en memoria
  final Map<String, List<Verse>> _emotionCache = {};
  
  VerseRepositoryImpl({required this.remoteDataSource});
  
  /// Establecer idioma actual
  void setLanguage(String languageCode) {
    _currentLanguage = languageCode;
    remoteDataSource.setTranslation(languageCode);
    // Limpiar cache al cambiar idioma
    _emotionCache.clear();
  }
  
  /// Obtener idioma actual
  String get currentLanguage => _currentLanguage;
  
  @override
  Future<Verse> getVerse(String reference) async {
    final model = await remoteDataSource.getVerse(reference);
    return model.toEntity();
  }
  
  @override
  Future<List<Verse>> getVerses(List<String> references) async {
    final refs = references.join(', ');
    final models = await remoteDataSource.getVerses(refs);
    return models.map((m) => m.toEntity()).toList();
  }
  
  @override
  Future<List<Verse>> searchVerses(String query) async {
    final models = await remoteDataSource.searchVerses(query);
    return models.map((m) => m.toEntity()).toList();
  }
  
  @override
  Future<List<Verse>> getVersesForEmotion(String emotionId) async {
    // Verificar cache
    final cacheKey = '${emotionId}_$_currentLanguage';
    if (_emotionCache.containsKey(cacheKey)) {
      return _emotionCache[cacheKey]!;
    }
    
    // Obtener categorías para la emoción según idioma
    final categories = EmotionCategories.getCategoriesForEmotion(emotionId, _currentLanguage);
    final allVerses = <Verse>[];
    
    for (final category in categories) {
      try {
        final verses = await remoteDataSource.getVersesByCategory(category);
        allVerses.addAll(verses.map((m) => m.toEntity()));
      } catch (e) {
        continue;
      }
    }
    
    // Guardar en cache
    _emotionCache[cacheKey] = allVerses;
    
    return allVerses;
  }
  
  @override
  Future<Verse> getRandomVerseForEmotion(String emotionId) async {
    final verses = await getVersesForEmotion(emotionId);
    
    if (verses.isEmpty) {
      // Fallback según idioma
      final fallbackRef = _currentLanguage == 'en' ? 'psalms 23:1' : 'salmos 23:1';
      return await getVerse(fallbackRef);
    }
    
    verses.shuffle();
    return verses.first;
  }
}
