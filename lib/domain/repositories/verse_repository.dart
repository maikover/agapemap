import '../../domain/entities/verse.dart';

/// Interfaz del repositorio de versículos
abstract class VerseRepository {
  /// Obtener un versículo por referencia
  Future<Verse> getVerse(String reference);
  
  /// Obtener múltiples versículos
  Future<List<Verse>> getVerses(List<String> references);
  
  /// Buscar versículos por palabra clave
  Future<List<Verse>> searchVerses(String query);
  
  /// Obtener versículos para una emoción específica
  Future<List<Verse>> getVersesForEmotion(String emotionId);
  
  /// Obtener un versículo aleatorio para una emoción
  Future<Verse> getRandomVerseForEmotion(String emotionId);
}
